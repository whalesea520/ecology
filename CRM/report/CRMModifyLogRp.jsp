<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
</head>
<%
if(!HrmUserVarify.checkUserRight("LogView:View", user))  {
        response.sendRedirect("/notice/noright.jsp") ;
	    return ;
    }
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(103,user.getLanguage())+SystemEnv.getHtmlLabelName(264,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(679,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%
int submiter=Util.getIntValue(request.getParameter("submiter"),0);
int manager=Util.getIntValue(request.getParameter("manager"),0);
int customer=Util.getIntValue(request.getParameter("customer"),0);
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String datetype = Util.null2String(request.getParameter("datetype"));
String searchName = Util.null2String(request.getParameter("searchName"));
String logTypeName = Util.null2String(request.getParameter("logTypeName"));
String sqlwhere="";
if(submiter!=0){
	sqlwhere+=" and t1.submiter="+submiter;
}

if(manager!=0){
	sqlwhere+=" and t3.manager="+manager;
}
if(customer!=0){
	sqlwhere+=" and t1.customerid="+customer;
}
if(!"".equals(searchName)){
	sqlwhere = " and t3.name like '%"+searchName+"%'";
}

if(!"".equals(logTypeName)){
	if(rs.getDBType().equals("oracle")){
		sqlwhere +=" and CASE substr(logtype , 1 ,1) WHEN 'n' THEN '新建' WHEN 'd' THEN '删除'"+
			" WHEN 'a' THEN '状态' WHEN 'p' THEN '门户'  WHEN 'u' THEN '合并' ELSE '编辑' END || ' '||"+
			" CASE  substr(logtype , 2,1)  WHEN 'c' THEN '联系人' WHEN 'a' THEN '地址' WHEN 's' THEN '共享' ELSE '' END"+
			" like '%"+searchName+"%'";
	}else{
		sqlwhere += " and CASE substring(logtype , 1 ,1) WHEN 'n' THEN '新建' WHEN 'd' THEN '删除'"+
		" WHEN 'a' THEN '状态' WHEN 'p' THEN '门户'  WHEN 'u' THEN '合并' ELSE '编辑' END +' '+"+
		" CASE  substring(logtype , 2,1)  WHEN 'c' THEN '联系人' WHEN 'a' THEN '地址' WHEN 's' THEN '共享' ELSE '' END "+
		" like '%"+logTypeName+"%'";
	
	}
}


if(!"".equals(datetype) && !"6".equals(datetype)){
	sqlwhere += " and submitdate >= '"+TimeUtil.getDateByOption(datetype+"","0")+" 00:00:00'";
	sqlwhere += " and submitdate <= '"+TimeUtil.getDateByOption(datetype+"","")+" 00:00:00'";
}

if("6".equals(datetype) && !"".equals(fromdate)){
	sqlwhere += " and submitdate > '"+fromdate+" 00:00:00'";
}

if("6".equals(datetype) && !"".equals(enddate)){
	sqlwhere += " and submitdate < '"+enddate+" 23:59:59'";
}


if(sqlwhere.equals("")){
	sqlwhere += " and t1.customerid != 0 " ;
}


%>
<body>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input type="text" class="searchInput"  id="searchNameInfo" name="searchNameInfo" value="<%=searchName%>" />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form id=weaver name=weaver method=post action="CRMModifyLogRp.jsp">
<input type="hidden" name="searchName" value="<%=searchName %>"> 
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>' attributes="">
	
	<wea:item><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())+SystemEnv.getHtmlLabelName(136,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="customer" 
		        browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
		        browserValue='<%=customer+""%>' 
		        browserSpanValue = '<%=CustomerInfoComInfo.getCustomerInfoname(customer+"")%>'
		        isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		        completeUrl="/data.jsp" width="150px" ></brow:browser>
	</wea:item>
	
	<wea:item><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></wea:item>
	<wea:item>
		<brow:browser viewType="0" name="manager" 
	        browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
	        browserValue='<%=manager+""%>' 
	        browserSpanValue = '<%=ResourceComInfo.getResourcename(manager+"")%>'
	        isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	        completeUrl="/data.jsp" width="150px" ></brow:browser>
	</wea:item>
	
	<wea:item><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></wea:item>
	<wea:item>
		<brow:browser viewType="0" name="submiter" 
	        browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
	        browserValue='<%=submiter+""%>' 
	        browserSpanValue = '<%=ResourceComInfo.getResourcename(submiter+"")%>'
	        isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	        completeUrl="/data.jsp" width="150px" ></brow:browser>
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
       </wea:item> 
       
       <wea:item><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%></wea:item>
       <wea:item><input type="text" class="searchInput"  id="logTypeName" name="logTypeName" value='<%=logTypeName%>' style="width: 150px;"/></wea:item>
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

	String orderby = "t1.submitdate ,t1.submittime ";
	String fromSql = "CRM_Log  t1,"+leftjointable+" t2 , CRM_CustomerInfo  t3";
	String sqlWhere = " t1.customerid = t2.relateditemid and t1.customerid = t3.id "+sqlwhere;
	String backfields = "t1.* , t3.manager";
	if(!user.getLogintype().equals("1")){
		fromSql = "CRM_Log  t1,CRM_CustomerInfo  t3";
		sqlWhere = " and t1.customerid = t3.id and t3.agent="+user.getUID()+sqlwhere;
	}
	
	String operateString= "<operates width=\"15%\">";
    operateString+=" <popedom transmethod=\"weaver.crm.report.CRMReporttTransMethod.getCrmModifyOpratePopedom\"></popedom> ";
    operateString+="     <operate href=\"javascript:showLogDetail()\" text=\""+SystemEnv.getHtmlLabelName(361,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>";       
    operateString+="</operates>";
	
	String tableString =" <table instanceid=\"info\"  pageId=\""+PageIdConst.CRM_EditLog+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_EditLog,user.getUID(),PageIdConst.CRM)+"\"  tabletype=\"none\">"+ 
    "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  "+
    	"sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.customerid\" sqlsortway=\"Desc\"/>"+
    "<head>"+
    "<col width=\"15%\"  text=\""+ SystemEnv.getHtmlLabelName(99,user.getLanguage()) +"\" column=\"submiter\" "+
		" otherpara=\"column:submitertype+"+user.getLogintype()+"\" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getSubmiterInfo\" />"+
	"<col width=\"10%\"  text=\""+ SystemEnv.getHtmlLabelName(15503,user.getLanguage()) +"\" column=\"logtype\""+ 
		" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getLogType\"/>"+ 
	"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(15502,user.getLanguage()) +"\" column=\"submitdate\""+
    	" otherpara=\"column:submittime\" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getCrmModifyTime\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(104,user.getLanguage())+SystemEnv.getHtmlLabelName(136,user.getLanguage()) +"\" column=\"customerid\""+ 
		" transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\""+
		" href=\"/CRM/data/ViewCustomer.jsp\" linkkey = \"CustomerID\" linkvaluecolumn = \"customerid\"/>"+ 
	"<col width=\"15%\"  text=\""+ SystemEnv.getHtmlLabelName(1278,user.getLanguage()) +"\" column=\"manager\" "+
		" otherpara=\""+user.getLogintype()+"\" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getManagerInfo\" />"+
	"<col width=\"15%\"  text=\""+ SystemEnv.getHtmlLabelName(33586,user.getLanguage()) +"\" column=\"clientip\" />"+ 	
	"</head>"+operateString+   			
	"</table>";
	
%>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_EditLog%>">
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
	
  function showLogDetail(customerId){
  	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())+SystemEnv.getHtmlLabelName(618,user.getLanguage()) %>";
	dialog.Width = 800;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = "/CRM/data/ViewModify.jsp?CustomerID="+customerId;
	dialog.show();
  }
  
    function onChangetype(obj){
		if(obj.value == 7){
			jQuery("#defineDate").show();
		}else{
			jQuery("#defineDate").hide();
		}
	}
	
 function searchInfo(){
 	jQuery("input[name='searchName']").val(jQuery("#searchNameInfo").val());
 	weaver.submit();
 }
</script>

</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
