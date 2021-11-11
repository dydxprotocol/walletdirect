//
//  WalletDirectRequest.swift
//  WalletDirect
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation

public class WalletDirectRequest: DictionaryData, WalletDirectPayloadProtocol {
    public var dapp_uuid: String? {
        get {
            return value(path: "dapp_uuid") as? String
        }
        set {
            set(value: newValue, path: "dapp_uuid")
        }
    }

    public var methods: [WalletDirectMethod]?
    
    public static func from(payload: [String: Any]) -> WalletDirectRequest {
        // this is called by wallet to retrieve payload from dApp's request
        let request = WalletDirectRequest(data: payload)
        if let methodsData = payload["methods"] as? [[String: Any]] {
            var methods = [WalletDirectMethod]()
            for methodData in methodsData {
                methods.append(WalletDirectMethod(data: methodData))
            }
            request.methods = methods
        }
        return request
    }
    
    public func payload() -> [String: Any] {
        // this is called by dApp to generate payload to send to Wallet
        var payload = data
        if let methods = methods {
            var methodsData = [[String: Any]]()
            for method in methods {
                methodsData.append(method.data)
            }
            payload["methods"] = methodsData
        } else {
            payload["methods"] = nil
        }
        return payload
    }
}
