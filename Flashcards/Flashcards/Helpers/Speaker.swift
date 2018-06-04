//
//  Speaker.swift
//  Flashcards
//
//  Created by Denis Voronov on 15/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation
import AVFoundation

class Speaker : NSObject {
    
    typealias Completion = ()->()
    
    lazy var synthesizer = {return AVSpeechSynthesizer()}()
    var completion: Completion?
    var config: GameConfig
    
    required init(config: GameConfig) {
        self.config = config
        super.init()
        synthesizer.delegate = self
    }
    
    func say(text: String, language: String, completion: Completion?) {
        print (language)
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = GameConfig.speechRatePresets.first(where: { (key, value) -> Bool in
            return key == config.speechRatePresetKey
        })!.1
        self.completion = completion
        synthesizer.speak(utterance)
    }
    
    func say(text: String, language: String) {
        say(text: text, language: language, completion: nil)
    }
    
}

extension Speaker : AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if let completion = completion {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                completion()
            })
        }
    }
}
