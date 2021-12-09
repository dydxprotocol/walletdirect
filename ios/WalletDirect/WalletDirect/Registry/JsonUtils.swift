//
//  JsonUtils.swift
//  WalletDirect
//
//  Created by Qiang Huang on 12/8/21.
//

import Foundation

public class JsonUtils {
    public static func load(file: String) -> Any? {
        let bundlePath = Bundle.main.bundlePath
        let bundleUrl = URL(fileURLWithPath: bundlePath)
        let fileUrl = bundleUrl.appendingPathComponent(file)
        if let data = try? Data(contentsOf: fileUrl) {
            return try? JSONSerialization.jsonObject(with: data, options: [])
        } else {
            return nil
        }
    }
}
