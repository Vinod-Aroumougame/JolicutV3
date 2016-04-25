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
    @IBOutlet weak var TypeOfServiceButton: UISegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if (MapParams.TypeOfService == "coupe") {
            TypeOfServiceButton.selectedSegmentIndex = 0
        }
        else if (MapParams.TypeOfService == "brushing") {
            TypeOfServiceButton.selectedSegmentIndex = 1
        }
        else {
            TypeOfServiceButton.selectedSegmentIndex = 2
        }
            SliderRadius.value = Float(Int(MapParams.SearchRadius)!)
    }
    @IBAction func change(sender: AnyObject) {
        let temp = Int(SliderRadius.value)
        MapParams.TypeOfService = TypeOfServiceButton.titleForSegmentAtIndex(TypeOfServiceButton.selectedSegmentIndex)! as String
        MapParams.SearchRadius = String(format:"%i", temp)
        performSegueWithIdentifier("Change", sender: self)
    }
}