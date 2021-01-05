<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%
String name=Util.null2String(request.getParameter("name"));
String desc=Util.null2String(request.getParameter("desc"));
String sqlwhere="where 1=1 ";
if(!"".equals(name)){
	sqlwhere+=" and name like '%"+name+"%'";
}
if(!"".equals(desc)){
	sqlwhere+=" and desc_n like '%"+desc+"%'";
}
%>
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:resetCd(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:closeDlg(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="e8_btn_top middle" onclick="javascript:document.SearchForm.submit();"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span><%=SystemEnv.getHtmlLabelName(780,user.getLanguage()) %></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="meeting"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(2155,user.getLanguage())%>"/>
</jsp:include>

<div class="zDialog_div_content">
 <FORM NAME="SearchForm" id="SearchForm"  action="MeetingServiceTypeBrowser.jsp" method=post>
 <input type="hidden" class="InputStyle"  name="flag" value="1">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
		<!-- 名称 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
             <input class=inputstyle type="text" id="name" name="name"  style="width:60%" value="<%=name%>">
		</wea:item>
		<!-- 描述 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
           <wea:item>
           	<input class=inputstyle type="text" id="desc" name="desc"  style="width:60%" value="<%=desc%>">
           </wea:item>
    </wea:group>
     
	<wea:group context='<%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<%
					//得到pageNum 与 perpage
					int perpage=10;
					//设置好搜索条件
					String backFields =" * ";
					String fromSql = " meeting_service_type ";
					
					
					String orderBy = " id ";
					String linkstr = "";
					linkstr = "";
					String tableString=""+
								"<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
								"<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" />"+
								"<head>"+
									"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"id\" orderkey=\"id\"  />"+
									"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" />"+
									"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"desc_n\" orderkey=\"desc_n\" />"+
								"</head>"+
								"</table>";
				%>
				<wea:SplitPageTag isShowTopInfo="true" tableString='<%=tableString%>'  mode="run"/>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%>"
					class="zd_btn_cancle" onclick="javascript:submitClear()">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>"
					class="zd_btn_cancle" onclick="javascript:closeDlg()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
var parentWin ;
var dialog;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#_xTable div.table").find("tr[class!='HeaderForXtalbe']").live("click",function(){
		 var id0  = $(this).find("td:first").next().next().text();
	     id0 = id0.replace("<","&lt;")
	     id0 = id0.replace(">","&gt;")
			var returnjson = {id:$(this).find("td:first").next().text(),name:id0};
			returnValue(returnjson);
	});

});
function changeTimeSag(obj,spanname){
	if($(obj).val()=="6"){
		$('#'+spanname).show();
	}else{
		$('#'+spanname).hide();
	}
}

function submitClear()
{
	var returnjson = {id:"",name:""};
	returnValue(returnjson);
}

function returnValue(returnjson){
	if(dialog){
		try{
			  dialog.callback(returnjson);
		 }catch(e){}
	
		try{
			 dialog.close(returnjson);
		 }catch(e){}
	}else{ 
		window.parent.returnValue  = returnjson;
		window.parent.close();
	}
}

function closeDlg(){
	if(dialog){
		dialog.close();
	}else{ 
		window.parent.close();
	}
}

function resetCd(){
	resetCondtionBrw('SearchForm');
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
