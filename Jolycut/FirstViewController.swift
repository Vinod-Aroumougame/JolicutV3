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
        print("removing...")
        let allAnnotations = self.MapView.annotations
        self.MapView.removeAnnotations(allAnnotations)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        if (nil != locationManager.location)
        {
            let location = self.locationManager.location
            let latitude: Double = location!.coordinate.latitude
            let longitude: Double = location!.coordinate.longitude
            User.Latt = String(format:"%f", latitude)
            User.Long = String(format:"%f", longitude)
            print(User.Latt)
            print(User.Long)
            
            let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.MapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
            upload_request()
        }
    }
    
    func addMarkers() {
        var i = 0
        while ( i != MapParams.EachProUser.count-1) {
            let USERDATA = MapParams.EachProUser[i].componentsSeparatedByString("\",\"")
            let lattitude = USERDATA[13].componentsSeparatedByString("\":\"")[1]
            let longitude = USERDATA[14].componentsSeparatedByString("\":\"")[1]
            let Name = USERDATA[1].componentsSeparatedByString("\":\"")[1]
            let Kind = USERDATA[3].componentsSeparatedByString("\":\"")[1]
            let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
            let location2:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(lattitude)!, longitude: Double(longitude)!)
            var annotation1 = MKPointAnnotation()
            annotation1.coordinate = location2
            annotation1.title = Name
            annotation1.subtitle = Kind
            MapView.addAnnotation(annotation1)
            print(annotation1.title)
            i++;
        }
    }
    
    func upload_request()
    {
        print("ICI !")
        print(MapParams.SearchRadius)
        let url:NSURL = NSURL(string:"http://92.222.74.85/api/getPrestataire/"+((User.Latt) as String)+"/"+((User.Long) as String)+"/brushing/"+MapParams.SearchRadius)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let data = "data=Hi".dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler:
            {(data,response,error) in
                if (nil != response as? NSHTTPURLResponse) {
                    let httpResponse = response as? NSHTTPURLResponse
                    if (httpResponse!.statusCode != 404) {
                        let urlContents = try! NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
                        guard let _:NSString = urlContents else {
                            print("error")
                            return
                        }
                        MapParams.Proffesionals = urlContents
                        MapParams.EachProUser = MapParams.Proffesionals.componentsSeparatedByString("]}")
                    }
                    MyVariables.ErrorCode = httpResponse!.statusCode
                    print("Fin de recherche http :")
                    guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                        print("error")
                        return
                    }
                }
                print("1er coiffeur")
                print(MapParams.EachProUser[0])
                print("2eme coiffeur")
                print(MapParams.EachProUser[1])
                print("lenght")
                print(MapParams.EachProUser.count)
                self.addMarkers()
        });
        task.resume()
    }
}