//
//  ViewController.swift
//  Flashcards
//
//  Created by Denis Voronov on 07/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

class GameVC: UIViewController, IGameViewInput  {

    var output: IGameViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonYesTouched(_ sender: Any) {
        output.userDidTouchYes()
    }

    @IBAction func buttonNoTouched(_ sender: Any) {
        output.userDidTouchNo()
    }
    
    @IBAction func buttonRepeatTouched(_ sender: Any) {
        output.userDidTouchRepeat()
    }
}

