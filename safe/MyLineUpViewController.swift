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
}
class MyLineUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineUpArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("create cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "LineUpCell", for: indexPath) as! LineUpTableViewCell
        cell.storeName.text = lineUpArray[indexPath.row].storeName
        print(lineUpArray[indexPath.row])
            return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let waitcode = lineUpArray[indexPath.row].waitCode
        let storeId = lineUpArray[indexPath.row].storeId
        let storeName = lineUpArray[indexPath.row].storeName
        let startTime = lineUpArray[indexPath.row].startTime
        let endTime = lineUpArray[indexPath.row].endTime
        let defaults = UserDefaults.standard
        defaults.set(waitcode, forKey: "Code")
        defaults.set(storeId, forKey: "storeId")
        defaults.set(storeName, forKey: "storeName")
        defaults.set(startTime, forKey: "startTime")
        defaults.set(endTime, forKey: "endTime")
        self.performSegue(withIdentifier: "LineUpListSegue", sender: nil)
    }
    
    
    @IBOutlet var table: UITableView!
    var lineUpArray: [MyLineUp] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        table.delegate = self;
        table.dataSource = self;
    }
    
    func fetch(){
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser{
            db.collection("users").document(user.uid).collection("LineUp")
                .addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    for document in documents {
                        let data = document.data()
                        let temp = MyLineUp(storeId: data["storeId"] as! String, storeName: data["storeName"] as! String, startTime: data["startTime"] as! String, endTime: data["endTime"] as! String, waitCode: data["waitCode"] as! String)
                        self.lineUpArray.append(temp)
                    }
                }
        }
    }
}
