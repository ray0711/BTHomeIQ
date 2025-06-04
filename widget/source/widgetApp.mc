import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

using Toybox.BluetoothLowEnergy as Ble;

class widgetApp extends Application.AppBase {

    var bleDataSrc = null;

    function initialize() {
        AppBase.initialize();
        bleDataSrc = new BTHomeTemperatureDelegate();        
        Ble.setDelegate(bleDataSrc);
    }

    function onStart(state as Dictionary?) as Void {
        Ble.setScanState(Ble.SCAN_STATE_SCANNING);
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        Ble.setScanState(Ble.SCAN_STATE_OFF);
        System.println("temp: " + bleDataSrc.temperature);
        System.println("humid: " + bleDataSrc.humidity);
        System.println("batt: " + bleDataSrc.battery);
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new widgetView();
        view.bind(bleDataSrc);
        return [ view ];
    }

}

function getApp() as widgetApp {
    return Application.getApp() as widgetApp;
}