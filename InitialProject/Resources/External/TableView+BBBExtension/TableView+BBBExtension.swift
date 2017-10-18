import Foundation
import UIKit

protocol BBB_ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

protocol BBB_NibLoadableView: class {
    static var nibName: String { get }
}

extension BBB_ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension BBB_NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UITableViewCell: BBB_ReusableView {}

extension UITableViewCell : BBB_NibLoadableView {}

extension UITableView {

    func gc_register(reuseIdentifier: String) {
        let bundle = Bundle.main
        let nib = UINib(nibName: reuseIdentifier, bundle: bundle)
        
        self.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func gc_dequeueReusableCell<T: UITableViewCell>(type: T.Type) -> T? where T: BBB_ReusableView {
        let returnCell: UITableViewCell?
        let identifier = type.defaultReuseIdentifier
        if let cell = self.dequeueReusableCell(withIdentifier: identifier) {
            returnCell = cell
        } else {
            self.gc_register(reuseIdentifier: identifier)
            returnCell = self.dequeueReusableCell(withIdentifier: identifier)
        }
        return returnCell as? T
    }
}
