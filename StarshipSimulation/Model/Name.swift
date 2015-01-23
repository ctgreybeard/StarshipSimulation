//
//  Name.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 1/13/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Cocoa

private var _givenNames: [String]?
private var _surNames: [String]?
private var _used: [Name.UsedName: Bool] = [:] // Protects against reusing a name combination

class Name {

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

    var given: String
    var sur: String

    class func loadFile(fileName file: String, inout into: [String]?) {
        let namefileURL = NSBundle.mainBundle().URLForResource(file, withExtension: "txt")
        if let goodURL = namefileURL {
            logger.info("Loading \(file) from \(goodURL)")
            let nameFile = NSString(contentsOfURL: goodURL, encoding: NSUTF8StringEncoding, error: nil)
            if let names = nameFile {
                into = names.componentsSeparatedByString("\n") as? [String]
            }
        } else {
            logger.error("Unable to load \(file)")
            into = ["NoName1", "NoName2", "NoName3"]
        }
    }

    class func loadNames() {
        if _givenNames == nil {
            loadFile(fileName: "givennames", into: &_givenNames)
            if _givenNames == nil {_givenNames = [String](count: 1000, repeatedValue: "James")} // Make it up if the file isn't found
        }
        if _surNames == nil {
            loadFile(fileName: "surnames", into: &_surNames)
            if _givenNames == nil {_surNames = [String](count: 1000, repeatedValue: "Kirk")}
        }
    }

    init?(gIndex: Int, sIndex: Int) {
        Name.loadNames()
        if _givenNames == nil || _surNames == nil || gIndex < 0 || gIndex >= _givenNames!.count || sIndex < 0 || sIndex >= _surNames!.count {
            given = "James"; sur = "Kirk"
            return nil
        }
        given = _givenNames![gIndex]
        sur = _surNames![sIndex]
        _used[UsedName(g: gIndex, s: sIndex)] = true
    }

    /// Generates a unique random name from _givenname and _surname
    convenience init?() {
        var gIndex: Int
        var sIndex: Int
        var trialUsed: UsedName

        // Ensure the name lists are loaded
        Name.loadNames()
        let gCount = _givenNames?.count ?? 1
        let sCount = _surNames?.count ?? 1
        do {
            gIndex = ssRandom(gCount)
            sIndex = ssRandom(sCount)
            trialUsed = UsedName(g: gIndex, s: sIndex)
        } while _used[trialUsed] != nil && _used[trialUsed] == true

        self.init(gIndex: gIndex, sIndex: sIndex)
    }

    func asString() -> String {
        return "\(given) \(sur)"
    }

}

func ==(lhs: Name.UsedName, rhs: Name.UsedName) -> Bool {
    return lhs.g == rhs.g && lhs.s == rhs.s
}

