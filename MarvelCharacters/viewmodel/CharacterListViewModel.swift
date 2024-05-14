//
//  CharacterListController.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 12/5/24.
//

import Foundation


class CharacterListViewModel: ObservableObject{
    @Published var characters:[Character]?=[]
    func fetch(){
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
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
}
