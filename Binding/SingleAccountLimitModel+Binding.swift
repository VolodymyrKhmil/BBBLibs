//
//  SingleAccountLimitModel+Binding.swift
//  TIDE
//
//  Created by volodymyrkhmil on 10/13/16.
//  Copyright © 2016 Techmagic. All rights reserved.
//

import Foundation

protocol AccountLimitNameView {
    var name: String? { get set }
}

protocol AccountLimitTextView {
    var limitText: String? { get set }
}

extension UILabel: AccountLimitNameView, AccountLimitTextView {
    
    //MARK: AccountLimitNameView
    
    var name: String? {
        get {
            return self.text
        }
        set(newValue) {
            self.text = newValue
        }
    }
    
    //MARK: AccountLimitTextView
    
    var limitText: String? {
        get {
            return self.text
        }
        set(newValue) {
            self.text = newValue
        }
    }
}

extension UITextField: AccountLimitNameView, AccountLimitTextView {
    
    //MARK: AccountLimitNameView
    
    var name: String? {
        get {
            return self.text
        }
        set(newValue) {
            self.text = newValue
        }
    }
    
    //MARK: AccountLimitTextView
    
    var limitText: String? {
        get {
            return self.text
        }
        set(newValue) {
            self.text = newValue
        }
    }
}

protocol AccountLimitBindible: BindableObject {
    var nameView: AccountLimitNameView! { get }
    var limitTextView: AccountLimitTextView! { get }
}

extension AccountLimitBindible {
    
    //MARK: AccountLimitBindible
    
    var nameView: AccountLimitNameView! {
        return nil
    }
    var limitTextView: AccountLimitTextView! {
        return nil
    }
    
    //MARK: BindableObject
    
    func bind(object: Any?) {
        if let object = object as? SingleAccountLimitModel {
            self.bindLimit(object)
        }
    }
    
    //MARK: Private
    
    private func bindLimit(limit: SingleAccountLimitModel?) {
        if let accountLimit = limit  {
            
            if var nameView: AccountLimitNameView = self.nameView {
                nameView.name = accountLimit.name
            }
            if var limitTextView: AccountLimitTextView = self.limitTextView {
                limitTextView.limitText = accountLimit.limits.map { limit in
                    return limit.message
                    }.joinWithSeparator("\n")
            }
        }
    }
}
