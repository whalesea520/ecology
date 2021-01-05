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
import java.util.ArrayList;
import java.util.List;

/**
 * Created by zsd on 2019/3/4.
 * 权益金控制
 */
public class QyjKzActionOld extends BaseBean implements Action {

    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(QyjKzAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################   开始调用权益金控制Action     ###########################");
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

            writeLog("");


            String cbhj="";//成本合计

            String bsqf="";//被授权方

            String qyh=""; //权益金合计

            String bqj="";//选择保底金期间

            String htbh="";//合同编号new

            String ckzje="";

            String htje="";

            String htqj="";//选择保底金期间

            //主表数据
            //获取主表的成本合计、被授权方、权利金合计、选择保底金期间、合同编号new
            MainTableInfo formtable_main_x = request.getMainTableInfo();
            Property[] properties = formtable_main_x.getProperty();
            for (int i = 0; i < properties.length; i++) {
                String fieldName = properties[i].getName();
                String fieldValue = Util.null2String(properties[i].getValue());
                if ("cbhj".equalsIgnoreCase(fieldName)) {
                    cbhj = fieldValue;
                }else if ("bsqf".equalsIgnoreCase(fieldName)) {
                    bsqf = fieldValue;
                }else if ("qljhj".equalsIgnoreCase(fieldName)) {
                    qyh = fieldValue;
                }else if ("xzbdjqj".equalsIgnoreCase(fieldName)) {
                    bqj = fieldValue;
                }else if ("htbh1".equalsIgnoreCase(fieldName)) {
                    htbh = fieldValue;
                }else if ("xzbdjqj".equalsIgnoreCase(fieldName)) {
                    htqj = fieldValue;
                }
            }

            log.error("xzbdjqj："+htqj);

            String mainId="";
            //根据唯一标识的ID查询主表的ID和选择保底金期间
            String sqlMa="select id,xzbdjqj from "+mainTable+" where requestId='"+requestid+"'  ";
            rs1.execute(sqlMa);
            if(rs1.next()){
                mainId=rs1.getString("id");//主表ID
                htqj=rs1.getString("xzbdjqj");//选择保底金期间
            }
            log.error("xzbdjqj2："+htqj);

            //客户关系：0内部；1外部
            String khgx="";
            //根据主表的被授权方查询uf_bsqssj(被授权商数据)表的kggx(客户关系)
            String sqlK="select kggx from uf_bsqssj where id='"+bsqf+"'";
            rss.execute(sqlK);
            if(rss.next()){
                khgx=rss.getString("kggx");
            }

            //客户关系：1外部
            //判断kggx(客户关系)为0(内部),跳过.kggx(客户关系)为1(外部)时执行以下操作:
            if("1".equals(khgx)){
                //是否计算权益金：0是；1否
                String sfQyj="";
                //是否计算成本：0是；1否
                String sfCb="";
                //合同类型：0销售；1权益金
                String htlx="";
                //根据主表的合同编号new查询uf_HTK(合同库)表的是否计算权益金、是否计算成本、合同类型
                String sqlT="select sfjsqyj,sfjscb,htlx from uf_HTK where id='"+htbh+"'";
                log.error("uf_HTK：" + sqlT);
                rss.execute(sqlT);
                if(rss.next()){
                    sfQyj=rss.getString("sfjsqyj");//是否计算权益金
                    sfCb=rss.getString("sfjscb");//是否计算成本
                    htlx=rss.getString("htlx");//合同类型
                }

                //计算成本
                //计算成本,
                if("0".equals(sfCb)){
                    double dd1=0;
                    if(!"".equals(cbhj)){
                        dd1=Double.valueOf(cbhj);//成本合计
                    }
                    log.error("dd1是："+dd1);

                    String cbje="0";
                    //根据主表的bsqf(被授权方)查询uf_sqscb(授权商成本)的cbje(成本金额)
                    String sqlC="select cbje from uf_sqscb where sqs='"+bsqf+"'";
                    rss.execute(sqlC);
                    if(rss.next()){
                        cbje=rss.getString("cbje");
                    }

                    double dd2=0;
                    if(!"".equals(cbje)){
                        dd2=Double.valueOf(cbje);
                    }
                    log.error("dd2是："+dd2);
                    double ddd=dd1-dd2;
                    log.error("结果是："+ddd);
                    //判断主表的成本合计减去授权商成本的成本金额,如果大于0,流程提交失败,报错:成本合计超出，不能提交。
                    if(ddd>0){
                        tempMessage = "成本合计超出，不能提交。";
                        request.getRequestManager().setMessageid("流程提交失败");
                        request.getRequestManager().setMessagecontent(tempMessage);
                        return "0";
                        //如果小于等于0,根据被授权方更新uf_sqscb(授权商成本)的cbje(成本金额)
                    }else {
                        BigDecimal bb1=new BigDecimal("0");
                        if(!"".equals(dd2)){
                            bb1=new BigDecimal(dd2);
                        }
                        BigDecimal bb2=new BigDecimal("0");
                        if(!"".equals(dd1)){
                            bb2=new BigDecimal(dd1);
                        }
                        BigDecimal bb3=new BigDecimal("0");
                        bb3=bb1.subtract(bb2).setScale(2,BigDecimal.ROUND_HALF_UP);

                        String sqlU="update uf_sqscb set cbje='"+bb3.toString()+"' where sqs='"+bsqf+"' ";
                        log.error("外部成本："+sqlU);
                        rss.execute(sqlU);

                    }
                }

                //计算权益金
                //计算权益金,根据主表的ID查询出明细表2的权利金的总和
                if("0".equals(sfQyj)){
                    double dd1=0;
                    String qyjSum="0";
                    String mxTable=mainTable+"_dt2";
                    String sqlSum="select  SUM(qlj) as sm  from "+mxTable+" where mainid='"+mainId+"' ";
                    log.error("权利金总和：" + sqlSum);
                    rss.execute(sqlSum);
                    if(rss.next()){
                        qyjSum=rss.getString("sm");
                    }
                    if(!"".equals(qyjSum)){
                        dd1=Double.valueOf(qyjSum);//权利金总和
                    }
                    log.error("sqlSum："+sqlSum);
                    //根据主表ID更新主表权益金合计字段
                    String sqlU1="update "+mainTable+" set qljhj='"+qyjSum+"' where id='"+mainId+"' ";
                    rss.execute(sqlU1);
                    log.error("更新权利金总和："+sqlU1);
                    String wsj="0";
                    //根据主表的选择保底金期间查询uf_HTK_dt8(合同库明细表8)的剩余保证金金额
                    String sqlC="select sybzjje from uf_HTK_dt8 where id='"+htqj+"'";
                    log.error("外部总权益金："+sqlC);
                    rss.execute(sqlC);
                    if(rss.next()){
                        wsj=rss.getString("sybzjje");//剩余保证金金额
                    }

                    double dd2=0;
                    if(!"".equals(wsj)){
                        dd2=Double.valueOf(wsj);
                    }
                    double ddd=dd1-dd2;
                    log.error("结果是："+ddd);
                    //判断权利金总和减去剩余保证金金额,如果大于0,流程提交失败,报错:权益金超出，不能提交。
                    if(ddd>0){
                        tempMessage = "权益金超出，不能提交。";
                        request.getRequestManager().setMessageid("流程提交失败");
                        request.getRequestManager().setMessagecontent(tempMessage);
                        return "0";
                    }else {
                        //获取最低保证金未税价
                        String zdb="0";
                        //获取累计防伪标权益金额
                        String ljj="0";
                        //获取主表ID
                        String mainid="";
                        //获取保底区间
                        String bzqj="";
                        //如果小于等于0,根据htqj查询htk_8(合同保底金查询)的剩余保证金金额、保证期间、累计防伪标权益金额
                        String sqlZd="select mainid,bzqj,sybzjje,ljfwbqyje from htk_8 where id='"+htqj+"'";
                        log.error("获取新合同保底金的剩余保证金金额、累计防伪标权益金额："+sqlZd);
                        rss.execute(sqlZd);
                        if(rss.next()){
                            mainid=rss.getString("mainid");//剩余保证金金额
                            bzqj=rss.getString("bzqj");//保证期间
                            zdb=rss.getString("sybzjje");//剩余保证金金额
                            ljj=rss.getString("ljfwbqyje");//累计防伪标权益金额
                        }

                        BigDecimal bb7=new BigDecimal("0");
                        if(!"".equals(zdb)){
                            bb7=new BigDecimal(zdb);
                        }
                        log.error("bb7-新合同保底金的剩余保证金金额："+bb7);
                        BigDecimal bb10=new BigDecimal("0");
                        if(!"".equals(ljj)){
                            bb10=new BigDecimal(ljj);
                        }
                        log.error("bb10-新合同保底金的累计防伪标权益金额："+bb10);
                        BigDecimal bb8=new BigDecimal("0");
                        if(!"".equals(qyh)){
                            bb8=new BigDecimal(qyh);//权益金合计
                        }
                        log.error("bb8-主表权益金合计："+bb8);
                        BigDecimal bb11=bb8.add(bb10);
                        log.error("bb11-累计防伪标权益金额："+bb11);

                        BigDecimal bb9=bb7.subtract(bb8);//剩余保证金金额减去权益金合计
                        log.error("bb9-剩余保证金金额减去权益金合计的余："+bb9);
                        double d3=bb9.doubleValue();
                        //剩余保证金金额减去权益金合计大于等于0，更新uf_htk_dt8(合同库明细表8)的剩余保证金金额和累计防伪标权益金额
                        if(d3>=0){
                            String sqlU3="update uf_htk_dt18 set zljfwbqyje='"+bb11.toString()+"',zsybzjje='"+bb9.toString()+"'  where id='"+htqj+"' ";
                            log.error("更新合同库明细表15: "+sqlU3);
                            rss.execute(sqlU3);
                        }

                        List<String> sybzjjeList=new ArrayList<String>();
                        List<String> idList=new ArrayList<String>();
                        String id="";//id
                        String sybzjje="";//明细表8中保证区间对应的付款笔数的剩余保证金金额

                        String sqlZM="select b.id,b.htbh,b.bzqj,b.bzqjs,b.bzqks,b.fkbs,b.sybzjje from HTK_15 a JOIN htk_8 b ON a.mainid=b.mainid and a.bzqj=b.bzqj where  a.mainid='"+mainid+"' and  a.bzqj='"+bzqj+"' ";
                        log.error("关联合同明细表15和明细表8："+sqlZM);
                        rs2.execute(sqlZM);
                        while(rs2.next()){
                            id=rs2.getString("id");//id
                            sybzjje=rs2.getString("sybzjje");//剩余保证金金额
                            idList.add(id);
                            sybzjjeList.add(sybzjje);
                        }
                        log.error("剩余保证金金额集合: " + sybzjjeList.toString());
                        log.error("id集合: " + idList.toString());
                        String aString="";
                        BigDecimal bb3=new BigDecimal("0");
                        for(int i=0;i<sybzjjeList.size();i++){
                            if("".equals(sybzjjeList.get(i))){
                                aString="0";
                            }else{
                                aString=sybzjjeList.get(i);
                            }

                            BigDecimal bb2=new BigDecimal("0");
                            if(!"".equals(aString)){
                                bb2=new BigDecimal(aString);
                            }
                            log.error("bb2:" + bb2);

                            log.error("开始的值：" + bb3);
                            BigDecimal bb4=bb2.subtract(bb8);
                            log.error("bb4:" + bb4);

                            BigDecimal bb5=bb4.add(bb3);
                            log.error("bb5:" + bb5);

                            Double b=bb5.doubleValue();
                            if(b<=0){
                                if(i>0){
                                    bb3=bb2.add(bb3);
                                    log.error("bb3:" + bb3);
                                    sybzjjeList.set(i, "0.00");
                                }else{
                                    bb3=bb2;
                                    log.error("bb3:" + bb3);
                                    sybzjjeList.set(i, "0.00");
                                }
                            }else{
                                sybzjjeList.set(i, bb5.toString());
                                break;
                            }

                        }
                        log.error("新的剩余保证金金额集合：" + sybzjjeList.toString());

                        for(int i=0;i<idList.size();i++){
                            String sql="update uf_HTK_dt8  set sybzjje='"+sybzjjeList.get(i)+"' where id='"+idList.get(i)+"' ";
                            log.error("更新uf_HTK_dt8的明细：" + sybzjjeList.toString());
                            rs2.execute(sql);
                        }


                    }
                }
            }
        } catch (Exception e) {
            tempMessage = ""+e;
            request.getRequestManager().setMessageid("流程提交失败");
            request.getRequestManager().setMessagecontent(tempMessage);
            return "0";
        }

        this.log.error("######################        调用权益金控制Action end   ################################################");
        /***interface action  stop *****/

        return "1";
    }

}
