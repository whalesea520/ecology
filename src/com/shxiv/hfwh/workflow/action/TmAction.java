package com.shxiv.hfwh.workflow.action;

import com.weaver.general.BaseBean;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.RecordSet;
import weaver.formmode.setup.ModeRightInfo;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.MainTableInfo;
import weaver.soa.workflow.request.Property;
import weaver.soa.workflow.request.RequestInfo;
import weaver.workflow.workflow.WorkflowComInfo;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by zsd on 2019/3/4.
 */
public class TmAction extends BaseBean implements Action {

    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(TmAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################   开始调用条码控制Action     ###########################");
        RecordSet rss = new RecordSet();
        RecordSet rs1 = new RecordSet();
        RecordSet rs2 = new RecordSet();
        String tempMessage = "";
        try {
            WorkflowComInfo workflowComInfo = new WorkflowComInfo();
            int requestid = Util.getIntValue(request.getRequestid());//创建一个流程就生成唯一标识的请求ID
            int workflowid = Util.getIntValue(request.getWorkflowid());//流程ID
            int formid = Util.getIntValue(workflowComInfo.getFormId("" + workflowid));//表单ID 

            String xgrq="";
            String xgsj="";
            //主表数据
            /*MainTableInfo formtable_main_x = request.getMainTableInfo();
            Property[] properties = formtable_main_x.getProperty();
            for (int i = 0; i < properties.length; i++) {
                String fieldName = properties[i].getName();
                String fieldValue = Util.null2String(properties[i].getValue());
                if ("bsqf".equalsIgnoreCase(fieldName)) {
                    bsqf = fieldValue;
                }else if ("XGRQ".equalsIgnoreCase(fieldName)) {
                    xgrq = fieldValue;
                }else if ("XGSJ".equalsIgnoreCase(fieldName)) {
                    xgsj = fieldValue;
                }
            }*/

            //主表表名
            String mainTable = "formtable_main_" + ((-1) * formid);//获取到当前流程表单的主表表名

            //明细表名
            String mxTable = mainTable+"_dt1";//获取到当前流程表单的明细表名:主表_dtx

            String mainId="";//主表ID
            
            String bsqf="";//被授权方
            
            //通过流程生成唯一标识的请求ID获取到该流程对应的主表ID,被授权方,修改日期,修改时间
            String sqlMa="select id,bsqf,XGRQ,XGSJ from "+mainTable+" where requestId='"+requestid+"'  ";
            rs1.execute(sqlMa);
            if(rs1.next()){
                mainId=rs1.getString("id");
                bsqf = rs1.getString("bsqf");
                /*xgrq = rs1.getString("XGRQ");
                xgsj = rs1.getString("XGSJ");*/
            }

            //获取当前日期
            SimpleDateFormat format1=new SimpleDateFormat("yyyy-MM-dd");

            //获取当前时间
            SimpleDateFormat format2=new SimpleDateFormat("HH:mm");

            String nowDate=format1.format(new Date());

            String nowTime=format2.format(new Date());

            //根据主表ID查询出明细表表的颜色,色号,红纺款号,成衣条码,尺寸组,尺寸,尺寸值
            String sqlMx=" select ys2,ys1,hfkh,cytm,ccz,cc,ccz1  from "+mxTable+" where mainid='"+mainId+"' ";
            rss.execute(sqlMx);
            while (rss.next()){
                String ys=rss.getString("ys2");//颜色
                String sh=rss.getString("ys1");//色号
                String hfkh=rss.getString("hfkh");//红坊款号
                String tm=rss.getString("cytm");//成衣条码
                String ccz=rss.getString("ccz");//尺寸组
                String cc=rss.getString("cc");//尺寸
                String ccbm=rss.getString("ccz1");//尺寸值
                log.error("tm: "+tm);

                //条码是否已存在
                String cct="0";//判断值
                //根据明细表中每一条成衣条码查询出uf_FWBGLTZ(防伪标管理台账)表中tm(条码)是否有数据
                String sqlSf=" select count(*) as cct from  uf_FWBGLTZ  where tm='"+tm+"' ";
                log.error("sqlSf: "+sqlSf);
                rs1.execute(sqlSf);
                if(rs1.next()){
                    cct=rs1.getString("cct");//赋给判断值
                }
                log.error("cct: "+cct);
                //不存在，可以插入
                if("0".equals(cct)){//如果cct>0表示一直为flase不可以插入,cct=0为ture没有值,可以插入,执行下面语句
                    //获取当前年月日
                    SimpleDateFormat form1=new SimpleDateFormat("yyyy-MM-dd");
                    //获取当前时分秒
                    SimpleDateFormat form2=new SimpleDateFormat("HH:mm:ss");

                    String date=form1.format(new Date());

                    String time=form2.format(new Date());
                    //执行插入语句,插入到uf_FWBGLTZ(防伪标管理台账)表中
                    String sqlTi=" insert into uf_FWBGLTZ (bsqs,hfkh,tm,cc,ccbm,ccz,ys,XGRQ,XGSJ,sh,formmodeid,modedatacreater,modedatacreatedate,modedatacreatertype,modedatacreatetime,lcid) values ('"+bsqf+"','"+hfkh+"','"+tm+"','"+cc+"','"+ccbm+"','"+ccz+"','"+ys+"','"+nowDate+"','"+nowTime+"','"+sh+"','62','1','"+date+"','0','"+time+"','"+requestid+"') ";
                    log.error("sqlTi: "+sqlTi);
                    rs2.execute(sqlTi);

                    int bid=0;//uf_FWBGLTZ表ID
                    //根据明细表中每一条成衣条码查询出uf_FWBGLTZ(防伪标管理台账)表中每一个ID
                    String sqlId="select id from uf_FWBGLTZ where tm='"+tm+"' ";
                    rs2.execute(sqlId);
                    if(rs2.next()){
                        bid=Integer.parseInt(rs2.getString("id"));
                    }

                    ModeRightInfo ModeRightInfo = new ModeRightInfo();
                    ModeRightInfo.setNewRight(true);//为true调用以下方法
                    ModeRightInfo.editModeDataShare(1,62,bid);
                }
            }

            /*String cct="0";
            String cytm="";
            String sqlCo=" select COUNT(cytm) as ct,cytm,mainid from "+mxTable+"  group by cytm,mainid having  mainid='"+mainId+"' and COUNT(cytm)>1  ";
            rs2.execute(sqlCo);
            if(rs2.next()){
                cct=rs2.getString("ct");
                cytm=rs2.getString("cytm");
            }

            if(!"0".equals(cct)&&!"".equals(cct)){
                tempMessage = "成衣条码"+cytm+"重复。";
                request.getRequestManager().setMessageid("流程提交失败");
                request.getRequestManager().setMessagecontent(tempMessage);
                return "0";
            }*/

        } catch (Exception e) {
            tempMessage = ""+e;
            request.getRequestManager().setMessageid("流程提交失败");
            request.getRequestManager().setMessagecontent(tempMessage);
            return "0";
        }

        this.log.error("######################        调用条码控制Action end   ################################################");
        /***interface action  stop *****/

        return "1";
    }

}
