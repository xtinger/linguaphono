//
//  IResourceReader.swift
//  Flashcards
//
//  Created by Denis Voronov on 04/06/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation

typealias ResourceLoadingCompletion = (Root)->()

enum ResourceReaderErrors: Error {
    case invalidUrl
    case parseError
}

protocol IResourceReader {
    func read(completion: @escaping ResourceLoadingCompletion)
}
