//
//  DetailView.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 12/5/24.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let charactersList:[Character]
    let characterIndex:Int
    
    
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
                        let currentCharacterThumbnail=charactersList[i].thumbnail?.fullPath ?? ""
                        let currentCharacterId=charactersList[i].id ?? 0
                        ZStack{
                            NetworkImage(url: currentCharacterThumbnail, gradient: LinearGradient(colors: [.black, .clear], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 0.0, y: 0.2)))
                            VStack{
                                Spacer()
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
                value.scrollTo(characterIndex)
                
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = .clear
                appearance.shadowColor = .clear
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .scrollTargetLayout()
        .scrollTargetBehavior(.paging)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text(charactersList[currentCharacterIndex].name ?? "")
                    .foregroundColor(.white)
                    .font(.system(size: 32, weight: .medium, design: .rounded))
            }
        }
    }
}


