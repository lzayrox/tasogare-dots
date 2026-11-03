pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property string close: String.fromCodePoint(0xF0156)
    readonly property string controlCenter: String.fromCodePoint(0xF1104)
    readonly property string lightMode: String.fromCodePoint(0xF050E)
    readonly property string darkMode: String.fromCodePoint(0xF0511)
    readonly property string terminal: String.fromCodePoint(0xF0489)
    readonly property string suspend: String.fromCodePoint(0xF0904)
    readonly property string restart: String.fromCodePoint(0xF0453)
    readonly property string power: String.fromCodePoint(0xF0425)

    readonly property string volumeMute: String.fromCodePoint(0xF026)
    readonly property string volumeLow: String.fromCodePoint(0xF027)
    readonly property string volumeMid: String.fromCodePoint(0xEFCF)
    readonly property string volumeHigh: String.fromCodePoint(0xF028)
    readonly property string volumeOff: "\uEEB8"

    readonly property string wifiOff: String.fromCodePoint(0xF05AA)
    readonly property string wifiDisconnected: String.fromCodePoint(0xF092D)

    function wifiStrength(strength) {
        const tier = strength >= 0.75 ? 4 : strength >= 0.5 ? 3 : strength >= 0.25 ? 2 : 1;
        return String.fromCodePoint(0xF091F + (tier - 1) * 3);
    }

    readonly property string mediaPlay: String.fromCodePoint(0xF075A)
    readonly property string mediaPause: String.fromCodePoint(0xF03E4)
    readonly property string mediaPrev: String.fromCodePoint(0xF04AE)
    readonly property string mediaNext: String.fromCodePoint(0xF04AD)
    readonly property string workspaces: String.fromCodePoint(0xF0842)

    readonly property string appTerminal: String.fromCodePoint(0xF0489)
    readonly property string appBrowser: String.fromCodePoint(0xF0239)
    readonly property string appCode: String.fromCodePoint(0xF0A1E)
    readonly property string appDiscord: String.fromCodePoint(0xF066F)
    readonly property string appMusic: String.fromCodePoint(0xF075A)
    readonly property string appSteam: String.fromCodePoint(0xF04D3)
    readonly property string appFiles: String.fromCodePoint(0xF024B)
    readonly property string appDefault: String.fromCodePoint(0xF05B2)

    readonly property string bell: String.fromCodePoint(0xF009A)
    readonly property string bellOff: String.fromCodePoint(0xF009B)
    readonly property string trash: String.fromCodePoint(0xF01B4)

    readonly property string widthArrows: String.fromCodePoint(0x2194)
}
