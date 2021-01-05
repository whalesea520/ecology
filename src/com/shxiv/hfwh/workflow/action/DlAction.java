package com.shxiv.hfwh.workflow.action;

import com.weaver.general.BaseBean;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;
import weaver.workflow.workflow.WorkflowComInfo;


/**
 * Created by zsd on 2019/3/4.
 */
public class DlAction extends BaseBean implements Action {

    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(DlAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################   开始调用大类控制Action     ###########################");
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

            //明细表名
            String mxTable = mainTable+"_dt1";//获取到当前流程表单的明细表名:主表_dtx

            String mainId="";//主表ID

            String bsf="";//被授权方
            
            String htbh="";//合同编号new

            //主表数据
            //通过流程生成唯一标识的请求ID获取到该流程对应的主表ID,被授权方,合同编号new
            String sqlMa="select id,htbh1,bsqf from "+mainTable+" where requestId='"+requestid+"'  ";
            rs1.execute(sqlMa);
            if(rs1.next()){
                mainId=rs1.getString("id");
                htbh=rs1.getString("htbh1");
                bsf=rs1.getString("bsqf");
            }

            //判断是否内部用户
            String khx="1";//默认客户关系.客户关系:0或者1
            String sqlB=" select kggx from uf_bsqssj where id='"+bsf+"' ";//根据被授权方查询被授权商数据表,查询出kggx:客户关系
            rs2.execute(sqlB);
            if(rs2.next()){
                khx=rs2.getString("kggx");//查询出客户关系
            }

            if("1".equals(khx)){//对比客户关系,如果是1,则为ture,执行下面操作
                String sqlMx=" select * from "+mxTable+" where mainid='"+mainId+"' ";//根据主表ID查询出这个ID对应的明细表所有数据
                rss.execute(sqlMx);
                while (rss.next()){
                    String fwbdl=rss.getString("fwbdl");//获取每条明细对应的防伪标大类

                    //是否启用
                    String ct1="0";//判断是否有数据:有1无0
                    //查询出uf_dl表中sfky字段:是否可用(只有0)可用并且uf_dl表的ID=根据上述的每条明细对应的防伪标大类(fwbdl)查出uf_dldyb(大类对应表)表的spdl字段(商品大类)
                    String sqlSf=" select COUNT(*) as ct1 from uf_dl where sfky='0' and id=(select spdl from uf_dldyb where fwbpx='"+fwbdl+"')  ";
                    /*log.error("sqlSf: "+sqlSf);*/
                    rs1.execute(sqlSf);
                    if(rs1.next()){
                        ct1=rs1.getString("ct1");//查询出ct1的值
                    }

                    if(!"0".equals(ct1)){//判断是否为true,是执行下面操作
                        String cct="0";
                      //查询出uf_dl表中sfky字段:是否可用(只有0)可用并且uf_dl表的ID=根据上述的每条明细对应的防伪标大类(fwbdl)查出uf_dldyb(大类对应表)表的spdl字段(商品大类)并且 ID还得满足=先根据主表查询出来的htbh(合同编号new)查询uf_HTK(合同库)合同库ID然后根据合同库ID查询出合同明细表对应的dl----合同明细表数据字典没有显示出来
                        String sqlS=" select COUNT(*) as cct from uf_dl where sfky='0' and id=(select spdl from uf_dldyb where fwbpx='"+fwbdl+"' ) and id in(select dl from uf_HTK_dt1 where mainid=(select id from uf_HTK where id='"+htbh+"' )) ";
                        /*log.error("sqlS: "+sqlS);*/
                        rs1.execute(sqlS);
                        if(rs1.next()){
                            cct=rs1.getString("cct");//查询出cct的值
                        }
                        //不存在，可以插入
                        if("0".equals(cct)){//对比,如果为ture,明细表防伪标大类不在合同中,流程提交失败,如果为false,明细表防伪标大类在合同中有一条数据或者多条数据,执行后面逻辑
                            tempMessage = "明细表防伪标大类不在合同中。";
                            request.getRequestManager().setMessageid("流程提交失败");
                            request.getRequestManager().setMessagecontent(tempMessage);
                            return "0";

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

        this.log.error("######################        调用大类控制Action end   ################################################");
        /***interface action  stop *****/

        return "1";
    }

}
