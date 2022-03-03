//
//  AppDelegate.swift
//  Demo
//
//  Created by Oliver Epper on 03.03.22.
//

import Foundation
import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.button?.title = ProcessInfo.processInfo.processName

        let menu = NSMenu()
        statusBarItem.menu = menu

        menu.addItem(withTitle: "Quit", action: #selector(quit), keyEquivalent: "")
    }

    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }
}
