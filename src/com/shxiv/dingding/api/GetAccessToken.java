package com.shxiv.dingding.api;

import com.dingtalk.api.DefaultDingTalkClient;
import com.dingtalk.api.request.OapiGettokenRequest;
import com.dingtalk.api.response.OapiGettokenResponse;
import com.taobao.api.ApiException;

/**
 * Created by Administrator on 2020/1/7.
 */
public class GetAccessToken {
    private String appkey="dingdpllsyckrgzma5ol";//应用的唯一标识key
    private String appsecret="e_eMXRjBfNDDTu8GaiF_iNcsU_gcaxz_bderrrzcEwUk2zyIln29tywg9D-zhIuI";//应用的密钥

    private String accessToken;
    private String errmsg;

    /**
     * 获取钉钉接口凭证
     * @return 接口凭证
     */
    public String accessToken() {
        DefaultDingTalkClient client = new DefaultDingTalkClient("https://oapi.dingtalk.com/gettoken");
        OapiGettokenRequest request = new OapiGettokenRequest();
        request.setAppkey(appkey);
        request.setAppsecret(appsecret);
        request.setHttpMethod("GET");
        try {
            OapiGettokenResponse response = client.execute(request);
            errmsg=response.getErrmsg();
//          System.out.println(errmsg);
            if ("ok".equals(errmsg)) {
                accessToken = response.getAccessToken();
            }else{
                accessToken= "获取凭证失败："+errmsg;
            }
        } catch (ApiException e) {
            e.printStackTrace();
        }
        return accessToken;
    }
}
