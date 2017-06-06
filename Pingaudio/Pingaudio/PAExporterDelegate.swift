//
//  PAExporterDelegate.swift
//  Pingaudio
//
//  Created by Miguel Nery on 01/06/17.
//  Copyright © 2017 Rachaus. All rights reserved.
//

import AVFoundation

protocol PAExporterDelegate {
    
    /**
     Export the tracks in `composition` to a .m4a file.
     - Parameter composition: Composition to be exported.
     - Parameter completion: A block to be executed when exporting is complete, wheter it succeeds or fail. The ouptut of the export is an `URL` pointing to the result audio in a temporary directory.
     - Parameter output: Path to the exported file if it succeeds, or `nil` if it fails.
     */
    func export(composition: AVMutableComposition, completion: @escaping (_ output: URL?) -> Void)
    
    /**
     Export the tracks in `composition` to a .m4a file. Only the range specified by `time` will be exported.
     - Parameter composition: Composition to be exported.
     - Parameter time: Interval to be exported in the audio.
     - Parameter completion: A block to be executed when exporting is complete, wheter it succeeds or fail. The ouptut of the export is an `URL` pointing to the result audio in a temporary directory.
     - Parameter output: Path to the exported file if it succeeds, or `nil` if it fails.
     */
    func export(composition: AVMutableComposition, in time: CMTimeRange, completion: @escaping (_ output: URL?) -> Void)
}
