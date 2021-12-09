//
//  Platform.swift
//  WalletDirect
//
//  Created by Qiang Huang on 12/8/21.
//

import Foundation
import UIKit

public class Platform: DictionaryData {
    public var deeplink: String? {
        return value(path: "deeplink") as? String
    }

    public var universallink: String? {
        return value(path: "universallink") as? String
    }
}

public extension Platform {
    // for wallets
    var protocols: [String: [String]]? {
        return value(path: "protocols") as? [String: [String]]
    }
}
