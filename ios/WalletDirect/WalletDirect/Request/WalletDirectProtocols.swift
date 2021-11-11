//
//  WalletDirectProtocols.swift
//  WalletDirect
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation

public protocol WalletDirectPayloadProtocol where Self: DictionaryData {
    var id: String? { get set }
    func payload() -> [String: Any]
}

extension WalletDirectPayloadProtocol {
    public var id: String? {
        get {
            return value(path: "id") as? String
        }
        set {
            set(value: newValue, path: "id")
        }
    }

    public var chainId: Int? {
        get {
            return value(path: "chainId") as? Int
        }
        set {
            set(value: newValue, path: "chainId")
        }
    }

    public var account: String? {
        get {
            return value(path: "account") as? String
        }
        set {
            set(value: newValue, path: "account")
        }
    }
}
