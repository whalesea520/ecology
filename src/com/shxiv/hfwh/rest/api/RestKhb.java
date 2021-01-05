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
@Path("/AU_PRODUCT")
public class RestKhb extends BaseBean  {

    private Logger log = Logger.getLogger(this.getClass());
    /**
     *
     *
     * @return 返回响应JSON字符串
     */
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String merchantsApproval(@QueryParam("key") String key,@QueryParam("timestamp") String timestamp,@QueryParam("sign") String sign) {
        log.error("红纺款号封装接口开始+++++++++++++++++++++++++++++++++++++++++++++");
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
            builder.append(" select u.hfkh,u.bsqskh,u.spmc,u.ssrq,uy.gcbh as zzsxx,  ");
            builder.append(" case u.jj when 0 then '春' when 1 then '夏' when 2 then '秋' when 3 then '冬' when 4 then '全季' when 5 then '春夏' when 6 then '秋冬'  end as jj, ");
            builder.append(" case u.sxz when 0 then '上装' when 1 then '下装' when 2 then '套装' when 3 then '无定义' when 4 then '配件' when 5 then '鞋物料' else '无定义' end as sxz,  ");
            builder.append(" case u.xb when 0 then '无定义' when 1 then '童装男性' when 2 then '童装中性' when 3 then '童装女性' when 4 then '成人男性' when 5 then '成人中性' when 6 then '成人女性' else '无定义' end as xb,  ");
            builder.append(" d.dl,z.zfl,u.cd,c.ccz,u.pfj,u.bzj,u.sqs,u.bz,nf.nf,p.pp,b.bsqgsbm,u.XGRQ,u.XGSJ,x.xl from uf_spsslc u  ");
            builder.append(" left join uf_sspp p on u.sspp1=p.id ");
            builder.append(" left join uf_dl d on u.dl=d.id ");
            builder.append(" left join uf_zfl z on u.zfl=z.id ");
            builder.append(" left join uf_xl x on u.xl=x.id ");
            builder.append(" left join uf_ccz c on u.ccz=c.id ");
            builder.append(" left join uf_bsqssj b on u.sqs=b.id ");
            builder.append(" left join uf_YCSQCX uy on u.zzsxx1=uy.id ");
            builder.append(" left join uf_nf nf on u.nf2=nf.id ");
            builder.append(" where 1=1 ");
            builder.append(" and u.XGRQ=CONVERT(varchar(10),GETDATE(),120) ");

            String sqlS=builder.toString();
            log.error("红纺款号sql语句："+sqlS);
            rss.execute(sqlS);
            while (rss.next()){

                //嵌套json
                JSONObject jsonObject1 = new JSONObject();
                jsonObject1.put("NAME",rss.getString("hfkh"));
                jsonObject1.put("AU_NAME",rss.getString("bsqskh"));
                jsonObject1.put("VALUE",rss.getString("spmc"));

                String ssDate=rss.getString("ssrq");
                if(ssDate!=null&&!"".equals(ssDate)){
                    ssDate=ssDate.replaceAll("-","");
                }

                jsonObject1.put("MARKETDATE",ssDate);
                jsonObject1.put("SUPPLIER",rss.getString("zzsxx"));
                jsonObject1.put("DIM1",rss.getString("pp"));
                jsonObject1.put("DIM3",rss.getString("dl"));
                jsonObject1.put("DIM4",rss.getString("jj"));
                jsonObject1.put("DIM5",rss.getString("sxz"));
                jsonObject1.put("DIM11",rss.getString("zfl"));

                /*String xld=rss.getString("xl");
                String [] xlds = xld.split(",");
                StringBuilder xlNames= new StringBuilder();
                String nameStr="";
                for(int i=0;i<xlds.length;i++){
                    int xlId = Util.getIntValue(xlds[i]) ;
                    String xlName="";
                    String sqlN="select xl from uf_xl where id="+xlId;
                    rs1.execute(sqlN);
                    if(rs1.next()){
                        xlName=rs1.getString("xl");
                    }
                    xlNames.append(",").append(xlName);
                }
                nameStr=xlNames.toString();
                nameStr=nameStr.substring(1,nameStr.length());*/

                jsonObject1.put("DIM7",rss.getString("xl"));
                jsonObject1.put("DIM12",rss.getString("xb"));
                jsonObject1.put("PROAREA",rss.getString("cd"));
                jsonObject1.put("SIZEGROUP",rss.getString("ccz"));
                jsonObject1.put("PRECOST",rss.getString("pfj"));
                jsonObject1.put("PRICELIST",rss.getString("bzj"));
                jsonObject1.put("CUSTOMER",rss.getString("bsqgsbm"));
                jsonObject1.put("DOCUMENTNOTE",rss.getString("bz"));
                jsonObject1.put("DIM2",rss.getString("nf"));

                String upDate=rss.getString("XGRQ");
                String upTime=rss.getString("XGSJ");
                if(upDate!=null&&!"".equals(upDate)){
                    upTime=upDate+" "+upTime+":00";
                    upDate=upDate.replaceAll("-","");
                }
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
        log.error("红纺款号响应JSON数据："+returnJson);
        log.error("红纺款号封装接口结束+++++++++++++++++++++++++++++++++++++++++++++");
        return returnJson;
    }
}
