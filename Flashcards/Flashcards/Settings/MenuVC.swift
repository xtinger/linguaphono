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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlTextField.text = GameConfig.phrasesURL?.absoluteString
        muteSwitch.isOn = !GameConfig.muted
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
}
