package com.shxiv.hfwh.workflow.action;

import com.weaver.general.BaseBean;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;
import weaver.workflow.workflow.WorkflowComInfo;

/**
 * Created by zsd on 2019/3/4.
 */
public class SsKhAction extends BaseBean implements Action {

    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(SsKhAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################   开始调用送审款号排重控制Action     ###########################");
        RecordSet rss = new RecordSet();
        RecordSet rs1 = new RecordSet();
        String tempMessage = "";
        try {
            WorkflowComInfo workflowComInfo = new WorkflowComInfo();
            int requestid = Util.getIntValue(request.getRequestid());//创建一个流程就生成唯一标识的请求ID
            int workflowid = Util.getIntValue(request.getWorkflowid());//流程ID
            int formid = Util.getIntValue(workflowComInfo.getFormId("" + workflowid));//表单ID 

            //主表表名
            String mainTable = "formtable_main_" + ((-1) * formid);//获取到当前流程表单的主表表名

            //明细表名
            String mxTable = mainTable+"_dt1";//获取到当前流程表单的明细表名

            String mainId="";
            String hfkh="";

            String sqlMa="select id,hfkh from "+mainTable+" where requestId='"+requestid+"'  ";
            this.log.error("sqlMa: "+sqlMa);
            rss.execute(sqlMa);
            if(rss.next()){
                mainId=rss.getString("id");
                hfkh = rss.getString("hfkh");
            }

            int sl=0;
            this.log.error("sl: "+sl);
            String sqlMb="select COUNT(*) as sl from uf_spsslc where hfkh='"+hfkh+"'";
            rs1.execute(sqlMb);
            this.log.error("sqlMb: "+sqlMb);
            if(rs1.next()){
                sl=rs1.getInt("sl");
            }

            if(sl>0){
                tempMessage = "该红纺款号已在商品送审台账表中存在,请重新确认红纺款号！";
                request.getRequestManager().setMessageid("流程提交失败");
                request.getRequestManager().setMessagecontent(tempMessage);
                return "0";
            }


        } catch (Exception e) {
            tempMessage = ""+e;
            request.getRequestManager().setMessageid("流程提交失败");
            request.getRequestManager().setMessagecontent(tempMessage);
            return "0";
        }

        this.log.error("##################调用送审款号排重控制Action end #######################");
        return "1";
    }

}
