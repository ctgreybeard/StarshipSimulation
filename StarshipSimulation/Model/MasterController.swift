//
//  SimController.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/8/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Cocoa

/// Master simulation controller class
class MasterController: SimController {

    override init() {
        logger.debug("MasterController")
        super.init()
        masterData.cd.masterRS = simState
    }
    override var whoAmI: String {
        return "Master Controller"
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
