//
//  WalletDirectProtocolResponse.swift
//  WalletDirect
//
//  Created by Qiang Huang on 12/8/21.
//

import Foundation

public class WalletDirectProtocolResponse: DictionaryData {
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
    
    public var responses: [WalletDirectResponse]?
    
    override public init(data: [String: Any]? = nil) {
        super.init(data: data)
        if let responsesData = data?["responses"] as? [[String: Any]] {
            var responses = [WalletDirectResponse]()
            for responseData in responsesData {
                let response = WalletDirectResponse(data: responseData)
                responses.append(response)
            }
            self.responses = responses
        }
    }
    
    public func payload() -> [String: Any] {
        var payload = data
        if let responses = responses {
            var data = [[String: Any]]()
            for response in responses {
                data.append(response.data)
            }
            payload["responses"] = data
        } else {
            payload["responses"] = nil
        }
        return payload
    }
}
