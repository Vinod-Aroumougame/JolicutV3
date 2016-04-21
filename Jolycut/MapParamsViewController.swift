//
//  MapParamsViewController.swift
//  JoliCut
//
//  Created by Quentin LE GAL on 21/04/16.
//  Copyright © 2016 Vinod AROUMOUGAME. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapParamsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var SliderRadius: UISlider!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SliderRadius.value = Float(Int(MapParams.SearchRadius)!)
    }
    @IBAction func change(sender: AnyObject) {
        let temp = Int(SliderRadius.value)
        MapParams.SearchRadius = String(format:"%i", temp)
        performSegueWithIdentifier("Change", sender: self)
    }
}