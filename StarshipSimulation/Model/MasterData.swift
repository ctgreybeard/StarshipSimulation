//
//  MasterData.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/29/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Foundation

var masterData: MasterData!

/// Holds simulation-wide data
struct MasterData {
    var cd: CommonData
    var master: MasterController? {
        didSet {
            allModels[0] = master
        }
    }
    var comm: Communications? {
        didSet {
            allModels[1] = comm
            funcModels[0] = comm
        }
    }
    var eng: Engineering? {
        didSet {
            allModels[2] = eng
            funcModels[1] = eng
        }
    }
    var helm: Helm? {
        didSet {
            allModels[3] = helm
            funcModels[2] = helm
        }
    }
    var medical: Medical? {
        didSet {
            allModels[4] = medical
            funcModels[3] = medical
        }
    }
    var nav: Navigation? {
        didSet {
            allModels[5] = nav
            funcModels[4] = nav
        }
    }
    var sciences: Sciences? {
        didSet {
            allModels[6] = sciences
            funcModels[5] = sciences
        }
    }

    var allModels = [SimController?](count: 7, repeatedValue: nil)
    var funcModels = [SimController?](count: 6, repeatedValue: nil)

    init() {
        logger.debug("Entry")
        cd = CommonData()
    }
}

