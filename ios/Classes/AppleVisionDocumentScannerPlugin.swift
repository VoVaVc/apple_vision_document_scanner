import Flutter
import UIKit
import VisionKit

enum ScannerError: Error {
    case noRootViewController
}

public class AppleVisionDocumentScannerPlugin: NSObject, FlutterPlugin, VNDocumentCameraViewControllerDelegate {
  var scanner: VNDocumentCameraViewController?
  var result: FlutterResult?

  override init() {
    super.init()
    #if targetEnvironment(simulator)
        self.scanner = nil
    #else
        self.scanner = VNDocumentCameraViewController()
        self.scanner!.delegate = self
    #endif
  }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "apple_vision_document_scanner", binaryMessenger: registrar.messenger())
    let instance = AppleVisionDocumentScannerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    
  private func destroy() {
    scanner?.dismiss(animated: false)
    return;
  }

  private func getRootController() throws -> UIViewController {
    guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
      throw ScannerError.noRootViewController
    }
    return rootViewController
  }

  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }

  private func hidePicker() {
    self.scanner!.dismiss(animated: true)
  }

  private func scan(result: @escaping FlutterResult) {
    Task {
      guard let scanner = self.scanner else {
        result(FlutterError(code: "SIMULATOR_NOT_SUPPORTED", message: "Document scanning is not supported in the simulator.", details: nil))
        return
      }
      guard VNDocumentCameraViewController.isSupported else {
        result(FlutterError(code: "UNSUPPORTED", message: "Document scanning is not supported.", details: nil))
        return
      }
      guard let rootController = try? getRootController() else {
        result(FlutterError(code: "NO_ROOT_VIEW_CONTROLLER", message: "Root view controller not found", details: nil))
        return
      }
      self.result = result
      rootController.present(scanner, animated: true)
    }
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

    DispatchQueue.main.async {
      self.result?(filenames)
      self.hidePicker()
    }
  }

  public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
    scanner!.dismiss(animated: true)

    DispatchQueue.main.async {
      self.result?(nil)
      self.hidePicker()
    }
  }

  public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
    self.hidePicker()
    DispatchQueue.main.async {
      self.result?(FlutterError(code: "SCAN_FAILED", message: "Failed to scan documents", details: error.localizedDescription))
    }
  }
   
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "scan":
        scan(result: result)
    case "destroy":
        destroy()
        result(nil)
    default:
        result(FlutterMethodNotImplemented)
    }
}
}
