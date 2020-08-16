import ArgumentParser
import Cocoa

import ArgumentParser

enum DataType: String, ExpressibleByArgument, CaseIterable {
  case text, string, color, rtf, rtfd, html, tabular
}

struct Clip: ParsableCommand {
  static  var configuration = CommandConfiguration(
    abstract: "Inspect and manipulate the clipboard",
    version: "1.0.0",
    subcommands: [List.self, Paste.self, Copy.self]
  )
}

extension Clip {
  struct List: ParsableCommand {
    static var configuration =
      CommandConfiguration(abstract: "List all clipboard contents")

    func run() {
        Set(NSPasteboard.general.types ?? [])
          .forEach { 
            guard let dataType = toDataType(pasteType: $0) else { return }
            guard let data = NSPasteboard.general.string(forType: $0) else { return }
            let len = dataType.rawValue.count
            let delimiter = String(repeating: "-", count: len)

            print(delimiter)
            print(dataType)
            print(delimiter)
            print(data)
          }
    }
  }

  struct Paste: ParsableCommand {
    static var configuration =
      CommandConfiguration(abstract: "Get clipboard contents for one data type")

    @Option(
      help: "data type, one of [text, color, rtf, rtfd, html, tabular]"
    )
      var type: DataType = .text

    func run() throws {
      let pasteType = toPasteType(dataType: type)

      if let string = NSPasteboard.general.string(forType:pasteType) {
        print(string)
        throw ExitCode.success
      } else {
        print("Could not find string data of type '\(type)' on the system clipboard")
        throw ExitCode.failure
      }
    }
  }

  struct Copy: ParsableCommand {
    static var configuration =
      CommandConfiguration(abstract: "Manipulate clipboard contents")

    @Option(help: "data type, one of [text, color, rtf, rtfd, html, tabular]")
      var type: DataType = .text

    @Option(help: "input data")
      var data: String

    func run() throws {
      let pasteType = toPasteType(dataType: type)

      NSPasteboard.general.clearContents()
      NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string, pasteType], owner: nil)

      NSPasteboard.general.setString(data, forType: NSPasteboard.PasteboardType.string)
      NSPasteboard.general.setString(data, forType: pasteType)
    }
  }
}

Clip.main()

func toPasteType(dataType: DataType) -> NSPasteboard.PasteboardType {
  let pasteType: NSPasteboard.PasteboardType

  switch dataType {
    case .text:
      pasteType = NSPasteboard.PasteboardType.string
    case .string:
      pasteType = NSPasteboard.PasteboardType.string
    case .color:
      pasteType = NSPasteboard.PasteboardType.color
    case .rtf:
      pasteType = NSPasteboard.PasteboardType.rtf
    case .rtfd:
      pasteType = NSPasteboard.PasteboardType.rtfd
    case .html:
      pasteType = NSPasteboard.PasteboardType.html
    case .tabular:
      pasteType = NSPasteboard.PasteboardType.tabularText
  }

  return pasteType;
}


func toDataType(pasteType: NSPasteboard.PasteboardType) -> DataType? {
  switch pasteType {
    case NSPasteboard.PasteboardType.string:
      return Optional.some(.string)
    case NSPasteboard.PasteboardType.color:
      return Optional.some(.color)
    case NSPasteboard.PasteboardType.rtf:
      return Optional.some(.rtf)
    case NSPasteboard.PasteboardType.rtfd:
      return Optional.some(.rtfd)
    case NSPasteboard.PasteboardType.html:
      return Optional.some(.html)
    case NSPasteboard.PasteboardType.tabularText:
      return Optional.some(.tabular)
    default:
      return Optional.none
  }
}