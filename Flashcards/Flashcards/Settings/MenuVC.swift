//
//  MenuVC.swift
//  Flashcards
//
//  Created by Denis Voronov on 23/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    
    var wireframe: FlashcardsWireframe?
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var muteSwitch: UISwitch!
    @IBOutlet weak var showTranslationOnAnyAnswerSwitch: UISwitch!
    @IBOutlet weak var speechRateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var reverseLanguageModeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlTextField.text = GameConfig.phrasesURL?.absoluteString
        muteSwitch.isOn = !GameConfig.muted
        showTranslationOnAnyAnswerSwitch.isOn = GameConfig.showTranslationOnAnyAnswer
        
        speechRateSegmentedControl.removeAllSegments()
        for (key, _) in GameConfig.speechRatePresets {
            speechRateSegmentedControl.insertSegment(withTitle: key, at: speechRateSegmentedControl.numberOfSegments, animated: false)
        }
        speechRateSegmentedControl.selectedSegmentIndex = GameConfig.speechRatePresets.index(where: { (key, value) -> Bool in
            return key == GameConfig.speechRatePresetKey
        })!
        
        
        reverseLanguageModeSegmentedControl.removeAllSegments()
        for (key, _) in GameConfig.reverseLanguageModeSetting {
            reverseLanguageModeSegmentedControl.insertSegment(withTitle: key, at: reverseLanguageModeSegmentedControl.numberOfSegments, animated: false)
        }
        reverseLanguageModeSegmentedControl.selectedSegmentIndex = GameConfig.reverseLanguageModeSetting.index(where: { (key, value) -> Bool in
            return value == GameConfig.reverseLanguageMode
        })!
    }
    
    @IBAction func buttonLoadTouched(_ sender: Any) {
        if let string = urlTextField.text, let phrasesURL = URL(string: string) {
            GameConfig.phrasesURL = phrasesURL
            wireframe?.reload()
        }
    }
    
    @IBAction func muteSwitchValueChanged(_ sender: Any) {
        GameConfig.muted = !muteSwitch.isOn
    }
    
    @IBAction func showTranslationOnAnyAnswerSwitchValueChanged(_ sender: Any) {
        GameConfig.showTranslationOnAnyAnswer = showTranslationOnAnyAnswerSwitch.isOn
    }
    
    @IBAction func speechRateSegmentControlValueChanged(_ sender: Any) {
        let index = speechRateSegmentedControl.selectedSegmentIndex
        GameConfig.speechRatePresetKey = GameConfig.speechRatePresets[index].0
    }
    
    @IBAction func reverseLanguageModeSegmentedControlValueChanged(_ sender: Any) {
        let index = reverseLanguageModeSegmentedControl.selectedSegmentIndex
        GameConfig.reverseLanguageMode = GameConfig.reverseLanguageModeSetting[index].1
    }
}
