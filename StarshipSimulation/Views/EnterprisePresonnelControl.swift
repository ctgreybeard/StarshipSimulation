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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        logger.debug("Entry")
        let floatFormatter = NSNumberFormatter()
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
        masterData?.cd.addObserver(self, forKeyPath: "enterprisePersonnel", options: .New | .Prior, context: ourContext)
    }

    override func viewWillDisappear() {
        logger.debug("Entry")
        masterData?.cd.removeObserver(self, forKeyPath: "foodConsumption")
        masterData?.cd.removeObserver(self, forKeyPath: "waterConsumption")
        masterData?.cd.removeObserver(self, forKeyPath: "oxygenConsumption")
        masterData?.cd.removeObserver(self, forKeyPath: "enterprisePersonnel")
        redoObservers() // Remove our observers
        super.viewWillDisappear()
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return masterData?.cd.BK ?? 0
    }

    /// MARK - This probably won't work if the array has already changed length
    func redoObservers() {
        for n in 0..<observers.count {
            if let person = observers[n] {
                person.removeObserver(self, forKeyPath: "personInfo")
                observers[n] = nil
            }
        }
        observers = nil
    }

    func dropObservers(indexes: NSIndexSet?, remove: Bool) {
        for var n = indexes!.firstIndex; n < NSNotFound; n = indexes!.indexGreaterThanIndex(n) {
            if let object = observers[n] {
                object.removeObserver(self, forKeyPath: "personInfo")
            }
            observers[n] = nil
            if remove {observers.removeAtIndex(n)}
        }
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        logger.debug("Entry: key: \(keyPath)")
        if context == ourContext {
            var fld: NSTextField?
            let cd = masterData?.cd

            if observers == nil {observers = [EnterprisePerson?](count: masterData!.cd.BK, repeatedValue: nil)}
            else if observers.count != masterData!.cd.BK {
                logger.severe("observers array not same length as cd.BK! (observers: \(observers.count) vs BK: \(masterData!.cd.BK)")
                redoObservers()
            }

            if keyPath == "personInfo" {
                for n in 0..<observers.count {
                    if let observed = observers[n] {
                        if observed === object {
                            logger.verbose("Found observed person for row \(n)")
                            let ourView = view as NSTableView
                            ourView.reloadDataForRowIndexes(NSIndexSet(index: n), columnIndexes: NSIndexSet(indexesInRange: NSMakeRange(0, ourView.numberOfColumns)))
                        }
                    }
                }
            } else if keyPath == "enterprisePersonnel" {
                let cdict = change as [NSString: AnyObject]
                let kind = cdict[NSKeyValueChangeKindKey] as NSNumber
                let prior = cdict[NSKeyValueChangeNotificationIsPriorKey] as? NSNumber
                let indexes = cdict[NSKeyValueChangeIndexesKey] as? NSIndexSet
                logger.debug("kind: \(kind), prior: \(prior), indexes: \(indexes)")
                switch UInt(kind.unsignedIntValue) {
                case NSKeyValueChange.Removal.rawValue:
                    logger.debug(".Removal")
                    if prior != nil {
                        dropObservers(indexes, remove: true)
                    }
                case NSKeyValueChange.Replacement.rawValue:
                    logger.debug(".Replacement")
                    if prior != nil {dropObservers(indexes, remove: false)}
                case NSKeyValueChange.Insertion.rawValue:
                    logger.debug(".Insertion")
                    if prior == nil {
                        for var n = indexes!.firstIndex; n < observers.count; n = indexes!.indexGreaterThanIndex(n) {
                            observers.insert(nil, atIndex: n)   // Will this work for more than one element?
                        }
                    }
                case NSKeyValueChange.Setting.rawValue:
                    logger.debug(".Setting")
                default:
                    logger.error("Unknown Change Kind: \(kind)")
                }
                logger.debug("")
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

                if let tval = change[NSKeyValueChangeNewKey] as? Float {
                    logger.debug("Setting \(keyPath) to \(tval)")
                    fld?.floatValue = tval
                } else {
                    logger.error("Error setting \(keyPath) using \(change[NSKeyValueChangeNewKey])")
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
                if colID == "Num" {
                    myCell.textField?.integerValue = row
                } else {
                    switch colID {
                    case "BL", "BM":
                        myCell.textField?.stringValue = (masterData.cd.valueForKey(colID) as SystemArrayAccess)[row] as String
                    case "BV", "BW", "BX":
                        myCell.textField?.floatValue = masterData.cd.valueForKey(colID) as Float
                    case "BO", "BS":    // Location and Destination
                        myCell.textField?.stringValue = (masterData.cd.valueForKey(colID + "d") as SystemArrayAccess)[row] as String
                    case "BN", "BT", "BU":
                        myCell.textField?.integerValue = (masterData.cd.valueForKey(colID) as SystemArrayAccess)[row] as Int
                    default:
                        logger.error("Personnel view asking for \(colID) but I don't know what that is.")
                    }
                }
                result = myCell
            } else {
                logger.error("Personnel view unable to find cell")
            }
        } else {
            logger.error("Personnel view unable to find column ID")
        }
        return result
    }
    @IBAction func updateConsumption(sender: NSTextField) {
        logger.debug("Setting value \(sender.stringValue) for \(sender.identifier)")
        masterData?.cd.setValue(sender.floatValue, forKey: sender.identifier)
    }
}
