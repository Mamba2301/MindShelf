//
//  LibraryView.swift
//  MyPersonalApp
//
//  Created by Alessandra Di Rosa on 15/12/24.
//


import SwiftData
import SwiftUI

struct LibraryView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var savedBooks: [Book]
    @Query private var savedBooksNew: [Book]

    @State private var isEditing = false
    // Definisci il layout della griglia (numero di colonne)
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            VStack {
                if savedBooksNew.isEmpty {
                    ContentUnavailableView(
                        "No books saved yet", systemImage: "book.pages")
                } else {
                    // LazyVGrid per una visualizzazione a griglia
                    ScrollView {
                        LazyVGrid(columns: gridItems, spacing: 16) {
                            ForEach(savedBooksNew) { savedBook in
                                // Aggiungi un NavigationLink per la navigazione al dettaglio
                                NavigationLink(destination: BookDetailView(book: savedBook)
                                ) {
                                    VStack {
                                        if let coverId = savedBook.coverId {
                                            AsyncImage(
                                                url: URL(
                                                    string:
                                                        "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg"
                                                )
                                            ) { image in
                                                image.resizable()
                                                    .scaledToFit()
                                                    .frame(
                                                        width: 100, height: 150
                                                    )  // Imposta le dimensioni della copertina
                                                    .cornerRadius(10)
                                                    .accessibilityLabel("Cover image of \(savedBook.title)")  // Accessibilità per l'immagine
                                            } placeholder: {
                                                ProgressView()
                                                    .progressViewStyle(
                                                        CircularProgressViewStyle()
                                                    )
                                            }
                                        }
                                        
                                        Text(savedBook.title)
                                            .font(Font.custom("Georgia", size: 15))
                                            .lineLimit(1)  // Limita il testo del titolo a una sola linea
                                            .foregroundColor(.accent)
                                            .accessibilityLabel("Title: \(savedBook.title)")  // Accessibilità per il titolo
                                        
                                        Text(savedBook.authorName)
                                            .font(Font.custom("Georgia", size: 15))
                                            .foregroundColor(.accent)
                                            .lineLimit(1)  // Limita il testo del nome autore a una sola linea
                                            .accessibilityLabel("Author: \(savedBook.authorName)")  // Accessibilità per l'autore
                                    }
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.accent))  // Aggiungi un bordo per il libro
                                }
                                
                                if isEditing {
                                    Button(action: {
                                        deleteBook(from: savedBook)  // Chiama la funzione di eliminazione
                                    }) {
                                        Image(systemName: "xmark.square.fill")
                                            .font(.title)
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.white, Color.accent)
                                            .accessibilityLabel("Delete \(savedBook.title)")
                                    }
                                    .offset(x: 7, y: -7)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Library")
            
            .foregroundColor(.accent)
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Done" : "Edit") {
                        withAnimation {
                            isEditing.toggle()  // Cambia lo stato di isEditing
                        }
                    }
                    .font(Font.custom("Georgia", size: 20))
                    .accessibilityLabel(isEditing ? "Finish editing" : "Start editing")  // Accessibilità per il pulsante di modifica
                }
            }
        }
    }

    private func deleteBook(from book: Book) {
        print("Deleting: \(book.title)")
        modelContext.delete(book)
    }
}

#Preview {
    LibraryView(savedBooks: .constant([]))
}
