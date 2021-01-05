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
 * @author wyj
 * @date 2020/12/22 17:09
 */
public class HtBgSqAction extends BaseBean implements Action {
    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(HtBgSqAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        this.log.error("######################开始调用合同变更申请控制Action ###########################");
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

            String id="";
            String bt="";
            String  lcbh="";
            String bgr="";
            String bgrq="";
            String htbgsm="";
            String htbh="";

            String sqlMa="select id,requestid,bh,httjr,tjrq,htbgsm,htbh from "+mainTable+" where requestId='"+requestid+"'  ";
            rss.execute(sqlMa);
            log.error("sqlMa: "+sqlMa);
            if(rss.next()){
                id=rss.getString("id");
                bt=rss.getString("requestid");
                lcbh = rss.getString("bh");
                bgr=rss.getString("httjr");
                bgrq = rss.getString("tjrq");
                htbgsm=rss.getString("htbgsm");
                htbh=rss.getString("htbh");
            }

            String sqlMb=" insert into uf_HTK_dt16 (mainid,bt,lcbh,bgr,bgrq,htbgsm,htbh) values ('"+htbh+"','"+bt+"','"+lcbh+"','"+bgr+"','"+bgrq+"','"+htbgsm+"','"+htbh+"') ";
            log.error("sqlMb: "+sqlMb);
            rs1.execute(sqlMb);
        }catch (Exception e) {
                tempMessage = ""+e;
                request.getRequestManager().setMessageid("流程提交失败");
                request.getRequestManager().setMessagecontent(tempMessage);
                return "0";
            }

            this.log.error("######################调用合同变更申请控制Action end   ###################################");
            /***interface action  stop *****/

            return "1";
        }
}
