//
//  ObservedChange.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 1/30/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//




import Foundation

typealias ChangeDict = [NSObject: AnyObject]
typealias UsefulChangeDict = [String: AnyObject]

/// A collection of registered observers with methods to register and remove them all at once
class Observers: NSObject {
    let observersBag: NSMutableSet

    override init() {
        observersBag = NSMutableSet()
        super.init()
        logger.debug("New \(self.className)")
    }

    /// Perform addObserver for the requestd target and options
    func registerObserver(observer: Observer) {
        observer.target.addObserver(observer.observer, forKeyPath: observer.keyPath, options: observer.options, context: observer.context)
    }

    /// Perform removeObserver for the requested target and options
    func deRegisterObserver(observer: Observer) {
        observer.target.removeObserver(observer.observer, forKeyPath: observer.keyPath, context: observer.context)
    }

    /// Register all observers in the Bag
    func registerAllObservers() {
        for o in observersBag {
            registerObserver(o as Observer)
        }
    }

    /// deRegister all observers in the Bag
    func deRegisterAllObservers() {
        for o in observersBag {
            deRegisterObserver(o as Observer)
        }
    }

    /// Create a new Observer, add it to the Bag and register with the Target
    func addObserver(observer: NSObject, target: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions, context: UnsafeMutablePointer<Void>) -> Observer {
        let newO = Observer(target: target, observer: observer, keyPath: keyPath, options: options, context: context)
        addObserver(newO)
        return newO
    }

    /// Add an Observer to the Bag and register it with the Target
    func addObserver(observer: Observer) {
        observersBag.addObject(observer)
        registerObserver(observer)
    }

    /// Remove an Observer from the Bag and optionally deRegister it with the Target
    func dropObserver(oldO: Observer, deRegister: Bool = true) {
        if deRegister {
            deRegisterObserver(oldO)
        }
        observersBag.removeObject(oldO)
    }

    func dropObserver(observer: NSObject, target: NSObject, forKeyPath keyPath: String, context: UnsafeMutablePointer<Void>, deRegister: Bool = true) {
        let tempO = Observer(target: target, observer: observer, keyPath: keyPath, options: nil, context: context)
        dropObserver(tempO, deRegister: deRegister)
    }

    func dropAllObservers(deRegister: Bool = true) {
        if deRegister {
            for o in observersBag {
                deRegisterObserver(o as Observer)
            }
        }
        observersBag.removeAllObjects()
    }
}

/// A KVO observer description
class Observer: NSObject, Hashable, Equatable {
    let target: NSObject
    let observer: NSObject
    let keyPath: String
    let options: NSKeyValueObservingOptions
    let context: UnsafeMutablePointer<Void>

    override var hashValue: Int {return target.hashValue &+ observer.hashValue &+ keyPath.hashValue &+ context.hashValue}

    init(target: NSObject, observer: NSObject, keyPath: String, options: NSKeyValueObservingOptions, context: UnsafeMutablePointer<Void>) {
        self.target = target
        self.observer = observer
        self.keyPath = keyPath
        self.options = options
        self.context = context
        super.init()
    }
}

func ==(lhs: Observer, rhs: Observer) -> Bool {
    return lhs.target === rhs.target && lhs.keyPath == rhs.keyPath
}

class ObservedChange: NSObject {

    let kindString: [NSKeyValueChange: String] = [
        .Replacement: ".Replacement",
        .Insertion: ".Insertion",
        .Removal: ".Removal",
        .Setting: ".Setting"]

    let cdict: UsefulChangeDict
    let kind: NSKeyValueChange
    let kindStr: String
    let prior: Bool
    let indexes: NSIndexSet?
    let changeNew: AnyObject?
    let changeOld: AnyObject?

    init(_ change: ChangeDict) {
        cdict = change as UsefulChangeDict
        kind = NSKeyValueChange(rawValue: UInt(cdict[NSKeyValueChangeKindKey] as NSNumber))!
        kindStr = kindString[kind] ?? ".???"
        prior = (cdict[NSKeyValueChangeNotificationIsPriorKey] as? NSNumber) == NSNumber(bool: true)
        indexes = cdict[NSKeyValueChangeIndexesKey] as? NSIndexSet
        changeNew = cdict[NSKeyValueChangeNewKey]
        changeOld = cdict[NSKeyValueChangeOldKey]
        super.init()
    }
}