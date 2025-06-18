//
//  AladinBookDTO.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

struct AladinBookDTO: Decodable {
    let isbn13: String?
    let title: String
    let author: String
    let publisher: String?
    let description: String?
    let cover: String?
    let categoryName: String?
}
