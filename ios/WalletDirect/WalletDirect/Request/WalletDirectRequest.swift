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

    public var protocolRequests: [String: WalletDirectProtocolRequest]?

    public static func from(payload: [String: Any]) -> WalletDirectRequest {
        // this is called by wallet to retrieve payload from dApp's request
        return WalletDirectRequest(data: payload)
    }
    
    public override init(data: [String : Any]?) {
        super.init(data: data)
        parseProtocols(data: data?["protocols"] as? [String: Any])
    }

    private func parseProtocols(data: [String: Any]?) {
        if let data = data {
            var protocolRequests = [String: WalletDirectProtocolRequest]()
            for (key, value) in data {
                // key is the protocol name
                if let protocolData = value as? [String: Any] {
                    let protocolRequest = WalletDirectProtocolRequest(data: protocolData)
                    protocolRequests[key] = protocolRequest
                }
            }
            self.protocolRequests = protocolRequests
        } else {
            protocolRequests = nil
        }
    }

    public func payload() -> [String: Any] {
        // this is called by dApp to generate payload to send to Wallet
        var payload = data
        if let protocolRequests = protocolRequests {
            var protocolRequestsData = [String: Any]()
            for (key, protocolRequest) in protocolRequests {
                protocolRequestsData[key] = protocolRequest.payload()
            }
            payload["protocols"] = protocolRequestsData
        } else {
            payload["protocols"] = nil
        }
        return payload
    }
}
