//
//  PAAudioManagerDelegate.swift
//  Pingaudio
//
//  Created by Rachaus on 31/05/17.
//  Copyright © 2017 Rachaus. All rights reserved.
//

import AVFoundation

protocol PAAudioManagerDelegate {
    /**
     Merge multiple audios in one single audio. The audios are appended, in the order they come in the `audios` array, to the first audio of the array.
     - Parameter audios: Array containing the audios.
     - Parameter completion: a block to be executed when merging is complete, wheter it succeeds or fail. The ouptut of the merge is an `URL` pointing to the merged audio in a temporary directory.
     - Parameter output: Path to the merged file if it succeeds, or `nil` if it fails.
     */
    func merge(audios: [PAAudio], completion: @escaping (_ output: URL?) -> Void)
}
