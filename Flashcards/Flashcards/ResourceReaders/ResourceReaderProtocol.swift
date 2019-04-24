//
//  IResourceReader.swift
//  Flashcards
//
//  Created by Denis Voronov on 04/06/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

typealias ResourceLoadingCompletion = (Root)->()

enum ResourceReaderError: Error {
    case invalidUrl
    case parseError
}

protocol ResourceReaderProtocol {
    func read(completion: @escaping ResourceLoadingCompletion)
}
