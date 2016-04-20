//
//  FirstViewController.swift
//  Jolycut
//
//  Created by Vinod AROUMOUGAME on 13/04/16.
//  Copyright © 2016 Vinod AROUMOUGAME. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var MapView: MKMapView!

    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.MapView.mapType = MKMapType.Standard
        self.MapView.showsUserLocation = true
        
        self.MapView.removeAnnotations(self.MapView.annotations)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let location = self.locationManager.location
        let latitude: Double = location!.coordinate.latitude
        let longitude: Double = location!.coordinate.longitude
        User.Latt = String(format:"%f", latitude)
        User.Long = String(format:"%f", longitude)
        print(latitude)
        print(longitude)
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.MapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        let location2:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 48.853, longitude: 2.348)
        
        var anotation = MKPointAnnotation()
        anotation.coordinate = location2
        anotation.title = "Coiffeur"
        anotation.subtitle = "Localisation d'un Coiffeur"
        MapView.addAnnotation(anotation)
    }
    
    func upload_request()
    {
        let url:NSURL = NSURL(string:"http://92.222.74.85/api/authenticate/"+(User.Email as String)+"/"+(User.Password as String))!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
                  let data = "data=Hi".dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print("error")
                    return
                }
                
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(dataString)
            }
        );
        task.resume()
    }
}