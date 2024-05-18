//
//  ComicsCarousel.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 12/5/24.
//

import SwiftUI

/// The `ComicsCarouselView` is the view that displays the comics carousel for the current character
struct ComicsCarouselView: View {
    // Get current characterId
    let characterId: Int
    
    // Initialize the CharacterListViewModel
    @StateObject var comicViewModel =  ComicListViewModel()
    var body: some View {
        VStack{
            
            ScrollView(.horizontal, showsIndicators: false){
                LazyHStack(alignment: .bottom, spacing: 20) {                    
                    ForEach(comicViewModel.comics ?? [], id: \.self){comic in
                        // For each comic set the comicThumbnail and comicUrl
                        let comicThumbnail = comic.thumbnail.fullPath
                        let comicUrl = comic.urls?.filter{$0.type == "detail"}.first?.url
                        if(comicThumbnail != nil){
                            
                            // Create a navigation link that contains the comic image
                            // When the user taps on a comic navigate to the comics page on a webview
                            // Pass the comicUrl to open the comic page
                            NavigationLink(destination: ComicWebView(url: comicUrl ?? "")){
                                VStack{
                                    NetworkImage(url: comicThumbnail ?? "",gradient: nil)
                                }
                            }
                            .task {
                                // When the user reaches the end of the comics list, fetch the next batch of comics from the `ComicListViewModel`
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
            // When the view is instanciated fetch the first batch of comics from the `ComicListViewModel`
            comicViewModel.fetch(characterId: characterId)
        }
    }
}
