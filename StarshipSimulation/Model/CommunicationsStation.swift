//
//  CommunicationsStation.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 1/4/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Foundation

class CommunicationsStation: SystemArrayObject {
    let nilMessage: String
    var messages: [String]
    var FQ: Int {return messages.count}
    var FR: String {
        get {return messages.count > 0 ? messages.removeLast() : nilMessage}
        set {messages.insert(newValue, atIndex: 0)}
    }

    var hasMessages: Bool {return messages.count > 0}

    required init() {
        nilMessage = "-nil-"
        messages = []
        super.init()
        mkSOID(.CommunicationsStation)
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        let newOne = CommunicationsStation()
        return newOne
    }
}