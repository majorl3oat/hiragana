//
//  HttpRequest.swift
//  hiragana
//
//  Created by Pongrapee Attasaranya on 2020/02/11.
//  Copyright © 2020 Majorl3oat. All rights reserved.
//

import Foundation

protocol HttpRequestDelegate: AnyObject {
    func didFinishConvert(output: String?)
    func didFailConvert(error: String?)
}

class HttpRequest {
    
    static let shared = HttpRequest()
    
    private init() {}
    
    func requestGooAPI(sentence: String?, delegate: HttpRequestDelegate?) {
        let api = APIGoo.shared
        guard let delegate = delegate else {
            print("Invalid Delegation")
            return
        }
        api.sendRequest(sentence: sentence, delegate: delegate)
    }
    
    func requestYahooAPI(sentence: String?, delegate: HttpRequestDelegate?) {
        let api = APIYahoo.shared
        guard let delegate = delegate else {
            print("Invalid Delegation")
            return
        }
        api.sendRequest(sentence: sentence, delegate: delegate)
    }
}
