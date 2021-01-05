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
 * 权益金计算
 */
public class QyjKjAction extends BaseBean implements Action {

    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(QyjKjAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################   开始调用权益金扣减Action     ###########################");
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

            //主表表名
            String mainTable = "formtable_main_" + ((-1) * formid);//获取到当前流程表单的主表表名

            String mainId="";
            //根据唯一标识的请求ID获取主表的ID
            String sqlMa="select id from "+mainTable+" where requestId='"+requestid+"'  ";
            rs1.execute(sqlMa);
            if(rs1.next()){
                mainId=rs1.getString("id");
            }

            //合同编号
            String htbh="";

            //申请日期
            String sqrq="";

            //被授权方
            String bsqf="";

            String ckzje="";

            String cbdj="";

            String qydj="";

            String cbhj="";

            String htqj="";

            String qyhj="";

            //主表数据
            //获取主表数据的合同编号new、被授权方、出库总金额、成本合计
            MainTableInfo formtable_main_x = request.getMainTableInfo();
            Property[] properties = formtable_main_x.getProperty();
            for (int i = 0; i < properties.length; i++) {
                String fieldName = properties[i].getName();
                String fieldValue = Util.null2String(properties[i].getValue());
                if ("htbh1".equalsIgnoreCase(fieldName)) {
                    htbh = fieldValue;
                }else if ("bsqf".equalsIgnoreCase(fieldName)) {
                    bsqf = fieldValue;
                }else if ("ckzje".equalsIgnoreCase(fieldName)) {
                    ckzje = fieldValue;
                }else if ("cbhj".equalsIgnoreCase(fieldName)) {
                    cbhj = fieldValue;
                }
            }

            BigDecimal bb1=new BigDecimal("0");
            if(!"".equals(ckzje)){
                bb1=new BigDecimal(ckzje);//出库总金额
            }

            log.error("外部出库金额: "+ckzje);

            String cbje="0";
            //根据被授权方查询uf_sqscb(授权商成本)表的cbje(成本金额)
            String sqlC="select cbje from uf_sqscb where sqs='"+bsqf+"'";
            rss.execute(sqlC);
            if(rss.next()){
                cbje=rss.getString("cbje");
            }

            BigDecimal bb2=new BigDecimal("0");
            if(!"".equals(cbje)){
                bb2=new BigDecimal(cbje);
            }

            BigDecimal bb4=new BigDecimal("0");
            if(!"".equals(cbhj)){
                bb4=new BigDecimal(cbhj);
            }

            BigDecimal bb3=bb2.subtract(bb1).add(bb4);//计算总cbje(成本金额)等于cbje(成本金额)-出库总金额+成本合计
            double d1=bb3.doubleValue();
            //根据被授权方更新uf_sqscb(授权商成本)表的cbje(成本金额)
            String sqlU1="update uf_sqscb set cbje='"+bb3.toString()+"' where sqs='"+bsqf+"' ";
            log.error("sqlU1: "+sqlU1);
            rss.execute(sqlU1);


        } catch (Exception e) {
            tempMessage = ""+e;
            request.getRequestManager().setMessageid("流程提交失败");
            request.getRequestManager().setMessagecontent(tempMessage);
            return "0";
        }

        this.log.error("######################        调用权益金计算Action end   ################################################");
        /***interface action  stop *****/

        return "1";
    }

}
