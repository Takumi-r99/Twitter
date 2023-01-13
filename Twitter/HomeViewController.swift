//
//  HomeViewController.swift
//  Twitter
//
//  Created by 池田匠 on 2022/06/21.
//

import Foundation
import UIKit //　UIに関するクラスが格納されたモジュール
import RealmSwift

class  HomeViewController: UIViewController{
    var tweetDataList: [TweetDataModel] = []

@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tweetButton: UIButton!
    
    var dateFormatter: DateFormatter {
        let dateFormatt = DateFormatter()
        dateFormatt.dateStyle = .long // 2022年4月24日　みたいなスタイル
        dateFormatt.timeZone = .current
        dateFormatt.locale = Locale(identifier: "ja-JP")
        return dateFormatt
    }

    @IBAction func tweetButton(_ sender: Any) {
        transitionToAddTweetView()
}
    
    override func viewDidLoad() {
        self.title = "ホーム"
        //　俺に任せろの意味
        tableView.dataSource = self
        // self = HomeViewController クラスを代入？　これで使えるようになる？
        tableView.delegate = self
        // UIView()とはさまざまなUIコンポーネントの親となるクラス　何の中身のないプレーンなクラス
        tableView.tableFooterView = UIView()  // 下の線を消したいから

        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension




    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 画面が表示される度にデータの更新
        setTweetData()
        // データは更新されたけど表示内容が更新されてないから更新する
        tableView.reloadData()
        setupTableView()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(TweetTableViewCell.nib(), forCellReuseIdentifier: TweetTableViewCell.reuseIdentifier)
    }

    func setTweetData() {
        // 読み込み？
        let realm = try! Realm()
        // インスタンス化したrealmからMemoDataModelクラスのデータを全件取得　filterもできる
        let result = realm.objects(TweetDataModel.self)
        // 取得結果を配列として代入する
        tweetDataList = Array(result)
    }
    func transitionToAddTweetView() {
        // EditorViewControllerを使えるようにする
        let storyboad = UIStoryboard(name: "AddTweetViewController", bundle: nil)
        // 「is initial view controller」が設定されている ViewController を取得する
        guard let addTweetViewController = storyboad.instantiateInitialViewController() as?AddTweetViewController else { return }
        addTweetViewController.delegate = self
        present(addTweetViewController, animated: true)
    }
    func getRecord(){
        let realm = try! Realm()
        tweetDataList = Array(realm.objects(TweetDataModel.self))
    }


}




// 拡張機能として約束事を定義する
extension HomeViewController: UITableViewDataSource{
    // UITableViewに表示するリストの数，セルの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 配列が持つcountプロパティ　配列の要素の数分のセルを用意したい
        return tweetDataList.count
    }
    //　リストの中身を定義　セルの構築
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.reuseIdentifier, for: indexPath) as? TweetTableViewCell else { return UITableViewCell() }
        let dateText = tweetDataList[indexPath.row].recordDate
        let date = dateFormatter.string(from: dateText)
        cell.bind(date: date, userName: tweetDataList[indexPath.row].name, tweetText: tweetDataList[indexPath.row].text)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate{
    //セルがタップされたときに呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //タップされた時にIndexPathにタップされた行の番号が入る
        // インスタンス化　コード上で使えるようにする
        // identityのとこにMemoDetailViewControllerって入れることでコード上で使えるようになる
        let storyboad = UIStoryboard(name: "Main", bundle: nil)
        // memoDetailViewControllerをインスタンス化
        let tweetDetailViewController = storyboad.instantiateViewController(identifier: "TweetDetailViewController") as!TweetDetailViewController
        // 画面遷移するときにMemoDetailViewControllerにデータを渡す
        // メモデータモデルを取り出す
        let tweetData = tweetDataList[indexPath.row]
        // これでデータを渡している
        tweetDetailViewController.configure(tweet: tweetData) // こーゆーのわからん
        // cellの選択の解除
        tableView.deselectRow(at: indexPath, animated: true)
        // 画面遷移メソッド
        navigationController?.pushViewController(tweetDetailViewController, animated: true)
    }
    // 横にスワイプした際に実行されるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // スワイプされたメモのindexPathを使ってメモデータリストから削除対象のメモデータを取得
        let targetTweet = tweetDataList[indexPath.row]
        // Realmのデータ削除処理
        let realm = try! Realm()
        try! realm.write {
            realm.delete(targetTweet)
        //　 定義したmemoDataListプロパティにはデータが残っている
        tweetDataList.remove(at: indexPath.row)
        // UItableViewの表示内容もこのままだと削除されたデータが残ったまま　cellの削除処理
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
 }
}

extension HomeViewController: AddTweetViewControllerDelegate{
    func recordUpdate() {
        getRecord()
        tableView.reloadData()
    }
}



