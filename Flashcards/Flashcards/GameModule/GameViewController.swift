//
//  ViewController.swift
//  Flashcards
//
//  Created by Denis Voronov on 07/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

protocol GameUIConfig {
    var cardChangeAnimationDuration: TimeInterval {get}
}

class GameViewController: UIViewController  {

    var output: GameViewOutputProtocol!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var cardsPlace: UIView!
    
    var config: GameUIConfig?
    
    weak var cardView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Flashcards"
        progressView.progressTintColor = Styles.Card.backgroundColorNormal
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_sidebar"), style: .plain, target: self, action: #selector(menuTouched))
        
        output.viewDidLoad()
    }
    
    @objc func menuTouched(sender: UIButton) {
        output.userDidTouchMenu()
    }

    @IBAction func buttonNoTouched(_ sender: Any) {
        output.userDidTouchNo()
    }
    
    @IBAction func buttonYesTouched(_ sender: Any) {
        output.userDidTouchYes()
    }

    @IBAction func buttonRepeatTouched(_ sender: Any) {
        output.userDidTouchRepeat()
    }
    
    @IBAction func cardButtonTouched(_ sender: Any) {
        output.userDidTouchCard()
    }
}

extension GameViewController : GameViewInputProtocol {
    func changeProgress(value: Float) {
        progressView.progress = value
    }
    
    func userInputEnabled(enabled: Bool) {
        self.view.isUserInteractionEnabled = enabled
        print("userInputEnabled(\(enabled ? "true" : "false")) ")
    }
    
    func show(cardView: CardView, completion:FlipCompletion?) {

        if let existingCardView = self.cardView {
            cardView.transform = CGAffineTransform(translationX: 0, y: -500)
            cardsPlace.addSubview(cardView)
            cardView.addFillSuperviewConstraints()
            
            var duration = 0.35
            if let config = config {
                duration = config.cardChangeAnimationDuration
            }
            
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn], animations: {
                existingCardView.transform = CGAffineTransform(translationX: -500, y: 0)
                cardView.transform = CGAffineTransform(translationX: 0, y: 0)
                
            }) { (finished) in
                existingCardView.removeFromSuperview()
                self.cardView = cardView
                if let completion = completion {
                    completion()
                }
            }
        }
        else {
            cardsPlace.addSubview(cardView)
            cardView.addFillSuperviewConstraints()
            self.cardView = cardView
            if let completion = completion {
                completion()
            }
        }
    }

    func flipTo(cardView: CardView, completion:FlipCompletion?) {
        if let existingCardView = self.cardView {
            cardView.isHidden = true
            cardsPlace.addSubview(cardView)
            cardView.addFillSuperviewConstraints()
            UIView.transition(from: existingCardView, to: cardView, duration: 0.75, options: [.transitionFlipFromRight, .showHideTransitionViews]) { (finished) in
                existingCardView.removeFromSuperview()
                self.cardView = cardView
                if let completion = completion {
                    completion()
                }
            }
        }
        else {
            cardsPlace.addSubview(cardView)
            cardView.addFillSuperviewConstraints()
            self.cardView = cardView
            if let completion = completion {
                completion()
            }
        }
    }
    
    func flipTo(cardView: CardView ) {
        flipTo(cardView: cardView, completion: nil)
    }
    
    func alert(alert: UIAlertController, animated: Bool) {
        present(alert, animated: animated)
    }
}

