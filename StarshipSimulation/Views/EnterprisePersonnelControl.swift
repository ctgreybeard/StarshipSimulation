//
//  EnterprisePresonnelControl.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 1/18/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Cocoa

class EnterprisePersonnelControl: NSViewController {

    @IBOutlet weak var tvEPers: NSTableView!
    @IBOutlet weak var fldFoodConsumption: NSTextField!
    @IBOutlet weak var fldWaterConsumption: NSTextField!
    @IBOutlet weak var fldO2Consumption: NSTextField!
    @IBOutlet var ac: NSArrayController!
    @IBOutlet weak var tv: NSTableView!

    var floatFormatter: NSNumberFormatter!
    var oBag: Observers!

    private var ourContext = UnsafeMutablePointer<Void>(bitPattern: Int(NSDate.timeIntervalSinceReferenceDate() * 1000.0))  // milliseconds

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        logger.debug("Entry")
        oBag = Observers()
        if let cd = masterData?.cd {
            floatFormatter = NSNumberFormatter()
            floatFormatter.format = "#0.0"
            fldFoodConsumption.formatter = floatFormatter
            fldFoodConsumption?.floatValue = cd.foodConsumption ?? 0.0
            fldWaterConsumption.formatter = floatFormatter
            fldWaterConsumption?.floatValue = cd.waterConsumption ?? 0.0
            fldO2Consumption.formatter = floatFormatter
            fldO2Consumption?.floatValue = cd.oxygenConsumption ?? 0.0
            oBag.addObserver(self, target: cd, forKeyPath: "foodConsumption", options: .New, context: ourContext)
            oBag.addObserver(self, target: cd, forKeyPath: "waterConsumption", options: .New, context: ourContext)
            oBag.addObserver(self, target: cd, forKeyPath: "oxygenConsumption", options: .New, context: ourContext)
            ac.bind("contentArray", toObject: cd, withKeyPath: "enterprisePersonnel", options: nil)
            ac.bind("sortDescriptors", toObject: tv, withKeyPath: "sortDescriptors", options: nil)
            tv.sortDescriptors = [NSSortDescriptor(key: "soID", ascending: true)]
        }
    }

    override func viewWillDisappear() {
        logger.debug("Entry")
        oBag.dropAllObservers(deRegister: true)
        oBag = nil
        floatFormatter = nil
        ac = nil

        super.viewWillDisappear()
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return masterData?.cd.BK ?? 0
    }

    /// Notified when observed values will be or have been changed.
    /// This is cool but a little complex.
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        logger.debug("Entry: key: \(keyPath)")
        if context == ourContext {
            var fld: NSTextField?
            let cd = masterData?.cd
            let c = ObservedChange(change)
            let indexes = c.indexes?.description ?? "nil"
            logger.debug("key: \(keyPath), kind: \(c.kindStr), prior: \(c.prior), indexes: \(indexes)")

            /// Something changed ... what was it?
            switch keyPath {

            case "foodConsumption":
                fld = fldFoodConsumption

            case "waterConsumption":
                fld = fldWaterConsumption

            case "oxygenConsumption":
                fld = fldO2Consumption

            default:
                logger.error("Unknown key: \(keyPath)")
            }

            if let setFld = fld {
                if let tval = c.changeNew as? Float {
                    if tval != setFld.floatValue {
                        logger.debug("Setting \(keyPath) to \(tval)")
                        setFld.floatValue = tval
                    } else {
                        logger.debug("No change for \(keyPath)")
                    }
                } else {
                    logger.error("Error setting \(keyPath) using \(c.changeNew)")
                }
            }
        }

    }

    @IBAction func updateConsumption(sender: NSTextField) {
        logger.debug("Entry")
        if sender.floatValue != masterData.cd.valueForKey(sender.identifier!) as? Float {
            logger.debug("Setting value \(sender.stringValue) for \(sender.identifier)")
            masterData?.cd.setValue(sender.floatValue, forKey: sender.identifier!)
        } else {
            logger.debug("No change for \(sender.identifier)")
        }
    }
}
