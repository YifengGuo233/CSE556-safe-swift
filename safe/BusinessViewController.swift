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
    
    @IBOutlet var startTimeField: UILabel!
    @IBOutlet var endTimeField: UILabel!
    @IBOutlet var maxSeatField: UILabel!
    @IBOutlet var seatLeftField: UILabel!
}

class BusinessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var table: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queueArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "queueCell", for: indexPath) as! QueueTableViewCell
        cell.startTimeField.text = queueArray[indexPath.row].startTime
        cell.endTimeField.text = queueArray[indexPath.row].endTime
        cell.maxSeatField.text = queueArray[indexPath.row].seat
        cell.seatLeftField.text = queueArray[indexPath.row].seatLeft
        return cell
    }
    
    var queueArray : [TimeSlot] = []
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
                            print(data)
                            //let id = document.documentID
                            let temp = TimeSlot(startTime: data["startTime"] as! String, endTime: data["endTime"] as! String, seat: data["seat"] as! String, seatLeft: data["seatLeft"] as! String)
                            self.queueArray.append(temp)
                        }
                        self.table.reloadData()
                    }
            }
        }
    }
}
