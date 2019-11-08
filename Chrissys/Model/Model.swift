//
//  Model.swift
//  Chrissys
//
//  Copyright © 2019 Chrissys. All rights reserved.
//

import Foundation

struct Model: Codable {
    enum MyEnum: Int, Codable {
        case one, two, three
    }
    let dateCreated: String
    let IMGURL: String
}
