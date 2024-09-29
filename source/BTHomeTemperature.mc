import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

using Toybox.BluetoothLowEnergy as Ble;

class BTHomeTemperature extends Application.AppBase {

    var bleDataSrc = null;

    function initialize() {
        AppBase.initialize();
        bleDataSrc = new BTHomeTemperatureDelegate();        
        Ble.setDelegate(bleDataSrc);
    }

    // onStart() is called on application start up
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
    function getInitialView() {
        var view = new BTHomeTemperatureView();
        view.bind(bleDataSrc);
        return [ view ];
    }
}

function getApp() as BTHomeTemperature {
    return Application.getApp() as BTHomeTemperature;
}