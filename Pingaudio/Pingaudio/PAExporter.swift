//
//  PAExporter.swift
//  Pingaudio
//
//  Created by Miguel Nery on 01/06/17.
//  Copyright © 2017 Rachaus. All rights reserved.
//

import AVFoundation

class PAExporter: PAExporterDataSource, PAExporterDelegate {
    var resultAudio: PAAudio?
    var didExport: Bool {
        get {
            return resultAudio != nil
        }
    }
    
    var exportStatus: String
    
    public init() {
        exportStatus = ""
    }
    
    func export(composition: AVMutableComposition) -> URL? {
        let fileManager = FileManager()
        let outputPath = fileManager.temporaryDirectory.appendingPathComponent("\(Date().timeIntervalSince1970).m4a")
        guard let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) else { return nil}
        exporter.outputURL = outputPath
        exporter.outputFileType = AVFileTypeAppleM4A
        exporter.shouldOptimizeForNetworkUse = true
        exporter.exportAsynchronously() {
            if let error = exporter.error {
                print(error.localizedDescription)
            }
        }
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateStatus(_:)), userInfo: exporter, repeats: true)
        return outputPath
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
        print(statusMessage)
    }
}
