//
//  TextViewController.swift
//  Psychologist
//
//  Created by Sebastian Osiński on 20.07.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    
    override var preferredContentSize: CGSize {
        get {
            if textView != nil && presentingViewController != nil {
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            } else {
                return super.preferredContentSize
            }
        }
        set {
            super.preferredContentSize = newValue
        }
    }

    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = text
        }
    }
    
    var text: String = "" {
        didSet {
            textView?.text = text
        }
    }
   
}
