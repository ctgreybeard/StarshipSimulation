//
//  EnterprisePresonnelControl.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 1/18/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Cocoa

class EnterprisePersonnelControl: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate {

    @IBOutlet weak var tvEPers: NSTableView!
    @IBOutlet weak var fldFoodConsumption: NSTextField!
    @IBOutlet weak var fldWaterConsumption: NSTextField!
    @IBOutlet weak var fldO2Consumption: NSTextField!
//    weak var cd: CommonData?

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
        masterData?.cd.addObserver(self, forKeyPath: "foodConsumption", options: .New, context: nil)
        masterData?.cd.addObserver(self, forKeyPath: "waterConsumption", options: .New, context: nil)
        masterData?.cd.addObserver(self, forKeyPath: "oxygenConsumption", options: .New, context: nil)
    }

    override func viewWillDisappear() {
        logger.debug("Entry")
        masterData?.cd.removeObserver(self, forKeyPath: "foodConsumption")
        masterData?.cd.removeObserver(self, forKeyPath: "waterConsumption")
        masterData?.cd.removeObserver(self, forKeyPath: "oxygenConsumption")
        super.viewWillDisappear()
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return masterData?.cd.BK ?? 0
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        logger.debug("Entry: key: \(keyPath)")
        var fld: NSTextField?
        let cd = masterData?.cd

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

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var result: NSView?

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
