<img src="http://qmchenry.com/lion.svg"/>

[![swiftpm](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)

### Type-safe NSLocalizedStrings for Swift projects

Lion, a play on L10n and Localization, prides itself with making the use of localized strings safer and easier in iOS, 
macOS, tvOS and watchOS projects using Swift. Lion is a command line tool that reads a Localization.strings file and
generates a Swift file with nested structs and static strings.

Without Lion:

```swift
    label.text = NSLocalizedString("Alpha.Title.CreateNew", comment: "")
```

With Lion:
```swift
    label.text = L.Alpha.Title.CreateNew
```

In the pre-Lion version, the string literal "Alpha.Title.CreateNew" is not checked at buildtime or runtime for correctness.
If the string is mistyped, the label's text will contain the key name instead of the properly localized string. In the
case with Lion, a mistyped word would yield a build error and a quick fix. The QA team never needed to know.

For example, an input .strings file containing:

```asciidoc
"Alpha.Title" = "Title";
"Alpha.Title.CreateNew" = "Create New";
"Alpha.Button.Save" = "Save";
"Beta.Label.CreateNew" = "Create New";
"Beta.Label.CreateNewer" = "Create Newer";
```

will yield Swift code that looks like:

```swift
struct L {
  struct Beta {
    struct Label {
      static let CreateNewer = NSLocalizedString("Beta.Label.CreateNewer", comment: "")
      static let CreateNew = NSLocalizedString("Beta.Label.CreateNew", comment: "")
    }
  }
  struct Alpha {
    struct Title {
      static let CreateNew = NSLocalizedString("Alpha.Title.CreateNew", comment: "")
      static let rawValue = NSLocalizedString("Alpha.Title", comment: "")
    }
    struct Button {
      static let Save = NSLocalizedString("Alpha.Button.Save", comment: "")
    }
  }
}
```

# Building

Lion uses Swift Package Manager for builds and package accounting. To build Lion, open a terminal window, cd to the top directory of the repository, and type:

```asciidoc
swift build
```

The package manager will fetch the dependencies, their dependencies, and any great-great-dependencies. There are currently some deprecation warnings in a third-party package with Swift 3.1 that do not affect Lion's use.

The exectuable exists in .build/debug/lion after building with default settings.

# Usage

Basic Lion use requires a Localizable.strings file identified with the `-i` command line option:

```asciidoc
.build/debug/lion -i Samples/Short.strings
```

This will generate Swift code representing the strings in the Short.strings file in the project's Samples directory and print it to the terminal. 

To write directly to an output file, supply the path and filename with the `-o` option. This also provides a newness check that will prevent regenerating the output file if the input hasn't changed. 

```asciidoc
.build/debug/lion -i Samples/Short.strings -o /tmp/Lion.swift
```

These examples generate a tree of structs starting with a base of `L` by default. This yeilds short references like `L.alpha.Title.CreateNew` at the expense of some clarity. If you'd prefer a different base struct name like `Localizations` you can supply the name with the `-b` or `--basename` option:

```asciidoc
.build/debug/lion -i Samples/Short.strings -o /tmp/Lion.swift -b Localizations
```

Bonus points awarded if you use `-b 🦁`.

