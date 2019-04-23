//
//  PlayData.swift
//  Project39
//
//  Created by Melissa  Garrett on 4/15/19.
//  Copyright © 2019 MelissaGarrett. All rights reserved.
//

import Foundation

class PlayData {
    var allWords = [String]()
    //var wordCounts = [String: Int]()
    var wordCounts: NSCountedSet!
    private(set) var filteredWords = [String]()
    
    init() {
        if let path = Bundle.main.path(forResource: "plays", ofType: "txt") {
            if let plays = try? String(contentsOfFile: path) {
                allWords = plays.components(separatedBy: CharacterSet.alphanumerics.inverted)
                allWords = allWords.filter { $0 != "" } // there were empty strings in file
                
                // Use dictionary to remove duplicate words (keys)
                /*for word in allWords {
                    if wordCounts[word] == nil {
                        wordCounts[word] = 1
                    } else {
                        wordCounts[word]! += 1
                    }
                }
                allWords = Array(wordCounts.keys) // Set 'allWords' with new list of non-duplicates*/
                
                // To remove duplicates and keep count of each item
                wordCounts = NSCountedSet(array: allWords)
                
                // To make words appearing more often listed at the top of table
                let sorted = wordCounts.allObjects.sorted {
                    wordCounts.count(for: $0) > wordCounts.count(for: $1)
                }
                
                allWords = sorted as! [String]
            }
            applyUserFilter("swift") // just a filter to start the app with
        }
    }
    
    func applyUserFilter(_ input: String) {
        if let userNumber = Int(input) {
            // we got a number
            applyFilter { self.wordCounts.count(for: $0) >= userNumber }
        } else {
            // we got a string
            applyFilter { $0.range(of: input, options: .caseInsensitive) != nil }
        }
    }
    
    func applyFilter(_ filter: (String) -> Bool) {
        filteredWords = allWords.filter(filter)
    }
}
