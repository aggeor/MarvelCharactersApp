//
//  ComicsCarousel.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 12/5/24.
//

import SwiftUI

struct ComicsCarouselView: View {
    let characterId: Int
    @StateObject var comicViewModel =  ComicListViewModel()
    var body: some View {
        VStack{
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(alignment: .top) {
                    let _ = print(comicViewModel.comics?.first?.title ?? "no title")
                    let comics=comicViewModel.comics?.filter{!$0.thumbnail.path!.contains("image_not_available")}
                    
                    let _ = print(comics ?? "no title")
                    ForEach(comics ?? [], id: \.self){comic in
                        let comicThumbnail = comic.thumbnail.fullPath
                        let comicUrl = comic.urls?.filter{$0.type == "detail"}.first?.url
                        if(comicThumbnail != nil){
                            NavigationLink(destination: ComicWebView(url: comicUrl ?? "")){
                                VStack{
                                    AsyncImage(url: URL(string: comicThumbnail!),
                                               scale: 3)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: 150, height: 250)
                            .scaledToFill()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .cornerRadius(16)
                            .padding(.horizontal)
                            
                        }
                    }
                }
            }
            .containerRelativeFrame(.horizontal, alignment: .center)
            
        }
        
        .onAppear{
            comicViewModel.fetch(characterId: characterId)
        }
    }
}

#Preview {
    ComicsCarouselView(characterId: 13943)
}
