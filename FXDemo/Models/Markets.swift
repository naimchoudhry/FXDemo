//
//  Markets.swift
//  FXDemo
//
//  Created by Naim on 21/01/2022.
//
import Foundation

struct Markets: Codable {
    @DecodableDefault.EmptyList var currencies: [Market]
    @DecodableDefault.EmptyList var commodities: [Market]
    @DecodableDefault.EmptyList var indices: [Market]
}

struct Market: Codable {
    var displayName: String                 // EUR/USD
    var marketId: String                    // EURUSD
    var epic: String                        // CS.D.EURUSD.CFD.IP
    var rateDetailURL: String               // https://www.dailyfx.com/eur-usd
    @DecodableDefault.False var topMarket: Bool
    var unscalingFactor: Int                // 10000
    var unscaledDecimals: Int               // 5
}
