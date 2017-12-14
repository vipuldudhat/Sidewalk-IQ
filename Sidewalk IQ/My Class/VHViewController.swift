//
//  VHViewController.swift
//  Buzzed
//
//  Created by vipul dudhat on 10/1/17.
//  Copyright © 2017 SCC INFOTECH LLP. All rights reserved.
//

import UIKit


  // - - - - - - - - - - - - - - - - - - - - -
 // MARK:- 📍 Extension - UIViewController 📌
// - - - - - - - - - - - - - - - - - - - - -

extension UIViewController {
    
    func goBack() {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
