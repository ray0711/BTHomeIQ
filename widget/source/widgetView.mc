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

    function onShow() as Void {
        View.onShow();
        // Request a redraw when the widget is shown
        WatchUi.requestUpdate();
    }

    // // Debug code for testing purposes
    // function onUpdate(dc as Graphics.Dc) as Void {
    //     dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    //     dc.clear();
    //     dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    //     dc.drawText(50, 50, Graphics.FONT_SMALL, "TEST", Graphics.TEXT_JUSTIFY_LEFT);
    // }
    
    // No MainLayout.xml: we do manual drawing and layout
    function onUpdate(dc as Graphics.Dc) as Void {
        // View.onUpdate(dc);

        var width = dc.getWidth();
        var height = dc.getHeight();

        // Prepare texts
        var label = "Temperature";
        var tempStr = "N/A";

        if (dataSrc != null && dataSrc.temperature != null) {
            // Format temperature string to two decimals and degree symbol
            tempStr = dataSrc.temperature.format("%0.2f") +" °C";
        }

        // Use default fonts, no setFont() to avoid linter error
        // Get font heights for vertical positioning
        var labelFont = Graphics.FONT_SMALL;
        var tempFont = Graphics.FONT_LARGE;

        // Calculate vertical positions (fixed, for compatibility)
        var labelY = height / 4;
        var tempY = height / 2;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        // Draw label (centered horizontally, fixed Y)
        dc.drawText(width / 2, labelY, labelFont, label, Graphics.TEXT_JUSTIFY_CENTER);

        // Draw temperature below label (centered horizontally, fixed Y)
        dc.drawText(width / 2, tempY, tempFont, tempStr, Graphics.TEXT_JUSTIFY_CENTER);
    }

}