//
//  MyLineUpViewController.swift
//  safe
//
//  Created by Yifeng Guo on 11/21/20.
//

import Foundation
import UIKit
import Firebase


class LineUpTableViewCell: UITableViewCell {
    @IBOutlet var storeName: UILabel!
    @IBOutlet var timeLabel: UILabel!
}
class MyLineUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineUpArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("create cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "LineUpCell", for: indexPath) as! LineUpTableViewCell
        cell.storeName.text = lineUpArray[indexPath.row].storeName
        cell.timeLabel.text = lineUpArray[indexPath.row].startTime + " - " + lineUpArray[indexPath.row].endTime
        print(lineUpArray[indexPath.row])
            return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let waitcode = lineUpArray[indexPath.row].waitCode
        let storeId = lineUpArray[indexPath.row].storeId
        let queueId = lineUpArray[indexPath.row].queueId
        let storeName = lineUpArray[indexPath.row].storeName
        let startTime = lineUpArray[indexPath.row].startTime
        let endTime = lineUpArray[indexPath.row].endTime
        let defaults = UserDefaults.standard
        defaults.set(waitcode, forKey: "Code")
        defaults.set(storeId, forKey: "storeId")
        defaults.set(queueId, forKey: "queueId")
        defaults.set(storeName, forKey: "storeName")
        defaults.set(startTime, forKey: "startTime")
        defaults.set(endTime, forKey: "endTime")
        self.performSegue(withIdentifier: "LineUpListSegue", sender: nil)
    }
    
    
    @IBOutlet var table: UITableView!
    var lineUpArray: [MyLineUp] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        table.delegate = self;
        table.dataSource = self;
        //table.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        fetch()
    }

    
    func fetch(){
        let db = Firestore.firestore()
        print("fetch")
        self.lineUpArray.removeAll()
        if let user = Auth.auth().currentUser{
            db.collection("users").document(user.uid).collection("LineUp")
                .getDocuments() { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    print("documents")
                    for document in documents {
                        print(document)
                        let data = document.data()
                        let temp = MyLineUp(storeId: data["storeId"] as! String, storeName: data["storeName"] as! String, queueId: data["queueId"] as! String, startTime: data["startTime"] as! String, endTime: data["endTime"] as! String, waitCode: data["waitCode"] as! String)
                        self.lineUpArray.append(temp)
                    }
                    self.table.reloadData()
                }
        }
        
    }
}
