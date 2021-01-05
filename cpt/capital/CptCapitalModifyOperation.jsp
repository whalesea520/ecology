<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CptSearchComInfo" class="weaver.cpt.search.CptSearchComInfo" scope="session" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%

if(!HrmUserVarify.checkUserRight("CptCapital:modify", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String userid = ""+user.getUID();
String Tempdeptid=""+user.getUserDepartment();
String	departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());/*部门*/
String	resourceid = Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
/*
权限判断,资产管理员以及其所有上级
boolean canView = false;
ArrayList allCanView = new ArrayList();
String sql = "select resourceid from HrmRoleMembers where roleid = 7 ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	String tempid = RecordSet.getString("resourceid");
	allCanView.add(tempid);
	AllManagers.getAll(tempid);
	while(AllManagers.next()){
		allCanView.add(AllManagers.getManagerID());
	}
}// end while

for (int i=0;i<allCanView.size();i++){
	if(userid.equals((String)allCanView.get(i))){
		canView = true;
	}
}


if(!canView) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
权限判断结束
*/


CptSearchComInfo.resetSearchInfo();

String from = Util.fromScreen(request.getParameter("from"),user.getLanguage()) ;				/*查询走向*/

String  mark = Util.fromScreen(request.getParameter("mark"),user.getLanguage()) ;				/*编号*/
String	name = Util.fromScreen2(request.getParameter("name"),user.getLanguage());			/*名称*/
String	startdate = Util.fromScreen(request.getParameter("startdate"),user.getLanguage());			/*生效日*/
String	startdate1 = Util.fromScreen(request.getParameter("startdate1"),user.getLanguage());			/*生效日*/
String	enddate= Util.fromScreen(request.getParameter("enddate"),user.getLanguage());				/*生效至*/
String	enddate1= Util.fromScreen(request.getParameter("enddate1"),user.getLanguage());				/*生效至*/
String	seclevel= Util.fromScreen(request.getParameter("seclevel"),user.getLanguage());				/*安全级别*/
String	seclevel1= Util.fromScreen(request.getParameter("seclevel1"),user.getLanguage());				/*安全级别*/
//String	departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());/*部门*/
//out.println(departmentid);
if (departmentid.equals("0")){ departmentid="";}
String	costcenterid = Util.fromScreen(request.getParameter("costcenterid"),user.getLanguage());			/*成本中心*/
if (costcenterid.equals("0")){ costcenterid="";}
//String	resourceid = Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());		/*人力资源*/
if (resourceid.equals("0")){ resourceid="";}
if (resourceid.equals("-1")){ resourceid="0";}
String	currencyid = Util.fromScreen(request.getParameter("currencyid"),user.getLanguage());	/*币种*/
if (currencyid.equals("0")){ currencyid="";}
String	capitalcost = Util.fromScreen(request.getParameter("capitalcost"),user.getLanguage());	/*成本*/
String	capitalcost1 = Util.fromScreen(request.getParameter("capitalcost1"),user.getLanguage());	/*成本*/
String	startprice = Util.fromScreen(request.getParameter("startprice"),user.getLanguage());	/*开始价格*/
String	startprice1 = Util.fromScreen(request.getParameter("startprice1"),user.getLanguage());	/*开始价格*/
String	depreendprice = Util.fromScreen(request.getParameter("depreendprice"),user.getLanguage()); /*折旧底价(新)*/
String	depreendprice1 = Util.fromScreen(request.getParameter("depreendprice1"),user.getLanguage()); /*折旧底价(新)*/
String	capitalspec = Util.fromScreen(request.getParameter("capitalspec"),user.getLanguage());			/*规格型号(新)*/
String	capitallevel = Util.fromScreen(request.getParameter("capitallevel"),user.getLanguage());	/*资产等级(新)*/
String	manufacturer = Util.fromScreen(request.getParameter("manufacturer"),user.getLanguage());			/*制造厂商(新)*/
String	manudate	= Util.fromScreen(request.getParameter("manudate"),user.getLanguage());			/*出厂日期(新)*/
String	manudate1	= Util.fromScreen(request.getParameter("manudate1"),user.getLanguage());			/*出厂日期(新)*/
String	capitaltypeid = Util.fromScreen(request.getParameter("capitaltypeid"),user.getLanguage());			/*资产类型*/
if (capitaltypeid.equals("0")){ capitaltypeid="";}
String	capitalgroupid = Util.fromScreen(request.getParameter("capitalgroupid"),user.getLanguage());			/*资产组*/
if (capitalgroupid.equals("0")){ capitalgroupid="";}
String	unitid = Util.fromScreen(request.getParameter("unitid"),user.getLanguage());				/*计量单位*/
if (unitid.equals("0")){ unitid="";}
String	capitalnum = Util.fromScreen(request.getParameter("capitalnum"),user.getLanguage());			/*数量*/
String	capitalnum1 = Util.fromScreen(request.getParameter("capitalnum1"),user.getLanguage());			/*数量*/
String	currentnum = Util.fromScreen(request.getParameter("currentnum"),user.getLanguage());			/*当前数量*/
String	currentnum1 = Util.fromScreen(request.getParameter("currentnum1"),user.getLanguage());			/*当前数量*/
String	replacecapitalid =Util.fromScreen(request.getParameter("replacecapitalid"),user.getLanguage());				/*替代*/
if (replacecapitalid.equals("0")){ replacecapitalid="";}
String	version =Util.fromScreen(request.getParameter("version"),user.getLanguage()) ;			/*版本*/
String	itemid =Util.fromScreen(request.getParameter("itemid"),user.getLanguage());			/*物品*/
if (itemid.equals("0")){ itemid="";}
String	depremethod1 =Util.fromScreen(request.getParameter("depremethod1"),user.getLanguage());			/*折旧法一*/
if (depremethod1.equals("0")){ depremethod1="";}
String	depremethod2 =Util.fromScreen(request.getParameter("depremethod2"),user.getLanguage());			/*折旧法二*/
if (depremethod2.equals("0")){ depremethod2="";}
String	deprestartdate =Util.fromScreen(request.getParameter("deprestartdate"),user.getLanguage());		/*折旧开始日期*/
String	deprestartdate1 =Util.fromScreen(request.getParameter("deprestartdate1"),user.getLanguage());		/*折旧开始日期*/
String	depreenddate = Util.fromScreen(request.getParameter("depreenddate"),user.getLanguage()) ;			/*折旧结束日期*/
String	depreenddate1 = Util.fromScreen(request.getParameter("depreenddate1"),user.getLanguage()) ;			/*折旧结束日期*/
String	customerid=Util.fromScreen(request.getParameter("customerid"),user.getLanguage());			/*客户id*/
if (customerid.equals("0")){ customerid="";}
String	attribute= Util.fromScreen(request.getParameter("attribute"),user.getLanguage());
String	stateid = Util.fromScreen(request.getParameter("stateid"),user.getLanguage());	/*资产状态*/
if (stateid.equals("0")){ stateid="";}
String	location = Util.fromScreen(request.getParameter("location"),user.getLanguage()) ;			/*存放地点*/
String	isdata = Util.fromScreen(request.getParameter("isdata"),user.getLanguage()) ;			/*存放地点*/
String	counttype = Util.fromScreen(request.getParameter("counttype"),user.getLanguage());	/*固资或低耗*/
if (counttype.equals("0")){ counttype="";}
String	isinner = Util.fromScreen(request.getParameter("isinner"),user.getLanguage());	/*帐内或帐外*/
//if (isinner.equals("0")){ isinner="";}

//set CptSearchComInfo values------------------------------------
CptSearchComInfo.setMark(mark);
CptSearchComInfo.setName(name);
CptSearchComInfo.setStartdate(startdate);
CptSearchComInfo.setStartdate1(startdate1);
CptSearchComInfo.setEnddate(enddate);
CptSearchComInfo.setEnddate1(enddate1);
CptSearchComInfo.setSeclevel(seclevel);
CptSearchComInfo.setSeclevel1(seclevel1);
CptSearchComInfo.setDepartmentid(departmentid);
CptSearchComInfo.setCostcenterid(costcenterid);
CptSearchComInfo.setResourceid(resourceid);
CptSearchComInfo.setCurrencyid(currencyid);
CptSearchComInfo.setCapitalcost(capitalcost);
CptSearchComInfo.setCapitalcost1(capitalcost1);
CptSearchComInfo.setStartprice(startprice);
CptSearchComInfo.setStartprice1(startprice1);
CptSearchComInfo.setDepreendprice(depreendprice);
CptSearchComInfo.setDepreendprice1(depreendprice1);
CptSearchComInfo.setCapitalspec(capitalspec);
CptSearchComInfo.setCapitallevel(capitallevel);
CptSearchComInfo.setManufacturer(manufacturer);
CptSearchComInfo.setManudate(manudate);
CptSearchComInfo.setManudate1(manudate1);
CptSearchComInfo.setCapitaltypeid(capitaltypeid);
CptSearchComInfo.setCapitalgroupid(capitalgroupid);
CptSearchComInfo.setUnitid(unitid);
CptSearchComInfo.setCapitalnum(capitalnum);
CptSearchComInfo.setCapitalnum1(capitalnum1);
CptSearchComInfo.setCurrentnum(currentnum);
CptSearchComInfo.setCurrentnum1(currentnum1);
CptSearchComInfo.setReplacecapitalid(replacecapitalid);
CptSearchComInfo.setVersion(version);
CptSearchComInfo.setItemid(itemid);
CptSearchComInfo.setDepremethod1(depremethod1);
CptSearchComInfo.setDepremethod2(depremethod2);
CptSearchComInfo.setDeprestartdate(deprestartdate);
CptSearchComInfo.setDeprestartdate1(deprestartdate1);
CptSearchComInfo.setDepreenddate(depreenddate);
CptSearchComInfo.setDepreenddate1(depreenddate1);
CptSearchComInfo.setCustomerid(customerid);
CptSearchComInfo.setAttribute(attribute);
CptSearchComInfo.setStateid(stateid);
CptSearchComInfo.setLocation(location);
CptSearchComInfo.setIsData(isdata);
CptSearchComInfo.setCountType(counttype);
CptSearchComInfo.setIsInner(isinner);

//out.println("STRing is "+CptSearchComInfo.FormatSQLSearch());
String type= Util.fromScreen(request.getParameter("type"),user.getLanguage()) ;
/*
if(type.equals("search")){
    response.sendRedirect("CptSearchResult.jsp?type=search");
}
*/

//是否分权系统，如不是，则不显示框架，直接转向到列表页面
RecordSet.executeSql("select detachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
    detachable=RecordSet.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
}
if(detachable==0){
    response.sendRedirect("CptCapitalModify.jsp?mark=" + mark);
}else{
    //response.sendRedirect("CptCapMod_frm.jsp");
    %>
    <script type="text/javascript">
	<!--
	if(window.parent.frames[0].name=="leftframe"){
		window.parent.location.href="CptCapMod_frm.jsp";
	}else{
		window.location.href="CptCapMod_frm.jsp";
	}
	//-->
	</script>
    <%
}
%>
