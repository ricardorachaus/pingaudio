//
//  PAAudioDelegate.swift
//  Pingaudio
//
//  Created by Rachaus on 31/05/17.
//  Copyright © 2017 Rachaus. All rights reserved.
//

import AVFoundation

protocol PAAudioDelegate {
    func append(audio path: URL)
    func insert(at: CMTime) -> Bool
    func remove(intervalFrom begin: CMTime, to end: CMTime) -> PAAudio
    func remove(outsideIntervalFrom begin: CMTime, to end: CMTime) -> PAAudio
    func split(intervalsOfDuration duration: CMTime) -> [PAAudio]
}
