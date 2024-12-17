//
//  SearchView.swift
//  MyPersonalApp
//
//  Created by Alessandra Di Rosa on 15/12/24.
//


import SwiftData
import SwiftUI

struct SearchView: View {
    @Query var savedBooks: [Book]
    @Environment(\.modelContext) var context

    @State private var searchTerm = ""
    @State private var books: [OpenLibraryBook] = []
    @State private var progressState: ProgressState = .notStarted

    var body: some View {
        NavigationStack {
            Group {
                switch progressState {
                case .notStarted:
                    ContentUnavailableView(
                        "Start searching",
                        systemImage: "magnifyingglass",
                        description: Text("Enter the name of a book")
                            .foregroundColor(.accent)
                    )
                case .inProgress:
                    ProgressView("Loading books...")
                case .failed:
                    Text("faild")
                case .successful:
                    List(books) { book in
                        HStack {
                            if let coverId = book.coverId {
                                AsyncImage(
                                    url: URL(
                                        string:
                                            "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg"
                                    )
                                ) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 75)
                                        .cornerRadius(5)
                                        .accessibilityLabel("Cover image of \(book.title)")
                                } placeholder: {
                                    ProgressView()
                                        .progressViewStyle(
                                            CircularProgressViewStyle())
                                }
                            }

                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                    .accessibilityLabel("Title: \(book.title)")

                                if let authors = book.authorName {
                                    Text(authors.joined(separator: ", "))
                                        .font(.subheadline)
                                        .foregroundColor(.accent)
                                        .accessibilityLabel("Authors: \(authors.joined(separator: ", "))")
                                } else {
                                    Text("Unknown Author")
                                        .font(.subheadline)
                                        .foregroundColor(.accent)
                                        .accessibilityLabel("Unknown Author")
                                }
                            }
                            
                            Spacer()
                            
                            Button {
                                save(book)
                            } label: {
                                Text("Save")
                                    .foregroundColor(.accent)
                
                                    .accessibilityLabel("Save this book to your library")                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .foregroundColor(.accent)
        }
        .searchable(
            text: $searchTerm, prompt: "Search for a book title"
        )
        .onChange(of: searchTerm) { newValue, oldValue in
            guard !newValue.isEmpty else { return }
            Task {
                try? await Task.sleep(for: .microseconds(300))
                await searchBooks()
            }
        }

    }

    private func searchBooks() async {
        progressState = .inProgress

        var session: URLSession {
            let sessionConfiguration: URLSessionConfiguration
            sessionConfiguration = URLSessionConfiguration.default
            return URLSession(configuration: sessionConfiguration)
        }

        let urlEncodedSearchTerm = searchTerm.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed)

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "openlibrary.org"
        urlComponents.path = "/search.json"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: urlEncodedSearchTerm)
        ]

        guard let url = urlComponents.url else {
            progressState = .failed
            return
        }

        let request = URLRequest(url: url)

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                progressState = .failed
                print("Could not fetch data")
                return
            }

            let openLibraryResponse = try JSONDecoder().decode(
                OpenLibrarySearchResult.self, from: data)

            books = openLibraryResponse.docs
        } catch {
            print("\(error)")
        }

        progressState = .successful
    }

    private func save(_ book: OpenLibraryBook) {
           guard !isBookAlreadySaved(book) else {
               return  // If the book is already saved, do nothing
           }

           let storing = Book(
               title: book.title,
               authorName: book.authorName?.joined(separator: ", ") ?? "Unknown",
               coverId: book.coverId
           )
        context.insert(storing)
    }
    private func isBookAlreadySaved(_ book: OpenLibraryBook) -> Bool {
            // Check if the book is already saved by comparing titles (or other identifiers)
            return savedBooks.contains(where: { $0.title == book.title })
        }
}

#Preview {
    SearchView()
        .modelContainer(for: Book.self)
}
