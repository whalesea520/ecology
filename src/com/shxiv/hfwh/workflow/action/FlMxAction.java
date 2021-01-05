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
 * Created by zsd on 2019/5/7.
 */
public class FlMxAction extends BaseBean implements Action {

    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(DlAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################   开始调用辅料申请插入Action     ###########################");
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

            //明细表1
            String mxTable1 = mainTable+"_dt1";

            //明细表2
            String mxTable2 = mainTable+"_dt2";

            String mainId="";//主表ID
            
            //根据唯一标识的请求ID查询主表的ID
            String sqlMa="select id from "+mainTable+" where requestId='"+requestid+"'  ";
            rs1.execute(sqlMa);
            if(rs1.next()){
                mainId=rs1.getString("id");
            }

            //根据主表ID查询出明细表1的flzcbje(辅料总成本金额)的和、cksl(出库数量)的和、辅料编码、辅料名称
            String sqlMx=" select SUM(flzcbje) as sje,SUM(cksl) as ssl,fltm,flmc from "+mxTable1+" group by mainid,fltm,flmc having mainid='"+mainId+"'";
            rss.execute(sqlMx);
            while (rss.next()){
                String flbm=rss.getString("fltm");//辅料编码
                String flmc=rss.getString("flmc");//辅料名称
                String flzcbje=rss.getString("sje");//辅料总成本金额的和
                String cksl=rss.getString("ssl");//出库数量的和

                //是否存在
                String ct1="0";
                //根据主表的ID和明细表1的辅料编码查询明细表2是否存在数据
                String sqlSf=" select COUNT(*) as ct1 from "+mxTable2+" where mainid='"+mainId+"' and flbm='"+flbm+"'  ";
                log.error("sqlSf: "+sqlSf);
                rs1.execute(sqlSf);
                if(rs1.next()){
                    ct1=rs1.getString("ct1");
                }

                String sqlU="";
                //没有数据，向明细表2中插入数据。
                if("0".equals(ct1)){//插入
                    sqlU=" insert into "+mxTable2+" (flbm,flmc,flzcbje,cksl) values ('"+flbm+"','"+flmc+"','"+flzcbje+"','"+cksl+"') ";
                }else {//更新
                	
                    String fje="0";
                    String fsl="0";
                    //有数据,更新数据。根据主表ID和明细表1的辅料条码查出明细表2的所有数据
                    String sqlMx2=" select * from "+mxTable2+" where mainid='"+mainId+"' and flbm='"+flbm+"'  ";
                    rs1.execute(sqlMx2);
                    if(rs1.next()){
                        fje=rs1.getString("flzcbje");//辅料总成本金额
                        fsl=rs1.getString("cksl");//出库数量
                    }
                    //金额计算
                    BigDecimal bb1=new BigDecimal("0");
                    if(!"".equals(flzcbje)){
                        bb1=new BigDecimal(flzcbje);
                    }

                    BigDecimal bb2=new BigDecimal("0");
                    if(!"".equals(fje)){
                        bb2=new BigDecimal(fje);
                    }

                    BigDecimal bb3=bb1.add(bb2);


                    //数量计算
                    BigDecimal bb4=new BigDecimal("0");
                    if(!"".equals(flzcbje)){
                        bb4=new BigDecimal(flzcbje);
                    }

                    BigDecimal bb5=new BigDecimal("0");
                    if(!"".equals(fsl)){
                        bb5=new BigDecimal(fsl);
                    }

                    BigDecimal bb6=bb4.add(bb5);

                    //通过金额计算(从上诉明细表1的辅料总成本金额加上明细表2的辅料总成本金额)和数量计算(从上诉明细表1的辅料总成本金额加上明细表2的出库数量)更新明细表2的辅料总成本金额和出库数量
                    sqlU=" update "+mxTable2+" set flzcbje='"+bb3.toString()+"',cksl='"+bb6.toString()+"' where mainid='"+bb3+"' and flbm='"+flbm+"'  ";
                }

                rs2.execute(sqlU);

            }

        } catch (Exception e) {
            tempMessage = ""+e;
            request.getRequestManager().setMessageid("流程提交失败");
            request.getRequestManager().setMessagecontent(tempMessage);
            return "0";
        }

        this.log.error("######################        调用调用辅料申请插入Action end   ################################################");
        /***interface action  stop *****/

        return "1";
    }

}
