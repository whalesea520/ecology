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
public class QyjKjActionOld extends BaseBean implements Action {

    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(QyjKjActionOld.class.getName());

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
            String mainTable = "formtable_main_" + ((-1) * formid);

            String mainId="";
            //根据唯一标识的请求ID查询主表ID
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
            MainTableInfo formtable_main_x = request.getMainTableInfo();
            Property[] properties = formtable_main_x.getProperty();
            for (int i = 0; i < properties.length; i++) {
                String fieldName = properties[i].getName();
                String fieldValue = Util.null2String(properties[i].getValue());
                if ("htbh1".equalsIgnoreCase(fieldName)) {
                    htbh = fieldValue;//合同编号new
                }else if ("sqrq".equalsIgnoreCase(fieldName)) {
                    sqrq = fieldValue;//申请日期
                }else if ("bsqf".equalsIgnoreCase(fieldName)) {
                    bsqf = fieldValue;//被授权方
                }else if ("ckzje".equalsIgnoreCase(fieldName)) {
                    ckzje = fieldValue;//出库总金额
                }else if ("dqkycbje".equalsIgnoreCase(fieldName)) {
                    cbdj = fieldValue;//当前可用成本金额
                }else if ("dqkybdje".equalsIgnoreCase(fieldName)) {
                    qydj = fieldValue;//当前可用保底金额
                }else if ("cbhj".equalsIgnoreCase(fieldName)) {
                    cbhj = fieldValue;//成本合计
                }else if ("fktzcx".equalsIgnoreCase(fieldName)) {
                    htqj = fieldValue;//选择保底金期间
                }else if ("qljhj".equalsIgnoreCase(fieldName)) {
                    qyhj = fieldValue;//权利金合计
                }
            }

            //客户关系：0内部；1外部
            String khgx="";
            //根据主表的被授权方查询被授权商数据表(uf_bsqssj)的kggx(客户关系:0内部,1外部)
            String sqlK="select kggx from uf_bsqssj where id='"+bsqf+"'";
            log.error("外部sqlK: "+sqlK);
            rs1.execute(sqlK);
            if(rs1.next()){
                khgx=rs1.getString("kggx");
            }

            //明细表1
            String mxTable1 = mainTable + "_dt1";

            //客户关系：1外部才执行以下操作
            if("1".equals(khgx)){

                //是否计算权益金：0是；1否
                String sfQyj="";

                //是否计算成本：0是；1否
                String sfCb="";

                //合同类型：0销售；1权益金
                String htlx="";

                //价格种类：0批发价；1零售价；2出厂价
                String jzl="";

                String tid="";
                //根据主表的被授权方查询对应合同库(uf_HTK)表中的ID、是否计算权益金、是否计算成本、合同类型、计算价格种类
                String sqlT="select id,sfjsqyj,sfjscb,htlx,jsjgzl from uf_HTK where id='"+htbh+"'";
                rss.execute(sqlT);
                if(rss.next()){
                    tid=rss.getString("id");//ID
                    sfQyj=rss.getString("sfjsqyj");//是否计算权益金
                    sfCb=rss.getString("sfjscb");//是否计算成本
                    htlx=rss.getString("htlx");//合同类型
                    jzl=rss.getString("jsjgzl");//计算价格种类
                }


                BigDecimal bb1=new BigDecimal("0");
                if(!"".equals(ckzje)){
                    bb1=new BigDecimal(ckzje);//出库总金额
                }

                log.error("外部出库金额: "+ckzje);

                String cbje="0";
                //根据主表的被授权方查询授权商成本的成本金额
                String sqlC="select cbje from uf_sqscb where sqs='"+bsqf+"'";
                rss.execute(sqlC);
                if(rss.next()){
                    cbje=rss.getString("cbje");//成本金额
                }

                BigDecimal bb2=new BigDecimal("0");
                if(!"".equals(cbje)){
                    bb2=new BigDecimal(cbje);//成本金额
                }

                BigDecimal bb3=bb2.subtract(bb1);
                double d1=bb3.doubleValue();
                //根据主表的被授权方更新授权商成本的成本金额=成本金额-出库总金额
                String sqlU1="update uf_sqscb set cbje='"+d1+"' where sqs='"+bsqf+"' ";
                log.error("外部sqlU1: "+sqlU1);
                rss.execute(sqlU1);

                //权益金扣减-非销售类型
                if(!"0".equals(htlx)){
                    //获取最低保证金未税价
                    String zdb="0";
                    //获取累计防伪标权益金额
                    String ljj="0";
                    //根据主表的选择保底金期间查询htk_8(合同保底金查询)的到账未税金额、累计防伪标权益金额
                    String sqlZd="select dzwsje,ljfwbqyje from htk_8 where id='"+htqj+"'";
                    rs3.execute(sqlZd);
                    if(rs3.next()){
                        zdb=rs3.getString("dzwsje");
                        ljj=rs3.getString("ljfwbqyje");
                    }

                    BigDecimal bb7=new BigDecimal("0");
                    if(!"".equals(zdb)){
                        bb7=new BigDecimal(zdb);//到账未税金额
                    }

                    BigDecimal bb10=new BigDecimal("0");
                    if(!"".equals(ljj)){
                        bb10=new BigDecimal(ljj);//累计防伪标权益金额
                    }

                    BigDecimal bb8=new BigDecimal("0");
                    if(!"".equals(qyhj)){
                        bb8=new BigDecimal(qyhj);//权利金合计
                    }

                    BigDecimal bb11=bb8.add(bb10);//权利金合计+累计防伪标权益金额
                    double d4=bb11.doubleValue();

                    BigDecimal bb9=bb7.subtract(bb11);//到账未税金额-(权利金合计+累计防伪标权益金额)
                    double d3=bb9.doubleValue();
                    if(d3>=0){
                    	//到账未税金额减去累计防伪标权益金额大于等于0更新合同库明细表8的累计防伪标权益金额和剩余保证金金额
                        String sqlU3="update uf_htk_dt8 set ljfwbqyje='"+d4+"',sybzjje='"+d3+"'  where id='"+htqj+"' ";
                        log.error("外部sqlU3: "+sqlU3);
                        rs3.execute(sqlU3);
                    }

                }

            }else{//客户关系：0内部
                BigDecimal bb1=new BigDecimal("0");
                if(!"".equals(ckzje)){
                    bb1=new BigDecimal(ckzje);
                }
                log.error("内部出库金额: "+ckzje);

                String cbje="0";
                //根据主表的被授权方查询授权商成本的成本金额
                String sqlC="select cbje from uf_sqscb where sqs='"+bsqf+"'";
                rss.execute(sqlC);
                if(rss.next()){
                    cbje=rss.getString("cbje");
                }

                BigDecimal bb2=new BigDecimal("0");
                if(!"".equals(cbje)){
                    bb2=new BigDecimal(cbje);
                }

                BigDecimal bb3=bb2.subtract(bb1);//成本金额+出库总金额
                double d1=bb3.doubleValue();
                //更新授权商成本的成本金额=成本金额+出库总金额
                String sqlU="update uf_sqscb set cbje='"+d1+"' where sqs='"+bsqf+"' ";
                log.error("内部sqlU: "+sqlU);
                rss.execute(sqlU);
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
