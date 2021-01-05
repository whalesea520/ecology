package com.shxiv.hfwh.rest.api;

import com.alibaba.fastjson.JSONObject;
import com.shxiv.demo.MD5.MD5_Encoding;
import com.weaver.general.Util;
import org.apache.log4j.Logger;
import weaver.conn.RecordSet;
import weaver.general.BaseBean;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.util.ArrayList;
import java.util.List;

/**
 * 描述:TODO 实现NC系统在NC审批之后控制OA中流程流转
 *
 * @author huihuzsiXiong
 * @create 2018-11-28 10:32
 */

@Path("/AU_CUSTOMER")
public class RestBsq extends BaseBean  {

    private Logger log = Logger.getLogger(this.getClass());
    /**
     *
     *
     * @return 返回响应JSON字符串
     */
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String merchantsApproval(@QueryParam("key") String key,@QueryParam("timestamp") String timestamp,@QueryParam("sign") String sign) {

        String returnJson = "";
        RecordSet rss=new RecordSet();
        RecordSet rs1=new RecordSet();

        MD5_Encoding encoding=new MD5_Encoding();
        String enc=encoding.getMD5ofStr("test").toLowerCase();

        String str= key + timestamp +enc;
        String passEnc= encoding.getMD5ofStr(str).toLowerCase();
        //被授权商信息
        JSONObject json = new JSONObject();

        //用户验证
        if(passEnc.equals(sign)){
            List<JSONObject> jsonObjects = new ArrayList<JSONObject>();
            json.put("status", "ok");//状态
            StringBuilder builder=new StringBuilder();
            builder.append("select u.id,u.bsqgsbm,u.bsqgs,u.frdb,u.ywdb,u.dz,u.nssrsbh,u.khhjzh,u.bz,c.cs,x.xlr,x.dh,u.zcrq,u.XGRQ,u.XGSJ, ");
            builder.append(" case u.khjb when '0' then '一级' when '1' then '二级' when '2' then '三级' else '' end as khjb,  ");
            builder.append(" case u.qd when '0' then '线上' when '1' then '线下' when '2' then '全渠道' else '' end as qd from uf_bsqssj u  ");
            builder.append(" left join uf_cs c on u.cs=c.id ");
            builder.append(" left join uf_lxrxx x on u.id=x.sqs ");
            builder.append(" where 1=1  ");
            builder.append(" and u.XGRQ=CONVERT(varchar(10),GETDATE(),120) ");

            String sqlS=builder.toString();
            rss.execute(sqlS);
            while (rss.next()){
                String kqdd=rss.getString("ywdb");
                String [] kqdds = kqdd.split(",");
                StringBuilder userNames= new StringBuilder();
                String nameStr="";
                for(int i=0;i<kqdds.length;i++){
                    int userId = Util.getIntValue(kqdds[i]) ;
                    String userName="";
                    String sqlN="select lastname from hrmresource where id="+userId;
                    rs1.execute(sqlN);
                    if(rs1.next()){
                        userName=rs1.getString("lastname");
                    }
                    userNames.append(",").append(userName);
                }
                nameStr=userNames.toString();
                nameStr=nameStr.substring(1,nameStr.length());

                //嵌套json
                JSONObject jsonObject1 = new JSONObject();
                jsonObject1.put("CODE",rss.getString("bsqgsbm"));
                jsonObject1.put("NAME",rss.getString("bsqgs"));
                jsonObject1.put("DESCRIPTION",rss.getString("bsqgs"));
                jsonObject1.put("LEGAL",rss.getString("frdb"));
                jsonObject1.put("CUSRANK",rss.getString("khjb"));
                jsonObject1.put("AREAMNG",nameStr);
                jsonObject1.put("CITY",rss.getString("cs"));
                jsonObject1.put("AU_TYPE",rss.getString("qd"));

                //获取明细表数据
                String xlr=rss.getString("xlr");
                String dh=rss.getString("dh");
                jsonObject1.put("CONTACTER",xlr);
                jsonObject1.put("MOBILE",dh);
                jsonObject1.put("PHONE",dh);
                jsonObject1.put("ADDRESS",rss.getString("dz"));
                String upDate=rss.getString("XGRQ");
                String upTime=rss.getString("XGSJ");
                if(upDate!=null&&!"".equals(upDate)){
                    upTime=upDate+" "+upTime+":00";
                    upDate=upDate.replaceAll("-","");
                }

                String enterDate=rss.getString("zcrq");
                if(enterDate!=null&&!"".equals(enterDate)){
                    enterDate=enterDate.replaceAll("-","");
                }
                jsonObject1.put("ENTERDATE",enterDate);
                jsonObject1.put("TAXNO",rss.getString("nssrsbh"));
                jsonObject1.put("ACCOUNT",rss.getString("khhjzh"));
                jsonObject1.put("REMARK",rss.getString("bz"));
                jsonObject1.put("MODIFIEDDATE",upTime);
                jsonObject1.put("OPERATION_DATE",upDate);
                jsonObjects.add(jsonObject1);
            }
            json.put("data",jsonObjects);

        }else {
            json.put("status", "fail");//状态
            json.put("msg", "用户验证失败！");//状态

        }

        returnJson = json.toString();
        /*log.error("响应JSON数据："+returnJson);*/
        return returnJson;
    }
}
