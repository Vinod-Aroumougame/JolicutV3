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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ProfilImage.contentMode = .ScaleAspectFit
            ProfilImage.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
