//
//  WalletDirectPayload.swift
//  WalletDirect
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation

public class WalletDirectPayload: DictionaryData {
    public var id: String? {
        get {
            return value(path: "id") as? String
        }
        set {
            set(value: newValue, path: "id")
        }
    }

    public var jsonRpc: [String: Any]? {
        get {
            return value(path: "JSON-RPC") as? [String: Any]
        }
        set {
            set(value: newValue, path: "JSON-RPC")
        }
    }
}
