package com.inlogica.screengrabtext;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import androidx.core.content.ContextCompat;
import android.util.Log;
import android.database.ContentObserver;
import android.os.HandlerThread;
import android.net.Uri;
import android.database.Cursor;

import io.flutter.plugin.common.MethodChannel;

public class ScreenShotObserver {

    private String TAG = "ScreenShotObserver";
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
                        
                        Log.d(TAG, "URI " + uri.toString());
                        if (uri.toString().matches(MediaStore.Images.Media.EXTERNAL_CONTENT_URI.toString() + "/[0-9]+(.*)")) {
                            Log.d(TAG, "In URI " + MediaStore.Images.Media.EXTERNAL_CONTENT_URI.toString());
                            if (ContextCompat.checkSelfPermission(context, Manifest.permission.READ_EXTERNAL_STORAGE)
                                    == PackageManager.PERMISSION_GRANTED) {
                                Cursor cursor = null;
                                try {
                                    cursor = context.getContentResolver().query(uri, new String[]{
                                            MediaStore.Images.Media.DISPLAY_NAME,
                                            MediaStore.Images.Media.DATA
                                    }, null, null, null);
                                    if (cursor != null && cursor.moveToFirst()) {
                                        final String fileName = cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.DISPLAY_NAME));
                                        final String path = cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.DATA));
                                        Log.d(TAG, "path" + path);
                                        if (path.matches("(.*)Screenshots(.*)")) {
                                            Log.d(TAG, "just screenshot" + fileName + " " + path);
                                            screenShotChannel.invokeMethod("onScreenShot", path);
                                        }
                                    }
                                } finally {
                                    if (cursor != null) {
                                        cursor.close();
                                    }
                                }
                            }
                        }
                        super.onChange(selfChange, uri);
                    }
                }
        );
    }
}