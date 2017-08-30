import UIKit

var key: Void?

class UITextFieldAdditions: NSObject {
    var paste: Bool = false
}

extension UITextField {
    @IBInspectable var BBB_paste: Bool {
        get {
            return self.additions.paste
        } set {
            self.additions.paste = newValue
        }
    }
    
    var additions: UITextFieldAdditions {
        let additions = objc_getAssociatedObject(self, &key) as? UITextFieldAdditions
        guard let value = additions else {
            let additions = UITextFieldAdditions()
            objc_setAssociatedObject(self, &key, additions, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            
            return additions
        }
        return value
    }
    
    open override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        if ((action == #selector(UIResponderStandardEditActions.paste(_:)) || (action == #selector(UIResponderStandardEditActions.cut(_:)))) && self.BBB_paste) {
            return nil
        }
        return super.target(forAction: action, withSender: sender)
    }
    
}
