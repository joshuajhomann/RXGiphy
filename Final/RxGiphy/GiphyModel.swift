//
//  GiphyPage.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/15/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import Foundation

struct GiphyPage: Codable {
    var data: [Giphy]
}

struct GiphyContainer: Codable {
    var data: Giphy
}

struct Giphy: Codable, Equatable {
    var id: String
    var rating: Rating?
    var images: Images
    var title: String

    struct Images: Codable, Equatable {
        var original: Info
        var fixedHeight: Info
        enum CodingKeys: String, CodingKey {
            case original
            case fixedHeight = "fixed_height"
        }

        struct Info: Codable, Equatable {
            var url: URL
            var size: Int
            var sizeDescription: String {
                return ByteCountFormatter.fileSizeFormatter.string(fromByteCount: Int64(size))
            }

            enum CodingKeys: String, CodingKey {
                case url, size
            }

            init(from decoder: Decoder) throws
            {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                url = try values.decode(URL.self, forKey: .url)
                let sizeString = try values.decode(String.self, forKey: .size)
                size = Int(sizeString) ?? 0
            }

            func encode(to encoder: Encoder) throws
            {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(url, forKey: .url)
                try container.encode(size.description, forKey: .size)
            }
        }
    }

    enum Rating: String, Codable, CustomStringConvertible, Equatable {
        case g, pg, pg13 = "pg-13", r, y
        var description: String {
            switch self {
            case .g:
                return "Rated G"
            case .pg:
                return "Rated PG"
            case .pg13:
                return "Rated PG-13"
            case .r:
                return "Rated R"
            case .y:
                return "Rated Y"
            }
        }
    }

    static let sampleJSON = """
    {
      "id" : "JIX9t2j0ZTN9S",
      "title" : "funny cat GIF",
      "images" : {
        "original" : {
          "url" : "https://media3.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif?cid=e1bb72ff5be0f080613163437387c44d",
          "size" : "7712339"
        },
        "fixed_height" : {
          "url" : "https://media3.giphy.com/media/JIX9t2j0ZTN9S/200.gif?cid=e1bb72ff5be0f080613163437387c44d",
          "size" : "632576"
        }
      },
      "rating" : "g"
    }
    """

    static var sample: Giphy {
        return try! JSONDecoder().decode(Giphy.self, from: Giphy.sampleJSON.data(using: .utf8)!)
    }
}

