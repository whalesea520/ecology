
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*"%>
<%@ page import="java.text.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.mr.util.CommonTransUtil" scope="page" />
<%
	int reporttype = Util.getIntValue(request.getParameter("reporttype"),1);//统计报表类型 1为商机报表
	String userid = Util.null2String(request.getParameter("userid"));
	if(userid.equals("") || !ResourceComInfo.isManager(user.getUID(),userid)){
		userid = user.getUID()+"";
	}
	int subtype = Util.getIntValue(request.getParameter("subtype"),0);//是否包含下属类型   1为本人  2为下属  否则为本人及下属
	int cyear = Integer.parseInt(TimeUtil.getCurrentDateString().substring(0,4));
	int cmonth = Integer.parseInt(TimeUtil.getCurrentDateString().substring(5,7));
	int year = Util.getIntValue(request.getParameter("year"),cyear);
	int viewtype = Util.getIntValue(request.getParameter("viewtype"),1);//查看类型 1为数量  2为金额
	
	int detailtype = 1;
	if(viewtype==2) detailtype = 2;
	if(viewtype==4) detailtype = 4;
	
	String syear = Util.null2String(request.getParameter("syear"));
	String smonth = Util.null2String(request.getParameter("smonth"));
	String sdate1 = Util.null2String(request.getParameter("sdate1"));
	String sdate2 = Util.null2String(request.getParameter("sdate2"));
	int sellstatus = Util.getIntValue(request.getParameter("sellstatus"),-1);
	int selllat = Util.getIntValue(request.getParameter("selllat"),1);
	int sellcontact = Util.getIntValue(request.getParameter("sellcontact"),-1);
	String contactdate = Util.null2String(request.getParameter("contactdate"));
	String crmtype = Util.null2String(request.getParameter("crmtype"));
	String crmstatus = Util.null2String(request.getParameter("crmstatus"));

	String datewhere = "";
	if(!syear.equals("")){
		if(smonth.equals("")){
			datewhere += " and t.createdate like '"+syear+"%'";
		}else{
			List mlist = Util.TokenizerString(smonth,",");
			for(int i=0;i<mlist.size();i++){
				datewhere += " "+((i==0)?"":"or")+" t.createdate like '"+syear+"-"+mlist.get(i)+"%'";
			}
			if(!datewhere.equals("")) datewhere = " and ("+datewhere+")";
		}
	}else{
		if(!sdate1.equals("")) datewhere += " and t.createdate>='"+sdate1+"'";
		if(!sdate2.equals("")) datewhere += " and t.createdate<='"+sdate2+"'";
	}
	int total = 0;
	String sql = "";
	String basesql = "";
	String orderby  = "";
	int reportheight = 200;
	String reporttitle = "";
	double max = 0;
	int dp = 0;//小数位数
	String unit = "";//数量单位
	boolean istarget = false;//是否显示目标
	boolean iscommafy = false;//是否千分位显示：
	Map datamap = new HashMap();
	
	String datastr = "";
	String colorstr = "";
	String color_ = "";
	if(reporttype==1){
		String latfield = "t.createdate";
		if(selllat==2) latfield = "t.predate";
		max = 10;
		String vsql = "count(t.id)";
		dp = 0;
		unit = "个";
		if(viewtype==2){
			max = 100;
			vsql = "sum(t.preyield)";
			dp = 2;
			unit = "万";
			iscommafy = true;
		}else if(viewtype==3){
			
			unit = "%";
		}
		
		basesql = "select substring("+latfield+",0,8) as ny,"+vsql+" as value from CRM_Sellchance t,HrmResource h"
			+" where t.creater=h.id and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)";
		
		if(sellstatus!=-1) basesql += " and t.endtatusid="+sellstatus;
		//增加联系日期的条件
		if(sellcontact!=-1){
			basesql += " and "+((sellcontact==1)?"not":"")
				+" exists(select 1 from WorkPlan w where convert(varchar,t.customerid)=convert(varchar,w.crmid)"
				+" and (w.sellchanceid=t.id or (w.sellchanceid is null and w.contacterid is null))"
				+" and w.type_n='3' and w.begindate is not null and w.begindate<>''";
			if(!contactdate.equals(""))
				basesql += " and w.begindate<='"+TimeUtil.getCurrentDateString()+"' and w.begindate>='"+contactdate+"'";
			basesql += ")";
		}
			
		orderby = " group by substring("+latfield+",0,8)";
		if(subtype==1){
			basesql += " and h.id ="+userid;
		}else if(subtype==2){
			basesql += " and h.managerstr like '%,"+userid+",%'";
		}else{
			basesql += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
		}

		//sql += " group by substring(createdate,0,8)";
		for(int i=0;i<2;i++){
			if(i==0){
				sql = basesql + " and "+latfield+" like '"+year+"%'" + orderby;
			}else{
				sql =basesql + " and "+latfield+" like '"+(year-1)+"%'" + orderby;
			}
			//System.out.println(sql); 
			rs.executeSql(sql);
			while(rs.next()){
				double money = Util.getDoubleValue(rs.getString(2),0);
				if(iscommafy) money = money/10000;
				if(money>max) max = money;
				datamap.put(i+"_"+Util.null2String(rs.getString(1)),money+"");
			}
		}	
	}else if(reporttype==2 || reporttype==11){
		max = 10;
		dp = 0;
		unit = "个";
		String datestr = "w.begindate";
		if(viewtype==1 || viewtype==4) datestr = "t.createdate";
		
		if(viewtype==2){//客户联系
			basesql = "select substring("+datestr+",0,8) as ny,count(distinct t.id) as value from CRM_CustomerInfo t,WorkPlan w,HrmResource h"
				+" where t.manager=h.id and t.status<>13 and (t.deleted=0 or t.deleted is null) and convert(varchar,t.id)=convert(varchar,w.crmid) and w.type_n='3' and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)";//and w.createrid=t.manager
				
		}else if(viewtype==1){//客户新增
			basesql = "select substring("+datestr+",0,8) as ny,count(t.id) as value from CRM_CustomerInfo t,HrmResource h"
				+" where t.manager=h.id and t.status<>13 and (t.deleted=0 or t.deleted is null) and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)";
		}else if(viewtype==4){//人脉新增
			basesql = "select substring("+datestr+",0,8) as ny,count(t.id) as value"
				+ " from CRM_CustomerContacter t join CRM_CustomerInfo c on t.customerid=c.id join HrmResource h"
				+ " on c.manager=h.id and (c.deleted=0 or c.deleted is null) and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)"
				+ " and c.status<>13 and c.type =26";
		}
		orderby = " group by substring("+datestr+",0,8)";
		if(subtype==1){
			basesql += " and h.id ="+userid;
		}else if(subtype==2){
			basesql += " and h.managerstr like '%,"+userid+",%'";
		}else{
			basesql += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
		}
		if(reporttype==2){
			if(!crmtype.equals("")) basesql += " and t.type in("+crmtype+")";
			if(!crmstatus.equals("")) basesql += " and t.status in("+crmstatus+")";
		}else{
			if(viewtype!=4){
				basesql += " and t.type=26";
			}
		}
		
		
		for(int i=0;i<2;i++){
			if(i==0){
				sql = basesql + " and "+datestr+" like '"+year+"%'" + orderby;
			}else{
				sql = basesql + " and "+datestr+" like '"+(year-1)+"%'" + orderby;
			}
			//System.out.println(sql); 
			rs.executeSql(sql);
			while(rs.next()){
				double money = Util.getDoubleValue(rs.getString(2),0);
				if(iscommafy) money = money/10000;
				if(money>max) max = money;
				datamap.put(i+"_"+Util.null2String(rs.getString(1)),money+"");
			}
		}	
	}else if(reporttype==3 || reporttype==4 || reporttype==10){
		String tname = "所有客户";
		String otherwhere = " and t.status<>13 " + datewhere;
		if(reporttype==4){
			tname = "伙伴";
			otherwhere += " and t.type in (11,12,13,14,15,16,17,18,20,21,25,19)";
		}else if(reporttype==10){
			tname = "客户";
			otherwhere += " and t.type in (1,3,4,5)";
		}
		reportheight = 400;
		if(viewtype==1){
			reporttitle = tname+"类型统计";
			basesql = "select a.id,a.fullname as name,count(t.id) as amount"
				+ " from CRM_CustomerType a join CRM_CustomerInfo t on a.id=t.type join HrmResource h"
				+ " on t.manager=h.id and (t.deleted=0 or t.deleted is null) and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)"
				+ otherwhere;
			if(subtype==1){
				basesql += " and h.id ="+userid;
			}else if(subtype==2){
				basesql += " and h.managerstr like '%,"+userid+",%'";
			}else{
				basesql += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
			}
			basesql += " and t.type is not null and t.type<>'' group by a.id,a.fullname";
			
			rs.executeSql(basesql);
			while(rs.next()){
				datastr += ",{name:'"+Util.null2String(rs.getString("name"))+"',y:"+Util.null2String(rs.getString("amount"))+",value:"+Util.null2String(rs.getString("id"))+"}";
				color_ = cmutil.getRandColorCode();//随机生成不重复颜色
    			colorstr += ",'"+color_+"'";
    			total += Util.getIntValue(rs.getString("amount"),0);
			}
			if(!datastr.equals("")) datastr = "[" + datastr.substring(1) + "]";
			if(!colorstr.equals("")) colorstr = "[" + colorstr.substring(1) + "]";
		}else if(viewtype==2){
			reporttitle = tname+"状态统计";
			basesql = "select a.id,a.fullname as name,count(t.id) as amount"
				+ " from CRM_CustomerStatus a join CRM_CustomerInfo t on a.id=t.status join HrmResource h"
				+ " on t.manager=h.id and (t.deleted=0 or t.deleted is null) and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)"
				+ otherwhere;
			if(subtype==1){
				basesql += " and h.id ="+userid;
			}else if(subtype==2){
				basesql += " and h.managerstr like '%,"+userid+",%'";
			}else{
				basesql += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
			}
			basesql += " and t.status is not null and t.status<>'' group by a.id,a.fullname";
			
			rs.executeSql(basesql);
			while(rs.next()){
				datastr += ",{name:'"+Util.null2String(rs.getString("name"))+"',y:"+Util.null2String(rs.getString("amount"))+",value:"+Util.null2String(rs.getString("id"))+"}";
				color_ = cmutil.getRandColorCode();//随机生成不重复颜色
    			colorstr += ",'"+color_+"'";
    			total += Util.getIntValue(rs.getString("amount"),0);
			}
			if(!datastr.equals("")) datastr = "[" + datastr.substring(1) + "]";
			if(!colorstr.equals("")) colorstr = "[" + colorstr.substring(1) + "]";
		}else if(viewtype==3){
			reporttitle = tname+"获取方式统计";
			basesql = "select t.source,count(t.id) as amount"
				+ " from CRM_CustomerInfo t,HrmResource h"
				+ " where t.manager=h.id and (t.deleted=0 or t.deleted is null) and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)"
				+ otherwhere;
			if(subtype==1){
				basesql += " and h.id ="+userid;
			}else if(subtype==2){
				basesql += " and h.managerstr like '%,"+userid+",%'";
			}else{
				basesql += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
			}
			basesql += " and t.source is not null and t.source<>'' group by t.source";
			
			rs.executeSql(basesql);
			while(rs.next()){
				datastr += ",{name:'"+ContactWayComInfo.getContactWayname(Util.null2String(rs.getString(1)))+"',y:"+Util.null2String(rs.getString(2))+",value:"+Util.null2String(rs.getString(1))+"}";
				color_ = cmutil.getRandColorCode();//随机生成不重复颜色
    			colorstr += ",'"+color_+"'";
    			total += Util.getIntValue(rs.getString("amount"),0);
			}
			if(!datastr.equals("")) datastr = "[" + datastr.substring(1) + "]";
			if(!colorstr.equals("")) colorstr = "[" + colorstr.substring(1) + "]";
		}else if(viewtype==4 || viewtype==5){
			reporttitle = "已联系"+tname+"统计";
			if(viewtype==5) reporttitle = "未联系"+tname+"统计";
			basesql = "select count(t.id) as amount"
				+ " from CRM_CustomerInfo t,HrmResource h"
				+ " where t.manager=h.id and (t.deleted=0 or t.deleted is null) and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)"
				+ otherwhere;
			if(subtype==1){
				basesql += " and h.id ="+userid;
			}else if(subtype==2){
				basesql += " and h.managerstr like '%,"+userid+",%'";
			}else{
				basesql += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
			}
			basesql += " and "+((viewtype==5)?"not":"")+" exists(select 1 from WorkPlan w where convert(varchar,t.id)=convert(varchar,w.crmid) and w.type_n='3' and w.begindate is not null and w.begindate<>''";// and w.begindate is not null
			
			int[] days = {-7,-14,-30,-60,-90,-180};
			String[] names = {"一周","二周","一个月","两个月","三个月","半年"};
			for(int i=0;i<days.length;i++){
				rs.executeSql(basesql+" and w.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),days[i])+"')");
				if(rs.next()){
					datastr += ",{name:'"+names[i]+"',y:"+Util.null2String(rs.getString(1))+",value:"+i+"}";
					color_ = cmutil.getRandColorCode();//随机生成不重复颜色
	    			colorstr += ",'"+color_+"'";
				}
			}
			if(!datastr.equals("")) datastr = "[" + datastr.substring(1) + "]";
			if(!colorstr.equals("")) colorstr = "[" + colorstr.substring(1) + "]";
		}
	}else if(reporttype==5){//人脉分为两种方式（伙伴及人脉）
		String tname = "人脉";
		String otherwhere = " and t.status<>13 and t.type =26"+datewhere;
		reportheight = 400;
		if(viewtype==1){
			reporttitle = tname+"数量统计";
			//统计客户
			basesql = "select count(t.id) as amount"
				+ " from CRM_CustomerInfo t join HrmResource h"
				+ " on t.manager=h.id and (t.deleted=0 or t.deleted is null) and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)"
				+ otherwhere;
			if(subtype==1){
				basesql += " and h.id ="+userid;
			}else if(subtype==2){
				basesql += " and h.managerstr like '%,"+userid+",%'";
			}else{
				basesql += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
			}
			rs.executeSql(basesql);
			if(rs.next()){
				datastr += ",{name:'销售伙伴',y:"+Util.null2String(rs.getString("amount"))+",value:1}";
				color_ = cmutil.getRandColorCode();//随机生成不重复颜色
    			colorstr += ",'"+color_+"'";
    			total += Util.getIntValue(rs.getString("amount"),0);
			}
			//统计联系人
			basesql = "select count(cc.id) as amount"
				+ " from CRM_CustomerContacter cc join CRM_CustomerInfo t on cc.customerid=t.id join HrmResource h"
				+ " on t.manager=h.id and (t.deleted=0 or t.deleted is null) and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)"
				+ " and t.status<>13 and t.type =26";
			if(subtype==1){
				basesql += " and h.id ="+userid;
			}else if(subtype==2){
				basesql += " and h.managerstr like '%,"+userid+",%'";
			}else{
				basesql += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
			}
			if(!datewhere.equals("")){
				basesql += datewhere.replaceAll("t.createdate","cc.createdate");
				/**
				basesql += " and exists (select 1 from CRM_Log t1,CRM_Modify t2"
					+ "  where t1.submitdate=t2.modifydate and t1.submittime=t2.modifytime and t1.customerid=t2.customerid"
					+ "  and t1.logtype='nc' and t1.customerid=t.id and t2.type=cc.id"
					+ datewhere.replaceAll("t.createdate","t1.submitdate")+")"; 
				
				basesql += " and (exists (select 1 from CRM_Log t1,CRM_Modify t2"
					+ "  where t1.submitdate=t2.modifydate and t1.submittime=t2.modifytime and t1.customerid=t2.customerid"
					+ "  and t1.logtype='nc' and t1.customerid=t.id and t2.type=cc.id"
					+ datewhere.replaceAll("t.createdate","t1.submitdate")+")"
					+ " or (1=1 "+datewhere+"))"; 
				*/
			}
			
			rs.executeSql(basesql);
			if(rs.next()){
				datastr += ",{name:'销售人脉',y:"+Util.null2String(rs.getString("amount"))+",value:2}";
				color_ = cmutil.getRandColorCode();//随机生成不重复颜色
    			colorstr += ",'"+color_+"'";
    			total += Util.getIntValue(rs.getString("amount"),0);
			}
			if(!datastr.equals("")) datastr = "[" + datastr.substring(1) + "]";
			if(!colorstr.equals("")) colorstr = "[" + colorstr.substring(1) + "]";
		}else if(viewtype==3 || viewtype==2){
			reporttitle = "已联系"+tname+"统计";
			if(viewtype==2) reporttitle = "未联系"+tname+"统计";
			basesql = "select count(t.id) as amount"
				+ " from CRM_CustomerInfo t,HrmResource h"
				+ " where t.manager=h.id and (t.deleted=0 or t.deleted is null) and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)"
				+ otherwhere;
			if(subtype==1){
				basesql += " and h.id ="+userid;
			}else if(subtype==2){
				basesql += " and h.managerstr like '%,"+userid+",%'";
			}else{
				basesql += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
			}
			basesql += " and "+((viewtype==2)?"not":"")+" exists(select 1 from WorkPlan w where convert(varchar,t.id)=convert(varchar,w.crmid) and w.createrid=t.manager and w.type_n='3' and w.begindate is not null and w.begindate<>''";
			
			int[] days = {-7,-14,-30,-60,-90,-180};
			String[] names = {"一周","二周","一个月","两个月","三个月","半年"};
			for(int i=0;i<days.length;i++){
				rs.executeSql(basesql+" and w.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),days[i])+"')");
				if(rs.next()){
					datastr += ",{name:'"+names[i]+"',y:"+Util.null2String(rs.getString(1))+",value:"+i+"}";
					color_ = cmutil.getRandColorCode();//随机生成不重复颜色
	    			colorstr += ",'"+color_+"'";
				}
			}
			if(!datastr.equals("")) datastr = "[" + datastr.substring(1) + "]";
			if(!colorstr.equals("")) colorstr = "[" + colorstr.substring(1) + "]";
		}
	}else if(reporttype==6){
		String tname = "商机";
		String otherwhere = datewhere;
		reportheight = 400;
		if(viewtype==1){
			reporttitle = tname+"(终端客户商机)阶段统计";
			basesql = "select a.id,a.fullname as name,count(t.id) as amount"
				+ " from CRM_SellStatus a join CRM_SellChance t on a.id=t.sellstatusid join HrmResource h"
				+ " on t.creater=h.id and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)"
				+ " and t.selltype = 1"
				+ otherwhere;;
			if(subtype==1){
				basesql += " and h.id ="+userid;
			}else if(subtype==2){
				basesql += " and h.managerstr like '%,"+userid+",%'";
			}else{
				basesql += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
			}
			basesql += " group by a.id,a.fullname order by a.id";
			
			rs.executeSql(basesql);
			while(rs.next()){
				datastr += ",{name:'"+Util.null2String(rs.getString("name"))+"',y:"+Util.null2String(rs.getString("amount"))+",value:"+Util.null2String(rs.getString("id"))+"}";
				color_ = cmutil.getRandColorCode();//随机生成不重复颜色
    			colorstr += ",'"+color_+"'";
    			total += Util.getIntValue(rs.getString("amount"),0);
			}
			if(!datastr.equals("")) datastr = "[" + datastr.substring(1) + "]";
			if(!colorstr.equals("")) colorstr = "[" + colorstr.substring(1) + "]";
		}else if(viewtype==2){
			reporttitle = tname+"状态统计";
			basesql = "select t.endtatusid as id,count(t.id) as amount"
				+ " from CRM_SellChance t join HrmResource h"
				+ " on t.creater=h.id and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)"
				+ otherwhere;
			if(subtype==1){
				basesql += " and h.id ="+userid;
			}else if(subtype==2){
				basesql += " and h.managerstr like '%,"+userid+",%'";
			}else{
				basesql += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
			}
			basesql += " group by t.endtatusid order by t.endtatusid";
			
			rs.executeSql(basesql);
			while(rs.next()){
				String statusname = "";
				if(Util.null2String(rs.getString("id")).equals("4")) statusname = "培育";
				if(Util.null2String(rs.getString("id")).equals("0")) statusname = "紧跟";
				if(Util.null2String(rs.getString("id")).equals("1")) statusname = "成功";
				if(Util.null2String(rs.getString("id")).equals("2")) statusname = "失败";
				if(Util.null2String(rs.getString("id")).equals("3")) statusname = "暂停";
				datastr += ",{name:'"+statusname+"',y:"+Util.null2String(rs.getString("amount"))+",value:"+Util.null2String(rs.getString("id"))+"}";
				color_ = cmutil.getRandColorCode();//随机生成不重复颜色
    			colorstr += ",'"+color_+"'";
    			total += Util.getIntValue(rs.getString("amount"),0);
			}
			if(!datastr.equals("")) datastr = "[" + datastr.substring(1) + "]";
			if(!colorstr.equals("")) colorstr = "[" + colorstr.substring(1) + "]";
		}else if(viewtype==3){
			reporttitle = tname+"预期收益统计";
			basesql = "select count(t.id) as amount"
				+ " from CRM_SellChance t join HrmResource h"
				+ " on t.creater=h.id and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)"
				+ otherwhere;
			if(subtype==1){
				basesql += " and h.id ="+userid;
			}else if(subtype==2){
				basesql += " and h.managerstr like '%,"+userid+",%'";
			}else{
				basesql += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
			}
			
			int[][] days = {{0,20},{20,50},{50,100},{100,1000}};
			String[] names = {"0-20万","20-50万","50-100万","100万以上"};
			for(int i=0;i<days.length;i++){
				rs.executeSql(basesql+" and t.preyield>="+days[i][0]*10000+" and t.preyield<"+days[i][1]*10000);
				if(rs.next()){
					datastr += ",{name:'"+names[i]+"',y:"+Util.null2String(rs.getString(1))+",value:"+i+"}";
					color_ = cmutil.getRandColorCode();//随机生成不重复颜色
	    			colorstr += ",'"+color_+"'";
				}
			}
			if(!datastr.equals("")) datastr = "[" + datastr.substring(1) + "]";
			if(!colorstr.equals("")) colorstr = "[" + colorstr.substring(1) + "]";
		}else if(viewtype==4 || viewtype==5){
			reporttitle = "已联系"+tname+"统计";
			if(viewtype==5){
				reporttitle = "未联系"+tname+"统计";
				otherwhere = " and t.endtatusid=0";
			}
			basesql = "select count(t.id) as amount"
				+ " from CRM_SellChance t,HrmResource h"
				+ " where t.creater=h.id and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)"
				+ otherwhere;
			if(subtype==1){
				basesql += " and h.id ="+userid;
			}else if(subtype==2){
				basesql += " and h.managerstr like '%,"+userid+",%'";
			}else{
				basesql += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
			}
			basesql += " and "+((viewtype==5)?"not":"")+" exists(select 1 from WorkPlan w where convert(varchar,t.customerid)=convert(varchar,w.crmid)"
					+" and (w.sellchanceid=t.id or (w.sellchanceid is null and w.contacterid is null))"
					+" and w.type_n='3' and w.begindate is not null and w.begindate<>''";//and w.createrid=t.creater
			
			int[] days = {-7,-14,-30,-60,-90,-180};
			String[] names = {"一周","二周","一个月","两个月","三个月","半年"};
			for(int i=0;i<days.length;i++){
				rs.executeSql(basesql+" and begindate<='"+TimeUtil.getCurrentDateString()+"' and w.begindate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),days[i])+"')");
				if(rs.next()){
					datastr += ",{name:'"+names[i]+"',y:"+Util.null2String(rs.getString(1))+",value:"+i+"}";
					color_ = cmutil.getRandColorCode();//随机生成不重复颜色
	    			colorstr += ",'"+color_+"'";
				}
			}
			if(!datastr.equals("")) datastr = "[" + datastr.substring(1) + "]";
			if(!colorstr.equals("")) colorstr = "[" + colorstr.substring(1) + "]";
		}else if(viewtype==6){
			reporttitle = tname+"建立时间统计";
			basesql = "select count(t.id) as amount"
				+ " from CRM_SellChance t,HrmResource h"
				+ " where t.creater=h.id and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)"
				+ otherwhere;
			if(subtype==1){
				basesql += " and h.id ="+userid;
			}else if(subtype==2){
				basesql += " and h.managerstr like '%,"+userid+",%'";
			}else{
				basesql += " and (h.id ="+userid+" or h.managerstr like '%,"+userid+",%')";
			}
			
			int[] days = {-7,-14,-30,-60,-90,-180};
			String[] names = {"一周","二周","一个月","两个月","三个月","半年"};
			for(int i=0;i<days.length;i++){
				rs.executeSql(basesql+" and t.createdate>='"+TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),days[i])+"'");
				if(rs.next()){
					datastr += ",{name:'"+names[i]+"',y:"+Util.null2String(rs.getString(1))+",value:"+i+"}";
					color_ = cmutil.getRandColorCode();//随机生成不重复颜色
	    			colorstr += ",'"+color_+"'";
				}
			}
			if(!datastr.equals("")) datastr = "[" + datastr.substring(1) + "]";
			if(!colorstr.equals("")) colorstr = "[" + colorstr.substring(1) + "]";
		}
	}
	String msgstr = "";
	if(datastr.equals("")) msgstr = "暂无相关统计信息";
	//System.out.println(basesql);
	
	//String maxvalue = this.round(max/10000+"",0);
	String maxvalue = this.round(max+"",0);
	
	String[] datas = {"","",""};
	String[][] datass = new String[12][3];
	String titles = ""; 
	String titles2 = "";
	String titles3 = "";
	if(reporttype==1 || reporttype==2 || reporttype==11){
		for(int i=0;i<3;i++){
			String data = "";
			String[] ss = new String[12];
			rs.next();
			String ymstr = "";
			int index = 0;
			int y = 0;
			for(int j=1;j<=12;j++){
				if(i==1){
					y = year - 1;
				}else{
					y = year;
				}
				if(j<10){
					ymstr = i+"_"+y+"-0"+j;
				}else{
					ymstr = i+"_"+y+"-"+j;
				}
				data += "," + this.round(Util.getDoubleValue((String)datamap.get(ymstr),0)+"",dp);
				ss[index] = this.round(Util.getDoubleValue((String)datamap.get(ymstr),0)+"",dp);
				//data += "," + this.round(Util.getDoubleValue((String)datamap.get(ymstr),0)/10000+"",2);
				//ss[index] = this.round(Util.getDoubleValue((String)datamap.get(ymstr),0)/10000+"",2);
				if(i==0){ titles += ",'" + ymstr.substring(7) + "'";titles2 += ",'" + ymstr.substring(2) + "'";}
				if(i==1) titles3 += ",'" + ymstr.substring(2) + "'";
				index++;
			}
			
			datas[i] = "[" + data.substring(1) + "]";
			datass[i] = ss;
		}
		titles = "[" + titles.substring(1) + "]";
		titles2 = titles2.substring(1);
		titles3 = titles3.substring(1);
	}
%>
						<div class="title1">
							<div id="charttitle" class="mini_title">图表分析</div>
							<%if(reporttype==1){ %>
							<div class="main_tab <%if(viewtype==1){ %>main_tab_click<%} %>" _index="1" title="按月统计建立商机的数量">商机数量</div>
							<div class="main_tab <%if(viewtype==2){ %>main_tab_click<%} %>" _index="2" title="按月统计建立商机的预期收益">预期收益</div>
							<div class="main_tab <%if(viewtype==3){ %>main_tab_click<%} %>" style="display: none" _index="3" title="按月统计建立商机的成功比例">成功比例</div>
							<%}else if(reporttype==2 || reporttype==11){ %>
								<%if(reporttype==2){ %>
								<div class="main_tab <%if(viewtype==1){ %>main_tab_click<%} %>" _index="1" title="按月统计新增客户的数量">新增数量</div>
								<%}else{ %>
								<div class="main_tab <%if(viewtype==1){ %>main_tab_click<%} %>" _index="1" title="按月统计新增销售伙伴的数量">新增伙伴</div>
								<div class="main_tab <%if(viewtype==4){ %>main_tab_click<%} %>" _index="4" title="按月统计新增销售人脉的数量">新增人脉</div>
								<%} %>
							<div class="main_tab <%if(viewtype==2){ %>main_tab_click<%} %>" _index="2" title="按月统计联系客户的数量">联系数量</div>
							<%}else if(reporttype==3 || reporttype==4 || reporttype==10){ %>
							<div class="main_tab <%if(viewtype==1){ %>main_tab_click<%} %>" _index="1" title="按类型统计客户的数量">类型</div>
							<div class="main_tab <%if(viewtype==2){ %>main_tab_click<%} %>" _index="2" title="按状态统计客户的数量">状态</div>
							<div class="main_tab <%if(viewtype==3){ %>main_tab_click<%} %>" _index="3" title="按获得方式统计客户的数量">获得方式</div>
							<div class="main_tab <%if(viewtype==4){ %>main_tab_click<%} %>" _index="4" title="按已联系的时间统计客户的数量">已联系</div>
							<div class="main_tab <%if(viewtype==5){ %>main_tab_click<%} %>" _index="5" title="按未联系的时间统计客户的数量">未联系</div>
							<%}else if(reporttype==5){ %>
							<div class="main_tab <%if(viewtype==1){ %>main_tab_click<%} %>" _index="1" title="统计人脉的数量">数量</div>
							<div class="main_tab <%if(viewtype==3){ %>main_tab_click<%} %>" _index="3" title="按已联系的时间统计人脉的数量">已联系</div>
							<div class="main_tab <%if(viewtype==2){ %>main_tab_click<%} %>" _index="2" title="按未联系的时间统计人脉的数量">未联系</div>
							<%}else if(reporttype==6){ %>
							<div class="main_tab <%if(viewtype==1){ %>main_tab_click<%} %>" _index="1" title="按阶段统计商机的数量">商机阶段</div>
							<div class="main_tab <%if(viewtype==2){ %>main_tab_click<%} %>" _index="2" title="按状态统计商机的数量">商机状态</div>
							<div class="main_tab <%if(viewtype==3){ %>main_tab_click<%} %>" _index="3" title="按预期收益统计商机的数量">预期收益</div>
							<div class="main_tab <%if(viewtype==4){ %>main_tab_click<%} %>" _index="4" title="按已联系的时间统计商机的数量">已联系</div>
							<div class="main_tab <%if(viewtype==5){ %>main_tab_click<%} %>" _index="5" title="按未联系的时间统计进行中商机的数量">未联系</div>
							<div class="main_tab <%if(viewtype==6){ %>main_tab_click<%} %>" _index="6" title="按已建立的时间间隔统计进行中商机的数量">建立周期</div>
							<%} %>
						</div>
						<div id="report1" style="width: 100%;height: <%=reportheight %>px;font-family:'微软雅黑' !important;">
						
							<%if(datastr.equals("")){ %>
							<div style="width: 100%;height: auto;text-align: center;margin-top: 10px;"><%=msgstr %></div>
							<%} %>
						</div>
						<%if(reporttype==1 || reporttype==2 || reporttype==11){ %>
						<table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
							<colgroup><col width="39px"/><col width="*"/></colgroup>
							<tr>
								<td>
									<table class="reporttable" cellpadding="0" cellspacing="0" border="0">
										<%if(istarget){ %>
										<tr>
											<td class="title" style="color: #4572A7;">目标</td>
										</tr>
										<%} %>
										<tr>
											<td class="title" style="color: #4673A7">本年</td>
										</tr>
										<tr>
											<td class="title" style="color: #AA4744;">同期</td>
										</tr>
										<tr>
											<td class="title" style="color: #FF0000;border-bottom: 1px #C4D0DC solid;">增长</td>
										</tr>
									</table>
								</td>
								<td>
									<table class="reporttable" cellpadding="0" cellspacing="1" border="0">
										<colgroup>
											<col width="8.33%"/><col width="8.33%"/><col width="8.33%"/><col width="8.33%"/><col width="8.33%"/><col width="8.33%"/>
											<col width="8.33%"/><col width="8.33%"/><col width="8.33%"/><col width="8.33%"/><col width="8.33%"/><col width="8.33%"/>
										</colgroup>
										<%
											List titlelist = Util.TokenizerString(titles2,",");
											if(istarget){ 
										%>
										<tr>
											<%for(int i=0;i<12;i++){ %>
												<td class="<%if(year==cyear && i+1==cmonth){ %>current<%} %> <%if(iscommafy){ %>money<%} %>"><%=datass[2][i] %></td>
											<%} %>
										</tr>
										<%} %>
										<tr>
											<%for(int i=0;i<12;i++){ %>
												<td id="sj_<%=i %>" class="<%if(year==cyear && i+1==cmonth){ %>current<%} %> <%if(iscommafy){ %>money<%} %>" onclick="changePlace(<%=titlelist.get(i) %>);" title=<%=titlelist.get(i) %> style="cursor: pointer;"><%=datass[0][i] %></td>
											<%} %>
										</tr>
										<tr>
											<%for(int i=0;i<12;i++){ %>
												<td id="tq_<%=i %>" class="<%if(year==cyear && i+1==cmonth){ %>current<%} %> <%if(iscommafy){ %>money<%} %>" onclick="changePlace('<%=(year-1)+((String)titlelist.get(i)).substring(5) %>);" title='<%=(year-1)+((String)titlelist.get(i)).substring(5,8) %>' style="cursor: pointer;"><%=datass[1][i] %></td>
											<%} %>
										</tr>
										<tr>
											<%for(int i=0;i<12;i++){ %>
												<td id="zz_<%=i %>" class="<%if(year==cyear && i+1==cmonth){ %>current<%} %>"></td>
											<%} %>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<div class="title1">
							<div id="placetitle" class="mini_title"><%=year %>排名</div>
							<%if(reporttype==1){ %>
							<div class="mini_tab <%if(detailtype==1){ %>mini_tab_click<%} %>" _index="1">商机数量</div>
							<div class="mini_tab <%if(detailtype==2){ %>mini_tab_click<%} %>" _index="2">预期收益</div>
							<div class="mini_tab <%if(detailtype==3){ %>mini_tab_click<%} %>" _index="3">成功比例</div>
							<%}else if(reporttype==2 || reporttype==11){ %>
								<%if(reporttype==2){ %>
								<div class="mini_tab <%if(detailtype==1){ %>mini_tab_click<%} %>" _index="1">新增数量</div>
								<%}else{ %>
								<div class="mini_tab <%if(detailtype==1){ %>mini_tab_click<%} %>" _index="1">新增伙伴</div>
								<div class="mini_tab <%if(detailtype==4){ %>mini_tab_click<%} %>" _index="4">新增人脉</div>
								<%} %>
							<div class="mini_tab <%if(detailtype==2){ %>mini_tab_click<%} %>" _index="2">联系数量</div>
							<div class="mini_tab <%if(detailtype==3){ %>mini_tab_click<%} %>" _index="3">联系比例</div>
							<%} %>
							<div style="float: right;width: auto;height:32px;">
								<div id="btn_type" class="mini_btn mini_btn_click" title="按人员进行统计,点击切换为按部门统计">人员</div>
								<div id="btn_order" class="mini_btn mini_btn_click" title="按数值降序进行排列,点击切换为升序">降序</div>
								<div id="btn_isall" class="mini_btn" title="包括没有数据的人员">所有</div>
							</div>
						</div>
						<div id="div_place" style="width: 100%;overflow: hidden">
							<jsp:include page="ReportPlace.jsp">
								<jsp:param value="<%=reporttype %>" name="reporttype"/>
								<jsp:param value="<%=detailtype %>" name="detailtype"/>
								<jsp:param value="<%=subtype %>" name="subtype"/>
								<jsp:param value="<%=userid %>" name="userid"/>
								<jsp:param value="<%=year %>" name="ym"/>
								<jsp:param value="<%=sellstatus %>" name="sellstatus"/>
								<jsp:param value="<%=selllat %>" name="selllat"/>
								<jsp:param value="<%=sellcontact %>" name="sellcontact"/>
								<jsp:param value="<%=contactdate %>" name="contactdate"/>
								<jsp:param value="<%=crmtype %>" name="crmtype"/>
								<jsp:param value="<%=crmstatus %>" name="crmstatus"/>
							</jsp:include>
						</div>
						<%} %>
		<script type="text/javascript">
			$(document).ready(function(){
				titles = new Array(<%=titles2%>);
				titles3 = new Array(<%=titles3%>);
				detailtype = "<%=detailtype%>";
				stattype = 1;
				ordertype = 1;
				showall = 0;
				ym = "<%=year %>";
				//alert(detailtype);
				
				$("div.main_tab").bind("click",function(){
					$("div.main_tab").removeClass("main_tab_click");
					$(this).addClass("main_tab_click");
					viewtype = $(this).attr("_index");
					loadList();
				});
				$("div.mini_tab").bind("click",function(){
					$("div.mini_tab").removeClass("mini_tab_click");
					$(this).addClass("mini_tab_click");
					detailtype = $(this).attr("_index");
					loadPlace();
				});
				$("#btn_type").bind("click",function(){
					if(stattype==1){
						stattype = 0;
						$(this).html("部门").attr("title","按部门进行统计,点击切换为按人员统计");
					}else{
						stattype = 1;
						$(this).html("人员").attr("title","按人员进行统计,点击切换为按部门统计");
					}
					loadPlace();
				});
				$("#btn_order").bind("click",function(){
					if(ordertype==1){
						ordertype = 0;
						$(this).html("升序").attr("title","按数值升序进行排列,点击切换为降序");
					}else{
						ordertype = 1;
						$(this).html("降序").attr("title","按数值降序进行排列,点击切换为升序");
					}
					loadPlace();
				});
				$("#btn_isall").bind("click",function(){
					if(showall==1){
						showall = 0;
						$(this).removeClass("mini_btn_click");
					}else{
						showall = 1;
						$(this).addClass("mini_btn_click");
					}
					loadPlace();
				});
				
				<%if(reporttype==1 || reporttype==2 || reporttype==11){%>
				chart = new Highcharts.Chart({
		            chart: {
		        		type: 'column',
		        		borderWidth: 0,
		        		backgroundColor: 'none',
		                renderTo: 'report1',
		                marginBottom: 20,
		                marginRight: 0,
		                marginLeft: 40
		            },
		            title: {
		                text: ''
		            },
		            subtitle: {
		                text: ''
		            },
		            xAxis: [{
		                categories: <%=titles%>
		            }],
		            yAxis: {
		                min: 0,
		                title: {
		                    text: ''
		                }
		            },
		            tooltip: {
		                formatter: function() {
		                    return ''+
		                        this.x +'月: '+ this.y +' <%=unit%>';
		               	}
		            },
		            legend: {
		                layout: 'vertical',
		                backgroundColor: '#FFFFFF',
		                align: 'right',
		                verticalAlign: 'top',
		                
		                //x: 100,
		               // y: 70,
		                floating: true,
		                shadow: false
		            },
		            series: [{
		            	borderWidth: 0,
		            	shadow: false,
		                name: '实际',
		                data: <%=datas[0]%>,
		                events:{//监听点的鼠标事件  
	                    	click: function(event) {
		                		changePlace(titles[event.point.x]);
	                    	} 
	                	}
		            }, {
		            	borderWidth: 0,
		            	shadow: false,
		                name: '同期',
		                data: <%=datas[1]%>,
		                events:{//监听点的鼠标事件  
	                    	click: function(event) {
		                		changePlace(titles3[event.point.x]);
	                    	} 
	                	}
		            }]
		        });

				setInc();
				commafyAll();

				<%}else if((reporttype==3||reporttype==4||reporttype==10||reporttype==5||reporttype==6) && !datastr.equals("")){%>
				 	chart = new Highcharts.Chart({
			            chart: {
			                renderTo: 'report1',
			                plotBackgroundColor: null,
			                plotBorderWidth: 0,
			                plotShadow: false,
			                backgroundColor: '#fff',
			                borderWidth: 0
			            },
			            title: {
			                text: '<%=reporttitle+((total!=0)?"[总计："+total+"个]":"")%>'
			            },
			            tooltip: {
			            	enabled: true,
			                formatter: function() {
			                    return '<b>'+ this.point.name +'</b>: '+ this.point.y;
			                }
			            },
			            legend: {
			                backgroundColor: '#FFFFFF',
			                borderWidth: 0,
			                floating: true,
			                shadow: false,
			                verticalAlign: 'bottom',
			                y:20
			            },
			            plotOptions: {
			                pie: {
			            		borderWidth: 0,
			            		shadow: true,
			                    allowPointSelect: true,
			                    cursor: 'pointer',
			                    dataLabels: {
			                        enabled: true,
			                        color: '#000000',
			                        connectorColor: '#616161',
			                        formatter: function() {
			                            return '<b>'+ this.point.name +'</b>: '+ Math.round(this.percentage*100)/100 +' %';
			                        }
			                    },
			                    events:{//监听点的鼠标事件  
			                    	click: function(event) {
			                    		loadDetail3(event.point.value);
			                    	} 
			                	},
			                	showInLegend: true
			                }
			            },
			            series: [{
			                type: 'pie',
			                name: 'Browser share',
			                data: <%=datastr%>
			            }],
			            colors: <%=colorstr%>
			        });

				<%}%>
				
			});


			//设置增长量
			function setInc(){
				var sj = 0;
				var tq = 0;
				var zz = 0;
				for(var i=0;i<12;i++){
					sj = $("#sj_"+i).html();
					tq = $("#tq_"+i).html();
					if(tq==0){
						zz = "-";
					}else{
						zz = ((sj-tq)/tq*100).toFixed(0) + "%";
					}
					$("#zz_"+i).html(zz);
				}
			}
			function commafyAll(){
				$(".money").each(function(){
					$(this).html(commafy($(this).html()));
				});	
			}

			function changePlace(_ym){
				$("#placetitle").html(_ym+"排名");
				ym = _ym;
				loadPlace();
				loadDetail(ym,detailtype);
			}
			function loadPlace(){
				$.ajax({
					type: "post",
				    url: "ReportPlace.jsp",
				    data:{"reporttype":"<%=reporttype%>","subtype":"<%=subtype%>","ym":ym,"userid":<%=userid%>,"detailtype":detailtype,"stattype":stattype,"ordertype":ordertype,"showall":showall,"selllat":"<%=selllat%>"
				    	,"sellcontact":"<%=sellcontact%>","contactdate":"<%=contactdate%>","crmtype":"<%=crmtype%>","crmstatus":"<%=crmstatus%>"}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
				    	$("#div_place").html(txt);
					}
			    });
			}

		</script>
<%!
/**
 * 对金额进行四舍五入
 * @param s 金额字符串
 * @param len 小数位数
 * @return
 */
public static String round(String s,int len){
	if (s == null || s.length() < 1) {
		return "";
	}
	NumberFormat formater = null;
	double num = Double.parseDouble(s);
	if (len == 0) {
		formater = new DecimalFormat("##0");
	} else {
		StringBuffer buff = new StringBuffer();
		buff.append("##0.");
		for (int i = 0; i < len; i++) {
			buff.append("0");
		}
		formater = new DecimalFormat(buff.toString());
	}
	return formater.format(num);
}
%>