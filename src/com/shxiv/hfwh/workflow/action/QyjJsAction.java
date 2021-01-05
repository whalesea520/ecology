//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.shxiv.hfwh.workflow.action;

import com.alibaba.fastjson.JSONObject;
import com.shxiv.hfwh.workflow.dto.QyjDto;
import com.weaver.general.BaseBean;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;
import weaver.workflow.workflow.WorkflowComInfo;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class QyjJsAction extends BaseBean implements Action {
    private Log log = LogFactory.getLog(QyjJsAction.class.getName());

    public QyjJsAction() {
    }

    @SuppressWarnings("unchecked")
    public String execute(RequestInfo var1) {
        this.log.error("######################   开始调用权益金计算Action     ###########################");
        RecordSet var2 = new RecordSet();
        RecordSet var3 = new RecordSet();
        RecordSet var4 = new RecordSet();
        RecordSet var5 = new RecordSet();
        RecordSet var6 = new RecordSet();
        RecordSet var7 = new RecordSet();
        new RecordSet();
        String var8 = "";

        try {
            WorkflowComInfo var111 = new WorkflowComInfo();
            int var10 = Util.getIntValue(var1.getRequestid());
            int var11 = Util.getIntValue(var1.getWorkflowid());
            int var12 = Util.getIntValue(var111.getFormId("" + var11));
            String var13 = "formtable_main_" + -1 * var12;
            String var14 = "";
            String var15 = "";
            String var16 = "";
            String var17 = "";
            String var18 = "";
            String var19 = "";
            String var20 = "";
            String var21 = "select * from " + var13 + " where requestId=\'" + var10 + "\'  ";
            var3.execute(var21);
            if(var3.next()) {
                var14 = var3.getString("id");
                var15 = var3.getString("htbh1");
                var16 = var3.getString("sqrq");
                var17 = var3.getString("bsqf");
                var18 = var3.getString("ckzje");
                var19 = var3.getString("lhtje");
                var20 = var3.getString("fktzcx");
            }

            String var22 = "";
            String var23 = "select kggx from uf_bsqssj where id=\'" + var17 + "\'";
            this.log.error("外部sqlK: " + var23);
            var3.execute(var23);
            if(var3.next()) {
                var22 = var3.getString("kggx");
            }

            String var24 = var13 + "_dt1";//明细表1
            String var25 = var13 + "_dt2";//明细表2
            if("1".equals(var22)) {
                String var26 = "";
                String var27 = "";
                String var28 = "";
                String var29 = "";
                String var30 = "";
                String var31 = "select id,sfjsqyj,sfjscb,htlx,jsjgzl from uf_HTK where id=\'" + var15 + "\'";
                this.log.error("sqlT: " + var31);
                var2.execute(var31);
                if(var2.next()) {
                    var30 = var2.getString("id");
                    var26 = var2.getString("sfjsqyj");
                    var27 = var2.getString("sfjscb");
                    var28 = var2.getString("htlx");
                    var29 = var2.getString("jsjgzl");
                }

                this.log.error("htlx: " + var28);
                if("".equals(var28)) {
                    var8 = "未设置计算类型。";
                    var1.getRequestManager().setMessageid("流程提交失败");
                    var1.getRequestManager().setMessagecontent(var8);
                    return "0";
                }

                String var32 = "";
                new BigDecimal("0");
                String var34 = "0";
                String var35 = "select dzwsje from htk_8 where id=\'" + var20 + "\'";
                var5.execute(var35);
                if(var5.next()) {
                    var34 = var5.getString("dzwsje");
                }

                new BigDecimal("0");
                if(!"".equals(var34)) {
                    new BigDecimal(var34);
                }

                if("1".equals(var28)) {
                    String var37 = "";
                    String var38 = "";
                    String var39 = "";
                    String var40 = "";
                    String var41 = "";
                    String var42 = "";
                    ArrayList var43 = new ArrayList();
                    String var44 = "select * from  " + var24 + "  where mainid=\'" + var14 + "\' ";
                    var4.execute(var44);
                    label883:
                    while(true) {
                        if(var4.next()) {
                            if("0".equals(var29)) {
                                var38 = var4.getString("pfj");
                            } else if("1".equals(var29)) {
                                var38 = var4.getString("lsj");
                            } else if("2".equals(var29)) {
                                var38 = var4.getString("ccj");
                            }

                            var37 = var4.getString("lysl");
                            var39 = var4.getString("hfkh");
                            var40 = var4.getString("xl");
                            var41 = var4.getString("id");
                            BigDecimal var1231 = new BigDecimal("0");
                            if(!"".equals(var38)) {
                                var1231 = new BigDecimal(var38);
                            }

                            BigDecimal var1241 = new BigDecimal("0");
                            if(!"".equals(var37)) {
                                var1241 = new BigDecimal(var37);
                            }

                            BigDecimal var125 = var1231.multiply(var1241);
                            double var48 = var125.doubleValue();
                            BigDecimal var50 = var125;
                            String var51;
                            String var52;
                            String var53;
                            String var54;
                            String var55;
                            String var56;
                            String var57;
                            BigDecimal var58;
                            BigDecimal var59;
                            BigDecimal var60;
                            double var61;
                            double var63;
                            BigDecimal var65;
                            String var66;
                            String var68;
                            String var69;
                            String var70;
                            String var71;
                            String var72;
                            String var120;
                            String var122;
                            String var123;
                            String var124;
                            String var139;
                            BigDecimal var142;
                            QyjDto var145;
                            BigDecimal var151;
                            BigDecimal var153;
                            QyjDto var155;
                            QyjDto var135;
                            QyjDto var62;
                            BigDecimal var166;
                            BigDecimal var1281;
                            BigDecimal var130;
                            QyjDto var188;
                            if(!"".equals(var42)) {
                                int var127;
                                BigDecimal var129;
                                BigDecimal var1321;
                                if("3".equals(var42)) {
                                    var51 = "0";
                                    var52 = "";
                                    var53 = "";
                                    var54 = "";
                                    var55 = "";
                                    var56 = "";
                                    var57 = "select id,qjjsy,qljl,ksje,jsje from uf_HTK_dt3 where mainid=\'" + var30 + "\' and qjjsy!=\'0\' order by  ksje ";
                                    this.log.error("sqlT3: " + var57);
                                    var5.execute(var57);

                                    while(true) {
                                        if(!var5.next()) {
                                            continue label883;
                                        }

                                        var55 = var5.getString("qljl");
                                        var53 = var5.getString("ksje");
                                        var54 = var5.getString("jsje");
                                        var56 = var5.getString("id");
                                        var52 = var5.getString("qjjsy");
                                        if("".equals(var55) && "0".equals(var51)) {
                                            this.log.error("权益金错误，没找到比例。");
                                            continue label883;
                                        }

                                        var58 = new BigDecimal("0");
                                        if(!"".equals(var55)) {
                                            var58 = new BigDecimal(var55);
                                        }

                                        var59 = new BigDecimal("0");
                                        if(!"".equals(var52)) {
                                            var59 = new BigDecimal(var52);
                                        }

                                        var60 = var59.subtract(var50);
                                        var61 = var60.doubleValue();
                                        var63 = 0.0D;
                                        if(!"".equals(var52)) {
                                            var63 = Double.parseDouble(var52);
                                        }

                                        if(var63 >= 9.99999999E8D) {
                                            var65 = var50.multiply(var58);
                                            var66 = "0";
                                            var139 = "0";
                                            var68 = "0";

                                            for(int var131 = 0; var131 < var43.size(); ++var131) {
                                                if("3".equals(((QyjDto)var43.get(var131)).getMxb()) && var56.equals(((QyjDto)var43.get(var131)).getQtd()) && var14.equals(((QyjDto)var43.get(var131)).getMainId())) {
                                                    var139 = ((QyjDto)var43.get(var131)).getXsje();
                                                    var68 = ((QyjDto)var43.get(var131)).getQlj();
                                                    var1321 = new BigDecimal("0");
                                                    if(!"".equals(var139)) {
                                                        var1321 = new BigDecimal(var139);
                                                    }

                                                    var1321 = var1321.add(var125);
                                                    var129 = new BigDecimal("0");
                                                    if(!"".equals(var68)) {
                                                        var129 = new BigDecimal(var68);
                                                    }

                                                    var129 = var129.add(var65);
                                                    var62 = (QyjDto)var43.get(var131);
                                                    var62.setXsje(var1321.toString());
                                                    var62.setQlj(var129.toString());
                                                    var43.set(var131, var62);
                                                    var66 = "1";
                                                }
                                            }

                                            if("0".equals(var66)) {
                                                QyjDto var133 = new QyjDto();
                                                var133.setMainId(var14);
                                                var133.setXsje(var50.toString());
                                                var133.setQljbl(var55);
                                                var133.setQlj(var65.toString());
                                                var133.setQljksqj(var53);
                                                var133.setQljjsqj(var54);
                                                var133.setPl("");
                                                var133.setQtd(var56);
                                                var133.setMxb("3");
                                                var133.setKsrq("");
                                                var133.setJsrq("");
                                                var43.add(var133);
                                            }
                                            continue label883;
                                        }

                                        if(var61 > 0.0D) {
                                            var65 = var50.multiply(var58);
                                            var66 = "update  uf_HTK_dt3 set qjjsy=\'" + var60.toString() + "\' where id=\'" + var56 + "\' ";
                                            var6.execute(var66);
                                            var139 = "0";
                                            var68 = "0";
                                            var69 = "0";

                                            for(var127 = 0; var127 < var43.size(); ++var127) {
                                                if("3".equals(((QyjDto)var43.get(var127)).getMxb()) && var56.equals(((QyjDto)var43.get(var127)).getQtd()) && var14.equals(((QyjDto)var43.get(var127)).getMainId())) {
                                                    var68 = ((QyjDto)var43.get(var127)).getXsje();
                                                    var69 = ((QyjDto)var43.get(var127)).getQlj();
                                                    var129 = new BigDecimal("0");
                                                    if(!"".equals(var68)) {
                                                        var129 = new BigDecimal(var68);
                                                    }

                                                    var129 = var129.add(var125);
                                                    var1281 = new BigDecimal("0");
                                                    if(!"".equals(var69)) {
                                                        var1281 = new BigDecimal(var69);
                                                    }

                                                    var1281 = var1281.add(var65);
                                                    var135 = (QyjDto)var43.get(var127);
                                                    var135.setXsje(var129.toString());
                                                    var135.setQlj(var1281.toString());
                                                    var43.set(var127, var135);
                                                    var139 = "1";
                                                }
                                            }

                                            if("0".equals(var139)) {
                                                var145 = new QyjDto();
                                                var145.setMainId(var14);
                                                var145.setXsje(var50.toString());
                                                var145.setQljbl(var55);
                                                var145.setQlj(var65.toString());
                                                var145.setQljksqj(var53);
                                                var145.setQljjsqj(var54);
                                                var145.setPl("");
                                                var145.setQtd(var56);
                                                var145.setMxb("3");
                                                var145.setKsrq("");
                                                var145.setJsrq("");
                                                var43.add(var145);
                                            }
                                            continue label883;
                                        }

                                        var50 = var50.subtract(var59);
                                        var65 = var59.multiply(var58);
                                        var66 = "update  uf_HTK_dt3 set qjjsy=\'0\' where id=\'" + var56 + "\' ";
                                        var6.execute(var66);
                                        var139 = "0";
                                        var68 = "0";
                                        var69 = "0";

                                        for(var127 = 0; var127 < var43.size(); ++var127) {
                                            if("3".equals(((QyjDto)var43.get(var127)).getMxb()) && var56.equals(((QyjDto)var43.get(var127)).getQtd()) && var14.equals(((QyjDto)var43.get(var127)).getMainId())) {
                                                var68 = ((QyjDto)var43.get(var127)).getXsje();
                                                var69 = ((QyjDto)var43.get(var127)).getQlj();
                                                var129 = new BigDecimal("0");
                                                if(!"".equals(var68)) {
                                                    var129 = new BigDecimal(var68);
                                                }

                                                var129 = var129.add(var125);
                                                var1281 = new BigDecimal("0");
                                                if(!"".equals(var69)) {
                                                    var1281 = new BigDecimal(var69);
                                                }

                                                var1281 = var1281.add(var65);
                                                var135 = (QyjDto)var43.get(var127);
                                                var135.setXsje(var129.toString());
                                                var135.setQlj(var1281.toString());
                                                var43.set(var127, var135);
                                                var139 = "1";
                                            }
                                        }

                                        if("0".equals(var139)) {
                                            var145 = new QyjDto();
                                            var145.setMainId(var14);
                                            var145.setXsje(var50.toString());
                                            var145.setQljbl(var55);
                                            var145.setQlj(var65.toString());
                                            var145.setQljksqj(var53);
                                            var145.setQljjsqj(var54);
                                            var145.setPl("");
                                            var145.setQtd(var56);
                                            var145.setMxb("3");
                                            var145.setKsrq("");
                                            var145.setJsrq("");
                                            var43.add(var145);
                                        }
                                    }
                                }

                                if("4".equals(var42)) {
                                    var51 = "";
                                    var52 = "";
                                    var53 = "select id,qljbl,ksrq,jsrq from uf_HTK_dt4 where mainid=\'" + var30 + "\' and \'" + var16 + "\' between ksrq and jsrq ";
                                    this.log.error("sqlT4: " + var53);
                                    var5.execute(var53);
                                    if(var5.next()) {
                                        var51 = var5.getString("qljbl");
                                        var52 = var5.getString("id");
                                    }

                                    if(!"".equals(var51)) {
                                        var1321 = new BigDecimal(var51);
                                        var130 = var1321.multiply(var125);
                                        this.log.error("bb410: " + var130);

                                        for(int var143 = 0; var143 < var43.size(); ++var143) {
                                            if("4".equals(((QyjDto)var43.get(var143)).getMxb()) && var52.equals(((QyjDto)var43.get(var143)).getQtd()) && var14.equals(((QyjDto)var43.get(var143)).getMainId())) {
                                                var57 = ((QyjDto)var43.get(var143)).getXsje();
                                                var120 = ((QyjDto)var43.get(var143)).getQlj();
                                                this.log.error("qlj: " + var120);
                                                var59 = new BigDecimal("0");
                                                if(!"".equals(var57)) {
                                                    var59 = new BigDecimal(var57);
                                                }

                                                var59 = var59.add(var125);
                                                var60 = new BigDecimal("0");
                                                if(!"".equals(var120)) {
                                                    var60 = new BigDecimal(var120);
                                                }

                                                var60 = var60.add(var130);
                                                this.log.error("bb102: " + var60.toString());
                                                QyjDto var140 = (QyjDto)var43.get(var143);
                                                var140.setXsje(var59.toString());
                                                var140.setQlj(var60.toString());
                                                var43.set(var143, var140);
                                            }
                                        }
                                    }
                                    continue;
                                }

                                BigDecimal var1351;
                                if("9".equals(var42)) {
                                    var51 = "";
                                    var52 = "";
                                    var53 = "";
                                    var54 = "select id,pl,qyjbl from uf_HTK_dt9 where pl=(select xl from uf_spsslc where id=\'" + var39 + "\') and mainid=\'" + var30 + "\' ";
                                    var5.execute(var54);
                                    if(var5.next()) {
                                        var51 = var5.getString("qyjbl");
                                        var53 = var5.getString("id");
                                    }

                                    var130 = new BigDecimal(var51);
                                    var1351 = var130.multiply(var125);
                                    this.log.error("bb910: " + var1351);
                                    int var137 = 0;

                                    while(true) {
                                        if(var137 >= var43.size()) {
                                            continue label883;
                                        }

                                        if("9".equals(((QyjDto)var43.get(var137)).getMxb()) && var53.equals(((QyjDto)var43.get(var137)).getQtd()) && var14.equals(((QyjDto)var43.get(var137)).getMainId())) {
                                            var120 = ((QyjDto)var43.get(var137)).getXsje();
                                            var122 = ((QyjDto)var43.get(var137)).getQlj();
                                            this.log.error("qlj: " + var122);
                                            var60 = new BigDecimal("0");
                                            if(!"".equals(var120)) {
                                                var60 = new BigDecimal(var120);
                                            }

                                            var60 = var60.add(var125);
                                            var1321 = new BigDecimal("0");
                                            if(!"".equals(var122)) {
                                                var1321 = new BigDecimal(var122);
                                            }

                                            var1321 = var1321.add(var1351);
                                            this.log.error("bb102: " + var1321.toString());
                                            QyjDto var141 = (QyjDto)var43.get(var137);
                                            var141.setXsje(var60.toString());
                                            var141.setQlj(var1321.toString());
                                            var43.set(var137, var141);
                                        }

                                        ++var137;
                                    }
                                }

                                BigDecimal var134;
                                if("10".equals(var42)) {
                                    var51 = "";
                                    var52 = "";
                                    var53 = "";
                                    var54 = "";
                                    var55 = "";
                                    var56 = "select id,qyjbl from uf_HTK_dt10 where pl=(select xl from uf_spsslc where id=\'" + var39 + "\') and \'" + var16 + "\' between ksrq and jsrq and mainid=\'" + var30 + "\' ";
                                    var5.execute(var56);
                                    if(var5.next()) {
                                        var51 = var5.getString("qyjbl");
                                        var53 = var5.getString("id");
                                    }

                                    BigDecimal var1391 = new BigDecimal(var51);
                                    var58 = var1391.multiply(var125);
                                    this.log.error("bb1010: " + var58);
                                    int var138 = 0;

                                    while(true) {
                                        if(var138 >= var43.size()) {
                                            continue label883;
                                        }

                                        if("10".equals(((QyjDto)var43.get(var138)).getMxb()) && var53.equals(((QyjDto)var43.get(var138)).getQtd()) && var14.equals(((QyjDto)var43.get(var138)).getMainId())) {
                                            var123 = ((QyjDto)var43.get(var138)).getXsje();
                                            var124 = ((QyjDto)var43.get(var138)).getQlj();
                                            this.log.error("qlj: " + var124);
                                            var1351 = new BigDecimal("0");
                                            if(!"".equals(var123)) {
                                                var1351 = new BigDecimal(var123);
                                            }

                                            var1351 = var1351.add(var125);
                                            var134 = new BigDecimal("0");
                                            if(!"".equals(var124)) {
                                                var134 = new BigDecimal(var124);
                                            }

                                            var134 = var134.add(var58);
                                            this.log.error("bb102: " + var134.toString());
                                            QyjDto var154 = (QyjDto)var43.get(var138);
                                            var154.setXsje(var1351.toString());
                                            var154.setQlj(var134.toString());
                                            var43.set(var138, var154);
                                        }

                                        ++var138;
                                    }
                                }

                                double var136;
                                BigDecimal var1421;
                                int var144;
                                QyjDto var1451;
                                QyjDto var146;
                                if("11".equals(var42)) {
                                    var51 = "0";
                                    var52 = "";
                                    var53 = "";
                                    var54 = "";
                                    var55 = "";
                                    var56 = "";
                                    var57 = "";
                                    var120 = "select id,qjsyje,ksje,jsje,qyjbl,pl from uf_HTK_dt11 where pl=(select xl from uf_spsslc where id=\'" + var39 + "\') and mainid=\'" + var30 + "\' and qjsyje!=\'0\' order by  ksje ";
                                    this.log.error("sqlT11: " + var120);
                                    var5.execute(var120);

                                    while(true) {
                                        if(!var5.next()) {
                                            continue label883;
                                        }

                                        var52 = var5.getString("qyjbl");
                                        var53 = var5.getString("qjsyje");
                                        var54 = var5.getString("ksje");
                                        var55 = var5.getString("jsje");
                                        var56 = var5.getString("id");
                                        var57 = var5.getString("pl");
                                        if("".equals(var52) && "0".equals(var51)) {
                                            this.log.error("权益金11错误，没找到比例。");
                                            continue label883;
                                        }

                                        var59 = new BigDecimal("0");
                                        if(!"".equals(var52)) {
                                            var59 = new BigDecimal(var52);
                                        }

                                        var60 = new BigDecimal("0");
                                        if(!"".equals(var53)) {
                                            var60 = new BigDecimal(var53);
                                        }

                                        var1321 = var60.subtract(var50);
                                        double var156 = var1321.doubleValue();
                                        var136 = 0.0D;
                                        if(!"".equals(var53)) {
                                            var136 = Double.parseDouble(var53);
                                        }

                                        if(var136 >= 9.99999999E8D) {
                                            var51 = "3";
                                            var166 = var50.multiply(var59);
                                            var139 = "0";
                                            var68 = "0";
                                            var69 = "0";

                                            for(var127 = 0; var127 < var43.size(); ++var127) {
                                                if("11".equals(((QyjDto)var43.get(var127)).getMxb()) && var56.equals(((QyjDto)var43.get(var127)).getQtd()) && var14.equals(((QyjDto)var43.get(var127)).getMainId())) {
                                                    var68 = ((QyjDto)var43.get(var127)).getXsje();
                                                    var69 = ((QyjDto)var43.get(var127)).getQlj();
                                                    var129 = new BigDecimal("0");
                                                    if(!"".equals(var68)) {
                                                        var129 = new BigDecimal(var68);
                                                    }

                                                    var129 = var129.add(var125);
                                                    var1281 = new BigDecimal("0");
                                                    if(!"".equals(var69)) {
                                                        var1281 = new BigDecimal(var69);
                                                    }

                                                    var1281 = var1281.add(var166);
                                                    var135 = (QyjDto)var43.get(var127);
                                                    var135.setXsje(var129.toString());
                                                    var135.setQlj(var1281.toString());
                                                    var43.set(var127, var135);
                                                    var139 = "1";
                                                }
                                            }

                                            if("0".equals(var139)) {
                                                var145 = new QyjDto();
                                                var145.setMainId(var14);
                                                var145.setXsje(var50.toString());
                                                var145.setQljbl(var52);
                                                var145.setQlj(var166.toString());
                                                var145.setQljksqj(var54);
                                                var145.setQljjsqj(var55);
                                                var145.setPl(var57);
                                                var145.setQtd(var56);
                                                var145.setMxb("11");
                                                var145.setKsrq("");
                                                var145.setJsrq("");
                                                var43.add(var145);
                                            }
                                            continue label883;
                                        }

                                        if(var156 > 0.0D) {
                                            var51 = "3";
                                            var166 = var50.multiply(var59);
                                            var139 = "update  uf_HTK_dt11 set qjsyje=\'" + var1321.toString() + "\' where id=\'" + var56 + "\' ";
                                            var6.execute(var139);
                                            var68 = "0";
                                            var69 = "0";
                                            var70 = "0";

                                            for(var144 = 0; var144 < var43.size(); ++var144) {
                                                if("11".equals(((QyjDto)var43.get(var144)).getMxb()) && var56.equals(((QyjDto)var43.get(var144)).getQtd()) && var14.equals(((QyjDto)var43.get(var144)).getMainId())) {
                                                    var69 = ((QyjDto)var43.get(var144)).getXsje();
                                                    var70 = ((QyjDto)var43.get(var144)).getQlj();
                                                    var1281 = new BigDecimal("0");
                                                    if(!"".equals(var69)) {
                                                        var1281 = new BigDecimal(var69);
                                                    }

                                                    var1281 = var1281.add(var125);
                                                    var1421 = new BigDecimal("0");
                                                    if(!"".equals(var70)) {
                                                        var1421 = new BigDecimal(var70);
                                                    }

                                                    var1421 = var1421.add(var166);
                                                    var146 = (QyjDto)var43.get(var144);
                                                    var146.setXsje(var1281.toString());
                                                    var146.setQlj(var1421.toString());
                                                    var43.set(var144, var146);
                                                    var68 = "1";
                                                }
                                            }

                                            if("0".equals(var68)) {
                                                var1451 = new QyjDto();
                                                var1451.setMainId(var14);
                                                var1451.setXsje(var50.toString());
                                                var1451.setQljbl(var52);
                                                var1451.setQlj(var166.toString());
                                                var1451.setQljksqj(var54);
                                                var1451.setQljjsqj(var55);
                                                var1451.setPl(var57);
                                                var1451.setQtd(var56);
                                                var1451.setMxb("11");
                                                var1451.setKsrq("");
                                                var1451.setJsrq("");
                                                var43.add(var1451);
                                            }
                                            continue label883;
                                        }

                                        var51 = "2";
                                        var50 = var50.subtract(var60);
                                        var166 = var60.multiply(var59);
                                        var139 = "update  uf_HTK_dt11 set qjsyje=\'0\' where id=\'" + var56 + "\' ";
                                        var6.execute(var139);
                                        var68 = "0";
                                        var69 = "0";
                                        var70 = "0";

                                        for(var144 = 0; var144 < var43.size(); ++var144) {
                                            if("11".equals(((QyjDto)var43.get(var144)).getMxb()) && var56.equals(((QyjDto)var43.get(var144)).getQtd()) && var14.equals(((QyjDto)var43.get(var144)).getMainId())) {
                                                var69 = ((QyjDto)var43.get(var144)).getXsje();
                                                var70 = ((QyjDto)var43.get(var144)).getQlj();
                                                var1281 = new BigDecimal("0");
                                                if(!"".equals(var69)) {
                                                    var1281 = new BigDecimal(var69);
                                                }

                                                var1281 = var1281.add(var125);
                                                var1421 = new BigDecimal("0");
                                                if(!"".equals(var70)) {
                                                    var1421 = new BigDecimal(var70);
                                                }

                                                var1421 = var1421.add(var166);
                                                var146 = (QyjDto)var43.get(var144);
                                                var146.setXsje(var1281.toString());
                                                var146.setQlj(var1421.toString());
                                                var43.set(var144, var146);
                                                var68 = "1";
                                            }
                                        }

                                        if("0".equals(var68)) {
                                            var1451 = new QyjDto();
                                            var1451.setMainId(var14);
                                            var1451.setXsje(var50.toString());
                                            var1451.setQljbl(var52);
                                            var1451.setQlj(var166.toString());
                                            var1451.setQljksqj(var54);
                                            var1451.setQljjsqj(var55);
                                            var1451.setPl(var57);
                                            var1451.setQtd(var56);
                                            var1451.setMxb("11");
                                            var1451.setKsrq("");
                                            var1451.setJsrq("");
                                            var43.add(var1451);
                                        }
                                    }
                                }

                                QyjDto var150;
                                double var1511;
                                int var1531;
                                if("12".equals(var42)) {
                                    var51 = "0";
                                    var52 = "";
                                    var53 = "";
                                    var54 = "";
                                    var55 = "";
                                    var56 = "";
                                    var57 = "";
                                    var120 = "";
                                    var122 = "select id,qjsyje,ksje,jsje,qyjbl,ksqr,jsrq from uf_HTK_dt12 where  (\'" + var16 + "\' between ksqr and jsrq) and mainid=\'" + var30 + "\' and qjsyje!=\'0\' order by  ksje ";
                                    var5.execute(var122);

                                    while(true) {
                                        if(!var5.next()) {
                                            continue label883;
                                        }

                                        var52 = var5.getString("qyjbl");
                                        var53 = var5.getString("qjsyje");
                                        var54 = var5.getString("ksje");
                                        var55 = var5.getString("jsje");
                                        var56 = var5.getString("id");
                                        var57 = var5.getString("ksqr");
                                        var120 = var5.getString("jsrq");
                                        if("".equals(var52) && "0".equals(var51)) {
                                            var51 = "1";
                                            continue label883;
                                        }

                                        var60 = new BigDecimal("0");
                                        if(!"".equals(var52)) {
                                            var60 = new BigDecimal(var52);
                                        }

                                        var1321 = new BigDecimal("0");
                                        if(!"".equals(var53)) {
                                            var1321 = new BigDecimal(var53);
                                        }

                                        var1351 = var1321.subtract(var50);
                                        var63 = var1351.doubleValue();
                                        var1511 = 0.0D;
                                        if(!"".equals(var53)) {
                                            var1511 = Double.parseDouble(var53);
                                        }

                                        BigDecimal var158;
                                        if(var1511 >= 9.99999999E8D) {
                                            var51 = "3";
                                            var158 = var50.multiply(var60);
                                            var68 = "0";
                                            var69 = "0";
                                            var70 = "0";

                                            for(var144 = 0; var144 < var43.size(); ++var144) {
                                                if("12".equals(((QyjDto)var43.get(var144)).getMxb()) && var56.equals(((QyjDto)var43.get(var144)).getQtd()) && var14.equals(((QyjDto)var43.get(var144)).getMainId())) {
                                                    var69 = ((QyjDto)var43.get(var144)).getXsje();
                                                    var70 = ((QyjDto)var43.get(var144)).getQlj();
                                                    var1281 = new BigDecimal("0");
                                                    if(!"".equals(var69)) {
                                                        var1281 = new BigDecimal(var69);
                                                    }

                                                    var1281 = var1281.add(var125);
                                                    var1421 = new BigDecimal("0");
                                                    if(!"".equals(var70)) {
                                                        var1421 = new BigDecimal(var70);
                                                    }

                                                    var1421 = var1421.add(var158);
                                                    var146 = (QyjDto)var43.get(var144);
                                                    var146.setXsje(var1281.toString());
                                                    var146.setQlj(var1421.toString());
                                                    var43.set(var144, var146);
                                                    var68 = "1";
                                                }
                                            }

                                            if("0".equals(var68)) {
                                                var1451 = new QyjDto();
                                                var1451.setMainId(var14);
                                                var1451.setXsje(var50.toString());
                                                var1451.setQljbl(var52);
                                                var1451.setQlj(var158.toString());
                                                var1451.setQljksqj(var54);
                                                var1451.setQljjsqj(var55);
                                                var1451.setPl("");
                                                var1451.setQtd(var56);
                                                var1451.setMxb("12");
                                                var1451.setKsrq(var57);
                                                var1451.setJsrq(var120);
                                                var43.add(var1451);
                                            }
                                            continue label883;
                                        }

                                        if(var63 > 0.0D) {
                                            var51 = "3";
                                            var158 = var50.multiply(var60);
                                            var68 = "update  uf_HTK_dt12 set qjsyje=\'" + var1351.toString() + "\' where id=\'" + var56 + "\' ";
                                            var6.execute(var68);
                                            var69 = "0";
                                            var70 = "0";
                                            var71 = "0";

                                            for(var1531 = 0; var1531 < var43.size(); ++var1531) {
                                                if("12".equals(((QyjDto)var43.get(var1531)).getMxb()) && var56.equals(((QyjDto)var43.get(var1531)).getQtd()) && var14.equals(((QyjDto)var43.get(var1531)).getMainId())) {
                                                    var70 = ((QyjDto)var43.get(var1531)).getXsje();
                                                    var71 = ((QyjDto)var43.get(var1531)).getQlj();
                                                    var1421 = new BigDecimal("0");
                                                    if(!"".equals(var70)) {
                                                        var1421 = new BigDecimal(var70);
                                                    }

                                                    var1421 = var1421.add(var125);
                                                    var153 = new BigDecimal("0");
                                                    if(!"".equals(var71)) {
                                                        var153 = new BigDecimal(var71);
                                                    }

                                                    var153 = var153.add(var158);
                                                    var150 = (QyjDto)var43.get(var1531);
                                                    var150.setXsje(var1421.toString());
                                                    var150.setQlj(var153.toString());
                                                    var43.set(var1531, var150);
                                                    var69 = "1";
                                                }
                                            }

                                            if("0".equals(var69)) {
                                                var62 = new QyjDto();
                                                var62.setMainId(var14);
                                                var62.setXsje(var50.toString());
                                                var62.setQljbl(var52);
                                                var62.setQlj(var158.toString());
                                                var62.setQljksqj(var54);
                                                var62.setQljjsqj(var55);
                                                var62.setPl("");
                                                var62.setQtd(var56);
                                                var62.setMxb("12");
                                                var62.setKsrq(var57);
                                                var62.setJsrq(var120);
                                                var43.add(var62);
                                            }
                                            continue label883;
                                        }

                                        var51 = "2";
                                        var50 = var50.subtract(var1321);
                                        var158 = var1321.multiply(var60);
                                        var68 = "update  uf_HTK_dt12 set qjsyje=\'0\' where id=\'" + var56 + "\' ";
                                        var6.execute(var68);
                                        var69 = "0";
                                        var70 = "0";
                                        var71 = "0";

                                        for(var1531 = 0; var1531 < var43.size(); ++var1531) {
                                            if("12".equals(((QyjDto)var43.get(var1531)).getMxb()) && var56.equals(((QyjDto)var43.get(var1531)).getQtd()) && var14.equals(((QyjDto)var43.get(var1531)).getMainId())) {
                                                var70 = ((QyjDto)var43.get(var1531)).getXsje();
                                                var71 = ((QyjDto)var43.get(var1531)).getQlj();
                                                var1421 = new BigDecimal("0");
                                                if(!"".equals(var70)) {
                                                    var1421 = new BigDecimal(var70);
                                                }

                                                var1421 = var1421.add(var125);
                                                var153 = new BigDecimal("0");
                                                if(!"".equals(var71)) {
                                                    var153 = new BigDecimal(var71);
                                                }

                                                var153 = var153.add(var158);
                                                var150 = (QyjDto)var43.get(var1531);
                                                var150.setXsje(var1421.toString());
                                                var150.setQlj(var153.toString());
                                                var43.set(var1531, var150);
                                                var69 = "1";
                                            }
                                        }

                                        if("0".equals(var69)) {
                                            var62 = new QyjDto();
                                            var62.setMainId(var14);
                                            var62.setXsje(var50.toString());
                                            var62.setQljbl(var52);
                                            var62.setQlj(var158.toString());
                                            var62.setQljksqj(var54);
                                            var62.setQljjsqj(var55);
                                            var62.setPl("");
                                            var62.setQtd(var56);
                                            var62.setMxb("12");
                                            var62.setKsrq(var57);
                                            var62.setJsrq(var120);
                                            var43.add(var62);
                                        }
                                    }
                                }

                                if(!"13".equals(var42)) {
                                    continue;
                                }

                                var51 = "0";
                                var52 = "";
                                var53 = "";
                                var54 = "";
                                var55 = "";
                                var56 = "";
                                var57 = "";
                                var120 = "";
                                var122 = "";
                                var123 = "select ksje,jsje,qyjbl,qjsyje,pl,ksqr,jsrq from uf_HTK_dt13 where  (\'" + var16 + "\' between ksqr and jsrq) and mainid=\'" + var30 + "\' and pl=(select xl from uf_spsslc where id=\'" + var39 + "\')  and qjsyje!=\'0\' order by  ksje";
                                this.log.error("sqlT13: " + var123);
                                var5.execute(var123);

                                while(var5.next()) {
                                    var52 = var5.getString("qyjbl");
                                    var53 = var5.getString("qjsyje");
                                    var54 = var5.getString("ksje");
                                    var55 = var5.getString("jsje");
                                    var56 = var5.getString("id");
                                    var57 = var5.getString("pl");
                                    var120 = var5.getString("ksqr");
                                    var122 = var5.getString("jsrq");
                                    if("".equals(var52) && "0".equals(var51)) {
                                        var51 = "1";
                                        break;
                                    }

                                    var1321 = new BigDecimal("0");
                                    if(!"".equals(var52)) {
                                        var1321 = new BigDecimal(var52);
                                    }

                                    var1351 = new BigDecimal("0");
                                    if(!"".equals(var53)) {
                                        var1351 = new BigDecimal(var53);
                                    }

                                    var134 = var1351.subtract(var50);
                                    var136 = var134.doubleValue();
                                    var1511 = 0.0D;
                                    if(!"".equals(var53)) {
                                        var1511 = Double.parseDouble(var53);
                                    }

                                    if(var1511 >= 9.99999999E8D) {
                                        var51 = "3";
                                        var142 = var50.multiply(var1321);
                                        var69 = "0";
                                        var70 = "0";
                                        var71 = "0";

                                        for(var1531 = 0; var1531 < var43.size(); ++var1531) {
                                            if("13".equals(((QyjDto)var43.get(var1531)).getMxb()) && var56.equals(((QyjDto)var43.get(var1531)).getQtd()) && var14.equals(((QyjDto)var43.get(var1531)).getMainId())) {
                                                var70 = ((QyjDto)var43.get(var1531)).getXsje();
                                                var71 = ((QyjDto)var43.get(var1531)).getQlj();
                                                var1421 = new BigDecimal("0");
                                                if(!"".equals(var70)) {
                                                    var1421 = new BigDecimal(var70);
                                                }

                                                var1421 = var1421.add(var125);
                                                var153 = new BigDecimal("0");
                                                if(!"".equals(var71)) {
                                                    var153 = new BigDecimal(var71);
                                                }

                                                var153 = var153.add(var142);
                                                var150 = (QyjDto)var43.get(var1531);
                                                var150.setXsje(var1421.toString());
                                                var150.setQlj(var153.toString());
                                                var43.set(var1531, var150);
                                                var69 = "1";
                                            }
                                        }

                                        if("0".equals(var69)) {
                                            var62 = new QyjDto();
                                            var62.setMainId(var14);
                                            var62.setXsje(var50.toString());
                                            var62.setQljbl(var52);
                                            var62.setQlj(var142.toString());
                                            var62.setQljksqj(var54);
                                            var62.setQljjsqj(var55);
                                            var62.setPl(var57);
                                            var62.setQtd(var56);
                                            var62.setMxb("13");
                                            var62.setKsrq(var120);
                                            var62.setJsrq(var122);
                                            var43.add(var62);
                                        }
                                        break;
                                    }

                                    int var1551;
                                    if(var136 > 0.0D) {
                                        var51 = "3";
                                        var142 = var50.multiply(var1321);
                                        var69 = "update  uf_HTK_dt13 set qjsyje=\'" + var134.toString() + "\' where id=\'" + var56 + "\' ";
                                        var6.execute(var69);
                                        var70 = "0";
                                        var71 = "0";
                                        var72 = "0";

                                        for(var1551 = 0; var1551 < var43.size(); ++var1551) {
                                            if("13".equals(((QyjDto)var43.get(var1551)).getMxb()) && var56.equals(((QyjDto)var43.get(var1551)).getQtd()) && var14.equals(((QyjDto)var43.get(var1551)).getMainId())) {
                                                var71 = ((QyjDto)var43.get(var1551)).getXsje();
                                                var72 = ((QyjDto)var43.get(var1551)).getQlj();
                                                var153 = new BigDecimal("0");
                                                if(!"".equals(var71)) {
                                                    var153 = new BigDecimal(var71);
                                                }

                                                var153 = var153.add(var125);
                                                var151 = new BigDecimal("0");
                                                if(!"".equals(var72)) {
                                                    var151 = new BigDecimal(var72);
                                                }

                                                var151 = var151.add(var142);
                                                var155 = (QyjDto)var43.get(var1551);
                                                var155.setXsje(var153.toString());
                                                var155.setQlj(var151.toString());
                                                var43.set(var1551, var155);
                                                var70 = "1";
                                            }
                                        }

                                        if("0".equals(var70)) {
                                            var135 = new QyjDto();
                                            var135.setMainId(var14);
                                            var135.setXsje(var50.toString());
                                            var135.setQljbl(var52);
                                            var135.setQlj(var142.toString());
                                            var135.setQljksqj(var54);
                                            var135.setQljjsqj(var55);
                                            var135.setPl(var57);
                                            var135.setQtd(var56);
                                            var135.setMxb("13");
                                            var135.setKsrq(var120);
                                            var135.setJsrq(var122);
                                            var43.add(var135);
                                        }
                                        break;
                                    }

                                    var51 = "2";
                                    var50 = var50.subtract(var1351);
                                    var142 = var1351.multiply(var1321);
                                    var69 = "update  uf_HTK_dt13 set qjsyje=\'0\' where id=\'" + var56 + "\' ";
                                    var6.execute(var69);
                                    var70 = "0";
                                    var71 = "0";
                                    var72 = "0";

                                    for(var1551 = 0; var1551 < var43.size(); ++var1551) {
                                        if("13".equals(((QyjDto)var43.get(var1551)).getMxb()) && var56.equals(((QyjDto)var43.get(var1551)).getQtd()) && var14.equals(((QyjDto)var43.get(var1551)).getMainId())) {
                                            var71 = ((QyjDto)var43.get(var1551)).getXsje();
                                            var72 = ((QyjDto)var43.get(var1551)).getQlj();
                                            var153 = new BigDecimal("0");
                                            if(!"".equals(var71)) {
                                                var153 = new BigDecimal(var71);
                                            }

                                            var153 = var153.add(var125);
                                            var151 = new BigDecimal("0");
                                            if(!"".equals(var72)) {
                                                var151 = new BigDecimal(var72);
                                            }

                                            var151 = var151.add(var142);
                                            var155 = (QyjDto)var43.get(var1551);
                                            var155.setXsje(var153.toString());
                                            var155.setQlj(var151.toString());
                                            var43.set(var1551, var155);
                                            var70 = "1";
                                        }
                                    }

                                    if("0".equals(var70)) {
                                        var135 = new QyjDto();
                                        var135.setMainId(var14);
                                        var135.setXsje(var50.toString());
                                        var135.setQljbl(var52);
                                        var135.setQlj(var142.toString());
                                        var135.setQljksqj(var54);
                                        var135.setQljjsqj(var55);
                                        var135.setPl(var57);
                                        var135.setQtd(var56);
                                        var135.setMxb("13");
                                        var135.setKsrq(var120);
                                        var135.setJsrq(var122);
                                        var43.add(var135);
                                    }
                                }

                                if(!"0".equals(var51) && !"1".equals(var51)) {
                                    continue;
                                }

                                var8 = "未设置权益金比例。";
                                var1.getRequestManager().setMessageid("流程提交失败");
                                var1.getRequestManager().setMessagecontent(var8);
                                return "0";
                            }

                            var51 = "0";
                            var52 = "";
                            var53 = "";
                            var54 = "";
                            var55 = "";
                            var56 = "";
                            var57 = "select id,qjjsy,qljl,ksje,jsje from uf_HTK_dt3 where mainid=\'" + var30 + "\' and qjjsy!=\'0\' order by  ksje ";
                            this.log.error("sqlT32: " + var57);
                            var5.execute(var57);

                            while(var5.next()) {
                                var55 = var5.getString("qljl");
                                var53 = var5.getString("ksje");
                                var54 = var5.getString("jsje");
                                var56 = var5.getString("id");
                                var52 = var5.getString("qjjsy");
                                if("".equals(var55) && "0".equals(var51)) {
                                    var51 = "1";
                                    break;
                                }

                                var58 = new BigDecimal("0");
                                if(!"".equals(var55)) {
                                    var58 = new BigDecimal(var55);
                                }

                                var59 = new BigDecimal("0");
                                if(!"".equals(var52)) {
                                    var59 = new BigDecimal(var52);
                                }

                                var60 = var59.subtract(var50);
                                var61 = var60.doubleValue();
                                var63 = 0.0D;
                                if(!"".equals(var52)) {
                                    var63 = Double.parseDouble(var52);
                                }

                                if(var63 > 9.99999999E8D) {
                                    var51 = "3";
                                    var65 = var50.multiply(var58);
                                    var135 = new QyjDto();
                                    var135.setMainId(var14);
                                    var135.setXsje(var50.toString());
                                    var135.setQljbl(var55);
                                    var135.setQlj(var65.toString());
                                    var135.setQljksqj(var53);
                                    var135.setQljjsqj(var54);
                                    var135.setPl("");
                                    var135.setQtd(var56);
                                    var135.setMxb("3");
                                    var43.add(var135);
                                    break;
                                }

                                if(var61 > 0.0D) {
                                    var51 = "3";
                                    var65 = var50.multiply(var58);
                                    var66 = "update  uf_HTK_dt3 set qjjsy=\'" + var60.toString() + "\' where id=\'" + var56 + "\' ";
                                    var6.execute(var66);
                                    var62 = new QyjDto();
                                    var62.setMainId(var14);
                                    var62.setXsje(var50.toString());
                                    var62.setQljbl(var55);
                                    var62.setQlj(var65.toString());
                                    var62.setQljksqj(var53);
                                    var62.setQljjsqj(var54);
                                    var62.setPl("");
                                    var62.setQtd(var56);
                                    var62.setMxb("3");
                                    var43.add(var62);
                                    break;
                                }

                                var51 = "2";
                                var50 = var50.subtract(var59);
                                var65 = var59.multiply(var58);
                                var66 = "update  uf_HTK_dt3 set qjjsy=\'0\' where id=\'" + var56 + "\' ";
                                var6.execute(var66);
                                var62 = new QyjDto();
                                var62.setMainId(var14);
                                var62.setXsje(var50.toString());
                                var62.setQljbl(var55);
                                var62.setQlj(var65.toString());
                                var62.setQljksqj(var53);
                                var62.setQljjsqj(var54);
                                var62.setPl("");
                                var62.setQtd(var56);
                                var62.setMxb("3");
                                var43.add(var62);
                            }

                            if(!"0".equals(var51) && !"1".equals(var51)) {
                                var42 = "3";
                                var120 = "update " + var13 + " set qyjb=\'3\'  where id=\'" + var14 + "\' ";
                                var6.execute(var120);
                                continue;
                            }

                            var120 = "";
                            var122 = "";
                            var123 = "";
                            var124 = "";
                            String var126 = "";
                            String var128 = "select id,qljbl,ksrq,jsrq from uf_HTK_dt4 where mainid=\'" + var30 + "\' and \'" + var16 + "\' between ksrq and jsrq ";
                            var5.execute(var128);
                            this.log.error("sqlT42: " + var128);
                            if(var5.next()) {
                                var122 = var5.getString("qljbl");
                                var123 = var5.getString("id");
                                var124 = var5.getString("ksrq");
                                var126 = var5.getString("jsrq");
                            }

                            if(!"".equals(var122)) {
                                var1281 = new BigDecimal("0");
                                if(!"".equals(var122)) {
                                    var1281 = new BigDecimal(var122);
                                }

                                var65 = var1281.multiply(var125);
                                var135 = new QyjDto();
                                var135.setMainId(var14);
                                var135.setXsje(var125.toString());
                                var135.setQljbl(var122);
                                var135.setQlj(var65.toString());
                                var135.setKsrq(var124);
                                var135.setJsrq(var126);
                                var135.setPl("");
                                var135.setQtd(var123);
                                var135.setMxb("4");
                                var43.add(var135);
                                var42 = "4";
                                var139 = "update " + var13 + " set qyjb=\'4\'  where id=\'" + var14 + "\' ";
                                var5.execute(var139);
                                continue;
                            }

                            String var64 = "";
                            String var132 = "";
                            var66 = "";
                            var139 = "select id,pl,qyjbl from uf_HTK_dt9 where pl=(select xl from uf_spsslc where id=\'" + var39 + "\') and mainid=\'" + var30 + "\' ";
                            this.log.error("sqlT92: " + var139);
                            var5.execute(var139);
                            if(var5.next()) {
                                var64 = var5.getString("qyjbl");
                                var132 = var5.getString("pl");
                                var66 = var5.getString("id");
                            }

                            if(!"".equals(var64)) {
                                var142 = new BigDecimal("0");
                                if(!"".equals(var64)) {
                                    var142 = new BigDecimal(var64);
                                }

                                var130 = var142.multiply(var125);
                                var145 = new QyjDto();
                                var145.setMainId(var14);
                                var145.setXsje(var125.toString());
                                var145.setQljbl(var64);
                                var145.setQlj(var130.toString());
                                var145.setQljksqj("");
                                var145.setQljjsqj("");
                                var145.setPl(var132);
                                var145.setQtd(var66);
                                var145.setMxb("9");
                                var43.add(var145);
                                var42 = "9";
                                var71 = "update " + var13 + " set qyjb=\'9\'  where id=\'" + var14 + "\' ";
                                var5.execute(var71);
                                continue;
                            }

                            var68 = "";
                            var69 = "";
                            var70 = "";
                            var71 = "";
                            var72 = "";
                            String var73 = "select id,pl,qyjbl,ksrq,jsrq from uf_HTK_dt10 where pl=(select xl from uf_spsslc where id=\'" + var39 + "\') and \'" + var16 + "\' between ksrq and jsrq and mainid=\'" + var30 + "\' ";
                            this.log.error("sqlT102: " + var73);
                            var5.execute(var73);
                            if(var5.next()) {
                                var68 = var5.getString("qyjbl");
                                var69 = var5.getString("pl");
                                var70 = var5.getString("id");
                                var71 = var5.getString("ksrq");
                                var72 = var5.getString("jsrq");
                            }

                            String var77;
                            if(!"".equals(var68)) {
                                var153 = new BigDecimal("0");
                                if(!"".equals(var68)) {
                                    var153 = new BigDecimal(var68);
                                }

                                var151 = var153.multiply(var125);
                                var155 = new QyjDto();
                                var155.setMainId(var14);
                                var155.setXsje(var125.toString());
                                var155.setQljbl(var68);
                                var155.setQlj(var151.toString());
                                var155.setKsrq(var71);
                                var155.setJsrq(var72);
                                var155.setPl(var69);
                                var155.setQtd(var70);
                                var155.setMxb("10");
                                var43.add(var155);
                                var42 = "10";
                                var77 = "update " + var13 + " set qyjb=\'10\'  where id=\'" + var14 + "\' ";
                                var5.execute(var77);
                                continue;
                            }

                            String var74 = "0";
                            String var75 = "";
                            String var76 = "";
                            var77 = "";
                            String var78 = "";
                            String var79 = "";
                            String var80 = "";
                            String var81 = "select id,qjsyje,ksje,jsje,qyjbl,pl from uf_HTK_dt11 where pl=(select xl from uf_spsslc where id=\'" + var39 + "\') and mainid=\'" + var30 + "\' and qjsyje!=\'0\' order by  ksje ";
                            this.log.error("sqlT11: " + var81);
                            var5.execute(var81);

                            String var90;
                            while(var5.next()) {
                                var75 = var5.getString("qyjbl");
                                var76 = var5.getString("qjsyje");
                                var77 = var5.getString("ksje");
                                var78 = var5.getString("jsje");
                                var79 = var5.getString("id");
                                var80 = var5.getString("pl");
                                if("".equals(var75) && "0".equals(var74)) {
                                    var74 = "1";
                                    break;
                                }

                                BigDecimal var163 = new BigDecimal("0");
                                if(!"".equals(var75)) {
                                    var163 = new BigDecimal(var75);
                                }

                                BigDecimal var165 = new BigDecimal("0");
                                if(!"".equals(var76)) {
                                    var165 = new BigDecimal(var76);
                                }

                                var166 = var165.subtract(var50);
                                double var167 = var166.doubleValue();
                                double var168 = 0.0D;
                                if(!"".equals(var76)) {
                                    var168 = Double.parseDouble(var76);
                                }

                                BigDecimal var169;
                                QyjDto var99;
                                if(var168 >= 9.99999999E8D) {
                                    var74 = "3";
                                    var169 = var50.multiply(var163);
                                    var99 = new QyjDto();
                                    var99.setMainId(var14);
                                    var99.setXsje(var50.toString());
                                    var99.setQljbl(var75);
                                    var99.setQlj(var169.toString());
                                    var99.setQljksqj(var77);
                                    var99.setQljjsqj(var78);
                                    var99.setPl(var80);
                                    var99.setQtd(var79);
                                    var99.setMxb("11");
                                    var43.add(var99);
                                    break;
                                }

                                if(var167 > 0.0D) {
                                    var74 = "3";
                                    var169 = var50.multiply(var163);
                                    var90 = "update  uf_HTK_dt11 set qjsyje=\'" + var166.toString() + "\' where id=\'" + var79 + "\' ";
                                    var6.execute(var90);
                                    var99 = new QyjDto();
                                    var99.setMainId(var14);
                                    var99.setXsje(var50.toString());
                                    var99.setQljbl(var75);
                                    var99.setQlj(var169.toString());
                                    var99.setQljksqj(var77);
                                    var99.setQljjsqj(var78);
                                    var99.setPl(var80);
                                    var99.setQtd(var79);
                                    var99.setMxb("11");
                                    var43.add(var99);
                                    break;
                                }

                                var74 = "2";
                                var50 = var50.subtract(var165);
                                var169 = var165.multiply(var163);
                                var90 = "update  uf_HTK_dt11 set qjsyje=\'0\' where id=\'" + var79 + "\' ";
                                var6.execute(var90);
                                var99 = new QyjDto();
                                var99.setMainId(var14);
                                var99.setXsje(var165.toString());
                                var99.setQljbl(var75);
                                var99.setQlj(var169.toString());
                                var99.setQljksqj(var77);
                                var99.setQljjsqj(var78);
                                var99.setPl(var80);
                                var99.setQtd(var79);
                                var99.setMxb("11");
                                var43.add(var99);
                            }

                            String var147;
                            if(!"0".equals(var74) && !"1".equals(var74)) {
                                var42 = "11";
                                var147 = "update " + var13 + " set qyjb=\'11\'  where id=\'" + var14 + "\' ";
                                var6.execute(var147);
                                continue;
                            }

                            var147 = "0";
                            String var148 = "";
                            String var149 = "";
                            String var152 = "";
                            String var86 = "";
                            String var157 = "";
                            String var88 = "";
                            String var159 = "";
                            var90 = "select id,qjsyje,ksje,jsje,qyjbl,ksqr,jsrq from uf_HTK_dt12 where  (\'" + var16 + "\' between ksqr and jsrq) and mainid=\'" + var30 + "\' and qjsyje!=\'0\' order by  ksje ";
                            this.log.error("sqlT12: " + var90);
                            var5.execute(var90);

                            String var160;
                            while(var5.next()) {
                                var148 = var5.getString("qyjbl");
                                var149 = var5.getString("qjsyje");
                                var152 = var5.getString("ksje");
                                var86 = var5.getString("jsje");
                                var157 = var5.getString("id");
                                var88 = var5.getString("ksqr");
                                var159 = var5.getString("jsrq");
                                if("".equals(var148) && "0".equals(var147)) {
                                    var147 = "1";
                                    break;
                                }

                                BigDecimal var173 = new BigDecimal("0");
                                if(!"".equals(var148)) {
                                    var173 = new BigDecimal(var148);
                                }

                                BigDecimal var172 = new BigDecimal("0");
                                if(!"".equals(var149)) {
                                    var172 = new BigDecimal(var149);
                                }

                                BigDecimal var174 = var172.subtract(var50);
                                double var175 = var174.doubleValue();
                                double var176 = 0.0D;
                                if(!"".equals(var149)) {
                                    var176 = Double.parseDouble(var149);
                                }

                                BigDecimal var177;
                                QyjDto var179;
                                if(var176 >= 9.99999999E8D) {
                                    var147 = "3";
                                    var177 = var50.multiply(var173);
                                    var179 = new QyjDto();
                                    var179.setMainId(var14);
                                    var179.setXsje(var50.toString());
                                    var179.setQljbl(var148);
                                    var179.setQlj(var177.toString());
                                    var179.setQljksqj(var152);
                                    var179.setQljjsqj(var86);
                                    var179.setPl("");
                                    var179.setQtd(var157);
                                    var179.setMxb("12");
                                    var179.setKsrq(var88);
                                    var179.setJsrq(var159);
                                    var43.add(var179);
                                    break;
                                }

                                if(var175 > 0.0D) {
                                    var147 = "3";
                                    var177 = var50.multiply(var173);
                                    var160 = "update  uf_HTK_dt12 set qjsyje=\'" + var174.toString() + "\' where id=\'" + var157 + "\' ";
                                    var6.execute(var160);
                                    var179 = new QyjDto();
                                    var179.setMainId(var14);
                                    var179.setXsje(var50.toString());
                                    var179.setQljbl(var148);
                                    var179.setQlj(var177.toString());
                                    var179.setQljksqj(var152);
                                    var179.setQljjsqj(var86);
                                    var179.setPl("");
                                    var179.setQtd(var157);
                                    var179.setMxb("12");
                                    var179.setKsrq(var88);
                                    var179.setJsrq(var159);
                                    var43.add(var179);
                                    break;
                                }

                                var147 = "2";
                                var50 = var50.subtract(var172);
                                var177 = var172.multiply(var173);
                                var160 = "update  uf_HTK_dt12 set qjsyje=\'0\' where id=\'" + var157 + "\' ";
                                var6.execute(var160);
                                var179 = new QyjDto();
                                var179.setMainId(var14);
                                var179.setXsje(var50.toString());
                                var179.setQljbl(var148);
                                var179.setQlj(var177.toString());
                                var179.setQljksqj(var152);
                                var179.setQljjsqj(var86);
                                var179.setPl("");
                                var179.setQtd(var157);
                                var179.setMxb("12");
                                var179.setKsrq(var88);
                                var179.setJsrq(var159);
                                var43.add(var179);
                            }

                            String var161;
                            if(!"0".equals(var147) && !"1".equals(var147)) {
                                var42 = "12";
                                var161 = "update " + var13 + " set qyjb=\'12\'  where id=\'" + var14 + "\' ";
                                var6.execute(var161);
                                continue;
                            }

                            var161 = "0";
                            String var162 = "";
                            String var1631 = "";
                            String var164 = "";
                            String var95 = "";
                            String var1651 = "";
                            String var97 = "";
                            String var1661 = "";
                            var160 = "";
                            String var1671 = "select ksje,jsje,qyjbl,qjsyje,pl,ksqr,jsrq from uf_HTK_dt13 where  (\'" + var16 + "\' between ksqr and jsrq) and mainid=\'" + var30 + "\' and pl=(select xl from uf_spsslc where id=\'" + var39 + "\')  and qjsyje!=\'0\' order by  ksje";
                            this.log.error("sqlT13: " + var1671);
                            var5.execute(var1671);

                            while(var5.next()) {
                                var162 = var5.getString("qyjbl");
                                var1631 = var5.getString("qjsyje");
                                var164 = var5.getString("ksje");
                                var95 = var5.getString("jsje");
                                var1651 = var5.getString("id");
                                var97 = var5.getString("pl");
                                var1661 = var5.getString("ksqr");
                                var160 = var5.getString("jsrq");
                                if("".equals(var162) && "0".equals(var161)) {
                                    var161 = "1";
                                    break;
                                }

                                BigDecimal var180 = new BigDecimal("0");
                                if(!"".equals(var162)) {
                                    var180 = new BigDecimal(var162);
                                }

                                BigDecimal var102 = new BigDecimal("0");
                                if(!"".equals(var1631)) {
                                    var102 = new BigDecimal(var1631);
                                }

                                BigDecimal var103 = var102.subtract(var50);
                                double var104 = var103.doubleValue();
                                double var106 = 0.0D;
                                if(!"".equals(var1631)) {
                                    var106 = Double.parseDouble(var1631);
                                }

                                BigDecimal var108;
                                if(var106 >= 9.99999999E8D) {
                                    var161 = "3";
                                    var108 = var50.multiply(var180);
                                    QyjDto var1691 = new QyjDto();
                                    var1691.setMainId(var14);
                                    var1691.setXsje(var50.toString());
                                    var1691.setQljbl(var162);
                                    var1691.setQlj(var108.toString());
                                    var1691.setQljksqj(var164);
                                    var1691.setQljjsqj(var95);
                                    var1691.setPl(var97);
                                    var1691.setQtd(var1651);
                                    var1691.setMxb("13");
                                    var1691.setKsrq(var1661);
                                    var1691.setJsrq(var160);
                                    var43.add(var1691);
                                    break;
                                }

                                String var109;
                                QyjDto var110;
                                if(var104 > 0.0D) {
                                    var161 = "3";
                                    var108 = var50.multiply(var180);
                                    var109 = "update  uf_HTK_dt13 set qjsyje=\'" + var103.toString() + "\' where id=\'" + var1651 + "\' ";
                                    var6.execute(var109);
                                    var110 = new QyjDto();
                                    var110.setMainId(var14);
                                    var110.setXsje(var50.toString());
                                    var110.setQljbl(var162);
                                    var110.setQlj(var108.toString());
                                    var110.setQljksqj(var164);
                                    var110.setQljjsqj(var95);
                                    var110.setPl(var97);
                                    var110.setQtd(var1651);
                                    var110.setMxb("13");
                                    var110.setKsrq(var1661);
                                    var110.setJsrq(var160);
                                    var43.add(var110);
                                    break;
                                }

                                var161 = "2";
                                var50 = var50.subtract(var102);
                                var108 = var102.multiply(var180);
                                var109 = "update  uf_HTK_dt13 set qjsyje=\'0\' where id=\'" + var1651 + "\' ";
                                var6.execute(var109);
                                var110 = new QyjDto();
                                var110.setMainId(var14);
                                var110.setXsje(var50.toString());
                                var110.setQljbl(var162);
                                var110.setQlj(var108.toString());
                                var110.setQljksqj(var164);
                                var110.setQljjsqj(var95);
                                var110.setPl(var97);
                                var110.setQtd(var1651);
                                var110.setMxb("13");
                                var110.setKsrq(var1661);
                                var110.setJsrq(var160);
                                var43.add(var110);
                            }

                            if(!"0".equals(var161) && !"1".equals(var161)) {
                                var42 = "13";
                                String var1681 = "update " + var13 + " set qyjb=\'13\'  where id=\'" + var14 + "\' ";
                                var6.execute(var1681);
                                continue;
                            }

                            this.log.error("合同库明细表15：单价加品类逻辑开始+++++++++++");
                            String var182="";
                            String var183="";//品类
                            String var184="";//单价
                            String var185="";//开始日期
                            String var186="";//结束日期
                            String var187="";
                            String var189="";
                            BigDecimal var190 = new BigDecimal("0");
                            String var199="";
                            List<String> xlList = new ArrayList();
                            String var180="select distinct xl from "+var24+" where mainid='"+var14+"'";
                            this.log.error("var180:"+var180);
                            var7.execute(var180);
                            while (var7.next()){
                                String xl = var7.getString("xl");
                                xlList.add(xl);
                            }
                            this.log.error("xlList:"+xlList.toString());
                            int ac=0;
                            for(int i=0;i<xlList.size();i++){
                                String var181="select COUNT(*) as ac from uf_HTK_dt15 where pl='"+xlList.get(i)+"'";
                                var7.execute(var181);
                                while (var7.next()){
                                    ac = var7.getInt("ac");
                                }
                                if(ac==0){
                                    break;
                                }
                            }
                            this.log.error("ac:"+ac);
                            if(ac>0){
                                for(int i=0;i<xlList.size();i++) {
                                var182="select id,pl,dj,ksrq,jsrq from uf_HTK_dt15 where mainid='"+var30+"' and pl='"+xlList.get(i)+"'";
                                var7.execute(var182);
                                this.log.error("var182:"+var182);
                                while (var7.next()) {
                                        var199 = var7.getString("id");
                                        var183 = var7.getString("pl");
                                        var184 = var7.getString("dj");
                                        var185 = var7.getString("ksrq");
                                        var186 = var7.getString("jsrq");
                                        var187 = "select SUM(lysl) as zlysl from " + var24 + " where xl='" + var183 + "' and mainid='" + var14 + "'";
                                        var7.execute(var187);
                                        this.log.error("var187:" + var187);
                                        if (var7.next()) {
                                            var189 = var7.getString("zlysl");
                                        }
                                        BigDecimal var191 = new BigDecimal("0");
                                        if (!"".equals(var191)) {
                                            var191 = new BigDecimal(var184);
                                        }
                                        BigDecimal var192 = new BigDecimal("0");
                                        if (!"".equals(var192)) {
                                            var192 = new BigDecimal(var189);
                                        }
                                        var190 = var191.multiply(var192);//每个品类的总价格
                                        this.log.error("var190:" + var190);
                                        var188 = new QyjDto();
                                        var188.setMainId(var14);
                                        var188.setXsje(var190.toString());
                                        var188.setQljbl(var184);
                                        var188.setQlj(var190.toString());
                                        var188.setPl(var183);
                                        var188.setQtd(var199);
                                        var188.setMxb("");
                                        var188.setKsrq(var185);
                                        var188.setJsrq(var186);
                                        var43.add(var188);
                                    }
                                }
                                var42 = "15";
                                String var197= "update " + var13 + " set qyjb=\'15\'  where id=\'" + var14 + "\' ";
                                var7.execute(var197);
                                this.log.error("单价加品类逻辑结束+++++++++++");
                                continue;
                            }


                            var8 = "未设置权益金比例。";
                            var1.getRequestManager().setMessageid("流程提交失败");
                            var1.getRequestManager().setMessagecontent(var8);
                            return "0";
                        }

                        this.log.error("listQ:" + JSONObject.toJSONString(var43));
                        Iterator var112 = var43.iterator();

                        while(true) {
                            if(!var112.hasNext()) {
                                break label883;
                            }

                            QyjDto var113 = (QyjDto)var112.next();
                            if("".equals(var113.getPl()) || var113.getPl() == null) {
                                var113.setPl("0");
                            }

                            if("".equals(var113.getQljksqj()) || var113.getQljksqj() == null) {
                                var113.setQljksqj("0");
                            }

                            if("".equals(var113.getQljjsqj()) || var113.getQljjsqj() == null) {
                                var113.setQljjsqj("0");
                            }

                            String var114 = "insert into " + var25 + " (mainid,xsje,qljbl,qlj,qljksqj,qljjsqj,pl,QID,mxb,ksrq,jsrq) values (\'" + var113.getMainId() + "\',\'" + var113.getXsje() + "\',\'" + var113.getQljbl() + "\',\'" + var113.getQlj() + "\',\'" + var113.getQljksqj() + "\',\'" + var113.getQljjsqj() + "\',\'" + var113.getPl() + "\',\'" + var113.getQtd() + "\',\'" + var113.getMxb() + "\',\'" + var113.getKsrq() + "\',\'" + var113.getJsrq() + "\')";
                            var6.execute(var114);
                        }
                    }
                }
            }
        } catch (Exception var1221) {
            var8 = "" + var1221;
            var1.getRequestManager().setMessageid("流程提交失败");
            var1.getRequestManager().setMessagecontent(var8);
            return "0";
        }

        this.log.error("######################        调用权益金计算Action end   ################################################");
        return "1";
    }
}
