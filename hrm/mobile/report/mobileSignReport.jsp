<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.mobile.sign.*"%>
<%@ page import="weaver.file.*"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="signIn" class="weaver.hrm.mobile.signin.SignInManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
boolean hasViewAllRight = false;
if(HrmUserVarify.checkUserRight("MobileSignInfo:Manage", user)){
	hasViewAllRight = true;
}

Calendar today = Calendar.getInstance ();
String currentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
                   + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
                   + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);

String fromDate = Util.null2String(request.getParameter("fromDate")).trim();
String toDate = Util.null2String(request.getParameter("toDate")).trim();

if(fromDate.equals("")||toDate.equals("")){
	fromDate = currentDate;
	toDate = currentDate;
}

String subCompanyId = Util.null2String(request.getParameter("subCompanyId")).trim();
String departmentId = Util.null2String(request.getParameter("departmentId")).trim();
String resourceId = Util.null2String(request.getParameter("resourceId")).trim();
String _level = "";
if(!hasViewAllRight){
	resourceId = ""+user.getUID();
    departmentId = ""+user.getUserDepartment();
    subCompanyId = ""+user.getUserSubCompany1();
} else {
	_level = strUtil.vString(HrmUserVarify.getRightLevel("MobileSignInfo:Manage", user));
	if(_level.equals("0")) {
		departmentId=""+user.getUserDepartment();
		subCompanyId=""+user.getUserSubCompany1();
	} else if(_level.equals("1")) {
		subCompanyId=""+user.getUserSubCompany1();
	}
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(125529,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<iframe id="ExcelOut" name="ExcelOut" style="display:none;" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" class="e8_btn_top" onclick="submitData(this);" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name=frmMain id="frmMain" method=post action="/hrm/mobile/report/mobileSignReport.jsp">
			<wea:layout type="4col">
				<wea:group context="<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>">
					<wea:item><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
					<wea:item>
						<BUTTON type=button class=calendar id=SelectDate onclick=onShowDate(fromDateSpan,fromDate)></BUTTON>&nbsp;
					    <SPAN id=fromDateSpan ><%=fromDate%></SPAN>
					    <input class="inputstyle" type="hidden" id="fromDate" name="fromDate" value="<%=fromDate%>">
					    －<BUTTON type=button class=calendar id=SelectDate onclick=onShowDate(toDateSpan,toDate)></BUTTON>&nbsp;
					    <SPAN id=toDateSpan ><%=toDate%></SPAN>
					    <input class="inputstyle" type="hidden" id="toDate" name="toDate" value="<%=toDate%>">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(hasViewAllRight && _level.equals("2")){%>
						<span>
							<brow:browser viewType="0" name="subCompanyId" browserValue="<%=subCompanyId%>" 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=164" width="60%" browserSpanValue="<%=SubCompanyComInfo.getSubcompanynames(subCompanyId)%>">
							</brow:browser>
						</span>
						<%}else{%>
							<span id="subCompanyNameSpan"><%=SubCompanyComInfo.getSubcompanynames(subCompanyId)%></span> 
							<input class="inputStyle" id="subCompanyId" type="hidden" name="subCompanyId" value="<%=subCompanyId%>">
						<%} %>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(hasViewAllRight && (_level.equals("1") || _level.equals("2"))){%>
						<span>
							<brow:browser viewType="0" name="departmentId" browserValue="<%=departmentId%>" 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=4" width="60%" browserSpanValue="<%=DepartmentComInfo.getDeptnames(departmentId)%>">
							</brow:browser>
						</span>
						<%}else{%>
							<SPAN id="departmentNameSpan"><%=DepartmentComInfo.getDeptnames(departmentId)%></SPAN> 
							<INPUT class="inputstyle" type="hidden" name="departmentId" value="<%=departmentId%>" >
						<%} %>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(125530,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(hasViewAllRight){%>
						<span>
							<brow:browser viewType="0" name="resourceId" browserValue="<%=resourceId%>" 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=1" width="60%" browserSpanValue="<%=ResourceComInfo.getLastnames(resourceId)%>">
							</brow:browser>
						</span>
						<%}else{%>
							<SPAN id="resourceNameSpan"><%=ResourceComInfo.getLastnames(resourceId)%></SPAN> 
							<INPUT class="inputstyle" type="hidden" name="resourceId" value="<%=resourceId%>" >
						<%} %>
					</wea:item>
				</wea:group>
			</wea:layout>
</form>
<wea:layout type="2col">
<wea:group context="<%=SystemEnv.getHtmlLabelName(125529,user.getLanguage())%>">
<wea:item attributes="{'isTableList':'true','colspan':'full'}">
<TABLE ID="BrowseTable" class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
	<TR class=DataHeader>
		<TH width="8%"><%=SystemEnv.getHtmlLabelName(33563,user.getLanguage())%></TH>
		<TH width="8%"><%=SystemEnv.getHtmlLabelName(20035,user.getLanguage())%></TH>
		<TH width="8%"><%=SystemEnv.getHtmlLabelName(125530,user.getLanguage())%></TH>
		<TH width="10%"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TH>
		<TH width="10%"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH>
		<TH width="26%"><%=SystemEnv.getHtmlLabelName(125531,user.getLanguage())%></TH>
		<TH width="22%"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
		<TH width="8%"><%=SystemEnv.getHtmlLabelName(25996,user.getLanguage())%></TH>
	</TR>
	<TR class=Line style="height: 1px"><TH colspan="2"></TH></TR>
<%
ExcelSheet es = new ExcelSheet();
ExcelRow er = es.newExcelRow();
er.addStringValue(SystemEnv.getHtmlLabelName(33563,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(20035,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(125530,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(141,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(125531,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(454,user.getLanguage()));
er.addStringValue(SystemEnv.getHtmlLabelName(25996,user.getLanguage()));
es.addExcelRow(er);

boolean line = true;
String lineClass = "DataLight";
String beginQueryDate = fromDate+" 00:00:00";
String endQueryDate = toDate+" 23:59:59";
String resourceSql = "select id from HrmResource where status in (0,1,2,3,5)";
if(!"".equals(resourceId)){
	resourceSql += " and id in ("+resourceId+")";
}else if(!"".equals(departmentId)){
	resourceSql += " and departmentid in ("+departmentId+")";
}else if(!"".equals(subCompanyId)){
	resourceSql += " and subcompanyid1 in ("+subCompanyId+")";
}
StringBuilder sql = new StringBuilder();
if(rs.getDBType().equals("oracle")){
	sql.append("select 'hrm'||cast(id as VARCHAR(10)) uniqueid,id,userId as operater,'hrm_sign' as operate_type,signDate as operate_date,signTime as operate_time,LONGITUDE,LATITUDE,ADDR as address,'"+SystemEnv.getHtmlLabelNames("15880,20032",user.getLanguage())+"' as remark,'' as attachment,signtype from HrmScheduleSign ");
}else{
	sql.append("select 'hrm'+cast(id as VARCHAR(10)) uniqueid,id,userId as operater,'hrm_sign' as operate_type,signDate as operate_date,signTime as operate_time,LONGITUDE,LATITUDE,ADDR as address,'"+SystemEnv.getHtmlLabelNames("15880,20032",user.getLanguage())+"' as remark,'' as attachment,signtype from HrmScheduleSign ");
}
sql.append("where isInCom='1' and userId in (").append(resourceSql).append(") ");
if(rs.getDBType().equals("oracle")){
	if(!"".equals(beginQueryDate)){
		sql.append(" AND signDate||' '||signTime>='").append(beginQueryDate).append("' ");
	}
	if(!"".equals(endQueryDate)){
		sql.append(" AND signDate||' '||signTime<='").append(endQueryDate).append("' ");
	}
	sql.append(" AND LONGITUDE is not null and LATITUDE is not null ");
}else{
	if(!"".equals(beginQueryDate)){
		sql.append(" AND signDate+' '+signTime>='").append(beginQueryDate).append("' ");
	}
	if(!"".equals(endQueryDate)){
		sql.append(" AND signDate+' '+signTime<='").append(endQueryDate).append("' ");
	}
	sql.append(" AND LONGITUDE!='' and LATITUDE!='' ");
}
sql.append(" UNION ");
if(rs.getDBType().equals("oracle")){
	sql.append(" select 'sign'||cast(id as VARCHAR(10)) uniqueid,t.id,t.operater,t.operate_type,trim(t.operate_date) as operate_date,");
	sql.append(" t.operate_time,t.longitude,t.latitude,t.address,t.remark,t.attachment,'1' as signtype from mobile_sign t ");
}else{
	sql.append(" select 'sign'+cast(id as VARCHAR(10)) uniqueid,t.id,t.operater,t.operate_type,t.operate_date as operate_date,");
	sql.append(" t.operate_time,t.longitude,t.latitude,t.address,t.remark,t.attachment,'1' as signtype from mobile_sign t ");
}
sql.append(" WHERE t.operater in (").append(resourceSql).append(")");
if(rs.getDBType().equals("oracle")){
	if(!"".equals(beginQueryDate)){
		sql.append(" AND  trim(t.operate_date)||' '||t.operate_time>='").append(beginQueryDate).append("'");
	}
	if(!"".equals(endQueryDate)){
		sql.append(" AND trim(t.operate_date)||' '||t.operate_time<='").append(endQueryDate).append("'");
	}
}else{
	if(!"".equals(beginQueryDate)){
		sql.append(" AND  t.operate_date+' '+t.operate_time>='").append(beginQueryDate).append("'");
	}
	if(!"".equals(endQueryDate)){
		sql.append(" AND t.operate_date+' '+t.operate_time<='").append(endQueryDate).append("'");
	}
}
sql.append(" ORDER BY operate_date desc,operate_time desc");
rs.executeSql(sql.toString());
while(rs.next()){
	if(line){
		line = false;
		lineClass = "DataLight";
	}else{
		line = true;
		lineClass = "DataDark";
	}
	String signDate = Util.null2String(rs.getString("operate_date"));
	String signTime = Util.null2String(rs.getString("operate_time"));
	String userId = Util.null2String(rs.getString("operater"));
	String signType = signIn.getShowName(SignType.getInstance(Util.null2String(rs.getString("operate_type"))));
	String address = Util.null2String(rs.getString("address"));
	String remark = Util.null2String(rs.getString("remark")).trim();
	String signtype = Util.null2String(rs.getString("signtype")).trim();
	if("2".equals(signtype)){
		remark = SystemEnv.getHtmlLabelName(125526,user.getLanguage());
	}
	if("".equals(remark)){
		remark = SystemEnv.getHtmlLabelName(125527,user.getLanguage());
	}
	
	er = es.newExcelRow();
	er.addStringValue(signDate);
	er.addStringValue(signTime);
	er.addStringValue(ResourceComInfo.getLastname(userId));
	er.addStringValue(SubCompanyComInfo.getSubCompanyname(ResourceComInfo.getSubCompanyID(userId)));
	er.addStringValue(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(userId)));
	er.addStringValue(address);
	er.addStringValue(remark);
	er.addStringValue(signType);
	es.addExcelRow(er);
%>
	<TR class="<%=lineClass%>">
		<TD width="8%" style="padding-left:12px;padding-right:5px;"><%=signDate%></TD>
		<TD width="8%" style="padding-left:12px;padding-right:5px;"><%=signTime%></TD>
		<TD width="8%" style="padding-left:12px;padding-right:5px;"><%=ResourceComInfo.getLastname(userId)%></TD>
		<TD width="10%" style="padding-left:12px;padding-right:5px;"><%=SubCompanyComInfo.getSubCompanyname(ResourceComInfo.getSubCompanyID(userId))%></TD>
		<TD width="10%" style="padding-left:12px;padding-right:5px;"><%=DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(userId))%></TD>
		<TD width="26%" style="padding-left:12px;padding-right:5px;"><%=address%></TD>
		<TD width="22%" style="padding-left:12px;padding-right:5px;"><%=remark%></TD>
		<TD width="8%" style="padding-left:12px;padding-right:5px;"><%=signType%></TD>
	</TR>
	<TR class=Line style="height: 1px"><td colspan="2"></td></TR>
<%}
ExcelFile.init();
ExcelFile.setFilename(SystemEnv.getHtmlLabelName(125529,user.getLanguage()));
ExcelFile.addSheet(SystemEnv.getHtmlLabelName(125529,user.getLanguage()),es);
%>
</TABLE>
</wea:item>
</wea:group>
</wea:layout>
</BODY>
</HTML>
<script language=javascript>
function submitData(obj){
	if(check_form(document.frmMain,"fromDate,toDate")){
		if(jQuery("#fromDate").val() > jQuery("#toDate").val()) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
		}else{
			obj.disabled = true;
			jQuery("#frmMain").submit();
		}
	}
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>