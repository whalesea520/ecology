
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>


<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
</head>
<%
int userid=user.getUID();   
if(!HrmUserVarify.checkUserRight("searchIndex:manager", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String title=Util.null2String(request.getParameter("title"));
String keywords=Util.null2String(request.getParameter("keywords"));
String showDiv=Util.null2String(request.getParameter("showDiv"));
String state=Util.null2String(request.getParameter("state"));

String operate = Util.null2String(request.getParameter("operate"));
String platformIDs = Util.null2String(request.getParameter("platformIDs"));
if(null != platformIDs && !"".equals(platformIDs)){
	String temStr="";
	if("del".equals(operate)){//删除
		temStr = "delete FullSearch_Robot  where id in ("+platformIDs+")";
		RecordSet.executeSql(temStr);
	}
}

String sqlwhere="where 1=1 ";
if(title!=null&&!"".equals(title)){
	sqlwhere+=" and title like '%"+title+"%' ";
}
if(keywords!=null&&!"".equals(keywords)){
	sqlwhere+=" and keywords like '%"+keywords+"%' ";
}
if(showDiv!=null&&!"".equals(showDiv)){
	sqlwhere+=" and showDiv like '%"+showDiv+"%' ";
}
if(state!=null&&!"".equals(state)){
	sqlwhere+=" and state = '"+state+"' ";
}

String perpage=PageIdConst.getPageSize(PageIdConst.ESearch_RobotList,user.getUID());

String backFields = " id,title,keywords,showDiv,state ";
String sqlFrom = " FullSearch_Robot t1";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"ESearchRobot\" tabletype=\"checkbox\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(229,user.getLanguage())+"\" column=\"title\" />"+
					  "<col width=\"65%\"  text=\""+SystemEnv.getHtmlLabelName(2095,user.getLanguage())+"\" column=\"keywords\"  />"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(21653,user.getLanguage())+"\"  column=\"showDiv\" orderkey=\"showDiv\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.fullsearch.SearchTransMethod.getShowDiv\"/>"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\"  column=\"state\" orderkey=\"state\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.fullsearch.SearchTransMethod.getState\"/>"+
			  "</head>";
tableString +=  "<operates>"+
				"		<popedom column=\"id\" otherpara=\"column:state\" transmethod=\"weaver.fullsearch.SearchTransMethod.getOpt\"></popedom> "+
				"		<operate href=\"javascript:qiyong();\" text=\""+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:jinyong();\" text=\""+SystemEnv.getHtmlLabelName(18096,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
                "		<operate href=\"javascript:editPlat();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
				"		<operate href=\"javascript:delPlat();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"3\"/>"+
				"</operates>";
tableString += "</table>";
 

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(31953,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doAdd(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(20472,user.getLanguage())+",javascript:createIndexl(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doAdd()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doDel()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(20472,user.getLanguage()) %>" class="e8_btn_top middle" onclick="createIndexl()"/>
			<input type="text" class="searchInput" id="t_name" name="t_name" value=""  />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<form id=weaverA name=weaverA method=post action="RobotManager.jsp">
	<input type="hidden" name="operate" value="">
	<input type="hidden" name="platformIDs" value="">
	<input type="hidden" name="chagestate" value="">
		  	<wea:layout type="4col">
	     	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>'>
		      <wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
		      <wea:item>
		        	<input type="text" id="title" name="title" value="<%=title%>" class="InputStyle">
		      </wea:item>
		      
		       <wea:item><%=SystemEnv.getHtmlLabelName(2095,user.getLanguage())%></wea:item>
		      <wea:item>
		      	<input type="text" id="keywords" name="keywords" value="<%=keywords%>" class="InputStyle">
		      </wea:item>
		      
		      <wea:item><%=SystemEnv.getHtmlLabelName(21653,user.getLanguage())%></wea:item>
		      <wea:item>
		       	  <select id="showDiv"  name="showDiv" style="width:80px;">
					<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					<option value=0 <%if(showDiv.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19494,user.getLanguage())%></option>
					<option value=1 <%if(showDiv.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(82833,user.getLanguage())%></option>
				 </select>
		      </wea:item>
		      
		      <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		      <wea:item>
		       	  <select id="state"  name="state" style="width:80px;">
					<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					<option value=0 <%if(state.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
					<option value=1 <%if(state.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></option>
				 </select>
		      </wea:item>
	      </wea:group>
		<!-- 操作 -->
	     <wea:group context="">
	    	<wea:item type="toolbar">
		        <input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtionAVS();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		    </wea:item>
	    </wea:group>
	    </wea:layout>
 </form>
</div>

<table width=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top">
		<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.ESearch_RobotList%>"/>
		<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
	</td>
</tr>
</table>
 
</body>
<script language="javascript">

var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	_table.reLoad();
	diag_vote.close();
	//doSubmit();
}

function refreshTable(){
	_table.reLoad();
}

function resetCondtionAVS(){
	jQuery("#title").val("");
	jQuery("#keywords").val("");
	jQuery("#showDiv").val("");
	jQuery("#state").val("");
	$("#showDiv").selectbox('detach');
	$("#showDiv").selectbox('attach');
	$("#state").selectbox('detach');
	$("#state").selectbox('attach');
}

function doSubmit()
{
	document.forms[0].submit();
}

function doAdd(){
	editPlat(0);
}

function editPlat(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.checkDataChange=false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82832,user.getLanguage())%>";
	diag_vote.URL = "/fullsearch/robot/RobotTab.jsp?_url=RobotEdit&dialog=1&id="+id;
	diag_vote.show();
}

function delPlat(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		jQuery("input[name=operate]").val("del");
        jQuery("input[name=platformIDs]").val(id);
        document.forms[0].submit();
	});
}

function doDel(){
	var deleteids = _xtable_CheckedCheckboxId();
	if(deleteids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}else{
	    var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
   		window.top.Dialog.confirm(str,function(){
	        jQuery("input[name=operate]").val("del");
	        jQuery("input[name=platformIDs]").val(deleteids.substr(0,deleteids.length-1));
	        document.forms[0].submit();
	    });
    }
}

function statePlat(id,state){
	if(state==1){
	   	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32690,user.getLanguage())%>",function(){//确定要禁用么
		     $.post("RobotOperation.jsp", 
				{"operate":"state", "id": id,"state":1},
			   	function(data){
					var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
					 if(data=="true"){
					 	 _table.reLoad();
					 }else{
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
					 }
		   		});
	     });
	}else{
		$.post("RobotOperation.jsp", 
			{"operate":"state", "id": id,"state":0},
		   	function(data){
				var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				 if(data=="true"){
				 	 _table.reLoad();
				 }else if(data=="false"){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
				 }
	   		});
	}
}

function createIndexl(){
     $.post("RobotOperation.jsp", 
		{"operate":"createIndex"},
	   	function(data){
			var data=data.replace(/[\r\n]/g,"");//.replace(/[ ]/g,"");
			 if(data=="false"){
			 	 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%>");
			 }else{
				window.top.Dialog.alert(data);
			 }
   		});
	     
}

function qiyong(id){
	statePlat(id,0);
}

function jinyong(id){
	statePlat(id,1);
}

function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}
function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("#title").val(name);
	doSubmit();
} 
</script>

</html>
