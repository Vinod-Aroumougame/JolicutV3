//
//  ProProfileInfoViewController.swift
//  JoliCut
//
//  Created by Quentin LE GAL on 20/04/16.
//  Copyright © 2016 Vinod AROUMOUGAME. All rights reserved.
//

import UIKit
import CoreLocation

class ProProfileInfoViewController: UIViewController {
    
    @IBOutlet var nom: UITextField!
    @IBOutlet var prenom: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var adresse: UITextField!
    @IBOutlet var tel: UITextField!
    @IBOutlet var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nom.text = (User.Lastname as String)
        prenom.text = (User.Firstname as String)
        email.text = (User.Email as String)
        adresse.text = (User.Adress as String)
        tel.text = (User.Telnumb as String)
        password.text = (User.Password as String)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ModifyUserData(sender: AnyObject) {
        if (nom.text != (User.Lastname as String))
        {
            User.Lastname = nom.text!
            let Value = nom.text!.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
            UpdateUser("nom", Value: Value, sender: self)
        }
        if (prenom.text != (User.Firstname as String))
        {
            User.Firstname = prenom.text!
            let Value = prenom.text!.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
            UpdateUser("prenom", Value: Value, sender: self)
        }
        if (email.text != (User.Email as String))
        {
            User.Email = email.text!
            let Value = email.text!.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
            UpdateUser("mail", Value: Value, sender: self)
        }
        if (password.text != (User.Password as String))
        {
            User.Password = password.text!
            let Value = password.text!.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
            UpdateUser("mail", Value: Value, sender: self)
        }
        if (adresse.text != (User.Adress as String))
        {
            User.Adress = adresse.text!
            let Value = adresse.text!.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
            UpdateUser("adresse", Value: Value, sender: self)
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(User.Adress as String, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Error", error)
                }
                if let placemark = placemarks?.first {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    User.Long = String(format:"%f", coordinates.longitude)
                    User.Latt = String(format:"%f", coordinates.latitude)
                }
            })
            UpdateUser("long", Value: User.Long as String, sender: self)
            UpdateUser("latt", Value: User.Latt as String, sender: self)
        }
        if (tel.text != (User.Telnumb as String))
        {
            User.Telnumb = tel.text!
            let Value = tel.text!.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
            UpdateUser("tel", Value: Value, sender: self)
        }
        let myAlert = UIAlertController(title: "Message", message: "Vos données on été modifiés.", preferredStyle: UIAlertControllerStyle.Alert)
        let dismiss = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){(ACTION) in print("Data changed");}
        myAlert.addAction(dismiss)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    @IBAction func Back(sender: AnyObject) {
        performSegueWithIdentifier("Back", sender: self)
    }
    
    /*requete pour updater les données*/
    
    func UpdateUser(Typeof: String, Value: String, sender: AnyObject?) -> Bool {
        MyVariables.ErrorCode = 0
        let url:NSURL = NSURL(string: "http://92.222.74.85/api/update/"+(User.Email as String)+"/"+Typeof+"/"+Value)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let data = "data=Hi".dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler:
            {(data,response,error) in
                if (nil != response as? NSHTTPURLResponse) {
                    let httpResponse = response as? NSHTTPURLResponse
                    MyVariables.ErrorCode = httpResponse!.statusCode
                }
                else {
                    MyVariables.ErrorCode = 404
                }
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print("error")
                    return
                }
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(dataString)
            }
        )
        while (MyVariables.ErrorCode != 200 || MyVariables.ErrorCode != 404)
        {
            task.resume()
            print(MyVariables.data)
            if (MyVariables.ErrorCode == 200)
            {
                MyVariables.ErrorCode = 0
                return true
            }
            else if (MyVariables.ErrorCode == 404)
            {
                MyVariables.ErrorCode = 0
                let myAlert = UIAlertController(title: "Error", message: "Echec des modifications", preferredStyle: UIAlertControllerStyle.Alert)
                let dismiss = UIAlertAction(title: "Return", style: UIAlertActionStyle.Default){(ACTION) in print("Server can't respond !");}
                myAlert.addAction(dismiss)
                self.presentViewController(myAlert, animated: true, completion: nil)
                return false
            }
        }
        return false
    }
    @IBAction func PrintDATA(sender: UIButton) {
        print(User.Latt)
        print(User.Long)
    }
}