<img src="http://qmchenry.com/lion.svg"/>
# Lion

<a href="https://swift.org/package-manager">
  <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
</a>

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

