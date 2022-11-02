import UIKit

protocol AlertBuilderProtocol {
    func createAlertController(title: String, message: String) -> UIAlertController
}


class AlertBuilder: AlertBuilderProtocol {
    
    func createAlertController(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        
        return alertController
    }
}
