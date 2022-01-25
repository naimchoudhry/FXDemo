//
//  APISource.swift
//  FXDemo
//
//  Created by Naim on 20/01/2022.
//

import Foundation

class APISource {
    
    enum NetworkError: Error, LocalizedError {
        case badURL(String)
        case noDataReturnedFromServer
        
        var errorDescription: String? {
            switch self {
            case .badURL(let url): return "Incorrect URL: \(url), please file a bug report"
            case .noDataReturnedFromServer: return "No Data Returned, please try again Later"
            }
        }
    }
    
    enum EndPoint: String {
        case news = "/v1/dashboard"
        case markets = "/v1/markets"
    }
    
    let urlHost = "https://content.dailyfx.com/api"
    var session: URLSession
    
    init() {
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func getApiData(endPoint: EndPoint, result: @escaping (Result<Data,Error>) -> Void) {
        let urlString = urlHost + endPoint.rawValue
        guard let url = URL(string: urlString) else {
            result(Result.failure(NetworkError.badURL(urlString)))
            return
        }
        callApiWith(request: URLRequest(url: url), completion: result)
    }
    
    func callApiWith(request: URLRequest, completion: @escaping (Result<Data,Error>) -> Void) {
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.noDataReturnedFromServer))
            }
        }
        task.resume()
    }
}
