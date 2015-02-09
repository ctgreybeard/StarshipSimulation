//
//  Name.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 1/13/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Cocoa

private var _givenNames: [String]!
private var _surNames: [String]!
private var _used: [Name.UsedName: Bool] = [:] // Protects against reusing a name combination


class Name: SystemObject, NSCopying {

    class UsedName: Hashable {
        let g: Int, s: Int

        init(g: Int, s: Int) {
            self.g = g
            self.s = s
        }

        var hashValue: Int {
            return g * 100000 + s
        }
    }

    let given: String
    let sur: String

    class func loadFile(fileName file: String) -> [String] {
        let namefileURL = NSBundle.mainBundle().URLForResource(file, withExtension: "txt")
        var into = ["NoName1", "NoName2", "NoName3"]    // fallback name list
        if let goodURL = namefileURL {
            logger.info("Loading \(file).txt from \(goodURL)")
            let nameFile = NSString(contentsOfURL: goodURL, encoding: NSUTF8StringEncoding, error: nil)
            if let names = nameFile {
                into = names.componentsSeparatedByString("\n") as! [String]
            }
        } else {
            logger.error("Unable to load \(file).txt")
        }
        return into
    }

    class func loadNames() {
        var toNames = [String]()
        if _givenNames == nil {
            _givenNames = loadFile(fileName: "givennames")
            if _givenNames == nil {_givenNames = [String](count: 1000, repeatedValue: "James")} // Make it up if the file isn't found
        }
        if _surNames == nil {
            _surNames = loadFile(fileName: "surnames")
            if _givenNames == nil {_surNames = [String](count: 1000, repeatedValue: "Kirk")}
        }
    }

    init(gIndex: Int, sIndex: Int) {
        Name.loadNames()
        if _givenNames == nil || _surNames == nil || gIndex < 0 || gIndex >= _givenNames!.count || sIndex < 0 || sIndex >= _surNames!.count {
            given = "James"; sur = "Kirk"
        } else {
            given = _givenNames![gIndex]
            sur = _surNames![sIndex]
            _used[UsedName(g: gIndex, s: sIndex)] = true
        }
        super.init()
        mkSOID(.Name)
    }

    init(g: String, s: String) {
        given = g
        sur = s
        super.init()
        mkSOID(.Name)
    }

    /// Generates a unique random name from _givenname and _surname
    convenience required init() {
        var gIndex: Int
        var sIndex: Int
        var trialUsed: UsedName

        // Ensure the name lists are loaded
        Name.loadNames()
        let gCount = _givenNames?.count ?? 1
        let sCount = _surNames?.count ?? 1
        var loopLimit = 1000    // Stop after 1000 names
        do {
            gIndex = ssRandom(gCount)
            sIndex = ssRandom(sCount)
            trialUsed = UsedName(g: gIndex, s: sIndex)
        } while _used[trialUsed] != nil && _used[trialUsed] == true && loopLimit-- > 0

        self.init(gIndex: gIndex, sIndex: sIndex)
    }

    convenience init(name: String) {
        let names = name.componentsSeparatedByString(" ")
        self.init(g: names[0] ?? "", s: names[1] ?? "")
    }

    func asString() -> String {
        return "\(given) \(sur)"
    }

    func copyWithZone(zone: NSZone) -> AnyObject {
        return Name(g: given, s: sur)
    }
}

func ==(lhs: Name.UsedName, rhs: Name.UsedName) -> Bool {
    return lhs.g == rhs.g && lhs.s == rhs.s
}

