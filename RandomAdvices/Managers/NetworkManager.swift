//
//  NetworkManager.swift
//  RandomAdvices
//
//  Created by Anton Glezman on 14.06.17.
//  Copyright © 2017 Globus. All rights reserved.
//

import Foundation

class NetworkManager {
    
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    typealias RequestCompletionHandler = (Data?, HTTPURLResponse?, Error?) -> Void
    
    static let shared = NetworkManager()
    
    private var session: URLSession
    private var configuration: URLSessionConfiguration
    
    private init() {
        self.configuration = URLSessionConfiguration.default
        self.session = URLSession.init(configuration: self.configuration)
    }
    
    public static func request(url: URL, queryParams: [String: String?]?, method: HttpMethod = .get) -> URLRequest? {
        var components = URLComponents.init(url: url, resolvingAgainstBaseURL: false)
        if let params = queryParams {
            var queryItems = [URLQueryItem]()
            for (key, value) in params {
                let item = URLQueryItem.init(name: key, value: value)
                queryItems.append(item)
            }
            components?.queryItems = queryItems
        }
        guard let _url = components?.url else { return nil }
        var request = URLRequest.init(url: _url)
        request.httpMethod = method.rawValue
        return request
    }
    
    @discardableResult
    public func sendRequest(_ request: URLRequest,
                            completionHandler: RequestCompletionHandler?) -> URLSessionDataTask {
        let task = self.session.dataTask(with: request) { (data, response, error) in
            if let handler = completionHandler {
                let httpResponse = response as? HTTPURLResponse
                handler(data, httpResponse, error)
            }
        }
        task.resume()
        return task
    }
}
