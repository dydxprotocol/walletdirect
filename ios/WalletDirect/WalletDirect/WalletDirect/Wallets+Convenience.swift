//
//  Wallets+Convenience.swift
//  WalletDirect
//
//  Created by Qiang Huang on 12/8/21.
//

import Foundation

public extension Wallets {
    func getAccounts(protocols: [String: String?], registry: Registry, completion: WalletDirectCompletion?) {
        // protocols is a map of protocol: optional chainId, such as ["ethereum":"3"] or ["ethereum": nil]
        let supportedProtocols: [String] = protocols.keys.compactMap { eachProtocol in
            if let chains = registry.native?.protocols?[eachProtocol] {
                if let chainId = protocols[eachProtocol], let chainId = chainId {
                    return chains.contains(chainId) ? eachProtocol : nil
                } else {
                    return eachProtocol
                }
            } else {
                return nil
            }
        }
        if supportedProtocols.count > 0 {
            let request = WalletDirectRequest(data: nil)
            var protocolReqeusts = [String: WalletDirectProtocolRequest]()
            for eachProtocol in supportedProtocols {
                let protocolRequest = WalletDirectProtocolRequest(data: nil)
                if let chainId = protocols[eachProtocol] {
                    protocolRequest.chainId = chainId
                }
                protocolReqeusts[eachProtocol] = WalletDirectProtocolRequest(data: nil)
            }
            request.protocolRequests = protocolReqeusts
            send(request: request, registry: registry, completion: completion)
        } else {
            completion?(.unexpectedError)
        }
    }

    func sign(protocol thisProtocol: String, chainId: String?, account: String?, signings: [[String: Any]], registry: Registry, completion: WalletDirectCompletion?) {
        if registry.native?.protocols?[thisProtocol] != nil {
            let request = WalletDirectRequest(data: nil)
            let protocolRequest = WalletDirectProtocolRequest(data: nil)
            protocolRequest.chainId = chainId
            protocolRequest.account = account
            
            var methods = [WalletDirectMethod]()
            for signing in signings {
                let method = WalletDirectMethod(data: nil)
                method.jsonRpc = signing
                method.id = randomId()
                methods.append(method)
            }
            protocolRequest.methods = methods
            request.protocolRequests = [thisProtocol: protocolRequest]
            send(request: request, registry: registry, completion: completion)
        } else {
            completion?(.unexpectedError)
        }
    }
}
