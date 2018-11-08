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
    }

    deinit {
        print("Deinitializing ViewController")
    }


}
