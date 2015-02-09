//
//  PhotonTubesControl.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 2/3/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Cocoa

class PhotonTubesControl: NSViewController {

    @IBOutlet weak var tubeTV: NSTableView!
    @IBOutlet var tubeAC: NSArrayController!
    @IBOutlet var torpAC: NSArrayController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logger.debug("\(self.className) loaded")

        if let cd = masterData?.cd {
            tubeAC.bind(NSContentArrayBinding, toObject: cd, withKeyPath: "SSPhotonTubes", options: nil)
            tubeAC.bind(NSSortDescriptorsBinding, toObject: tubeTV, withKeyPath: NSSortDescriptorsBinding, options: nil)
            tubeTV.sortDescriptors = [NSSortDescriptor(key: "locationRaw", ascending: true)]
        } else {
            logger.error("Could not locate CommonData")
        }
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        logger.debug("\(self.className) appears")

    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
        logger.debug("\(self.className) disappears")

    }
    
}
