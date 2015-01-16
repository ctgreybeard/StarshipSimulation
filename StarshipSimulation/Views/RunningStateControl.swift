//
//  RunningStateControl.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/20/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Cocoa
// import XCGLogger

@IBDesignable class RunningStateControl: NSControl {

    // Action request
    var actionRequest: String?

    // Some constants
    let textFieldHeight = CGFloat(20.0)
    let buttonHeight = CGFloat(20.0)
    let unknownColor = NSColor.blueColor()
    let colors = ["Running": NSColor.greenColor(), "Stopped": NSColor.redColor(), "Paused": NSColor.yellowColor()]
    let runOrPause = ["Running": "Pause", "Stopped": "Pause", "Paused": "Run"]
    let startOrStop = ["Running": "Stop", "Stopped": "Start", "Paused": "Stop"]
    let stateText = ["Running": "Running", "Stopped": "Stopped", "Paused": "Paused"]
    let runPauseEnabled = ["Running": true, "Stopped": false, "Paused": true]

    // Content
    var subsystemNameField: NSTextField!
    var subsystemStateField: NSTextField!
    var subsystemElapsedField: NSTextField!
    var subsystemRunPauseButton: NSButton!
    var subsystemStartStopButton: NSButton!

    @IBInspectable var subsystemName: NSString! {
        didSet {
            if subsystemNameField != nil {
                subsystemNameField.stringValue = subsystemName ?? "Unknown"
            }
        }
    }

    @IBInspectable var subsystemState: NSString! {
        didSet {
            if subsystemStateField != nil {
                subsystemStateField.stringValue = subsystemState ?? "Unknown"
                subsystemStateField.backgroundColor = colors[subsystemState] ?? unknownColor
                subsystemRunPauseButton.title = runOrPause[subsystemState] ?? "Run?"
                subsystemRunPauseButton.enabled = runPauseEnabled[subsystemState] ?? true
                subsystemStartStopButton.title = startOrStop[subsystemState] ?? "Start?"
                layer?.borderColor = subsystemStateField.backgroundColor?.CGColor
            }
        }
    }

    var subsystemElapsed: NSTimeInterval! {
        didSet {
            if let etField = subsystemElapsedField {
                let et = Int(subsystemElapsed ?? 0.0)
                let h = et / 3600
                let m = et / 60 - h * 60
                let s = et - h * 3600 - m * 60
                logger.verbose("Elapsed: \(subsystemElapsed)")
                etField.stringValue = NSString(format: "Time: %2d:%02d:%02d", h, m, s)
            }
        }
    }

    override var flipped: Bool { return false }

    override init(frame frameRect: NSRect) {
        logger.debug("Entry")
        super.init(frame: frameRect)
        wantsLayer = true
        canDrawSubviewsIntoLayer = true
        addContent()
    }

    required init?(coder: NSCoder) {
        logger.debug("Entry")
        super.init(coder: coder)
        wantsLayer = true
        canDrawSubviewsIntoLayer = true
        addContent()
    }

    /// Add all content
    func addContent() {
        logger.debug("Entry")

        layer?.cornerRadius = 5.0
        layer?.borderWidth = 1.0
        layer?.borderColor = NSColor.blackColor().CGColor

        let buttonSize = NSSize(width: bounds.width / 2.0, height: buttonHeight)
        let titleSize = NSSize(width: bounds.width, height: textFieldHeight)

        // Set up the buttons/text bottom up

        // Run/Pause button
        let runPauseOrigin = NSPoint(x: 0, y: 0)
        let runPauseRect = NSRect(origin: runPauseOrigin, size: buttonSize)
        if subsystemRunPauseButton == nil {
            subsystemRunPauseButton = NSButton(frame: runPauseRect)
            addSubview(subsystemRunPauseButton)
        }

        // StartStop button
        let startStopOrigin = NSPoint(x: runPauseOrigin.x + buttonSize.width, y: runPauseOrigin.y)
        let startStopRect = NSRect(origin: startStopOrigin, size: buttonSize)
        if subsystemStartStopButton == nil {
            subsystemStartStopButton = NSButton(frame: startStopRect)
            addSubview(subsystemStartStopButton)
        }

        // Elapsed time
        let elapsedOrigin = NSPoint(x: runPauseOrigin.x, y: runPauseOrigin.y + buttonHeight)
        let elapsedRect = NSRect(origin: elapsedOrigin, size: titleSize)    // Same size
        if subsystemElapsedField == nil {
            subsystemElapsedField = NSTextField(frame: elapsedRect)
            addSubview(subsystemElapsedField)
        }

        // Sim state
        let stateOrigin = NSPoint(x: elapsedOrigin.x, y: elapsedOrigin.y + textFieldHeight)
        let stateRect = NSRect(origin: stateOrigin, size: titleSize)    // Same size
        if subsystemStateField == nil {
            subsystemStateField = NSTextField(frame: stateRect)
            addSubview(subsystemStateField)
        }

        // Sim control title
        let titleOrigin = NSPoint(x: stateOrigin.x, y: stateOrigin.y + textFieldHeight)
        let titleRect = NSRect(origin: titleOrigin, size: titleSize)

        if subsystemNameField == nil {
            subsystemNameField = NSTextField(frame: titleRect)
            subsystemNameField.font = NSFont.boldSystemFontOfSize(12.0)
            addSubview(subsystemNameField)
        }
        subsystemNameField.stringValue = subsystemName ?? "Unknown"

        let textFields = [subsystemNameField, subsystemStateField, subsystemElapsedField]
        for textField in textFields {
            textField.alignment = .CenterTextAlignment
            textField.editable = false
            textField.selectable = true
        }

        let buttons = [subsystemRunPauseButton, subsystemStartStopButton]
        for aButton in 0..<buttons.count {
            let myButton = buttons[aButton]
            myButton.action = "runStopClicked:"
            myButton.target = self
            myButton.tag = aButton
            // logger.debug("Button \(aButton) nextResponder=\(buttons[aButton].nextResponder)")
        }
        subsystemState = "Stopped"
        subsystemElapsed = 0.0
    }

    func runStopClicked(sender: NSButton) {
        logger.debug("Click! By: \(sender.tag), action: \(sender.title)")
        actionRequest = sender.title
        logger.debug("Sending \(action) to \(target)")
        sendAction(action, to: target)
    }
}
