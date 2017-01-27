//
//  ArticleDetailViewController.swift
//  NewsFeediOS
//
//  Created by Vince on 1/27/17.
//  Copyright © 2017 Vince Davis. All rights reserved.
//

import UIKit
import NewsFeedKit
import Kingfisher
public class ArticleDetailViewController: UIViewController {

    public var article: Article?
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Detail"
        let url = URL(string: article?.thumbnailUrl ?? "")
        image?.kf.setImage(with: url)
        
        titleLabel.text = article?.title ?? ""
        descriptionLabel.text = article?.desc ?? ""
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
