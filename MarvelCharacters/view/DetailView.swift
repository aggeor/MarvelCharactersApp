//
//  DetailView.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 12/5/24.
//

import SwiftUI

/// The `DetailView` is the view that displays the selected character with their comics list
struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Get the characters list and the character index from the `CharacterNavigationView`
    let charactersList:[Character]
    let characterIndex:Int
    
    // Initialize the currentCharacterIndex state variable
    @State private var currentCharacterIndex: Int
    
    init(charactersList: [Character], characterIndex: Int) {
        self.charactersList = charactersList
        self.characterIndex = characterIndex
        _currentCharacterIndex = State(initialValue: characterIndex)
    }
    var body: some View {
        ScrollViewReader { value in
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVStack(spacing: 0) {
                    ForEach(0..<(charactersList.count), id: \.self) { i in
                        
                        // For each character set the currentCharacterThumbnail and currentCharacterId
                        let currentCharacterThumbnail=charactersList[i].thumbnail?.fullPath ?? ""
                        let currentCharacterId=charactersList[i].id ?? 0
                        
                        ZStack{
                            // Display the character image as the background for the view
                            NetworkImage(url: currentCharacterThumbnail, gradient: LinearGradient(colors: [.black, .clear], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 0.0, y: 0.2)))
                            
                            VStack{
                                // Spacer to move the `ComicsCarouselView` to the bottom of the view
                                Spacer()
                                // Add the `ComicsCarouselView` to display the list of comics
                                ComicsCarouselView(characterId: currentCharacterId)
                                    .padding(.vertical)
                            }
                            
                        }
                        .onAppear {
                            currentCharacterIndex = i
                        }
                        .containerRelativeFrame([.horizontal, .vertical])
                    }
                    
                }
            }
            .onAppear {
                // Move the navigator to the selected character
                value.scrollTo(characterIndex)
                
                // Remove background appearance of navigation bar
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = .clear
                appearance.shadowColor = .clear
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
            
        }
        // Remove default navigation bar back button
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .scrollTargetLayout()
        .scrollTargetBehavior(.paging)
        .toolbar {
            // Add custom navigation bar back button
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
            // Add custom navigation bar title with current character name
            ToolbarItem(placement: .principal) {
                Text(charactersList[currentCharacterIndex].name ?? "")
                    .foregroundColor(.white)
                    .font(.system(size: 32, weight: .medium, design: .rounded))
            }
        }
    }
}


