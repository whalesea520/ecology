//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

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

public class QyjKzAction extends BaseBean implements Action {
    private Log log = LogFactory.getLog(QyjKzAction.class.getName());

    public QyjKzAction() {
    }

    public String execute(RequestInfo var1) {
        this.log.error("######################   开始调用权益金控制Action     ###########################");
        RecordSet var2 = new RecordSet();
        RecordSet var3 = new RecordSet();
        String var4 = "";

        try {
            WorkflowComInfo var53 = new WorkflowComInfo();
            int var6 = Util.getIntValue(var1.getRequestid());
            int var7 = Util.getIntValue(var1.getWorkflowid());
            int var8 = Util.getIntValue(var53.getFormId("" + var7));
            String var9 = "formtable_main_" + -1 * var8;
            this.writeLog("");
            String var10 = "";//成本合计
            String var11 = "";//被授权方
            String var12 = "";//权益金合计
            String var13 = "";//选择保底金期间
            String var14 = "";//合同编号new
            String var15 = "";
            String var16 = "";
            String var17 = "";//选择保底金期间
            MainTableInfo var18 = var1.getMainTableInfo();
            Property[] var19 = var18.getProperty();

            String var21;
            String var22;
            for(int var20 = 0; var20 < var19.length; ++var20) {
                var21 = var19[var20].getName();
                var22 = Util.null2String(var19[var20].getValue());
                if("cbhj".equalsIgnoreCase(var21)) {
                    var10 = var22;
                } else if("bsqf".equalsIgnoreCase(var21)) {
                    var11 = var22;
                } else if("qljhj".equalsIgnoreCase(var21)) {
                    var12 = var22;
                } else if("fktzcx".equalsIgnoreCase(var21)) {
                    var13 = var22;
                } else if("htbh1".equalsIgnoreCase(var21)) {
                    var14 = var22;
                } else if("fktzcx".equalsIgnoreCase(var21)) {
                    var17 = var22;
                }
            }

            this.log.error("fktzcx：" + var17);
            String var54 = "";
            //查询主表的ID和选择保底金期间
            var21 = "select id,fktzcx from " + var9 + " where requestId=\'" + var6 + "\'  ";
            var3.execute(var21);
            if(var3.next()) {
                var54 = var3.getString("id");
                var17 = var3.getString("fktzcx");
            }

            this.log.error("fktzcx2：" + var17);
            var22 = "";
            //查询uf_bsqssj(被授权商数据)表的kggx(客户关系)
            String var23 = "select kggx from uf_bsqssj where id=\'" + var11 + "\'";
            var2.execute(var23);
            if(var2.next()) {
                var22 = var2.getString("kggx");
            }

            if("1".equals(var22)) {
                String var24 = "";//是否计算权益金
                String var25 = "";//是否计算成本
                String var26 = "";
                //查询uf_HTK(合同库)表的是否计算权益金、是否计算成本、合同类型
                String var27 = "select sfjsqyj,sfjscb,htlx from uf_HTK where id=\'" + var14 + "\'";
                this.log.error("uf_HTK：" + var27);
                var2.execute(var27);
                if(var2.next()) {
                    var24 = var2.getString("sfjsqyj");
                    var25 = var2.getString("sfjscb");
                    var26 = var2.getString("htlx");
                }

                double var28;
                String var30;
                String var31;
                //计算成本
                if("0".equals(var25)) {
                    var28 = 0.0D;
                    if(!"".equals(var10)) {
                        var28 = Double.valueOf(var10).doubleValue();
                    }

                    this.log.error("dd1是：" + var28);
                    var30 = "0";
                    //查询uf_sqscb(授权商成本)的cbje(成本金额)
                    var31 = "select cbje from uf_sqscb where sqs=\'" + var11 + "\'";
                    var2.execute(var31);
                    if(var2.next()) {
                        var30 = var2.getString("cbje");
                    }

                    double var55 = 0.0D;
                    if(!"".equals(var30)) {
                        var55 = Double.valueOf(var30).doubleValue();
                    }

                    this.log.error("dd2是：" + var55);
                    double var56 = var28 - var55;
                    this.log.error("结果是：" + var56);
                    if(var56 > 0.0D) {
                        var4 = "成本合计超出，不能提交。";
                        var1.getRequestManager().setMessageid("流程提交失败");
                        var1.getRequestManager().setMessagecontent(var4);
                        return "0";
                    }

                    BigDecimal var57 = new BigDecimal("0");
                    if(!"".equals(Double.valueOf(var55))) {
                        var57 = new BigDecimal(var55);
                    }

                    BigDecimal var37 = new BigDecimal("0");
                    if(!"".equals(Double.valueOf(var28))) {
                        var37 = new BigDecimal(var28);
                    }

                    new BigDecimal("0");
                    BigDecimal var58 = var57.subtract(var37).setScale(2, 4);
                    String var39 = "update uf_sqscb set cbje=\'" + var58.toString() + "\' where sqs=\'" + var11 + "\' ";
                    this.log.error("外部成本：" + var39);
                    var2.execute(var39);
                }
                //计算权利金
                if("0".equals(var24)) {
                    var28 = 0.0D;
                    var30 = "0";
                    var31 = var9 + "_dt2";
                    //查询出明细表2的权利金的总和
                    String var561 = "select  SUM(qlj) as sm  from " + var31 + " where mainid=\'" + var54 + "\' ";
                    var2.execute(var561);
                    if(var2.next()) {
                        var30 = var2.getString("sm");
                    }

                    if(!"".equals(var30)) {
                        var28 = Double.valueOf(var30).doubleValue();
                    }
                    //更新主表权益金合计字段
                    String var33 = "update " + var9 + " set qljhj=\'" + var28 + "\' where id=\'" + var54 + "\' ";
                    var2.execute(var33);
                    String var571 = "0";
                    //查询uf_HTK_dt8(合同库明细表8)的剩余保证金金额
                    String var35 = "select sybzjje from uf_HTK_dt8 where id=\'" + var13 + "\'";
                    this.log.error("外部权益金：" + var35);
                    var2.execute(var35);
                    if(var2.next()) {
                        var571 = var2.getString("sybzjje");
                    }
                    this.log.error("var571：" + var571);
                    double var581 = 0.0D;
                    if(!"".equals(var571)) {
                        var581 = Double.valueOf(var571).doubleValue();
                    }

                    double var59 = var28 - var581;
                    this.log.error("结果是：" + var59);
                    boolean a = var59 > 0.0D;
                    this.log.error("a：" + a);
                    if(var59 > 0.0D) {
                        var4 = "权益金超出，不能提交。";
                        var1.getRequestManager().setMessageid("流程提交失败");
                        var1.getRequestManager().setMessagecontent(var4);
                        return "0";
                    }

                    this.log.error("结果是+++++++++++++++");
                    String var40 = "0";//剩余保证金金额
                    String var41 = "0";//累计防伪标权益金额
                    //查询htk_8(合同保底金查询)的剩余保证金金额、累计防伪标权益金额
                    String var42 = "select sybzjje,ljfwbqyje from htk_8 where id=\'" + var17 + "\'";
                    this.log.error("sqlZd：" + var42);
                    var2.execute(var42);
                    if(var2.next()) {
                        var40 = var2.getString("sybzjje");
                        var41 = var2.getString("ljfwbqyje");
                    }

                    BigDecimal var43 = new BigDecimal("0");
                    if(!"".equals(var40)) {
                        var43 = new BigDecimal(var40);
                    }

                    this.log.error("bb7：" + var43);
                    BigDecimal var44 = new BigDecimal("0");
                    if(!"".equals(var41)) {
                        var44 = new BigDecimal(var41);
                    }

                    this.log.error("bb10：" + var44);
                    BigDecimal var45 = new BigDecimal("0");
                    if(!"".equals(var12)) {
                        var45 = new BigDecimal(var12);
                    }

                    this.log.error("bb8：" + var45);
                    BigDecimal var46 = var45.add(var44);
                    double var47 = var46.doubleValue();
                    BigDecimal var49 = var43.subtract(var45);
                    double var50 = var49.doubleValue();
                    this.log.error("结果2是：" + var50);
                    if(var50 >= 0.0D) {
                        //更新uf_htk_dt8(合同库明细表8)的剩余保证金金额和累计防伪标权益金额
                        String var52 = "update uf_htk_dt8 set ljfwbqyje=\'" + var46.toString() + "\',sybzjje=\'" + var49.toString() + "\'  where id=\'" + var17 + "\' ";
                        this.log.error("外部sqlU3: " + var52);
                        var2.execute(var52);
                    }
                }
            }
        } catch (Exception var551) {
            var4 = "" + var551;
            var1.getRequestManager().setMessageid("流程提交失败");
            var1.getRequestManager().setMessagecontent(var4);
            return "0";
        }

        this.log.error("######################        调用权益金控制Action end   ################################################");
        return "1";
    }
}
