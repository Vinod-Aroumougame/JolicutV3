//
//  ProfileViewController.swift
//  JoliCut
//
//  Created by Quentin LE GAL on 19/04/16.
//  Copyright © 2016 Vinod AROUMOUGAME. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var ProfilImage: UIImageView!
    let ImageToRecover = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let decodedData = NSData(base64EncodedString: User.Picture as String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedimage = UIImage(data: decodedData!)
        ProfilImage.image = decodedimage! as UIImage
        ImageToRecover.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Quit(sender: AnyObject) {
        performSegueWithIdentifier("Quit", sender: self)
    }
    
    @IBAction func ImageButton(sender: UIButton) {
        ImageToRecover.allowsEditing = false
        ImageToRecover.sourceType = .PhotoLibrary
        
        presentViewController(ImageToRecover, animated: true, completion: nil)
    }
    
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
            print(MyVariables.ErrorCode)
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

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ProfilImage.contentMode = .ScaleAspectFit
            ProfilImage.image = pickedImage
            let imageData = UIImagePNGRepresentation(ProfilImage.image!)
            User.Picture = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        }
        dismissViewControllerAnimated(true, completion: nil)
        UpdateUser("photo", Value: User.Picture as String, sender: self)
    }
}
