import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // チャンネルとハンドラコールバック登録

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name:  "platform_method/battery", binaryMessenger: controller as! FlutterBinaryMessenger)
    batteryChannel.setMethodCallHandler({
      (methodCall: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

        if (methodCall.method == "getBatteryInfo") {

          // バッテリー残量を取得
          let level = self.getBatteryLevel()

          // Flutterへ返す情報を作成
          let res = [
              "device": "iOS",
              "level": level,
          ]
          result(res)

        } else {
            result(FlutterMethodNotImplemented)
        }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // バッテリー残量を取得
  private func getBatteryLevel() -> Int {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true

    if (device.batteryState == UIDevice.BatteryState.unknown) {
      return -1
    } else {
      return Int(device.batteryLevel * 100)
    }
  }
}
