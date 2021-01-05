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
public class MxFzAction extends BaseBean implements Action {

    /**
     * log 对象
     */
    private Log log = LogFactory.getLog(MxFzAction.class.getName());

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################   开始调用明细赋值Action     ###########################");
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

            //主表信息查询
            String sqlMa="select id from "+mainTable+" where requestId='"+requestid+"'  ";//查询出主表ID
            rs1.execute(sqlMa);
            if(rs1.next()){
                mainId=rs1.getString("id");
            }

            //明细表1
            String mxTable1 = mainTable+"_dt1";//获取到当前流程表单的明细表名:主表_dtx

            //获取明细表数据
            String sqlMx=" select*from "+mxTable1+" where mainid='"+mainId+"' ";//根据主表ID查询出明细表数据
            rss.execute(sqlMx);
            while (rss.next()){
                String mxId=rss.getString("id");//明细表ID
                
                String kh=rss.getString("hfkh");//红纺款号

                String ys2=rss.getString("ys2");//明细表中颜色

                String ys="";//商品送审流程台账中颜色

                String spmc="";//商品名称

                String hfkh="";//红纺款号

                String bzj="";//标准价

                String ccj="";//出厂价

                String pfj="";//批发价

                String ccz1="";//尺寸组

                String sspp1="";//授权品牌

                String ssrq="";//上市日期

                String xl="";//小类
                //根据红坊款号查询uf_spsslc(商品送审流程台账)表中颜色,商品名称,红纺款号,标准价,出厂价,批发价,尺寸组,授权品牌,上市日期,小类
                String sqlY=" select b.ys,a.spmc,a.hfkh,a.bzj,a.ccj,a.pfj,a.ccz,a.sspp1,a.ssrq,a.xl from uf_spsslc a left join uf_bysdyb b on a.sspp1=b.pp where a.id='"+kh+"' ";
                rs1.execute(sqlY);
                if(rs1.next()){
                    ys=rs1.getString("ys");
                    spmc=rs1.getString("spmc");
                    hfkh=rs1.getString("hfkh");
                    bzj=rs1.getString("bzj");
                    ccj=rs1.getString("ccj");
                    pfj=rs1.getString("pfj");
                    ccz1=rs1.getString("ccz");
                    sspp1=rs1.getString("sspp1");
                    ssrq=rs1.getString("ssrq");
                    xl=rs1.getString("xl");
                }



                //颜色信息
                String yswb="";//uf_ys（颜色）表中的色号
                String shy="";//uf_ys（颜色）表中的颜色
                
                //根据明细表中的颜色获取uf_ys（颜色）表中的色号、颜色
                String sqlYs="select ys,sh from uf_ys where id='"+ys2+"'";
                rs1.execute(sqlYs);
                if(rs1.next()){
                    yswb=rs1.getString("ys");
                    shy=rs1.getString("sh");
                }

                //尺寸信息
                String ccn="";//尺寸ID
                String ccy="";//尺寸值
                String ccc=rss.getString("ccc");//获取明细表中的尺寸
                //根据明细表中的尺寸和uf_spsslc(商品送审流程台账)表中ccz(尺寸组)获取uf_cc(尺寸)表获取ID、值
                String sqlCc="select id,cc from uf_cc where ms='"+ccc+"' and ccz='"+ccz1+"' ";
                rs1.execute(sqlCc);
                if(rs1.next()){
                    ccy=rs1.getString("cc");
                    ccn=rs1.getString("id");
                }
                //判断尺寸值是否存在,不存在,流程提交失败,报错:信息找不到。存在执行以下操作：
                if("".equals(ccy)){
                    tempMessage = "尺寸信息找不到。";
                    request.getRequestManager().setMessageid("流程提交失败");
                    request.getRequestManager().setMessagecontent(tempMessage);
                    return "0";
                }

                String jgd1=rss.getString("jgd"); //价格段
               
                String fwbdl=rss.getString("fwbdl"); //防伪标大类

                String cgj="";//防伪标成本

                String wlbm=""; //防伪标编码

                String wltm="";//防伪标条码

                String wlmc="";//防伪标名称
                
                //根据明细表中的价格段、防伪标大类和uf_spsslc(商品送审流程台账)表中颜色查询出uf_fljcb（辅料基础表）表中防伪标成本、防伪标编码、防伪标条码、防伪标名称
                String sqlS=" select cgj,wlbm,wltm,wlmc from uf_fljcb where jgd1='"+jgd1+"' and sh='"+ys+"' and fwbdl='"+fwbdl+"'  ";
                rs1.execute(sqlS);
                if(rs1.next()){
                    cgj=rs1.getString("cgj");
                    wlbm=rs1.getString("wlbm");
                    wltm=rs1.getString("wltm");
                    wlmc=rs1.getString("wlmc");
                }

                //成衣条码:红纺款号文本+色号+尺寸值
                String hfwb=hfkh;//uf_spsslc(商品送审流程台账)表中红纺款号

                String ccz=ccy;//ccz(尺寸组)中的尺寸值

                String sh=shy;//uf_ys（颜色）表中的颜色

                String cytm=hfwb+sh+ccz;//成衣条码

                //防伪标总成本计算

                String lysl=rss.getString("lysl"); //领用数量

                //用来对超过16位有效位的数进行精确的运算的API
                BigDecimal bb1=new BigDecimal("0");
                
                if(!"".equals(lysl)){
                    bb1=new BigDecimal(lysl);//领用数量
                }

                BigDecimal bb2=new BigDecimal("0");
                if(!"".equals(cgj)){
                    bb2=new BigDecimal(cgj);//防伪标成本
                }

                BigDecimal bb3=bb1.multiply(bb2);//领用数量和明细表中的防伪标成本的值相乘，返回BigDecimal对象
                
                //uf_spsslc(商品送审流程台账)表中出厂价
                if("".equals(ccj)){
                    ccj="0";
                }
                
                //uf_spsslc(商品送审流程台账)表中批发价
                if("".equals(pfj)){
                    pfj="0";
                }

                //uf_spsslc(商品送审流程台账)表中标准价
                if("".equals(bzj)){
                    bzj="0";
                }
                //更新主表信息
                String sqlU1="update "+mxTable1+" set cytm='"+cytm+"',fwbcb='"+cgj+"',fwbbm='"+wlbm+"',fwbtm='"+wltm+"',fwbmc='"+wlmc+"',bys='"+ys+"',fwbzcbje='"+bb3.toString()+"',mc='"+spmc+"',hfkhwb='"+hfkh+"',lsj='"+bzj+"',ccj='"+ccj+"',pfj='"+pfj+"',ccz='"+ccz1+"',sspp='"+sspp1+"',ssrq='"+ssrq+"',xl='"+xl+"',ys='"+yswb+"',ys1='"+shy+"',ccz1='"+ccy+"',cc='"+ccn+"'   where id='"+mxId+"'  ";
                rs2.execute(sqlU1);
            }

        } catch (Exception e) {
            tempMessage = ""+e;
            request.getRequestManager().setMessageid("流程提交失败");
            request.getRequestManager().setMessagecontent(tempMessage);
            return "0";
        }

        this.log.error("######################        调用调用明细赋值Action end   ################################################");
        /***interface action  stop *****/

        return "1";
    }

}
