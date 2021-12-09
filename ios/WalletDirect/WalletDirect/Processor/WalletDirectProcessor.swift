//
//  WalletDirectProcessor.swift
//  WalletDirect
//
//  Created by Qiang Huang on 12/8/21.
//

import Foundation

public typealias WalletDirectMethodProcessing = (_ protocol: String?, _ chainId: String?, _ account: String?, _ method: WalletDirectMethod) -> WalletDirectResponse
public typealias WalletDirectWalletProcessing = (_ protocol: String?, _ chainId: String?, _ account: String?) -> WalletDirectProtocolResponse

public class WalletDirectProcessor {
    public func process(request: WalletDirectRequest, walletProcessing: WalletDirectWalletProcessing, methodProcessing: WalletDirectMethodProcessing) -> WalletDirectResult {
        let result = WalletDirectResult(data: nil)
        result.id = request.id
        if let protocolRequests = request.protocolRequests {
            var protocolResponses = [String: WalletDirectProtocolResponse]()
            for (thisProtocol, protocolRequest) in protocolRequests {
                let protocolResponse = walletProcessing(thisProtocol, protocolRequest.chainId, protocolRequest.account)
                if let methods = protocolRequest.methods {
                    var responses = [WalletDirectResponse]()
                    for method in methods {
                        let response = methodProcessing(thisProtocol, protocolResponse.chainId, protocolResponse.account, method)
                        response.id = method.id
                        responses.append(response)
                    }
                    protocolResponse.responses = responses
                }
                protocolResponses[thisProtocol] = protocolResponse
            }
            result.protocolResponses = protocolResponses
            result.successful = true
        } else {
            result.successful = false
        }
        return result
    }
    
    public init() {
        
    }
}
