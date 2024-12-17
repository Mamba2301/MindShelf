//
//  OpenLibraryBook.swift
//  MyPersonalApp
//
//  Created by Alessandra Di Rosa on 15/12/24.
//



import Foundation

struct OpenLibraryBook: Identifiable, Decodable {
    var id: String
    var title: String
    var authorName: [String]?
    var coverId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "key"
        case title
        case authorName = "author_name"
        case coverId = "cover_i"
    }
}

struct OpenLibrarySearchResult: Decodable {
    var docs: [OpenLibraryBook]
}
