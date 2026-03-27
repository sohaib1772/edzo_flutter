import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

    // نخزن الحالة المبدئية
    var initialCaptureStatus: Bool = UIScreen.main.isCaptured
    var initialLink: String? = nil
    var channel: FlutterMethodChannel?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        GeneratedPluginRegistrant.register(with: self)
        
        // Capture initial link if launched from deep link
        if let url = launchOptions?[.url] as? URL {
            initialLink = url.absoluteString
        } else if let userActivityDictionary = launchOptions?[.userActivityDictionary] as? [AnyHashable: Any],
                  let userActivity = userActivityDictionary["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity,
                  userActivity.activityType == NSUserActivityTypeBrowsingWeb,
                  let webpageURL = userActivity.webpageURL {
            initialLink = webpageURL.absoluteString
        }

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        channel = FlutterMethodChannel(name: "flutter/secure", binaryMessenger: controller.binaryMessenger)

        // إرجاع الحالة المبدئية عند طلب Flutter
        channel?.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "getInitialCaptureStatus" {
                result(self?.initialCaptureStatus)
            } else if call.method == "getInitialLink" {
                result(self?.initialLink)
                self?.initialLink = nil // Clear after first retrieval
            }
        }

        // مراقبة أي تغيير في حالة التسجيل
        NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.channel?.invokeMethod("screenCaptured", arguments: UIScreen.main.isCaptured)
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Handle Custom URL Schemes (while app is running)
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        channel?.invokeMethod("onDeepLink", arguments: url.absoluteString)
        return super.application(app, open: url, options: options)
    }

    // Handle Universal Links (while app is running)
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            channel?.invokeMethod("onDeepLink", arguments: url.absoluteString)
        }
        return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
}