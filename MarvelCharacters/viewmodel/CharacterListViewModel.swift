//
//  CharacterListController.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 12/5/24.
//

import Foundation


class CharacterListViewModel: ObservableObject{
    @Published var characters:[Character]?=[]
    private var nextOffset=0
    func fetchFirst(){
        let endpointUrl=getEndpointUrl()
        let timestamp=getTimestamp()
        let publicKey=getPublicKey()
        let md5Hash=getMD5Hash()
        guard let url = URL(string: "\(endpointUrl):443/v1/public/characters?ts=\(timestamp)&apikey=\(publicKey)&hash=\(md5Hash)")else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){[weak self] data, response, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let jsonCharacterDataWrapper = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
                DispatchQueue.main.async{
                    self?.characters = jsonCharacterDataWrapper.data?.results
                    self?.filterCharacters()
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchNext(){
        let endpointUrl=getEndpointUrl()
        let timestamp=getTimestamp()
        let publicKey=getPublicKey()
        let md5Hash=getMD5Hash()
        nextOffset+=20
        guard let url = URL(string: "\(endpointUrl):443/v1/public/characters?offset=\(nextOffset)&ts=\(timestamp)&apikey=\(publicKey)&hash=\(md5Hash)")else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){[weak self] data, response, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let jsonCharacterDataWrapper = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
                DispatchQueue.main.async{
                    let nextCharacters: [Character]?=(jsonCharacterDataWrapper.data?.results)!
                    if(nextCharacters != nil){
                        self?.characters! += nextCharacters!
                        
                        self?.filterCharacters()
                    }
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    func hasReachedEnd(of character:Character) -> Bool{
        characters?.last?.id == character.id
    }
    
    func filterCharacters(){
        self.characters?=self.characters?.filter{!$0.thumbnail!.path!.contains("image_not_available")} ?? []
        self.characters?=self.characters?.filter{!$0.thumbnail!.path!.contains("4c002e0305708")} ?? []
        
        
    }
}
