//
//  ArticlesViewController.swift
//  NewsFeediOS
//
//  Created by Vince on 1/27/17.
//  Copyright © 2017 Vince Davis. All rights reserved.
//

import UIKit
import NewsFeedKit
import Kingfisher
import RealmSwift

class ArticlesViewController: UITableViewController {

    var results: Results<Article>!
    var articleSections: [Results<Article>]?
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "News Feed"
        let newsfeed = NewsFeedKit()
        newsfeed.getArticles(.topStories) { _ in
            newsfeed.getArticles(.business) { _ in
                newsfeed.getArticles(.entertainment) { _ in
                    
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startFetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return articleSections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleSections?[section].count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Top Stories"
        case 1: return "Business"
        case 2: return "Entertainment"
        default: return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let articles = articleSections?[indexPath.section]
        let article = articles?[indexPath.row]
        
        if let title = cell.viewWithTag(100) as? UILabel {
            title.text = article?.title ?? ""
        }
        
        if let url = URL(string: article?.thumbnailUrl ?? ""), let iv = cell.viewWithTag(200) as? UIImageView {
            iv.kf.setImage(with: url)
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detail") as? ArticleDetailViewController
        let articles = articleSections?[indexPath.section]
        let article = articles?[indexPath.row]
        vc?.article = article
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ArticlesViewController {
    func createSections() {
        articleSections = [
            results.filter("section = 0"),
            results.filter("section = 1"),
            results.filter("section = 2")
        ]
    }
    
    func startFetch() {
        results = NewsFeedKit().queryArticles()
        token = results?.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let tableview = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self?.createSections()
                tableview.reloadData()
                break
            case .update(_, _, _, _):
                // Query results have changed, so apply them to the UITableView
                self?.createSections()
                tableview.reloadData()
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
    }
    
    func stopFetch() {
        token?.stop()
    }
}

