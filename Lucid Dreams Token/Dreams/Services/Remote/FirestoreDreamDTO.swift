//
//  FirestoreDreamDTO.swift
//  Lucid Dreams Token
//
//  Created by Development Team on 2026.
//

import Foundation

struct FirestoreDreamDTO: Codable, Sendable {
    let id: String
    let title: String
    let content: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case createdAt
    }
}
