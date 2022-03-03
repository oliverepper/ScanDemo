//
//  DemoServiceProtocol.h
//  DemoService
//
//  Created by Oliver Epper on 03.03.22.
//

import Foundation

@objc public protocol DemoServiceProtocol {
    func connect(withReply reply: @escaping () -> Void)
}
