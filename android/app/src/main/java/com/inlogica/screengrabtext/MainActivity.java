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
    private NotificationScreenShot notifyScreenshot;

  @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        
        notifyScreenshot = new NotificationScreenShot(this);

      MethodChannel screenShotChannel = new MethodChannel(getFlutterView(), CHANNEL);
        
        // call for the projection manager
        screenshot = new ScreenShot(this, screenShotChannel);
        screenshot.startProjection();

        screenShotChannel.setMethodCallHandler(
            new MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall call, Result result) {
                    if (call.method.equals("startProjection")) {

                        final Toast toast = Toast.makeText(getApplicationContext(),"screenshot in "+Integer.toString(5),Toast.LENGTH_SHORT);
                        toast.show();
                        Handler toastHandler = new Handler();
                        toastHandler.postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                toast.cancel(); 
                            }
                        }, 1000);

                        final Handler countDownHandler = new Handler();
                        countDownHandler.postDelayed(new Runnable() {
                            int count = 4;
                            public void run() {
                                if(count==0){
                                    screenshot.takeScreenShot(notifyScreenshot);
                                } else {
                                    final Toast toast = Toast.makeText(getApplicationContext(),"screenshot in "+Integer.toString(count),Toast.LENGTH_SHORT);
                                    toast.show();
                                    if(count==1){
                                        Handler toastHandler = new Handler();
                                        toastHandler.postDelayed(new Runnable() {
                                            @Override
                                            public void run() {
                                                toast.cancel(); 
                                            }
                                        }, 500);
                                    } else {
                                        Handler toastHandler = new Handler();
                                        toastHandler.postDelayed(new Runnable() {
                                            @Override
                                            public void run() {
                                                toast.cancel(); 
                                            }
                                        }, 1000);
                                    }
                                    countDownHandler.postDelayed(this, 1000);
                                }
                                --count;
                            }
                        },1000);
                    }
                }
            }
        );
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        screenshot.onActivityResult(requestCode, resultCode, data);
    }
}
