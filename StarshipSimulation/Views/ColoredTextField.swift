//
//  ColoredTextField.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 2/4/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Cocoa

@IBDesignable class ColoredTextField: NSTextField {

    @IBInspectable dynamic var lowValue: Int
    @IBInspectable dynamic var hiValue: Int
    @IBInspectable dynamic var lowColor: NSColor
    @IBInspectable dynamic var hiColor: NSColor

    override var integerValue: Int {
        didSet {
            bgFromValue()
        }
    }

    required init?(coder: NSCoder) {
        lowColor = NSColor(SRGBRed: 0.95, green: 0.77, blue: 0.77, alpha: 1.0)
        hiColor = NSColor(SRGBRed: 0.77, green: 0.95, blue: 0.77, alpha: 1.0)
        lowValue = 0
        hiValue = 100
        super.init(coder: coder)
        drawsBackground = true
        logger.verbose("lowC=\(lowColor), hiC=\(hiColor), lowV=\(lowValue), hiV=\(hiValue)")
    }

    override func awakeFromNib() {
        logger.verbose("lowC=\(lowColor), hiC=\(hiColor), lowV=\(lowValue), hiV=\(hiValue)")
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }

    func bgFromValue() {
        let normInt = max(lowValue, min(hiValue, integerValue)) - lowValue
        let vFraction = Float(normInt) / Float(hiValue - lowValue)
        backgroundColor = lowColor.blendedColorWithFraction(CGFloat(vFraction), ofColor: hiColor)
    }

    override func viewWillDraw() {
        let vFraction: CGFloat = 0.5
        bgFromValue()
        super.viewWillDraw()
    }
    
}
