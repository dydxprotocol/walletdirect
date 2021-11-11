//
//  Registry.swift
//
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation
import UIKit

public class Registry: DictionaryData {
    public var name: String? {
        return value(path: "name") as? String
    }

    public var deeplink: String? {
        return value(path: "deeplink") as? String
    }

    public var shortName: String? {
        return value(path: "metadata/shortName") as? String
    }

    public var imageUrl: String? {
        return value(path: "metadata/imageUrl") as? String
    }

    public var developer: String? {
        return value(path: "metadata/developer") as? String
    }

    public var developerUrl: String? {
        return value(path: "metadata/developerUrl") as? String
    }

    public var installed: Bool = false

    override public init(data: [String: Any]) {
        super.init(data: data)
        checkInstallation()
    }

    internal func checkInstallation() {
        if let deeplink = deeplink, let url = URL(string: deeplink) {
            installed = UIApplication.shared.canOpenURL(url)
        }
    }
}
