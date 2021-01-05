package com.shxiv.hfwh.workflow.action;

import com.weaver.general.BaseBean;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;
import weaver.workflow.workflow.WorkflowComInfo;

import java.math.BigDecimal;

public class FyBxAction extends BaseBean implements Action {
    private Log log = LogFactory.getLog(FyBxAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        this.log.error("######################费用报销申请单控制Action###########################");
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
            String sfcjk="";
            String bxjehj="";
            String bccjje="";
            String syje="";

            String sqlMa="select id,sfcjk,bxjehj,bccjje,syje from "+mainTable+" where requestId='"+requestid+"'  ";
            rss.execute(sqlMa);
            this.log.error("sqlMa:"+sqlMa);
            if(rss.next()){
                id=rss.getString("id");
                sfcjk=rss.getString("sfcjk");
                bxjehj=rss.getString("bxjehj");
                bccjje=rss.getString("bccjje");
                syje=rss.getString("syje");
            }

            if(sfcjk.equals("0")) {
                if (!bxjehj.equals(bccjje)) {
                    tempMessage = "本次冲借金额必须等于报销金额合计!";
                    request.getRequestManager().setMessageid("流程提交失败");
                    request.getRequestManager().setMessagecontent(tempMessage);
                    return "0";
                }
                BigDecimal var1 = new BigDecimal("0");
                if(!"".equals(bccjje)) {
                    var1 = new BigDecimal(bccjje);
                }

                BigDecimal var2 = new BigDecimal("0");
                if(!"".equals(syje)) {
                    var2 = new BigDecimal(syje);
                }
                this.log.error("var1和var2比较:"+var1.compareTo(var2));
                if(var1.compareTo(var2)==1){
                    tempMessage = "本次冲借金额合计不能大于剩余借款金额!";
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

        this.log.error("######################调用费用报销申请单控制返回Action end#######################################");
        /***interface action  stop *****/

        return "1";
    }

}
