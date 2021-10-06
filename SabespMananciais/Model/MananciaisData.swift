//
//  MananciaisData.swift
//  SabespMananciais
//
//  Created by Ed Yama on 05/10/21.
//

import Foundation

struct MananciaisData: Codable {
    let name: String
    let data: [Manancial]
}

struct Manancial: Codable {
    let key: String
    let value: String
}
