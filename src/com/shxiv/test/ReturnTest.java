package com.shxiv.test;

import com.alibaba.fastjson.JSONObject;
import com.shxiv.demo.MD5.MD5_Encoding;
import com.shxiv.hfwh.rest.dto.HfResponseDto;
import com.shxiv.hfwh.rest.http.HfHttpClient;
import com.shxiv.hfwh.rest.http.HfRequest;
import weaver.general.BaseBean;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ReturnTest extends BaseBean {

    private HfRequest hfRequest;

    public static void addMessage() {
//		RecordSet rss = new RecordSet();
//		BaseBean baseBean = new BaseBean();
        try {
            HfHttpClient hfHttpClient = new HfHttpClient();
            HfRequest hfRequest = new HfRequest();
//			String urlFlb = baseBean.getPropValue("ShxivHfwh_http", "urlFw1");
            String urlFlb = "http://103.24.118.15:5619/api/fake_out?";
            System.out.println("urlFlb:" + urlFlb);
            MD5_Encoding encoding = new MD5_Encoding();
            String enc = encoding.getMD5ofStr("OA").toLowerCase();
            String key = "oa@mail.com";
            SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
            String timestamp = format.format(new Date());
//          String timestamp = "202001022300";
            String str = key + timestamp + enc;
            String passEnc = encoding.getMD5ofStr(str).toLowerCase();
            urlFlb += "key=oa@mail.com&timestamp=" + timestamp + "&sign=" + passEnc;
            System.out.println("urlFlb全部值:" + urlFlb);
            hfRequest.setUrl(urlFlb);
            hfRequest.setBody("");
            String cs5 = null;
            try {
                cs5 = hfHttpClient.doPostRequest(hfRequest);
            } catch (Exception e) {
                e.printStackTrace();
            }
            // http://103.24.118.15:5619/api/fake_out?key=oa@mail.com&timestamp=20200102105011&sign=a261c0fd436e457be8b80f577d0818f4
            JSONObject jsonResponse = JSONObject.parseObject(cs5);

            System.out.println("jsonResponse:" + jsonResponse);

            HfResponseDto fw1Dto = JSONObject.toJavaObject(jsonResponse, HfResponseDto.class);

            if ("ok".equals(fw1Dto.getStatus())) {
                if (fw1Dto.getData() != null) {
                    if (fw1Dto.getData().size() > 0) {

                        for (HfResponseDto sDto : fw1Dto.getData()) {
                            String rq = "";//年-月-日
                            //"OPERATION_DATE":"20200102"
                            if (!"".equals(sDto.getOPERATION_DATE())) {
                                String srq = sDto.getOPERATION_DATE();
                                String year = srq.substring(0, 4);
                                String month = srq.substring(4, 6);
                                String day = srq.substring(6, 8);
                                rq = year + "-" + month + "-" + day;
                            }

                            System.out.println("年-月-日:" + rq);
                            String sj = "";//时-分
                            //"STATUSTIME":"2020-01-02 10:50:10"
                            if (!"".equals(sDto.getSTATUSTIME())) {
                                String ssj = sDto.getSTATUSTIME();
                                sj = ssj.substring(11, 16);
                            }
                            System.out.println("时-分:" + sj);
                            int zsl = 0;//总出库数量
                            if (!"".equals(sDto.getTOT_QTYOUT()) && sDto.getTOT_QTYOUT() != null) {
                                zsl = Integer.parseInt(sDto.getTOT_QTYOUT());
                            }
                            System.out.println("总出库数量:" + zsl);
                            double zje = 0.00;//总出库金额
                            if (!"".equals(sDto.getTOT_AMTOUT()) && sDto.getTOT_AMTOUT() != null) {
                                Double d = Double.valueOf(sDto.getTOT_AMTOUT());
                                DecimalFormat df = new DecimalFormat("0.00");
                                String s = df.format(d);
                                zje = Double.valueOf(s);
                            }
                            System.out.println("总出库金额:" + zje);

                            String sqlZ = "update hfwhcstest set bjrq='" + rq + "',bjsj='" + sj + "',ckzje='" + zje
                                    + "',ckzjl='" + zsl + "',ckdh='" + sDto.getDOCNO() + "',kddh='" + sDto.getEXPRESSNO()
                                    + "',flbm='" + sDto.getMATERIAL() + "',kh='" + sDto.getPRODUCT() + "',cksl='" + sDto.getQTYOUT()
                                    + "',ckje='" + sDto.getAMTOUT() + "',czsj='" + sDto.getOPERATION_DATE();
//							rss.execute(sqlZ);
                        }

                    }
                } else {
                    System.out.println("获取ERP-防伪申请成功！但没有数据! ");
                }

            } else {
                System.out.println("获取ERP-防伪申请数据job失败了！ ");
            }
        } catch (Exception e) {
            System.out.println(("e错误： " + JSONObject.toJSONString(e)));
        }
    }

    public static void main(String[] args) throws Exception {
        addMessage();
    }
}
