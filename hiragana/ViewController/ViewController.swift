//
//  ViewController.swift
//  hiragana
//
//  Created by Pongrapee Attasaranya on 2020/02/10.
//  Copyright © 2020 Majorl3oat. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController, UITextViewDelegate, HttpRequestDelegate {
    
    let reachability = try! Reachability()
    
    // MARK: - Interface Builder
    
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
            self.view.makeToast("テキストを入力してください", duration: 1.5)
            return
        }
        
        if !(Utilities.shared.checkReachable()) {
            self.view.makeToast("ネットワークの原因で認証に失敗しました", duration: 1.5)
            return
        }
        
        let option = UserDefaults.standard.integer(forKey: kAPIOption)
        switch(option) {
            case kAPIGoo:
                HttpRequest.shared.requestGooAPI(sentence: sentence, delegate: self)
                break
            case kAPIYahoo:
                HttpRequest.shared.requestYahooAPI(sentence: sentence, delegate: self)
                break;
            default:
                self.view.makeToast("無効なAPI", duration: 1.5)
            return
        }
        self.view.makeToastActivity(.center)
    }
    
    @IBAction func copyButton(sender: UIButton) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = outputTextView?.text
        self.view.makeToast("コピーしました", duration: 1.5, position: .bottom)
    }

    // MARK: - Main Functions
    
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
    
    // MARK: - HttpRequestDelegate
    
    func didFinishConvert(output: String?) {
        guard let output = output else { return }
        DispatchQueue.main.async {
            self.outputTextView?.text = output
            self.view.hideAllToasts(includeActivity: true, clearQueue: true)
        }
    }
    
    func didFailConvert(error: String?) {
        guard let error = error else { return }
        DispatchQueue.main.async {
            self.outputTextView?.text = error
            self.view.hideAllToasts(includeActivity: true, clearQueue: true)
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text.count > 0) {
            inputPlaceholder?.isHidden = true
        } else {
            inputPlaceholder?.isHidden = false
        }
    }
}


