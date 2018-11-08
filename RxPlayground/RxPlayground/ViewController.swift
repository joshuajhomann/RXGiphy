//
//  ViewController.swift
//  RxPlayground
//
//  Created by Joshua Homann on 10/15/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    let text = BehaviorRelay<String>(value: "")
    var date: Date?
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium


        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [text] _ in
            text.accept(formatter.string(from: Date()))
        }

        text.asDriver().drive(label.rx.text).disposed(by: bag)


    }

    deinit {
        print("Deinitializing ViewController")
    }


}
