//
//  WalletDirectError.swift
//  WalletDirect
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation

public class WalletDirectError: DictionaryData {
    public var id: String? {
        get {
            return value(path: "id") as? String
        }
        set {
            set(value: newValue, path: "id")
        }
    }

    public var message: String? {
        get {
            return value(path: "message") as? String
        }
        set {
            set(value: newValue, path: "message")
        }
    }
}
