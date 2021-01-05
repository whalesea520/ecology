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
 * 权益金控制
 */
public class XsKzActionOld extends BaseBean implements Action {

    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(XsKzActionOld.class.getName());

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################   开始调用销售控制Action     ###########################");
        RecordSet rss = new RecordSet();
        RecordSet rs1 = new RecordSet();
        String tempMessage = "";
        try {
            WorkflowComInfo workflowComInfo = new WorkflowComInfo();
            int requestid = Util.getIntValue(request.getRequestid());//创建一个流程就生成唯一标识的请求ID
            int workflowid = Util.getIntValue(request.getWorkflowid());//流程ID
            int formid = Util.getIntValue(workflowComInfo.getFormId("" + workflowid));//表单ID 

            //主表表名
            String mainTable = "formtable_main_" + ((-1) * formid);

            String mainId="";//主表ID
            //查询主表ID
            String sqlMa="select id from "+mainTable+" where requestId='"+requestid+"'  ";
            rs1.execute(sqlMa);
            if(rs1.next()){
                mainId=rs1.getString("id");
            }


            //保证期间
            String bqj="";

            String htbh="";

            //主表数据
            MainTableInfo formtable_main_x = request.getMainTableInfo();
            Property[] properties = formtable_main_x.getProperty();
            for (int i = 0; i < properties.length; i++) {
                String fieldName = properties[i].getName();
                String fieldValue = Util.null2String(properties[i].getValue());
                if ("xzkj".equalsIgnoreCase(fieldName)) {
                    bqj = fieldValue;//选择扣减
                }else if ("htbh".equalsIgnoreCase(fieldName)) {
                    htbh = fieldValue;//合同编号
                }
            }

            //合同类型：0销售；1权益金
            String htlx="";
            //根据合同编号查询合同库的ID、是否计算权益金、是否计算成本、合同类型、计算价格种类
            String sqlT="select id,sfjsqyj,sfjscb,htlx,jsjgzl from uf_HTK where id='"+htbh+"'";
            rss.execute(sqlT);
            if(rss.next()){
                htlx=rss.getString("htlx");//合同类型
            }
            //根据合同类型计算:
            if("0".equals(htlx)){
                double dd1=0;

                String qyjSum="0";
                String mxTable=mainTable+"_dt2";
                //根据主表ID查询出明细表2的权利金总和
                String sqlSum="select  SUM(qlj) as sm  from "+mxTable+" where mainid='"+mainId+"' ";
                rss.execute(sqlSum);
                if(rss.next()){
                    qyjSum=rss.getString("sm");
                }
                if(!"".equals(qyjSum)){
                    dd1=Double.valueOf(qyjSum);//权利金总和
                }

                //更改主表权益金合计字段
                String sqlU1="update "+mainTable+" set qlj='"+qyjSum+"' where id='"+mainId+"' ";
                rss.execute(sqlU1);


                String wsj="0";
                //根据主表的选择扣减查询合同库明细表8的最低保证金未税价(可用)
                String sqlC="select zdbzjeky from uf_HTK_dt8 where id='"+bqj+"'";
                log.error("外部权益金："+sqlC);
                rss.execute(sqlC);
                if(rss.next()){
                    wsj=rss.getString("zdbzjeky");
                }

                double dd2=0;
                if(!"".equals(wsj)){
                    dd2=Double.valueOf(wsj);//最低保证金未税价(可用)
                }
                //权利金总和-最低保证金未税价(可用)大于0，则流程提交失败，报错"权益金超出，不能提交。".
                if(dd1-dd2>0){
                    tempMessage = "权益金超出，不能提交。";
                    request.getRequestManager().setMessageid("流程提交失败");
                    request.getRequestManager().setMessagecontent(tempMessage);
                    return "0";
                }else {
                	//小于等于0,更新合同库明细表8中的最低保证金未税价(可用)
                    BigDecimal bb1=new BigDecimal("0");
                    if(!"".equals(qyjSum)){
                        bb1=new BigDecimal(qyjSum);
                    }

                    BigDecimal bb2=new BigDecimal("0");
                    if(!"".equals(wsj)){
                        bb2=new BigDecimal(wsj);
                    }

                    BigDecimal bb3=bb2.subtract(bb1);
                    double d1=bb3.doubleValue();

                    String sqlU="update uf_HTK_dt8 set zdbzjeky='"+d1+"' where id='"+bqj+"' ";
                    rss.execute(sqlU);
                }
            }
        } catch (Exception e) {
            tempMessage = ""+e;
            request.getRequestManager().setMessageid("流程提交失败");
            request.getRequestManager().setMessagecontent(tempMessage);
            return "0";
        }

        this.log.error("######################        调用销售控制Action end   ################################################");
        /***interface action  stop *****/

        return "1";
    }

}
