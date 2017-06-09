import GenKit
import CommandLineKit
import FileKit
import Foundation


let inputPath = StringOption(shortFlag: "i", longFlag: "input", required: true, helpMessage: "Input localization.strings file")
let outputPath = StringOption(shortFlag: "o", longFlag: "output", helpMessage: "Output file (writes to stdout if not provided)")
let quietOption = BoolOption(shortFlag: "q", longFlag: "quiet", helpMessage: "Suppress non-error output")

let cli = CommandLine()
cli.setOptions(inputPath, outputPath, quietOption)

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

guard let inputFile = inputPath.value else {
    print("Error understanding input file path")
    exit(EX_USAGE)
}


let input = Path(inputFile)
let output = outputPath.value.map{ Path($0) }
let quiet = quietOption.wasSet

let lines: [String]

do {
    let rawStrings = try String(contentsOf: URL(fileURLWithPath: input.rawValue), encoding: .utf8)
    lines = rawStrings.components(separatedBy: .newlines)
} catch let error {
    print(error.localizedDescription)
    exit(EX_DATAERR)
}

let keyPaths = lines.flatMap{ s -> String? in
    let c = s.components(separatedBy: "\"")
    return c.count > 1 ? c[1] : nil
}.sorted()

struct S {
    let name: String
    let keyPath: String
    let indent: Int
    let hasString: Bool
    let closing: Bool
    let leaf: Bool
    let indentString: String
    
    init(name: String = "", keyPath: String = "", indent: Int, hasString: Bool = false, closing: Bool = false, leaf: Bool = false) {
        self.name = name
        self.keyPath = keyPath
        self.indent = indent
        self.closing = closing
        self.hasString = hasString
        self.leaf = leaf
        self.indentString = String(repeating: "  ", count: indent + 1)
    }
}

var ss = [S]()
var set = Set<String>()
var lastLevel = 0
var lastKeyPath = ""

keyPaths.reversed().forEach { keyPath in
    let c = keyPath.components(separatedBy: ".")
    let isLeaf = set.isEmpty || !lastKeyPath.hasPrefix(keyPath)
    lastKeyPath = keyPath
    
    for level in (0...c.count-1) {

        let a = c[0...level]
        let subKeyPath = a.joined(separator: ".")
        if set.contains(subKeyPath) && subKeyPath == keyPath {
            ss.append(S(name: c[level], keyPath: keyPath, indent: level + 1, hasString: level == c.count-1, leaf: isLeaf))
        } else if !set.contains(subKeyPath) || subKeyPath == keyPath {
            if lastLevel > level {
                (level...lastLevel-1).reversed().forEach {
                    ss.append(S(indent: $0, closing: true))
                }
            }
            lastLevel = level

            set.insert(subKeyPath)
            ss.append(S(name: c[level], keyPath: keyPath, indent: level, hasString: level == c.count-1, leaf: isLeaf))
            
        }
    }
}

if lastLevel > 0 {
    (0...lastLevel-1).reversed().forEach {
        ss.append(S(indent: $0, hasString: false, closing: true))
    }
}

let dictionary = ["strings": ss]

//ss.forEach {
//    print($0)
//}

let template =
"struct L {\n" +
"{% for string in strings %}" +
"{{ string.indentString }}" +
"{% if string.closing %}}\n" +
"{% elif string.hasString %}" +
  "static let " +
  "{% if string.leaf %}" +
    "{{ string.name }}" +
  "{% else %}" +
    "rawValue" +
  "{% endif %}" +
  " = NSLocalizedString(\"{{ string.keyPath }}\", comment: \"\")\n" +
"{% else %}" +
"struct {{ string.name }} {\n" +
"{% endif %}" +
"{% endfor %}" +
"}\n"

do {
    let rendered = try GenKit.generate(dictionary, templateString: template, template: .stencil)
    print(rendered)
} catch let error {
    print(error.localizedDescription)
}

