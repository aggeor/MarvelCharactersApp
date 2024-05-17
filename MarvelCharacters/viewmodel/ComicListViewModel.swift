//
//  ComicViewModel.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 12/5/24.
//

import Foundation
import CryptoKit


class ComicListViewModel: ObservableObject{
    @Published var comics:[Comic]?=[]
    private var nextOffset=0
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
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
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
    
    func hasReachedEnd(of comic:Comic) -> Bool{
        comics?.last?.id == comic.id
    }
    
    func filterComics(){
        self.comics?=self.comics?.filter{!$0.thumbnail.path!.contains("image_not_available")} ?? []
        self.comics?=self.comics?.filter{!$0.thumbnail.path!.contains("4c002e0305708")} ?? []
        
        
    }
}

