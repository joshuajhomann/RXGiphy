//
//  RootViewController.swift
//  RxPlayground
//
//  Created by Joshua Homann on 10/15/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RootViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1e-3) { [label] in
            label?.text = "RxSwift Objects: \(RxSwift.Resources.total)"
        }
    }
}

