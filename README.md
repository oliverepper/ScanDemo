**Started working with the most recent release of macOS**

This repo demonstrates a problem I have with CoreBluetooth peripheral scanning under Monterey. If your start the Demo app you can observe ongoing scanning via the Console output. This is started from the `.task` modifier (ContentView). You can hit the stop button and start scanning again via the start button.

## 1st Problem
If you enable LSUIElement in the `Info.plist` scanning no longer works.

## 2nd Problem
If you try to start scanning via the included XCPService it does not work, too.

I think this is related to an update to CoreBluetooth that no longer allows to scan for arbitrary peripherals in the background (`scanForPeripherals(withServices: nil, options: nil)`). The problem is that the device I want to scan for does NOT advertise any services.

How can this be fixed?
