//
//  Utilities.swift
//  hiragana
//
//  Created by Pongrapee Attasaranya on 2020/02/12.
//  Copyright © 2020 Majorl3oat. All rights reserved.
//

import Foundation
import SystemConfiguration

class Utilities {
    
    static let shared = Utilities()
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
    
    private init() {}
    
    func checkReachable() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
        
        if (isNetworkReachable(with: flags)) {
            if flags.contains(.isWWAN) {
                //available via mobile
                return true
            }
            //available via wifi
            return true
        }
        else if (!isNetworkReachable(with: flags)) {
            //unavailable
            return false
        }
        return true
    }
    
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
}
