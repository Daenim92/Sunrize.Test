//
//  SunrizeData.swift
//  Sunrize
//
//  Created by Daenim on 9/11/18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation

//{
//    "results":
//    {
//    "sunrise":"7:27:02 AM",
//    "sunset":"5:05:55 PM",
//    "solar_noon":"12:16:28 PM",
//    "day_length":"9:38:53",
//    "civil_twilight_begin":"6:58:14 AM",
//    "civil_twilight_end":"5:34:43 PM",
//    "nautical_twilight_begin":"6:25:47 AM",
//    "nautical_twilight_end":"6:07:10 PM",
//    "astronomical_twilight_begin":"5:54:14 AM",
//    "astronomical_twilight_end":"6:38:43 PM"
//    },
//    "status":"OK"
//}

struct SunrizeData: Decodable {
    
    let results: Results?
    
    struct Results: Decodable {
        let sunrise: Date
        let sunset: Date
        let solar_noon: Date
        let day_length: TimeInterval
        let civil_twilight_begin: Date
        let civil_twilight_end: Date
        let nautical_twilight_begin: Date
        let nautical_twilight_end: Date
        let astronomical_twilight_begin: Date
        let astronomical_twilight_end: Date
    }
    
    let status: Status
    
    enum Status: String, Decodable {

        case OK = "OK"// indicates that no errors occurred;
        case InvalidRequest = "INVALID_REQUEST"// indicates that either lat or lng parameters are missing or invalid;
        case InvalidDate = "INVALID_DATE"// indicates that date parameter is missing or invalid;
        case UnknownError = "UNKNOWN_ERROR"// indicates that the request could not be processed due to a server error. The request may succeed if you try again.
    }
}
