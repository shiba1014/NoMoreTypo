//
//  CheckStringTypoCommand.swift
//  NoMoreTypo
//
//  Created by Satsuki Hashiba on 2017/12/06.
//  Copyright © 2017年 Satsuki Hashiba. All rights reserved.
//

import Foundation
import XcodeKit
import AppKit

class CheckStringTypoCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        var typoLines: [(index: Int, message: String)] = []
        
        for lineIndex in 0 ..< invocation.buffer.lines.count {
            let line = invocation.buffer.lines[lineIndex] as! String
            
            let strings = getStrings(from: line)
            strings.flatMap { getWords(from: $0) }
                .forEach {
                    if let message = checkTypo(word: $0) {
                        typoLines.append((lineIndex, message))
                    }
            }
        }
        
        for i in 0..<typoLines.count {
            let typoInfo = typoLines[i]
            let insertIndex = typoInfo.index + i + 1
            invocation.buffer.lines.insert(typoInfo.message, at: insertIndex)
        }
        
        if typoLines.count == 0 {
            invocation.buffer.lines.insert("// No typo in String!👏", at: 0)
        }
        
        completionHandler(nil)
    }
}

private extension CheckStringTypoCommand {
    func getStrings(from line: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: "\"[^\"]+\"", options: NSRegularExpression.Options())
            let range = NSRange(0..<line.count)
            let results = regex.matches(in: line, options: NSRegularExpression.MatchingOptions.reportCompletion, range: range)
            return results.compactMap { (line as NSString).substring(with: $0.range) }
        } catch {
            return []
        }
    }
    
    func getWords(from name: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: "(?!\\.)[a-zA-Z][a-z]+", options: NSRegularExpression.Options())
            let range = NSRange(0..<name.count)
            let results = regex.matches(in: name, options: NSRegularExpression.MatchingOptions.reportCompletion, range: range)
            return results.compactMap { (name as NSString).substring(with: $0.range) }
        } catch {
            return []
        }
    }
    
    func checkTypo(word: String) -> String? {
        let checker = NSSpellChecker.shared
        let typoRange = checker.checkSpelling(of: word, startingAt: 0)
        var message: String = ""
        if typoRange.location != NSNotFound {
            message += "Typo👾: \"\(word)\" "
            guard let candidates = checker.guesses(forWordRange: typoRange, in: word, language: "en_US", inSpellDocumentWithTag: 0) else { return nil }
            if candidates.count > 0 {
                message += "Did you mean🤔: " + candidates.joined(separator: ", ")
            }
            return message
        } else {
            return nil
        }
    }
}



