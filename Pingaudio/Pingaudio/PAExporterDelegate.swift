//
//  PAExporterDelegate.swift
//  Pingaudio
//
//  Created by Miguel Nery on 01/06/17.
//  Copyright © 2017 Rachaus. All rights reserved.
//

import AVFoundation

protocol PAExporterDelegate {
    func export(composition: AVMutableComposition, completion: @escaping (_ output: URL?) -> Void)
}
