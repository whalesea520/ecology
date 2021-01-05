package com.shxiv.hfwh.rest.dto;

/**
 * Created by zsd on 2018/12/23.
 */
public class HfRequestDto {

    private String key;

    private String timestamp;

    private String sign;

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }
}
