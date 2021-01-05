package com.shxiv.hfwh.workflow.action;

import com.weaver.general.BaseBean;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;
import weaver.workflow.workflow.WorkflowComInfo;

public class ByjSqdFhAction extends BaseBean implements Action {
    private Log log = LogFactory.getLog(ByjSqdFhAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        this.log.error("######################备用金申请单控制返回Action###########################");
        RecordSet rss = new RecordSet();
        String tempMessage = "";
        try {
            WorkflowComInfo workflowComInfo = new WorkflowComInfo();
            int requestid = Util.getIntValue(request.getRequestid());//创建一个流程就生成唯一标识的请求ID
            int workflowid = Util.getIntValue(request.getWorkflowid());//流程ID
            int formid = Util.getIntValue(workflowComInfo.getFormId("" + workflowid));//表单ID

            //主表表名
            String mainTable = "formtable_main_" + ((-1) * formid);//获取到当前流程表单的主表表名

            //明细表名
            String mxTable = mainTable+"_dt1";//获取到当前流程表单的明细表名:主表_dtx

            String id="";

            String sqlMa="select id from "+mainTable+" where requestId='"+requestid+"'  ";
            rss.execute(sqlMa);
            this.log.error("sqlMa:"+sqlMa);
            if(rss.next()){
                id=rss.getString("id");
            }

            String sqlMb="delete from  "+mxTable+" where mainid="+id;
            rss.execute(sqlMb);
            this.log.error("sqlMb:"+sqlMb);

        } catch (Exception e) {
            tempMessage = ""+e;
            request.getRequestManager().setMessageid("流程提交失败");
            request.getRequestManager().setMessagecontent(tempMessage);
            return "0";
        }

        this.log.error("######################调用备用金申请单控制返回Action end#######################################");
        /***interface action  stop *****/

        return "1";
    }

}
