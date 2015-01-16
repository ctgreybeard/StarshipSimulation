//
//  SimController.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/29/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Foundation

/// Top level Simulation controller superclass
class SimController: NSObject {

    let simState: RunningState

    override init() {
        simState = RunningState()
        super.init()
//        logger.debug("\(whoAmI)")
    }

    /// Subclasses should override this to return an appropriate value
    var whoAmI: String {
        return "SimController"
    }

    override var description: String {
        return whoAmI
    }

    func simStart() {
        simState.runValue = .Run
    }

    func simStop() {
        // First we pause
        simPause()
        simState.runValue = .Stop
    }

    func simPause() {
        simState.runValue = .Pause
    }

    func simRestart() {
        simStop()
        simStart()
    }
}

