//
//  Article.swift
//  FXDemo
//
//  Created by Naim on 20/01/2022.
//
import Foundation

struct Articles: Codable {
    @DecodableDefault.False var breakingNews: Bool
    @DecodableDefault.EmptyList var topNews: [Article]
    @DecodableDefault.EmptyType var dailyBriefings: DailyBriefings
    @DecodableDefault.EmptyList var technicalAnalysis: [Article]
    @DecodableDefault.EmptyList var specialReport: [Article]
}

struct DailyBriefings: Codable, HasSimpleInit {
    @DecodableDefault.EmptyList var eu: [Article]
    @DecodableDefault.EmptyList var asia: [Article]
    @DecodableDefault.EmptyList var us: [Article]
}

struct Article: Codable {
    var title: String
    var url: String
    var description: String
    @DecodableDefault.EmptyList var authors: [Author]
    var headlineImageUrl: String?
    var articleImageUrl: String?
    @DecodableDefault.EmptyList var tags: [String]
    @DecodableDefault.EmptyList var categories: [String]
    @DecodableDefault.EmptyList var instruments: [String]
    var displayTimestamp: Date
    var lastUpdatedTimestamp: Date
}

struct Author: Codable {
    var name: String
    var title: String?
    var descriptionShort: String?
    var photo: String?
}
