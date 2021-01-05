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

/**
 * Created by zsd on 2019/3/4.
 * 区间剩余金额返还
 */
public class QyjFhAction extends BaseBean implements Action {

    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(QyjFhAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################   开始调用区间剩余金额返还Action     ###########################");
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
            String mainTable = "formtable_main_" + ((-1) * formid);//获取到当前流程表单的主表表名

            String mainId="";//主表ID
            
          //通过流程生成唯一标识的请求ID获取到该流程对应的主表ID
            String sqlMa="select id from "+mainTable+" where requestId='"+requestid+"'  ";
            rs1.execute(sqlMa);
            if(rs1.next()){
                mainId=rs1.getString("id");
            }

            String mxTable2=mainTable+"_dt2";
            //根据主表ID查询明细表2的所有数据
            String sqlMx="select * from "+mxTable2+" where mainid='"+mainId+"' ";
            rss.execute(sqlMx);
            while (rss.next()){
                String qid=rss.getString("QID");//权利金比例ID
                String qyj=rss.getString("qlj");//权利金
                String mxb=rss.getString("mxb");//明细表
                String sqlU="";
                String sqlM="";
                BigDecimal bb1=new BigDecimal("0");
                if(!"".equals(qyj)){
                    bb1=new BigDecimal(qyj);
                }
                log.error("mxb: "+mxb);
                //mxb(明细表)等于3,
                if("3".equals(mxb)){
                    String ysj="";
                    //根据明细表2的权利金比例ID查询合同库明细表3的所有数据。
                    sqlM="select*from uf_HTK_dt3 where id='"+qid+"' ";
                    log.error("sqlM1: "+sqlM);
                    rs2.execute(sqlM);
                    if(rs2.next()){
                        ysj=rs2.getString("qjjsy");//区间金额剩余
                    }
                    BigDecimal bb2=new BigDecimal("0");
                    if(!"".equals(ysj)){
                        bb2=new BigDecimal(ysj);
                    }
                    BigDecimal bb3=bb1.add(bb2);//计算总的区间金额剩余=明细表2的权利金+合同库明细表3的区间金额剩余
                    
                    //根据明细表2的权利金比例ID更新合同库明细表3的区间金额剩余(总的区间金额剩余)
                    sqlU="update uf_HTK_dt3  set qjjsy='"+bb3.toString()+"' where id='"+qid+"' ";
                }else if("11".equals(mxb)){
                    String ysj="";
                  //根据明细表2的权利金比例ID查询合同库明细表11的所有数据。
                    sqlM="select*from uf_HTK_dt11 where id='"+qid+"' ";
                    log.error("sqlM2: "+sqlM);
                    rs2.execute(sqlM);
                    if(rs2.next()){
                        ysj=rs2.getString("qjsyje");//区间剩余金额
                    }
                    BigDecimal bb2=new BigDecimal("0");
                    if(!"".equals(ysj)){
                        bb2=new BigDecimal(ysj);
                    }
                    BigDecimal bb3=bb1.add(bb2);//计算总的区间剩余金额=明细表2的权利金+合同库明细表11的区间剩余金额
                    //根据明细表2的权利金比例ID更新合同库明细表11的区间剩余金额(总的区间剩余金额)
                    sqlU="update uf_HTK_dt11  set qjsyje='"+bb3.toString()+"' where id='"+qid+"' ";
                }else if("12".equals(mxb)){
                    String ysj="";
                    sqlM="select*from uf_HTK_dt12 where id='"+qid+"' ";
                    log.error("sqlM3: "+sqlM);
                    rs2.execute(sqlM);
                    if(rs2.next()){
                        ysj=rs2.getString("qjsyje");
                    }
                    BigDecimal bb2=new BigDecimal("0");
                    if(!"".equals(ysj)){
                        bb2=new BigDecimal(ysj);
                    }
                    BigDecimal bb3=bb1.add(bb2);

                    sqlU="update uf_HTK_dt12  set qjsyje='"+bb3.toString()+"' where id='"+qid+"' ";
                }else if("13".equals(mxb)){
                    String ysj="";
                    sqlM="select*from uf_HTK_dt13 where id='"+qid+"' ";
                    log.error("sqlM4: "+sqlM);
                    rs2.execute(sqlM);
                    if(rs2.next()){
                        ysj=rs2.getString("qjsyje");
                    }
                    BigDecimal bb2=new BigDecimal("0");
                    if(!"".equals(ysj)){
                        bb2=new BigDecimal(ysj);
                    }
                    BigDecimal bb3=bb1.add(bb2);

                    sqlU="update uf_HTK_dt13  set qjsyje='"+bb3.toString()+"' where id='"+qid+"' ";
                }
                log.error("sqlU1: "+sqlU);
                rs1.execute(sqlU);

            }


            //删除明细表2数据
            String sqlDel="delete "+mxTable2+"  where mainid='"+mainId+"' ";
            rs1.execute(sqlDel);




        } catch (Exception e) {
            tempMessage = ""+e;
            request.getRequestManager().setMessageid("流程提交失败");
            request.getRequestManager().setMessagecontent(tempMessage);
            return "0";
        }

        this.log.error("######################        调用区间剩余金额Action end   ################################################");
        /***interface action  stop *****/

        return "1";
    }

}
