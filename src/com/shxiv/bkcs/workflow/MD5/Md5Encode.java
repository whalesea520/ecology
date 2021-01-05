package com.shxiv.bkcs.workflow.MD5;


import com.alibaba.fastjson.JSONObject;
import com.shxiv.demo.MD5.MD5_Encoding;
import com.shxiv.hfwh.rest.http.HfHttpClient;
import com.shxiv.hfwh.rest.http.HfRequest;
import weaver.general.BaseBean;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by zsd on 2018/6/13.
 */
public class Md5Encode {

    public static String getMD5(String str) {
        try {
            // 生成一个MD5加密计算摘要
            MessageDigest md = MessageDigest.getInstance("MD5");
            // 计算md5函数
            md.update(str.getBytes());
            // digest()最后确定返回md5 hash值，返回值为8为字符串。因为md5 hash值是16位的hex值，实际上就是8位的字符
            // BigInteger函数则将8位的字符串转换成16位hex值，用字符串来表示；得到字符串形式的hash值
            String md5=new BigInteger(1, md.digest()).toString(16);
            //BigInteger会把0省略掉，需补全至32位
            return fillMD5(md5);
        } catch (Exception e) {
            throw new RuntimeException("MD5加密错误:"+e.getMessage(),e);
        }
    }

    public static String fillMD5(String md5){
        return md5.length()==32?md5:fillMD5("0"+md5);
    }

    public static void main(String[] args) throws Exception{
  
        BaseBean baseBean=new BaseBean();

        HfHttpClient hfHttpClient=new HfHttpClient();
        HfRequest hfRequest=new HfRequest();
        String urlFlb=baseBean.getPropValue("ShxivHfwh_http","urlFw1");
        System.out.println("urlFlb:"+urlFlb);
        MD5_Encoding encoding=new MD5_Encoding();
        String enc=encoding.getMD5ofStr("OA").toLowerCase();
        String key="oa@mail.com";
        SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss") ;
        String timestamp=format.format(new Date());
        String str= key + timestamp +enc;
        String passEnc= encoding.getMD5ofStr(str).toLowerCase();
        urlFlb+="key=oa@mail.com&timestamp="+timestamp+"&sign="+passEnc;
        System.out.println("urlFlb全部值:"+urlFlb);
        hfRequest.setUrl(urlFlb);
        hfRequest.setBody("");
        String cs5= null;
        try {
            cs5 = hfHttpClient.doPostRequest(hfRequest);
        } catch (Exception e) {
            e.printStackTrace();
        }

        JSONObject jsonResponse = JSONObject.parseObject(cs5);
        System.out.println("jsonResponse:"+jsonResponse);

//        String urlTest="{ \"ret\":\"S\", \"msg\":[{\"autoAccountIds\":\"274\",\"channelAccountAmount\":45,\"channelSubtract\":10,\"channelWater\":300,\"logDate\":\"2018-06\",\"platformName\":\"超级斗地主\",\"moneyType\":\"人民币\",\"divideRate\":\"15.0%\"}] }";
//        boolean status = urlTest.contains("[");
//        if(status){
//            System.out.println("1");
//        }else{
//            System.out.println("2");
//        }
    }
}
