import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

    // نخزن الحالة المبدئية
    var initialCaptureStatus: Bool = UIScreen.main.isCaptured

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        GeneratedPluginRegistrant.register(with: self)

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "flutter/secure", binaryMessenger: controller.binaryMessenger)

        // إرجاع الحالة المبدئية عند طلب Flutter
        channel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "getInitialCaptureStatus" {
                result(self?.initialCaptureStatus)
            }
        }

        // مراقبة أي تغيير في حالة التسجيل
        NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            channel.invokeMethod("screenCaptured", arguments: UIScreen.main.isCaptured)
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}