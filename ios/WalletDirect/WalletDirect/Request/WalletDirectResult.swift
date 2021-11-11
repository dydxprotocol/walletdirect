//
//  WalletDirectResult.swift
//  WalletDirect
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation

public class WalletDirectResult: DictionaryData, WalletDirectPayloadProtocol {
    public var successful: Bool? {
        get {
            return value(path: "successful") as? Bool
        }
        set {
            set(value: newValue, path: "successful")
        }
    }

    public var responses: [WalletDirectResponse]?
    public var error: WalletDirectError?

    public static func from(payload: [String: Any]) -> WalletDirectResult {
        // this is called by wallet to retrieve payload from dApp's request
        let result = WalletDirectResult(data: payload)
        if let responsesData = payload["responses"] as? [[String: Any]] {
            var responses = [WalletDirectResponse]()
            for responseData in responsesData {
                responses.append(WalletDirectResponse(data: responseData))
            }
            result.responses = responses
        }
        if let errorData = payload["error"] as? [String: Any] {
            result.error = WalletDirectError(data: errorData)
        }
        return result
    }

    public func payload() -> [String: Any] {
        // this is called by dApp to generate payload to send to Wallet
        var payload = data
        if let responses = responses {
            var responsesData = [[String: Any]]()
            for response in responses {
                responsesData.append(response.data)
            }
            payload["responses"] = responsesData
        } else {
            payload["responses"] = nil
        }
        if let error = error {
            payload["error"] = error.data
        } else {
            payload["error"] = nil
        }
        return payload
    }
}
