//
//  JSONService.swift
//  MasterPlayer
//
//  Created by Glny Gl on 24.10.2018.
//  Copyright © 2018 Glny Gl. All rights reserved.
//

import Foundation
import Alamofire

class JSONServise: NSObject {
    
    static func getJSON(_ index: Int, success:@escaping (UserModel) -> Void, failure: @escaping (String) -> Void)  {
        
        let baseURL = "http://wamp.mobilist.com.tr/challenge/index.php"
        let URL = "\(baseURL)?start=\(index)"
        
        var userModel: UserModel?
        
        Alamofire.request(URL).responseJSON { (response) -> Void in
            if response.result.isFailure {
                print("Error")
            } else {
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let jData = try decoder.decode(UserModel.self, from: data)
                    userModel = jData
                    success(userModel!)
                } catch let err {
                    print("Err", err)
                }
            }
        }
    }
}
