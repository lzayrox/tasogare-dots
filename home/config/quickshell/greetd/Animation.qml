pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    // =========================================================================
    // 1. Enter Animation (Fade-in inicial estilo field: 1400ms OutCubic)
    // =========================================================================
    property Item enterTarget: null

    function playEnter(target) {
        if (!target)
            return;
        enterTarget = target;
        target.opacity = 0.0;
        enterAnim.restart();
    }

    NumberAnimation {
        id: enterAnim
        target: root.enterTarget
        property: "opacity"
        from: 0.0
        to: 1.0
        duration: 1400
        easing.type: Easing.OutCubic
    }

    // =========================================================================
    // 2. Shake Animation (Error de contraseña / credenciales)
    // =========================================================================
    property Item shakeTarget: null
    property Translate _shakeTranslate: Translate {}
    property int shakeDistance: 12
    property int shakeStepDuration: 40

    function playShake(target, distance) {
        if (!target)
            return;
        shakeTarget = target;
        if (distance !== undefined)
            shakeDistance = distance;

        var hasTranslate = false;
        for (var i = 0; i < target.transform.length; ++i) {
            if (target.transform[i] === _shakeTranslate) {
                hasTranslate = true;
                break;
            }
        }
        if (!hasTranslate) {
            target.transform.push(_shakeTranslate);
        }

        shakeAnim.restart();
    }

    SequentialAnimation {
        id: shakeAnim

        NumberAnimation {
            target: root._shakeTranslate
            property: "x"
            from: 0
            to: -root.shakeDistance
            duration: root.shakeStepDuration
        }
        NumberAnimation {
            target: root._shakeTranslate
            property: "x"
            from: -root.shakeDistance
            to: root.shakeDistance
            duration: root.shakeStepDuration
        }
        NumberAnimation {
            target: root._shakeTranslate
            property: "x"
            from: root.shakeDistance
            to: -Math.round(root.shakeDistance * 0.5)
            duration: root.shakeStepDuration
        }
        NumberAnimation {
            target: root._shakeTranslate
            property: "x"
            from: -Math.round(root.shakeDistance * 0.5)
            to: Math.round(root.shakeDistance * 0.5)
            duration: root.shakeStepDuration
        }
        NumberAnimation {
            target: root._shakeTranslate
            property: "x"
            from: Math.round(root.shakeDistance * 0.5)
            to: 0
            duration: root.shakeStepDuration
        }
    }

    // =========================================================================
    // 3. Exit Transition (Al iniciar sesión con éxito)
    // =========================================================================
    property Item exitTarget: null
    property var onExitCallback: null

    function playExit(target, callback) {
        if (!target)
            return;
        exitTarget = target;
        onExitCallback = callback;
        exitAnim.restart();
    }

    ParallelAnimation {
        id: exitAnim

        NumberAnimation {
            target: root.exitTarget
            property: "opacity"
            to: 0.0
            duration: 220
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: root.exitTarget
            property: "scale"
            to: 0.98
            duration: 220
            easing.type: Easing.OutCubic
        }

        onFinished: {
            if (root.onExitCallback) {
                root.onExitCallback();
            }
        }
    }
}
