//
//  Haircutter.swift
//  JoliCut
//
//  Created by Quentin LE GAL on 21/04/16.
//  Copyright © 2016 Vinod AROUMOUGAME. All rights reserved.
//

import UIKit

class Haircutter {
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
    }
    
}