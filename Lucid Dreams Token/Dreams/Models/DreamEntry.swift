//
//  Lucid Dreams Token
//
//  Created by jhonalejo zh on 17/6/26.
//

import Foundation

struct DreamEntry: Identifiable, Codable {
    
    let id: UUID
    var title: String
    var content: String
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        content: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
    }
}
