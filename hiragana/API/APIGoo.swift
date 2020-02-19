//
//  APIGoo.swift
//  hiragana
//
//  Created by Pongrapee Attasaranya on 2020/02/11.
//  Copyright © 2020 Majorl3oat. All rights reserved.
//

import Foundation

class APIGoo {
    
    // MARK: - Declaration
    
    struct requestJSONModel : Codable {
        var app_id: String
        var sentence: String?
        var output_type: String
    }

    struct responseJSONModel : Decodable {
        var output_type: String
        var converted: String?
    }
    
    struct errorJSONModel : Decodable {
        var error: errorModel
    }
    
    struct errorModel : Decodable {
        var code: Int
        var message: String
    }

    struct API {
        private init() {}
        
        static let baseURL = "https://labs.goo.ne.jp/api/hiragana"
        static let method = "POST"
        static let contentType = "application/json"
        static let appID = kAPIGooAppID
        static let outputType = "hiragana"
    }
    
    static let shared = APIGoo()
    var delegate: HttpRequestDelegate?
    
    // MARK: - Main Functions
    
    private init() {}
    
    func sendRequest(sentence: String?, delegate: HttpRequestDelegate?) {
        
        // Config
        let url = URL(string: API.baseURL)
        guard let requestUrl = url else {
            print("Invalid URL")
            return
        }
        self.delegate = delegate
        
        // Prepare Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = API.method
        request.setValue(API.contentType, forHTTPHeaderField: "Content-Type")
        
        // Set HTTP Request Body
        let requestmodel = requestJSONModel(app_id: API.appID,
                                            sentence:sentence,
                                            output_type: API.outputType)
        
        // Set request body
        let jsonData = try? JSONEncoder().encode(requestmodel)
        request.httpBody = jsonData
        
        // Send request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("URLSession Error: \(error)")
                return
            }
            
            guard let data = data else { return }

            // Check error from API
            let err = try? JSONDecoder().decode(errorJSONModel.self, from: data)
            if (err != nil) {
                let errStr = String(err?.error.code ?? -1) + " : " + (err?.error.message ?? "Unexpected Error")
                self.delegate?.didFailConvert(error: errStr)
                return
            }
            
            // Check response if no error
            let res = try? JSONDecoder().decode(responseJSONModel.self, from: data)
            if (res != nil) {
                self.delegate?.didFinishConvert(output: res?.converted)
            }
        }
        task.resume()
    }
}
