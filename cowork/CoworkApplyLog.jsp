<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(63,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:window.weaver.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
	String name = Util.null2String(request.getParameter("name"));
	String approveid = Util.null2String(request.getParameter("approveid"));
	String status = Util.null2String(request.getParameter("status"));
	String startdate = Util.null2String(request.getParameter("startdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	String datetype = Util.null2String(request.getParameter("datetype"));
	String sqlWhere = "";
	if(!"".equals(name)){
		sqlWhere +=" and t2.name like '%"+name+"%'";
	}
	if(!"".equals(approveid)){
		sqlWhere +=" and t1.approveid = '"+approveid+"'";
	}
	if(!"".equals(status)){
		sqlWhere +=" and t1.status = '"+status+"'";
	}
	
	if(!"".equals(datetype) && !"6".equals(datetype)){
		sqlWhere += " and applydate >= '"+TimeUtil.getDateByOption(datetype+"","0")+" 00:00:00'";
		sqlWhere += " and applydate <= '"+TimeUtil.getDateByOption(datetype+"","")+" 00:00:00'";
	}

	if("6".equals(datetype) && !"".equals(startdate)){
		sqlWhere += " and applydate > '"+startdate+" 00:00:00'";
	}

	if("6".equals(datetype) && !"".equals(enddate)){
		sqlWhere += " and applydate < '"+enddate+" 23:59:59'";
	}
	
	String orderby = " t1.applydate desc , t1.status";
	String fromSql = "cowork_apply_info t1,cowork_items t2 ";
	String backfields = " t1.applydate , t1.status , t1.approveid ,t2.name ";
	sqlWhere = "t1.coworkid =t2.id and t1.resourceid =  "+user.getUID()+sqlWhere;
	
	String tableString =" <table instanceid=\"info\"  pageId=\""+PageIdConst.Cowork_ApplyLog+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Cowork_ApplyLog,user.getUID(),PageIdConst.COWORK)+"\" tabletype=\"checkbox\">"+ 
    "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  "+
    	"sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"asc\"/>"+
    "<head>"+
    "<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(129,user.getLanguage())+SystemEnv.getHtmlLabelName(26686,user.getLanguage()) +"\" column=\"name\""+
		"/>"+ 
	"<col width=\"25%\"  text=\""+ SystemEnv.getHtmlLabelName(855,user.getLanguage()) +"\" column=\"applydate\"/>"+ 
	
   	"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(83220,user.getLanguage())+"\" column=\"status\""+
    	" transmethod=\"weaver.cowork.CoworkApplayTrans.getCoworkType\" otherpara = \""+user.getLanguage()+"\"/>"+
   	"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(24743,user.getLanguage()) +"\" column=\"approveid\""+
    	" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\""+
    	" href=\"/hrm/resource/HrmResource.jsp\" linkkey=\"id\" linkvaluecolumn=\"approveid\"/>"+ 
  	
	"</head>"+   			
	"</table>";
	
	//System.err.println("select "+backfields+" from "+ fromSql+" where "+sqlWhere);
%>

<BODY>


<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
	    	<input type="text" class="searchInput" name="searchName" id="searchName"  value="<%=name %>"/>
       		<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
			
<!-- 高级搜索 -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form id="weaver" name="weaver" action="CoworkApplyLog.jsp" method="post">
	<wea:layout type="4col" attributes="{'layoutTableId':'oTable1'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=inputstyle type=text name="name" id="name" value="<%=name %>" style="width:180px" maxlength=25 onkeydown="if(window.event.keyCode==13) return false;">      
			</wea:item> 
			
			
			<wea:item><%=SystemEnv.getHtmlLabelName(83220,user.getLanguage())%></wea:item>
			<wea:item>
				<SELECT  class=InputStyle name="status"  style="width: 120px;">
					<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					<option value="1" <%=status.equals("-1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18660,user.getLanguage())%></option>
					<option value="0" <%=status.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(83221,user.getLanguage())%></option>
					<option value="-1" <%=status.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%></option>
				</SELECT>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(24743,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="approveid" 
				browserValue='<%=approveid%>' 
				browserSpanValue = '<%=ResourceComInfo.getResourcename(approveid)%>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp" width="210px" >
				</brow:browser>
			</wea:item>
		      
	      	<wea:item><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
	        <wea:item>
	        	<span>
		        	<SELECT  name="datetype" id="datetype" onchange="onChangetype(this)" style="width: 120px;">
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
			        <button class="Calendar" style="height: 16px" type="button" onclick="getDate(startdatespan,startdate)" value="<%=startdate%>"></button>
					<span id="startdatespan"><%=startdate%></span>
					<input type="hidden" id="startdate" name="startdate">
					－
					<button class="Calendar" style="height: 16px" type="button" onclick="getDate(enddatespan,enddate)" value="<%=enddate%>"></button>
					<span id="enddatespan"><%=enddate%></span>
					<input type="hidden" id="enddate" name="enddate">
				</span>
	        </wea:item>
         </wea:group>
          
		<wea:group context="" attributes="{'Display':'none'}">
			<wea:item type="toolbar">
				<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="searchBtn"/>
				<input type="button" name="reset" onclick="resetCondition()" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</form>	
</div>
	
	
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Cowork_ApplyLog%>">
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>
<script type="text/javascript">
	$(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:searchInfo});
		jQuery("#hoverBtnSpan").hoverBtn();
	});
	
	function searchInfo(){
		jQuery("#name").val(jQuery("#searchName").val());
		weaver.submit();	
	}
	
	function onChangetype(obj){
		if(obj.value == 6){
			jQuery("#dateTd").show();
		}else{
			jQuery("#dateTd").hide();
		}
	}
	
  $(document).ready(function(){
		if("<%=datetype%>" == 6){
			jQuery("#dateTd").show();
		}else{
			jQuery("#dateTd").hide();
		}	
  });
</script>

</BODY>

</HTML>
