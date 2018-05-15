//
//  ViewController.swift
//  Flashcards
//
//  Created by Denis Voronov on 07/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

class GameVC: UIViewController  {

    var output: IGameViewOutput!
    
    @IBOutlet weak var cardsPlace: UIView!
    
    weak var cardView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
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
}

extension GameVC : IGameViewInput {
    func show(cardView: CardView) {

        if let existingCardView = self.cardView {
            cardView.transform = CGAffineTransform(translationX: 0, y: -500)
            cardsPlace.addSubview(cardView)
            cardView.addFillSuperviewConstraints()
            
            UIView.animate(withDuration: GameConfig.cardChangeAnimationDuration, delay: 0, options: [.curveEaseIn], animations: {
                existingCardView.transform = CGAffineTransform(translationX: -500, y: 0)
                cardView.transform = CGAffineTransform(translationX: 0, y: 0)
                
            }) { (finished) in
                existingCardView.removeFromSuperview()
            }
        }
        else {
            cardsPlace.addSubview(cardView)
            cardView.addFillSuperviewConstraints()
        }
        
        self.cardView = cardView
        
        /*
        if let existingCardView = self.cardView {
            
            cardView.isHidden = true
            cardsPlace.addSubview(cardView)
            cardView.addFillSuperviewConstraints()
            
            UIView.transition(from: existingCardView, to: cardView, duration: 0.25, options: [.transitionFlipFromRight, .showHideTransitionViews]) { (finished) in
                existingCardView.removeFromSuperview()
            }
        }
        else {
            cardsPlace.addSubview(cardView)
            cardView.addFillSuperviewConstraints()
        }
        
        self.cardView = cardView
 */
    }
    
    func flipTo(cardView: CardView, andBack flipBack: Bool) {
        if let existingCardView = self.cardView {
            
            cardView.isHidden = true
            cardsPlace.addSubview(cardView)
            cardView.addFillSuperviewConstraints()
            
            UIView.transition(from: existingCardView, to: cardView, duration: 0.25, options: [.transitionFlipFromRight, .showHideTransitionViews]) { (finished) in
                existingCardView.removeFromSuperview()
            }
        }
        else {
            cardsPlace.addSubview(cardView)
            cardView.addFillSuperviewConstraints()
        }
        
        self.cardView = cardView
    }
}

