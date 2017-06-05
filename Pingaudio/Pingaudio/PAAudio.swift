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
    
    /**
     Default initializer
     - Parameter path: path to some audio file
     */
    public init(path: URL) {
        self.path = path
        asset = AVAsset(url: self.path)
        duration = (asset?.duration)!
        exporter = PAExporter()
    }
    
    /**
        Move item in `tempPath` to current audio path.
        - Parameter tempPath: item to be moved.
     
     */
    func moveToDocuments(tempPath: URL) {
        let fileManager = FileManager()
        let savePath = self.path
        if fileManager.fileExists(atPath: tempPath.path) && fileManager.fileExists(atPath: savePath.path) {
            // first delete previous audio in current path
            do {
                try fileManager.removeItem(at: savePath)
            } catch let error {
                print(error.localizedDescription)
                return
            }
            
            // now move the new audio to the PAAudio path
            do {
                try fileManager.moveItem(at: tempPath, to: savePath)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    /**
     Append audio file in `path` at the end of current audio, making a new audio from it
     - Parameter path: path to some audio file
     */
    public func append(audio path: URL) {
        let audioManager = PAAudioManager()
        
        let outputPath = audioManager.merge(audios: [self, PAAudio(path: path)])
        if let tempPath = outputPath {
            moveToDocuments(tempPath: tempPath)
        } else {
            print("Failed to append file. AVAssetExportSession is nil")
        }
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
        if self.duration <= duration {
            return [self]
        } else {
            
        }
        return [PAAudio(path: path)]
    }
    
}
