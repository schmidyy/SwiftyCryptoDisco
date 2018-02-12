//
//  ConnectionManager.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2018-02-11.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Foundation
import Alamofire

class ConnectionManager {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
