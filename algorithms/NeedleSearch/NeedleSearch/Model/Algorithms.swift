//
//  Algorithms.swift
//
//  Project: NeedleSearch
// 
//  Author:  Uladzislau Volchyk
//  On:      05.05.2021
//

import Foundation

extension String {
    func sub(index: Int) -> Character {
        let charIndex: String.Index
        if index >= 0 {
            charIndex = self.index(self.startIndex, offsetBy: index)
        } else {
            charIndex = self.index(self.endIndex, offsetBy: index)
        }
        return self[charIndex]
    }
}

extension Character {
    var ascii: Int {
        return numericCast(unicodeScalars.first!.value)
    }
}

func rabinSearch(text: String, pattern: String) -> [Int] {
    var result = [Int]()
    guard !pattern.isEmpty && !text.isEmpty  else {
        return result
    }
    let parentSize = text.count
    let patternSize = pattern.count
    var parentHash = 0, patternHash = 0, power = 1
    for i in 0...parentSize - patternSize {
        if i == 0 {
            // building initial hash value
            for j in 0..<patternSize {
                parentHash += text.sub(index: patternSize - 1 - j).ascii * power
                patternHash += pattern.sub(index: patternSize - 1 - j).ascii * power
                if j < patternSize - 1 {
                    power *= 2
                }
            }
        } else {
            // sliding along the polynome
            let eachValue = parentHash - text.sub(index: i-1).ascii * power
            parentHash = 2 * eachValue + text.sub(index: patternSize - 1 + i).ascii
        }
        // check for a hash collision
        if parentHash == patternHash {
            var finished = true
            for j in 0..<patternSize {
                if text.sub(index: i + j) != pattern.sub(index: j) {
                    finished = false
                    break
                }
            }
            if finished {
                result.append(i)
            }
        }
    }
    return result
}

fileprivate func pi(_ text: String) -> [Int] {
    var pi = [Int](repeating: 0, count: text.count)
    (1..<text.count).forEach { i in
        var j = pi[i - 1]
        let iIndex = text.index(text.startIndex, offsetBy: i)
        let jIndex = text.index(text.startIndex, offsetBy: j)
        
        while j > 0 && text[iIndex...iIndex] != text[jIndex...jIndex] {
            j = pi[j - 1]
        }
        if text[iIndex...iIndex] == text[jIndex...jIndex] {
            j += 1
        }
        pi[i] = j
    }
    return pi
}


extension String {
    
    func kmp(ptrn: String) -> [Int] {
        
        var result = [Int]()
        let text = Array(self)
        let pattern = Array(ptrn)
        
        let textLength: Int = text.count
        let patternLength: Int = pattern.count
        
        guard !pattern.isEmpty else {
            return result
        }
        
        var suffixPrefix: [Int] = [Int](repeating: 0, count: patternLength)
        var textIndex: Int = 0
        var patternIndex: Int = 0
        
        let zeta = pi(ptrn)
        
        for patternIndex in (1 ..< patternLength).reversed() {
            textIndex = patternIndex + zeta[patternIndex] - 1
            suffixPrefix[textIndex] = zeta[patternIndex]
        }
        
        /* Search stage: scanning the text for pattern matching */
        textIndex = 0
        patternIndex = 0
        
        while textIndex + (patternLength - patternIndex - 1) < textLength {
            
            while patternIndex < patternLength && text[textIndex] == pattern[patternIndex] {
                textIndex = textIndex + 1
                patternIndex = patternIndex + 1
            }
            
            if patternIndex == patternLength {
                result.append(textIndex - patternIndex)
            }
            
            if patternIndex == 0 {
                textIndex += 1
            } else {
                patternIndex = suffixPrefix[patternIndex - 1]
            }
        }
        
        guard !result.isEmpty else {
            return result
        }
        
        return result
    }
}
