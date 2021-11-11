//
//  WalletDirectManager.swift
//  WalletDirect
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation
import UIKit

public enum WalletDirectResultCode {
    case successful
    case idNotFound
    case requestNotFound
    case unexpectedError
    case deeplinkFailure
}

public typealias WalletDirectCompletion = (_ result: WalletDirectResultCode) -> Void
internal typealias WalletDirectReceivingFunction = (_ payload: WalletDirectPayloadProtocol) -> Void

public class WalletDirectManager {
    public static var shared: WalletDirectManager?

    internal var registries: Registries

    internal init(registries: Registries) {
        self.registries = registries
    }

    internal func send(payload: WalletDirectPayloadProtocol, registry: Registry, completion: WalletDirectCompletion?) {
        if let _ = payload.id {
            send(data: payload.payload(), registry: registry, completion: completion)
        } else {
            completion?(.idNotFound)
        }
    }

    public func send(data: [String: Any], registry: Registry, completion: WalletDirectCompletion?) {
        if let json = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
            let base64 = json.base64EncodedString()
            if let url = deeplink(registry: registry, base64: base64) {
                UIApplication.shared.open(url, options: [:]) { successful in
                    completion?(successful ? .successful : .deeplinkFailure)
                }
            } else {
                completion?(.unexpectedError)
            }
        } else {
            completion?(.unexpectedError)
        }
    }

    public func receive(deeplink: String?) {
        if let deeplink = deeplink, let urlComponents = URLComponents(string: deeplink), let base64 = urlComponents.queryItems?.first(where: { $0.name == "data" })?.value, let data = Data(base64Encoded: base64), let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let payload = payload(json: json) {
                receive(payload: payload)
            }
        }
    }

    internal func payload(json: [String: Any]) -> WalletDirectPayloadProtocol? {
        return nil
    }

    internal func receive(payload: WalletDirectPayloadProtocol) {
    }

    internal func deeplink(registry: Registry, base64: String) -> URL? {
        if let deeplink = registry.deeplink {
            let string = "\(deeplink)?data=\(base64)"
            return URL(string: string)
        } else {
            return nil
        }
    }
}
