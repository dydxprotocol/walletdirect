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
        let bundlePath = Bundle.main.bundlePath
        let bundleUrl = URL(fileURLWithPath: bundlePath)
        let fileUrl = bundleUrl.appendingPathComponent(file)
        if let data = try? Data(contentsOf: fileUrl) {
            if let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
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
        } else {
            // failed to load registry json
        }
    }
}
