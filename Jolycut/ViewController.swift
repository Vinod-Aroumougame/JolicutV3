//
//  ViewController.swift
//  Test
//
//  Created by Quentin LE GAL on 13/04/16.
//  Copyright © 2016 Quentin LE GAL. All rights reserved.
//

import UIKit

struct MyVariables {
    static var ErrorCode = 0
    static var data = NSString()
}
struct User  {
    static var bit = NSArray()
    static var elems = NSArray()
    static var ID = NSString()
    static var Lastname = NSString()
    static var Firstname = NSString()
    static var Password = NSString()
    static var Email = NSString()
    static var Paytool = NSString()
    static var Adress = NSString()
    static var Telnumb = NSString()
    static var Picturefull = NSString()
    static var Competences = NSString()
    static var Prix = NSString()
    static var Picture = NSString()
    static var Kind = NSString()
    static var Latt = NSString()
    static var Long = NSString()
    static var Note = NSString()
    static var Dispo = NSString()
    static var SocReason = NSString()
    static var Demand = NSString()
    static var Factures = NSString()
    
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var login: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBAction func Back(sender: AnyObject) {
        performSegueWithIdentifier("BackToMenu", sender: self)
    }
    
    @IBAction func button(sender: AnyObject) {
        CheckUser("toto", sender: self)
        if (User.Kind.isEqualToString("client")) {
            performSegueWithIdentifier("ToClientInterface", sender: self)
        }
        else if (User.Kind.isEqualToString("pro")){
            performSegueWithIdentifier("ToProInterface", sender: self)
        }
    }
    
    func CloseKeyboard() {
            view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let touch: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.CloseKeyboard))
        view.addGestureRecognizer(touch)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CheckUser(identifier: String, sender: AnyObject!) -> Bool {
        let whitespace = NSCharacterSet.whitespaceCharacterSet()
        let range = login.text!.rangeOfCharacterFromSet(whitespace)
        if ( login.text == ("") || password.text == ("") )
        {
            let myAlert = UIAlertController(title: "Error", message: "Can't let empty field !", preferredStyle: UIAlertControllerStyle.Alert)
            let dismiss = UIAlertAction(title: "Return", style: UIAlertActionStyle.Default){(ACTION) in print("Dismissed");}
            myAlert.addAction(dismiss)
            self.presentViewController(myAlert, animated: true, completion: nil)
            return false
        }
        else if (range != nil) {
            let myAlert = UIAlertController(title: "Error", message: "Login can't contain whitespace !", preferredStyle: UIAlertControllerStyle.Alert)
            let dismiss = UIAlertAction(title: "Return", style: UIAlertActionStyle.Default){(ACTION) in print("spacefound");}
            myAlert.addAction(dismiss)
            self.presentViewController(myAlert, animated: true, completion: nil)
            return false
        }
        else
        {
            let url:NSURL = NSURL(string: "http://92.222.74.85/api/authenticate/"+login.text!+"/"+password.text!)!
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            
            let task = session.dataTaskWithRequest(request) {
                (let data, let response, let error) in
                if (nil != response as? NSHTTPURLResponse) {
                    let httpResponse = response as? NSHTTPURLResponse
                    if (httpResponse!.statusCode != 404) {
                        let urlContents = try! NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
                        guard let _:NSString = urlContents else {
                            print("error")
                            return
                        }
                        MyVariables.data = urlContents
                    }
                    MyVariables.ErrorCode = httpResponse!.statusCode
                    print("Fin de recherche http :")
                    guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                        print("error")
                        return
                    }
                }
                else {
                    MyVariables.ErrorCode = 8
                }
            }
            while (MyVariables.ErrorCode != 200 || MyVariables.ErrorCode != 404 || MyVariables.ErrorCode != 8)
            {
                print(MyVariables.ErrorCode)
                task.resume()
                if (MyVariables.ErrorCode == 200)
                {
                    User.elems = MyVariables.data.componentsSeparatedByString("\",\"")
                    User.ID = User.elems[0].componentsSeparatedByString("\":\"")[1]
                    User.Lastname = User.elems[1].componentsSeparatedByString("\":\"")[1]
                    User.Firstname = User.elems[2].componentsSeparatedByString("\":\"")[1]
                    if (User.elems.count == 11)
                    {
                        User.Password = User.elems[3].componentsSeparatedByString("\":\"")[1]
                        User.Email = User.elems[4].componentsSeparatedByString("\":\"")[1]
                        User.Paytool = User.elems[5].componentsSeparatedByString("\":\"")[1]
                        User.Adress = User.elems[6].componentsSeparatedByString("\":\"")[1]
                        User.Telnumb = User.elems[7].componentsSeparatedByString("\":\"")[1]
                        User.Picturefull = User.elems[8].componentsSeparatedByString("\":\"")[1]
                        User.Picture = User.Picturefull.componentsSeparatedByString(",")[1]
                        User.Kind = User.elems[9].componentsSeparatedByString("\":\"")[1]
                        print(User.elems)
                    }
                    else if (User.elems.count != 11)
                    {
                        User.Competences = User.elems[3].componentsSeparatedByString("\":\"")[1]
                        User.Password = User.elems[5].componentsSeparatedByString("\":\"")[1]
                        User.Email = User.elems[4].componentsSeparatedByString("\":\"")[1]
                        User.Prix = User.elems[6].componentsSeparatedByString("\":\"")[1]
                        User.Dispo = User.elems[7].componentsSeparatedByString("\":\"")[1]
                        User.Telnumb = User.elems[8].componentsSeparatedByString("\":\"")[1]
                        User.Picturefull = User.elems[9].componentsSeparatedByString("\":\"")[1]
                        User.Picture = User.Picturefull.componentsSeparatedByString(",")[1]
                        User.Kind = User.elems[10].componentsSeparatedByString("\":\"")[1]
                        User.Note = User.elems[11].componentsSeparatedByString("\":\"")[1]
                        User.SocReason = User.elems[12].componentsSeparatedByString("\":\"")[1]
                        User.Latt = User.elems[13].componentsSeparatedByString("\":\"")[1]
                        User.Long = User.elems[14].componentsSeparatedByString("\":\"")[1]
                        User.Demand = User.elems[15].componentsSeparatedByString("\":\"")[1]
                        print(User.elems)
                    }
                    MyVariables.ErrorCode = 0
                    return true
                }
                else if (MyVariables.ErrorCode == 404)
                {
                    MyVariables.ErrorCode = 0
                    let myAlert = UIAlertController(title: "Error", message: "Incorrect credentials", preferredStyle: UIAlertControllerStyle.Alert)
                    let dismiss = UIAlertAction(title: "Return", style: UIAlertActionStyle.Default){(ACTION) in print("Wrong login");}
                    myAlert.addAction(dismiss)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                    return false
                }
                else if (MyVariables.ErrorCode == 8)
                {
                    MyVariables.ErrorCode = 0
                    let myAlert = UIAlertController(title: "Error", message: "Can't connect to server", preferredStyle: UIAlertControllerStyle.Alert)
                    let dismiss = UIAlertAction(title: "Return", style: UIAlertActionStyle.Default){(ACTION) in print("Server can't respond !");}
                    myAlert.addAction(dismiss)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                    return false
                }
            }
        }
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

