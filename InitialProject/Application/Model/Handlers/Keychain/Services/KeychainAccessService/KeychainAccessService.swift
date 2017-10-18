//
//  KeychainAccessService.swift
//  GoodCards
//
//  Created by volodymyrkhmil on 10/28/16.
//  Copyright © 2016 GoodCards. All rights reserved.
//

import KeychainAccess

class KeychainAccessService: KeychainService {
    
    //MARK: KeychainService
    
    func valueForKey(key: String) -> String? {
        return self.keychain[key]
    }
    
    func setValue(value: String?, forKey key: String) {
        self.keychain[key] = value
    }
    
    //MARK: Private.Property
    
    private lazy var service: String = {
        return Bundle.main.bundleIdentifier ?? "co.userfeel"
    }()
    
    private lazy var keychain: Keychain = {
        return Keychain(service: self.service)
    }()
    
}
