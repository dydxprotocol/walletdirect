//
//  WalletDirectProtocolRequest.swift
//  WalletDirect
//
//  Created by Qiang Huang on 12/8/21.
//

import Foundation

public class WalletDirectProtocolRequest: DictionaryData {
    public var chainId: String? {
        get {
            return value(path: "chainId") as? String
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
    
    public var methods: [WalletDirectMethod]?
    
    override public init(data: [String: Any]? = nil) {
        super.init(data: data)
        if let methodsData = data?["methods"] as? [[String: Any]] {
            var methods = [WalletDirectMethod]()
            for methodData in methodsData {
                let method = WalletDirectMethod(data: methodData)
                methods.append(method)
            }
            self.methods = methods
        }
    }
    
    public func payload() -> [String: Any] {
        var payload = data
        if let methods = methods {
            var data = [[String: Any]]()
            for method in methods {
                data.append(method.data)
            }
            payload["methods"] = data
        } else {
            payload["methods"] = nil
        }
        return payload
    }
}
