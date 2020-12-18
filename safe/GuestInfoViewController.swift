//
//  GuestInfoViewController.swift
//  safe
//
//  Created by Yifeng Guo on 12/8/20.
//

import Foundation
import UIKit
import Firebase
import SwiftGifOrigin

class GuestInfoViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet var guestName: UITextField!
    @IBOutlet var guestPhoneNumber: UITextField!
    
    var text = false
    var call = false
    
    @IBOutlet var textMeButton: UIButton!
    @IBOutlet var callMeButton: UIButton!
    
    @IBAction func TextMeClick(_ sender: Any) {
        if(!text){
            if let image = UIImage(named: "button_checked") {
                textMeButton.setImage(image, for: .normal)
                text = true
            }
        }
        else{
            if let image = UIImage(named: "button_unchecked") {
                textMeButton.setImage(image, for: .normal)
                text = false
            }
        }
    }
    @IBAction func TextMeButtonClick(_ sender: Any) {
        if(!text){
            if let image = UIImage(named: "button_checked") {
                textMeButton.setImage(image, for: .normal)
                text = true
            }
        }
        else{
            if let image = UIImage(named: "button_unchecked") {
                textMeButton.setImage(image, for: .normal)
                text = false
            }
        }
    }
    
    @IBAction func CallMeButtonClick(_ sender: Any) {
        if(!call){
            if let image = UIImage(named: "button_checked") {
                callMeButton.setImage(image, for: .normal)
                call = true
            }
            
        }
        else{
            if let image = UIImage(named: "button_unchecked") {
                callMeButton.setImage(image, for: .normal)
                call = false
            }
        }
    }
    
    @IBAction func CallMeClick(_ sender: Any) {
        if(!call){
            if let image = UIImage(named: "button_checked") {
                callMeButton.setImage(image, for: .normal)
                call = true
            }
            
        }
        else{
            if let image = UIImage(named: "button_unchecked") {
                callMeButton.setImage(image, for: .normal)
                call = false
            }
        }
    }
    
    
    @IBAction func Finish(_ sender: Any) {
        if(guestName.text != "" && guestPhoneNumber.text != ""){
            let alert = UIAlertController(title: "Line Up", message: "You are lined up!", preferredStyle: .alert)
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    alert.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "LineUpSegue", sender: nil)
            }
        }
        else{
            let alert = UIAlertController(title: "Need more information", message: "We may need your name and phone number to contact you.", preferredStyle: .alert)
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
