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

class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        sortedArray.removeAll()
        if let search = searchBar.text{
            if(search == ""){
                sortedArray = storeArray
            }
            print(search)
        storeArray.forEach { store in
            if (store.storeName.contains(search)) {
                print("exists")
                
                sortedArray.append(store)
                }
            }
        table.reloadData()
        }
    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        
//    }
    
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var table: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("create cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        cell.storeName.text = sortedArray[indexPath.row].storeName
        cell.addressOne.text = sortedArray[indexPath.row].addressOne
        cell.addressTwo.text = sortedArray[indexPath.row].addressTwo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let defaults = UserDefaults.standard
        defaults.set(sortedArray[indexPath.row].storeName, forKey: "storeName")
        defaults.set(sortedArray[indexPath.row].storeId, forKey: "storeId")
        defaults.removeObject(forKey:"Code")
        defaults.removeObject(forKey:"startTime")
        defaults.removeObject(forKey:"endTime")
        defaults.removeObject(forKey:"seat")
        defaults.removeObject(forKey:"queueId")
        self.performSegue(withIdentifier: "storeSegue", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let defaults = UserDefaults.standard
        defaults.set(sortedArray[indexPath.row].storeName, forKey: "storeName")
        defaults.set(sortedArray[indexPath.row].storeId, forKey: "storeId")
        let contextItem = UIContextualAction(style: .normal, title: "Line Up") { [self] (contextualAction, view, boolValue) in
                boolValue(true) // pass true if you want the handler to allow the action
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey:"Code")
                defaults.removeObject(forKey:"startTime")
                defaults.removeObject(forKey:"endTime")
                defaults.removeObject(forKey:"seat")
                defaults.removeObject(forKey:"queueId")
                self.performSegue(withIdentifier: "storeSegue", sender: nil)
            }
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
            return swipeActions
    }

    var storeArray: [Store] = []
    var sortedArray: [Store] = []
    var dataPass: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        table.delegate = self;
        table.dataSource = self;
        searchBar.delegate = self
        let user = Auth.auth().currentUser
        if let user = user {
              let email = user.email
              let defaults = UserDefaults.standard
              defaults.set(email, forKey: "email")
        }
    }
    
    func fetch(){
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser{
            db.collection("store")
                .addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    for document in documents {
                        let data = document.data()
                        let id = document.documentID
                        let temp = Store(storeId: id , storeName: data["storeName"] as! String, addressOne: data["addressOne"] as! String, addressTwo: data["addressTwo"] as! String, state: data["state"] as! String, city: data["city"] as! String, zip: data["zip"] as! String)
                        self.storeArray.append(temp)
                        self.sortedArray.append(temp)
                    }
                    self.table.reloadData()
                }
        }
    }

}
