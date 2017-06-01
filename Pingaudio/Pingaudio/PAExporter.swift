//
//  PAExporter.swift
//  Pingaudio
//
//  Created by Miguel Nery on 01/06/17.
//  Copyright © 2017 Rachaus. All rights reserved.
//

import Foundation

class PAExporter: PAExporterDataSource, PAExporterDelegate {
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
        exportStatus = ""
    }
    
    func export(composition: AVMutableComposition, to outputPath: URL) {
        guard let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) else { return }
        exporter.outputURL = outputPath
        exporter.outputFileType = AVFileTypeAppleM4A
        exporter.shouldOptimizeForNetworkUse = true
        
        exporter.exportAsynchronously() {
            self.resultAudio = PAAudio(path: outputPath)
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
