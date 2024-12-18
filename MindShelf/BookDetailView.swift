//
//  BookDetailView.swift
//  MyPersonalApp
//
//  Created by Alessandra Di Rosa on 15/12/24.
//

import SwiftData
import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct BookDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    var book: Book
    
    @State private var connection: String
    @State private var impressions: String
    @State private var questions: String

    
    init(book: Book) {
        self.book = book
        _connection = State(initialValue: book.connections)
        _impressions = State(initialValue: book.impressions)
        _questions = State(initialValue: book.questions)
    }

    var body: some View {
        ScrollView {
            VStack {
                
                if let coverId = book.coverId {
                    AsyncImage(
                        url: URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg")
                    ) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 300)
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }

                Text(book.title)
                    .font(Font.custom("Georgia", size: 30))
                    .font(.title)
                    .padding()

                Text("By \(book.authorName)")
                    .font(Font.custom("Georgia", size: 20))
                    .foregroundColor(.accent)
                    .padding()

                Spacer()

              
                VStack(alignment: .leading) {
                    Text("Connections")
                        .font(Font.custom("Georgia", size: 20))
                        .padding(.top)

                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $connection)
                            .font(Font.custom("Georgia", size: 15))
                            .frame(height: 150)
                            .padding()
                            .background(Color.accent
                                .opacity(0.0))
                            .cornerRadius(8)
                            .border(Color.accent, width: 1)
                            .onSubmit {
                                dismissKeyboard()
                            }
                        
                        if connection.isEmpty {
                            Text("Emotions, characters, or places that have impacted me.")
                                .foregroundColor(.gray)
                                .font(Font.custom("Georgia", size: 15))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading) {
                    Text("Impressions")
                        .font(Font.custom("Georgia", size: 20))
                        .padding(.top)

                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $impressions)
                            .font(Font.custom("Georgia", size: 15))
                            .frame(height: 150)
                            .padding()
                            .background(Color.accent.opacity(0.0))
                            .cornerRadius(8)
                            .border(Color.accent, width: 1)
                            .onSubmit {
                                dismissKeyboard()
                            }
                        
                        if impressions.isEmpty {
                            Text("With my experience, with my readings, what does this text remind me of?")
                                .foregroundColor(.gray)
                                .font(Font.custom("Georgia", size: 15))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                    }
                }
                .padding(.horizontal)

               
                VStack(alignment: .leading) {
                    Text("Questions")
                        .font(Font.custom("Georgia", size: 20))
                        .padding(.top)

                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $questions)
                            .font(Font.custom("Georgia", size: 15))
                            .frame(height: 150)
                            .padding()
                            .background(Color.accent.opacity(0.0))
                            .cornerRadius(8)
                            .border(Color.accent, width: 1)
                            .onSubmit {
                                dismissKeyboard()
                            }
                        
                        if questions.isEmpty {
                            Text("Is there something I don't understand? Why is that happening? If I could...")
                                .foregroundColor(.gray)
                                .font(Font.custom("Georgia", size: 15))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()

               
                Button("Save Changes") {
                    saveChanges()
                }
                .font(Font.custom("Georgia", size: 20))
                .padding()
                .foregroundColor(.accent)
                .background(Color.accent.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .onTapGesture {
            self.dismissKeyboard()
        }
        .navigationTitle(book.title)
        .foregroundColor(.accent)
        .padding()
    }

   
    private func saveChanges() {
        
        book.connections = connection
        book.impressions = impressions
        book.questions = questions

      
        do {
            try modelContext.save()
            print("Changes saved successfully!")
        } catch {
            print("Error saving changes: \(error)")
        }
        dismiss()
    }
}

#Preview {
    BookDetailView(
        book: Book(
            title: "Sample Book",
            authorName: "Sample Author",
            coverId: 12345,
            connections: "Emotions, characters, or places that have impacted me.",
            impressions: "With my experience, with my readings, what does this text remind me of?",
            questions: "Is there something I don't understand? Why is that happening? If I could..."
        )
    )
}

