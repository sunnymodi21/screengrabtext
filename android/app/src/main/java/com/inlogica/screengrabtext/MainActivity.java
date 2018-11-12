package com.inlogica.screengrabtext;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.content.Intent;
import java.util.Timer;
import java.util.TimerTask;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.inlogica.screengrabtext/takeshot";

    private ScreenShot screenshot;
    private MethodChannel screenShotChannel;
    private NotificationScreenShot notifyScreenshot;

  @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        
        notifyScreenshot = new NotificationScreenShot(this);

        screenShotChannel = new MethodChannel(getFlutterView(), CHANNEL);
        
        // call for the projection manager
        screenshot = new ScreenShot(this, screenShotChannel);
        screenShotChannel.setMethodCallHandler(
            new MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall call, Result result) {
                    if (call.method.equals("startProjection")) {
                        notifyScreenshot.showNotifiction(7);
                        final Timer myTimer = new Timer();
                        myTimer.scheduleAtFixedRate(new TimerTask() {
                            int count = 7;
                            @Override
                            public void run() {
                                --count;
                                if(count==0){
                                    myTimer.cancel();
                                    notifyScreenshot.cancelNotification();
                                    screenshot.startProjection();
                                } else {
                                    notifyScreenshot.showNotifiction(count);
                                }
                            }
                        },0,1000);
                    }
                }
            }
        );
            // ,new MethodChannel(){
            //     @Override 
            //     public void success(response) {
            //         Log.i("MSG", result);
            //       }
            //     @Override 
            //     public void error(String code, String msg, details) {
            //         Log.e("MSG", name failed +" "+ msg);
            //       }
            //     @Override 
            //     public voidnotImplemented() {
            //         Log.e("MSG", name+" not implemented");
            //       }
            // });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        screenshot.onActivityResult(requestCode, resultCode, data);
    }
}
