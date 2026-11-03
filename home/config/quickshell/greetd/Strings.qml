pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    property string lang: "en"

    readonly property var translations: ({
            es: {
                title: "Iniciar Sesión",
                usernamePlaceholder: "usuario",
                passwordPlaceholder: "contraseña",
                loginButton: "entrar",
                verifying: "verificando...",
                authSuccess: "iniciando sesión...",
                authFailed: "contraseña incorrecta",
                capsLockWarning: "bloq mayús activado",
                hint: "enter para entrar · esc para borrar",
                session: "hyprland",
                poweroff: "apagar",
                reboot: "reiniciar",
                suspend: "suspender"
            },
            en: {
                title: "Sign In",
                usernamePlaceholder: "username",
                passwordPlaceholder: "password",
                loginButton: "unlock",
                verifying: "verifying...",
                authSuccess: "launching session...",
                authFailed: "wrong password",
                capsLockWarning: "caps lock is on",
                hint: "enter to unlock · esc to clear",
                session: "hyprland",
                poweroff: "power",
                reboot: "reboot",
                suspend: "suspend"
            }
        })

    readonly property var current: translations[lang] || translations["es"]

    function t(key) {
        var dict = translations[lang] || translations["es"];
        return dict[key] !== undefined ? dict[key] : key;
    }
}
