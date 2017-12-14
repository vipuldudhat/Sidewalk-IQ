//
//  CEStoryboardExtension.swift
//  Cookeat
//
//  Created by dev on 23/01/17.
//  Copyright © 2017 Cookeat. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    enum Storyboard : String {
        // Authentication will handle all login views
        case Authenticate
        
        // Main will hold all the dashboard related views
        case Main
        
        // get Storyboard name based on enum 
        var filename : String {
            return rawValue
        }
    }
    
    // convenience initilzer to make initilize method short and concise
    convenience init(storyboard : Storyboard, bundle:Bundle?=nil) {
        self.init(name: storyboard.filename, bundle:bundle)
    }
}
