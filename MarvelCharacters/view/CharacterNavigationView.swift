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
                        .padding(.bottom,32)
                    
                    LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                        ForEach(characters ?? [], id: \.self){
                            character in
                            let characterIndex = characters?.firstIndex(of: character) ?? 0
                            let charactersList = characters ?? []
                            let thumbnailPath = character.thumbnail?.fullPath ?? ""
                            NavigationLink(destination: DetailView(charactersList: charactersList, characterIndex: characterIndex)){
                                ZStack{
                                    NetworkImage(url: thumbnailPath)
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 180, height: 220)
                                        .overlay(LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .center))
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
//                            .padding()
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


#Preview {
    CharacterNavigationView()
}
