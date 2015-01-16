//
//  MasterData.swift
//  StarShipSimulation
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
            allModels[2] = comm
            funcModels[1] = comm
        }
    }
    var helm: Helm? {
        didSet {
            allModels[3] = comm
            funcModels[2] = comm
        }
    }
    var medical: Medical? {
        didSet {
            allModels[4] = comm
            funcModels[3] = comm
        }
    }
    var nav: Navigation? {
        didSet {
            allModels[5] = comm
            funcModels[4] = comm
        }
    }
    var sciences: Sciences? {
        didSet {
            allModels[6] = comm
            funcModels[5] = comm
        }
    }

    var allModels = [SimController?](count: 7, repeatedValue: nil)
    var funcModels = [SimController?](count: 6, repeatedValue: nil)

    init() {
        cd = CommonData()
    }
}

