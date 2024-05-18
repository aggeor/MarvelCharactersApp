//
//  ComicViewModel.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 12/5/24.
//

import Foundation
import CryptoKit

/// `ComicListViewModel` is a view model for the comics list
///
/// The purpose for this view model is to fetch the comics data and set them based on the `Comic` model
///
/// Returns a `[Comic]?`

class ComicListViewModel: ObservableObject{
    @Published var comics:[Comic]?=[]
    private var nextOffset=0
    
    /// Fetch the first batch of comic data for the current character based on the `characterId`
    func fetch(characterId: Int){
        let endpointUrl=getEndpointUrl()
        let publicKey = getPublicKey()
        let timeStamp = getTimestamp()
        let md5Hash = getMD5Hash()
        guard let url = URL(string: "\(endpointUrl):443/v1/public/characters/\(characterId)/comics?ts=\(timeStamp)&apikey=\(publicKey)&hash=\(md5Hash)")else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){[weak self] data, response, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let jsonComicDataWrapper = try JSONDecoder().decode(ComicDataWrapper.self, from: data)
                DispatchQueue.main.async{
                    self?.comics = jsonComicDataWrapper.data?.results
                    self?.filterComics()
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    /// Fetch the next batch of comic data for the current character based on the `characterId` and the `nextOffset`
    func fetchNext(characterId: Int){
        let endpointUrl=getEndpointUrl()
        let timestamp=getTimestamp()
        let publicKey=getPublicKey()
        let md5Hash=getMD5Hash()
        nextOffset+=20
        guard let url = URL(string: "\(endpointUrl):443/v1/public/characters/\(characterId)/comics?offset=\(nextOffset)&ts=\(timestamp)&apikey=\(publicKey)&hash=\(md5Hash)")else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){[weak self] data, response, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let jsonComicDataWrapper = try JSONDecoder().decode(ComicDataWrapper.self, from: data)
                DispatchQueue.main.async{
                    let nextComics: [Comic]?=(jsonComicDataWrapper.data?.results)!
                    if(nextComics != nil){
                        self?.comics! += nextComics!
                        self?.filterComics()
                    }
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    /// Helper function to determine if the current comic is the last on the current list of comics
    func hasReachedEnd(of comic:Comic) -> Bool{
        comics?.last?.id == comic.id
    }
    
    /// Helper function to remove comics from the list that don't have a thumbnail image available
    func filterComics(){
        self.comics?=self.comics?.filter{!$0.thumbnail.path!.contains("image_not_available")} ?? []
        self.comics?=self.comics?.filter{!$0.thumbnail.path!.contains("4c002e0305708")} ?? []
    }
}

