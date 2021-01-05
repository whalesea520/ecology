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
import java.text.SimpleDateFormat;
import java.util.Date;

public class FkAction extends BaseBean implements Action {
    private Log log = LogFactory.getLog(FkAction.class.getName());

    public FkAction() {
    }

    public String execute(RequestInfo var1) {
        this.log.error("######################   开始调用付款控制Action     ###########################");
        RecordSet var2 = new RecordSet();
        RecordSet var3 = new RecordSet();
        String var4 = "";

        try {
            WorkflowComInfo var5 = new WorkflowComInfo();
            int var6 = Util.getIntValue(var1.getRequestid());
            int var7 = Util.getIntValue(var1.getWorkflowid());
            int var8 = Util.getIntValue(var5.getFormId("" + var7));
            String var9 = "formtable_main_" + -1 * var8;
            String var10 = var9 + "_dt1";
            String var11 = "";
            String var12 = "";
            String var13 = "";
            String var14 = "select id,bsqqgs,htbhnew from " + var9 + " where requestId=\'" + var6 + "\'  ";
            var3.execute(var14);
            if(var3.next()) {
                var11 = var3.getString("id");
                var13 = var3.getString("bsqqgs");
                var12 = var3.getString("htbhnew");
            }

            String var15 = " select*from " + var10 + " where mainid=\'" + var11 + "\' ";
            this.log.error("sqlMx: " + var15);
            var2.execute(var15);

            while(var2.next()) {
                String var16 = var2.getString("fylx1");
                String var17;
                String var18;
                String var19;
                String var22;
                BigDecimal var28;
                BigDecimal var29;
                BigDecimal var30;
                String var35;
                String var37;
                String var39;
                BigDecimal var41;
                BigDecimal var42;
                BigDecimal var43;
                BigDecimal var44;
                if("0".equals(var16)) {
                    var17 = var2.getString("dzwsje");
                    var18 = var2.getString("dzhsje");
                    var19 = "0";
                    var35 = "0";
                    var37 = "0";
                    var22 = var2.getString("fkqs1");
                    var39 = " select sybzjje,dzwsje,dzhsje from uf_HTK_dt8 where id=\'" + var22 + "\' ";
                    var3.execute(var39);
                    if(var3.next()) {
                        var19 = var3.getString("sybzjje");
                        var35 = var3.getString("dzwsje");
                        var37 = var3.getString("dzhsje");
                    }

                    var41 = new BigDecimal("0");
                    if(!"".equals(var19)) {
                        var41 = new BigDecimal(var19);
                    }

                    var42 = new BigDecimal("0");
                    if(!"".equals(var35)) {
                        var42 = new BigDecimal(var35);
                    }

                    var43 = new BigDecimal("0");
                    if(!"".equals(var37)) {
                        var43 = new BigDecimal(var37);
                    }

                    var44 = new BigDecimal("0");
                    if(!"".equals(var17)) {
                        var44 = new BigDecimal(var17);
                    }

                    var28 = new BigDecimal("0");
                    if(!"".equals(var18)) {
                        var28 = new BigDecimal(var18);
                    }

                    var29 = var44.add(var41);
                    var30 = var44.add(var42);
                    BigDecimal var31 = var28.add(var43);
                    if(var29.doubleValue()>=0){
                        if(var30.doubleValue()>=0){
                           if(var31.doubleValue()>=0){
                               String var32 = " update uf_HTK_dt8 set sybzjje=\'" + var29.toString() + "\',dzwsje=\'" + var30.toString() + "\',dzhsje=\'" + var31.toString() + "\' where id=\'" + var22 + "\' ";
                               var3.execute(var32);
                           }else{
                               var4 = "到账含税金额不能小于0";
                               var1.getRequestManager().setMessageid("流程提交失败");
                               var1.getRequestManager().setMessagecontent(var4);
                               return "0";
                           }
                        }else{
                            var4 = "到账未税金额不能小于0";
                            var1.getRequestManager().setMessageid("流程提交失败");
                            var1.getRequestManager().setMessagecontent(var4);
                            return "0";
                        }
                    }else{
                        var4 = "剩余保证金金额不能小于0";
                        var1.getRequestManager().setMessageid("流程提交失败");
                        var1.getRequestManager().setMessagecontent(var4);
                        return "0";
                    }
                } else if(!"1".equals(var16) && !"2".equals(var16)) {
                    if("3".equals(var16)) {
                        var17 = var2.getString("dzhsje");
                        var18 = "0";
                        var19 = "select lyydje from uf_htk where id=\'" + var12 + "\'";
                        var3.execute(var19);
                        if(var3.next()) {
                            var18 = var3.getString("lyydje");
                        }

                        BigDecimal var34 = new BigDecimal("0");
                        if(!"".equals(var17)) {
                            var34 = new BigDecimal(var17);
                        }

                        BigDecimal var36 = new BigDecimal("0");
                        if(!"".equals(var18)) {
                            var36 = new BigDecimal(var18);
                        }
                        BigDecimal var38 = var34.add(var36);
                        if(var38.doubleValue()>=0){
                            var39 = " update uf_htk set lyydje=\'" + var38.toString() + "\'  where id=\'" + var12 + "\' ";
                            var3.execute(var39);
                        }else{
                            var4 = "履约保证金不能小于0";
                            var1.getRequestManager().setMessageid("流程提交失败");
                            var1.getRequestManager().setMessagecontent(var4);
                            return "0";
                        }
                    } else if("4".equals(var16)) {
                        var17 = var2.getString("dzwsje");
                        var18 = var2.getString("dzhsje");
                        var19 = "0";
                        var35 = "0";
                        var37 = var2.getString("xzdfgk");
                        var22 = " select dzws,dzhs from uf_HTK_dt14 where id=\'" + var37 + "\' ";
                        var3.execute(var22);
                        if(var3.next()) {
                            var19 = var3.getString("dzws");
                            var35 = var3.getString("dzhs");
                        }

                        BigDecimal var40 = new BigDecimal("0");
                        if(!"".equals(var19)) {
                            var40 = new BigDecimal(var19);
                        }

                        var41 = new BigDecimal("0");
                        if(!"".equals(var35)) {
                            var41 = new BigDecimal(var35);
                        }

                        var42 = new BigDecimal("0");
                        if(!"".equals(var17)) {
                            var42 = new BigDecimal(var17);
                        }

                        var43 = new BigDecimal("0");
                        if(!"".equals(var18)) {
                            var43 = new BigDecimal(var18);
                        }

                        var44 = var42.add(var40);
                        var28 = var43.add(var41);
                        if(var44.doubleValue()>=0){
                            if(var28.doubleValue()>=0){
                                String var45 = " update uf_HTK_dt14 set dzws=\'" + var44.toString() + "\',dzhs=\'" + var28.toString() + "\' where id=\'" + var37 + "\' ";
                                var3.execute(var45);
                            }else{
                                var4 = "到账含税不能小于0";
                                var1.getRequestManager().setMessageid("流程提交失败");
                                var1.getRequestManager().setMessagecontent(var4);
                                return "0";
                            }
                        }else{
                            var4 = "到账未税不能小于0";
                            var1.getRequestManager().setMessageid("流程提交失败");
                            var1.getRequestManager().setMessagecontent(var4);
                            return "0";
                        }
                    }
                } else {
                    var17 = var2.getString("dzhsje");
                    this.log.error("实收金额: " + var17);
                    var18 = "0";
                    var19 = "select count(*) as ct from uf_sqscb where sqs=\'" + var13 + "\'";
                    this.log.error("sqlCt: " + var19);
                    var3.execute(var19);
                    if(var3.next()) {
                        var18 = var3.getString("ct");
                    }

                    SimpleDateFormat var20 = new SimpleDateFormat("yyyy-MM-dd");
                    Date var21 = new Date();
                    var22 = var20.format(var21);
                    SimpleDateFormat var23 = new SimpleDateFormat("HH:mm:ss");
                    String var24 = var23.format(var21);
                    String var25 = "";
                    if("0".equals(var18)) {
                        var25 = "insert into uf_sqscb (sqs,cbje,formmodeid,modedatacreater,modedatacreatertype,modedatacreatedate,modedatacreatetime) values (\'" + var13 + "\',\'" + var17 + "\',\'82\',\'1\',\'0\',\'" + var22 + "\',\'" + var24 + "\')";
                    } else {
                        String var26 = "0";
                        String var27 = "select cbje from uf_sqscb where sqs=\'" + var13 + "\'";
                        var3.execute(var27);
                        if(var3.next()) {
                            var26 = var3.getString("cbje");
                        }

                        var28 = new BigDecimal("0");
                        if(!"".equals(var17)) {
                            var28 = new BigDecimal(var17);
                        }

                        var29 = new BigDecimal("0");
                        if(!"".equals(var26)) {
                            var29 = new BigDecimal(var26);
                        }

                        var30 = var28.add(var29);
                        if(var30.doubleValue()>=0){
                            var25 = " update uf_sqscb set cbje=\'" + var30.toString() + "\'  where sqs=\'" + var13 + "\' ";
                        }else{
                            var4 = "被授权商的成本金额不能小于0";
                            var1.getRequestManager().setMessageid("流程提交失败");
                            var1.getRequestManager().setMessagecontent(var4);
                            return "0";
                        }
                    }

                    this.log.error("sqlU: " + var25);
                    var3.execute(var25);
                }
            }
        } catch (Exception var33) {
            var4 = "" + var33;
            var1.getRequestManager().setMessageid("流程提交失败");
            var1.getRequestManager().setMessagecontent(var4);
            return "0";
        }

        this.log.error("######################        调用付款控制Action end   ################################################");
        return "1";
    }
}
