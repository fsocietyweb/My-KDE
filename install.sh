#!/bin/bash

# Farben für eine schöne Terminal-Ausgabe
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # Keine Farbe

echo -e "${YELLOW}=========================================${NC}"
echo -e "${YELLOW}     My KDE Control Center Installer     ${NC}"
echo -e "${YELLOW}=========================================${NC}"
echo ""

# 1. ENGLISCHE WARNUNG BEZÜGLICH DER SPRACHE
echo -e "${RED}[WARNING] Please note:${NC}"
echo -e "This application is currently only available in ${YELLOW}German${NC}."
echo -e "An English and French interface option is prepared in the settings but they don't work At the moment,"
echo -e "but the core documentation texts are hardcoded in German for now."
echo -e "The Application May Have some Bugs so Please Wait till New Version"
echo ""
read -p "Do you want to proceed with the installation? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${RED}Installation aborted by user.${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}[1/4] Checking permissions...${NC}"

# 2. SUDO CHECK (Prüft, ob das Skript als root/sudo läuft)
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[ERROR] Please run this script with sudo!${NC}"
    echo -e "Example: sudo ./install.sh"
    exit 1
fi
echo -e "${GREEN}Root privileges detected.${NC}"

# 3. ABHÄNGIGKEITEN ERKENNEN & INSTALLIEREN
echo ""
echo -e "${GREEN}[2/4] Detecting Linux Distribution & Installing Dependencies...${NC}"

if [ -f /etc/fedora-release ]; then
    echo "Fedora detected."
    dnf install -y cmake extra-cmake-modules gcc-c++ qt6-qtbase-devel qt6-qtdeclarative-devel kf6-kcoreaddons-devel kf6-ki18n-devel kf6-kirigami-devel
elif [ -f /etc/debian_version ] || [ -f /etc/lsb-release ]; then
    echo "Ubuntu/Debian/KDE Neon detected."
    apt update && apt install -y build-essential cmake extra-cmake-modules qt6-base-dev qt6-declarative-dev libkf6coreaddons-dev libkf6i18n-dev qml6-module-org-kde-kirigami
elif [ -f /etc/arch-release ]; then
    echo "Arch Linux detected."
    pacman -Sy --needed --noconfirm base-devel cmake extra-cmake-modules qt6-base qt6-declarative kcoreaddons ki18n kirigami
else
    echo -e "${YELLOW}[WARNING] Unknown distribution. Please ensure Qt6 and KF6 development packages are installed manually.${NC}"
fi

# 4. DOWNLOAD & KOMPILIEREN (INSTALL)
echo ""
echo -e "${GREEN}[3/4] Cloning repository from GitHub...${NC}"

# Erstellt ein temporäres Verzeichnis für den Build und löscht alte Versuche
rm -rf /tmp/mykde_build
mkdir -p /tmp/mykde_build && cd /tmp/mykde_build

# Lädt das gesamte Repository fehlerfrei herunter
git clone https://github.com/fsocietyweb/My-KDE/tree/main/source
cd My-KDE

echo ""
echo -e "${GREEN}Compiling My KDE...${NC}"
mkdir build && cd build
cmake ..
make -j$(nproc)

if [ ! -f "mykde-app" ]; then
    echo -e "${RED}[ERROR] Compilation failed. Please check the errors above.${NC}"
    exit 1
fi

