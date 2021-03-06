//
//  BusinessViewController.swift
//  safe
//
//  Created by Yifeng Guo on 11/21/20.
//

import Foundation
import UIKit
import Firebase

class QueueTableViewCell: UITableViewCell {
    
//    @IBOutlet var background: UIView!
    
    @IBOutlet var timeField: UILabel!
    @IBOutlet var seatField: UILabel!
}

class BusinessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var table: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queueArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "queueCell", for: indexPath) as! QueueTableViewCell
        cell.timeField.text = queueArray[indexPath.row].startTime + " - " + queueArray[indexPath.row].endTime
        cell.seatField.text = queueArray[indexPath.row].seatLeft + " seats left (" +  queueArray[indexPath.row].seat + ")"
//        cell.background.layer.shadowColor = UIColor.black.cgColor
//        cell.background.layer.shadowOpacity = 1
//        cell.background.layer.shadowOffset = .zero
//        cell.background.layer.shadowRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let defaults = UserDefaults.standard
        defaults.set(queueArray[indexPath.row].queueId, forKey: "queueId")
        defaults.set(queueArray[indexPath.row].startTime, forKey: "startTime")
        defaults.set(queueArray[indexPath.row].endTime, forKey: "endTime")
        defaults.set(queueArray[indexPath.row].seat, forKey: "seat")
        defaults.set(queueArray[indexPath.row].seatLeft, forKey: "seatLeft")
        self.performSegue(withIdentifier: "detailQueueSegue", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let defaults = UserDefaults.standard
        defaults.set(queueArray[indexPath.row].queueId, forKey: "queueId")
        defaults.set(queueArray[indexPath.row].startTime, forKey: "startTime")
        defaults.set(queueArray[indexPath.row].endTime, forKey: "endTime")
        defaults.set(queueArray[indexPath.row].seat, forKey: "seat")
        defaults.set(queueArray[indexPath.row].seatLeft, forKey: "seatLeft")
        let contextItem = UIContextualAction(style: .normal, title: "Edit") { [self] (contextualAction, view, boolValue) in
                boolValue(true) // pass true if you want the handler to allow the action
                self.performSegue(withIdentifier: "detailQueueSegue", sender: nil)
            }
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
            return swipeActions
    }
    
    var queueArray : [TimeSlot] = []
    var sortedArray : [TimeSlot] = []
    override func viewDidLoad() {
        let defaults = UserDefaults.standard
        let user = Auth.auth().currentUser
        if let user = user {
          let uid = user.uid
            let db = Firestore.firestore()
            let docRef = db.collection("store").document(uid)
            let storeId = docRef.documentID
            defaults.set(storeId, forKey: "storeId")
            docRef.getDocument { [self] (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    if let storeName = data?["storeName"]{
                        defaults.set(storeName, forKey: "storeName")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        fetch()
        table.delegate = self;
        table.dataSource = self;
    }
    
    func fetch(){
        let defaults = UserDefaults.standard
        if let storeId = defaults.string(forKey: "storeId") {
            let db = Firestore.firestore()
            if let user = Auth.auth().currentUser{
                db.collection("store").document(user.uid).collection("queue")
                    .addSnapshotListener { querySnapshot, error in
                        guard let documents = querySnapshot?.documents else {
                            print("Error fetching documents: \(error!)")
                            return
                        }
                        for document in documents {
                            let data = document.data()
                            print("1")
                            print(data)
                            let id = document.documentID
                            let temp = TimeSlot(queueId:id, startTime: data["startTime"] as! String, endTime: data["endTime"] as! String, seat: data["seat"] as! String, seatLeft: data["seatLeft"] as! String)
                            self.queueArray.append(temp)
                        }
                        func sortedByTime(this:TimeSlot, that:TimeSlot) -> Bool {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH:mm"
                            let this_startTime = dateFormatter.date(from: this.startTime)!
                            let that_startTime = dateFormatter.date(from: that.startTime)!
                          return this_startTime < that_startTime
                        }
                        self.queueArray = self.queueArray.sorted(by: sortedByTime)
                        
                        self.table.reloadData()
                    }
            }
        }
    }
}
