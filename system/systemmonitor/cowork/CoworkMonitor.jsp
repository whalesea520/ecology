
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
if(!HrmUserVarify.checkUserRight("collaborationmanager:edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(19985,user.getLanguage());
String needfav ="1";
String needhelp ="";

String name = Util.null2String(request.getParameter("name"));
String creater = Util.null2String(request.getParameter("creater"));
String typeid = Util.null2String(request.getParameter("typeid"));
String begindate = Util.null2String(request.getParameter("begindate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String status = Util.null2String(request.getParameter("status"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

if(!name.equals("")){
	sqlwhere += " and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
}
if(!creater.equals("")){
	sqlwhere += " and t1.creater = "+ creater;
}
if(!typeid.equals("")){
	sqlwhere += " and t1.typeid = "+ typeid;
}
if(!begindate.equals("")){
	sqlwhere += " and t1.begindate >= '"+begindate+"'";
}
if(!enddate.equals("")){
	sqlwhere += " and t1.enddate <= '"+enddate+"'";
}
if(!status.equals("")){
	sqlwhere += " and t1.status =" + status +" " ;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteCowork(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(405,user.getLanguage())+",javascript:endCowork(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(RecordSet.getDBType().equals("db2")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+xssUtil.put("where int(operateitem)=90")+",_self} " ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+xssUtil.put("where operateitem=90")+",_self} " ;
}
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<wea:layout attributes="{'layoutTableId':'topTitle'}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			
			<span title="搜索" style="font-size: 12px;">
					<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>
					<input type="text" class="searchInput"  id="searchname" name="searchname" 
						value="<%=name %>" onchange="searchName()"/>
			</span>
			<span id="advancedSearch" class="advancedSearch">高级搜索</span>
			<span title="菜单" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;overflow: auto" >	
<FORM id=searchname name=mainfrom STYLE="margin-bottom:0" action="CoworkMonitor.jsp" method=post>
<input type=hidden id="operation" name=operation value="deletecowork">
<input type=hidden name=deletecoworkid id="deletecoworkid" value="">
<input type=hidden name=coworkids value="" id="coworkids">
<wea:layout type="4col">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text"  class=InputStyle  name="name" value="<%=name%>">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="creater" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
		         browserValue='<%=creater%>' 
		         browserSpanValue = '<%=ResourceComInfo.getResourcename(creater)%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp" width="80%" ></brow:browser> 
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(17694,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="typeid" size=1 style="width:80%">
				<option value="">&nbsp;</option>
				<%
				String typesql="select * from cowork_types" ;
				RecordSet.executeSql(typesql);
				while(RecordSet.next()){
					String tmptypeid=RecordSet.getString("id");
					String typename=RecordSet.getString("typename");
				%>
					<option value="<%=tmptypeid%>" <%if(typeid.equals(tmptypeid)){%>selected<%}%>><%=typename%></option>
				<%}%>
			</select>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON type="button" class=Calendar onclick="getDate(begindatespan,begindate)"></BUTTON> 
			<SPAN id=begindatespan><%=begindate%></SPAN> 
			<input type="hidden" name="begindate" id="begindate" value="<%=begindate%>">
		</wea:item>  
		
		<wea:item><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON type="button" class=Calendar onclick="getDate(enddatespan,enddate)"></BUTTON> 
			<SPAN id=enddatespan><%=enddate%></SPAN> 
			<input type="hidden" name="enddate" id="enddate" value="<%=enddate%>">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		<wea:item>
			<select name=status>
				<option value="">&nbsp;</option>
				<option value="1" <%if("1".equals(status)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
				<option value="2" <%if("2".equals(status)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
			</select>
		</wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="搜索" id="searchBtn"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="重置" class="e8_btn_cancel" onclick="javascript:mainfrom.reset()"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="取消" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
	
</wea:layout>	
</FORM>
</div>
<%
   String backfields = "t1.id,t1.name,t1.creater,t1.typeid,t2.typename,t1.status,t1.begindate,t1.enddate";
   String fromSql  = " from cowork_items t1,cowork_types t2";
   String sqlWhere = " where t1.typeid=t2.id"+sqlwhere;
   String orderby = "" ;
   int	perpage=10;
   String tableString = "<table tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
                        "	  <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
                        "    <head>"+
                        "		  <col width=\"10%\"  text=\"ID"+"\" column=\"id\" orderkey=\"t1.id\" />"+
                        "		  <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" column=\"name\"  orderkey=\"name\" />"+
                        "		  <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\"  transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
                        "		  <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17694,user.getLanguage())+"\" column=\"typename\"  orderkey=\"typename\" />"+
           			 	"		  <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"begindate\"  orderkey=\"begindate\" />"+
           			 	"		  <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"enddate\"  orderkey=\"enddate\" />"+
           			 	"		  <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\"  orderkey=\"status\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.cowork.CoworkItemsVO.getTransStatus\"/>"+
                        "	  </head>"+
                        "</table>";
%>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />

<script language="javascript">

function doSearch(){
   mainfrom.submit();
}


//删除协作
function deleteCowork(){
	if(isdel()) {
		jQuery.post("/system/systemmonitor/MonitorOperation.jsp",
			{'deletecoworkid':_xtable_CheckedCheckboxId(),'operation':'deletecowork'},function(){
				_table.reLoad();
		});
	}
}
//结束协作
function endCowork(){
    if(_xtable_CheckedCheckboxId()!=""){
       jQuery("#operation").val("endCowork");
       var coworkids=_xtable_CheckedCheckboxId();
       coworkids=coworkids.substring(0,coworkids.length-1);
       jQuery("#coworkids").val(coworkids);
       window.mainfrom.action = "/system/systemmonitor/MonitorOperation.jsp";
       window.mainfrom.submit();
    }    
}

$(function(){
	
	jQuery("#topTitle").topMenuTitle({searchFn:null});
	jQuery("#hoverBtnSpan").hoverBtn();
	
				
});

function searchName(){
	var searchname = jQuery("#searchname").val();
	window.mainfrom.action = "CoworkMonitor.jsp?name="+searchname;
	window.mainfrom.submit();
}
</script>
</BODY>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
