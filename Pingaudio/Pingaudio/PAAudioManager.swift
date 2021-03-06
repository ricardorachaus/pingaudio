//
//  PAAudioManager.swift
//  Pingaudio
//
//  Created by Rachaus on 31/05/17.
//  Copyright © 2017 Rachaus. All rights reserved.
//

import AVFoundation

public class PAAudioManager: PAAudioManagerDelegate {
    var exporter: PAExporter!
    
    init() {
        exporter = PAExporter()
    }
    
    public func merge(audios: [PAAudio], completion: @escaping (_ output: URL?) -> Void) {
        let composition = AVMutableComposition()
        var time = kCMTimeZero
        
        for audio in audios {
            let asset = AVAsset(url: audio.path)
            PAAudioManager.add(asset: asset, ofType: AVMediaTypeAudio, to: composition, at: time)
            time = CMTimeAdd(time, asset.duration)
        }
        exporter.export(composition: composition) { (output: URL?) -> Void in
            if let result = output {
                completion(result)
            } else {
                completion(nil)
            }
        }
    }
    
    static func add(asset: AVAsset, ofType type: String, to composition: AVMutableComposition, at time: CMTime) {
        let track = composition.addMutableTrack(withMediaType: type, preferredTrackID: kCMPersistentTrackID_Invalid)
        let assetTrack = asset.tracks(withMediaType: type).first!
        do {
            try track.insertTimeRange(CMTimeRange(start: kCMTimeZero, duration: asset.duration), of: assetTrack, at: time)
        } catch _ {
            print("falha ao adicionar track a composition")
        }
    }
}
