//
//  WalletDirectResponse.swift
//  WalletDirect
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation

public class WalletDirectResponse: WalletDirectPayload {
    public var successful: Bool? {
        get {
            return value(path: "successful") as? Bool
        }
        set {
            set(value: newValue, path: "successful")
        }
    }
}
