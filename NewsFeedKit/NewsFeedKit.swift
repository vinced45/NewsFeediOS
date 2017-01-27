//
//  NewsFeedKit.swift
//  NewsFeediOS
//
//  Created by Vince on 1/27/17.
//  Copyright © 2017 Vince Davis. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

@objc
public class NewsFeedKit: NSObject {
    
    let entertainmentUrl = "https://raw.githubusercontent.com/jvanaria/jvanaria.github.io/master/entertainment.json"
    let businessURL = "https://raw.githubusercontent.com/jvanaria/jvanaria.github.io/master/business.json"
    let topStoriesUrl = "https://raw.githubusercontent.com/jvanaria/jvanaria.github.io/master/top-stories.json"
    
    // MARK: Enums
    public enum ArticleResult {
        case success([Article])
        case error(Error)
    }
    
    public enum ArticleType: Int {
        case topStories = 0
        case business = 1
        case entertainment = 2
    }
    
    public typealias ArticleClosure = (_ result: ArticleResult) -> Void
    
    // MARK: Public Methods

    public func getArticles(_ type: ArticleType, completion: @escaping ArticleClosure) {
        let url = newsSections()[type.rawValue]
        network.call(url) { result in
            switch result {
            case let .downloadCompleted(_, data):
                let json = JSON(data: data)
                self.saveArticles(json, section: type.rawValue) { articleResult in
                    switch articleResult {
                    case let .success(articles):
                        completion(ArticleResult.success(articles))
                    default:
                        completion(ArticleResult.error(NewsFeedError.default()))
                    }
                }
            case let .error(error):
                print(error)
            default:
                print(NewsFeedError.default())
            }
        }
    }
    
    public func queryArticles() -> Results<Article>? {
        if let results = db.query(Article.self) {
            return results
        }
        
        return nil
    }
}

// MARK: Private Methods
extension NewsFeedKit {
    internal func newsSections() -> [String] {
        return [topStoriesUrl, businessURL, entertainmentUrl]
    }
    
    internal func saveArticles(_ mainJson: JSON?, section: Int, completion: @escaping ArticleClosure) {
        var articles: [Article] = []
        
        guard let jsons = mainJson?["Items"].array else  {
            completion(ArticleResult.error(NewsFeedError.default()))
            return
        }
        
        for json in jsons {
            let article = Article()
            if section == 0 {
                article.id = "top-\(json["Id"].stringValue)"
            } else {
                article.id = json["Id"].stringValue
            }
            article.title = json["Title"].stringValue
            article.desc = json["Description"].stringValue
            article.thumbnailUrl = json["ThumbnailUrl"].stringValue
            article.section = section
            articles.append(article)
        }
        db.add(articles)
        completion(ArticleResult.success(articles))
    }
}
