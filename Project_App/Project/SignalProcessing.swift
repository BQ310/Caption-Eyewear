//
//  SignalProcessing.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 4/28/23.
//

import Foundation

import Accelerate
import AVFoundation

class SignalProcessing {
    static func rms(buffer: AVAudioPCMBuffer) async -> Float {
        guard let channelData = buffer.floatChannelData else {
            return 0
          }
          
          let channelDataValue = channelData.pointee
          // 4
          let channelDataValueArray = stride(
            from: 0,
            to: Int(buffer.frameLength),
            by: buffer.stride)
            .map { channelDataValue[$0] }
          
          // 5
          let rms = sqrt(channelDataValueArray.map {
            return $0 * $0
          }
          .reduce(0, +) / Float(buffer.frameLength))
          
          // 6
          let avgPower = 20 * log10(rms)
          // 7
        let referenceLevel: Float = 5
        let offset: Float = 50.0
        let range: Float = 160.0
        let SPL = 20 * log10(referenceLevel * powf(10, (avgPower/20)) * range) + offset;
        return (SPL.isInfinite || SPL.isNaN) ? 0 : SPL
    }

}
