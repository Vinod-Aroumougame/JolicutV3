//
//  HaircutterListViewController.swift
//  JoliCut
//
//  Created by Quentin LE GAL on 20/04/16.
//  Copyright © 2016 Vinod AROUMOUGAME. All rights reserved.
//

import UIKit

class HaircutterListViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var Field: UIImageView!
    @IBOutlet var Name: UILabel!
    @IBOutlet var Details: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Display()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func Display() {
        let USERDATA = MapParams.EachProUser[0].componentsSeparatedByString("\",\"")
        Name.text = USERDATA[1].componentsSeparatedByString("\":\"")[1]
        Details.text = USERDATA[3].componentsSeparatedByString("\":\"")[1]
    }
}
