
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String typename = Util.null2String(request.getParameter("typename"));
String modename = Util.null2String(request.getParameter("modename"));
String ids =Util.null2String(request.getParameter("ids"));
String names ="";

String userID = ""+user.getUID();

int perpage=Util.getPerpageLog();
if(perpage<10) perpage=10;

String sqlwhere=" where id is null ";

if(!typename.equals("")) sqlwhere+=" and t2.typename like '%" + Util.fromScreen2(typename,user.getLanguage()) +"%'";
if(!modename.equals("")) sqlwhere+=" and t3.modename like '%" + Util.fromScreen2(modename,user.getLanguage()) +"%'";

String backFields = " t2.type,t2.typename,t3.modename ";
String sqlFrom = " wechat_reminder_type t2 join wechat_reminder_mode t3 on t2.modekey=t3.modekey left JOIN wechat_reminder_set t1 on t2.type=t1.type ";

String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"remindermodeTable\" tabletype=\"checkbox\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\"t2.type\"  sqlprimarykey=\"t2.type\" sqlsortway=\"asc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(15148,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"typename\"  orderkey=\"typename\"/>"+
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(19049,user.getLanguage())+"\" column=\"modename\" orderkey=\"modename\"/>"+
			  "</head>"+
			  "</table>";
 

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15148,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage());
String needfav ="1";
String needhelp ="";
 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:resetCondtionAVS(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btn_cancle(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="e8_btn_top" onclick="doSearch()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>


<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<div class="zDialog_div_content" style="overflow:auto;">
		<form id=SearchForm name=SearchForm method=post action="MutiModeBrowser.jsp">
			<input type="hidden" name="ids" value="<%=ids %>">
			<wea:layout type="4Col">
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'  attributes="{'groupSHBtnDisplay':'none'}">
				      <wea:item><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage()) %></wea:item>
				      <wea:item>
				          <input id="typename" name="typename" value="<%=typename%>" class="InputStyle">
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%></wea:item>
				      <wea:item>
				          <input id="modename" name="modename" value="<%=modename%>" class="InputStyle">
				      </wea:item>
				      
			     </wea:group>
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(33046,user.getLanguage())%>' attributes="{'groupDisplay':'none','itemAreaDisplay':'inline-block'}">
				      <wea:item attributes="{'isTableList':'true'}">
				          <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false" selectedstrs="<%=ids %>"/>
				      </wea:item>
    			</wea:group>
			     
			</wea:layout>
		 </form>
		</div>
 
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2Col">
				<!-- 操作 -->
			     <wea:group context="">
			    	<wea:item type="toolbar">
				      <input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>" class="e8_btn_submit" onclick="doSubmit()">
					  <input type="button" value="<%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%>" class="e8_btn_submit" onclick="onClear()">
					  <input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" class="e8_btn_cancel" onclick="btn_cancle()">
				    </wea:item>
			    </wea:group>
		    </wea:layout>
	</td>
</tr>
</table>
</BODY>
</HTML>

<script language="javascript">
 
var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
dialog = parent.parent.getDialog(parent);
}catch(e){}
 
jQuery(document).ready(function(){

});

var checkids="";
var checknames="";

function btn_cancle(){
	dialog.close();
}

function onClear()
{
	returnjson = {id:"",name:""};
   if(dialog){
   	 dialog.callback(returnjson);
	}else{ 
  	  window.parent.returnValue  = returnjson;
  	  window.parent.close();
 	}
}

function doSubmit()
{
	_xtable_CheckedCheckboxId();
	 returnjson = {id:checkids,name:checknames};
   if(dialog){
   	 dialog.callback(returnjson);
	}else{ 
  	  window.parent.returnValue  = returnjson;
  	  window.parent.close();
 	}
}

function _xtable_CheckedCheckboxId(){
  checkids="";
  checknames="";
  for (i=0;i<_xtable_checkedList.size();i++)  {
 	var id= _xtable_checkedList.get(i);
     if  (id==null) continue;
     var name=$('#_xTable_'+id).parent().parent().next().html();
     checkids += checkids==""? id:","+ id;
     checknames+=checknames==""?name:","+name;
  }
}

function doSearch()
{
    document.SearchForm.submit();
}

function resetCondtionAVS(){
	$('#typename').val("");
	$('#modename').val("");
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
	$("#typename").val(name);
	doSearch();
}  
 
</script>
