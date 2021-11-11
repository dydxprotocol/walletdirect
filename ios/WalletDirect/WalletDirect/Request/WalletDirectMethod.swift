//
//  WalletDirectMethod.swift
//  WalletDirect
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation

public class WalletDirectMethod: WalletDirectPayload {
    public var optional: Bool? {
        get {
            return value(path: "optional") as? Bool
        }
        set {
            set(value: newValue, path: "optional")
        }
    }
}
