//
//  MainController.swift
//  safe
//
//  Created by Yifeng Guo on 11/14/20.
//

import UIKit
import Firebase
import Foundation

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var storeName: UILabel!
    @IBOutlet var addressOne: UILabel!
    @IBOutlet var addressTwo: UILabel!
}

class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var table: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("create cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        cell.storeName.text = storeArray[indexPath.row]
            return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let defaults = UserDefaults.standard
        defaults.set(storeArray[indexPath.row], forKey: "storeName")
        let contextItem = UIContextualAction(style: .normal, title: "Line Up") { [self] (contextualAction, view, boolValue) in
                boolValue(true) // pass true if you want the handler to allow the action
                self.performSegue(withIdentifier: "storeSegue", sender: nil)
            }
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
            return swipeActions
    }

    var storeArray: [String] = ["Store1","Store2","Store3"]
    
    //var data: String = ""
    var dataPass: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self;
        table.dataSource = self;
        
        let user = Auth.auth().currentUser
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          let uid = user.uid
          let email = user.email
          let photoURL = user.photoURL
          print(uid)
          print(email)
    
        }
        print(storeArray.count)
        print(storeArray)
        //self.table.reloadData()
    }

}
