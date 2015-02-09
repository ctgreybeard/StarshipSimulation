//
//  ColoredTextField.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 2/4/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Cocoa

@IBDesignable class ColoredTextField: NSTextField {

    @IBInspectable dynamic var lowValue: Int = 0
    @IBInspectable dynamic var hiValue: Int = 100
    @IBInspectable dynamic var lowColor: NSColor = NSColor(SRGBRed: 0.95, green: 0.77, blue: 0.77, alpha: 1.0)
    @IBInspectable dynamic var hiColor: NSColor = NSColor(SRGBRed: 0.77, green: 0.95, blue: 0.77, alpha: 1.0)
    var oldFraction: Float = -1.0   // An impossible value, forces first background setting

    /// Respond to changes by setting the background color
    override var integerValue: Int {
        didSet {
            if oldValue != integerValue {
                logger.debug("didSet")
                bgFromValue()
            }
        }
    }

    /// Ensure that we actually affect the background
    override func awakeFromNib() {
        logger.verbose("awakeFromNib, Lo=\(lowValue), Hi=\(hiValue), lowColor=\(lowColor), hiColor=\(hiColor)")
        drawsBackground = true
    }

    /// Set the backgroundColor from the integerValue
    func bgFromValue() {
        let vFraction = Float(max(lowValue, min(hiValue, integerValue)) - lowValue) / Float(max(1, hiValue - lowValue))
        if abs(vFraction - oldFraction) > 0.1 {
            let newBackgroundColor = lowColor.blendedColorWithFraction(CGFloat(vFraction), ofColor: hiColor)
            oldFraction = vFraction
            backgroundColor = newBackgroundColor
            logger.verbose("Value=\(integerValue), Fraction=\(vFraction)")
        }
    }

    /// Make sure we know what the backgroundColor is
    override func viewWillDraw() {
        logger.verbose("viewWillDraw")
        bgFromValue()
        super.viewWillDraw()
    }
    
}
