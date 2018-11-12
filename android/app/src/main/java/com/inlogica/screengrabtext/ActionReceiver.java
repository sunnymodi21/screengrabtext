package com.inlogica.screengrabtext;

import android.content.Context;
import android.content.Intent;

import android.content.BroadcastReceiver;
import android.widget.Toast;

public class ActionReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        Toast.makeText(context,"recieved",Toast.LENGTH_SHORT).show();
    }

}
