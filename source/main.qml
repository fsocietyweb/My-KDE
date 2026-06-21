import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.ApplicationWindow {
    id: root

    title: "My KDE"
    width: 1100
    height: 800

    color: "transparent"

    property string weatherText: "Wird geladen..."
    property string appLanguage: "Deutsch"
    property int pingTime: 0
    property string diskSpaceText: "Klicke zum Berechnen"

    globalDrawer: null

    background: Rectangle {
        color: Kirigami.Theme.backgroundColor
        opacity: 0.88

        border.color: Kirigami.Theme.borderColor
        border.width: 1

        Rectangle {
            anchors.fill: parent
            color: Kirigami.Theme.backgroundColor
            opacity: 0.05
            radius: 2
        }
    }

    header: ToolBar {
        background: Rectangle {
            color: Kirigami.Theme.backgroundColor
            opacity: 0.85
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 6

            Label {
                text: "MY KDE CONTROL ZENTRALE"
                font.pointSize: 11
                font.bold: true
                font.letterSpacing: 1.2
                color: Kirigami.Theme.textColor
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 12
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 8
                spacing: 2

                Button {
                    text: root.appLanguage === "Français" ? "Introduction" : "Einführung"
                    icon.name: "help-welcome"
                    flat: true
                    onClicked: mainStack.currentIndex = 0
                }

                Button {
                    text: "Dashboard"
                    icon.name: "dashboard-show"
                    flat: true

                    onClicked: {
                        mainStack.currentIndex = 1
                        myCore.fetchWeather()
                    }
                }

                Button {
                    text: "System Tuning"
                    icon.name: "preferences-ubuntu-panel"
                    flat: true
                    onClicked: mainStack.currentIndex = 2
                }

                Button {
                    text: "Connect Plus"
                    icon.name: "kdeconnect"
                    flat: true
                    onClicked: mainStack.currentIndex = 3
                }

                Button {
                    text: "Settings"
                    icon.name: "settings-configure"
                    flat: true
                    onClicked: mainStack.currentIndex = 4
                }
            }

            Kirigami.Separator {
                Layout.fillWidth: true
            }
        }
    }

    Connections {
        target: myCore

        function onPingUpdated(ms) {
            root.pingTime = ms
        }
    }

    StackLayout {
        id: mainStack

        anchors.fill: parent
        currentIndex: 0

        // REITER 1

        Kirigami.ScrollablePage {
            background: null

            ColumnLayout {
                spacing: 18
                Layout.margins: 35

                Kirigami.Heading {
                    text: root.appLanguage === "Français"
                    ? "Documentation Système"
                    : "Systemumgebung und Dokumentation"
                    level: 2
                }

                Kirigami.Separator {
                    Layout.fillWidth: true
                }

                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    font.pointSize: 11
                    lineHeight: 1.4

                    text:
                    "Die Steuerungszentrale dient als hochentwickeltes Administrationswerkzeug zur Optimierung, Analyse und Systemüberwachung Ihres KDE Plasma Desktops. Diese Softwarelösung bündelt Kernel-Abfragen, Speicherplatzanalysen im Dolphin-Dateisystem-Standard sowie DBus-Schnittstellen in einer konsistenten, hardwarebeschleunigten Oberfläche. Das Design folgt den strengen UI-Richtlinien der KDE-Breeze-Evolution und verzichtet vollständig auf redundante grafische Elemente.\n\n" +

                    "Architektonische Kernmerkmale dieses Kontrollzentrums:\n" +
                    "• Direkte Prozesskopplung mit dem KWin-Kompositor zur Echtzeitmodifikation globaler Fenstereffekte.\n" +
                    "• Automatisierte Skript-Schnittstellen zur Erkennung verwaister Systembibliotheken und ungenutzter Flatpak-Reste.\n" +
                    "• Asynchrone Netzwerküberwachung mittels nativer Sockets zur Ermittlung exakter Latenzwerte ohne Thread-Blocking.\n" +
                    "• Dynamische Einbindung lokaler Speicherplatzindizes zur Emulation nativer Dateimanager-Funktionen.\n\n" +

                    "Verwenden Sie die obere Navigationsleiste, um die verschiedenen Steuerungsmodule anzusteuern. Alle vom Benutzer vorgenommenen Anpassungen werden unmittelbar in die Konfigurationsdateien Ihres lokalen Benutzerverzeichnisses geschrieben."
                }
            }
        }

        // REITER 2

        Kirigami.ScrollablePage {
            background: null

            ColumnLayout {
                spacing: 20
                Layout.margins: 30

                Kirigami.AbstractCard {
                    Layout.fillWidth: true

                    background: Rectangle {
                        color: Kirigami.Theme.backgroundColor
                        opacity: 0.4
                        border.color: Kirigami.Theme.borderColor
                        radius: 4
                    }

                    contentItem: ColumnLayout {
                        spacing: 12
                        Layout.margins: 16

                        Kirigami.Heading {
                            text: "Umgebungsdaten"
                            level: 3
                        }

                        Label {
                            text: "Lokale Wetterlage: " + root.weatherText
                        }

                        Label {
                            text: "Netzwerklatenz zum Server: "
                            + (root.pingTime > 0
                            ? root.pingTime + " ms"
                            : "Keine aktive Messung")
                        }

                        Label {
                            text: "Protokolltyp: IPv4/IPv6 Dualstack-Betrieb"
                        }

                        Button {
                            text: "Netzwerk-Latenz überprüfen"
                            icon.name: "network-connect"
                            onClicked: myCore.checkPing()
                        }
                    }
                }

                Kirigami.AbstractCard {
                    Layout.fillWidth: true

                    background: Rectangle {
                        color: Kirigami.Theme.backgroundColor
                        opacity: 0.4
                        border.color: Kirigami.Theme.borderColor
                        radius: 4
                    }

                    contentItem: ColumnLayout {
                        spacing: 12
                        Layout.margins: 16

                        Kirigami.Heading {
                            text: "Dateisystem-Analyse (Dolphin Standard)"
                            level: 3
                        }

                        Label {
                            text: "Zustand des Systemlaufwerks: "
                            + root.diskSpaceText
                            font.bold: true
                        }

                        Label {
                            text: "Dateisystemtyp: Ext4/Btrfs Root-Partition"
                        }

                        Button {
                            text: "Speicherbelegung aktualisieren"
                            icon.name: "drive-harddisk"
                            onClicked: {
                                root.diskSpaceText = myCore.getDiskSpace()
                            }
                        }
                    }
                }
            }
        }

        // REITER 3

        Kirigami.ScrollablePage {
            background: null

            ColumnLayout {
                spacing: 20
                Layout.margins: 30

                Kirigami.AbstractCard {
                    Layout.fillWidth: true

                    background: Rectangle {
                        color: Kirigami.Theme.backgroundColor
                        opacity: 0.4
                        border.color: Kirigami.Theme.borderColor
                        radius: 4
                    }

                    contentItem: ColumnLayout {
                        spacing: 15
                        Layout.margins: 16

                        Kirigami.Heading {
                            text: "Bereinigung und Optimierung"
                            level: 3
                        }

                        Label {
                            text: "Säubert verwaiste Flatpak-Laufzeiten und temporäre Paket-Caches dauerhaft aus dem Systemverzeichnis."
                        }

                        RowLayout {
                            spacing: 10

                            Button {
                                text: "Flatpak-Säuberung starten"
                                icon.name: "edit-clear-all"
                                onClicked: myCore.cleanBloatware()
                            }

                            Button {
                                text: "KWin Compositor-Tuning"
                                icon.name: "kwin"
                                onClicked: {
                                    myCore.runCommand(
                                        "kcmshell6",
                                        ["kcm_kwin_effects"]
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }

        // REITER 4

        Kirigami.ScrollablePage {
            background: null

            ColumnLayout {
                spacing: 20
                Layout.margins: 30

                Kirigami.AbstractCard {
                    Layout.fillWidth: true

                    background: Rectangle {
                        color: Kirigami.Theme.backgroundColor
                        opacity: 0.4
                        border.color: Kirigami.Theme.borderColor
                        radius: 4
                    }

                    contentItem: ColumnLayout {
                        spacing: 15
                        Layout.margins: 16

                        Kirigami.Heading {
                            text: "Schnittstellen-Konfiguration"
                            level: 3
                        }

                        Label {
                            text: "Verwaltung gekoppelter Mobilgeräte über verschlüsselte lokale TLS-Verbindungen."
                        }

                        RowLayout {
                            spacing: 10

                            Button {
                                text: "SMS-Zentrale initialisieren"
                                icon.name: "internet-telephony"
                                onClicked: myCore.runCommand("kdeconnect-sms")
                            }

                            Button {
                                text: "Geräteeinstellungen öffnen"
                                icon.name: "kdeconnect"
                                onClicked: {
                                    myCore.runCommand(
                                        "kcmshell6",
                                        ["kcm_kdeconnect"]
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }

        // REITER 5

        Kirigami.ScrollablePage {
            background: null

            ColumnLayout {
                spacing: 20
                Layout.margins: 30

                Kirigami.AbstractCard {
                    Layout.fillWidth: true

                    background: Rectangle {
                        color: Kirigami.Theme.backgroundColor
                        opacity: 0.4
                        border.color: Kirigami.Theme.borderColor
                        radius: 4
                    }

                    contentItem: ColumnLayout {
                        spacing: 15
                        Layout.margins: 16

                        Kirigami.Heading {
                            text: "Globale Applikations-Parameter"
                            level: 3
                        }

                        RowLayout {
                            spacing: 15

                            Label {
                                text: "Lokalisierung (Language Selection):"
                            }

                            ComboBox {
                                model: ["Deutsch", "Français", "English"]

                                onActivated: {
                                    root.appLanguage = currentText
                                }
                            }
                        }

                        Kirigami.Separator {
                            Layout.fillWidth: true
                        }

                        Kirigami.Heading {
                            text: "Erweiterte Engine-Optionen"
                            level: 4
                        }

                        CheckBox {
                            text: "Hardwarebeschleunigtes QML-Rendering erzwingen (OpenGL/Vulkan)"
                            checked: true
                        }

                        CheckBox {
                            text: "Asynchrone Hintergrundüberwachung für Wetter-Dienste aktivieren"
                            checked: false
                        }

                        CheckBox {
                            text: "Benachrichtigungen über DBus-Schnittstelle senden"
                            checked: true
                        }

                        CheckBox {
                            text: "Automatischen Latenz-Ping beim App-Start ausführen"
                            checked: true
                        }

                        RowLayout {
                            spacing: 10

                            Label {
                                text: "Aktualisierungsintervall für Sensordaten:"
                            }

                            SpinBox {
                                from: 1
                                to: 60
                                value: 5
                            }

                            Label {
                                text: "Sekunden"
                            }
                        }
                    }
                }
            }
        }
    }
}
