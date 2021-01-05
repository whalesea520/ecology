<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@ page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String o4searchTX = Util.null2String(request.getParameter("o4searchTX"));
String o4searchSL = Util.null2String(request.getParameter("o4searchSL"));

String companyid = Util.null2String(request.getParameter("companyid"));
//很关键的一个变量，用于判断后续页面是否开发编辑权限
//0--只有这个公司的查看权限，没有维护权限
//1--拥有这个公司查看和维护全县
String showOrUpdate =Util.null2String(request.getParameter("showOrUpdate"));

String maintFlag =Util.null2String(request.getParameter("maintFlag"));

//System.out.println("============maintFlag================="+maintFlag);
//System.out.println("============showOrUpdate================="+showOrUpdate);
String companyname = "";
String archivenum = "";
/* 公司基本表*/
String sqlinfo = "select * from CPCOMPANYINFO where companyid = " + companyid;
rs.execute(sqlinfo);
if(rs.next()){
	companyname = rs.getString("COMPANYNAME");
	archivenum = rs.getString("ARCHIVENUM");
}

int userid=user.getUID();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(446, user.getLanguage());
String needfav = "1";
String needhelp = "";
String licensename = Util.null2String(request.getParameter("nameQuery"));
String advQryFr = Util.null2String(request.getParameter("advQryFr"));
String advQryZs = Util.null2String(request.getParameter("advQryZs"));
String advQryFzrq = Util.null2String(request.getParameter("advQryFzrq"));
String advQryNjrq = Util.null2String(request.getParameter("advQryNjrq"));
String advQryFzdw = Util.null2String(request.getParameter("advQryFzdw"));

String id="";
%>
<HTML>
	<HEAD>
</head>
<BODY>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/proj/js/common_wev8.js"></script>


<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<script type="text/javascript">
//关闭
function doClose1(){
	window.closeDialog();
}
	
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});

/*刷新自身页面*/
function reloadListContent(){
	window.location.reload();
}


function onBtnSearchClick(from_advSubmit){
	if(from_advSubmit=="from_advSubmit"){
		jQuery("#nameQuery").val(jQuery("#advQryName").val());
	}else{
		jQuery("#advQryName").val(jQuery("#nameQuery").val());
	}
	document.getElementById("frmmain").submit();
}


function doView(licenseid){
	openDialog("/cpcompanyinfo/CompanyBusinessLicenseMaint.jsp?&btnid=viewBtn&licenseid="+licenseid+"&companyid=<%=companyid %>&showOrUpdate=<%=showOrUpdate%>", 
			"<%=SystemEnv.getHtmlLabelNames("31022", user.getLanguage()) %>", 
			1000, 650,false,true);
}
	

function addNew(){//openDialog(url,title,800,550,false,true);

	var url = "/cpcompanyinfo/CompanyBusinessLicenseMaint.jsp?companyid=<%=companyid %>&btnid=newBtn";
	var title = "<%=SystemEnv.getHtmlLabelNames("31021", user.getLanguage()) %>" ;
	openDialog(url,title,1000,650,false,true);
}

function doEdit(licenseid){
	openDialog("/cpcompanyinfo/CompanyBusinessLicenseMaint.jsp?&btnid=editBtn&licenseid="+licenseid+"&companyid=<%=companyid %>&showOrUpdate=<%=showOrUpdate%>", 
			"<%=SystemEnv.getHtmlLabelNames("31023", user.getLanguage()) %>", 
			1000, 650,false,true);
}

//删除
function doDel(licenseid){

	if(confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>？")){
			var o4params = {
				method:"del",
				licenseids:licenseid
			};
		
			jQuery.post("/cpcompanyinfo/action/CPLicenseOperate.jsp",o4params,function(data){
				reflush2List();
			});
			reloadListContent();
		}
}

//批量删除
function batchDel(){
		var licenseids = "";
		$("input[name='chkInTableTag']").each(function(){
		if($(this).attr("checked"))			
			licenseids = licenseids +$(this).attr("checkboxId")+",";
		});
		
		if(""==licenseids){
			alert("<%=SystemEnv.getHtmlLabelNames("84087",user.getLanguage())%>");
			return;
		}
		
		if(confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>？")){
			var o4params = {
				method:"del",
				licenseids:licenseids
			};
		
			jQuery.post("/cpcompanyinfo/action/CPLicenseOperate.jsp",o4params,function(data){
				reflush2List();
			});
			
			reloadListContent();
		}
}
</script>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<form class=ViewForm id="frmmain" action="/cpcompanyinfo/CompanyBusinessLicenseList.jsp" method="post">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button" id="saveBoa" value="<%=SystemEnv.getHtmlLabelNames("1290",user.getLanguage())%>" class="e8_btn_top" onclick="javascript:history.go(-1)"/>
					<input type="text" class="searchInput" id="nameQuery" name="nameQuery" value="<%=licensename %>" /><!-- 快速搜索 -->
					&nbsp;&nbsp;&nbsp;
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span><!-- 高级搜索 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		

<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
	
	<wea:layout type="4Col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelNames("32905",user.getLanguage())%>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(30945,user.getLanguage())%></wea:item><!-- 证照名称* -->
		    <wea:item>
		    	<input type=text id="advQryName" name="advQryName" class=Inputstyle value='<%=licensename %>' />
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(23797,user.getLanguage())%></wea:item><!-- 法人* -->
	    	<wea:item>
		    	<input type=text id="advQryFr" name="advQryFr" class=Inputstyle value='<%=advQryFr %>' />
	    	</wea:item>
	    	
	    	<wea:item><%=SystemEnv.getHtmlLabelName(31133,user.getLanguage())%></wea:item><!-- 住所* -->
		    <wea:item>
		    	<input type=text id="advQryZs" name="advQryZs" class=Inputstyle value='<%=advQryZs %>' />
		    </wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(31020,user.getLanguage())%></wea:item><!-- 发证单位* -->
		    <wea:item>
		    	<input type=text id="advQryFzdw" name="advQryFzdw" class=Inputstyle value='<%=advQryFzdw %>' />
		    </wea:item>
	    	
	    	<wea:item><%=SystemEnv.getHtmlLabelName(28339,user.getLanguage())%></wea:item><!-- 发证日期* -->
	    	<wea:item>
		    	<input type="hidden" id="advQryFzrq" name="advQryFzrq" value='<%=advQryFzrq %>' />
		    	<button class="calendar" type="button" id="bntadvQryFzrq" onclick="_gdt('advQryFzrq', 'spanadvQryFzrq', 'undefined');"></button>
				<span id="spanadvQryFzrq"><%=advQryFzrq %></span>
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(31030,user.getLanguage())%></wea:item><!-- 年检日期* -->
	    	<wea:item>
		    	<input type="hidden" id="advQryNjrq" name="advQryNjrq" value='<%=advQryNjrq %>' />
		    	<button class="calendar" type="button" id="btnadvQryNjrq" onclick="_gdt('advQryNjrq', 'spanadvQryNjrq', 'undefined');"></button>
				<span id="spanadvQryNjrq"><%=advQryNjrq %></span>
	    	</wea:item>
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="e8_btn_submit" type="button" id="advSubmit" onclick="onBtnSearchClick('from_advSubmit');" 
	    			value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/><!-- 查询 -->
	    		<input class="e8_btn_submit" type="button" id="advReset" onclick="resetCondtion();"
	    			value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"/><!-- 重置 -->
	    		<input class="e8_btn_cancel" type="button" id="cancel" 
	    			value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/><!-- 取消 -->
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>	

		<input id="companyid" name="companyid" value="<%=companyid %>" type="hidden" />
		<input id="showOrUpdate" name="showOrUpdate" value="<%=showOrUpdate %>" type="hidden" />
	<input id="maintFlag" name="maintFlag" value="<%=maintFlag %>" type="hidden" />
		
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("84088",user.getLanguage())%>' attributes=""> 
		<wea:item type="groupHead">
			<%if(maintFlag.equals("true")){ %>
	     	<input class="addbtn" accesskey="A" onclick="addNew()" title="<%=SystemEnv.getHtmlLabelNames("611",user.getLanguage())%>" type="button">
			<input class="delbtn" accesskey="E" onclick="batchDel()" title="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>" type="button">
			<%} %>
	    </wea:item>
		<wea:item attributes="{'isTableList':'true'}">

<%
String sqlwhere1 = "";
if(!o4searchTX.equals("")){
	sqlwhere1 += " and "+o4searchSL+" like '%"+o4searchTX+ "%'";
}
if(!"".equals(licensename)){
	sqlwhere1 += " and exists (select 1 from CPLMLICENSEAFFIX tla where tla.licensename like '%"+StringEscapeUtils.escapeSql(licensename)+"%' and tla.licenseaffixid = t1.licenseaffixid) ";
}
if(!"".equals(advQryFzrq)){
	sqlwhere1 += " and t1.dateinssue = '"+StringEscapeUtils.escapeSql(advQryFzrq)+"' ";
}
if(!"".equals(advQryFzdw)){
	sqlwhere1 += " and t1.departinssue like '%"+StringEscapeUtils.escapeSql(advQryFzdw)+"%' ";
}
if(!"".equals(advQryNjrq)){
	sqlwhere1 += " and t1.ANNUALINSPECTION = '"+StringEscapeUtils.escapeSql(advQryNjrq)+"' ";
}
if(!"".equals(advQryZs)){
	sqlwhere1 += " and t1.REGISTERADDRESS like '%"+StringEscapeUtils.escapeSql(advQryZs)+"%' ";
}
if(!"".equals(advQryFr)){
	sqlwhere1 += " and t1.CORPORATION like '%"+StringEscapeUtils.escapeSql(advQryFr)+"%' ";
}

int language=user.getLanguage();
String backfields = " t1.licenseid,t1.licenseaffixid,(select tla.affixindex from CPLMLICENSEAFFIX tla where tla.licenseaffixid = t1.licenseaffixid) affixindex, "+
	" (select tla.licensename from CPLMLICENSEAFFIX tla where tla.licenseaffixid = t1.licenseaffixid) licensename, "+
	" t1.dateinssue,t1.departinssue,t1.memo,t1.affixdoc,t1.createdatetime ,'"+showOrUpdate+"'  as showOrUpdate,"+language+" as language";
String fromSql = " CPBUSINESSLICENSE t1 ";
String sqlwhere = " where t1.isdel='T' and t1.companyid =" + companyid + sqlwhere1;
String sqlorderby = " t1.licenseaffixid ";
String sqlsortway = " asc ";
String refComlog = "column:showOrUpdate+column:language";
//out.println(refComlog);
//out.println("select "+backfields+" "+fromSql+" "+sqlwhere);
String pageId="cpcompanyinfo_CompanyBusinessLicenseList";
StringBuffer tableString = new StringBuffer();
tableString .append(" <table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID())+"\" width=\"100%\" isfixed=\"true\" isnew= \"true\" > ");
//tableString .append(" <checkboxpopedom    popedompara=\"column:t1.licenseid\" showmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getIsShowBox\" />");
tableString .append(" <sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" "+
	" sqlorderby=\""+Util.toHtmlForSplitPage(sqlorderby)+"\"  sqlprimarykey=\"t1.licenseid\" sqlisdistinct=\"false\" sqlsortway=\""+Util.toHtmlForSplitPage(sqlsortway)+"\"  />");
tableString .append(" <head>");                  
tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(31019,user.getLanguage())+"\"  column=\"affixindex\"   orderkey=\"affixindex\"  align=\"center\" width=\"8%\"  transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getAffixindex\" />");      
tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(30945,user.getLanguage())+"\"  column=\"licensename\"   orderkey=\"licensename\"   align=\"center\" width=\"20%\" />");
tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(28339,user.getLanguage())+"\" column=\"dateinssue\"    align=\"center\"  width=\"10%\"	 />");
tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(31020,user.getLanguage())+"\" column=\"departinssue\"   align=\"center\"  width=\"20%\" />");        
tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(20820,user.getLanguage())+"\"   column=\"memo\" orderkey=\"memo\" align=\"center\"  width=\"10%\"  />");
tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(156,user.getLanguage())+"\" column=\"affixdoc\" transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getAffixDown\"  width=\"5%\"  align=\"center\"  />");     
tableString.append("	<col   text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdatetime\"    align=\"center\"  width=\"16%\" />");
tableString.append("  </head>");
 //tableString.append("	<col  text=\""+SystemEnv.getHtmlLabelName(30585,user.getLanguage()) +"\"  column=\"licenseid\"     otherpara=\""+refComlog+"\"    align=\"center\"   width=\"16%\"   transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getLicenseOperating\"/>");
tableString.append("<operates>"+
	"<popedom column=\"licenseid\" transmethod=\"weaver.cpcompanyinfo.CompanyInfoTransMethod.getLicenseOperating4E8\" otherpara=\""+refComlog+"\" ></popedom> "+
	"<operate href=\"javascript:doView();\" text=\""+SystemEnv.getHtmlLabelName(367, user.getLanguage())+"\" index=\"0\"/>"+//查看
	"<operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" index=\"1\"/>"+//编辑
	"<operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"\" index=\"2\"/>"+//删除
	"</operates>");
tableString.append("  </table>");
%>
<input type="hidden" name="pageId" id="pageId" value="<%=pageId  %>" />
			<wea:SplitPageTag tableString='<%=tableString.toString()%>' mode="run" />
				
		</wea:item>
	</wea:group>
</wea:layout>

		</form>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	</BODY>
</HTML>


