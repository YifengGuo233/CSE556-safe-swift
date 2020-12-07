//
//  DetailQueueViewController.swift
//  safe
//
//  Created by Yifeng Guo on 11/27/20.
//

import Foundation
import UIKit
import Firebase

class QueueTableCell: UITableViewCell {
    
    @IBOutlet var nameField: UILabel!
    @IBOutlet var phoneField: UILabel!
}


class DetailQueueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "queueCell", for: indexPath) as! QueueTableCell
        cell.nameField.text = "Name: " + peopleArray[indexPath.row].firstName + " " + peopleArray[indexPath.row].lastName
            cell.phoneField.text = peopleArray[indexPath.row].phone
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let defaults = UserDefaults.standard
        let userId = peopleArray[indexPath.row].id
        
        let contextItem1 = UIContextualAction(style: .normal, title: "Remove") { [self] (contextualAction, view, boolValue) in
                boolValue(true) // pass true if you want the handler to allow the action
            let db = Firestore.firestore()
            if let storeId = defaults.string(forKey: "storeId"){
                if let queueId = defaults.string(forKey: "queueId"){
                    
                    /*Below is to delete info from both store and user side*/
                    db.collection("store").document(storeId).collection("queue").document(queueId).collection("users").document(userId).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully from store!")
                        }
                        peopleArray.remove(at: indexPath.row)
                        self.queueTable.deleteRows(at: [indexPath], with: .automatic)
                    }
                    db.collection("users").document(userId).collection("LineUp").document(storeId).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                    /*Above is to delete info from both store and user side*/
                    
                    /*Below is to check update remaining seat*/
                    var count = 0;
                    db.collection("store").document(storeId).collection("queue").document(queueId).collection("users").getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            count = querySnapshot!.documents.count;
                            if let seat = defaults.string(forKey: "seat"){
                                print(seat)
                                let seatInt:Int = (seat as NSString).integerValue
                                print(seatInt)
                                let seatLeft = seatInt - count;
                                
                                db.collection("store").document(storeId).collection("queue").document(queueId).updateData([
                                    "seatLeft": String(seatLeft),
                                    ]) { err in
                                        if let err = err {
                                            print("Error adding document: \(err)")
                                        } else {
                                            print("successful Update")
                                        }
                                    }
                                }
                            }
                        }
                    /*Above is to check update remaining seat*/
                    
                }
            }
            
        }
        contextItem1.backgroundColor = UIColor.red
        /*Can only test on real device*/
        let contextItem2 = UIContextualAction(style: .normal, title: "Call") { [self] (contextualAction, view, boolValue) in
                boolValue(true) // pass true if you want the handler to allow the action
            if let url = URL(string: "tel://\(peopleArray[indexPath.row].phone)"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        contextItem2.backgroundColor = UIColor.green
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem1, contextItem2])
            return swipeActions
    }
    

    
    
    var peopleArray : [People] = []
    @IBOutlet var queueTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        queueTable.delegate = self;
        queueTable.dataSource = self;
    }
    
    func fetch(){
        let defaults = UserDefaults.standard
        if let storeId = defaults.string(forKey: "storeId"){
            if let queueId = defaults.string(forKey: "queueId"){
            let db = Firestore.firestore()
            if let user = Auth.auth().currentUser{
                db.collection("store").document(storeId).collection("queue").document(queueId).collection("users")
                    .addSnapshotListener { querySnapshot, error in
                        guard let documents = querySnapshot?.documents else {
                            print("Error fetching documents: \(error!)")
                            return
                        }
                        for document in documents {
                            let data = document.data()
                            print(data)
                            let id = document.documentID
                            let temp = People(id: id, firstName: data["firstName"] as! String, lastName: data["lastName"] as! String, waitCode: data["waitCode"] as! String, phone: data["phoneNumber"] as! String)
                            self.peopleArray.append(temp)
                        }
                        self.queueTable.reloadData()
                    }
                }
            }
        }
    }
    
}
