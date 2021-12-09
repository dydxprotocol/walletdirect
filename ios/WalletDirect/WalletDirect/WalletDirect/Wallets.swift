//
//  Wallets.swift
//  WalletDirect
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation

public typealias WalletDirectResultReceived = (_ result: WalletDirectResult, _ request: WalletDirectRequest) -> Void

// DApp should use this class to send to wallet
public class Wallets: WalletDirectManager {
    private var dAppId: String // Calling dApp's ID, to be sent to Wallet
    private var pending: [String: WalletDirectPayloadProtocol] = [:]
    private var receiving: WalletDirectResultReceived

    public init(dAppId: String, receiving: @escaping WalletDirectResultReceived) {
        self.dAppId = dAppId
        self.receiving = receiving
        super.init(registries: WalletsRegistries())
    }

    public func installed() -> [Registry] {
        return registries.installed
    }

    public func send(request: WalletDirectRequest, registry: Registry, completion: WalletDirectCompletion?) {
        if request.id == nil {
            request.id = randomId()
        }
        request.dapp_uuid = dAppId
        pending[request.id!] = request
        send(payload: request, registry: registry, completion: completion)
    }

    override internal func payload(json: [String: Any]) -> WalletDirectPayloadProtocol? {
        return WalletDirectResult(data: json)
    }

    override internal func receive(payload: WalletDirectPayloadProtocol) {
        if let result = payload as? WalletDirectResult, let requestId = result.id, let request = pending[requestId] as? WalletDirectRequest {
            pending[requestId] = nil
            receiving(result, request)
        }
    }
}
