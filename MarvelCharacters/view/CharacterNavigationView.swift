//
//  SwiftUIView.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 12/5/24.
//

import SwiftUI

struct CharacterNavigationView: View {
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170))
    ]
    @StateObject var characterViewModel =  CharacterListViewModel()
    var body: some View {
        NavigationView {
            let characters=characterViewModel.characters
            if(characterViewModel.characters != []){
                ScrollView{
                    Text("Characters")
                        .font(.title2)
                    Divider()
                    
                    LazyVGrid(columns: adaptiveColumns) {
                        ForEach(characters ?? [], id: \.self){
                            character in
                            let thumbnailPath = character.thumbnail?.fullPath ?? ""
                            let characterName = character.name
                            let characterId = Int(character.id ?? 0)
                            NavigationLink(destination: DetailView(characterName:characterName ?? "",thumbnailPath: thumbnailPath,characterId: characterId)){
                                ZStack{
                                    AsyncImage(url: URL(string:thumbnailPath),
                                               scale: 3)
                                    .aspectRatio(contentMode: .fill)
                                    .scaledToFit()
                                    .frame(width: 180, height: 220)
                                    .overlay(LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .top))
                                    Text("\(character.name ?? "")")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .medium,design: .rounded))
                                        .frame(maxHeight:.infinity, alignment: .bottom)
                                        .padding()
                                }
                            }
                            .task {
                                if (characterViewModel.hasReachedEnd(of: character)){
                                    characterViewModel.fetchNext()
                                }
                            }
                            
                            .background(.clear)
                            .cornerRadius(20)
                            .padding()
                        }
                    }
                    
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


#Preview {
    CharacterNavigationView()
}
