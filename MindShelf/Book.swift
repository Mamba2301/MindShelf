//
//  Book.swift
//  MyPersonalApp
//
//  Created by Alessandra Di Rosa on 15/12/24.
//


import Foundation
import SwiftData

@Model
class Book {
    var id: UUID
    var title: String
    var authorName: String
    var coverId: Int?
    var connections : String = ""
    var impressions : String = ""
    var questions: String = ""
    
    init(id: UUID = UUID(), title: String = "", authorName: String = "", coverId: Int?, connections: String = "", impressions: String = "", questions: String = "" ) {
        self.id = id
        self.title = title
        self.authorName = authorName
        self.coverId = coverId
        self.connections = connections
        self.impressions = impressions
        self.questions = questions
    }
}
