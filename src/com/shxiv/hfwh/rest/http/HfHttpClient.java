package com.shxiv.hfwh.rest.http;

import com.sapi.httpclient.Clients;
import com.sapi.httpclient.Request;
import com.sapi.httpclient.Response;
import com.sapi.httpclient.constant.Constants;
import com.sapi.httpclient.enums.Method;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.general.Util;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by zsd on 2019/1/10.
 */

public class HfHttpClient {
    public String doPostRequest(HfRequest request) throws Exception {
        Log logs= LogFactory.getLog("HfHttpClient: ");
        Request req = new Request(Method.GET, request.getUrl(),"", Constants.DEFAULT_TIMEOUT * 100);
        Map<String, String> headers = new HashMap<String, String>();
        headers.put("Content-Type", "application/json");
        headers.put("Connection","close");
        req.setHeaders(headers);
        req.setStringBody(request.getBody());
        Response resp = null;
        resp = Clients.execute(req);
        int statusCode = resp.getStatusCode();
        String json = null ;
        if (statusCode == 200) {
            json = Util.null2String(resp.getBody());
        }
        return json;
    }
}
