//
//  EditorViewController.swift
//  Twitter
//
//  Created by 池田匠 on 2022/06/23.
//

import UIKit
import RealmSwift
protocol AddTweetViewControllerDelegate{
    func recordUpdate()
}
class AddTweetViewController: UIViewController{
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var tweetTextView: UITextView!
    var tweetData = TweetDataModel()
    var delegate: AddTweetViewControllerDelegate?
    @IBAction func tweetButton(_ sender: Any) {
                saveTweet()

            }

    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }


    var dateFormatter: DateFormatter {
        let dateFormatt = DateFormatter()
        dateFormatt.dateStyle = .long // 2022年4月24日　みたいなスタイル
        dateFormatt.timeZone = .current
        dateFormatt.locale = Locale(identifier: "ja-JP")
        return dateFormatt
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.text = ""
        tweetTextView.delegate = self
    }
    func saveTweet(){
        let realm  = try! Realm()
        try! realm.write{
            if let nameText = userName.text{
                tweetData.name = nameText
            }
            if let tweetText = tweetTextView.text{
                tweetData.text = tweetText
            }
            realm.add(tweetData)
        }
        delegate?.recordUpdate()
        dismiss(animated: true)
    }

    func tweetTest(tweetText: String) -> Bool {
        let textCount = tweetText.count
        let maxlength = textCount <= 140
        return maxlength
    }

}

extension AddTweetViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 140
    }

}
