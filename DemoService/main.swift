//
//  main.m
//  DemoService
//
//  Created by Oliver Epper on 03.03.22.
//

import Foundation

let delegate = DemoServiceDelegate()
let listener = NSXPCListener.service()
listener.delegate = delegate
listener.resume()
