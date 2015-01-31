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
    case Name = "NAME"
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

/// SystmObject instance counters
var numSO: [SOTAG: Int] = [:]

/// MARK: An alternate idea would be to use .className to index the tag and counter arrays ...

/// System Object ID - Tag and instance counter
class SOID: NSObject, Printable, DebugPrintable, Equatable, Hashable, NSCopying {
    let tag: SOTAG
    let counter: Int

    init(tag: SOTAG) {
        self.tag = tag
        if numSO[tag] != nil {
            numSO[tag]! += 1
        } else {
            numSO[tag] = 1
        }
        counter = numSO[tag]!
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

    func compare(other: SOID) -> NSComparisonResult {
        var c1 = tag.rawValue.compare(other.tag.rawValue)
        if c1 == .OrderedSame {
            c1 = NSNumber(integer: counter).compare(NSNumber(integer: other.counter))
        }
        return c1
    }

    func copyWithZone(zone: NSZone) -> AnyObject {
        let newOne = SOID(id: self)
        return newOne
    }
}

func ==(lhs: SOID, rhs: SOID) -> Bool {
    return lhs.tag == rhs.tag && lhs.counter == rhs.counter
}

/// Base System Object for all simulation objects
class SystemObject: NSObject, Printable, Equatable {
    // Null common class
    var soID: SOID!
    var soidHistory: [SOID]

    required override init() {
        soidHistory = []
        super.init()
        mkSOID(.SystemObject)
    }

    func mkSOID(tag: SOTAG) {
        soID = SOID(tag: tag)
        soidHistory.append(soID)
    }

    override var description: String {return "\(self.className)(\(soID.description))"}
}

func ==(lhs: SystemObject, rhs: SystemObject) -> Bool {
    return lhs.soID == rhs.soID
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

typealias SystemArray = NSMutableArray

/// Make a new SystemArray populated with new SystemArrayObjects
func SSMakeSystemArray(count num: Int, withType with: SystemArrayObject.Type) -> SystemArray {
    var newArray = SystemArray(capacity: num)
    for i in 0..<num {
        newArray.addObject(with.self())
    }
    return newArray
}

/// Make a new SystemArray populated with new SystemArrayObjects
func SSMakeSystemArray(withArray array: [SystemArrayObject]) -> SystemArray {
    var newArray = SystemArray(capacity: array.count)
    newArray.setArray(array)
    return newArray
}

/// Key access to SystemArray
class SystemArrayAccess: SystemObject {
    private var _array: SystemArray
    private var _members: [String]?
    private var _ro: Bool

    dynamic var array: SystemArray {return _array}

    //class func automaticallyNotifiesObserversOfArray() -> Bool {return false}

    convenience init(source: SystemArray, readOnly ro: Bool = true) {
        self.init(source: source, members: nil, readOnly: ro)
    }

    convenience init(source: SystemArray, member: String, readOnly ro: Bool = false) {
        self.init(source: source, members: [member], readOnly: ro)
    }

    init(source: SystemArray, members: [String]?, readOnly ro: Bool = false) {
        _array = source
        _members = members
        _ro = ro
        super.init()
        mkSOID(.SystemArrayAccess)
    }

    required convenience init() {
        self.init(source: SystemArray(), members: nil)
    }

    var count: Int {return _array.count}

    func setSource(newSource: SystemArray) {
        willChangeValueForKey("array")
        _array = newSource
        didChangeValueForKey("array")
    }

    func objectAtIndex(i: Int) -> SystemArrayObject? {
        if i >= 0 && i < _array.count {return (_array.objectAtIndex(i) as SystemArrayObject)}
        else {return nil}
    }

    func replaceObjectAtIndex(i: Int, withObject object: SystemArrayObject) {
        if i >= 0 && i < _array.count {
            willChange(.Replacement, valuesAtIndexes: NSIndexSet(index: i), forKey: "array")   // Handle any KVO
            _array.replaceObjectAtIndex(i, withObject: object)
            didChange(.Replacement, valuesAtIndexes: NSIndexSet(index: i), forKey: "array")
        }
    }

    subscript(i: Int) -> AnyObject? {
        get {
            var value: AnyObject?
            if let l1sao = self.objectAtIndex(i) {
                if  _members?.count == 1 {
                    value = l1sao.valueForKeyPath(_members![0])
                } else if _members == nil {
                    value = l1sao
                } else {
                    logger.error("Subscript count mismatch")
                }
            }
            return value
        }
        set {
            if !_ro {
                if _members?.count == 1 {
                    objectAtIndex(i)?.setValue(newValue, forKeyPath: _members![0])
                } else if _members == nil {
                    replaceObjectAtIndex(i, withObject: newValue as SystemArrayObject)
                } else {
                    logger.error("Subscript count mismatch")
                }
            }
        }
    }

    /// TODO: Clean up the code below
    subscript(i: Int, j: Int) -> AnyObject? {
        get {
            var value: AnyObject?
            if _members != nil && _members!.count == 2 {
                value = (self[i]?.valueForKeyPath(_members![0])?[j] as? SystemArrayObject)?.valueForKeyPath(_members![1])
            } else {
                logger.error("Subscript count mismatch")
            }
            return value
        }
        set {
            if !_ro {
                if _members != nil && _members?.count == 2 {
                    (objectAtIndex(i)?.valueForKeyPath(_members![0])?[j] as? SystemArrayObject)?.setValue(newValue, forKeyPath: _members![1])
                } else {
                    logger.error("Subscript count mismatch")
                }
            } else {
                logger.warning("Trying to update readOnly array")
            }
        }
    }

    /// Appends item to the end of the array and returns the index
    func append(new1: SystemArrayObject) -> Int {
        let aCount = _array.count
        willChange(.Insertion, valuesAtIndexes: NSIndexSet(index: aCount), forKey: "array")
        _array.addObject(new1)
        didChange(.Insertion, valuesAtIndexes: NSIndexSet(index: aCount), forKey: "array")
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
        if index >= 0 && index <= _array.count {
            willChange(.Insertion, valuesAtIndexes: NSIndexSet(index: index), forKey: "array")
            _array.insertObject(newOne, atIndex: index)
            didChange(.Insertion, valuesAtIndexes: NSIndexSet(index: index), forKey: "array")
        } else {
            logger.warning("Subscript out of range for insertObject")
        }
    }
}