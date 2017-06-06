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
    fileprivate var exporter: PAExporter?
    
    /**
     Default initializer
     - Parameter path: path to some audio file
     */
    public init(path: URL) {
        self.path = path
        exporter = PAExporter()
    }
    
    /**
        Move item in `tempPath` to current audio path.
        - Parameter tempPath: item to be moved.
     
     */
    func moveToDocuments(tempPath: URL) -> Bool {
        let fileManager = FileManager()
        let savePath = self.path
        if fileManager.fileExists(atPath: tempPath.path) && fileManager.fileExists(atPath: savePath.path) {
            // first delete previous audio in current path
            do {
                try fileManager.removeItem(at: savePath)
            } catch let error {
                print(error.localizedDescription)
                return false
            }
            
            // now move the new audio to the PAAudio path
            do {
                try fileManager.moveItem(at: tempPath, to: savePath)
                return true
            } catch let error {
                print(error.localizedDescription)
                return false
            }
        }
        return false
    }
    
    
    public func append(audio path: URL, completion: @escaping (_ completed: Bool) -> Void) {
        let audioManager = PAAudioManager()
        
        audioManager.merge(audios: [self, PAAudio(path: path)]) { (output: URL?) -> Void in
            if let tempPath = output {
                completion(self.moveToDocuments(tempPath: tempPath))
            } else {
                print("Failed to append file. AVAssetExportSession is nil")
                completion(false)
            }
        }
    }
    
    public func insert(at: CMTime) -> Bool {
        return true
    }
    
    public func remove(intervalFrom begin: CMTime, to end: CMTime, completion: @escaping (_ output: PAAudio?) -> Void) {
        let exporter = PAExporter()
        let asset = AVAsset(url: path)
        let composition = AVMutableComposition()
        PAAudioManager.add(asset: asset, ofType: AVMediaTypeAudio, to: composition, at: kCMTimeZero)
        
        let  firstTimeRange = CMTimeRange(start: kCMTimeZero, end: begin)
        var firstPartPath: URL?
        exporter.export(composition: composition, in: firstTimeRange) { (resultPath: URL?) -> Void in
            if let result = resultPath {
                firstPartPath = result
                
                let secondTimeRange = CMTimeRange(start: end, end: asset.duration)
                var secondPartPath: URL?
                exporter.export(composition: composition, in: secondTimeRange) { (output: URL?) -> Void in
                    if let result = output {
                        secondPartPath = result
                        
                        guard let firstPart = firstPartPath, let secondPart = secondPartPath else {
                            print("failed to remove interval: Invalid parts")
                            return
                        }
                        
                        let firstAudio = PAAudio(path: firstPart)
                        let secondAudio = PAAudio(path: secondPart)
                        
                        let audioManager = PAAudioManager()
                        audioManager.merge(audios: [firstAudio, secondAudio]) { (output: URL?) -> Void in
                            if let result = output {
                                completion(PAAudio(path: result))
                            } else {
                                completion(nil)
                            }
                        }
                    } else {
                        secondPartPath = nil
                        print("failed to export second part of audio")
                    }
                }
            } else {
                firstPartPath = nil
                print("failed to export first part of audio")
            }
        }
    }
    
    public func remove(outsideIntervalFrom begin: CMTime, to end: CMTime, completion: @escaping (_ output: PAAudio?) -> Void) {
        let exportTimeRange = CMTimeRange(start: begin, end: end)
        let composition = AVMutableComposition()
        PAAudioManager.add(asset: AVAsset(url: path), ofType: AVMediaTypeAudio, to: composition, at: kCMTimeZero)
        let exporter = PAExporter()
        exporter.export(composition: composition, in: exportTimeRange) { (output: URL?) -> Void in
            if let resultPath = output {
                completion(PAAudio(path: resultPath))
            } else {
                print("failed to export audio")
                completion(nil)
            }
        }
    }
    

    public func split(intervalsOfDuration duration: CMTime) -> [PAAudio] {
        return [PAAudio(path: path)]
    }
    
}
