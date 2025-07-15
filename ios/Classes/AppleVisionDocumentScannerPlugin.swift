import Flutter
import UIKit
import VisionKit

enum AppleVisionDocumentScannerMethods: String {
    case scan, destroy
}

enum ScannerError: Error {
    case noRootViewController
    case unsupported
    case scanFailed(String)
}

public class AppleVisionDocumentScannerPlugin: NSObject, FlutterPlugin, VNDocumentCameraViewControllerDelegate {
  var scanner: VNDocumentCameraViewController
  var result: FlutterResult?

  override init() {
    super.init()
    #if targetEnvironment(simulator)
        fatalError("Plugin cannot run in the simulator.")
    #else
        self.scanner = VNDocumentCameraViewController()
        self.scanner.delegate = self
    #endif
  }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "apple_vision_document_scanner", binaryMessenger: registrar.messenger())
    let instance = AppleVisionDocumentScannerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    
  private func destroy() {
    scanner.dismiss(animated: false)
  }

  private func getRootController() throws -> UIViewController {
    guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
        throw ScannerError.noRootViewController;
    }
    return rootViewController
  }

  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }

  private func scan() throws {
    guard VNDocumentCameraViewController.isSupported else {
      throw ScannerError.unsupported;
    }
    guard let rootController = try? getRootController() else {
      throw ScannerError.noRootViewController;
    }
    rootController.present(self.scanner, animated: true)
  }

  public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
    let tempDirPath = getDocumentsDirectory()
    let currentDateTime = Date()
    let df = DateFormatter()
    df.dateFormat = "yyyyMMdd-HHmmss"
    
    let formattedDate = df.string(from: currentDateTime)
    var filenames: [String] = []
    for i in 0 ..< scan.pageCount {
        let page = scan.imageOfPage(at: i)
        let url = tempDirPath.appendingPathComponent(formattedDate + "-\(i).png")
        try? page.pngData()?.write(to: url)
        filenames.append(url.path)
    }

    result?(filenames)
  }

  public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
       result?(nil)
       scanner.dismiss(animated: true)
   }

   public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
       result?(FlutterError(code: "SCAN_ERROR", message: "Failed to scan documents", details: error.localizedDescription))
       scanner.dismiss(animated: true)
   }
   

  public func handle(_ call: FlutterMethodCall, resultArg: @escaping FlutterResult) {
    result = resultArg
    switch call.method {
    case AppleVisionDocumentScannerMethods.scan.rawValue:
      do {
            try scan()
        } catch {
            resultArg(FlutterError(code: "SCAN_ERROR", message: "Failed to start scan", details: error.localizedDescription))
        }
    case AppleVisionDocumentScannerMethods.destroy.rawValue:
      destroy()
    default:
      resultArg(FlutterMethodNotImplemented)
    }
  }
}
