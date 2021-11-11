//
//  DAppsRegistries.swift
//  WalletDirect
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation

internal class DAppsRegistries: Registries {
    public init() {
        super.init(file:"dapps.json")
    }
}
