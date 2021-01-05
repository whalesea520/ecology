package com.shxiv.hfwh.rest.api;

import com.alibaba.fastjson.JSONObject;
import com.shxiv.demo.MD5.MD5_Encoding;
import org.apache.log4j.Logger;
import weaver.conn.RecordSet;
import weaver.general.BaseBean;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import java.util.ArrayList;
import java.util.List;

/**
 * 描述:TODO 实现NC系统在NC审批之后控制OA中流程流转
 *
 * @author zsd
 * @create 2018-11-28 10:32
 */
@Path("/AU_SUPPLIER")
public class RestZzc extends BaseBean  {

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
            builder.append(" select u.gcbh,u.gcmc,u.bsqs,u.lxr,u.dh,s.sssf,c.cs,b.bsqgsbm,u.XGRQ,u.XGSJ,u.dz from uf_YCSQCX u  ");
            builder.append(" left join uf_cs c on u.cs=c.id ");
            builder.append(" left join uf_sf s on u.sf=s.id ");
            builder.append(" left join uf_bsqssj b on u.bsqs=b.id ");
            builder.append(" where 1=1");
            builder.append(" and u.XGRQ=CONVERT(varchar(10),GETDATE(),120) ");

            String sqlS=builder.toString();
            rss.execute(sqlS);
            while (rss.next()){

                //嵌套json
                JSONObject jsonObject1 = new JSONObject();
                jsonObject1.put("CODE",rss.getString("gcbh"));
                jsonObject1.put("NAME",rss.getString("gcmc"));
                jsonObject1.put("DESCRIPTION",rss.getString("gcmc"));
                jsonObject1.put("CUSTOMER",rss.getString("bsqgsbm"));
                jsonObject1.put("CONTACTER",rss.getString("lxr"));
                jsonObject1.put("PHONE",rss.getString("dh"));
                jsonObject1.put("ADDRESS",rss.getString("dz"));
                String upDate=rss.getString("XGRQ");
                String upTime=rss.getString("XGSJ");
                if(upDate!=null&&!"".equals(upDate)){
                    upTime=upDate+" "+upTime+":00";
                    upDate=upDate.replaceAll("-","");
                }
                jsonObject1.put("PROVINCE",rss.getString("sssf"));
                jsonObject1.put("CITY",rss.getString("cs"));
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
        log.error("响应JSON数据："+returnJson);
        return returnJson;
    }
}
