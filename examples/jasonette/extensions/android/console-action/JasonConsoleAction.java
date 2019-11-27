package com.jasonette.seed.Action;

import android.content.Context;
import android.util.Log;

import com.jasonette.seed.Core.JasonViewActivity;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.Iterator;

public class JasonConsoleAction {
    public void debug(final JSONObject action, JSONObject data, Context context) {
        try {
            if(action.has("options")){
                final JSONObject options = action.getJSONObject("options");
                JSONArray kvarrary = new JSONArray();

                if (options.has("eval")) {
                    JSONObject kv = new JSONObject();
                    kv.put("name", "evaluated");
                    kv.put("value", options.get("eval"));
                    kvarrary.put(kv);
                }

                JSONObject href = new JSONObject();
                JSONObject params = new JSONObject();
                JSONObject new_options = new JSONObject();

                Iterator<String> keysIterator = data.keys();
                try {
                    while (keysIterator.hasNext()) {
                        String key = (String) keysIterator.next();
                        Object val = data.get(key);
                        JSONObject kv = new JSONObject();
                        kv.put("name", key);
                        kv.put("value", val);
                        kvarrary.put(kv);
                    }
                } catch (Exception e) {

                }
                params.put("variables", kvarrary);
                new_options.put("url", "file://jasonconsoleaction.json");
                new_options.put("options", params);
                href.put("type", "$href");
                href.put("options", new_options);
                ((JasonViewActivity)context).call(href.toString(), "{}", context);
            }
        } catch (Exception e) {
            Log.d("Error", e.toString());
        }
    }
}
