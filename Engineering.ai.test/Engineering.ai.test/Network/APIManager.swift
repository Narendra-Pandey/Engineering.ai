//
//  APIManager.swift
//  Engineering.ai.test
//
//  Created by PCQ182 on 25/12/19.
//  Copyright © 2019 PCQ182. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireJsonToObjects
import SVProgressHUD

class APIManager{
    
    // MARK: - Variable -
    static var shared: APIManager = {
        let instance = APIManager()
        return instance
    }()
    let session:SessionManager!
    
    // MARK: - Class initiallization -
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 4
        session = Alamofire.SessionManager.init(configuration: configuration)
    }
}

// MARK: - Send Generic API Call -
extension APIManager {
    func sendGenericCall<N:GenericModal>(type:N.Type,router:APIRouter,success:@escaping (_:N)->Void,failure:@escaping (_:Error)->Void) {
        
        if NetworkReachabilityManager()!.isReachable == false {
            SVProgressHUD.dismiss()
            showAlert(messae: ErrorMessage.noInternet.rawValue)
            return
        }
        
        var path = router.path
        if router.method == .get {
            path = router.getWithParam()
        }
        
        session.request(path, method: router.method, parameters: router.parameter, encoding: URLEncoding.default, headers: nil).responseObject { (response: DataResponse<N>) in
             SVProgressHUD.dismiss()
            if response.result.isSuccess {
                success(response.result.value!)
            }else{
                self.showAlert(messae: ErrorMessage.APiError.rawValue)
                failure(response.error!)
            }
        }
    }
    
    private func showAlert(messae:String) {
        let alert = UIAlertController(title: "Error", message: messae, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
