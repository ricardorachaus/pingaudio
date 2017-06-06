//
//  PAAudioManagerDelegate.swift
//  Pingaudio
//
//  Created by Rachaus on 31/05/17.
//  Copyright © 2017 Rachaus. All rights reserved.
//

import AVFoundation

protocol PAAudioManagerDelegate {
    func merge(audios: [PAAudio], completion: @escaping (_ output: URL?) -> Void)
}
