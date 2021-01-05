package com.shxiv.hfwh.workflow.action;

import com.weaver.general.BaseBean;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;
import weaver.workflow.workflow.WorkflowComInfo;

public class ByjSqdAction extends BaseBean implements Action {

    private Log log = LogFactory.getLog(ByjSqdAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        this.log.error("######################备用金申请单控制Action###########################");
        RecordSet rss = new RecordSet();
        RecordSet rs1 = new RecordSet();
        RecordSet rs2 = new RecordSet();
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
            String sqrq="";//申请日期
            String ghrq="";//归还日期
            String zbjkje="";//借款金额
            String jkr="";//借款人

            String sqlMa="select id,sqrq,ghrq,jkr,jkje from "+mainTable+" where requestId='"+requestid+"'  ";
            rss.execute(sqlMa);
            this.log.error("sqlMa:"+sqlMa);
            if(rss.next()){
                id=rss.getString("id");
                sqrq=rss.getString("sqrq");
                ghrq=rss.getString("ghrq");
                jkr=rss.getString("jkr");
                zbjkje=rss.getString("jkje");
            }

            if(ghrq.compareTo(sqrq)<0){
                tempMessage = "归还日期不能小于申请日期,请确认时间!";
                request.getRequestManager().setMessageid("流程提交失败");
                request.getRequestManager().setMessagecontent(tempMessage);
                return "0";
            }

            String mainid="";
            String reqid="";
            String lcbh="";
            String jkje="";
            String mghrq="";

            String sqlMb="select a.requestid,a.lcbh,a.jkje,a.ghrq from formtable_main_38 a " +
                    "join workflow_requestbase b on a.requestId=b.requestid where a.jkr='"+jkr+"' and b.currentnodetype=3"+" and a.ghrq"+">='"+sqrq+"'";
            rs1.execute(sqlMb);
            this.log.error("sqlMb:"+sqlMb);
            while (rs1.next()){
                reqid=rs1.getString("requestid");
                lcbh=rs1.getString("lcbh");
                jkje=rs1.getString("jkje");
                mghrq=rs1.getString("ghrq");

                String sqlMc="insert into formtable_main_38_dt1(mainid,bt,bh,qkje,ghrq) values('"+id+"','"+reqid+"','"+lcbh+"','"+jkje+"','"+mghrq+"')";
                rs2.execute(sqlMc);
                this.log.error("sqlMc:"+sqlMc);

            }


        } catch (Exception e) {
            tempMessage = ""+e;
            request.getRequestManager().setMessageid("流程提交失败");
            request.getRequestManager().setMessagecontent(tempMessage);
            return "0";
        }

        this.log.error("######################调用备用金申请单控制Action end#######################################");
        /***interface action  stop *****/

        return "1";
    }

}
