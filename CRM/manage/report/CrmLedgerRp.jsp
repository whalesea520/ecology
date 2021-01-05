<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "客户统计";
String needfav ="1";
String needhelp ="";

String whereclause = " where exists (select 1 from CRM_CustomerInfo where manager=t.id)";
boolean canallview = false;
String sql = "select id from HrmRoleMembers where roleid=8 and resourceid="+user.getUID();
rs.executeSql(sql);
if(rs.next()){
	canallview = true;
}
if(!canallview) {
   whereclause += "and ( managerstr like '%,"+user.getUID()+",%' or id = "+user.getUID()+")";
}

String resource = Util.null2String(request.getParameter("viewer"));
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String viewernames = Util.fromScreen(request.getParameter("viewernames"),user.getLanguage());
String checkDeptIds = Util.fromScreen(request.getParameter("checkDeptId"),user.getLanguage());
String checkDeptnames = Util.fromScreen(request.getParameter("checkDeptnames"),user.getLanguage());
String cityid = Util.null2String(request.getParameter("cityid"));
String status = Util.null2String(request.getParameter("status"));


if(!resource.equals("")){
	whereclause += " and t.id in (" + resource + ") ";	
}
if(!checkDeptIds.equals("")){
	whereclause += " and t.departmentid in (" + checkDeptIds + ") ";	
}
if(status.equals("1")){
	whereclause += " and t.status in (0,1,2,3) ";	
}
if(status.equals("2")){
	whereclause += " and t.status > 3";	
}

String sqlwhere1 = "";
if(!cityid.equals("")){
	sqlwhere1 += " and city = "+cityid;
}

String sqlwhere = "";

String datestr = TimeUtil.getCurrentDateString();
sqlwhere = " and createdate like '%"+datestr.substring(0,7)+"%'";

if(!fromdate.equals("")){
	sqlwhere1 += " and createdate >= '"+fromdate+"'";

}
if(!enddate.equals("")){
	sqlwhere1 += " and createdate <= '"+enddate+"'";
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{导出-Excel,javascript:onExcel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		<form id=weaver name=frmmain method=post action="CrmLedgerRp.jsp">
		<table class=ViewForm>
		  <colgroup>
		  <col width="10%">
		  <col width="40%">
		  <col width="10%">
		  <col width="40%">
		  <tbody>
		  <tr> 
			<TD>人员</TD>
			<TD class=Field>
			  <button type="button" class=browser onClick="onShowResource()"></button>
			  <span id=viewerspan><%=viewernames%></span>
			  <input type=hidden name=viewernames value="<%=viewernames%>">
			  <input type=hidden name=viewer value="<%=resource%>">
			</TD>
			<TD>部门</TD>
			<TD class=Field>
			  <BUTTON class=Browser id=SelectDepID onClick="onShowDepartment()"></BUTTON>
			  <span id=deptName><%=checkDeptnames%></span>
			  <INPUT class=saveHistory id=checkDeptnames type=hidden name=checkDeptnames value="<%=checkDeptnames%>">
			  <INPUT class=saveHistory id=checkDeptId type=hidden name=checkDeptId value="<%=checkDeptIds%>">
			</TD>
		  </TR>
		  <tr style="height: 1px"><td class=Line colspan=4></td></tr>
		  <tr> 
			<TD>城市</TD>
			<TD class=Field>
			<BUTTON class=Browser id=SelectCityID onClick="onShowCityID()"></BUTTON> 
              <SPAN id=cityidspan STYLE="width=30%"><%=CityComInfo.getCityname(cityid)%></SPAN> 
              <INPUT id="cityid" type=hidden name="cityid" value="<%=cityid%>">               
			</TD>
			<TD>日期</TD>
			<TD class=Field>
			  <BUTTON class=calendar type="button" id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
			  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
			  <input type="hidden" name="fromdate" value=<%=fromdate%>>－&nbsp;<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
			  <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
			  <input type="hidden" name="enddate" value=<%=enddate%>>
			</TD>
		  </TR>
		  <tr style="height: 1px"><td class=Line colspan=4></td></tr>
		  <tr> 
			<TD>人员状态</TD>
			<TD class=Field colspan=4>
			  <select name="status"> 
			     <option value=""></option>
				 <option value="1" <%if("1".equals(status)){%>selected<%}%>>有效</option>
				 <option value="2" <%if("2".equals(status)){%>selected<%}%>>无效</option>
			  </select>
			</TD>
		  </TR>
		  <tr style="height: 1px"><td class=Line colspan=4></td></tr>
		</table>
		<br>
		<%
		String language = String.valueOf(user.getLanguage());
		String backFields = " id,departmentid,subcompanyid1,lastname,(select supsubcomid from hrmsubcompany where id=subcompanyid1) supsubcomid,(select count(t1.id) from CRM_CustomerInfo t1 where status=1 and manager = t.id "+sqlwhere1+") wxcount,(select count(t2.id) from CRM_CustomerInfo t2 where t2.status=2 and manager = t.id "+sqlwhere1+" ) jccount,(select count(t3.id) from CRM_CustomerInfo t3 where t3.status=3 and manager = t.id "+sqlwhere1+" ) qzcount,(select count(id) from CRM_SellChance where customerid in (select id from CRM_CustomerInfo where manager = t.id)) sellchance,(select count(distinct crmid) from workplan where createrid=t.id and type_n='3' "+sqlwhere+") contactlog ";
		String sqlFrom = " hrmresource t ";
		//out.println(backFields + sqlFrom + whereclause);
		String tableString=""+
			  "<table  pagesize=\"20\" tabletype=\"none\">"+
			  "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlorderby=\"id\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(whereclause)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"10%\" text=\"一级分部\" column=\"subcompanyid1\" orderkey=\"subcompanyid1\" otherpara=\"column:supsubcomid\" transmethod=\"weaver.crm.SptmForCrmModiRecord.getOneSubcompany\" />"+
					  "<col width=\"10%\" text=\"二级分部\" column=\"subcompanyid1\" orderkey=\"subcompanyid1\" linkkey=\"subcompanyid\" target=\"_fullwindow\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />"+
					  "<col width=\"15%\" text=\"部门\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" linkkey=\"id\" href=\"/hrm/company/HrmDepartmentDsp.jsp\"  target=\"_fullwindow\" />"+
					  "<col width=\"10%\" text=\"销售人员\" column=\"id\" orderkey=\"id\" linkkey=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" href=\"/hrm/resource/HrmResource.jsp?1=1\" target=\"_fullwindow\"/>"+
					  "<col width=\"10%\"  text=\"无效客户\" column=\"wxcount\" orderkey=\"wxcount\" linkkey=\"hrmid_1\" linkvaluecolumn=\"id\" href=\"/CRM/report/CrmLedgerCusView.jsp\" target=\"_fullwindow\" />"+
					  "<col width=\"10%\"  text=\"基础客户\" column=\"jccount\" orderkey=\"jccount\" linkkey=\"hrmid_2\" linkvaluecolumn=\"id\" href=\"/CRM/report/CrmLedgerCusView.jsp\" target=\"_fullwindow\" />"+
					  "<col width=\"10%\"  text=\"潜在客户\" column=\"qzcount\" orderkey=\"qzcount\" linkkey=\"hrmid_3\" linkvaluecolumn=\"id\" href=\"/CRM/report/CrmLedgerCusView.jsp\" target=\"_fullwindow\" />"+ 
					  "<col width=\"10%\"  text=\"销售商机\" column=\"sellchance\" orderkey=\"sellchance\" linkkey=\"hrmid\" linkvaluecolumn=\"id\" href=\"/CRM/report/ListCusSellChance.jsp\" target=\"_fullwindow\"/>"+ 
					  "<col width=\"15%\"  text=\"一个月内联系的活跃客户\" column=\"contactlog\" orderkey=\"contactlog\" linkkey=\"hrmid_4\" linkvaluecolumn=\"id\" href=\"/CRM/report/CrmLedgerCusView.jsp\" target=\"_fullwindow\" />"+ 
			  "</head>"+
			  "</table>";
		%>
		<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/>
		</form>
        </td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">
function onShowResource(){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if(data){
		if(data.id!=""){
			var namestmp = data.name;
			var idstmp = data.id;
			namestmp = namestmp.substring(1);
			idstmp = idstmp.substring(1);
			viewerspan.innerHTML = namestmp
			frmmain.viewernames.value = namestmp
			frmmain.viewer.value = idstmp
		}else{ 
			viewerspan.innerHTML = ""
			frmmain.viewernames.value = "";
			frmmain.viewer.value=""
		}
	}
}
function onShowDepartment(){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if(data){
		if(data.id!=""){
			var namestmp = data.name;
			var idstmp = data.id;
			namestmp = namestmp.substring(1);
			idstmp = idstmp.substring(1);
			deptName.innerHTML = namestmp
			frmmain.checkDeptnames.value = namestmp
			frmmain.checkDeptId.value = idstmp
		}else{ 
			deptName.innerHTML = ""
			frmmain.checkDeptnames.value = "";
			frmmain.checkDeptId.value=""
		}
	}
}

function onShowCityID(){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if(data){
		if(data.id!=""){
			var namestmp = data.name;
			var idstmp = data.id;
			cityidspan.innerHTML = namestmp
			frmmain.cityid.value = idstmp
		}else{ 
			cityidspan.innerHTML = ""
			frmmain.cityid.value = "";
		}
	}
}

function onExcel() {
    _xtable_getAllExcel();
}
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>