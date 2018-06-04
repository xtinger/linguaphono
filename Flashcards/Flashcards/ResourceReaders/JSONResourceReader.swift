//
//  JSONReader.swift
//  Flashcards
//
//  Created by Denis Voronov on 04/06/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

class JSONResourceReader: IResourceReader {
    var endpointURL: URL
    
    init(endpointURL: URL) {
        self.endpointURL = endpointURL
    }
    
    func read(completion: @escaping ResourceLoadingCompletion) {
        let dataTask = URLSession.shared.dataTask(with: endpointURL) { data, response, error in
            guard error == nil, let data = data else {
                print(error!)
                return
            }
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Root.self, from: data)
                completion(root)
                print("prepare OK")
                
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
    
    
}
