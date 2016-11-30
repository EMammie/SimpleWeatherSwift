//
//  WXDailyForcast.swift
//  SimpleWeatherSwift
//
//  Created by Mammie, Eugene on 11/17/16.
//  Copyright © 2016 com.Development. All rights reserved.
//

import UIKit

class WXDailyForcast: WXCondition {
    
    
    static func ajsonKeyPathsByPropertyKey() -> [AnyHashable:Any] {
    // 1
    var paths = super.jsonKeyPathsByPropertyKey()    // 2
    paths?["tempHigh"] = "temp.max"
    paths?["tempLow"] = "temp.min"
    // 3
    return paths!
    }

}
