//
//  SelectTimeViewController.swift
//  safe
//
//  Created by Yifeng Guo on 11/21/20.
//

import Foundation
import UIKit
import Firebase

class TimeTableViewCell: UITableViewCell {
    
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    @IBOutlet var seatLabel: UILabel!
}

class SelectTimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("create cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as! TimeTableViewCell
        cell.startTimeLabel.text = timeArray[indexPath.row].startTime
        cell.endTimeLabel.text = timeArray[indexPath.row].endTime
        cell.seatLabel.text = "Seat Left: " + String( timeArray[indexPath.row].seatLeft)
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let defaults = UserDefaults.standard
        defaults.set(timeArray[indexPath.row].startTime, forKey: "startTime")
        defaults.set(timeArray[indexPath.row].endTime, forKey: "endTime")
        defaults.set(timeArray[indexPath.row].seat, forKey: "seat")
        defaults.set(timeArray[indexPath.row].seatLeft, forKey: "seatLeft")
        defaults.set(timeArray[indexPath.row].queueId, forKey: "queueId")
        self.performSegue(withIdentifier: "selectTimeSegue", sender: nil)
    }
    
    //var temp = TimeSlot(startTime: "12:00", endTime: "13:00", seat: 5)
    
    var timeArray: [TimeSlot] = []
    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //timeArray.append(temp)
        
        
        table.delegate = self;
        table.dataSource = self;
        fetch()
    }
    
    func fetch(){
        let defaults = UserDefaults.standard
        if let storeId = defaults.string(forKey: "storeId") {
            let db = Firestore.firestore()
            if let user = Auth.auth().currentUser{
                db.collection("store").document(storeId).collection("queue")
                    .addSnapshotListener { querySnapshot, error in
                        guard let documents = querySnapshot?.documents else {
                            print("Error fetching documents: \(error!)")
                            return
                        }
                        for document in documents {
                            let data = document.data()
                            print("date")
                            print(data)
                            let id = document.documentID
                            let temp = TimeSlot(queueId : id , startTime: data["startTime"] as! String, endTime: data["endTime"] as! String, seat: data["seat"] as! String, seatLeft: data["seatLeft"] as! String)
                            self.timeArray.append(temp)
                        }
                        self.table.reloadData()
                    }
            }
        }
    }
    
    
}
