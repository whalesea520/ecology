<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("LogView:View", user))  {
        response.sendRedirect("/notice/noright.jsp") ;
	    return ;
    }
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(674,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(679,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
String CustomerName=Util.fromScreen(request.getParameter("CustomerName"),user.getLanguage());
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String datetype = Util.null2String(request.getParameter("datetype"));
String sqlwhere="";
if(!CustomerName.equals("")){
	sqlwhere+=" and t3.name like '%"+CustomerName+"%'";
}

if(!"".equals(datetype) && !"6".equals(datetype)){
	sqlwhere += " and logindate >= '"+TimeUtil.getDateByOption(datetype+"","0")+" 00:00:00'";
	sqlwhere += " and logindate <= '"+TimeUtil.getDateByOption(datetype+"","")+" 00:00:00'";
}

if("6".equals(datetype) && !"".equals(fromdate)){
	sqlwhere += " and logindate > '"+fromdate+" 00:00:00'";
}

if("6".equals(datetype) && !"".equals(enddate)){
	sqlwhere += " and logindate < '"+enddate+" 23:59:59'";
}


if(sqlwhere.equals("")){
	sqlwhere += " and t1.id != 0 " ;
}
%>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input type="text" class="searchInput"  id="searchNameInfo" name="searchNameInfo" value="<%=CustomerName%>" />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form id=weaver name=weaver method=post action="CRMLoginLogRpChild.jsp">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>' attributes="">
		<wea:item><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT type="text" class=InputStyle maxLength=50 size=30 name="CustomerName" value="<%=CustomerName%>" style="width: 150px;">
		</wea:item>
	
	  	<wea:item><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
       	<wea:item>
       		<span>
	        	<SELECT  name="datetype" id="datetype" onchange="onChangetype(this)" style="width: 100px;">
				  <option value="" 	<%if(datetype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="1" <%if(datetype.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
				  <option value="2" <%if(datetype.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
				  <option value="3" <%if(datetype.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
				  <option value="4" <%if(datetype.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
				  <option value="5" <%if(datetype.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
				  <option value="6" <%if(datetype.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
				</SELECT>     
			</span>
        
        	<span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
				<button class="Calendar" style="height: 16px" type="button" onclick="getDate(startdatespan,fromdate)" value="<%=fromdate%>"></button>
				<span id="startdatespan"><%=fromdate%></span>
				<input type="hidden" id="fromdate" name="fromdate">
				－
				<button class="Calendar" style="height: 16px" type="button" onclick="getDate(enddatespan,enddate)" value="<%=enddate%>"></button>
				<span id="enddatespan"><%=enddate%></span>
				<input type="hidden" id="enddate" name="enddate">
			</span>  
		</span>
       </wea:item> 
       
	</wea:group>
	
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>" id="searchBtn"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(27088,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition()"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
	
</wea:layout>
</form>
</div>

<%

	String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
	String orderby = "t1.logindate ,t1.logintime ";
	String fromSql = "CRM_loginLog  t1,"+leftjointable+"  t2, CRM_CustomerInfo  t3";
	String sqlWhere = " t1.id = t3.id and t1.id = t2.relateditemid "+sqlwhere;
	String backfields = "t1.*";
	if(!user.getLogintype().equals("1")){
		fromSql = "CRM_loginLog  t1,CRM_CustomerInfo  t3";
		sqlWhere = " t1.id = t3.id and t3.agent="+user.getUID()+sqlwhere;
	}
	
	String tableString =" <table instanceid=\"info\"  pageId=\""+PageIdConst.CRM_LoginLog+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_LoginLog,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"none\">"+ 
	"<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  "+
		"sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"/>"+
	"<head>"+
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(1268,user.getLanguage()) +"\" column=\"id\""+ 
		" transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\""+
		" href=\"/CRM/data/ViewCustomer.jsp\" linkkey = \"CustomerID\" linkvaluecolumn = \"id\"/>"+ 
	"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(15502,user.getLanguage()) +"\" column=\"logindate\""+
		" otherpara=\"column:logintime\" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getCrmModifyTime\"/>"+ 
	"<col width=\"15%\"  text=\""+ SystemEnv.getHtmlLabelName(33586,user.getLanguage()) +"\" column=\"ipaddress\" />"+ 	
	"</head>"+   			
	"</table>";
	
%>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_LoginLog%>">
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">
  
  $(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:searchInfo});
	jQuery("#hoverBtnSpan").hoverBtn();
	if("<%=datetype%>" == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
  });

    function onChangetype(obj){
		if(obj.value == 6){
			jQuery("#dateTd").show();
		}else{
			jQuery("#dateTd").hide();
		}
	}
	
 function searchInfo(){
 	jQuery("input[name='CustomerName']").val(jQuery("#searchNameInfo").val());
 	weaver.submit();
 }
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
