import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.BluetoothLowEnergy as Ble;

class widgetApp extends Application.AppBase {

    var bleDataSrc = null;

    function initialize() {
        AppBase.initialize();
        bleDataSrc = new BTHomeBarrel.BTHomeTemperatureDelegate();
        Ble.setDelegate(bleDataSrc);
    }

    function onStart(state as Dictionary?) as Void {
        Ble.setScanState(Ble.SCAN_STATE_SCANNING);
    }

    function onStop(state as Dictionary?) as Void {
        Ble.setScanState(Ble.SCAN_STATE_OFF);
        System.println("temp: " + bleDataSrc.temperature);
        System.println("humid: " + bleDataSrc.humidity);
        System.println("batt: " + bleDataSrc.battery);
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new widgetView();
        view.bind(bleDataSrc);
        return [ view ];
    }

    function getGlanceView() {
        var glanceView = new widgetGlanceView();
        glanceView.bind(bleDataSrc);
        return [ glanceView ];
    }
}

function getApp() as widgetApp {
    return Application.getApp() as widgetApp;
}