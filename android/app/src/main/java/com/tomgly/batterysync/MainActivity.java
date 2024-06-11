package com.tomgly.batterysync;

// MethodChannelのため
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodCall;

// バッテリー取得のため
import android.content.Context;
import android.os.BatteryManager;

// 追加のプラグイン
import java.util.HashMap;
import java.util.Map;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // チャンネルとハンドラコールバック登録
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "platform_method/battery");
        channel.setMethodCallHandler((methodCall, result) -> {
            if (methodCall.method.equals("getBatteryInfo")) {

                // バッテリー残量を取得
                int level = getBatteryLevel();

                // Flutterへ返す情報を作成
                Map<String, Object> res = new HashMap<>();
                res.put("device", "Android");
                res.put("level", level);
                result.success(res);

            } else {
                result.notImplemented();
            }
        });
    }

    // バッテリー残量を取得
    private int getBatteryLevel() {
        BatteryManager manager = (BatteryManager) getSystemService(Context.BATTERY_SERVICE);
        return manager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    }
}
