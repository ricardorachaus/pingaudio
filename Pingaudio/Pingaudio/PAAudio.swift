//
//  PAAudio.swift
//  Pingaudio
//
//  Created by Rachaus on 31/05/17.
//  Copyright © 2017 Rachaus. All rights reserved.
//

import AVFoundation

public class PAAudio: PAAudioDataSource, PAAudioDelegate {
    var delegate: PAAudioDelegate?
    var path: URL
    var duration: CMTime
    fileprivate var asset: AVAsset?
    fileprivate var exporter: PAExporter?
    fileprivate var audio: PAAudio? {
        get {
            let resultAudio = exporter?.resultAudio
            if (exporter?.didExport)! {
                path = (resultAudio?.path)!
                self.asset = AVAsset(url: self.path)
                self.duration = (asset?.duration)!
                return resultAudio
            } else {
                return nil
            }
        }
    }
    
    public init(path: URL) {
        self.path = path
        asset = AVAsset(url: self.path)
        duration = (asset?.duration)!
        exporter = PAExporter()
    }
    
    func append(audio path: URL) {
        let composition = AVMutableComposition()
        let asset = AVAsset(url: path)
        PAAudioManager.add(asset: asset, ofType: AVMediaTypeAudio, to: composition, at: self.duration)
        exporter?.export(composition: composition, to: self.path)
        
    }
    
    func insert(at: CMTime) -> Bool {
        return true
    }
    
    func remove(intervalFrom begin: CMTime, to end: CMTime) -> PAAudio {
        return PAAudio(path: path)
    }
    
    func remove(outsideIntervalFrom begin: CMTime, to end: CMTime) -> PAAudio {
        return PAAudio(path: path)
    }
    
    func split(intervalsOfDuration duration: CMTime) -> [PAAudio] {
        return [PAAudio(path: path)]
    }
    
}
