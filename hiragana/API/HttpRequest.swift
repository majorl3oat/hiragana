//
//  HttpRequest.swift
//  hiragana
//
//  Created by Pongrapee Attasaranya on 2020/02/11.
//  Copyright © 2020 Majorl3oat. All rights reserved.
//

import Foundation

class HttpRequest {
    
    static let shared = HttpRequest()
    
    private init() {}
    
    func requestGooAPI(sentence: String?) {
        let api = APIGoo.shared
        api.sendRequest(sentence: sentence)
    }
}
