package com.shxiv.hfwh.rest.api;

import com.alibaba.fastjson.JSONObject;
import com.shxiv.demo.MD5.MD5_Encoding;
import net.sf.json.JSONArray;
import org.apache.log4j.Logger;
import weaver.conn.RecordSet;
import weaver.general.BaseBean;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 描述:TODO 辅料申请
 *
 * @author zsd
 * @create 2018-11-28 10:32
 */
@Path("/M_ACC_DISTRIBUTE")
public class RestFls extends BaseBean  {

    private Logger log = Logger.getLogger(this.getClass());
    /**
     *
     *
     * @return 返回响应JSON字符串
     */
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String merchantsApproval(@QueryParam("key") String key, @QueryParam("timestamp") String timestamp, @QueryParam("sign") String sign) {


        String returnJson = "";
        RecordSet rss=new RecordSet();
        RecordSet rs2=new RecordSet();

        MD5_Encoding encoding=new MD5_Encoding();
        String enc=encoding.getMD5ofStr("test").toLowerCase();

        String str= key + timestamp +enc;
        String passEnc= encoding.getMD5ofStr(str).toLowerCase();
        //被授权商信息
        JSONObject json = new JSONObject();
        BaseBean baseBean=new BaseBean();
        String nodeFls=baseBean.getPropValue("ShxivHfwh_param","nodeFls");
        try {
            //用户验证
            if(passEnc.equals(sign)){
                List<JSONObject> jsonObjects = new ArrayList<JSONObject>();
                json.put("status", "ok");//状态

                StringBuilder builder=new StringBuilder();
                builder.append(" select m.requestId,m.bh,m.sqrq,b.bsqgsbm as bsqf,m.sqzsl zsl,m.cbhj,'LD0001' as fhc,  ");
                builder.append(" dt.fltm,dt.lysl,dt.flzcbje,dt.tm from formtable_main_198 m ");
                builder.append(" left join workflow_requestbase w on m.requestId=w.requestid  ");
                builder.append(" left join formtable_main_198_dt1 dt on m.id=dt.mainid ");
                builder.append(" left join uf_bsqssj b on m.bsqf=b.id ");
                builder.append(" where 1=1 and w.currentnodeid='"+nodeFls+"'");

                String sqlS=builder.toString();
                rss.execute(sqlS);
                while (rss.next()){

                    //嵌套json
                    JSONObject jsonObject1 = new JSONObject();
                    jsonObject1.put("OA_DOCNO",rss.getString("bh"));
                    jsonObject1.put("DOCNO","");
                    SimpleDateFormat format1=new SimpleDateFormat("yyyy-MM-dd");
                    SimpleDateFormat format2=new SimpleDateFormat("HH:mm");

                    String sqR=rss.getString("sqrq");
                    if(sqR!=null&&!"".equals(sqR)){
                        sqR=sqR.replaceAll("-","");
                    }
                    jsonObject1.put("BILLDATE",sqR);
                    jsonObject1.put("CUSTOMER",rss.getString("bsqf"));
                    jsonObject1.put("TOT_QTY",rss.getString("zsl"));
                    jsonObject1.put("TOT_AMT",rss.getString("cbhj"));
                    String upDate=format1.format(new Date());
                    if(upDate!=null&&!"".equals(upDate)){
                        upDate=upDate.replaceAll("-","");
                    }
                    jsonObject1.put("STATUSTIME",format2.format(new Date()));
                    jsonObject1.put("OPERATION_DATE",upDate);


                    //明细表数据封装
                    String mbm="";
                    String mtm="";
                    String fld=rss.getString("fltm");
                    log.error("fld: "+fld);
                    String sqlF="select wlbm from uf_fljcb where id='"+fld+"'";
                    rs2.execute(sqlF);
                    if(rs2.next()){
                        mbm=rs2.getString("wlbm");
                    }
                    jsonObject1.put("MATERIAL",mbm);
                    jsonObject1.put("PRODUCTALIAS",rss.getString("tm"));
                    jsonObject1.put("QTY",rss.getString("lysl"));
                    jsonObject1.put("AMT",rss.getString("flzcbje"));

                    jsonObjects.add(jsonObject1);
                }
                log.error("jsonObjects: "+jsonObjects);
                json.put("data",jsonObjects);

            }else {
                json.put("status", "fail");//状态
                json.put("msg", "用户验证失败！");//状态

            }
        }catch (Exception e){
            log.error("错误: "+e);
        }

        log.error("json: "+json);
        returnJson = json.toString();
        /*log.error("响应JSON数据："+returnJson);*/
        return returnJson;
    }
}
