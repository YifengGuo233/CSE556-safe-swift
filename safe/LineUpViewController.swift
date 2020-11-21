//
//  LineUpViewController.swift
//  safe
//
//  Created by Yifeng Guo on 11/21/20.
//

import Foundation
import UIKit
import Firebase
class LineUpViewController: UIViewController{
   
    @IBAction func cancelButtonClick(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey:"Code")
        self.performSegue(withIdentifier: "doneOrCancelSegue", sender: nil)
    }
    
    @IBAction func doneButtonClick(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey:"Code")
        self.performSegue(withIdentifier: "doneOrCancelSegue", sender: nil)
        
        
    }
    @IBOutlet var CodeField: UILabel!
    var Code: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let Code = defaults.string(forKey: "Code") {
            print(Code) // Some String Value
            CodeField.text = Code
        }
    }
}
