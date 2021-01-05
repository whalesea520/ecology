package com.shxiv.hfwh.workflow.action;

import com.weaver.general.BaseBean;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;
import weaver.workflow.workflow.WorkflowComInfo;

import java.text.SimpleDateFormat;
import java.util.Date;

public class HtKhXgAction extends BaseBean implements Action {

    private Log log = LogFactory.getLog(HtKhXgAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################开始调用合同款号转移控制Action###########################");
        RecordSet rss = new RecordSet();
        RecordSet rs1 = new RecordSet();
        RecordSet rs2 = new RecordSet();
        RecordSet rs3 = new RecordSet();

        String tempMessage = "";
        try {
            WorkflowComInfo workflowComInfo = new WorkflowComInfo();
            int requestid = Util.getIntValue(request.getRequestid());//创建一个流程就生成唯一标识的请求ID
            int workflowid = Util.getIntValue(request.getWorkflowid());//流程ID
            int formid = Util.getIntValue(workflowComInfo.getFormId("" + workflowid));//表单ID

            //获取当前日期
            SimpleDateFormat format1=new SimpleDateFormat("yyyy-MM-dd");

            //获取当前时间
            SimpleDateFormat format2=new SimpleDateFormat("HH:mm");

            String nowDate=format1.format(new Date());

            String nowTime=format2.format(new Date());

            //主表表名
            String mainTable = "formtable_main_" + ((-1) * formid);//获取到当前流程表单的主表表名

            String mainId="";//主表ID

            //通过流程生成唯一标识的请求ID获取到该流程对应的主表ID
            String sqlMa="select id from "+mainTable+" where requestId='"+requestid+"'  ";
            rs1.execute(sqlMa);
            if(rs1.next()){
                mainId=rs1.getString("id");
            }

            String htbh1="";//合同编号
            String bsqs="";//被授权商
            String kh="";//客户
            String xhtbh="";//新合同编号
            String xbsqs="";//新被授权商
            String xkh="";//新客户
            String bh="";//编号
            String sqr="";//申请人

            //主表数据
            //通过流程生成唯一标识的请求ID获取到该流程对应的主表ID,被授权方,合同编号new
            String sqlMb="select htbh1,bsqs,kh,xhtbh,xbsqs,xkh,bh,sqr from "+mainTable+" where requestId='"+requestid+"'  ";
            //log.error("sqlMb:"+sqlMb);
            rss.execute(sqlMb);
            while(rss.next()){
                htbh1=rss.getString("htbh1");
                bsqs=rss.getString("bsqs");
                kh=rss.getString("kh");
                xhtbh=rss.getString("xhtbh");
                xbsqs=rss.getString("xbsqs");
                xkh=rss.getString("xkh");
                bh=rss.getString("bh");
                sqr=rss.getString("sqr");
            }

            String hfkh="";//红纺款号

            //根据主表ID查询明细表1的红纺款号
            String sqlMc="select id from uf_spsslc where htbm='"+htbh1+"'";
            //log.error("sqlMc:"+sqlMc);
            rs2.execute(sqlMc);
            while(rs2.next()){
                hfkh= rs2.getString("id");

                //根据ID插入台账明细表2
                String sqlMe="insert into uf_spsslc_dt2(mainid,htbh,kh,bsqs,bh,xgr1,xgsj) "+"values('"+hfkh+"','"+htbh1+"','"+kh+"','"+bsqs+ "','"+bh+"','"+sqr+"','"+nowDate+"')";
                //log.error("sqlMe:"+sqlMe);
                rs3.execute(sqlMe);

                //更新台账表主表的合同,客户,被授权商
                String sqlMf="update uf_spsslc set htbm='"+xhtbh+"',sqs='"+xbsqs+"',bsqs='"+xkh+"',XGRQ='"+nowDate+"',XGSJ='"+nowTime+"'  where id='"+hfkh+"'";
                //log.error("sqlMf:"+sqlMf);
                rs3.execute(sqlMf);

            }

        } catch (Exception e) {
            tempMessage = ""+e;
            request.getRequestManager().setMessageid("流程提交失败");
            request.getRequestManager().setMessagecontent(tempMessage);
            return "0";
        }

        this.log.error("######################调用合同款号转移Action end##################################");
        /***interface action  stop *****/

        return "1";
    }

}
