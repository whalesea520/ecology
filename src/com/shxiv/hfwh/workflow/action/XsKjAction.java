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
public class XsKjAction extends BaseBean implements Action {

    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(XsKjAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################   开始调用权益金扣减Action     ###########################");
        RecordSet rs1 = new RecordSet();
        RecordSet rs3 = new RecordSet();
        String tempMessage = "";
        try {
            WorkflowComInfo workflowComInfo = new WorkflowComInfo();
            int requestid = Util.getIntValue(request.getRequestid());//创建一个流程就生成唯一标识的请求ID
            int workflowid = Util.getIntValue(request.getWorkflowid());//流程ID
            int formid = Util.getIntValue(workflowComInfo.getFormId("" + workflowid));//表单ID 

            //主表表名
            String mainTable = "formtable_main_" + ((-1) * formid);

            String htbh="";

            String htqj="";

            String qyhj="";

            //主表数据
            MainTableInfo formtable_main_x = request.getMainTableInfo();
            Property[] properties = formtable_main_x.getProperty();
            for (int i = 0; i < properties.length; i++) {
                String fieldName = properties[i].getName();
                String fieldValue = Util.null2String(properties[i].getValue());
                if ("xzkj".equalsIgnoreCase(fieldName)) {
                    htqj = fieldValue;//选择扣减
                }else if("qlj".equalsIgnoreCase(fieldName)){
                    qyhj=fieldValue;//权利金
                }else if ("htbh".equalsIgnoreCase(fieldName)) {
                    htbh = fieldValue;//合同编号
                }
            }

            //合同类型：0销售；1权益金
            String htlx="";
            //根据合同编号查询合同库的ID、是否计算权益金、是否计算成本、合同类型、计算价格种类
            String sqlT="select id,sfjsqyj,sfjscb,htlx,jsjgzl from uf_HTK where id='"+htbh+"'";
            rs3.execute(sqlT);
            if(rs3.next()){
                htlx=rs3.getString("htlx");//合同类型
            }
            //根据合同类型计算:0销售、1权益金
            if("0".equals(htlx)){
                //获取最低保证金未税价
                String zdb="0";
                //获取累计防伪标权益金额
                String ljj="0";
                //根据主表的选择扣减查询合同保底金查询的到账未税金额、累计防伪标权益金额
                String sqlZd="select dzwsje,ljfwbqyje from htk_8 where id='"+htqj+"'";
                rs3.execute(sqlZd);
                if(rs3.next()){
                    zdb=rs3.getString("dzwsje");//到账未税金额
                    ljj=rs3.getString("ljfwbqyje");//累计防伪标权益金额
                }

                BigDecimal bb7=new BigDecimal("0");
                if(!"".equals(zdb)){
                    bb7=new BigDecimal(zdb);
                }

                BigDecimal bb10=new BigDecimal("0");
                if(!"".equals(ljj)){
                    bb10=new BigDecimal(ljj);
                }

                BigDecimal bb8=new BigDecimal("0");
                if(!"".equals(qyhj)){
                    bb8=new BigDecimal(qyhj);
                }

                BigDecimal bb11=bb8.add(bb10);//权益金+累计防伪标权益金额
                double d4=bb11.doubleValue();

                BigDecimal bb9=bb7.subtract(bb11);//到账未税金额-(权益金+累计防伪标权益金额)
                double d3=bb9.doubleValue();
                if(d3>=0){
                	//根据主表的选择扣减更新合同库明细表8的销售报表累计金额、剩余保证金金额
                    String sqlU3="update uf_htk_dt8 set xsbxljje='"+bb11.toString()+"',sybzjje='"+bb9.toString()+"'  where id='"+htqj+"' ";
                    log.error("外部sqlU3: "+sqlU3);
                    rs3.execute(sqlU3);
                }
            }
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
