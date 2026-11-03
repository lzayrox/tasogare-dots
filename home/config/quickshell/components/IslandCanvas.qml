pragma ComponentBehavior: Bound

import QtQuick
import qs
import "../services"

Canvas {
    id: root

    property real bodyWidth: 0
    property real bodyHeight: 0
    property real radiusBottomLeft: 0
    property real radiusBottomRight: 0
    property real filletLeftX: 0
    property real filletRightX: 0
    property real filletY: 0
    property bool isBottomAttached: false
    property color fillColor: Qt.alpha(Theme.background, Config.bar.surfaceAlpha)

    x: -root.filletLeftX
    width: root.bodyWidth + root.filletLeftX + root.filletRightX
    height: root.bodyHeight
    renderTarget: Canvas.FramebufferObject
    renderStrategy: Canvas.Immediate
    antialiasing: true

    onFillColorChanged: requestPaint()
    onBodyWidthChanged: requestPaint()
    onBodyHeightChanged: requestPaint()
    onRadiusBottomLeftChanged: requestPaint()
    onRadiusBottomRightChanged: requestPaint()
    onFilletLeftXChanged: requestPaint()
    onFilletRightXChanged: requestPaint()
    onFilletYChanged: requestPaint()
    onIsBottomAttachedChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d");
        ctx.reset();
        const w = root.bodyWidth;
        const h = root.bodyHeight;
        const flx = Math.max(0, root.filletLeftX);
        const frx = Math.max(0, root.filletRightX);
        const fy = Math.max(0, root.filletY);
        const rBL = Math.max(0, root.radiusBottomLeft);
        const rBR = Math.max(0, root.radiusBottomRight);

        if (w <= 0 || h <= 0)
            return;

        ctx.fillStyle = root.fillColor;
        ctx.beginPath();

        if (!root.isBottomAttached) {
            const sumL = rBL + fy;
            const scaleL = (sumL > h && sumL > 0) ? (h / sumL) : 1.0;
            const effRL = rBL * scaleL;
            const effFyL = fy * scaleL;
            const effFlx = flx > 0 ? (flx * (effFyL / Math.max(0.1, fy))) : 0;

            const sumR = rBR + fy;
            const scaleR = (sumR > h && sumR > 0) ? (h / sumR) : 1.0;
            const effRR = rBR * scaleR;
            const effFyR = fy * scaleR;
            const effFrx = frx > 0 ? (frx * (effFyR / Math.max(0.1, fy))) : 0;

            const sumRadius = effRL + effRR;
            const scaleW = (sumRadius > w && sumRadius > 0) ? (w / sumRadius) : 1.0;
            const finalRL = effRL * scaleW;
            const finalRR = effRR * scaleW;

            ctx.moveTo(flx - effFlx, 0);

            if (effFlx > 0.05 && effFyL > 0.05)
                ctx.bezierCurveTo(flx - effFlx * 0.448, 0, flx, effFyL * 0.448, flx, effFyL);
            else {
                ctx.lineTo(flx, 0);
                ctx.lineTo(flx, effFyL);
            }

            if (h - finalRL > effFyL)
                ctx.lineTo(flx, h - finalRL);

            if (finalRL > 0.2)
                ctx.arc(flx + finalRL, h - finalRL, finalRL, Math.PI, 0.5 * Math.PI, true);
            else
                ctx.lineTo(flx, h);

            ctx.lineTo(flx + w - finalRR, h);

            if (finalRR > 0.2)
                ctx.arc(flx + w - finalRR, h - finalRR, finalRR, 0.5 * Math.PI, 0, true);
            else
                ctx.lineTo(flx + w, h);

            if (h - finalRR > effFyR)
                ctx.lineTo(flx + w, effFyR);

            if (effFrx > 0.05 && effFyR > 0.05)
                ctx.bezierCurveTo(flx + w, effFyR * 0.448, flx + w + effFrx * 0.448, 0, flx + w + effFrx, 0);
            else
                ctx.lineTo(flx + w, 0);

            ctx.lineTo(flx - effFlx, 0);
        } else {
            const sumL = rBL + fy;
            const scaleL = (sumL > h && sumL > 0) ? (h / sumL) : 1.0;
            const effRL = rBL * scaleL;
            const effFyL = fy * scaleL;
            const effFlx = flx > 0 ? (flx * (effFyL / Math.max(0.1, fy))) : 0;

            const sumR = rBR + fy;
            const scaleR = (sumR > h && sumR > 0) ? (h / sumR) : 1.0;
            const effRR = rBR * scaleR;
            const effFyR = fy * scaleR;
            const effFrx = frx > 0 ? (frx * (effFyR / Math.max(0.1, fy))) : 0;

            const sumRadius = effRL + effRR;
            const scaleW = (sumRadius > w && sumRadius > 0) ? (w / sumRadius) : 1.0;
            const finalRL = effRL * scaleW;
            const finalRR = effRR * scaleW;

            ctx.moveTo(flx - effFlx, h);

            if (effFlx > 0.05 && effFyL > 0.05)
                ctx.bezierCurveTo(flx - effFlx * 0.448, h, flx, h - effFyL * 0.448, flx, h - effFyL);
            else {
                ctx.lineTo(flx, h);
                ctx.lineTo(flx, h - effFyL);
            }

            if (h - effFyL > finalRL)
                ctx.lineTo(flx, finalRL);

            if (finalRL > 0.2)
                ctx.arc(flx + finalRL, finalRL, finalRL, Math.PI, 1.5 * Math.PI, false);
            else
                ctx.lineTo(flx, 0);

            ctx.lineTo(flx + w - finalRR, 0);

            if (finalRR > 0.2)
                ctx.arc(flx + w - finalRR, finalRR, finalRR, 1.5 * Math.PI, 2.0 * Math.PI, false);
            else
                ctx.lineTo(flx + w, 0);

            if (h - effFyR > finalRR)
                ctx.lineTo(flx + w, h - effFyR);

            if (effFrx > 0.05 && effFyR > 0.05)
                ctx.bezierCurveTo(flx + w, h - effFyR * 0.448, flx + w + effFrx * 0.448, h, flx + w + effFrx, h);
            else
                ctx.lineTo(flx + w, h);

            ctx.lineTo(flx - effFlx, h);
        }

        ctx.closePath();
        ctx.fill();
    }
}
