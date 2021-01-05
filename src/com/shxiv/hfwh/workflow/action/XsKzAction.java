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
public class XsKzAction extends BaseBean implements Action {

    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(XsKzAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################   开始调用销售控制Action     ###########################");
        RecordSet rss = new RecordSet();
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

            String mainId="";
            //获取主表ID
            String sqlMa="select id from "+mainTable+" where requestId='"+requestid+"'  ";
            rs1.execute(sqlMa);
            if(rs1.next()){
                mainId=rs1.getString("id");
            }


            //保证期间
            String bqj="";

            String htbh="";

            String qyhj="";

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
                }else if("qlj".equalsIgnoreCase(fieldName)){
                    qyhj=fieldValue;//权利金
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
            //根据合同类型计算:0销售、1权益金
            if("0".equals(htlx)){
                double dd1=0;

                String qyjSum="0";
                String mxTable=mainTable+"_dt2";
                //根据明细表2查询出权利金总和
                String sqlSum="select  SUM(qlj) as sm  from "+mxTable+" where mainid='"+mainId+"' ";
                rss.execute(sqlSum);
                if(rss.next()){
                    qyjSum=rss.getString("sm");
                }
                if(!"".equals(qyjSum)){
                    dd1=Double.valueOf(qyjSum);//权利金总和
                }

                //更改主表权益金合计字段
                //根据唯一标的ID更新主表的权利金
                String sqlU1="update "+mainTable+" set qlj='"+qyjSum+"' where id='"+mainId+"' ";
                rss.execute(sqlU1);


                String wsj="0";
                //根据主表的选择扣减查询合同库明细表8的剩余保证金金额
                String sqlC="select sybzjje from uf_HTK_dt8 where id='"+bqj+"'";
                log.error("外部权益金："+sqlC);
                rss.execute(sqlC);
                if(rss.next()){
                    wsj=rss.getString("sybzjje");//剩余保证金金额
                }

                double dd2=0;
                if(!"".equals(wsj)){
                    dd2=Double.valueOf(wsj);//剩余保证金金额
                }
                //权利金总减去剩余保证金金额如果大于0，则流程提交失败,报错权益金超出，不能提交。
                if(dd1-dd2>0){
                    tempMessage = "权益金超出，不能提交。";
                    request.getRequestManager().setMessageid("流程提交失败");
                    request.getRequestManager().setMessagecontent(tempMessage);
                    return "0";
                }else {
                	//小于等于0,执行以下操作:
                    //获取最低保证金未税价
                    String zdb="0";
                    //获取累计防伪标权益金额
                    String ljj="0";
                    //根据主表的选择扣减查询合同保底金查询表的剩余保证金金额、销售报表累计金额
                    String sqlZd="select sybzjje,xsbxljje from htk_8 where id='"+bqj+"'";
                    rs3.execute(sqlZd);
                    if(rs3.next()){
                        zdb=rs3.getString("sybzjje");//剩余保证金金额
                        ljj=rs3.getString("xsbxljje");//销售报表累计金额
                    }

                    BigDecimal bb7=new BigDecimal("0");
                    if(!"".equals(zdb)){
                        bb7=new BigDecimal(zdb);//剩余保证金金额
                    }

                    BigDecimal bb10=new BigDecimal("0");
                    if(!"".equals(ljj)){
                        bb10=new BigDecimal(ljj);//销售报表累计金额
                    }

                    BigDecimal bb8=new BigDecimal("0");
                    if(!"".equals(qyjSum)){
                        bb8=new BigDecimal(qyjSum);//权利金总和
                    }

                    BigDecimal bb11=bb8.add(bb10);//销售报表累计金额=权利金总和+销售报表累计金额
                    double d4=bb11.doubleValue();

                    BigDecimal bb9=bb7.subtract(bb8);//剩余保证金金额=剩余保证金金额-权利金总和
                    double d3=bb9.doubleValue();
                    //剩余保证金金额大于等于0,更新合同库明细表8的销售报表累计金额、剩余保证金金额
                    if(d3>=0){
                        String sqlU3="update uf_htk_dt8 set xsbxljje='"+bb11.toString()+"',sybzjje='"+bb9.toString()+"'  where id='"+bqj+"' ";
                        log.error("外部sqlU3: "+sqlU3);
                        rs3.execute(sqlU3);
                    }
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
