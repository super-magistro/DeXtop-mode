#!/bin/bash
# DeXtop Mode: Professional installation script for Desktop Mode via Python GUI wrappers

# Exit on error
set -e

# --- macOS: Homebrew + pipx installation ---
if [ "$(uname -s)" = "Darwin" ]; then
    echo "=========================================="
    echo "      Installing DeXtop Mode (macOS)      "
    echo "=========================================="

    # Homebrew is required for scrcpy, adb and tkinter
    if ! command -v brew > /dev/null 2>&1; then
        for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
            [ -x "$brew_bin" ] && eval "$("$brew_bin" shellenv)" && break
        done
    fi
    if ! command -v brew > /dev/null 2>&1; then
        echo "[0/4] Homebrew not found, installing it (https://brew.sh)..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/tty
        for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
            [ -x "$brew_bin" ] && eval "$("$brew_bin" shellenv)" && break
        done
    fi

    # Homebrew's Python ships without tkinter: install the matching python-tk
    PY_FORMULA=$(brew info --json=v2 python3 | sed -n 's/.*"name": *"\(python@[0-9.]*\)".*/\1/p' | head -1)
    PY_VERSION=${PY_FORMULA#python@}
    PY_BIN="$(brew --prefix)/opt/$PY_FORMULA/bin/python$PY_VERSION"

    echo "[1/4] Installing dependencies (scrcpy, adb, pipx, Python-TK)..."
    brew install scrcpy android-platform-tools pipx "$PY_FORMULA" "python-tk@$PY_VERSION"

    echo "[2/4] Installing DeXtop Mode..."
    if [ -n "${BASH_SOURCE[0]}" ] && [ -f "$(dirname "${BASH_SOURCE[0]}")/pyproject.toml" ]; then
        SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    else
        SOURCE="dextop-mode"
    fi
    pipx install --force --python "$PY_BIN" "$SOURCE"
    pipx ensurepath > /dev/null 2>&1 || true

    echo "[3/4] Creating the application launcher..."
    APP_DIR="$HOME/Applications/DeXtop Mode.app"
    rm -rf "$APP_DIR"
    mkdir -p "$APP_DIR/Contents/MacOS" "$APP_DIR/Contents/Resources"
    cat <<EOF > "$APP_DIR/Contents/MacOS/dextop"
#!/bin/bash
exec "$HOME/.local/bin/dextop" "\$@"
EOF
    chmod +x "$APP_DIR/Contents/MacOS/dextop"
    printf "APPL????" > "$APP_DIR/Contents/PkgInfo"

    # App icon: generate the PNG with DeXtop Mode itself, then convert it to .icns
    ICON_PNG="$HOME/.config/dextop/icon.png"
    DEXTOP_PY="$(pipx environment --value PIPX_LOCAL_VENVS)/dextop-mode/bin/python"
    "$DEXTOP_PY" -c "import dextop; dextop.ensure_app_icon()" > /dev/null 2>&1 || true
    if [ -f "$ICON_PNG" ]; then
        ICONSET="$(mktemp -d)/dextop.iconset"
        mkdir -p "$ICONSET"
        for size in 16 32 128 256 512; do
            sips -z $size $size "$ICON_PNG" --out "$ICONSET/icon_${size}x${size}.png" > /dev/null
            sips -z $((size * 2)) $((size * 2)) "$ICON_PNG" --out "$ICONSET/icon_${size}x${size}@2x.png" > /dev/null
        done
        iconutil -c icns "$ICONSET" -o "$APP_DIR/Contents/Resources/dextop.icns" || true
    fi

    APP_VERSION=$("$DEXTOP_PY" -c "import dextop; print(dextop.__version__)" 2>/dev/null || echo "1.0")
    cat <<EOF > "$APP_DIR/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key><string>DeXtop Mode</string>
    <key>CFBundleDisplayName</key><string>DeXtop Mode</string>
    <key>CFBundleIdentifier</key><string>io.github.super-magistro.dextop</string>
    <key>CFBundleExecutable</key><string>dextop</string>
    <key>CFBundleIconFile</key><string>dextop</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>CFBundleInfoDictionaryVersion</key><string>6.0</string>
    <key>CFBundleShortVersionString</key><string>$APP_VERSION</string>
    <key>CFBundleVersion</key><string>$APP_VERSION</string>
    <key>LSApplicationCategoryType</key><string>public.app-category.utilities</string>
    <key>LSMinimumSystemVersion</key><string>11.0</string>
</dict>
</plist>
EOF
    # Ad-hoc signature so macOS treats the bundle as a regular application
    codesign --force --deep --sign - "$APP_DIR" > /dev/null 2>&1 || true

    # Register the launcher so Spotlight / Launchpad pick it up immediately
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP_DIR" > /dev/null 2>&1 || true
    mdimport "$APP_DIR" > /dev/null 2>&1 || true

    echo "[4/4] Done!"
    echo "=========================================="
    echo "      Installation successful!            "
    echo "=========================================="
    echo "Open 'DeXtop Mode' from Launchpad / Spotlight, or run 'dextop' in a new terminal."
    exit 0
fi

# Dynamically get the repository directory
if [ -n "${BASH_SOURCE[0]}" ] && [ -f "$(dirname "${BASH_SOURCE[0]}")/dextop.py" ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
else
    # Executed via curl/pipe: clone repository locally
    INSTALL_TARGET="$HOME/.local/share/dexify"
    mkdir -p "$HOME/.local/share"
    if [ -d "$INSTALL_TARGET" ]; then
        rm -rf "$INSTALL_TARGET"
    fi
    echo "Cloning DeXtop Mode repository..."
    git clone https://github.com/super-magistro/DeXtop-mode.git "$INSTALL_TARGET"
    DIR="$INSTALL_TARGET"
fi

echo "=========================================="
echo "          Installing DeXtop Mode          "
echo "=========================================="

# Request sudo privileges at the very beginning, BEFORE the spinner
echo "Administrator privileges are required for installation."
# Force sudo to forget any cached password
sudo -k
# Now, it will STRICTLY require the password
sudo -v

# Keep the sudo token active in the background during the entire installation
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- UI SETTINGS ---
# Hide cursor for a cleaner look
tput civis

cleanup() {
    # Restore cursor on exit
    tput cnorm
}
trap cleanup EXIT

# Spinner function to show progress without flooding the terminal
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# --- STEP 1: CLEANUP ---
echo -n "[1/5] Removing old versions... "
(
    sudo snap remove scrcpy > /dev/null 2>&1 || true
    rm -f "$HOME/.local/bin/dexify-run.sh" || true
    rm -f "$HOME/.local/share/applications/mode-dex.desktop" || true
) & spinner $!
echo "Done!"

# --- STEP 2: SYSTEM DEPENDENCIES ---
echo -n "[2/5] Installing dependencies (Scrcpy, ADB, Python-TK)... "
(
    while sudo fuser /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock >/dev/null 2>&1; do sleep 1; done
    sudo apt update > /dev/null 2>&1
    sudo DEBIAN_FRONTEND=noninteractive apt install -y scrcpy ffmpeg adb wget python3-tk python3-pip python3-venv > /dev/null 2>&1
) & spinner $!
echo "Done!"

# --- STEP 3: PYTHON VIRTUAL ENVIRONMENT ---
echo -n "[3/5] Setting up Python virtual environment... "
(
    python3 -m venv "$DIR/venv" > /dev/null 2>&1
    "$DIR/venv/bin/pip" install --upgrade pip > /dev/null 2>&1
    "$DIR/venv/bin/pip" install customtkinter pillow > /dev/null 2>&1
    
    # Pre-generate the app icon
    "$DIR/venv/bin/python" -c "import sys; sys.path.append('$DIR'); import dextop; dextop.ensure_app_icon()" > /dev/null 2>&1
) & spinner $!
echo "Done!"

# --- STEP 4: HIDING ORIGINAL SCRCPY MENUS ---
echo -n "[4/5] Securing system (hiding background scrcpy shortcuts)... "
(
    mkdir -p "$HOME/.local/share/applications"
    
    # Override scrcpy launcher entries locally with NoDisplay to hide them
    cat <<EOF > "$HOME/.local/share/applications/scrcpy.desktop"
[Desktop Entry]
Type=Application
Name=scrcpy
NoDisplay=true
EOF

    cat <<EOF > "$HOME/.local/share/applications/scrcpy-console.desktop"
[Desktop Entry]
Type=Application
Name=scrcpy (console)
NoDisplay=true
EOF
) & spinner $!
echo "Done!"

# --- STEP 5: DEBIAN PACKAGE INSTALLATION ---
echo -n "[5/5] Building & installing native Debian (.deb) package... "
(
    cd "$DIR"
    chmod +x build_deb.sh
    ./build_deb.sh > /dev/null 2>&1
    DEB_FILE=$(ls -t "$DIR"/dextop-mode_*.deb 2>/dev/null | head -1)
    sudo DEBIAN_FRONTEND=noninteractive apt install -y "$DEB_FILE" > /dev/null 2>&1
) & spinner $!
echo "Done!"

echo "=========================================="
echo "      Installation successful!            "
echo "=========================================="
echo "DeXtop Mode (.deb) has been installed to your system."
echo "Search for 'DeXtop Mode' in your application menu or run 'dextop' in your terminal."
