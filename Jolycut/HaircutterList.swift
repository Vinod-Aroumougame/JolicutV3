//
//  HaircutterList.swift
//  JoliCut
//
//  Created by Quentin LE GAL on 21/04/16.
//  Copyright © 2016 Vinod AROUMOUGAME. All rights reserved.
//

import UIKit

class HaircutterTableViewController: UITableViewController {
    // MARK: Properties
    
    var Users = [Haircutter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the sample data.
        loadSampleMeals()
    }
    
    func loadSampleMeals() {
        var i = 0
        while ( i != MapParams.EachProUser.count-1)
        {
            let USERDATA = MapParams.EachProUser[i].componentsSeparatedByString("\",\"")
            let Name = USERDATA[1].componentsSeparatedByString("\":\"")[1]
            let Kind = USERDATA[3].componentsSeparatedByString("\":\"")[1]
            let photo1 = UIImage(named: "meal1")!
            let Userx = Haircutter(array: MapParams.EachProUser[i] as! NSString, name: Name, kind: Kind, photo: photo1)!
            Users += [Userx]
            i += 1;
        }
    }
    
    @IBAction func ActionButton(sender: AnyObject) {
        print("touched")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "HaircutterTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HaircutterTableViewCell
        let user = Users[indexPath.row]
        cell.nameLabel.text = user.name
        cell.kindLabel.text = user.kind
        cell.photoImageView.image = user.photo
        cell.ugly.text = user.array as String
        return cell
    }
}
