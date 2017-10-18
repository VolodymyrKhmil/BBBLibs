import UIKit

enum LARouter: Router {
    case main(controller: UIViewController)
    
    //MARK: Private.Nested
    
    private struct LAInitial: Initial {
        
        //MARK: Initial
        
        func initial() -> UIViewController {
            return UIViewController()
        }
    }
    
    //MARK: Public.Property
    
    static var initial: Initial = LAInitial()
    
    //MARK: Private.Property
    
    private var from: UIViewController {
        return UIViewController()
    }
    
    private var to: UIViewController {
        return UIViewController()
    }
    
    private var animated: Bool {
        return true
    }
    
    private var presentType: RoutingData.RoutType {
        return .push
    }
    
    //MARK: Router
    
    func routData() -> RoutingData {
        return RoutingData(from: self.from, to: self.to, animated: self.animated, routingType: self.presentType)
    }
}
