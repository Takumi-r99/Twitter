//
//  TwitterTests.swift
//  TwitterTests
//
//  Created by 池田匠 on 2022/06/15.
//

import XCTest
@testable import Twitter

class TwitterTests: XCTestCase {

    override func setUpWithError() throws {
        // ここにセットアップコードを入力します。このメソッドは、クラス内の各テストメソッドを呼び出す前に呼び出されます。
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testExample() throws {
        let tweetController = AddTweetViewController()
        let tweetText = tweetController.tweetTest(tweetText: "テストテスト")
        XCTAssert(true)
    }
}
