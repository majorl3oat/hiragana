//
//  APIGoo.swift
//  hiragana
//
//  Created by Pongrapee Attasaranya on 2020/02/11.
//  Copyright © 2020 Majorl3oat. All rights reserved.
//

import Foundation

class APIGoo {
    
    struct requestJSONModel : Codable {
        var app_id: String
        var sentence: String?
        var output_type: String
    }

    struct responseJSONModel : Codable {
        var output_type: String
        var converted: String?
    }

    struct API {
        private init() {}
        
        static let baseURL = "https://labs.goo.ne.jp/api/hiragana"
        static let method = "POST"
        static let contentType = "application/json"
        static let appID = "282c46b372af8a654aa7b628237122b74dc8e0ee09010f5f148ac70ca099f8c6"
        static let outputType = "hiragana"
    }

    static let shared = APIGoo()
    
    private init() {}
    
    func sendRequest(sentence: String?) {
        // Config URL
        let url = URL(string: API.baseURL)
        guard let requestUrl = url else {
            print("Invalid URL")
            return
        }
        
        // Prepare Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = API.method
        request.setValue(API.contentType, forHTTPHeaderField: "Content-Type")
        
        // Set HTTP Request Body
        let requestmodel = requestJSONModel(app_id: API.appID, sentence:sentence, output_type: API.outputType)
        let jsonData = try? JSONEncoder().encode(requestmodel)
        let jsonD = try? JSONDecoder().decode(requestJSONModel.self, from: jsonData!)
        print(jsonD!)
        request.httpBody = jsonData
        
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                guard let data = data else {return}
                do {
                    let res = try JSONDecoder().decode(responseJSONModel.self, from: data)
                    print(res.converted!)
                } catch let jsonErr {
                    print("JSON Error: \(jsonErr)")
                }
        }
        task.resume()
    }

}
