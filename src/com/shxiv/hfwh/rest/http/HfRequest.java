package com.shxiv.hfwh.rest.http;

/**
 * Created by zsd on 2019/1/10.
 */
public class HfRequest {

    private String url;
    private String body;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("HfRequest{");
        sb.append("url='").append(url).append('\'');
        sb.append(", body='").append(body).append('\'');
        sb.append('}');
        return sb.toString();
    }
}
