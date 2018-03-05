//
//  Wallet.swift
//  loopr-ios
//
//  Created by xiaoruby on 2/17/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import Foundation

class AppWallet: Equatable {
    
    final let address: String
    final let name: String
    final let active: Bool
    
    init(address: String, name: String, active: Bool) {
        self.address = address
        self.name = name
        self.active = active
    }
    
    static func == (lhs: AppWallet, rhs: AppWallet) -> Bool {
        return lhs.address == rhs.address
    }

}