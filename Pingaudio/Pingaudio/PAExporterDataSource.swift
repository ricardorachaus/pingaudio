//
//  PAAudioManagerDataSource.swift
//  Pingaudio
//
//  Created by Rachaus on 31/05/17.
//  Copyright © 2017 Rachaus. All rights reserved.
//

import AVFoundation

protocol PAExporterDataSource {
    var resultAudio: PAAudio? { get set }
    var didExport: Bool { get }
}
