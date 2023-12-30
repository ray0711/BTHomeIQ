using Toybox.Lang;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.BluetoothLowEnergy as Ble;


class BTHomeTemperatureDelegate extends Ble.BleDelegate {
    var temperature;
    var humidity = 0;
    var battery = 0;
     
     function initialize() {
        BleDelegate.initialize();    
    }

     function onScanResults(scanResults) {
        while (true) {
            var res = scanResults.next() as Ble.ScanResult;
            if(temperature < 4) {
                temperature = 4;
            }
            if (res != null) {      
                if(temperature < 5) {
                    temperature = 5;
                }        
                if(res.hasAddress("a4:c1:38:f5:16:ea")){
                    System.println(res.getRawData());
                    var iterator = res.getServiceUuids();
                    System.println("uuids");
                    for (var data = iterator.next(); data != null; data = iterator.next()) {
                        System.println(data.toString());
                    }
                    System.println("getManufacturerSpecificDataIterator");
                    iterator = res.getManufacturerSpecificDataIterator();
                    for (var data = iterator.next(); data != null; data = iterator.next()) {
                        System.println(data);
                    }
                    iterator = res.getServiceUuids();
                    System.println("uuids->data");
                    for (var data = iterator.next(); data != null; data = iterator.next()) {
                        var serviceData = res.getServiceData(data as Toybox.BluetoothLowEnergy.Uuid);
                        System.println(serviceData);
                        parseBTHomeData(serviceData);
                    }                    

                }
                if(hasService(res.getServiceUuids(), "0000fe95-0000-1000-8000-00805f9b34fb")){
                    System.println("BINGO!");
                    temperature = temperature + 2;
                }                                          
            }
            else {
                break;
            }
        }
    }

        private function hasService(iterator, serviceUuid) {
            for (var uuid = iterator.next(); uuid != null; uuid = iterator.next()) {
                System.println(uuid);
                if (uuid.equals(serviceUuid)) {
                    return true;
                }
            }
            return false;
        }

        private function parseBTHomeData(serviceData as Lang.ByteArray) {
            var startOffset = 1; // first byte with flags ignore for now
            for(var i = startOffset; i < serviceData.size(); i+=1){
                System.println("i: "+ i);
                  if(temperature < 6) {
                    temperature = 6;
                }        
                switch(serviceData[i]){ 
                    case 0: i += 1 ;// ignore package id
                        break;
                    case 1: battery = serviceData.decodeNumber(NUMBER_FORMAT_UINT8, {
                                :offset=>i + 1, 
                                :endianness=>ENDIAN_LITTLE} );
                            i += 1;
                            break;

                    case 69: temperature = serviceData.decodeNumber(NUMBER_FORMAT_SINT16, {
                                :offset=>i + 1, 
                                :endianness=>ENDIAN_LITTLE} ) * 0.1;
                            i += 2;
                            break;
                    case 2: temperature = serviceData.decodeNumber(NUMBER_FORMAT_SINT16, {
                                :offset=>i + 1, 
                                :endianness=>ENDIAN_LITTLE} ) * 0.01;
                            System.println("temp: "+ temperature);
                            i += 2;
                            break;
                    
                    case 3: humidity = serviceData.decodeNumber(NUMBER_FORMAT_UINT16, {
                                :offset=>i + 1, 
                                :endianness=>ENDIAN_LITTLE} ) * 0.01;
                            i += 2;
                            break;
                    case 45: humidity = serviceData.decodeNumber(NUMBER_FORMAT_UINT8, {
                                :offset=>i + 1, 
                                :endianness=>ENDIAN_LITTLE} ) ;
                            i += 1;
                            break;
                    default: System.println("Not implemented type, stopping processing. ObjectType: " + serviceData[i]);
                        continue;

                    }
            }
        }
}
