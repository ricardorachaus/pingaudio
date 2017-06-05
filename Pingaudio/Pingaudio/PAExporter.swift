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
        return outputPath
    }
    
    func export(composition: AVMutableComposition, in time: CMTimeRange, completion: @escaping (_ output: URL?) -> Void) {
        let fileManager = FileManager()
        let outputPath = fileManager.temporaryDirectory.appendingPathComponent("\(Date().timeIntervalSince1970).m4a")
        guard let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) else {
            print("wtf")
            return
        }
        exporter.outputURL = outputPath
        exporter.outputFileType = AVFileTypeAppleM4A
        exporter.shouldOptimizeForNetworkUse = true
        exporter.timeRange = time
        
        exporter.exportAsynchronously() {
            self.updateStatus(exporterStatus: exporter.status)
            if let error = exporter.error {
                print(error.localizedDescription)
                completion(nil)
            } else {
                completion(outputPath)
            }
        }
    }
    
    func updateStatus(exporterStatus: AVAssetExportSessionStatus) {
        var statusMessage: String!
        switch exporterStatus {
        case .waiting:
            statusMessage = "waiting"
            
        case .exporting:
            statusMessage = "exporting"
            
        case .cancelled:
            statusMessage = "cancelled"
            
        case .completed:
            statusMessage = "completed"
            
        case .failed:
            statusMessage = "failed"
            
        case .unknown:
            statusMessage = "unknown"
        }
        exportStatus = statusMessage
        print(statusMessage)
    }
}
