//
//  RawRepresentable+BBBCount.swift
//  Sqord
//
//  Created by volodymyrkhmil on 9/15/16.
//  Copyright © 2016 TechMagic. All rights reserved.
//

import Foundation

extension RawRepresentable {
    static func BBB_count() -> Int {
        var count = 1
        while (withUnsafePointer(&count) { UnsafePointer<Type>($0).memory }).hashValue != 0 {
            count += 1
        }
        return count
    }
}