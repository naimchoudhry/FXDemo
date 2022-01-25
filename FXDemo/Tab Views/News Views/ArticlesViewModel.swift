//
//  ArticlesViewModel.swift
//  FXDemo
//
//  Created by Naim on 20/01/2022.
//

import Foundation

class ArticlesViewModel {
    
    var newArticlesLoaded: ((Bool) -> Void)?
    
    private(set) var articles: Articles?
    private var gettingArticles: Bool
    
    init() {
        gettingArticles = false
        getArticles()
    }
    
    func getArticles() {
        guard !gettingArticles  else {return}
        gettingArticles = true
        let apiSource = APISource()
        apiSource.getApiData(endPoint: .news) { [weak self] result in
            guard let self = self else {return}
            defer { self.gettingArticles = false }
            switch result {
            case .failure:
                DispatchQueue.main.async {self.newArticlesLoaded?(false)}
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .millisecondsSince1970
                do {
                    let articleGroups = try decoder.decode(Articles.self, from: data)
                    DispatchQueue.main.async {
                        self.articles = articleGroups
                        self.newArticlesLoaded?(true)
                    }
                } catch {
                    DispatchQueue.main.async {self.newArticlesLoaded?(false)}
                }
            }
        }
    }
}
