import Toybox.Graphics;
import Toybox.WatchUi;

class widgetView extends WatchUi.View {

    var dataSrc;

    function initialize() {
        View.initialize();
    }

    function bind(src) {
        dataSrc = src;
    }

    // No MainLayout.xml: we do manual drawing and layout
    function onUpdate(dc as Graphics.Dc) as Void {
        View.onUpdate(dc);

        var width = dc.getWidth();
        var height = dc.getHeight();

        // Clear screen
        dc.clear();

        // Prepare texts
        var label = "Temperature";
        var tempStr = "N/A";

        if (dataSrc != null && dataSrc.temperature != null) {
            // Format temperature with one decimal place
            tempStr = Lang.format("%.1f°C", [dataSrc.temperature]);
        }

        // Use default fonts, no setFont() to avoid linter error
        // Get font heights for vertical positioning
        var labelFont = Graphics.FONT_XTINY;
        var tempFont = Graphics.FONT_LARGE;

        // Calculate vertical positions (fixed, for compatibility)
        var labelY = height / 4;
        var tempY = height / 2;

        // Draw label (centered horizontally, fixed Y)
        dc.drawText(width / 2, labelY, labelFont, label, Graphics.TEXT_JUSTIFY_CENTER);

        // Draw temperature below label (centered horizontally, fixed Y)
        dc.drawText(width / 2, tempY, tempFont, tempStr, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function onShow() as Void {
        // Call parent onShow (no invalidate() in widget views)
        View.onShow();
    }
}
