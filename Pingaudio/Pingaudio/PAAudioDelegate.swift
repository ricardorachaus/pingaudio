//
//  PAAudioDelegate.swift
//  Pingaudio
//
//  Created by Rachaus on 31/05/17.
//  Copyright © 2017 Rachaus. All rights reserved.
//

import AVFoundation

protocol PAAudioDelegate {
    /**
     Append an audio file at the end of current audio.
     - Parameter path: path to the audio file to append.
     - Parameter completion: a block to be executed when appending is complete, wheter it succeeds or fail.
     */
    func append(audio path: URL, completion: @escaping (_ output: Bool) -> Void)
    
    /**
     Remove the interval defined by `begin` and `end` from the audio.
     - Parameter begin: begin of the interval to be removed.
     - Parameter end: end of the interval to be removed.
     - Parameter completion: a block to be executed when removing is complete, wheter it succeeds or fail.
     */
    func remove(intervalFrom begin: CMTime, to end: CMTime, completion: @escaping(_ output: PAAudio?) -> Void)
    
    /**
     Remove the audio outside the interval defined by `begin` and `end` from the audio, leaving the interval untouched.
     - Parameter begin: begin of the interval to be removed.
     - Parameter end: end of the interval to be removed.
     - Parameter completion: a block to be executed when removing is complete, wheter it succeeds or fail.
     */
    func remove(outsideIntervalFrom begin: CMTime, to end: CMTime, completion: @escaping(_ output: PAAudio?) -> Void)
}
