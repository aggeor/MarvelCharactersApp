//
//  SwiftUIView.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 12/5/24.
//

import SwiftUI


/// The `CharacterNavigationView` is the main view of the app displays the character list retrieved from the `CharacterListViewModel`
struct CharacterNavigationView: View {
    
    // Adjust the `LazyVGrid` to two columns
    private let adaptiveColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    // Get the frame width and height to adjust the size of the items based on the screen size
    let frameWidth = UIScreen.main.bounds.width/2.38
    let frameHeight = UIScreen.main.bounds.height/3.87
    
    // Initialize the CharacterListViewModel
    @StateObject var characterViewModel =  CharacterListViewModel()
    var body: some View {
        NavigationView {
            let characters=characterViewModel.characters
            if(characterViewModel.characters != []){
                ScrollView{
                    // Set the title
                    Text("Characters")
                        .font(.title2)
                    // Add a divider line between title and characters list section
                    Divider()
                        .padding(.bottom,32)
                    
                    // Add the characters in a `LazyVGrid`
                    LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                        ForEach(characters ?? [], id: \.self){
                            character in
                            
                            // For each character set the characterIndex, charactersList and character image thumbnailPath
                            let characterIndex = characters?.firstIndex(of: character) ?? 0
                            let charactersList = characters ?? []
                            let thumbnailPath = character.thumbnail?.fullPath ?? ""
                            
                            // Create a navigation link that contains the character image and the character name
                            // When the user taps on a character navigate to the `DetailsView`
                            // Pass the charactersList to create the list of characters within the `DetailsView`
                            // Pass the characterIndex to display the selected character
                            NavigationLink(destination: DetailView(charactersList: charactersList, characterIndex: characterIndex)){
                                ZStack{
                                    NetworkImage(url: thumbnailPath, gradient: LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .center))
                                    Text("\(character.name ?? "")")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .medium,design: .rounded))
                                        .frame(maxHeight:.infinity, alignment: .bottom)
                                        .padding()
                                }
                            }
                            .frame(width: frameWidth, height: frameHeight)
                            .task {
                                // When the user reaches the end of the characters list, fetch the next batch of characters from the `CharacterListViewModel`
                                if (characterViewModel.hasReachedEnd(of: character)){
                                    characterViewModel.fetchNext()
                                }
                            }
                            
                            .background(.clear)
                            .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                }
                
            }else{
                // While loading the data show a `ProgressView`
                ProgressView()
                    .frame(alignment: .center)
            }
        }
        .onAppear{
            // When the view is instanciated fetch the first batch of characters from the `CharacterListViewModel`
            characterViewModel.fetchFirst()
        }
        
    }
}

