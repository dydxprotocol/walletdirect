//
//  Registries.swift
//
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation

internal class Registries {
    internal var registries: [String: Registry] = [:]

    public var installed: [Registry] = []

    public init(file: String) {
        if let dictionary = JsonUtils.load(file: file) as? [String: Any] {
            for (key, value) in dictionary {
                if let registryDictionary = value as? [String: Any] {
                    let registry = Registry(data: registryDictionary)
                    registries[key] = registry
                    if registry.installed {
                        installed.append(registry)
                    }
                }
            }
        }
    }
}
