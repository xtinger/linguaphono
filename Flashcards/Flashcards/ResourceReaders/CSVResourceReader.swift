//
//  CSVResourceReader.swift
//  Flashcards
//
//  Created by Denis Voronov on 04/06/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import Foundation
import CSV

struct Columns {
    static let lesson = "Lesson"
    static let wordOriginal = "WordOriginal"
    static let phraseOriginal = "PhraseOriginal"
    static let phraseTranslated = "PhraseTranslated"
    static let delimiter = UnicodeScalar(",")!
}

class CSVResourceReader : ResourceReaderProtocol {

    var endpointURL: URL
    
    init(endpointURL: URL) {
        self.endpointURL = endpointURL
    }
    
    func read(completion: @escaping ResourceLoadingCompletion) {
        print(endpointURL)
        let dataTask = URLSession.shared.dataTask(with: endpointURL) { [weak self] data, response, error in
            guard let ws = self else {return}
            guard error == nil, let data = data else {
                print(error!)
                return
            }
            
            do {
                print(data)
                if let root = try ws.parseCSV(data: data) {
                    print(root)
                    completion(root)
                }
                
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }

    private func parseCSV(data: Data) throws -> Root? {
        guard let csvString = String.init(data: data, encoding: String.Encoding.utf8) else {throw ResourceReaderError.parseError}
        print(csvString)
        let csv = try! CSVReader(string: csvString, hasHeaderRow: true, trimFields: true, delimiter: Columns.delimiter, whitespaces: CharacterSet.whitespaces)
        
        var lessons: [Lesson] = []
        var words: [Word]?
        var word: Word?
        var phrases: [Phrase]?
        
        while let _ = csv.next() {
            if let wordOriginal = csv[Columns.wordOriginal], !wordOriginal.isEmpty {
                if let parsedWord = word, let parsedPhrases = phrases, parsedPhrases.count > 0 {
                    let newWord = Word(text: parsedWord.text, phrases: parsedPhrases)
                    words?.append(newWord)
                }
                word = Word(text: wordOriginal, phrases: [])
                phrases = []
            }
            
            if let lessonStr = csv[Columns.lesson], !lessonStr.isEmpty {
                
                if let parsedWords = words, parsedWords.count > 0 {
                    let newLesson = Lesson(words: parsedWords)
                    lessons.append(newLesson)
                }
                
                words = []
            }
            
            if let phraseOriginal = csv[Columns.phraseOriginal], let phraseTranslated = csv[Columns.phraseTranslated], !phraseOriginal.isEmpty, !phraseTranslated.isEmpty {
                let phrase = Phrase(textNormal: phraseOriginal, textBack: phraseTranslated)
                phrases?.append(phrase)
            }
        }
        
        guard let header = csv.headerRow, header.count >= 7 else {
            throw ResourceReaderError.parseError
        }
        
        let languageOriginal = header[5]
        let languageTranslation = header[6]
        guard !languageOriginal.isEmpty, !languageTranslation.isEmpty else  {
            throw ResourceReaderError.parseError
        }
        
        let block = Block(lessons: lessons, languageOriginal: languageOriginal, languageTranslation: languageTranslation)
        let root = Root(blocks: [block])
        
        return root
    }
}
