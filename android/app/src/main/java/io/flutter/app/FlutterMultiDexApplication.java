package io.flutter.app;

import android.app.Application;
import io.flutter.view.FlutterMain;
import androidx.multidex.MultiDex;

public class FlutterMultiDexApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        MultiDex.install(this);
        FlutterMain.startInitialization(this);
    }
}