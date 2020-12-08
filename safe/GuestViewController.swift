//
//  GuestViewController.swift
//  safe
//
//  Created by Yifeng Guo on 12/8/20.
//

import Foundation
import UIKit
import Firebase
import SwiftGifOrigin

class GuestViewController: UIViewController{
    
    @IBOutlet var ScanQR: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let URL = "https://media.giphy.com/media/KjWDaVqI6waTtJmEXT/giphy.gif"
        ScanQR.image = UIImage.gif(url: URL)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.performSegue(withIdentifier: "ScanSegue", sender: nil)
            
        }
    }
}
