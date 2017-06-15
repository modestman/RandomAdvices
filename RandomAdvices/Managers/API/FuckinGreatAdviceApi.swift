//
//  FuckinGreatAdviceApi.swift
//  RandomAdvices
//
//  Created by Anton Glezman on 14.06.17.
//  Copyright © 2017 Globus. All rights reserved.
//

import Foundation

protocol FuckinGreatAdviceApiProtocol {
    typealias AdviceCompletionHandler = (ApiAdviceModel?, Error?) -> Void
    func getRandomAdvice(completion: @escaping AdviceCompletionHandler)
}

class FuckinGreatAdviceApi: FuckinGreatAdviceApiProtocol {
    
    static let baseUrl = "http://fucking-great-advice.ru/api/"
    
    private lazy var randomAdviceRequest: URLRequest = {
        let url = URL.init(string: FuckinGreatAdviceApi.baseUrl.appending("random"))
        return NetworkManager.request(url: url!, queryParams: nil)!
    }()
    
    public func getRandomAdvice(completion: @escaping AdviceCompletionHandler) {
        NetworkManager.shared.sendRequest(self.randomAdviceRequest) { (data, httpResponse, error) in
            guard let response = httpResponse else { return }
            if response.statusCode == 200 {
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            let model = ApiAdviceModel.init(from: json)
                            completion(model, nil)
                        }
                    } catch {
                        print("Json parse error")
                        completion(nil, JsonParseError())
                    }
                }
            } else {
                // TODO: handle http error code
                completion(nil, error)
            }
        }
    }
    
    struct JsonParseError: Error {}
}
