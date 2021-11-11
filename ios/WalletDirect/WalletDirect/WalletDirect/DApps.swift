//
//  DApps.swift
//  WalletDirect
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation

public typealias WalletDirectRequestReceived = (_ requst: WalletDirectRequest, _ registry: Registry) -> Void

// DApp should use this class to send to wallet
public class DApps: WalletDirectManager {
    private var pending: [String: WalletDirectRequest] = [:]
    private var receiving: WalletDirectRequestReceived

    public init(receiving: @escaping WalletDirectRequestReceived) {
        self.receiving = receiving
        super.init(registries: DAppsRegistries())
    }

    public func respond(result: WalletDirectResult, completion: WalletDirectCompletion?) {
        if let id = result.id {
            if let request = pending[id], let dapp_uuid = request.dapp_uuid, let registry = registries.registries[dapp_uuid] {
                pending[id] = nil
                send(payload: result, registry: registry, completion: completion)
            }
        } else {
            completion?(.idNotFound)
        }
    }

    override internal func payload(json: [String: Any]) -> WalletDirectPayloadProtocol? {
        let request = WalletDirectRequest(data: json)
        if let requestId = request.id {
            pending[requestId] = request
            return request
        } else {
            return nil
        }
    }

    internal override func receive(payload: WalletDirectPayloadProtocol) {
        if let request = payload as? WalletDirectRequest, let dapp_uuid = request.dapp_uuid, let registry = registries.registries[dapp_uuid] {
            receiving(request, registry)
        }
    }
}
