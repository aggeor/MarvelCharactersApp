//
//  DetailView.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 12/5/24.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let characterName:String
    let thumbnailPath:String
    let characterId:Int
    
    var body: some View {
        ZStack{
            AsyncImage(
                url: URL(string: thumbnailPath)!,
                transaction: Transaction(
                    animation: .spring(
                        response: 0.5,
                        dampingFraction: 0.65,
                        blendDuration: 0.025)
                )
            ){ phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                    //                        .transition(.move(edge: .trailing))
                        .ignoresSafeArea()
                    
                case .failure(_):
                    ProgressView()
                        .frame(alignment: .center)
                    
                case .empty:
                    ProgressView()
                        .frame(alignment: .center)
                    
                @unknown default:
                    ProgressView()
                        .frame(alignment: .center)
                }
            }
            .aspectRatio(contentMode: .fill)
            .overlay(
                LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .bottom)
            )
            VStack{
                Spacer()
                ComicsCarouselView(characterId: characterId)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar{ content:do {
            ToolbarItem(placement: .topBarLeading){
                Button{
                    presentationMode.wrappedValue.dismiss()
                } label:{
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text(characterName)
                    .foregroundColor(.white)
                    .font(.system(size: 32, weight: .medium,design: .rounded))
            }
            
        }
        }
        
    }
    
}

#Preview {
    DetailView(characterName: "3D-Man", thumbnailPath: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg", characterId: 1)
}
