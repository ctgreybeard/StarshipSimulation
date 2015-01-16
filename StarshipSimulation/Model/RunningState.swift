//
//  RunningState.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/29/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Foundation

/// Simulation running state
///
/// - Stop  - Simulation stopped, will need reinitialization for restart
/// - Run   - Simulation initializd and running
/// - Pause - Simulation clock stopped, can be resumed
public class RunningState: NSObject {

    /// Simulation running states
    ///
    /// - Stop - Simulation stooped, requires reinitialization
    /// - Run - Simulation running
    /// - Pause - Simulation paused, may be restarted
    public enum RunValue {
        case Stop, Run, Pause
    }

    // Private instance variables
    private var _runValue = RunValue.Stop
    private var _startTime: NSDate?
    var startTime: NSDate? {return _startTime}
    private var _elapsedTime: NSTimeInterval = 0.0

    // Observable values indicating run state
    dynamic var stateLabel: String = "Initializing"
    dynamic var isRunning: Bool { return _runValue == .Run }
    dynamic var isStopped: Bool { return _runValue == .Stop }
    dynamic var isPaused: Bool { return _runValue == .Pause }

    /// Internal representation of run state, sets stateLabel as side effect
    var runValue: RunValue {
        get { return _runValue }
        set {
            switch newValue {
            case .Stop:
                stateLabel = "Stopped"
                _startTime = nil
                _elapsedTime = 0.0
            case .Run:
                stateLabel = "Running"
                if _startTime == nil {
                    _startTime = NSDate()
                    _elapsedTime = 0.0
                } else if _runValue == .Pause {
                    _startTime = NSDate().dateByAddingTimeInterval(-elapsedTime)
                }
            case .Pause:
                stateLabel = "Paused"
                if _runValue == .Run {
                    _elapsedTime = NSDate().timeIntervalSinceDate(_startTime!)
                }
            }
            _runValue = newValue
        }
    }

    /// Computed elapsed simulation time
    var elapsedTime: NSTimeInterval {
        switch runValue {
        case .Stop:
            break
        case .Run:
            if _startTime != nil {
                _elapsedTime = NSDate().timeIntervalSinceDate(_startTime!)
            } else {
                _startTime = NSDate()
                _elapsedTime = 0.0
            }
        case .Pause:
            break
        }
        return _elapsedTime
    }
}