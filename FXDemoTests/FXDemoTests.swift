//
//  FXDemoTests.swift
//  FXDemoTests
//
//  Created by Naim on 20/01/2022.
//

import XCTest
@testable import FXDemo

class FXDemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testArticleEndocable() throws {
        
        let testJsonArticle: [String:Any?] = [
            "title": "The Federal Reserve Bank: A Forex Trader’s Guide ",
            "url": "https://www.dailyfx.com/forex/fundamental/article/special_report/2021/04/28/federal-reserve-bank.html",
            "description": "Learn about the US central bank, its key mandates, and how to trade Fed interest rate decisions.",
            "content": nil,
            "firstImageUrl": nil,
            "headlineImageUrl": "https://a.c-dn.net/b/43VtAd/headline_207001032.jpg",
            "articleImageUrl": nil,
            "backgroundImageUrl": nil,
            "videoType": nil,
            "videoId": nil,
            "videoUrl": nil,
            "videoThumbnail": nil,
            "newsKeywords": nil,
            "authors": [[
                "name": "Laura Wagg",
                "title": nil,
                "bio": nil,
                "email": nil,
                "phone": nil,
                "facebook": nil,
                "twitter": nil,
                "googleplus": nil,
                "subscription": nil,
                "rss": "https://www.dailyfx.com/feeds/all",
                "descriptionLong": nil,
                "descriptionShort": nil,
                "photo": "https://a.c-dn.net/b/0zd31D/default.png"
            ]],
            "instruments": ["FOMC"],
            "tags": ["Federal Reserve", "FOMC", "Evergreen"],
            "categories": ["forex", "fundamental", "article", "special_report"],
            "displayTimestamp": 1642665600000,
            "lastUpdatedTimestamp": 1642659368226
        ]
        
        let testJsonArticles: [String: Any?] = [
            "breakingNews": nil,
            "topNews": [testJsonArticle, testJsonArticle],
            "dailyBriefings": nil, //["eu": [testJsonArticle, testJsonArticle]],
            "technicalAnalysis": [testJsonArticle, testJsonArticle],
            "specialReport": [testJsonArticle, testJsonArticle]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: testJsonArticles)
        let decoder = JSONDecoder()
        XCTAssertNoThrow(try decoder.decode(Articles.self, from: data))
    }
    
    func testMarketEncodable() throws {
        let testJsonMarket: [String:Any?] = [
            "currencies": [[
                "displayName": "EUR/USD",
                "marketId": "EURUSD",
                "epic": "CS.D.EURUSD.CFD.IP",
                "rateDetailURL": "https://www.dailyfx.com/eur-usd",
                "topMarket": true,
                "unscalingFactor": 10000,
                "unscaledDecimals": 5,
                "calendarMapping": ["EUR", "USD"],
            ]],
           "commodities": [[
                   "displayName": "Spot Gold",
                   "marketId": "GC",
                   "epic": "CS.D.CFDGOLD.CFDGC.IP",
                   "rateDetailURL": "https://www.dailyfx.com/gold-price",
                   "topMarket": true,
                   "unscalingFactor": 1,
                   "unscaledDecimals": 2,
                   "calendarMapping": ["USD"],
            ]],
           "indices": [[
                   "displayName": "USDOLLAR",
                   "marketId": "DX",
                   "epic": "CC.D.DX.UNC.IP",
                   "rateDetailURL": "https://www.dailyfx.com/us-dollar-index",
                   "topMarket": false,
                   "unscalingFactor": 100,
                   "unscaledDecimals": 3,
                   "calendarMapping": ["USD"],
            ]]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: testJsonMarket)
        let decoder = JSONDecoder()
        XCTAssertNoThrow(try decoder.decode(Markets.self, from: data))
    }
    
    func testCache() {
        //Test Cache Types
        let intCache = Cache<Int,Int>()
        intCache[1] = 1
        XCTAssertTrue(intCache[1] == 1)
        intCache[1] = nil
        XCTAssertTrue(intCache[1] == nil)
        
        let anyCache = Cache<AnyHashable, Any>()
        anyCache["Bool"] = false
        if let val = anyCache["Bool"] as? Bool {
            XCTAssertTrue(val == false)
        } else {
            XCTFail()
        }
        anyCache[1] = Double(1.23456)
        if let val = anyCache[1] as? Double {
            XCTAssertTrue(val == 1.23456)
        } else {
            XCTFail()
        }
    }

}
