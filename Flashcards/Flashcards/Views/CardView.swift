//
//  CardView.swift
//  Flashcards
//
//  Created by Denis Voronov on 10/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit
import EvergreenBitsUI

//TODO: protocol
@IBDesignable
class CardView : UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var label: UILabel!
    
    public var backColor: UIColor? {
        didSet {
            view?.backgroundColor = backColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.clear
        view = loadViewFromNib()
        view.layer.cornerRadius = Styles.Main.cornerRadius
        addSubview(view)
        view.addFillSuperviewConstraints()
    }
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
}
