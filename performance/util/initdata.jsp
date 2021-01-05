<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.gp.util.OperateUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//判断是否有权限
if (!HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)) {
    return;
}

String msg = "";
int year = Util.getIntValue(request.getParameter("year"),Util.getIntValue(TimeUtil.getCurrentDateString().substring(0,4)));
int month = Util.getIntValue(request.getParameter("month"),Util.getIntValue(TimeUtil.getCurrentDateString().substring(5,7)));
int season = Util.getIntValue(request.getParameter("season"),Util.getIntValue(TimeUtil.getCurrentSeason()));

String subcompanyid = "";
String startdate = "";
String enddate = "";
String basedate = "";
OperateUtil opu = new OperateUtil();
//判断是否已初始化月度数据
rs.executeSql("select id from GP_InitTag where year="+year+" and type1=1 and type2="+month);
if(!rs.next()){
	//初始化当前月份的月度考核数据
	//读取启用月度考核的分部
	try{
		basedate = TimeUtil.getYearMonthEndDay(year, month);
	}catch(Exception e){}
	rs.executeSql("select resourceid,mstarttype,mstartdays,mendtype,menddays from GP_BaseSetting where resourcetype=2 and ismonth=1");
	while(rs.next()){
		subcompanyid = Util.null2String(rs.getString("resourceid"));
		startdate = TimeUtil.dateAdd(basedate, Util.getIntValue(rs.getString("mstarttype"),1)*Util.getIntValue(rs.getString("mstartdays"),0));
		enddate = TimeUtil.dateAdd(basedate, Util.getIntValue(rs.getString("mendtype"),1)*Util.getIntValue(rs.getString("menddays"),0));
		opu.initData(subcompanyid, year, 1, month, startdate, enddate);
	}
	rs.executeSql("insert into GP_InitTag(year,type1,type2) values("+year+",1,"+month+")");
	msg += "初始化月度数据-年份："+year+" 月份："+month+"<br>";
}
//判断是否已初始化季度数据
rs.executeSql("select id from GP_InitTag where year="+year+" and type1=2 and type2="+season);
if(!rs.next()){
	//初始化当前季度的季度考核数据
	//读取启用季度考核的分部
	try{
		if(season==1) basedate = TimeUtil.getYearMonthEndDay(year,3);
		if(season==2) basedate = TimeUtil.getYearMonthEndDay(year,6);
		if(season==3) basedate = TimeUtil.getYearMonthEndDay(year,9);
		if(season==4) basedate = TimeUtil.getYearMonthEndDay(year,12);
	}catch(Exception e){}
	rs.executeSql("select resourceid,qstarttype,qstartdays,qendtype,qenddays from GP_BaseSetting where resourcetype=2 and isquarter=1");
	while(rs.next()){
		subcompanyid = Util.null2String(rs.getString("resourceid"));
		startdate = TimeUtil.dateAdd(basedate, Util.getIntValue(rs.getString("qstarttype"),1)*Util.getIntValue(rs.getString("qstartdays"),0));
		enddate = TimeUtil.dateAdd(basedate, Util.getIntValue(rs.getString("qendtype"),1)*Util.getIntValue(rs.getString("qenddays"),0));
		opu.initData(subcompanyid, year, 2, season, startdate, enddate);
	}
	rs.executeSql("insert into GP_InitTag(year,type1,type2) values("+year+",2,"+season+")");
	msg += "初始化季度数据-年份："+year+" 季度："+season+"<br>";
}
//判断是否已初始化半年度数据
rs.executeSql("select id from GP_InitTag where year="+year+" and type1=3 and type2=0");
if(!rs.next()){
	//初始化当前年度的半年度考核数据
	//读取启用半年度考核的分部
	try{
		basedate = TimeUtil.getYearMonthEndDay(year,6);
	}catch(Exception e){}
	rs.executeSql("select resourceid,hstarttype,hstartdays,hendtype,henddays from GP_BaseSetting where resourcetype=2 and ishyear=1");
	while(rs.next()){
		subcompanyid = Util.null2String(rs.getString("resourceid"));
		startdate = TimeUtil.dateAdd(basedate, Util.getIntValue(rs.getString("hstarttype"),1)*Util.getIntValue(rs.getString("hstartdays"),0));
		enddate = TimeUtil.dateAdd(basedate, Util.getIntValue(rs.getString("hendtype"),1)*Util.getIntValue(rs.getString("henddays"),0));
		opu.initData(subcompanyid, year, 3, 0, startdate, enddate);
	}
	rs.executeSql("insert into GP_InitTag(year,type1,type2) values("+year+",3,0)");
	msg += "初始化半年度数据-年份："+year+"<br>";
}
//判断是否已初始化年度数据
rs.executeSql("select id from GP_InitTag where year="+year+" and type1=4 and type2=0");
if(!rs.next()){
	//初始化当前年度的年度考核数据
	//读取启用年度考核的分部
	try{
		basedate = TimeUtil.getYearMonthEndDay(year,12);
	}catch(Exception e){}
	rs.executeSql("select resourceid,fstarttype,fstartdays,fendtype,fenddays from GP_BaseSetting where resourcetype=2 and isfyear=1");
	while(rs.next()){
		subcompanyid = Util.null2String(rs.getString("resourceid"));
		startdate = TimeUtil.dateAdd(basedate, Util.getIntValue(rs.getString("fstarttype"),1)*Util.getIntValue(rs.getString("fstartdays"),0));
		enddate = TimeUtil.dateAdd(basedate, Util.getIntValue(rs.getString("fendtype"),1)*Util.getIntValue(rs.getString("fenddays"),0));
		opu.initData(subcompanyid, year, 4, 0, startdate, enddate);
	}
	rs.executeSql("insert into GP_InitTag(year,type1,type2) values("+year+",4,0)");
	msg += "初始化年度数据-年份："+year+"<br>";
}
%>
<%=msg %>
