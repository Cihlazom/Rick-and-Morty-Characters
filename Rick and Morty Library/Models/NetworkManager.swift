//
//  NetworkManager.swift
//  Rick and Morty Library
//
//  Created by Vladislav on 14.04.2022.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    enum NetworkErrors: Error {
        case failedToGetUrl
        case failedToGetData
    }
    
    func requestAllInfo(page: Int ,completion: @escaping (Result<MainRequest, Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string:"https://rickandmortyapi.com/api/character?page=\(page)") else {
            completion(.failure(NetworkErrors.failedToGetUrl))
            return
        }

        let task = session.dataTask(with: url) { (data, _, error) in
            guard let data = data,
                  error == nil else {
                      completion(.failure(NetworkErrors.failedToGetData))
                      return
                  }
            do {
                let model = try JSONDecoder().decode(MainRequest.self, from: data)
                completion(.success(model))
            } catch {
                print("Error")
            }
        }
        task.resume()
    }
    
    func getCharacterById(id: Int, completion: @escaping (Result<CharacterInfo, Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string:"https://rickandmortyapi.com/api/character/\(id)") else {
            completion(.failure(NetworkErrors.failedToGetUrl))
            return
        }

        let task = session.dataTask(with: url) { (data, _, error) in
            guard let data = data,
                  error == nil else {
                      completion(.failure(NetworkErrors.failedToGetData))
                      return
                  }
            do {
                let model = try JSONDecoder().decode(CharacterInfo.self, from: data)
                completion(.success(model))
            } catch {
                print("Error")
            }
        }
        task.resume()
    }
}

