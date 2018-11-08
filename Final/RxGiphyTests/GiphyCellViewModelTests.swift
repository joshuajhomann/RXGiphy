//
//  GiphyCellViewModelTests.swift
//  GiphyCellViewModelTests
//
//  Created by Joshua Homann on 10/9/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit.UIColor
import Nimble
import Quick
import RxTest
import RxBlocking
@testable import RxGiphy

class GiphyCellViewModelTests: QuickSpec {
    var coordinator = MockCoordinator()
    var cachService = MockGifCacheService()
    override func spec() {
        beforeEach {
            self.coordinator = MockCoordinator()
            self.cachService = MockGifCacheService()
        }
        describe("ratingColorDriver") {
            it("is green when the rating is G") {
                var giphy = Giphy.sample
                giphy.rating = .g
                let viewModel = GiphyCellViewModel(coordinator: self.coordinator,
                                                   gifCacheService: self.cachService,
                                                   giphy: giphy)
                let color = try? viewModel.ratingColorDriver.asObservable().toBlocking().first()
                expect(color).to(equal(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
            }
        }
        describe("selectAction") {
            it("creates the .showDetail action") {
                let giphy = Giphy.sample
                let viewModel = GiphyCellViewModel(coordinator: self.coordinator,
                                                   gifCacheService: self.cachService,
                                                   giphy: giphy)
                viewModel.selectAction.execute(())


                expect {
                    guard let action = self.coordinator.lastAction else {
                        print("No action in coordinator")
                        return false
                    }
                    guard case .showDetail(let giphyToShow) = action else {
                        print("Wrong action recieved")
                        return false
                    }
                    guard giphyToShow == giphy else {
                        print("Wrong associated giphy")
                        return false
                    }
                    return true
                    }.toEventually(beTrue())
            }
        }
    }
}
