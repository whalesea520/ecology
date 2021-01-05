package com.shxiv.hfwh.workflow.action;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.RecordSet;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;
import weaver.workflow.workflow.WorkflowComInfo;

import java.text.SimpleDateFormat;
import java.util.Date;


/**
 * Created by zsd on 2018/7/11.
 */
public class RqAction extends BaseBean implements Action {

    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(RqAction.class.getName());

    private String xgRq;

    private String xgSj;

    public String getXgRq() {
        return xgRq;
    }

    public void setXgRq(String xgRq) {
        this.xgRq = xgRq;
    }

    public String getXgSj() {
        return xgSj;
    }

    public void setXgSj(String xgSj) {
        this.xgSj = xgSj;
    }

    /*
     *
      * <p>Title: execute</p>
      * <p>Description: </p>
      * @param request
      * @return
      * @see weaver.interfaces.workflow.action.Action#execute(weaver.soa.workflow.request.RequestInfo)
     */
    @Override
    public String execute(RequestInfo request) {
        WorkflowComInfo workflowComInfo = new WorkflowComInfo();
        int requestid = Util.getIntValue(request.getRequestid());
        int workflowid = Util.getIntValue(request.getWorkflowid());
        int formid = Util.getIntValue(workflowComInfo.getFormId(""+workflowid));
        String maintablename = "formtable_main_"+((-1)*formid);

        String tempMessage="";

        RecordSet rs=new RecordSet();
        /***interface action  start*****/
        this.log.error("########tirrger  action:"+ this.getClass().getName()+" start  ################################################");

        try {

            //获取当前日期
            SimpleDateFormat format1=new SimpleDateFormat("yyyy-MM-dd");

            //获取当前时间
            SimpleDateFormat format2=new SimpleDateFormat("HH:mm");

            String nowDate=format1.format(new Date());

            String nowTime=format2.format(new Date());



            //流程标题
            //根据主表的ID更新主表的日期和时间
            String sqlU=" update "+maintablename+" set  "+xgRq+"='"+nowDate+"',"+xgSj+"='"+nowTime+"'  where requestId='"+requestid+"' ";
            rs.execute(sqlU);

        } catch (Exception e) {
            tempMessage = ""+e;
            request.getRequestManager().setMessageid("流程提交失败");
            request.getRequestManager().setMessagecontent(tempMessage);
            return "0";
        }

        this.log.error("########tirrger  action:"+this.getClass().getName()+" end   ################################################");
        /***interface action  stop *****/

        return "1";
    }
}
