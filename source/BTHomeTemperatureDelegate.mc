using Toybox.Lang;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.BluetoothLowEnergy as Ble;

class BTHomeTemperatureDelegate extends Ble.BleDelegate {
  var temperature;
  var humidity;
  var battery;

  function initialize() {
    BleDelegate.initialize();
  }

  function onScanResults(scanResults) {
    while (true) {
      var res = scanResults.next() as Ble.ScanResult;
      if (res != null) {
        if (res.hasAddress("a4:c1:38:f5:16:ea")) {
          System.println(res.getRawData());
          var iterator = res.getServiceUuids();
          System.println("uuids");
          for (
            var data = iterator.next();
            data != null;
            data = iterator.next()
          ) {
            System.println(data.toString());
          }
          System.println("getManufacturerSpecificDataIterator");
          iterator = res.getManufacturerSpecificDataIterator();
          for (
            var data = iterator.next();
            data != null;
            data = iterator.next()
          ) {
            System.println(data);
          }
          iterator = res.getServiceUuids();
          System.println("uuids->data");
          for (
            var data = iterator.next();
            data != null;
            data = iterator.next()
          ) {
            var serviceData = res.getServiceData(
              data as Toybox.BluetoothLowEnergy.Uuid
            );
            System.println(serviceData);
            parseBTHomeData(serviceData);
          }
        }
        if (
          hasService(
            res.getServiceUuids(),
            "0000fe95-0000-1000-8000-00805f9b34fb"
          )
        ) {
          System.println("BINGO!");
        }
      } else {
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
    for (
      var i = startOffset;
      i < serviceData.size();
      i += objectIdSizeDict[serviceData[i]] + 1 /* ObjectID size */
    ) {
      System.println("i: " + i);
      switch (serviceData[i]) {
        case 0:
          break;
        case 1:
          battery = serviceData.decodeNumber(NUMBER_FORMAT_UINT8, {
            :offset => i + 1,
            :endianness => ENDIAN_LITTLE,
          });
          break;

        case 69:
          temperature =
            serviceData.decodeNumber(NUMBER_FORMAT_SINT16, {
              :offset => i + 1,
              :endianness => ENDIAN_LITTLE,
            }) * 0.1;
          break;
        case 2:
          temperature =
            serviceData.decodeNumber(NUMBER_FORMAT_SINT16, {
              :offset => i + 1,
              :endianness => ENDIAN_LITTLE,
            }) * 0.01;
          System.println("temp: " + temperature);
          break;

        case 3:
          humidity =
            serviceData.decodeNumber(NUMBER_FORMAT_UINT16, {
              :offset => i + 1,
              :endianness => ENDIAN_LITTLE,
            }) * 0.01;
          break;
        case 45:
          humidity = serviceData.decodeNumber(NUMBER_FORMAT_UINT8, {
            :offset => i + 1,
            :endianness => ENDIAN_LITTLE,
          });
          break;
        default:
          System.println(
            "Not implemented type, ignoring. ObjectType: " + serviceData[i]
          );
          break;
      }
    }
  }

  /*  based on https://github.com/Bluetooth-Devices/bthome-ble/blob/V2/src/bthome_ble/const.py */
  const objectIdSizeDict = {
    0 => 1,
    1 => 1,
    2 => 2,
    3 => 2,
    4 => 3,
    5 => 3,
    6 => 2,
    7 => 2,
    8 => 2,
    9 => 1,
    10 => 3,
    11 => 3,
    12 => 2,
    13 => 2,
    14 => 2,
    15 => 1,
    16 => 1,
    17 => 1,
    18 => 2,
    19 => 2,
    20 => 2,
    21 => 1,
    22 => 1,
    23 => 1,
    24 => 1,
    25 => 1,
    26 => 1,
    27 => 1,
    28 => 1,
    29 => 1,
    30 => 1,
    31 => 1,
    32 => 1,
    33 => 1,
    34 => 1,
    35 => 1,
    36 => 1,
    37 => 1,
    38 => 1,
    39 => 1,
    40 => 1,
    41 => 1,
    42 => 1,
    43 => 1,
    44 => 1,
    45 => 1,
    46 => 1,
    47 => 1,
    58 => 1,
    60 => 2,
    61 => 2,
    62 => 4,
    63 => 2,
    64 => 2,
    65 => 2,
    66 => 3,
    67 => 2,
    68 => 2,
    69 => 2,
    70 => 1,
    71 => 2,
    72 => 2,
    73 => 2,
    74 => 2,
    75 => 3,
    76 => 4,
    77 => 4,
    78 => 4,
    79 => 4,
    80 => 4,
    81 => 2,
    82 => 2,
    83 => 1,
    84 => 1,
  };
}
