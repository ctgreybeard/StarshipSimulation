//
//  Helm.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/8/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Cocoa
// import XCGLogger

/// Helm simulation controller class
class Helm: SimController {

    override init() {
        logger.debug("Entry")
        super.init()
    }
    override var whoAmI: String {
        return "Helm Controller"
    }
    override func simStart() {
        super.simStart()
    }

    override func simStop() {
        super.simStop()
    }

    override func simPause() {
        super.simPause()
    }

    override func simRestart() {
        super.simRestart()
    }
    
}
