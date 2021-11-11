//
//  DictionaryData.swift
//  WalletDirect
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation

public class DictionaryData {
    internal var data: [String: Any]

    public init(data: [String: Any]) {
        self.data = data
    }

    internal func value(path: String) -> Any? {
        return value(pathComponents: path.components(separatedBy: "/"), data: data)
    }

    internal func value(pathComponents: [String], data: [String: Any]) -> Any? {
        if let first = pathComponents.first {
            if pathComponents.count == 1 {
                // last item
                return data[first]
            } else {
                var rest = pathComponents
                rest.removeFirst()
                if let node = data[first] as? [String: Any] {
                    return value(pathComponents: rest, data: node)
                } else {
                    return nil
                }
            }
        } else {
            return nil
        }
    }

    internal func set(value: Any?, path: String) {
        data = set(value: value, pathComponents: path.components(separatedBy: "/"), data: data)
    }
    
    internal func set(value: Any?, pathComponents: [String], data: [String: Any]) -> [String: Any] {
        if let first = pathComponents.first {
            if pathComponents.count == 1 {
                var modified = data
                modified[first] = value
                return modified
            } else {
                var rest = pathComponents
                rest.removeFirst()
                if let node = data[first] as? [String: Any] {
                    return set(value: value, pathComponents: rest, data: node)
                } else {
                    return data
                }
            }
        } else {
            return data
        }
    }
}
