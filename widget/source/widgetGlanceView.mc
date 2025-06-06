import Toybox.Graphics;
import Toybox.WatchUi;

(:glance)
class widgetGlanceView extends WatchUi.GlanceView {

    var dataSrc;

    function initialize() {
        GlanceView.initialize();
    }

    function bind(src) {
        dataSrc = src;
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();

        var tempStr = "N/A";
        if (dataSrc != null && dataSrc.temperature != null) {
            tempStr = dataSrc.temperature.format("%0.1f") + "°C";
        }

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        // Draw temperature centered
        dc.drawText(width / 2, height / 4, Graphics.FONT_LARGE, tempStr, Graphics.TEXT_JUSTIFY_CENTER);
    }
}