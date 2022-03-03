//
//  DemoService.h
//  DemoService
//
//  Created by Oliver Epper on 03.03.22.
//

import Foundation

final class DemoServiceDelegate: NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: DemoServiceProtocol.self)
        newConnection.exportedObject = DemoService()

        newConnection.resume()

        return true
    }
}
