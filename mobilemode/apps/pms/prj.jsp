<%@page import="weaver.prj.util.ResourceUtil"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.prj.util.PrjCardUtil"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.hrm.*"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%
response.setContentType("text/plain");
String callbackFunName = "success_jsonpCallback";//request.getParameter("callbackparam");

String currentDateString = TimeUtil.getCurrentDateString();
String[] currentDateStringArray = currentDateString.split("-");
String yyyy = currentDateStringArray[0]; 
String yyyyMM = currentDateStringArray[0]+"-"+currentDateStringArray[1]; 

Random random = new Random();
int randomInt = random.nextInt();
if(randomInt < 0){
	randomInt *= -1;
}

//User user = HrmUserVarify.getUser (request , response) ;
int _userid = Util.getIntValue(request.getParameter("userid"));
UserManager userManager = new UserManager();
User user = userManager.getUserByUserIdAndLoginType(_userid, "1");

String userid = user.getUID()+"";

int customerid1 = Util.getIntValue(request.getParameter("customerid1"));/*具体某一个项目的id*/

ResourceComInfo rci = new ResourceComInfo();


String projName = "";
String projCode = "";
String prdctType = "";
String projManager = "";
String manager = "";
String planstartdate = "";
String planApprovalDate = "";
String gdrq = "";
String zjlf = "";
String deliveryModule = "";
String requirement = "";

RecordSet rs1 = new RecordSet();
String sql1 = "select cbi.*, ci.manager from proj_CardBaseInfo cbi "+
		" LEFT JOIN CRM_CustomerInfo ci on cbi.projCustomer = ci.id  " +
		" where cbi.id = "+customerid1;
rs1.executeSql(sql1);
if(rs1.next()){
	projName = Util.null2String(rs1.getString("projName")).trim();
	projCode = Util.null2String(rs1.getString("projCode")).trim();
	projManager = rci.getLastname(Util.null2String(rs1.getString("projManager")).trim());
	manager = rci.getLastname(Util.null2String(rs1.getString("manager")).trim());
	planstartdate = Util.null2String(rs1.getString("planstartdate")).trim();
	planApprovalDate = Util.null2String(rs1.getString("planApprovalDate")).trim();
	gdrq = Util.null2String(rs1.getString("gdrq")).trim();
	deliveryModule = Util.null2String(rs1.getString("deliveryModule")).trim();
	requirement = Util.null2String(rs1.getString("requirement")).trim();
	prdctType = Util.null2String(rs1.getString("prdctType")).trim();
}


String sum_execAmount = "0";
String sqlA1 = "select sum(ISNULL(cbied.execAmount, 0.0)) sum_execAmount from proj_CardBaseInfo cbi "+
" join proj_CardBaseInfoExec cbie on cbi.id = cbie.cbi_id "+
" join proj_CardBaseInfoExecDtl cbied on cbie.id = cbied.cbie_id "+
" where cbi.id = "+customerid1;
rs1.executeSql(sqlA1);
if(rs1.next()){
	sum_execAmount = PrjCardUtil.formatDecimal(rs1.getDouble("sum_execAmount"), "0.##");
	if(Util.getDoubleValue(sum_execAmount, 0) < 0){
		sum_execAmount = "0";
	}
}

String sum_inAmt = "0";
String sqlA2 = "select sum(inAmt) sum_inAmt from proj_CardBaseInfo cbi "+
" join proj_CardBaseInfoExec cbie on cbi.id = cbie.cbi_id "+
" join proj_CardBaseInfoExecDtl cbied on cbie.id = cbied.cbie_id "+
" join proj_CardBaseInfoExecAmtDtl cbiea on cbied.id = cbiea.cbied2_id "+
" where cbi.id = "+customerid1;
rs1.executeSql(sqlA2);
if(rs1.next()){
	sum_inAmt = PrjCardUtil.formatDecimal(rs1.getDouble("sum_inAmt"), "0.##");
	if(Util.getDoubleValue(sum_inAmt, 0) < 0){
		sum_inAmt = "0";
	}
}

String nskjh_sum_execAmount = "0";
String subSqlWhere = "select sum(ISNULL(cbied2.execAmount, 0.0)) sum_execAmount " +
		"from proj_CardBaseInfoExecDtl2 cbied2  " +
		"join proj_CardBaseInfoExecDtl cbied on cbied.id = cbied2.cbied_id  " +
		"join proj_CardBaseInfoExec cbie on cbie.id = cbied.cbie_id  " +
		"where cbie.cbi_id = "+customerid1+" " +
		" and ISNULL(cbied2.execAmount, 0.0) > 0 "+
		" and ( "+
		" ( " +
		"	cbied2.planFinishDate >= '"+yyyy+"-01-01' " +
		"	and   " +
		"	cbied2.planFinishDate <= '"+yyyy+"-12-31' " +
		" ) "+
		" or "+
		" ( " +
		"	cbied2.FinishDate >= '"+yyyy+"-01-01' " +
		"	and   " +
		"	cbied2.FinishDate <= '"+yyyy+"-12-31' " +
		" ) "+
		" ) ";
rs1.executeSql(subSqlWhere);
if(rs1.next()){
	nskjh_sum_execAmount = PrjCardUtil.formatDecimal(rs1.getDouble("sum_execAmount"), "0.##");
	if(Util.getDoubleValue(nskjh_sum_execAmount, 0) < 0){
		nskjh_sum_execAmount = "0";
	}
}

String nywc_sum_inAmt = "0";
String nywc_max_inDate = "";
subSqlWhere = "select sum(ISNULL(cbiea.inAmt, 0.0)) sum_inAmt, max(cbiea.inDate) max_inDate " +
		"from proj_CardBaseInfoExecAmtDtl cbiea " +
		"join proj_CardBaseInfoExecDtl cbied on cbied.id = cbiea.cbied2_id  " +
		"join proj_CardBaseInfoExec cbie on cbie.id = cbied.cbie_id  " +
		"where cbie.cbi_id = "+customerid1+" " +
		" and ( "+
		//"	cbiea.opDate >= '"+yyyy+"-01-01' " +
		//"	and   " +
		"	cbiea.inDate <= '"+yyyy+"-12-31' " +
		" ) ";
//out.print(subSqlWhere);
rs1.executeSql(subSqlWhere);
if(rs1.next()){
	nywc_sum_inAmt = PrjCardUtil.formatDecimal(rs1.getDouble("sum_inAmt"), "0.##");
	if(Util.getDoubleValue(nywc_sum_inAmt, 0) < 0){
		nywc_sum_inAmt = "0";
	}
	nywc_max_inDate = Util.null2String(rs1.getString("max_inDate"));
}

String yskjh_sum_execAmount = "0";
subSqlWhere = "select sum(ISNULL(cbied2.execAmount, 0.0)) sum_execAmount " +
		"from proj_CardBaseInfoExecDtl2 cbied2  " +
		"join proj_CardBaseInfoExecDtl cbied on cbied.id = cbied2.cbied_id  " +
		"join proj_CardBaseInfoExec cbie on cbie.id = cbied.cbie_id  " +
		"where cbie.cbi_id = "+customerid1+" " +
		" and ISNULL(cbied2.execAmount, 0.0) > 0 "+
		" and ( "+
		" ( " +
		"	cbied2.planFinishDate >= '"+yyyyMM+"-01' " +
		"	and   " +
		"	cbied2.planFinishDate <= '"+yyyyMM+"-31' " +
		" ) "+
		" or "+
		" ( " +
		"	cbied2.FinishDate >= '"+yyyyMM+"-01' " +
		"	and   " +
		"	cbied2.FinishDate <= '"+yyyyMM+"-31' " +
		" ) "+
		" ) ";
rs1.executeSql(subSqlWhere);
if(rs1.next()){
	yskjh_sum_execAmount = PrjCardUtil.formatDecimal(rs1.getDouble("sum_execAmount"), "0.##");
	if(Util.getDoubleValue(yskjh_sum_execAmount, 0) < 0){
		yskjh_sum_execAmount = "0";
	}
}

String yywc_sum_inAmt = "0";
subSqlWhere = "select sum(ISNULL(cbiea.inAmt, 0.0)) sum_inAmt " +
		"from proj_CardBaseInfoExecAmtDtl cbiea " +
		"join proj_CardBaseInfoExecDtl cbied on cbied.id = cbiea.cbied2_id  " +
		"join proj_CardBaseInfoExec cbie on cbie.id = cbied.cbie_id  " +
		"where cbie.cbi_id = "+customerid1+" " +
		" and ( "+
		"	cbiea.opDate >= '"+yyyyMM+"-01' " +
		"	and   " +
		"	cbiea.opDate <= '"+yyyyMM+"-31' " +
		" ) ";
rs1.executeSql(subSqlWhere);
if(rs1.next()){
	yywc_sum_inAmt = PrjCardUtil.formatDecimal(rs1.getDouble("sum_inAmt"), "0.##");
	if(Util.getDoubleValue(yywc_sum_inAmt, 0) < 0){
		yywc_sum_inAmt = "0";
	}
}

ResourceUtil prjUtil = new ResourceUtil();
String yskzb = prjUtil.getPrjZhiBiaoShouKuan(customerid1+"", yyyyMM.replace("-", "@"));
yskzb = PrjCardUtil.formatDecimal(Util.getDoubleValue(yskzb, 0), "0.##");
if(Util.getDoubleValue(yskzb, 0) < 0){
	yskzb = "0";
}
//产品类型
if("".equals(prdctType)){
	rs1.executeSql("select relporduct from proj_CardBaseInfo where id="+customerid1);
	if(rs1.next()){
		prdctType=prjUtil.tranPrdctType(rs1.getString(1));
	}
}



String a = "";
if(Util.getDoubleValue(sum_execAmount, 0)>0){
	a = Util.getPointValue2(""+(Util.getDoubleValue(sum_inAmt, 0) / Util.getDoubleValue(sum_execAmount, 0) * 100), 1);
}
//out.println(a);
String str = "产品类型: "+prdctType+" 客户经理: "+manager+" 立项日期: "+planstartdate+" 计划验收: "+planApprovalDate+" 实际验收: "+gdrq+" 总额: "+Util.itemDecimal(sum_execAmount)+" 已收: "+Util.itemDecimal(sum_inAmt)+"";
str += " 年收款计划: "+Util.itemDecimal(nskjh_sum_execAmount)+" 年已完成: "+Util.itemDecimal(nywc_sum_inAmt)+" 最近到账: "+nywc_max_inDate+" 月收款指标: "+Util.itemDecimal(yskzb)+" 月收款计划: "+Util.itemDecimal(yskjh_sum_execAmount)+" 月已完成: "+Util.itemDecimal(yywc_sum_inAmt)+"";

String json = callbackFunName + "({prjCode:\""+projCode+"\", prjName:\""+projName+"\", prjManager:\""+projManager+"\", prjCustomerManager:\""+manager+"\", prjReceived:\""+a+"\", prjTotal:\""+Util.itemDecimal(sum_execAmount)+"\", prjInfo:\""+str+"\"})";
out.println(json);
%>