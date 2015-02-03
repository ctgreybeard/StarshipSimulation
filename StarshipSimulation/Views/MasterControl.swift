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
    let updateCountersInterval = 0.1

    @IBOutlet weak var runState: RunningStateControl!
    @IBOutlet weak var cntPersonnel: NSTextField!
    let cntPersonnelTag = "BK"
    @IBOutlet weak var cntPhotonTubes: NSTextField!
    let cntPhotonTubesTag = ""
    @IBOutlet weak var cntPhaserStations: NSTextField!
    let cntPhaserStationsTag = ""
    @IBOutlet weak var cntDeflectorShields: NSTextField!
    let cntDeflectorShieldsTag = ""
    @IBOutlet weak var cntCloak: NSTextField!
    let cntCloakTag = ""
    @IBOutlet weak var cntWarpEngines: NSTextField!
    let cntWarpEnginesTag = ""
    @IBOutlet weak var cntImpulseEngines: NSTextField!
    let cntImpulseEnginesTag = ""
    @IBOutlet var soDictController: NSDictionaryController!
    @IBOutlet weak var soTableView: NSTableView!

    /// Contains a bit pattern unlikely to be used by anyone else -- this could be improved --
    private var ourContext = UnsafeMutablePointer<Void>(bitPattern: Int(NSDate.timeIntervalSinceReferenceDate() * 1000.0))  // milliseconds
    let personnelKey = "enterprisePersonnel"

    /// Observers we registered
    var observers = [NSObject, String, NSKeyValueObservingOptions]()

    /// Initialize the SOID table display
    func initSOTable() {
        logger.debug("Entry")
        soDictController.bind(NSContentDictionaryBinding, toObject: systemData, withKeyPath: systemData.numSOName, options: nil)
        soDictController.bind(NSSortDescriptorsBinding, toObject: soTableView, withKeyPath: NSSortDescriptorsBinding, options: nil)
        soTableView.sortDescriptors = [NSSortDescriptor(key: "key", ascending: true)]
    }

    /// Called right after the view is loaded
    override func viewDidLoad() {
        logger.debug("Entry")
        super.viewDidLoad()
        initSOTable()
    }

    /// Called when the view will appear on the screen
    override func viewWillAppear() {
        logger.debug("And we're back!")
        restoreObservers()
        soTableView.reloadData()
    }

    /// Called right before the view goes away
    override func viewWillDisappear() {
        logger.debug("Going away for now")
        removeObservers()
    }

    /// Action message sent by the custom MasterControl
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
        logger.info("doStart")
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
        logger.info("doStop")
        modelStop()
        runState.subsystemState = "Stopped"
        cancelViewUpdateTimers()
    }

    /// Sets the model to Running state
    func doRun() {
        logger.info("doRun")
        modelRun()
        runState.subsystemState = "Running"
    }

    /// Sets the model to Paused state
    func doPause() {
        logger.info("doPause")
        modelPause()
        runState.subsystemState = "Paused"
    }

    /// Allocates a new model (MasterData)
    func newModel() {
        logger.info("newModel")
        masterData = MasterData()
        masterData.master = MasterController()
        masterData.comm = Communications()
        masterData.eng = Engineering()
        masterData.helm = Helm()
        masterData.medical = Medical()
        masterData.nav = Navigation()
        masterData.sciences = Sciences()
        observe(masterData.cd, object: personnelKey)
    }

    /// Simulation start
    func modelStart() {
        logger.info("modelStart")
        masterData?.master?.simStart()
    }

    /// Simulation stop
    func modelStop() {
        logger.info("modelStop")
        masterData?.master?.simStop()
    }

    /// Simulation start/continue
    func modelRun() {
        logger.info("modelRun")
        masterData?.master?.simStart()
    }

    /// Simulation Pause
    func modelPause() {
        logger.info("modelPause")
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

    /// Updates a displayed counter if the value is different
    func updateDisplayedCount(dField: NSTextField, reference: String, master: NSObject = masterData.cd) {
        let dInt = dField.intValue
        let vInt = Int32(master.valueForKey(reference) as Int)
        if dInt != vInt {dField.intValue = vInt}
    }

    /// Add self as an observer and record it into observers
    func observe(o: NSObject, object: String, opt: NSKeyValueObservingOptions = .Initial | .New) {
        o.addObserver(self, forKeyPath: object, options: opt, context: ourContext)
        observers.append(o, object, opt)
    }

    /// Remove any registered observers
    func removeObservers() {
        logger.debug("Remove observers")
        for (o, s, opt) in observers {
            o.removeObserver(self, forKeyPath: s, context: ourContext)
        }
    }

    /// Restore any registered observers
    func restoreObservers() {
        logger.debug("Restore observers")
        for (o, s, opt) in observers {
            o.addObserver(self, forKeyPath: s, options: opt, context: ourContext)
        }
    }

    /// Standard KVO observer
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if context == ourContext {  // Our change request?
            let c = ObservedChange(change)
            let indexes = c.indexes?.description ?? "nil"
            logger.debug("key: \(keyPath), kind: \(c.kindStr), prior: \(c.prior), indexes: \(indexes)")
            switch keyPath {
            case personnelKey:
                updateDisplayedCount(cntPersonnel, reference: cntPersonnelTag)
            default:
                logger.error("Unhandled change for keyPath: \(keyPath)")
            }
        } else {
            logger.info("Escalating change for \(keyPath)")
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}
