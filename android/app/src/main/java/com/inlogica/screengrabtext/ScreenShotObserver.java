package com.inlogica.screengrabtext;

import android.content.Context;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.util.Log;
import android.database.ContentObserver;
import android.os.HandlerThread;
import android.net.Uri;
import android.database.Cursor;

import java.io.File;
import io.flutter.plugin.common.MethodChannel;

public class ScreenShotObserver {

    private String TAG = "ScreenShotObserver";
    private NotificationScreenShot notifyScreenshot;
    public void screenShotObserve(Context mainContext, MethodChannel screenShotFlutChannel){
        final Context context = mainContext;
        final MethodChannel screenShotChannel = screenShotFlutChannel;
        HandlerThread handlerThread = new HandlerThread("content_observer");
        handlerThread.start();
        final Handler handler = new Handler(handlerThread.getLooper()) {
    
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);
            }
        };

        context.getContentResolver().registerContentObserver(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                true,
                new ContentObserver(handler) {

                    private File pix = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
                    private String screenShotPath = new File(pix, "Screenshots").getAbsolutePath();

                    @Override
                    public boolean deliverSelfNotifications() {
                        return super.deliverSelfNotifications();
                    }
    
                    @Override
                    public void onChange(boolean selfChange) {
                        super.onChange(selfChange);
                    }
    
                    @Override
                    public void onChange(boolean selfChange, Uri uri) {
                        if (uri.toString().matches(MediaStore.Images.Media.EXTERNAL_CONTENT_URI.toString() + "/[0-9]+")) {
    
                            Cursor cursor = null;
                            try {
                                cursor = context.getContentResolver().query(uri, new String[] {
                                        MediaStore.Images.Media.DISPLAY_NAME,
                                        MediaStore.Images.Media.DATA
                                }, null, null, null);
                                if (cursor != null && cursor.moveToFirst()) {
                                    final String fileName = cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.DISPLAY_NAME));
                                    final String path = cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.DATA));
                                    if(path.matches(screenShotPath+"(.*)")){
                                        Log.d(TAG, "just screenshot" + fileName + " " + path);
                                        notifyScreenshot = new NotificationScreenShot(context);
                                        notifyScreenshot.showNotification();
                                        screenShotChannel.invokeMethod("onScreenShot", path);
                                    }
                                }
                            } finally {
                                if (cursor != null)  {
                                    cursor.close();
                                }
                            }
                        }
                        super.onChange(selfChange, uri);
                    }
                }
        );
    }
}