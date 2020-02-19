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
    var timer:Timer?
    
    // MARK: - Interface Builder
    
    @IBOutlet weak var inputTextView: UITextView?
    @IBOutlet weak var outputTextView: UITextView?
    @IBOutlet weak var inputPlaceholder: UILabel?
    @IBOutlet weak var outputPlaceholder: UILabel?
    
    @IBAction func clearButton(sender: UIButton) {
        inputTextView?.text = ""
        inputPlaceholder?.isHidden = false
        inputTextView?.becomeFirstResponder()
    }
    
    @IBAction func convertButton(sender: UIButton) {
        // Check input
        guard let sentence = inputTextView?.text else { return }
        if (sentence.count <= 0) {
            self.view.makeToast("テキストを入力してください", duration: kToastDuration)
            return
        }
        
        if !(Utilities.shared.checkReachable()) {
            self.view.makeToast("ネットワークの原因で認証に失敗しました", duration: kToastDuration)
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
                self.view.makeToast("無効なAPI", duration: kToastDuration)
            return
        }
        self.view.makeToastActivity(.center)
        timer = Timer.scheduledTimer(timeInterval: kRequestTimeout, target: self, selector: #selector(self.removeIndicator), userInfo: nil, repeats: false)
    }
    
    @IBAction func copyButton(sender: UIButton) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = outputTextView?.text
        self.view.makeToast("コピーしました", duration: kToastDuration, position: .bottom)
    }
    
    @objc func removeIndicator() {
        // Has internet connection but time out
        self.view.hideAllToasts(includeActivity: true, clearQueue: true)
        self.view.makeToast("ネットワークの原因で認証に失敗しました", duration: kToastDuration)
    }
    
    @objc func doneButton(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }

    // MARK: - Main Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initKeyboardAccessory()
        initTapHideKeyboard()
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
    
    func initKeyboardAccessory() {
        let toolbarSize:CGRect = CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30))
        let accessoryView = UIToolbar(frame: toolbarSize)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(doneButton))
        
        accessoryView.setItems([flexSpace, doneBtn], animated: false)
        accessoryView.sizeToFit()
        inputTextView?.inputAccessoryView = accessoryView
    }
    
    func initTapHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self.view,
                                         action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - HttpRequestDelegate
    
    func didFinishConvert(output: String?) {
        guard let output = output else { return }
        timer?.invalidate()
        DispatchQueue.main.async {
            self.outputTextView?.text = output
            self.view.hideAllToasts(includeActivity: true, clearQueue: true)
        }
    }
    
    func didFailConvert(error: String?) {
        guard let error = error else { return }
        timer?.invalidate()
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


