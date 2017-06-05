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
    public var path: URL
    var duration: CMTime
    fileprivate var asset: AVAsset?
    fileprivate var exporter: PAExporter?
    fileprivate var audio: PAAudio? {
        get {
            let resultAudio = exporter?.resultAudio
            if (exporter?.didExport)! {
                self.path = (resultAudio?.path)!
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
    
    public func append(audio path: URL) {
        let audioManager = PAAudioManager()
        let outputPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/hue.m4a")
        let outputPathUrl = URL(string: outputPath!)
        
        audioManager.merge(audios: [self, PAAudio(path: path)], outputPath: outputPathUrl!)
        self.path = outputPathUrl!
//        setAudio()
    }
    
    func setAudio() {
        let result = exporter?.resultAudio?.path
        var count = 0
        while result == nil {
            print("hue \(count)")
            count += 1
        }
        path = (exporter?.resultAudio?.path)!
    }
    
    public func insert(at: CMTime) -> Bool {
        return true
    }
    
    public func remove(intervalFrom begin: CMTime, to end: CMTime) -> PAAudio {
        let exportTimeRange = CMTimeRange(start: begin, end: end)
        let composition = AVMutableComposition(url: path)
        let exporter = PAExporter()
        let newPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/qotsa.m4a")
        let outputURL = URL(string: newPath!)
        
        exporter.export(composition: composition, to: outputURL!, in: exportTimeRange)
        
        return PAAudio(path: path)
    }
    
    public func remove(outsideIntervalFrom begin: CMTime, to end: CMTime) -> PAAudio {
        return PAAudio(path: path)
    }
    
    public func split(intervalsOfDuration duration: CMTime) -> [PAAudio] {
        return [PAAudio(path: path)]
    }
    
}
