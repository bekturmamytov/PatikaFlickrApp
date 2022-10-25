//
//  Photos.swift
//  FlickrClientApp
//
//  Created by Bektur Mamytov on 24/10/22.
//

import Foundation

struct Photos: Codable {
    let page: Int?
    let pages: Int?
    let perpage: Int?
    let total: Int?
    let photo: [Photo]?
}
