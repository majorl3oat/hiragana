//
//  APIYahoo.swift
//  hiragana
//
//  Created by Pongrapee Attasaranya on 2020/02/11.
//  Copyright © 2020 Majorl3oat. All rights reserved.
//

import Foundation

class APIYahoo: NSObject, XMLParserDelegate {
    
    struct API {
        private init() {}
        
        static let baseURL = "https://jlp.yahooapis.jp/FuriganaService/V1/furigana"
        static let method = "POST"
        static let contentType = "application/x-www-form-urlencoded"
        static let userAgent = "Yahoo AppID: dj00aiZpPVg5c1c5S3lzT0huRSZzPWNvbnN1bWVyc2VjcmV0Jng9ZTE-"
        static let outputType = "hiragana"
    }
    
    var elementName: String = String()
    var responseStr: String = String()
        
    static let shared = APIYahoo()
    
    private override init() {}
    
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
        request.setValue(API.userAgent, forHTTPHeaderField: "User-Agent")
        
        // Set request body
        guard let query = sentence else { return }
        let param = "sentence=\(query)"
        request.httpBody = param.data(using: String.Encoding.utf8)
        
        // Send request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            // Parse XML Response
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    
    // MARK: XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let str = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if self.elementName == "Furigana" {
            responseStr += str
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print(responseStr)
    }
}
