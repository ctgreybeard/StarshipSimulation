//
//  MasterControl.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/20/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Cocoa

class MasterControl: SimViewController {

    /// Various parameters to adjust for tuning
    let updateTimerInterval = 0.49

    @IBOutlet weak var runState: RunningStateControl!
    
    override func viewDidLoad() {
        logger.debug("Entry")
        super.viewDidLoad()
        // Do view setup here.
    }

    @IBAction func masterControl(sender: RunningStateControl) {
        logger.debug("Received action: \(sender.actionRequest)")
        let actionTable: [String: () -> Void] = ["Start": doStart, "Stop": doStop, "Run": doRun, "Pause": doPause]
        if let action = actionTable[sender.actionRequest!] {
            actionTable[sender.actionRequest!]!()
        } else {
            logger.severe("Unknown action request: \(sender.actionRequest)")
        }
    }

    /// Start the simulation
    ///
    /// Allocates the model if necessary, starts the model and the uview update timers
    func doStart() {
        logger.debug("Entry")
        if masterData == nil {
            newModel()
        }
        modelStart()
        runState.subsystemState = "Running"
        createViewUpdateTimers()
        startViewUpdateTimers()
    }

    /// Stop the simulation
    ///
    /// Stops the model, cancels to view update timers
    func doStop() {
        logger.debug("Entry")
        modelStop()
        runState.subsystemState = "Stopped"
        cancelViewUpdateTimers()
    }

    /// Sets the model to Running state
    func doRun() {
        logger.debug("Entry")
        modelRun()
        runState.subsystemState = "Running"
    }

    /// Sets the model to Pausd state
    func doPause() {
        logger.debug("Entry")
        modelPause()
        runState.subsystemState = "Paused"
    }

    /// Allocates a new model (MasterData)
    func newModel() {
        logger.debug("Entry")
        masterData = MasterData()
        masterData.master = MasterController()
        masterData.comm = Communications()
        masterData.eng = Engineering()
        masterData.helm = Helm()
        masterData.medical = Medical()
        masterData.nav = Navigation()
        masterData.sciences = Sciences()
    }

    /// Simulation start
    func modelStart() {
        logger.debug("Entry")
        masterData?.master?.simStart()
    }

    /// Simulation stop
    func modelStop() {
        logger.debug("Entry")
        masterData?.master?.simStop()
    }

    /// Simulation start/continue
    func modelRun() {
        logger.debug("Entry")
        masterData?.master?.simStart()
    }

    /// Simulation Pause
    func modelPause() {
        logger.debug("Entry")
        masterData?.master?.simPause()
    }

    /// Initializes the view update timers if they are not already running
    override func createViewUpdateTimers() {
        logger.debug("Entry")
        if viewUpdateTimers.isEmpty {
            viewUpdateTimers.append(NSTimer(timeInterval: updateTimerInterval, target: self, selector: "updateElapsed:", userInfo: nil, repeats: true))
        }
        super.createViewUpdateTimers()
    }

    /// Updates the elapsed time display from the model elapsed time
    func updateElapsed(timer: NSTimer) {
        if let et = masterData.master?.simState.elapsedTime {
            runState.subsystemElapsed = et
        }
    }

}
