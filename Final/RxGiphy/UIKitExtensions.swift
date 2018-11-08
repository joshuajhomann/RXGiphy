//
//  UIKitExtensions.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/17/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit

protocol NamablebyType {
    static var name: String { get }
}

extension NamablebyType {
    static var name: String {
        return String(describing: Self.self)
    }
}

extension UIViewController: NamablebyType { }
extension UIView: NamablebyType { }

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionViewCell: ReuseIdentifiable {}

extension ByteCountFormatter {
    static var fileSizeFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter
    }()
}

