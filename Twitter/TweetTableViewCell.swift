//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by 池田匠 on 2022/06/28.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TweetTableViewCell"
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetText: UILabel!





    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    static func nib() -> UINib {
        return UINib(nibName: TweetTableViewCell.reuseIdentifier, bundle: nil)
    }
    func bind(date: String, userName: String, tweetText: String) {
        self.date.text = date
        self.userName.text = userName
        self.tweetText.text = tweetText//textView
    }
}
