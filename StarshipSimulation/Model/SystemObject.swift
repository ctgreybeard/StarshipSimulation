//
//  SystemObject.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 1/13/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Foundation

/// Each case is the exact name of the class that it refers to, the value is a unique string
enum SOTAG: String {
    case AtmosphericSensor = "ASENS"
    case Cargo = "CAR"
    case CelestialObject = "CO"
    case CloakingDevice = "CLOAK"
    case CommunicationsComputer = "CCOMP"
    case CommunicationsStation = "COMM"
    case DeflectorShield = "DSHIELD"
    case DetentionCell = "DCELL"
    case EnemyShip = "ESHIP"
    case EnergyConnectionStation = "ENERGY"
    case EnterprisePerson = "EPERS"
    case FederationPerson = "FPERS"
    case FleetShip = "FSHIP"
    case GravitySensor = "GSENS"
    case ImpulseEngine = "IMPE"
    case IntensiveCareUnit = "ICARE"
    case LifeFormsSensor = "LFSENS"
    case LifeSupport = "LS"
    case Location = "LOC"
    case MedicalComputer = "MCOMP"
    case MedicalResearchLab = "MLAB"
    case NavigationComputer = "NCOMP"
    case PhaserStation = "PHASER"
    case PhotonTorpedo = "PTORP"
    case PhotonTube = "PTUBE"
    case RadiationSensor = "RSENS"
    case Rank = "RANK"
    case Sensor = "SENS"
    case ShuttleCraft = "SCRAFT"
    case SpatialPosition = "SPOS"
    case SpatialVolume = "SVOL"
    case SystemArray = "SA"
    case SystemArrayAccess = "SAA"
    case SystemArrayObject = "SAO"
    case SystemObject = "SO"
    case SystemStatus = "SS"
    case TractorBeam = "TBEAM"
    case TransporterStation = "TPORT"
    case TurboElevatorCar = "TEC"
    case TurboElevatorStation = "TES"
    case TurboElvatorComputer = "TCOMP"
    case Velocity = "VEL"
    case WarpEngine = "WARPE"
    case Weapon = "OUCH"
    // A special case for testing
    case Test = "TEST"
}

/// MARK: This is dumb. I should be able to enumerate the enum ... initializing the array would be much simpler ...

/// SystmObject instance counters
var numSO: [SOTAG: Int] = [
    SOTAG.AtmosphericSensor: 0,
    SOTAG.Cargo: 0,
    SOTAG.CelestialObject: 0,
    SOTAG.CloakingDevice: 0,
    SOTAG.CommunicationsComputer: 0,
    SOTAG.CommunicationsStation: 0,
    SOTAG.DeflectorShield: 0,
    SOTAG.DetentionCell: 0,
    SOTAG.EnemyShip: 0,
    SOTAG.EnergyConnectionStation: 0,
    SOTAG.EnterprisePerson: 0,
    SOTAG.FederationPerson: 0,
    SOTAG.FleetShip: 0,
    SOTAG.GravitySensor: 0,
    SOTAG.ImpulseEngine: 0,
    SOTAG.IntensiveCareUnit: 0,
    SOTAG.LifeFormsSensor: 0,
    SOTAG.LifeSupport: 0,
    SOTAG.Location: 0,
    SOTAG.MedicalComputer: 0,
    SOTAG.MedicalResearchLab: 0,
    SOTAG.NavigationComputer: 0,
    SOTAG.PhaserStation: 0,
    SOTAG.PhotonTorpedo: 0,
    SOTAG.PhotonTube: 0,
    SOTAG.RadiationSensor: 0,
    SOTAG.Rank: 0,
    SOTAG.Sensor: 0,
    SOTAG.ShuttleCraft: 0,
    SOTAG.SpatialPosition: 0,
    SOTAG.SpatialVolume: 0,
    SOTAG.SystemArray: 0,
    SOTAG.SystemArrayAccess: 0,
    SOTAG.SystemArrayObject: 0,
    SOTAG.SystemObject: 0,
    SOTAG.SystemStatus: 0,
    SOTAG.TractorBeam: 0,
    SOTAG.TransporterStation: 0,
    SOTAG.TurboElevatorCar: 0,
    SOTAG.TurboElevatorStation: 0,
    SOTAG.TurboElvatorComputer: 0,
    SOTAG.Velocity: 0,
    SOTAG.WarpEngine: 0,
    SOTAG.Weapon: 0,
    SOTAG.Test: 0
]

/// MARK: An alternate idea would be to use .className to index the tag and counter arrays ...

/// System Object ID - Tag and instance counter
class SOID: NSObject, Printable, DebugPrintable, Equatable, Hashable, NSCopying {
    let tag: SOTAG
    let counter: Int

    init(tag: SOTAG) {
        self.tag = tag
        if numSO[tag] != nil {
            counter = ++numSO[tag]!
        } else {
            logger.error("No place to put \(tag.rawValue)")
            counter = -1
        }
        super.init()
    }

    private init(id: SOID) {
        tag = id.tag
        counter = id.counter
        super.init()
    }

    override var hashValue: Int {return description.hashValue}

    override var description: String {return "\(tag.rawValue)\(counter)"}

    override var debugDescription: String {return "\(self.className)(tag: \(tag.rawValue), counter: \(counter))"}

    func copyWithZone(zone: NSZone) -> AnyObject {
        let newOne = SOID(id: self)
        return newOne
    }
}

func ==(lhs: SOID, rhs: SOID) -> Bool {
    return lhs.tag == rhs.tag && lhs.counter == rhs.counter
}

/// Base System Object for all simulation objects
class SystemObject: NSObject, Printable {
    // Null common class
    var soID: SOID!
    var soidHistory: [SOID]

    required override init() {
        soID = SOID(tag: .SystemObject)
        soidHistory = []
        super.init()
    }

    func mkSOID(tag: SOTAG) {
        soidHistory.append(soID)
        soID = SOID(tag: tag)
    }

    override var description: String {return "\(self.className)(\(soID.description))"}
}

/// An accessable array of any SystemArrayObject instances
class SystemArray: SystemObject {
    private var _array: NSMutableArray
    var count: Int {return _array.count}
    var array: NSArray {return NSArray(array: _array)}

    /// Primary initializer, used most frequently to init a SystemArray
    convenience init(num: Int, withType with: SystemArrayObject.Type)  {
        var _array = [SystemArrayObject]()
        for i in 0..<num {
            let z = with.self()
            _array.append(z)
        }
        self.init(with: _array)
    }

    /// Create an empty SystemArray
    convenience required init() {
        self.init(with: [SystemArrayObject]())
    }

    /// Create a new SystemArray with supplied array
    init(with array: [SystemArrayObject]) {
        _array = NSMutableArray(array: array)
        super.init()
        mkSOID(.SystemArray)

    }

    /// Treat a SystemArray like a regular array
    subscript(i: Int) -> SystemArrayObject? {
        get {
            if i >= 0 && i < _array.count {
                return _array[i] as? SystemArrayObject
            } else {
                return nil
            }
        }
        set {
            if i >= 0 && i < _array.count {
                willChange(.Replacement, valuesAtIndexes: NSIndexSet(index: i), forKey: "array")
                _array[i] = newValue!
                didChange(.Replacement, valuesAtIndexes: NSIndexSet(index: i), forKey: "array")
            }
        }
    }

    /// Appends item to the end of the arrsy and returns the index
    func append(new1: SystemArrayObject) -> Int {
        willChange(.Insertion, valuesAtIndexes: NSIndexSet(index: _array.count), forKey: "array")
        _array.addObject(new1)
        didChange(.Insertion, valuesAtIndexes: NSIndexSet(index: _array.count - 1), forKey: "array")
        return _array.count - 1
    }

    /// Remove the item at index and return it
    func removeAtIndex(index: Int) -> SystemArrayObject? {
        var temp: SystemArrayObject?
        if index >= 0 && index < _array.count {
            temp = _array[index] as? SystemArrayObject
            willChange(.Removal, valuesAtIndexes: NSIndexSet(index: index), forKey: "array")
            _array.removeObjectAtIndex(index)
            didChange(.Removal, valuesAtIndexes: NSIndexSet(index: index), forKey: "array")
        }
        return temp
    }

    /// Insert the item at index
    func insertObject(newOne: SystemArrayObject, atIndex index: Int) {
        if index >= 0 && index < _array.count {
            willChange(.Insertion, valuesAtIndexes: NSIndexSet(index: index), forKey: "array")
            _array.insertObject(newOne, atIndex: index)
            didChange(.Insertion, valuesAtIndexes: NSIndexSet(index: index), forKey: "array")
        }
    }
}

/// Contents of SystemArray, subclasses must implement copyWithZone
class SystemArrayObject: SystemObject, NSCopying {

    func copyWithZone(zone: NSZone) -> AnyObject {
        logger.verbose("Copying SAO \(soID)")
        return SystemArrayObject()
    }

    required init() {
        super.init()
        mkSOID(.SystemArrayObject)
    }
}

/// Key access to SystemArray
class SystemArrayAccess: SystemObject {
    private var _source: SystemArray
    private var _members: [String]?
    private var _ro: Bool

    convenience init(source: SystemArray) {
        self.init(source: source, members: nil, readOnly: true)
    }

    convenience init(source: SystemArray, member: String, readOnly ro: Bool = false) {
        self.init(source: source, members: [member], readOnly: ro)
    }

    init(source: SystemArray, members: [String]?, readOnly ro: Bool = false) {
        _source = source
        _members = members
        _ro = ro
        super.init()
        mkSOID(.SystemArrayAccess)
    }

    required convenience init() {
        self.init(source: SystemArray(), members: nil)
    }

    func setSource(newSource: SystemArray) {
        _source = newSource
    }

    subscript(i: Int) -> AnyObject? {
        get {
            var value: AnyObject? = nil
            if let l1sao = _source[i] {
                if let mems = _members {
                    value = l1sao.valueForKeyPath(mems[0])
                } else {
                    value = l1sao
                }
            }
            return value
        }
        set {
            if !_ro {
                if _members != nil {
                    _source[i]?.setValue(newValue, forKeyPath: _members![0])
                } else {
                    _source[i] = (newValue as SystemArrayObject)
                }
            }
        }
    }

    /// TODO: Clean up the code below
    subscript(i: Int, j: Int) -> AnyObject? {
        get {
            var value: AnyObject?
            if _members != nil && _members?.count == 2 {
                value = (_source[i]?.valueForKeyPath(_members![0])?[j] as NSObject).valueForKeyPath(_members![1])
            }
            return value
        }
        set {
            if !_ro {
                if _members != nil && _members?.count == 2 {
                    (_source[i]?.valueForKeyPath(_members![0])?[j] as NSObject).setValue(newValue, forKeyPath: _members![1])
                }
            }
        }
    }
}