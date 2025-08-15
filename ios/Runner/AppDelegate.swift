import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    GeneratedPluginRegistrant.register(with: self)
    
    if let window = self.window {
        let secureView = UIView(frame: window.bounds)
        secureView.backgroundColor = .black
        secureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: nil, queue: .main) { _ in
            if UIScreen.main.isCaptured {
                // أظهر طبقة سوداء عند تسجيل الشاشة أو أخذ سكرين شوت
                window.addSubview(secureView)
            } else {
                // إزالة الطبقة السوداء عند انتهاء التسجيل
                secureView.removeFromSuperview()
            }
        }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}