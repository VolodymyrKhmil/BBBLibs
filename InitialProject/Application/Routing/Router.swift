import ObjectiveC
import UIKit

struct RoutingData {
    
    //MARK: Enums
    
    enum RoutType {
        case present
        case push
        case pop
    }
    
    //MARK: Property
    
    var from: UIViewController!
    var to: UIViewController!
    var animated: Bool = true
    var routingType: RoutType = .push
}

protocol Initial {
    func initial() -> UIViewController
}

protocol Router {
    func routData() -> RoutingData
}

extension UIViewController {
    private static var rout_associated_key: UInt8 = 0
    var routFrom: Rout? {
        get {
            return objc_getAssociatedObject(self, &UIViewController.rout_associated_key) as? Rout
        }
        set(newValue) {
            objc_setAssociatedObject(self, &UIViewController.rout_associated_key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

class Rout {
    
    //MARK: Properties
    
    var data: RoutingData?
    
    //MARK: Initialisers
    
    init(router: Router) {
        self.data = router.routData()
    }
    
    //MARK: Private
    
    private static var inital: UINavigationController? {
        didSet {
            self.inital?.navigationBar.isTranslucent    = false
            self.inital?.navigationBar.tintColor        = .white
            self.inital?.navigationBar.barTintColor     = .green
            
            let titleDict: [String : Any] = [NSForegroundColorAttributeName: UIColor.white]
            self.inital?.navigationBar.titleTextAttributes = titleDict
        }
    }
    
    //MARK: Methods
    
    class func initial(initial: Initial) -> UIViewController {
        self.inital = UINavigationController(rootViewController: initial.initial())
        return self.inital ?? UINavigationController()
    }
    
    class func clearStack(animated: Bool = true) {
        _ = self.inital?.popToRootViewController(animated: animated)
    }
    
    @discardableResult
    func rout(with completion: RoutCompletion? = nil) -> RoutingData? {
        if let routData = self.data {
            routData.to.routFrom = self
            switch routData.routingType {
            case .present:
                routData.from.present(routData.to, animated: routData.animated, completion: completion)
            case .push:
                routData.from.navigationController?.pushViewController(routData.to, animated: routData.animated)
                completion?()
            case .pop:
                _ = routData.from.navigationController?.popToViewController(routData.to, animated: routData.animated)
            }
        }
        
        return self.data
    }
    
    @discardableResult
    func back(with completion: RoutCompletion? = nil) -> RoutingData? {
        if let routData = self.data {
            switch routData.routingType {
            case .present:
                routData.to.dismiss(animated: routData.animated, completion: completion)
            case .push:
                _ = routData.from.navigationController?.popToViewController(routData.from, animated: routData.animated)
                completion?()
            default: break
            }
        }
        let data = self.data
        self.data?.to.routFrom = nil
        return data
    }
    
    //MARK: Typealias
    
    typealias RoutCompletion = () -> Void
}
