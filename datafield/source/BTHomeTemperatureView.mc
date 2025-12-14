import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class BTHomeTemperatureView extends WatchUi.SimpleDataField {
    var dataSrc = null;
    var temperatureField = null;
    var minTemperatureField = null;
    var maxTemperatureField = null;
    var humidityField = null;
    var minHumidityField = null;
    var maxHumidityField = null;

    var minTemperatue = null;
    var maxTemperature = null;
    var minHumidity = null;
    var maxHumidity = null;

    const TEMEPERATURE_FIELD_ID = 0;
    const HUMIDITY_FIELD_ID = 1;
    const MIN_TEMEPERATURE_FIELD_ID = 2;
    const MAX_TEMEPERATURE_FIELD_ID = 3;
    const MIN_HUMIDITY_FIELD_ID = 4;
    const MAX_HUMIDITY_FIELD_ID = 5;

    function initialize() {
        SimpleDataField.initialize();
        label = "Temperature";

        temperatureField = createField(
            "temperature",
            TEMEPERATURE_FIELD_ID,
            FitContributor.DATA_TYPE_FLOAT,
            {:mesgType=>FitContributor.MESG_TYPE_RECORD,
                :units=>"C",
                :nativeNum=>13,
            }
        );
        minTemperatureField = createField(
            "Min Temp",
            MIN_TEMEPERATURE_FIELD_ID,
            FitContributor.DATA_TYPE_FLOAT,
            {:mesgType=>FitContributor.MESG_TYPE_SESSION,
                :units=>"C",
                :nativeNum=>13,
            }
        );
        maxTemperatureField = createField(
            "Max Temp",
            MAX_TEMEPERATURE_FIELD_ID,
            FitContributor.DATA_TYPE_FLOAT,
            {:mesgType=>FitContributor.MESG_TYPE_SESSION,
                :units=>"C",
                :nativeNum=>13,
            }
        );

        humidityField = createField(
            "humidity",
            HUMIDITY_FIELD_ID,
            FitContributor.DATA_TYPE_UINT8,
            {:mesgType=>FitContributor.MESG_TYPE_RECORD,
                :units=>"%",
            }
        );
        minHumidityField = createField(
            "Min Humidity",
            MIN_HUMIDITY_FIELD_ID,
            FitContributor.DATA_TYPE_UINT8,
            {:mesgType=>FitContributor.MESG_TYPE_SESSION,
                :units=>"%",
            }
        );

        maxHumidityField = createField(
            "Max Humidity",
            MAX_HUMIDITY_FIELD_ID,
            FitContributor.DATA_TYPE_UINT8,
            {:mesgType=>FitContributor.MESG_TYPE_SESSION,
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
                
                minHumidity = min(minHumidity, dataSrc.humidity);
                minHumidityField.setData(minHumidity);
                
                maxHumidity = max(maxHumidity, dataSrc.humidity);
                maxHumidityField.setData(maxHumidity);
                
            }
            if(dataSrc.temperature != null){
                temperatureField.setData(dataSrc.temperature);

                minTemperatue = min(minTemperatue, dataSrc.temperature);
                minTemperatureField.setData(minTemperatue);

                maxTemperature = max(maxTemperature, dataSrc.temperature);
                maxTemperatureField.setData(maxTemperature);
            }            
        }
        return dataSrc.temperature;
    }

    function min(a as Numeric or Null, b as Numeric) as Numeric {
        if (a == null) {
            return b;
        }
        return a < b ? a : b;
    }

    function max(a as Numeric or Null, b as Numeric) as Numeric {
        if (a == null) {
            return b;
        }
        return a > b ? a : b;
    }
}