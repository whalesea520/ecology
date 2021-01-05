package com.shxiv.hfwh.workflow.action;

import com.weaver.general.BaseBean;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.MainTableInfo;
import weaver.soa.workflow.request.Property;
import weaver.soa.workflow.request.RequestInfo;
import weaver.workflow.workflow.WorkflowComInfo;

import java.math.BigDecimal;

/**
 * Created by zsd on 2019/3/4.
 * 区间剩余金额返还
 */
public class FqFhAction extends BaseBean implements Action {

    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(FqFhAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################   开始调用权益金返还Action     ###########################");
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
            String mainTable = "formtable_main_" + ((-1) * formid);

            String mainId="";
            //根据唯一标识的请求ID查询出主表的ID
            String sqlMa="select id from "+mainTable+" where requestId='"+requestid+"'  ";
            rs1.execute(sqlMa);
            if(rs1.next()){
                mainId=rs1.getString("id");
            }

            //权益金合计
            String qyh="";

            //被授权商ID
            String bqj="";

            //主表数据
            MainTableInfo formtable_main_x = request.getMainTableInfo();
            Property[] properties = formtable_main_x.getProperty();
            for (int i = 0; i < properties.length; i++) {
                String fieldName = properties[i].getName();
                String fieldValue = Util.null2String(properties[i].getValue());
                if ("qljhj".equalsIgnoreCase(fieldName)) {
                    qyh = fieldValue;//获取权益金合计
                }else if ("fktzcx".equalsIgnoreCase(fieldName)) {
                    bqj = fieldValue;//获取被授权商ID
                }
            }

            String wsj="0";
            //根据主表的被授权商ID查询合同库明细表8(uf_HTK_dt8)的最低保证金未税价(可用)
            String sqlC="select zdbzjeky from uf_HTK_dt8 where id='"+bqj+"'";
            log.error("外部权益金："+sqlC);
            rss.execute(sqlC);
            if(rss.next()){
                wsj=rss.getString("zdbzjeky");
            }

            BigDecimal bb1=new BigDecimal("0");
            if(!"".equals(qyh)){
                bb1=new BigDecimal(qyh);//权益金合计
            }

            BigDecimal bb2=new BigDecimal("0");
            if(!"".equals(wsj)){
                bb2=new BigDecimal(wsj);
            }

            BigDecimal bb3=bb2.add(bb1);//最低保证金未税价(可用)
            double d1=bb3.doubleValue();

            //返还
            //根据表的被授权商ID更新合同库明细表8(uf_HTK_dt8)的最低保证金未税价(可用)=主表的权益金合计+合同库明细表8(uf_HTK_dt8)的最低保证金未税价(可用)
            String sqlU="update uf_HTK_dt8 set zdbzjeky='"+d1+"' where id='"+bqj+"' ";
            rss.execute(sqlU);


        } catch (Exception e) {
            tempMessage = ""+e;
            request.getRequestManager().setMessageid("流程提交失败");
            request.getRequestManager().setMessagecontent(tempMessage);
            return "0";
        }

        this.log.error("######################        调用调用权益金返还Action end   ################################################");
        /***interface action  stop *****/

        return "1";
    }

}
