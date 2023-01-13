//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by 池田匠 on 2022/06/22.
//


import UIKit
import RealmSwift
// メモ画面用のクラス
class TweetDetailViewController: UIViewController {
    // textを表示させるためのUI部品

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var userName: UITextField!

    // MemoDataModelをこのクラス内で使えるように
    var tweetData = TweetDataModel()
    // コンピューティッドプロパティ DateFormatterの中身を書き換えてるというか設定してる
    // 日付のフォーマットを指定
    var dateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        displaydata()
        setDonebutton()
        textView.delegate = self

    }
    // MemoDetailViewControllerにメモデータを渡す　これはデータをもらう側の処理
    func configure(tweet: TweetDataModel) {
        tweetData = tweet
    }
    
    func displaydata() {
        textView.text = tweetData.text
        userName.text = tweetData.name
        //　ヘッダータイトル navigationItemはUIViewControllerのプロパティ
        // stringメソッドの引数に日付を渡してフォーマットを変更した状態でヘッダーに表示
        navigationItem.title = dateFormat.string(from: tweetData.recordDate)
    }
    @objc func tapDonebutton() {
        // 現在表示されているキーボードを閉じる
        view.endEditing(true)
    }
    // キーボードに閉じるボタンを追加する
    func setDonebutton() {
        // キーボードの上部にボタンを配置
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        // キーボードに閉じるボタンを設置
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDonebutton))
        // いっぱいボタンを追加できるから配列形式で
        toolBar.items = [commitButton]
        // inputAccessoryViewに入れることでキーボードの上にツールバーを配置できる
        textView.inputAccessoryView = toolBar
    }
    // データを保存するためのメソッド
    func saveData() {
        // realmクラスのインスタンス化　try!はエラー処理に関するもの
        let realm = try! Realm()
        // データモデルの保存
        try! realm.write{
            if let dateText = textView.text,
               let date = dateFormat.date(from: dateText) {
                // 日付を更新
                tweetData.recordDate = date
            }
            // 書き換え後のプロパティがmemoDataプロパティに反映されないため入力された文字列で上書きするようにする
            if let tweetText = textView.text{
            tweetData.text = tweetText //　この右辺のtextは入力された文字
            }

            if let nameText = userName.text{
                tweetData.name = nameText
            }
            // 文字列更新時にrecordDateもその時の日時で更新
            realm.add(tweetData)
        }
    }
}
// UItextViewの文字列が変更されるたびにデータが上書きされるようにしたい
extension TweetDetailViewController: UITextViewDelegate {
    // 文字列変更時に実行されるメソッド
    func textViewDidChange(_ textView: UITextView){
        //引数をたす
        // 入力後の文字列はtextViewのtextプロパティから取得可能
        saveData()

    }
}


