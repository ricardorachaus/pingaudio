//
//  PAAudioDataSource.swift
//  Pingaudio
//
//  Created by Rachaus on 31/05/17.
//  Copyright © 2017 Rachaus. All rights reserved.
//

import AVFoundation

protocol PAAudioDataSource {
    /**
     Path to audio
     */
    var path: URL {get set}
    var duration: CMTime {get set}
}
