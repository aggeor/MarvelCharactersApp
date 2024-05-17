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
                LazyHStack(alignment: .bottom, spacing: 20) {
                    let comics=comicViewModel.comics?.filter{!$0.thumbnail.path!.contains("image_not_available")}
                    
                    ForEach(comics ?? [], id: \.self){comic in
                        let comicThumbnail = comic.thumbnail.fullPath
                        let comicUrl = comic.urls?.filter{$0.type == "detail"}.first?.url
                        if(comicThumbnail != nil){
                            NavigationLink(destination: ComicWebView(url: comicUrl ?? "")){
                                VStack{
                                    NetworkImage(url: comicThumbnail ?? "")
                                        .scaledToFill()
                                }
                            }
                            .task {
                                if (comicViewModel.hasReachedEnd(of: comic)){
                                    comicViewModel.fetchNext(characterId: characterId)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: 150, height: 250)
                            .scaledToFill()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .cornerRadius(16)
                            
                            
                        }
                    }
                }
                .padding(.horizontal,20)
            }
            .containerRelativeFrame(.horizontal, alignment: .center)
            
        }
        
        .onAppear{
            comicViewModel.fetch(characterId: characterId)
        }
    }
}
