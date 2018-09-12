//
//  LocationPickerViewController.swift
//  Sunrize
//
//  Created by Daenim on 9/12/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import MapKit
import PromiseKit
import CoreLocation
import SVProgressHUD

protocol LocationReceiverProtocol {
    func receiveLocation(lat: Double, lon: Double)
}

class LocationPickerViewController: UIViewController {

    @IBOutlet var mapView: MKMapView?
    @IBOutlet var pickButton: UIBarButtonItem?
    @IBOutlet var scanButton: UIBarButtonItem?

    let pickAnnotation = MKPointAnnotation()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let receiver as LocationReceiverProtocol:
            receiver.receiveLocation(lat: pickAnnotation.coordinate.latitude,
                                     lon: pickAnnotation.coordinate.longitude)
        default:
            break
        }
    }
    
    @IBAction func pickLocation() {
        self.performSegue(withIdentifier: "return", sender: nil)
    }
    
    @IBAction func requestLocation() {
        scanButton?.isEnabled = false
        firstly {
            CLLocationManager.requestLocation()
        }.compactMap {
            $0.last?.coordinate
        }.done {
            self.useLocation($0)
//            self.performSegue(withIdentifier: "return", sender: nil)
        }.ensure {
            self.scanButton?.isEnabled = true
        }.catch {
            SVProgressHUD.showError(withStatus: $0.localizedDescription)
        }
    }
    
    func useLocation(_ location: CLLocationCoordinate2D) {
        pickAnnotation.coordinate = location
        pickButton?.isEnabled = true
        mapView?.addAnnotation(pickAnnotation)
        mapView?.centerCoordinate = location
    }

    @IBAction func tapMapView(_ sender: UITapGestureRecognizer) {
        guard let coordinate = mapView?.convert(sender.location(in: mapView), toCoordinateFrom: mapView) else
        { return }
        
        useLocation(coordinate)
    }
}

extension LocationPickerViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case let p as MKPointAnnotation where p == pickAnnotation:
            let id = "pick"
            return mapView.dequeueReusableAnnotationView(withIdentifier: id) ??
                MKMarkerAnnotationView(annotation: pickAnnotation, reuseIdentifier: id)
        default:
            return mapView.view(for: annotation)
        }
    }
}
