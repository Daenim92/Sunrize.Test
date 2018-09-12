//
//  Formatters.swift
//  Sunrize
//
//  Created by Daenim on 9/12/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class Formatters: UIViewController {

    static let timeIntervalCommon: DateIntervalFormatter = {
        let f = DateIntervalFormatter()
        return f
    }()
    
    static let timeCommon: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .medium
        return f
    }()
    
    static let dateCommon: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .none
        return f
    }()
    
}
