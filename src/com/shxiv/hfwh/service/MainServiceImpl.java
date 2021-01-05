//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.shxiv.hfwh.service;

import com.shxiv.hfwh.service.dto.MessageDto;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.RecordSet;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class MainServiceImpl {
    private Log log = LogFactory.getLog("获取数据：");

    public MainServiceImpl() {
    }
    @SuppressWarnings("unchecked")
    public List<MessageDto> getMsg(String var1, String var2) {
        RecordSet var3 = new RecordSet();
        ArrayList var4 = new ArrayList();
        StringBuilder var5 = new StringBuilder();
        var5.append(" select distinct t.pp from crm_customerinfo c ");
        var5.append(" left join uf_zhkt z on c.PortalLoginid=z.zh ");
        var5.append(" left join uf_bsqssj b on z.bsqs=b.id ");
        var5.append(" left join uf_HTK h on b.id=h.bsqgs ");
        var5.append(" left join uf_sspp t on h.sqip=t.id ");
        var5.append(" where c.id=\'" + var1 + "\' and CONVERT(varchar(10),GETDATE(),120) between h.htksrq and h.htjsrq ");
        if(!"".equals(var2) && var2 != null) {
            var5.append(" and t.pp like\'%" + var2 + "%\'");
        }

        String var6 = var5.toString();
        this.log.error("SQL1:" + var6);
        var3.execute(var6);

        while(var3.next()) {
            String var7 = var3.getString("pp");
            if(!"".equals(var7)) {
                MessageDto var8 = new MessageDto();
                var8.setIpName(var7);
                var4.add(var8);
            }
        }

        return var4;
    }
    @SuppressWarnings("unchecked")
    public String getXsMsg(String var1) {
        RecordSet var2 = new RecordSet();
        String var3 = "";
        StringBuilder var4 = new StringBuilder();
        var4.append(" select distinct b.qd from crm_customerinfo c ");
        var4.append(" left join uf_zhkt z on c.PortalLoginid=z.zh ");
        var4.append(" left join uf_bsqssj b on z.bsqs=b.id ");
        var4.append(" where c.id=\'" + var1 + "\' ");
        String var5 = var4.toString();
        this.log.error("线上线下SQL: " + var5);
        var2.execute(var5);
        if(var2.next()) {
            var3 = var2.getString("qd");
        }

        return var3;
    }
    @SuppressWarnings("unchecked")
    public List<MessageDto> getTkMsg(String var1, String var2, String var3, String var4) {
        new RecordSet();
        RecordSet var6 = new RecordSet();
        RecordSet var7 = new RecordSet();
        ArrayList var8 = new ArrayList();
        String var9 = "select u.* from uf_TCGL u left join uf_sspp t on u.sqip=t.id where t.pp=\'" + var2 + "\' and u.tkc=\'" + var4 + "\' and u.sqqd=\'" + var3 + "\'";
        this.log.error("SQL2: " + var9);
        var6.execute(var9);

        while(var6.next()) {
            MessageDto var10 = new MessageDto();
            String var11 = var6.getString("pdf");
            String var12 = "";
            if(!"".equals(var11)) {
                var7.execute("select imagefileid from DocImageFile where docid = " + var11);
                if(var7.next()) {
                    var12 = var7.getString("imagefileid");
                }

                if(!"".equals(var12)) {
                    var10.setPdfId(var12);
                    String var13 = var6.getString("fm");
                    String var14 = "";
                    var7.execute("select imagefileid from DocImageFile where docid = " + var13);
                    if(var7.next()) {
                        var14 = var7.getString("imagefileid");
                    }

                    var10.setFmId(var14);
                    var10.setTcId(var6.getString("id"));
                    var10.setTcName(var6.getString("tcmc"));
                    var10.setTcBm(var6.getString("tcbm"));
                    var10.setTcIp(var6.getString("sqip"));
                    String var15 = "0";
                    String var16 = "select COUNT(*) as sc from uf_scb where userid=\'" + var1 + "\' and tcId=\'" + var10.getTcId() + "\'";
                    var7.execute(var16);
                    if(var7.next()) {
                        var15 = var7.getString("sc");
                    }

                    if("0".equals(var15)) {
                        var10.setIsSc("0");
                    } else {
                        var10.setIsSc("1");
                    }

                    var8.add(var10);
                }
            }
        }

        return var8;
    }
    @SuppressWarnings("unchecked")
    public boolean addSc(String var1, String var2) {
        RecordSet var3 = new RecordSet();
        boolean var4 = true;
        SimpleDateFormat var5 = new SimpleDateFormat("yyyy-MM-dd");
        String var6 = var5.format(new Date());
        String var7 = "insert into uf_scb(tcId,userId,scRq,isSc) values (\'" + var2 + "\',\'" + var1 + "\',\'" + var6 + "\',\'1\') ";
        var4 = var3.execute(var7);
        return var4;
    }

    public boolean deleteSc(String var1, String var2) {
        RecordSet var3 = new RecordSet();
        boolean var4 = true;
        String var5 = "delete uf_scb where tcId=\'" + var2 + "\' and userId=\'" + var1 + "\' ";
        var4 = var3.execute(var5);
        return var4;
    }
    @SuppressWarnings("unchecked")
    public boolean checkTc(String var1, String var2, String var3, String var4, String var5) {
        /*
            var1=userId=83
            var3=tcId=124
            var2=tcIp=2
            var4=tpbm
            var5=tpmc
         */
        boolean var6 = false;
        RecordSet var7 = new RecordSet();
        RecordSet var8 = new RecordSet();
        RecordSet var9 = new RecordSet();
        RecordSet var10 = new RecordSet();
        String var11 = "0";
        /*
            根据url传过来的客户ID和下载ID(品牌ID)和图册名称和下载日期查询客户下载日志记录表查询是否有数据,
            如果没有数据执行以下代码
            如果有数据往图片下载日志表和图片下载统计表里面插入数据
         */
        String var12 = " select COUNT(*) as yxz from uf_KHXZRZJB where khmc=\'" + var1 + "\' and xzip=\'" + var2 + "\' and tcmc=\'" + var3 + "\' and left(xzrq,4)=DATENAME(YEAR,GETDATE()) ";
        this.log.error("sqlXz：" + var12);
        var9.execute(var12);
        if(var9.next()) {
            var11 = var9.getString("yxz");
        }

        this.log.error("yxz：" + var11);
        String var13;
        String var14;
        if("0".equals(var11)) {
            var13 = "0";
            /*
                根据图册名称查询图册管理表(uf_TCGL)中的授权渠道(线上或者线下)
             */
            var14 = " select sqqd from uf_TCGL where id=\'" + var3 + "\' ";
            var10.execute(var14);
            if(var10.next()) {
                var13 = var10.getString("sqqd");
            }

            int var15 = 0;
            boolean var16 = false;
            String var17 = "";
            String var18 = "";
            /*
                根据客户ID查询出合同库的大类(大类进行排重查询)
             */
            StringBuilder var19 = new StringBuilder();
            var19.append(" select distinct d.dl from crm_customerinfo c ");
            var19.append(" left join uf_zhkt z on c.PortalLoginid=z.zh ");
            var19.append(" left join uf_bsqssj b on z.bsqs=b.id ");
            var19.append(" left join uf_HTK h on b.id=h.bsqgs ");
            var19.append(" left join uf_HTK_dt1 d on h.id=d.mainid ");
            var19.append(" where c.id=\'" + var1 + "\' and CONVERT(varchar(10),GETDATE(),120) between h.htksrq and h.htjsrq  ");
            String var20 = var19.toString();
            this.log.error("校验SQL是：" + var20);
            var7.execute(var20);

            while(var7.next()) {
                var18 = var7.getString("dl");
                /*
                    判断大类是否为空,如果不为空,往下执行,如果为空,则不执行以下操作,
                    就不为往图册管理的表执行任何操作,图片也不能下载
                 */
                if(!"".equals(var18) && var18 != null) {
                    String var21 = "select  SUM(isnull(u.xzsl,0)) as ct  from uf_dl d left join uf_XZTCSLB u on d.jb=u.jb  left join uf_nf n on u.nf=n.id where d.id=\'" + var18 + "\' and n.nf=DATENAME(YEAR,GETDATE()) and u.ip=\'" + var2 + "\' and u.qdlx=\'" + var13 + "\' ";
                    this.log.error("级别SQL：" + var21);
                    var8.execute(var21);
                    if(var8.next()) {
                        var17 = var8.getString("ct");
                    }

                    if(!"".equals(var17) && var17 != null) {
                        int var32 = Integer.parseInt(var17);
                        if(var32 > var15) {
                            var15 = var32;
                        }
                    }
                }
            }

            this.log.error("可下载数量：" + var15);
            int var34 = 0;
            String var22 = "select COUNT(*) as ct1 from uf_TCGL where sqip=\'" + var2 + "\' and id in(select distinct mainid from uf_TCGL_dt1 where " +
                    " in(select tpmc from uf_tpxzb where khmc=\'" + var1 + "\' and  left(xzrq,4)=DATENAME(YEAR,GETDATE()) ) ) ";
            var9.execute(var22);
            if(var9.next()) {
                var34 = Integer.parseInt(var9.getString("ct1"));
            }

            this.log.error("已下载数量：" + var34);
            int var23 = var15 - var34;
            if(var23 >= 1) {
                String var24 = "";
                String var25 = "select PortalLoginid as zh from crm_customerinfo where id=\'" + var1 + "\' ";
                var9.execute(var25);
                if(var9.next()) {
                    var24 = var9.getString("zh");
                }

                String var26 = " insert into uf_KHXZRZJB(khmc,tcmc,xzzh,xzrq,xzip,formmodeid,modedatacreatedate,modedatacreater,xzqd)values(\'" + var1 + "\',\'" + var3 + "\',\'" + var24 + "\',CONVERT(varchar(10),GETDATE(),120),\'" + var2 + "\',\'77\',CONVERT(varchar(10),GETDATE(),120),\'" + var1 + "\',\'" + var13 + "\') ";
                var6 = var9.execute(var26);
                int var27 = var23 - 1;
                String var28 = "0";
                String var29 = " select count(*) as cz  from uf_khxzb where khmc=\'" + var1 + "\' ";
                var8.execute(var29);
                if(var8.next()) {
                    var28 = var8.getString("cz");
                }

                this.log.error("cz: " + var28);
                String var30 = "";
                if("0".equals(var28)) {
                    var30 = " insert into uf_khxzb (khmc,xzzh,kysl,sysl,xzrq,formmodeid,ip,qd) values (\'" + var1 + "\',\'" + var24 + "\',\'" + var15 + "\',\'" + var27 + "\',CONVERT(varchar(10),GETDATE(),120),\'90\',\'" + var2 + "\',\'" + var13 + "\') ";
                } else {
                    var30 = " update uf_khxzb set kysl=\'" + var15 + "\',sysl=\'" + var27 + "\',xzrq=CONVERT(varchar(10),GETDATE(),120)  where  khmc=\'" + var1 + "\' and ip=\'" + var2 + "\' and qd=\'" + var13 + "\' ";
                }

                this.log.error("sqlKh: " + var30);
                var8.execute(var30);
            }
        } else {
            var6 = true;
        }

        if(var6) {
            var13 = "insert into uf_tplog (khmc,tpmc,sstc,tpid,xzrq) values (\'" + var1 + "\',\'" + var5 + "\',\'" + var3 + "\',\'" + var4 + "\',CONVERT(varchar(10),GETDATE(),120))";
            var8.execute(var13);
            var14 = "0";
            String var31 = "select count(*) as ct from uf_tpxzb where khmc=\'" + var1 + "\' and sstc=\'" + var3 + "\' and tpid=\'" + var4 + "\'";
            this.log.error("sqlCz: " + var31);
            var8.execute(var31);
            if(var8.next()) {
                var14 = var8.getString("ct");
            }

            this.log.error("cct: " + var14);
            if("0".equals(var14)) {
                String var33 = "insert into uf_tpxzb (khmc,tpmc,sstc,tpid,xzrq,formmodeid,tcip) values (\'" + var1 + "\',\'" + var5 + "\',\'" + var3 + "\',\'" + var4 + "\',CONVERT(varchar(10),GETDATE(),120),\'91\',\'" + var2 + "\')";
                var8.execute(var33);
            }
        }

        this.log.error("结果是：" + var6);
        return var6;
    }

    public List<MessageDto> getTpMsg(String var1, String var2) {
        RecordSet var3 = new RecordSet();
        RecordSet var4 = new RecordSet();
        ArrayList var5 = new ArrayList();
        String var6 = "select*from  uf_TCGL_dt1 where mainid=\'" + var2 + "\'";
        this.log.error("图片SQL1:" + var6);
        var3.execute(var6);

        while(var3.next()) {
            MessageDto var7 = new MessageDto();
            String var8 = var3.getString("AI");
            String var9 = var3.getString("PNG");
            String var10 = var3.getString("JPG");
            String var11 = var3.getString("PSD");
            String var12 = var3.getString("EPS");
            if(!"".equals(var8)) {
                var4.execute("select imagefileid from DocImageFile where docid = " + var8);
                if(var4.next()) {
                    var8 = var4.getString("imagefileid");
                }
            }

            if(!"".equals(var9)) {
                var4.execute("select imagefileid from DocImageFile where docid = " + var9);
                if(var4.next()) {
                    var9 = var4.getString("imagefileid");
                }
            }

            if(!"".equals(var10)) {
                var4.execute("select imagefileid from DocImageFile where docid = " + var10);
                if(var4.next()) {
                    var10 = var4.getString("imagefileid");
                }
            }

            if(!"".equals(var11)) {
                var4.execute("select imagefileid from DocImageFile where docid = " + var11);
                if(var4.next()) {
                    var11 = var4.getString("imagefileid");
                }
            }

            if(!"".equals(var12)) {
                var4.execute("select imagefileid from DocImageFile where docid = " + var12);
                if(var4.next()) {
                    var12 = var4.getString("imagefileid");
                }
            }

            var7.setMfmId(var10);
            var7.setAi(var8);
            var7.setPsd(var11);
            var7.setJpg(var10);
            var7.setPng(var9);
            var7.setEps(var12);
            var7.setTcName(var3.getString("tpmc"));
            var7.setTcBm(var3.getString("tpbm"));
            var5.add(var7);
        }

        return var5;
    }
    @SuppressWarnings("unchecked")
    public List<MessageDto> getScTkMsg(String var1) {
        new RecordSet();
        RecordSet var3 = new RecordSet();
        RecordSet var4 = new RecordSet();
        ArrayList var5 = new ArrayList();
        String var6 = "select t.*,p.pp from uf_scb s left join uf_TCGL t on s.tcId=t.id  left join uf_sspp p on t.sqip=p.id where s.userId=\'" + var1 + "\'";
        this.log.error("SQL2: " + var6);
        var3.execute(var6);

        while(var3.next()) {
            MessageDto var7 = new MessageDto();
            String var8 = var3.getString("pdf");
            String var9 = "";
            if(!"".equals(var8)) {
                var4.execute("select imagefileid from DocImageFile where docid = " + var8);
                if(var4.next()) {
                    var9 = var4.getString("imagefileid");
                }

                if(!"".equals(var9)) {
                    var7.setIpName(var3.getString("pp"));
                    var7.setPdfId(var9);
                    String var10 = var3.getString("fm");
                    String var11 = "";
                    var4.execute("select imagefileid from DocImageFile where docid = " + var10);
                    if(var4.next()) {
                        var11 = var4.getString("imagefileid");
                    }

                    var7.setFmId(var11);
                    var7.setTcId(var3.getString("id"));
                    var7.setTcIp(var3.getString("ip"));
                    var7.setTcName(var3.getString("tcmc"));
                    var5.add(var7);
                }
            }
        }

        return var5;
    }
}
