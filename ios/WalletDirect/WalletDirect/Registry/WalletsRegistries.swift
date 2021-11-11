//
//  WalletsWalletDirect.swift
//  WalletDirect
//
//  Created by Qiang Huang on 11/11/21.
//

import Foundation

internal class WalletsRegistries: Registries {
    public init() {
        super.init(file:"wallets.json")
    }
}
