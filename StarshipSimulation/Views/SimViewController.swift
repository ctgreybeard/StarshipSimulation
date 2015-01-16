//
//  SimViewController.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/28/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Cocoa

class SimViewController: NSViewController {

    /// The array of timers that update the view
    ///
    /// Built up by the view controller for the subsystem
    var viewUpdateTimers: [NSTimer] = []

    /// The active view update timers
    ///
    /// Created from viewUpdateTimers
    var activeViewUpdateTimers: [NSTimer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        logger.debug("Entry: \(self.className)")
    }

    /// Initializes the view update timer array 
    ///
    /// Subclasses should override this to add their own update timers using (for example):
    ///    override func createViewUpdateTimers() {
    ///        logger.debug("Entry")
    ///        if viewUpdateTimers.isEmpty {
    ///            viewUpdateTimers.append(NSTimer(timeInterval: aDouble, target: self, selector: aSelector, userInfo: nil, repeats: true))
    ///        }
    ///    }
    ///
    func createViewUpdateTimers() {
        logger.debug("Entry: \(self.className)")
    }


    /// Starts the view update timers, if any
    func startViewUpdateTimers() {
        logger.debug("Entry: \(self.className)")
        if activeViewUpdateTimers.isEmpty {
            for et in viewUpdateTimers {
                NSRunLoop.currentRunLoop().addTimer(et, forMode: NSDefaultRunLoopMode)
            }
        }
    }

    /// Stops and releases the view update timers
    func cancelViewUpdateTimers() {
        logger.debug("Entry: \(self.className)")
        for et in activeViewUpdateTimers {
            et.invalidate()
        }
        activeViewUpdateTimers = []
    }

    /// Start the timers before the view appears
    override func viewWillAppear() {
        super.viewWillAppear()
        logger.debug("Entry: \(self.className)")
        startViewUpdateTimers()
    }

    /// Does nothing for now
    override func viewDidAppear() {
        super.viewDidAppear()
        logger.debug("Entry: \(self.className)")
    }

    /// Stop the view update timers before the view disappears
    override func viewWillDisappear() {
        super.viewWillDisappear()
        logger.debug("Entry: \(self.className)")
        cancelViewUpdateTimers()
    }

    /// Does nothing for now
    override func viewDidDisappear() {
        super.viewDidDisappear()
        logger.debug("Entry: \(self.className)")
    }
}
