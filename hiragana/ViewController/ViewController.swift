//
//  ViewController.swift
//  hiragana
//
//  Created by Pongrapee Attasaranya on 2020/02/10.
//  Copyright © 2020 Majorl3oat. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    // MARK: Interface Builder Related
    
    @IBOutlet weak var inputTextView: UITextView?
    @IBOutlet weak var outputTextView: UITextView?
    @IBOutlet weak var inputPlaceholder: UILabel?
    @IBOutlet weak var outputPlaceholder: UILabel?
    
    @IBAction func clearButton(sender: UIButton) {
        inputTextView?.text = ""
        inputPlaceholder?.isHidden = false
    }
    
    @IBAction func convertButton(sender: UIButton) {
        // Check input
        guard let sentence = inputTextView?.text else { return }
        if (sentence.count <= 0) {
            // show alert
            return
        }
        
        let option = UserDefaults.standard.integer(forKey: kAPIOption)
        switch(option) {
            case kAPIGoo:
                HttpRequest.shared.requestGooAPI(sentence: sentence)
                break
            case kAPIYahoo:
                HttpRequest.shared.requestYahooAPI(sentence: sentence)
                break;
            default:
                // show alert: invalid engine
            return
        }
    }

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView() {
        let borderColor = UIColor(red:0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        
        inputTextView?.becomeFirstResponder()
        inputTextView?.delegate = self
        
        inputTextView?.layer.borderWidth = 0.5
        inputTextView?.layer.borderColor = borderColor
        inputTextView?.layer.cornerRadius = 5.0
        
        outputTextView?.layer.borderWidth = 0.5
        outputTextView?.layer.borderColor = borderColor
        outputTextView?.layer.cornerRadius = 5.0
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text.count > 0) {
            inputPlaceholder?.isHidden = true
        } else {
            inputPlaceholder?.isHidden = false
        }
    }
}


