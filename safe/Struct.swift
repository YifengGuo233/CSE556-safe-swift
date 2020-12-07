//
//  TimeSlot.swift
//  safe
//
//  Created by Yifeng Guo on 11/21/20.
//

struct TimeSlot {
    var queueId = ""
    var startTime = ""
    var endTime = ""
    var seat = ""
    var seatLeft = ""
}

struct Store{
    var storeId = ""
    var storeName = ""
    var addressOne = ""
    var addressTwo = ""
    var state = ""
    var city = ""
    var zip = ""
}

struct MyLineUp{
    var storeId = ""
    var storeName = ""
    var queueId = ""
    var startTime = ""
    var endTime = ""
    var waitCode = ""
}

struct People{
    var id = ""
    var firstName = ""
    var lastName = ""
    var waitCode = ""
    var phone = ""
}
