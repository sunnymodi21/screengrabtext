package com.inlogica.screengrabtext;

import android.content.Context;
import android.content.Intent;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.os.Build;
import android.app.PendingIntent;
import android.support.v4.app.NotificationCompat;

public class NotificationScreenShot {

    NotificationManager notificationManager;
    private NotificationCompat.Builder mBuilder;

    NotificationScreenShot(Context context){
        notificationManager = (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);

        Intent intent = new Intent(context, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, 0);

        mBuilder = new NotificationCompat.Builder(context, "com.inlogica.screengrabtext/notify")
        .setSmallIcon(R.mipmap.ic_launcher)
        .setContentTitle("ScreenShot Done")
        .setContentText("Click to copy")
        .setContentIntent(pendingIntent)
        .setAutoCancel(true);
        //.addAction(R.drawable.ic_snooze, "Start Timer", startPendingIntent);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel("com.inlogica.screengrabtext/notify", "screenshot", importance);
            channel.setDescription("screenshot countdown");
            NotificationManager notificationManager = context.getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

    public void showNotification() {
        assert notificationManager != null;
        notificationManager.notify(101, mBuilder.build());
    }

    public void cancelNotification(){
        notificationManager.cancel(101); 
    }

}
