//
//  MarketViewModel.swift
//  FXDemo
//
//  Created by Naim on 20/01/2022.
//
import Foundation

class MarketsViewModel {
    
    var marketsLoaded: ((Bool) -> Void)?
    private(set) var markets: Markets?
    private var gettingMarkets: Bool
    
    init() {
        gettingMarkets = false
        getMarkets()
    }
    
    func getMarkets() {
        guard !gettingMarkets  else {return}
        gettingMarkets = true
        let apiSource = APISource()
        apiSource.getApiData(endPoint: .markets) { result in
            defer { self.gettingMarkets = false }
            switch result {
            case .failure:
                DispatchQueue.main.async {self.marketsLoaded?(false)}
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    self.markets = try decoder.decode(Markets.self, from: data)
                    DispatchQueue.main.async {self.marketsLoaded?(true)}
                } catch {
                    DispatchQueue.main.async {self.marketsLoaded?(false)}
                }
            }
        }
    }
}
