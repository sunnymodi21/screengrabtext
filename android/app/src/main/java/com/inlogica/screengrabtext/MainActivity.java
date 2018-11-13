package com.inlogica.screengrabtext;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.content.Intent;

import android.widget.Toast;
import android.os.Handler;

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
                        final Handler countDownHandler = new Handler();
                        countDownHandler.postDelayed(new Runnable() {
                            int count = 7;
                            public void run() {
                                --count;
                                if(count==0){
                                    notifyScreenshot.cancelNotification();
                                    screenshot.startProjection();
                                } else {
                                    final Toast toast = Toast.makeText(getApplicationContext(),"screenshot in "+Integer.toString(count),Toast.LENGTH_SHORT);
                                    toast.show();
                                    if(count==1){
                                        Handler handler = new Handler();
                                            handler.postDelayed(new Runnable() {
                                            @Override
                                            public void run() {
                                                toast.cancel(); 
                                            }
                                        }, 500);
                                    } else {
                                        Handler handler = new Handler();
                                            handler.postDelayed(new Runnable() {
                                            @Override
                                            public void run() {
                                                toast.cancel(); 
                                            }
                                        }, 1000);
                                    }
                                    notifyScreenshot.showNotifiction(count);
                                    countDownHandler.postDelayed(this, 1000);
                                }
                            }
                        },1000);
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
