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
import java.util.ArrayList;
import java.util.List;

/**
 * 描述:TODO 实现NC系统在NC审批之后控制OA中流程流转
 *
 * @author zsd
 * @create 2018-11-28 10:32
 */
@Path("/M_AU_FAKEPUR")
public class RestFwb extends BaseBean  {

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
        String fNodeId=baseBean.getPropValue("ShxivHfwh_param","nodeFwb");
        String wfId=baseBean.getPropValue("ShxivHfwh_param","wfFwb");

        //用户验证
        if(passEnc.equals(sign)){
            List<JSONObject> jsonObjects = new ArrayList<JSONObject>();
            json.put("status", "ok");//状态

            StringBuilder builder=new StringBuilder();
            builder.append(" select m.requestId,m.bh,m.sqrq,y.gcbh as gys,m.cgzsl,m.cgzje,'LD0001' as fhc, ");
            builder.append("  m.rq,m.sj,dt.fwbbm,dt.cgsl,dt.cgje from formtable_main_213 m ");
            builder.append(" left join workflow_requestbase w on m.requestId=w.requestid  ");
            builder.append(" left join formtable_main_213_dt1 dt on m.id=dt.mainid ");
            builder.append(" left join uf_YCSQCX y on m.gys=y.id ");
            builder.append(" where 1=1 and w.workflowid='"+wfId+"' and w.currentnodeid='"+fNodeId+"' ");

            String sqlS=builder.toString();
            log.error("SQL是："+sqlS);
            rss.execute(sqlS);
            while (rss.next()){

                //嵌套json
                JSONObject jsonObject1 = new JSONObject();
                jsonObject1.put("OA_DOCNO",rss.getString("bh"));
                jsonObject1.put("DOCNO","");
                String sqR=rss.getString("sqrq");
                if(sqR!=null&&!"".equals(sqR)){
                    sqR=sqR.replaceAll("-","");
                }
                jsonObject1.put("BILLDATE",sqR);
                jsonObject1.put("SUPPLIER",rss.getString("gys"));
                jsonObject1.put("TOT_QTY",rss.getString("cgzsl"));
                jsonObject1.put("TOT_AMT",rss.getString("cgzje"));
                jsonObject1.put("STORE",rss.getString("fhc"));
                String upDate=rss.getString("xgrq");
                if(upDate!=null&&!"".equals(upDate)){
                    upDate=upDate.replaceAll("-","");
                }
                jsonObject1.put("STATUSTIME",rss.getString("xgsj"));
                jsonObject1.put("OPERATION_DATE",upDate);


                //明细表数据封装
                String mbm="";
                String fld=rss.getString("fwbbm");
                String sqlF="select wlbm from uf_fljcb where id='"+fld+"'";
                rs2.execute(sqlF);
                if(rs2.next()){
                    mbm=rs2.getString("wlbm");
                }

                jsonObject1.put("MATERIAL",mbm);
                jsonObject1.put("QTY",rss.getString("cgsl"));
                jsonObject1.put("AMT",rss.getString("cgje"));

                /*JSONArray jsonA = new JSONArray();
                String mainId=rss.getString("id");
                String sqlMx="select fwbbm,fwbtm,lysl,fwbzcbje from formtable_main_197_dt1 where mainid='"+mainId+"'";
                rs1.execute(sqlMx);
                while (rs1.next()){

                    JSONObject jsonObject2 = new JSONObject();
                    jsonObject2.put("MATERIAL",rs1.getString("fwbbm"));
                    jsonObject2.put("QTY",rs1.getString("lysl"));
                    jsonObject2.put("AMT",rs1.getString("fwbzcbje"));
                    jsonA.add(jsonObject2);
                }

                jsonObject1.put("mxm",jsonA);*/

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
