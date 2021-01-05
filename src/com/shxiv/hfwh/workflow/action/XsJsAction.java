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
public class XsJsAction extends BaseBean implements Action {

    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(XsJsAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################   开始调用销售计算Action     ###########################");
        RecordSet rss = new RecordSet();
        RecordSet rs1 = new RecordSet();
        RecordSet rs2 = new RecordSet();
        RecordSet rs3 = new RecordSet();
        RecordSet rs4 = new RecordSet();
        RecordSet rs5 = new RecordSet();
        String tempMessage = "";
        try {
            WorkflowComInfo workflowComInfo = new WorkflowComInfo();
            int requestid = Util.getIntValue(request.getRequestid());//创建一个流程就生成唯一标识的请求ID
            int workflowid = Util.getIntValue(request.getWorkflowid());//流程ID
            int formid = Util.getIntValue(workflowComInfo.getFormId("" + workflowid));//表单ID 

            //主表表名
            String mainTable = "formtable_main_" + ((-1) * formid);

            String htbh="";//合同编号

            //主表数据
            MainTableInfo formtable_main_x = request.getMainTableInfo();
            Property[] properties = formtable_main_x.getProperty();
            for (int i = 0; i < properties.length; i++) {
                String fieldName = properties[i].getName();
                String fieldValue = Util.null2String(properties[i].getValue());
                if ("htbh".equalsIgnoreCase(fieldName)) {
                    htbh = fieldValue;//合同编号
                }
            }

            String mainId="";
            //查询出主表ID
            String sqlMa="select id from "+mainTable+" where requestId='"+requestid+"'  ";
            rs1.execute(sqlMa);
            if(rs1.next()){
                mainId=rs1.getString("id");
            }

            //明细表1
            String mxTable1 = mainTable + "_dt1";

            //明细表2
            String mxTable2 = mainTable + "_dt2";


            //合同类型：0销售；1权益金
            String htlx="";

            String htid="";
            //根据合同编号查询合同库的ID、合同类型
            String sqlT="select id,htlx from uf_HTK where id='"+htbh+"'";
            rss.execute(sqlT);
            if(rss.next()){
                htlx=rss.getString("htlx");//合同类型
                htid=rss.getString("id");//ID
            }
            //根据合同类型计算:
            if("0".equals(htlx)){
                //净销售额
                String jxse="";

                String mxId = "";
                //根据主表ID查询明细表1所有的数据
                String sqlMx1 = "select*from  " + mxTable1 + "  where mainid='" + mainId + "' ";
                rs2.execute(sqlMx1);
                while (rs2.next()) {
                    jxse = rs2.getString("jxse");//净销售额
                    mxId = rs2.getString("id");//ID


                    BigDecimal bb7 = new BigDecimal("0");
                    if (!"".equals(jxse)) {
                        bb7 = new BigDecimal(jxse);
                    }

                    BigDecimal bb707 = bb7;//净销售额

                    //销售-金额：合同表明细3
                    String tt = "0";
                    String syj = "";
                    String ksj = "";
                    String jsj = "";
                    String qbl = "";
                    String mtd = "";
                    //根据明细表1的ID查询合同库明细表3的ID、区间金额剩余、权利金比例、开始金额、结束金额
                    String sqlT3 = "select id,qjjsy,qljl,ksje,jsje from uf_HTK_dt3 where mainid='" + htid + "' and qjjsy!='0' order by  ksje ";
                    log.error("sqlT3: " + sqlT3);
                    rs3.execute(sqlT3);
                    while (rs3.next()) {
                        qbl = rs3.getString("qljl");
                        ksj = rs3.getString("ksje");
                        jsj = rs3.getString("jsje");
                        mtd = rs3.getString("id");
                        syj = rs3.getString("qjjsy");
                        if ("".equals(qbl) && "0".equals(tt)) {
                            tt = "1";
                            break;
                        } else {
                            BigDecimal bb8 = new BigDecimal("0");
                            if (!"".equals(qbl)) {
                                bb8 = new BigDecimal(qbl);//权利金比例
                            }
                            //区间剩余金额
                            BigDecimal bb701 = new BigDecimal("0");
                            if (!"".equals(syj)) {
                                bb701 = new BigDecimal(syj);//区间金额剩余
                            }
                            //差值
                            BigDecimal bb702 = bb701.subtract(bb707);//差值=区间金额剩余-净销售额

                            double d5 = bb702.doubleValue();
                            double dd0 =0;
                            if(!"".equals(syj)) {
                                dd0 = Double.valueOf(syj);//区间金额剩余
                            }
                            //区间金额剩余等于999999999
                            if (dd0 == 999999999) {
                                tt = "3";
                                BigDecimal bb703 = bb707.multiply(bb8);//净销售额乘以权利金比例
                                /*double d6 = bb703.doubleValue();*/

                                String ct = "0";
                                //
                                String sqlP = "select count(*) as ct from " + mxTable2 + " where mainid='" + mainId + "' and QID='" + mtd + "'";
                                rs4.execute(sqlP);
                                if (rs4.next()) {
                                    ct = rs4.getString("ct");
                                }

                                if ("0".equals(ct)) {
                                    //插入明细表数据
                                    String sqlIn = "insert into " + mxTable2 + " (mainid,jxse,qljbl,qlj,jeksqj,jejsqj,QID) values ('" + mainId + "','" + bb707.toString() + "','" + qbl + "','" + bb703.toString() + "','" + ksj + "','" + jsj + "','" + mtd + "')";
                                    rs4.execute(sqlIn);
                                } else {
                                    String xse = "0";
                                    String qlj = "0";
                                    String sqlM2 = "select jxse,qlj from " + mxTable2 + " where mainid='" + mainId + "' and QID='" + mtd + "' ";
                                    rs4.execute(sqlM2);
                                    if (rs4.next()) {
                                        xse = rs4.getString("jxse");
                                        qlj = rs4.getString("qlj");

                                    }

                                    BigDecimal bb101 = new BigDecimal("0");
                                    if (!"".equals(xse)) {
                                        bb101 = new BigDecimal(xse);
                                    }
                                    bb101 = bb101.add(bb7);

                                    BigDecimal bb102 = new BigDecimal("0");
                                    if (!"".equals(qlj)) {
                                        bb102 = new BigDecimal(qlj);
                                    }
                                    bb102 = bb102.add(bb703);


                                    //更新明细表数据
                                    String sqlU7 = "update " + mxTable2 + " set jxse='" + bb101.toString() + "',qlj='" + bb102.toString() + "'  where mainid='" + mainId + "' and QID='" + mtd + "'  ";
                                    rs4.execute(sqlU7);
                                }
                                break;
                            }else{
                                if (d5 > 0) {
                                    tt = "3";
                                    BigDecimal bb703 = bb707.multiply(bb8);//净销售额
                                    /*double d6 = bb703.doubleValue();*/

                                    String sqlU6 = "update  uf_HTK_dt3 set qjjsy='" + bb702.toString() + "' where id='" + mtd + "' ";
                                    rs4.execute(sqlU6);

                                    String ct = "0";
                                    String sqlP = "select count(*) as ct from " + mxTable2 + " where mainid='" + mainId + "' and QID='" + mtd + "'  ";
                                    rs4.execute(sqlP);
                                    if (rs4.next()) {
                                        ct = rs4.getString("ct");
                                    }

                                    if ("0".equals(ct)) {
                                        //插入明细表数据
                                        String sqlIn = "insert into " + mxTable2 + " (mainid,jxse,qljbl,qlj,jeksqj,jejsqj,QID) values ('" + mainId + "','" + bb707.toString() + "','" + qbl + "','" + bb703.toString() + "','" + ksj + "','" + jsj + "','" + mtd + "' )";
                                        rs4.execute(sqlIn);
                                    } else {
                                        String xse = "0";
                                        String qlj = "0";
                                        String sqlM2 = "select jxse,qlj from " + mxTable2 + " where mainid='" + mainId + "' and QID='" + mtd + "' ";
                                        rs4.execute(sqlM2);
                                        if (rs4.next()) {
                                            xse = rs4.getString("jxse");
                                            qlj = rs4.getString("qlj");

                                        }

                                        BigDecimal bb101 = new BigDecimal("0");
                                        if (!"".equals(xse)) {
                                            bb101 = new BigDecimal(xse);
                                        }
                                        bb101 = bb101.add(bb7);

                                        BigDecimal bb102 = new BigDecimal("0");
                                        if (!"".equals(qlj)) {
                                            bb102 = new BigDecimal(qlj);
                                        }
                                        bb102 = bb102.add(bb703);


                                        //更新明细表数据
                                        String sqlU7 = "update " + mxTable2 + " set jxse='" + bb101.toString() + "',qlj='" + bb102.toString() + "'  where mainid='" + mainId + "' and QID='" + mtd + "' ";
                                        rs4.execute(sqlU7);
                                    }
                                    break;
                                } else {
                                    tt = "2";
                                    bb707 = bb707.subtract(bb701);

                                    BigDecimal bb703 = bb701.multiply(bb8);
                                    /*double d6 = bb703.doubleValue();*/

                                    String sqlU6 = "update  uf_HTK_dt3 set qjjsy='0' where id='" + mtd + "' ";
                                    rs4.execute(sqlU6);

                                    String ct = "0";
                                    String sqlP = "select count(*) as ct from " + mxTable2 + " where mainid='" + mainId + "' and QID='" + mtd + "' ";
                                    rs4.execute(sqlP);
                                    if (rs4.next()) {
                                        ct = rs4.getString("ct");
                                    }

                                    if ("0".equals(ct)) {
                                        //插入明细表数据
                                        String sqlIn = "insert into " + mxTable2 + " (mainid,jxse,qljbl,qlj,jeksqj,jejsqj,QID) values ('" + mainId + "','" + bb701.toString() + "','" + qbl + "','" + bb703.toString() + "','" + ksj + "','" + jsj + "','" + mtd + "' )";
                                        rs4.execute(sqlIn);
                                    } else {
                                        String xse = "0";
                                        String qlj = "0";
                                        String sqlM2 = "select jxse,qlj from " + mxTable2 + " where mainid='" + mainId + "' and QID='" + mtd + "'  ";
                                        rs4.execute(sqlM2);
                                        if (rs4.next()) {
                                            xse = rs4.getString("jxse");
                                            qlj = rs4.getString("qlj");

                                        }

                                        BigDecimal bb101 = new BigDecimal("0");
                                        if (!"".equals(xse)) {
                                            bb101 = new BigDecimal(xse);
                                        }
                                        bb101 = bb101.add(bb701);

                                        BigDecimal bb102 = new BigDecimal("0");
                                        if (!"".equals(qlj)) {
                                            bb102 = new BigDecimal(qlj);
                                        }
                                        bb102 = bb102.add(bb703);


                                        //更新明细表数据
                                        String sqlU7 = "update " + mxTable2 + " set jxse='" + bb101.toString() + "',qlj='" + bb102.toString() + "'  where mainid='" + mainId + "' and QID='" + mtd + "'  ";
                                        rs4.execute(sqlU7);
                                    }
                                }
                            }
                        }
                    }
                    if("0".equals(tt)||"1".equals(tt)){
                        tempMessage = "未维护权益金比例。";
                        request.getRequestManager().setMessageid("流程提交失败");
                        request.getRequestManager().setMessagecontent(tempMessage);
                        return "0";
                    }
                }

            }
        } catch (Exception e) {
            tempMessage = ""+e;
            request.getRequestManager().setMessageid("流程提交失败");
            request.getRequestManager().setMessagecontent(tempMessage);
            return "0";
        }

        this.log.error("######################        调用销售计算Action end   ################################################");
        /***interface action  stop *****/

        return "1";
    }

}
