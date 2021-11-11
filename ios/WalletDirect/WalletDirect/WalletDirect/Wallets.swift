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

    private func randomId() -> String {
        return String(Int.random(in: 10000000000000000 ..< 99999999999999999))
    }

    public func send(chainId: Int?, account: String?, rpcMethods: [[String: Any]], registry: Registry, completion: WalletDirectCompletion?) {
        let requestId = randomId()
        let request = WalletDirectRequest(data: [:])
        request.id = requestId
        request.dapp_uuid = dAppId
        request.chainId = chainId
        request.account = account
        var methods = [WalletDirectMethod]()
        for rpcMethod in rpcMethods {
            let method = WalletDirectMethod(data: [:])
            method.id = randomId()
            method.jsonRpc = rpcMethod
            methods.append(method)
        }
        request.methods = methods
        pending[requestId] = request
        send(payload: request, registry: registry, completion: completion)
    }
    
    override internal func payload(json: [String: Any]) -> WalletDirectPayloadProtocol? {
        return WalletDirectResult(data: json)
    }
    
    internal override func receive(payload: WalletDirectPayloadProtocol) {
        if let result = payload as? WalletDirectResult, let requestId = result.id, let request = pending[requestId] as? WalletDirectRequest {
            pending[requestId] = nil
            receiving(result, request)
        }
    }
}
