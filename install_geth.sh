#!/bin/bash
set -e

# Detect architecture
ARCH=$(uname -m)

case "$ARCH" in
    x86_64)
        URL="https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.13.15-c5ba367e.tar.gz"
        ;;
    i386|i686)
        URL="https://gethstore.blob.core.windows.net/builds/geth-linux-386-1.13.15-c5ba367e.tar.gz"
        ;;
    armv7l)
        URL="https://gethstore.blob.core.windows.net/builds/geth-linux-arm7-1.13.15-c5ba367e.tar.gz"
        ;;
    armv6l)
        URL="https://gethstore.blob.core.windows.net/builds/geth-linux-arm6-1.13.15-c5ba367e.tar.gz"
        ;;
    armv5tel)
        URL="https://gethstore.blob.core.windows.net/builds/geth-linux-arm5-1.13.15-c5ba367e.tar.gz"
        ;;
    aarch64)
        URL="https://gethstore.blob.core.windows.net/builds/geth-linux-arm64-1.13.15-c5ba367e.tar.gz"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

echo "Detected architecture: $ARCH"
echo "Downloading Geth from: $URL"

# Create working directory
WORKDIR="$HOME/geth_install"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Download and extract
wget -q --show-progress "$URL" -O geth.tar.gz
tar -xvf geth.tar.gz

# Find extracted directory
EXTRACTED_DIR=$(tar -tzf geth.tar.gz | head -1 | cut -f1 -d"/")

# Rename to 'geth'
rm -rf "$HOME/geth"
mv "$EXTRACTED_DIR" "$HOME/geth"

# Add to PATH if not already added
if ! grep -q 'export PATH="$HOME/geth:$PATH"' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/geth:$PATH"' >> "$HOME/.bashrc"
    echo "Added Geth to PATH in ~/.bashrc"
fi

echo "Installation complete. Run:"
source ~/.bashrc
echo "Then test with: geth version"