//
//  NetworkService.swift
//  Sunrize
//
//  Created by Daenim on 9/11/18.
//  Copyright © 2018 test. All rights reserved.
//

import Alamofire
import PromiseKit

class NetworkService {
    static let shared = NetworkService()
    
    static let baseUrl = "https://api.sunrise-sunset.org/json"
    
    static let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
    
    func getInfoAt(latitide: Double, longitude: Double, date: Date? = nil) -> Promise<SunrizeData>
    {
        var params = Parameters()
        params["lat"] = latitide
        params["lng"] = longitude
        params["date"] = date
        params["formatted"] = 0
        
        return request(NetworkService.baseUrl, method: .get, parameters: params, encoding: URLEncoding.default)
            .responseDecodable(SunrizeData.self, decoder: NetworkService.decoder)
    }
}


