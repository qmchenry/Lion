//
//  ReservedWords.swift
//  lion
//
//  Created by Quinn McHenry on 6/9/17.
//
//

import Foundation

struct ReservedWords {
    
    // from https://github.com/apple/swift/blob/master/docs/archive/LangRefNew.rst#reserved-keywords
    
    static let keywords: Set<String> = [
        // Declarations and Type Keywords
        "class",
        "destructor",
        "extension",
        "import",
        "init",
        "func",
        "enum",
        "protocol",
        "struct",
        "subscript",
        "Type",
        "typealias",
        "var",
        "where",
        
        // Statements
        "break",
        "case",
        "continue",
        "default",
        "do",
        "else",
        "if",
        "in",
        "for",
        "return",
        "switch",
        "then",
        "while",
        
        // Expressions
        "as",
        "is",
        "new",
        "super",
        "self",
        "Self",
        "type",
        "__COLUMN__",
        "__FILE__",
        "__LINE__",
    ]

    public static func escapeIfNeeded(_ input: String) -> String {
        if keywords.contains(input) {
            return "`\(input)`"
        }
        return input
    }
    
}
