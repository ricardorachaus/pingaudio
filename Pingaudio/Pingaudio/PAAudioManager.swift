//
//  PAAudioManager.swift
//  Pingaudio
//
//  Created by Rachaus on 31/05/17.
//  Copyright © 2017 Rachaus. All rights reserved.
//

import AVFoundation

public class PAAudioManager: PAAudioManagerDataSource, PAAudioManagerDelegate {
    var resultAudio: PAAudio? {
        get {
            if didExport {
                return self.resultAudio
            }
            else {
                return nil
            }
        }
        set (audio) {
            self.resultAudio = audio
        }
    }
    
    var didExport: Bool
    var exportStatus: String
    
    public init() {
        didExport = false
        resultAudio = PAAudio()
    }
    
    public func merge(audios: [PAAudio], outputPath: URL) -> PAAudio {
        let composition = AVMutableComposition()
        var time = kCMTimeZero
        
        for audio in audios {
            let asset = AVAsset(url: audio.path)
            add(asset: asset, ofType: AVMediaTypeAudio, to: composition, at: time)
            time = CMTimeAdd(time, asset.duration)
        }
        export(composition: composition, to: outputPath)
    }
    
    fileprivate func add(asset: AVAsset, ofType type:String, to composition: AVMutableComposition, at time: CMTime) {
        let track = composition.addMutableTrack(withMediaType: type, preferredTrackID: kCMPersistentTrackID_Invalid)
        let assetTrack = asset.tracks(withMediaType: type).first!
        do {
            try track.insertTimeRange(CMTimeRange(start: kCMTimeZero, duration: asset.duration), of: assetTrack, at: time)
        } catch _ {
            print("falha ao adicionar track a composition")
        }
    }
    
    internal func export(composition: AVMutableComposition, to outputPath: URL) {
        guard let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) else { return }
        exporter.outputURL = outputPath
        exporter.outputFileType = AVFileTypeAppleM4A
        exporter.shouldOptimizeForNetworkUse = true
        
        exporter.exportAsynchronously() {
            resultAudio = PAAudio(path: outputPath)
        }
        
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateStatus(_:)), userInfo: exporter, repeats: true)
    }
    
    
    
    @objc func updateStatus(_ timer: Timer) {
        let exporter = timer.userInfo as! AVAssetExportSession
        var statusMessage: String!
        switch exporter.status {
        case .waiting:
            statusMessage = "waiting"
            
        case .exporting:
            statusMessage = "exporting"
            
        case .cancelled:
            statusMessage = "cancelled"
            timer.invalidate()
            
        case .completed:
            statusMessage = "completed"
            timer.invalidate()
            
        case .failed:
            statusMessage = "failed"
            timer.invalidate()
            
        case .unknown:
            statusMessage = "unknown"
            timer.invalidate()
        }
        exportStatus = statusMessage
    }

}
