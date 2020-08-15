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
    subcommands: [Paste.self, Copy.self]
  )
}

extension Clip {
  struct Paste: ParsableCommand {
    static var configuration =
      CommandConfiguration(abstract: "Inspect clipboard contents")

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
      pasteType =  NSPasteboard.PasteboardType.string
    case .string:
      pasteType =  NSPasteboard.PasteboardType.string
    case .color:
      pasteType =  NSPasteboard.PasteboardType.color
    case .rtf:
      pasteType =  NSPasteboard.PasteboardType.rtf
    case .rtfd:
      pasteType =  NSPasteboard.PasteboardType.rtfd
    case .html:
      pasteType =  NSPasteboard.PasteboardType.html
    case .tabular:
      pasteType =  NSPasteboard.PasteboardType.tabularText
  }

  return pasteType;
}