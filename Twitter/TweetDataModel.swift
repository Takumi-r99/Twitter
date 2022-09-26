//
//  TextDataModel.swift
//  Twitter
//
//  Created by 池田匠 on 2022/06/21.
//

import Foundation
import RealmSwift
// クラス継承　Realm
class TweetDataModel: Object{
    // データをちゃんと識別するために　識別子とはつける名前のこと
    @objc dynamic var id: String = UUID().uuidString // 重複しない文字列を返してくれる
    //  @objc dynamicはrealmの仕様
    @objc dynamic var text: String = ""
    @objc dynamic var recordDate: Date = Date()
}
