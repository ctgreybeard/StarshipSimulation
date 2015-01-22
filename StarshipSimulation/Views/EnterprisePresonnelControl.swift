//
//  EnterprisePresonnelControl.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 1/18/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Cocoa

private var ourContext = UnsafeMutablePointer<Void>(bitPattern: Int(NSDate.timeIntervalSinceReferenceDate()))

class EnterprisePersonnelControl: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate {

    @IBOutlet weak var tvEPers: NSTableView!
    @IBOutlet weak var fldFoodConsumption: NSTextField!
    @IBOutlet weak var fldWaterConsumption: NSTextField!
    @IBOutlet weak var fldO2Consumption: NSTextField!
    //    weak var cd: CommonData?
    var observers: [EnterprisePerson?]!
    var floatFormatter: NSNumberFormatter!

    let myTag = 14623   // Tag set in Storyboard for NSTableView

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        logger.debug("Entry")
        floatFormatter = NSNumberFormatter()
        floatFormatter.format = "#0.0"
        fldFoodConsumption.formatter = floatFormatter
        fldFoodConsumption?.floatValue = masterData?.cd.foodConsumption ?? 0.0
        fldWaterConsumption.formatter = floatFormatter
        fldWaterConsumption?.floatValue = masterData?.cd.waterConsumption ?? 0.0
        fldO2Consumption.formatter = floatFormatter
        fldO2Consumption?.floatValue = masterData?.cd.oxygenConsumption ?? 0.0
        masterData?.cd.addObserver(self, forKeyPath: "foodConsumption", options: .New, context: ourContext)
        masterData?.cd.addObserver(self, forKeyPath: "waterConsumption", options: .New, context: ourContext)
        masterData?.cd.addObserver(self, forKeyPath: "oxygenConsumption", options: .New, context: ourContext)
        masterData?.cd.addObserver(self, forKeyPath: "enterprisePersonnel.array", options: .New | .Prior, context: ourContext)
    }

    override func viewWillDisappear() {
        logger.debug("Entry")
        masterData?.cd.removeObserver(self, forKeyPath: "foodConsumption")
        masterData?.cd.removeObserver(self, forKeyPath: "waterConsumption")
        masterData?.cd.removeObserver(self, forKeyPath: "oxygenConsumption")
        masterData?.cd.removeObserver(self, forKeyPath: "enterprisePersonnel.array")
        dropObservers() // Remove our observers
        floatFormatter = nil
        super.viewWillDisappear()
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return masterData?.cd.BK ?? 0
    }

    // MARK - This probably won't work if the array has already changed length

    /// Drop all obervers and nil the array. It will be rebuilt the next time it is needed.
    func dropObservers() {
        dropObservers(atIndexes: NSIndexSet(indexesInRange: NSMakeRange(0, observers.count)))
        observers = nil
    }

    /// Drop the observers (usually only one) at index(es)
    func dropObservers(atIndexes indexes: NSIndexSet?) {
        for var n = indexes!.firstIndex; n < NSNotFound; n = indexes!.indexGreaterThanIndex(n) {
            if let object = observers[n] {
                object.removeObserver(self, forKeyPath: "personInfo")
            }
            observers[n] = nil
        }
    }

    /// Return a string describing the NSKeyValueChangeKind (for logging)
    private func kindStr(kind: NSKeyValueChange) -> String {
        let kindString: [NSKeyValueChange: String] = [
            .Replacement: ".Replacement",
            .Insertion: ".Insertion",
            .Removal: ".Removal",
            .Setting: ".Setting"]
        return kindString[kind] ?? ".???"
    }

    /// Notified when observed values will be or have been changed.
    /// This is cool but a little complex.
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        logger.debug("Entry: key: \(keyPath)")
        if context == ourContext {
            var fld: NSTextField?
            let cd = masterData?.cd
            let ourView = view.viewWithTag(myTag) as? NSTableView
            let cdict = change as [NSString: AnyObject]
            let kind = NSKeyValueChange(rawValue: UInt(cdict[NSKeyValueChangeKindKey] as NSNumber))!
            let prior = (cdict[NSKeyValueChangeNotificationIsPriorKey] as? NSNumber) == NSNumber(bool: true)
            let indexes = cdict[NSKeyValueChangeIndexesKey] as? NSIndexSet
            logger.debug("key: \(keyPath), kind: \(kindStr(kind)), prior: \(prior), indexes: \(indexes)")

            if observers == nil {observers = [EnterprisePerson?](count: masterData!.cd.BK, repeatedValue: nil)}
            else if observers.count != masterData!.cd.BK {
                logger.severe("observers array not same length as cd.BK! (observers: \(observers.count) vs BK: \(masterData!.cd.BK))")
                dropObservers()
            }

            /// Something changed ... what was it?
            if keyPath == "personInfo" {    // Personal data
                // Iterate through the observers array to find a matching object; that index is the table row number
                for n in 0..<observers.count {
                    if let observed = observers[n] {
                        if observed === object {
                            logger.debug("Found observed person for row \(n)")
                            ourView?.reloadDataForRowIndexes(NSIndexSet(index: n), columnIndexes: NSIndexSet(indexesInRange: NSMakeRange(0, ourView!.numberOfColumns)))   // Reload th entire row
                            break   // We are done ...
                        }
                    }
                }
            } else if keyPath == "enterprisePersonnel.array" {  // An element in the array containing all Entrprise Personnel changed
                switch kind {
                case .Replacement:
                    if prior {
                        dropObservers(atIndexes: indexes)
                    } else {
                        if let updIndex = indexes {
                            ourView?.reloadDataForRowIndexes(updIndex, columnIndexes: NSIndexSet(indexesInRange: NSMakeRange(0, ourView!.numberOfColumns)))   // Reload the row
                        } else {
                            logger.severe("No indexes found for .Replacemnt request")
                        }
                    }
                case .Insertion, .Removal:
                    //  The following line crashes the SourcKit AND the Swift compiler
                    //logger.debug(kind == .Insertion ? ".Insertion" : ".Removal")
                    if prior {   // Before the insert/removal
                        dropObservers() // Drop all of our observers
                    } else {            // After the insert
                        ourView?.reloadData()   // Rebuild the display
                    }
                case .Setting:  // This shouldn't occur, show an error
                    logger.error("Unhandled change request: .Setting")
                }
            } else {
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
                    if let tval = change[NSKeyValueChangeNewKey] as? Float {
                        if tval != setFld.floatValue {
                            logger.debug("Setting \(keyPath) to \(tval)")
                            setFld.floatValue = tval
                        } else {
                            logger.debug("No change in \(keyPath)")
                        }
                    } else {
                        logger.error("Error setting \(keyPath) using \(change[NSKeyValueChangeNewKey])")
                    }
                }
            }
        } else {
            logger.info("Not our observation(\(keyPath):\(context))")
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }

    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var result: NSView?

        if observers == nil {observers = [EnterprisePerson?](count: masterData!.cd.BK, repeatedValue: nil)}
        if observers[row] == nil {
            let ourPerson = masterData!.cd.enterprisePersonnel[row]! as EnterprisePerson
            ourPerson.addObserver(self, forKeyPath: "personInfo", options: .New, context: ourContext)
            observers[row] = ourPerson
        }

        if let colID = tableColumn?.identifier {
            if let myCell = tableView.makeViewWithIdentifier(colID, owner: self) as? NSTableCellView {
                result = myCell
                if colID == "Num" {
                    myCell.textField?.integerValue = row
                } else {
                    switch colID {
                    case "BL", "BM", "BLid":
                        myCell.textField?.stringValue = (masterData.cd.valueForKey(colID) as SystemArrayAccess)[row] as String
                    case "BO", "BS":    // Location and Destination
                        myCell.textField?.stringValue = (masterData.cd.valueForKey(colID + "d") as SystemArrayAccess)[row] as String
                    case "BN", "BT", "BU":
                        myCell.textField?.integerValue = (masterData.cd.valueForKey(colID) as SystemArrayAccess)[row] as Int
                    default:
                        logger.error("Personnel view asking for \(colID) but I don't know what that is.")
                    }
                }
            } else {
                logger.error("Personnel view unable to find cell")
            }
        } else {
            logger.error("Personnel view unable to find column ID")
        }
        return result
    }

    @IBAction func updateConsumption(sender: NSTextField) {
        if sender.floatValue != masterData.cd.valueForKey(sender.identifier) as? Float {
            logger.debug("Setting value \(sender.stringValue) for \(sender.identifier)")
            masterData?.cd.setValue(sender.floatValue, forKey: sender.identifier)
        } else {
            logger.debug("No change for \(sender.identifier)")
        }
    }
}
