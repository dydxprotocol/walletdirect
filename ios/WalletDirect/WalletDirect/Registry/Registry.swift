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

    public var platforms: [String: Platform]?
    public var installed: Bool = false

    public var native: Platform? {
        return platforms?["ios"]
    }
    
    public var deeplink: String? {
        return native?.deeplink
    }
    
    public var link: String? {
        return native?.deeplink ?? native?.universallink
    }
    
    override public init(data: [String: Any]?) {
        super.init(data: data)
        if let platformsData = data?["platforms"] as? [String: Any] {
            var platforms = [String: Platform]()
            for (key, value) in platformsData {
                if let data = value as? [String: Any] {
                    let platform = Platform(data: data)
                    platforms[key] = platform
                }
            }
            self.platforms = platforms
        } else {
            platforms = nil
        }
        checkInstallation()
    }

    internal func checkInstallation() {
        if let deeplink = deeplink, let url = URL(string: deeplink) {
            installed = UIApplication.shared.canOpenURL(url)
        }
    }
}

public extension Registry {
    // For dApp

    var web: Platform? {
        return platforms?["web"]
    }
}
