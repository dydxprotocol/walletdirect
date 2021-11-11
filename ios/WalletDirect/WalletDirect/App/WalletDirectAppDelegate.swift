//
//  WalletDirectAppDelegate.swift
//  WalletDirect
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation
import UIKit

open class WalletDirectAppDelegate: UIResponder, UIApplicationDelegate {
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        WalletDirectManager.shared?.receive(deeplink: userActivity.webpageURL?.absoluteString)
        return true
    }

    open func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        WalletDirectManager.shared?.receive(deeplink: url.absoluteString)
        return true
    }

    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        WalletDirectManager.shared?.receive(deeplink: url.absoluteString)
        return true
    }
}
