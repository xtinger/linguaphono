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
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func say(text: String, language: String, completion: Completion?) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
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
            completion()
        }
    }
}
