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

    public var protocolResponses: [String: WalletDirectProtocolResponse]?
    public var error: WalletDirectError?

    public static func from(payload: [String: Any]) -> WalletDirectResult {
        // this is called by wallet to retrieve payload from dApp's request
        return WalletDirectResult(data: payload)
    }

    override public init(data: [String: Any]?) {
        super.init(data: data)
        parseProtocols(data: data?["protocols"] as? [String: Any])
    }

    private func parseProtocols(data: [String: Any]?) {
        if let data = data {
            var protocolResponses = [String: WalletDirectProtocolResponse]()
            for (key, value) in data {
                // key is the protocol name
                if let protocolData = value as? [String: Any] {
                    let protocolRequest = WalletDirectProtocolResponse(data: protocolData)
                    protocolResponses[key] = protocolRequest
                }
            }
            self.protocolResponses = protocolResponses
        } else {
            protocolResponses = nil
        }
    }

    public func payload() -> [String: Any] {
        // this is called by dApp to generate payload to send to Wallet
        var payload = data
        if let protocolResponses = protocolResponses {
            var protocolResponsesData = [String: Any]()
            for (key, protocolResponse) in protocolResponses {
                protocolResponsesData[key] = protocolResponse.payload()
            }
            payload["protocols"] = protocolResponsesData
        } else {
            payload["protocols"] = nil
        }
        return payload
    }
}
