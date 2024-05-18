//
//  SwiftUIView.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 12/5/24.
//

import SwiftUI

struct CharacterNavigationView: View {
    private let adaptiveColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let frameWidth = UIScreen.main.bounds.width/2.38
    let frameHeight = UIScreen.main.bounds.height/3.87
    @StateObject var characterViewModel =  CharacterListViewModel()
    var body: some View {
        NavigationView {
            let characters=characterViewModel.characters
            if(characterViewModel.characters != []){
                ScrollView{
                    Text("Characters")
                        .font(.title2)
                    Divider()
                        .padding(.bottom,32)
                    
                    LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                        ForEach(characters ?? [], id: \.self){
                            character in
                            let characterIndex = characters?.firstIndex(of: character) ?? 0
                            let charactersList = characters ?? []
                            let thumbnailPath = character.thumbnail?.fullPath ?? ""
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
                ProgressView()
                    .frame(alignment: .center)
            }
        }
        .onAppear{
            characterViewModel.fetchFirst()
        }
        
    }
}

