//
//  KStreamModel.swift
//  SpotFlock
//
//  Created by Nuviso Infore on 31/07/19.
//  Copyright © 2019 Spotflock. All rights reserved.
//

import Foundation

import JavaScriptCore

@objc protocol FeedJSExport: JSExport {
    var title: String! {get set}
    var titleImage: String! {get set}
    var shortDescription: String! {get set}
    var fullDescription: String! {get set}
    var titleImageURL: String! {get set}
    var descriptionImageURL: String! {get set}
    var articleType: String! {get set}
    var publishedDate: String! {get set}
    var createdAt: String! {get set}
    var updatedAt: String! {get set}
    
    static func gettingFeedsList(title: String?, titleImage: String?, shortDescription: String?, fullDescription: String?, titleImageURL: String?, descriptionImageURL: String?, articleType: String?, publishedDate: String?, createdAt: String?, updatedAt: String?) -> Feed
}

// MARK: - Kstream
class Kstream: Codable {
    let success: Bool
    let kstream: KstreamClass?
    
    init(success: Bool, kstream: KstreamClass?) {
        self.success = success
        self.kstream = kstream
    }
}

// MARK: - KstreamClass
class KstreamClass: Codable {
    let currentPage: Int?
    var feed: [Feed]?
    let firstPageURL: String?
    let from: Int?
    let nextPageURL, path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case feed = "data"
        case firstPageURL = "first_page_url"
        case from
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to
    }
    
    init(currentPage: Int?, feed: [Feed]?, firstPageURL: String?, from: Int?, nextPageURL: String?, path: String?, perPage: Int?, prevPageURL: String?, to: Int?) {
        self.currentPage = currentPage
        self.feed = feed
        self.firstPageURL = firstPageURL
        self.from = from
        self.nextPageURL = nextPageURL
        self.path = path
        self.perPage = perPage
        self.prevPageURL = prevPageURL
        self.to = to
    }
}

// MARK: - Feed
@objc class Feed: NSObject, Codable, FeedJSExport {
    static func gettingFeedsList(title: String?, titleImage: String?, shortDescription: String?, fullDescription: String?, titleImageURL: String?, descriptionImageURL: String?, articleType: String?, publishedDate: String?, createdAt: String?, updatedAt: String?) -> Feed {
        return Feed.init(title: title, titleImage: titleImage, shortDescription: shortDescription, fullDescription: fullDescription, titleImageURL: titleImageURL, descriptionImageURL: descriptionImageURL, articleType: articleType, publishedDate: publishedDate, createdAt: createdAt, updatedAt: updatedAt)
    }
    var id, rssSourceID: Int?
    dynamic var title: String?
    dynamic var titleImage, shortDescription: String?
    dynamic var fullDescription: String?
    dynamic var titleImageURL: String?
    dynamic var descriptionImageURL: String?
    dynamic var articleType: String?
    dynamic var publishedDate: String?
    dynamic var createdAt: String?
    dynamic var updatedAt: String?
    
    var articleURL: String?
    let author: String?
    let tagLine: String?
    let isSponsored, isPremium: Int?
    let tags, filtertags: String?
    let likes, comments, shares, metaKstreamID: Int?
    let accepted: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case rssSourceID = "rss_source_id"
        case title
        case titleImage = "title_image"
        case tagLine = "tag_line"
        case shortDescription = "short_description"
        case fullDescription = "full_description"
        case titleImageURL = "title_image_url"
        case descriptionImageURL = "description_image_url"
        case articleURL = "article_url"
        case author
        case articleType = "article_type"
        case publishedDate = "published_date"
        case isSponsored = "is_sponsored"
        case isPremium = "is_premium"
        case tags, filtertags, likes, comments, shares
        case metaKstreamID = "meta_kstream_id"
        case accepted
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(id: Int?, rssSourceID: Int?, title: String?, titleImage: String?, tagLine: String?, shortDescription: String?, fullDescription: String?, titleImageURL: String?, descriptionImageURL: String?, articleURL: String?, author: String?, articleType: String?, publishedDate: String?, isSponsored: Int?, isPremium: Int?, tags: String?, filtertags: String?, likes: Int?, comments: Int?, shares: Int?, metaKstreamID: Int?, accepted: Int?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.rssSourceID = rssSourceID
        self.title = title
        self.titleImage = titleImage
        self.tagLine = tagLine
        self.shortDescription = shortDescription
        self.fullDescription = fullDescription
        self.titleImageURL = titleImageURL
        self.descriptionImageURL = descriptionImageURL
        self.articleURL = articleURL
        self.author = author
        self.articleType = articleType
        self.publishedDate = publishedDate
        self.isSponsored = isSponsored
        self.isPremium = isPremium
        self.tags = tags
        self.filtertags = filtertags
        self.likes = likes
        self.comments = comments
        self.shares = shares
        self.metaKstreamID = metaKstreamID
        self.accepted = accepted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(title: String?, titleImage: String?, shortDescription: String?, fullDescription: String?, titleImageURL: String?, descriptionImageURL: String?, articleType: String?, publishedDate: String?, createdAt: String?, updatedAt: String?) {
        self.title = title
        self.titleImage = titleImage
        self.shortDescription = shortDescription
        self.fullDescription = fullDescription
        self.titleImageURL = titleImageURL
        self.descriptionImageURL = descriptionImageURL
        self.articleType = articleType
        self.publishedDate = publishedDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.author = nil
        self.tagLine = nil
        self.isSponsored = nil
        self.isPremium = nil
        self.tags = nil
        self.filtertags = nil
        self.likes = nil
        self.comments = nil
        self.shares = nil
        self.metaKstreamID = nil
        self.accepted = nil
        
    }
}
