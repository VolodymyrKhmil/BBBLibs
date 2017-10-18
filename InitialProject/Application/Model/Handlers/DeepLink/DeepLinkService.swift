import DeepLinkKit

protocol DeepLinkService {
    var pattern: String { get }
    
    func received(link: DPLDeepLink?, controller: UIViewController?)
}

extension DPLDeepLinkRouter: Taskable {
    
    //MARK: Public
    
    func register(service: DeepLinkService) {
        self.register({ (link) in
            self.notify {
                let rootVC = UIApplication.shared.keyWindow?.rootViewController
                
                if let controller = (rootVC as? UINavigationController) {
                    service.received(link: link, controller: controller.viewControllers.last)
                }else {
                    service.received(link: link, controller: rootVC)
                }
            }
        }, forRoute: service.pattern)
    }
}
