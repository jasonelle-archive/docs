package com.jasonette.seed.Action;

import android.content.Context;
import android.util.Log;

import com.jasonette.seed.Helper.JasonHelper;
import com.jasonette.seed.R;
import com.segment.analytics.Analytics;
import com.segment.analytics.Properties;
import com.segment.analytics.Traits;

import org.json.JSONObject;

import java.util.Iterator;

public class JasonSEGAnalyticsAction {
    public static void initialize(Context context){
        String key = context.getResources().getString(R.string.segment);
        Analytics analytics = new Analytics.Builder(context, key)
                .trackApplicationLifecycleEvents() // Enable this to record certain application events automatically!
                .recordScreenViews() // Enable this to record screen views automatically!
                .build();

        Analytics.setSingletonInstance(analytics);


    }
    public void identify(final JSONObject action, final JSONObject data, final Context context){
        try {
            if (action.has("options")) {
                JSONObject options = action.getJSONObject("options");
                String id = null;
                if(options.has("id")){
                    id = options.getString("id");
                }

                JSONObject traits = null;
                if(options.has("traits")){
                    traits = options.getJSONObject("traits");
                }

                Traits traitsObject = new Traits();
                Iterator<?> keys = traits.keys();
                while (keys.hasNext()) {
                    String key = (String) keys.next();
                    String val = traits.get(key).toString();
                    traitsObject.put(key, val);
                }
                Analytics.with(context).identify(id, traitsObject, null);

            }
            JasonHelper.next("success", action, data, context);
        } catch (Exception e){
            Log.d("Error", e.toString());
        }
    }
    public void track(final JSONObject action, final JSONObject data, final Context context){
        try {
            if (action.has("options")) {
                JSONObject options = action.getJSONObject("options");
                String event = null;
                if(options.has("event")){
                    event = options.getString("event");
                }

                JSONObject properties = null;
                if(options.has("properties")){
                    properties = options.getJSONObject("properties");
                }

                Properties propertiesObject = new Properties();
                Iterator<?> keys = properties.keys();
                while (keys.hasNext()) {
                    String key = (String) keys.next();
                    String val = properties.get(key).toString();
                    propertiesObject.put(key, val);
                }

                Analytics.with(context).track(event, propertiesObject);

            }
            JasonHelper.next("success", action, data, context);
        } catch (Exception e){
            Log.d("Error", e.toString());
        }


    }
}
