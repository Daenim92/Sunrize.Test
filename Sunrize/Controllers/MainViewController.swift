//
//  ViewController.swift
//  Sunrize
//
//  Created by Daenim on 9/11/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import CoreLocation
import PromiseKit
import SVProgressHUD

class MainViewController: UIViewController {
    
    @IBOutlet var dayProgressView: UISlider? //progress view does not have a thumb - as a symbol of sun
    @IBOutlet var sunrizeDetailsView: UITextView?
    var location: (lat: Double, lon: Double)?
    
    // view timeline
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render(nil)
    }
    
    /// actions
    
    @IBAction func refresh() {
        guard let loc = self.location else {
            SVProgressHUD.showError(withStatus: "Please select location")
            return
        }
        
        SVProgressHUD.show(withStatus: "Loading info")
        firstly {
            NetworkService.shared.getInfoAt(latitide: Double(loc.lat),
                                            longitude: Double(loc.lon))
        }.done(on: .main) {
            self.render($0)
        }.ensure {
            SVProgressHUD.dismiss()
        }.catch {
            SVProgressHUD.showError(withStatus: $0.localizedDescription)
        }
    }
    
    func render(_ data: SunrizeData?)
    {
        let current = Date().timeIntervalSinceReferenceDate
        let sunset = data?.results?.sunset.timeIntervalSinceReferenceDate ?? 0
        let sunrize = data?.results?.sunrise.timeIntervalSinceReferenceDate ?? 0.0
        
        dayProgressView?.value = Float(current)
        dayProgressView?.minimumValue = Float(sunrize)
        dayProgressView?.maximumValue = Float(sunset)

        sunrizeDetailsView?.text = data?.results.map {
            let dayInfo =
            [
                "Current location:",
                location.map {
                    "\($0.lat) , \($0.lon)"
                    } ?? "none selected",
                "Current time: \(Formatters.timeCommon.string(from: Date()))",
                "",
                "Day length: \($0.day_length) seconds",
                "Solar noon: \(Formatters.timeCommon.string(from: $0.solar_noon))",
                "",
            ]
            
            let dayTypesInfo =
            [
                ("Common",   $0.sunrise,                   $0.sunset),
                ("Astro",    $0.astronomical_twilight_end, $0.astronomical_twilight_begin),
                ("Civil",    $0.civil_twilight_end,        $0.civil_twilight_begin),
                ("Nautical", $0.nautical_twilight_end,     $0.nautical_twilight_begin),
            ].map {
                "\($0.0) day:\n" +
                "\(Formatters.timeCommon.string(from: $0.1)) - \(Formatters.timeCommon.string(from: $0.2))"
            }
            
            let fullDetails = dayInfo + dayTypesInfo
            
            return fullDetails.flatMap { $0 } .joined(separator: "\n")
        } ?? ""
    }
}

extension MainViewController: LocationReceiverProtocol {
    func receiveLocation(lat: Double, lon: Double)
    {
        location = (lat, lon)
        refresh()
    }
    
    @IBAction func returnLocation(_ segue: UIStoryboardSegue) { }
}

