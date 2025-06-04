using Toybox.Lang;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.BluetoothLowEnergy as Ble;

class BTHomeTemperatureDelegate extends Ble.BleDelegate {
  const BTHOME_UUID = "0000fcd2-0000-1000-8000-00805f9b34fb";
  var temperature;
  var humidity;
  var battery;

  function initialize() {
    BleDelegate.initialize();
  }

  function onScanResults(scanResults) {
    for (
      var res = scanResults.next() as Ble.ScanResult?;
      res != null;
      res = scanResults.next() as Ble.ScanResult?
    ) {
      var macFilter =
        Toybox.Application.Properties.getValue("macFilter") as Lang.String;
      if (macFilter.length == 17) {
        if (!res.hasAddress(macFilter)) {
          continue;
        }
      }

      var uuid = getMatchingUuid(res.getServiceUuids(), BTHOME_UUID);
      if (uuid != null) {
        System.println("BINGO!");
        var serviceData = res.getServiceData(
          uuid as Toybox.BluetoothLowEnergy.Uuid
        );
        parseBTHomeData(serviceData);
      }
    }
  }

  private function getMatchingUuid(
    iterator,
    serviceUuid
  ) as Toybox.BluetoothLowEnergy.Uuid? {
    for (var uuid = iterator.next(); uuid != null; uuid = iterator.next()) {
      System.println(uuid);
      if (uuid.equals(serviceUuid)) {
        return uuid;
      }
    }
    return null;
  }

  private function parseBTHomeData(serviceData as Lang.ByteArray) {
    if (serviceData[0] != 64) {
      System.println(
        "Unsupported BTHome message. Only BTHome V2, unencrypted, " +
          "regularly triggerd is supported. Supported value: 64 actual: " +
          serviceData[0]
      );
      return;
    }
    var startOffset = 1;
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
    Toybox.WatchUi.requestUpdate();
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
