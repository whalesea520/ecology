package com.shxiv.hfwh.workflow.action;

import com.weaver.general.BaseBean;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;
import weaver.workflow.workflow.WorkflowComInfo;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Administrator on 2020/8/21.
 */
public class WqdlAction extends BaseBean implements Action {
    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(WqdlAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        this.log.error("######################   开始调用维权代理控制Action     ###########################");
        RecordSet rss = new RecordSet();
        RecordSet rss1 = new RecordSet();
        RecordSet rss2 = new RecordSet();
        String tempMessage = "";
        try {
            WorkflowComInfo workflowComInfo = new WorkflowComInfo();
            int requestid = Util.getIntValue(request.getRequestid());//创建一个流程就生成唯一标识的请求ID
            int workflowid = Util.getIntValue(request.getWorkflowid());//流程ID
            int formid = Util.getIntValue(workflowComInfo.getFormId("" + workflowid));//表单ID

            //主表表名
            String mainTable = "formtable_main_" + ((-1) * formid);//获取到当前流程表单的主表表名

            //明细表名
            String mxTable = mainTable + "_dt1";//获取到当前流程表单的明细表名:主表_dtx

            String mainId="";//主表ID

            //主表数据
            String sqlMa="select id from "+mainTable+" where requestId='"+requestid+"'  ";
            rss.execute(sqlMa);
            if(rss.next()){
                mainId=rss.getString("id");
            }

            String mxId="";//明细表ID
            String canu="";//案号
            String bsqgs="";//被授权公司
            String jxs="";//侵权主体名称
            String pt="";//	平台
            String dplx="";//店铺类型
            String dpmc="";//店铺名称
            String pl="";//品类
            int ct=0;
            int bt=0;
            List<String> mxIdList = new ArrayList<String>();
            List<String> btList = new ArrayList<String>();

            String sqlMb="select id,canu,bsqgs,jxs,pt,dplx,dpmc,pl from "+mxTable+" where mainid='"+mainId+"'  ";
            log.error("sqlMb:"+sqlMb);
            rss1.execute(sqlMb);
            while(rss1.next()){
                mxId=rss1.getString("id");
                canu=rss1.getString("canu");
                bsqgs=rss1.getString("bsqgs");
                jxs=rss1.getString("jxs");
                pt=rss1.getString("pt");
                dplx=rss1.getString("dplx");
                dpmc=rss1.getString("dpmc");
                pl=rss1.getString("pl");

                String sqlMc="select count(*) as ct from uf_wqlc_dt1 where "
                        + "bsqgs='"+bsqgs+"' and jxs='"+jxs+"' and pt='"+pt
                        +"' and dplx='"+dplx+"' and dpmc='"+dpmc
                        +"' and pl='"+pl+"'";
                log.error("sqlMc:"+sqlMc);
                rss2.execute(sqlMc);
                if(rss2.next()){
                    ct=rss2.getInt("ct");
                }
                if(ct>0){
                    mxIdList.add(canu);
                }

                String sqlMd="select count(*) as bt from (select a.dpm,a.jxs,b.bsqgs,m.qdmc,n.dplx from uf_bmd a join uf_bsqssj b " +
                        "on a.bsqs=b.id join uf_qdmc m on a.qdmc=m.id join uf_dplx n on a.dplx=n.id) c where "
                        + "c.bsqgs='"+bsqgs+"' and c.jxs='"+jxs+"' and c.qdmc='"+pt
                        +"' and c.dplx='"+dplx+"' and c.dpm='"+dpmc
                        +"'";
                log.error("sqlMd:"+sqlMd);
                rss2.execute(sqlMd);
                if(rss2.next()){
                    bt=rss2.getInt("bt");
                }
                if(bt>0){
                    btList.add(canu);
                }

            }
            if(mxIdList.size()>0){
                tempMessage = mxIdList.toString()+"案号已经申请,请删除后重新提交！";
                request.getRequestManager().setMessageid("流程提交失败");
                request.getRequestManager().setMessagecontent(tempMessage);
                return "0";
            }

            if(btList.size()>0){
                tempMessage = btList.toString()+"案号在授权范围内,请删除后重新提交！";
                request.getRequestManager().setMessageid("流程提交失败");
                request.getRequestManager().setMessagecontent(tempMessage);
                return "0";
            }

            }catch (Exception e) {
                tempMessage = ""+e;
                request.getRequestManager().setMessageid("流程提交失败");
                request.getRequestManager().setMessagecontent(tempMessage);
                return "0";
            }

        this.log.error("######################   调用维权代理控制Action end   ########################################");
        return "1";
        }


}
