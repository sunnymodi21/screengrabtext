package com.inlogica.screengrabtext;

import android.content.Context;
import android.content.Intent;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.os.Build;
import android.app.PendingIntent;

public class NotificationScreenShot {

    NotificationManager notificationManager;
    private Notification.Builder mBuilder;

    NotificationScreenShot(Context context){
        notificationManager = (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);

        //Intent startIntent = new Intent(context, ActionReceiver.class);
        //PendingIntent startPendingIntent =
        //PendingIntent.getBroadcast(context, 0, startIntent, 0);
        Intent intent = new Intent(context, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, 0);

        mBuilder = new Notification.Builder(context, "com.inlogica.screengrabtext/notify")
        .setSmallIcon(R.mipmap.ic_launcher)
        .setContentTitle("ScreenShot Done")
        .setContentText("Click to copy")
        .setPriority(Notification.PRIORITY_HIGH)
        .setContentIntent(pendingIntent)
        .setOnlyAlertOnce(true);
        //.addAction(R.drawable.ic_snooze, "Start Timer", startPendingIntent);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel("com.inlogica.screengrabtext/notify", "screenshot", importance);
            channel.setDescription("screenshot countdown");
            NotificationManager notificationManager = context.getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

    public void showNotifiction() {
        assert notificationManager != null;
        notificationManager.notify(101, mBuilder.build());
    }

    public void cancelNotification(){
        notificationManager.cancel(101); 
    }

}
