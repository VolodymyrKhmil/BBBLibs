//
//  KeychainService.swift
//  q9elements.mobile
//
//  Created by volodymyrkhmil on 2/23/17.
//  Copyright © 2017 TechMagic. All rights reserved.
//

import Foundation

protocol KeychainService {
    func valueForKey(key: String) -> String?
    func setValue(value: String?, forKey key: String)
}
