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
import java.util.ArrayList;
import java.util.List;

public class FkSqdAction extends BaseBean implements Action {
    private Log log = LogFactory.getLog(FkSqdAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        this.log.error("######################付款申请单控制Action###########################");
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

            //明细表名
            String mxTable = mainTable+"_dt1";//获取到当前流程表单的明细表名:主表_dtx

            String id="";
            String sfhtfk="";
            String yfkje="";
            String spzje="";
            String bcfkje="";
            String htze="";
            String htbh="";

            String sqlMa="select id,sfhtfk,yfkje,spzje,bcfkje,htze,htbh from "+mainTable+" where requestId='"+requestid+"'  ";
            rss.execute(sqlMa);
            this.log.error("sqlMa:"+sqlMa);
            if(rss.next()){
                id=rss.getString("id");
                sfhtfk=rss.getString("sfhtfk");
                yfkje=rss.getString("yfkje");
                spzje=rss.getString("spzje");
                bcfkje=rss.getString("bcfkje");
                htze=rss.getString("htze");
                htbh=rss.getString("htbh");
            }

            if(sfhtfk.equals("0")){
                if("".equals(yfkje)) {
                    yfkje="0";
                }

                if("".equals(spzje)) {
                    spzje="0";
                }

                if("".equals(bcfkje)) {
                    bcfkje="0";
                }

                BigDecimal var4 = new BigDecimal("0");
                if(!"".equals(htze)) {
                    var4 = new BigDecimal(htze);
                }

                if(yfkje.equals("0.00")){
                    String aa="";
                    String sqlMd=" select ( ISNULL(sum(bcfkje),0)+(select ISNULL(lsfkje,0) from uf_httzb where id='"+htbh+"')) aa from formtable_main_62 fm,workflow_requestbase wr where fm.requestId=wr.requestid and  wr.currentnodetype=3 and fm.htbh='"+htbh+"' and fm.requestId!='"+requestid+"'";
                    rss1.execute(sqlMd);
                    this.log.error("sqlMd:"+sqlMd);
                    if(rss1.next()){
                        aa=rss1.getString("aa");
                    }

                    String sqlMe="update "+mainTable+" set yfkje='"+aa+"' where requestId='"+requestid+"'";
                    rss1.execute(sqlMe);
                    this.log.error("sqlMe:"+sqlMe);
                }

                if(spzje.equals("0.00")){
                    String aa="";
                    String sqlMf="select ISNULL(sum(bcfkje),0) aa from formtable_main_62 fm,workflow_requestbase wr where fm.requestId=wr.requestid and wr.currentnodetype<3 and wr.currentnodetype>0 and fm.htbh='"+htbh+"' and fm.requestId!='"+requestid+"'";
                    rss1.execute(sqlMf);
                    this.log.error("sqlMd:"+sqlMf);
                    if(rss1.next()){
                        aa=rss1.getString("aa");
                    }

                    String sqlMg="update "+mainTable+" set spzje='"+aa+"' where requestId='"+requestid+"'";
                    rss1.execute(sqlMg);
                    this.log.error("sqlMg:"+sqlMg);
                }


                List<String> list=new ArrayList<String>();
                list.add(yfkje);
                list.add(spzje);
                list.add(bcfkje);
                this.log.error("List:"+list.toString());

                BigDecimal count=new BigDecimal(0);
                for(String string:list) {
                    count = count.add(new BigDecimal(string));
                }
                this.log.error("count总和:" + count);

                this.log.error("var1和var2比较:"+count.compareTo(var4));
                if(count.compareTo(var4)==1){
                    tempMessage = "本次付款金额+已付款金额+审批中金额不能大于合同总额!";
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

        this.log.error("######################调用付款申请单控制Action end#######################################");
        /***interface action  stop *****/

        return "1";
    }

}
