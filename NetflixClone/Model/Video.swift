//
//  Video.swift
//  NetflixClone
//
//  Created by 강동영 on 7/22/24.
//

import Foundation

struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Codable {
    let key: String
    let site: String
    let type: String
}

