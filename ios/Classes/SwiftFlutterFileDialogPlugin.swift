import Flutter
import UIKit

public class SwiftFlutterFileDialogPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_file_dialog", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterFileDialogPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  deinit {
      writeLog("SwiftFlutterFileDialogPlugin.deinit")
  }

  var openFileDialog: OpenFileDialog?
  var saveFileDialog: SaveFileDialog?

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      writeLog(call.method)
      guard let args = call.arguments as? [String: Any] else {
          result(FlutterError(code: "invalid_args", message: nil, details: nil))
          return
      }
      switch call.method {
      case "pickFile":
          openFileDialog = OpenFileDialog()
          let params = OpenFileDialogParams(data: args)
          openFileDialog!.pickFile(params, result: result)

      case "saveFile":
          saveFileDialog = SaveFileDialog()
          let params = SaveFileDialogParams(data: args)
          saveFileDialog!.saveFile(params, result: result)

      default:
          result(FlutterMethodNotImplemented)
      }
  }
}


struct OpenFileDialogParams {
    let dialogType: OpenFileDialogType
    let sourceType: UIImagePickerController.SourceType
    let allowEditing: Bool
    let allowedUtiTypes: [String]?
    let fileExtensionsFilter: [String]?

    init(data: [String: Any?]) {
        // dialog type
        let dialogTypeString = data["dialogType"] as? String ?? OpenFileDialogType.document.rawValue
        dialogType = OpenFileDialogType(rawValue: dialogTypeString) ?? OpenFileDialogType.document

        // source type
        let sourceTypeString = data["sourceType"] as? String ?? "photoLibrary"
        switch sourceTypeString {
        case "photoLibrary":
            sourceType = .photoLibrary
        case "savedPhotosAlbum":
            sourceType = .savedPhotosAlbum
        case "camera":
            sourceType = .camera
        default:
            sourceType = .photoLibrary
        }
        
        allowEditing = data["allowEditing"] as? Bool ?? false

        allowedUtiTypes = data["allowedUtiTypes"] as? [String]
        fileExtensionsFilter = data["fileExtensionsFilter"] as? [String]
    }
}

struct SaveFileDialogParams {
    let sourceFilePath: String?
    init(data: [String: Any?]) {
        sourceFilePath = data["sourceFilePath"] as? String
    }
}