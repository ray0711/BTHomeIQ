import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class BTHomeTemperatureView extends WatchUi.SimpleDataField {
    var dataSrc = null;
    var temperatureField = null;
    var humidityField = null;

    const TEMEPERATURE_FIELD_ID = 0;
    const HUMIDITY_FIELD_ID = 1;

    function initialize() {
        SimpleDataField.initialize();
        label = "Temperature";

        temperatureField = createField(
            "Temperature",
            TEMEPERATURE_FIELD_ID,
            FitContributor.DATA_TYPE_SINT8,
            {:mesgType=>FitContributor.MESG_TYPE_RECORD,
                :units=>"C",
                :nativeNum=>13,
            }
        );    
        humidityField = createField(
            "Humidity",
            HUMIDITY_FIELD_ID,
            FitContributor.DATA_TYPE_UINT8,
            {:mesgType=>FitContributor.MESG_TYPE_RECORD,
                :units=>"%",
            }
        ); 
    }

    function bind(src) {
        dataSrc = src;
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        // See Activity.Info in the documentation for available information.
        if (dataSrc != null) {
            if(dataSrc.humidity != null){
                humidityField.setData(dataSrc.humidity);
            }
            if(dataSrc.temperature != null){
                temperatureField.setData(dataSrc.temperature);
            }            
        }
        return dataSrc.temperature;
    }
}