package com.shxiv.hfwh.workflow.action;

import com.weaver.general.BaseBean;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;
import weaver.workflow.workflow.WorkflowComInfo;

public class HtKhFwbAction extends BaseBean implements Action {

    private Log log = LogFactory.getLog(HtKhFwbAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################开始调用合同款号转移防伪标控制Action###########################");
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

            String htbh="";//合同编号

            //主表数据
            //通过流程生成唯一标识的请求ID获取到该流程对应的主表ID,被授权方,合同编号new
            String sqlMa="select htbh1 from "+mainTable+" where requestId='"+requestid+"'  ";
            rss.execute(sqlMa);
            if(rss.next()){
                htbh=rss.getString("htbh1");
            }
            //log.error("htbh:"+htbh);

            String id="";//红纺款号Id
            String hfkh="";//红纺款号文本
            String sqlMe="select id,hfkh from uf_spsslc where htbm='"+htbh+"'";
            rss.execute(sqlMe);
            if(rss.next()) {
                id = rss.getString("id");
                hfkh= rss.getString("hfkh");
                int ct = 0;
                String sqlMb = "select COUNT( *)as ct from formtable_main_197_dt1 where mainid in( " +
                        " select a.id from formtable_main_197 a " +
                        " join workflow_requestbase b on a.requestId=b.requestid " +
                        " where b.currentnodetype in (0,1,2) and a.htbh1='"+htbh+"'"+
                        ") and hfkh='"+id+"'";
                //log.error("sqlMb:"+sqlMb);
                rs1.execute(sqlMb);
                while (rs1.next()) {
                    ct = rs1.getInt("ct");
                }
                //log.error("ct:"+ct);
                if (ct > 0) {
                    tempMessage = "转移中的款号在防伪标申请流程中还有未归档的流程,请确认该合同的防伪标流程是否全部已归档！";
                    request.getRequestManager().setMessageid("流程提交失败");
                    request.getRequestManager().setMessagecontent(tempMessage);
                    return "0";
                }

            }

        } catch (Exception e) {
            tempMessage = ""+e;
            request.getRequestManager().setMessageid("流程提交失败");
            request.getRequestManager().setMessagecontent(tempMessage);
            return "0";
        }

        this.log.error("######################合同款号转移防伪标控制Action end##################################");
        /***interface action  stop *****/

        return "1";
    }

}
