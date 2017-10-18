//
//  BaseVC.swift
//  GoodCards
//
//  Created by volodymyrkhmil on 10/27/16.
//  Copyright © 2016 GoodCards. All rights reserved.
//

class BaseVC<T>:  UIViewController where T: UIView {
    
    //MARK: Public.Property
    
    var outerView: T {
        get {
            return self.la_outerView as! T
        }
        set(newValue) {
            self.la_outerView = newValue
        }
    }
    
    //MARK: Life Cycle
    
    override func loadView() {
        super.loadView()
        self.outerView = T()
        self.addBaseView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBaseNavigation()
    }
    
    //MARK: Public.Methods
    
    func showAlertError(_ error: LAError) {
        let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Private.Methods
    
    //TODO: create single code manager
    private func setupBaseNavigation() {
        if !self.navigationItem.hidesBackButton {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
    private func addBaseView() {
        let view: UIView  = UIView()
        view.backgroundColor = .green
        
        self.view.insertSubview(view, at: 0)
        self.view.addConstraints(UIView.place(view, onOtherView: self.view))
    }
    
}
