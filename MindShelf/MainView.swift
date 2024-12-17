//
//  MainView.swift
//  MyPersonalApp
//
//  Created by Alessandra Di Rosa on 15/12/24.
//


import SwiftUI

struct MainView: View {
    @State private var savedBooks: [Book] = []

    var body: some View {
        TabView {
            Tab("Library", systemImage: "books.vertical.fill") {
                LibraryView(savedBooks: $savedBooks)
                    .foregroundColor(.accent)
            }
            Tab("Search", systemImage: "magnifyingglass") {
                SearchView()
                    .foregroundColor(.accent)
            }
        }
    }
}

#Preview {
    MainView()
}
