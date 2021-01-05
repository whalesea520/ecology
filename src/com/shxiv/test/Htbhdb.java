package com.shxiv.test;

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
 * Created by Administrator on 2020/2/12.
 */
public class Htbhdb extends BaseBean implements Action  {

    private Log log = LogFactory.getLog(Htbhdb.class.getName());

    @Override
    public String execute(RequestInfo request) {

        this.log.error("######################   开始对比合同编号    ###########################");
        RecordSet rss = new RecordSet();
        RecordSet rss1 = new RecordSet();
        String tempMessage = "";

        try {
            WorkflowComInfo workflowComInfo = new WorkflowComInfo();
            int requestid = Util.getIntValue(request.getRequestid());//创建一个流程就生成唯一标识的请求ID
            int workflowid = Util.getIntValue(request.getWorkflowid());//流程ID
            int formid = Util.getIntValue(workflowComInfo.getFormId("" + workflowid));//表单ID

            //主表表名
            String mainTable = "formtable_main_" + ((-1) * formid);//获取到当前流程表单的主表表名


            String lcbh="";//流程编号

            //主表数据
            //通过流程生成唯一标识的请求ID获取到该流程对应的主表ID,被授权方,合同编号new
            String sqlMa=" select htbh from "+mainTable+" where requestId='"+requestid+"'  ";
            rss.execute(sqlMa);
            if(rss.next()){
                lcbh=rss.getString("htbh");
            }

            String htbh="";//合同编号
            List<String> htbhList=new ArrayList<String>();
            String sql="select htbh from uf_HTK";
            rss1.execute(sql);
            while(rss1.next()){
                htbh=rss1.getString("htbh");
                htbhList.add(htbh);
            }
            if(htbhList.contains(lcbh)){
                tempMessage = "合同编号与合同库中合同编号相同,相互冲突!请重新编辑合同编号";
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

        this.log.error("######################   对比合同编号 end  ##############################################");

        return "1";
    }
}
