<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">

</head>
<%
int userid=user.getUID(); 
String usertype=user.getLogintype();
if(!"1".equals(usertype)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String name=Util.null2String(request.getParameter("name"));//备注
String newstype =Util.null2String(request.getParameter("newstype"));//类型
String operate = Util.null2String(request.getParameter("operate"));
String IDS = Util.null2String(request.getParameter("IDS"));
if(null != IDS && !"".equals(IDS)){
	String temStr="";
	if("del".equals(operate)){//删除
		temStr = "update wechat_news set isdel='1' where id in ("+IDS+")";
		RecordSet.executeSql(temStr);
	}
}

String sqlwhere="where t1.isdel=0 and t1.createrid="+userid+" ";
 
if(name!=null&&!"".equals(name)){
	sqlwhere+=" and t1.name like '%"+name+"%' ";
}
if(newstype!=null&&!"".equals(newstype)){
	sqlwhere+=" and t1.newstype = '"+newstype+"' ";
}
int perpage=Util.getPerpageLog();
if(perpage<10) perpage=10;

String backFields = " t1.* ";
String sqlFrom = " wechat_news t1";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"wechatMaterialTable\" tabletype=\"checkbox\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\"updatetime\" sqlprimarykey=\"t1.id\" sqlsortway=\"desc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(454,user.getLanguage())+"\" column=\"name\" transmethod=\"weaver.wechat.WechatTransMethod.newsViewName\" otherpara=\"column:id\"/>"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"newstype\" transmethod=\"weaver.wechat.WechatTransMethod.getNewsType\" otherpara=\""+user.getLanguage()+"\"/>"+
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(26446,user.getLanguage())+"\" column=\"updatetime\"/>"+
			  "</head>";
 tableString +=  "<operates>"+
				"		<operate href=\"javascript:previewNews();\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:editNews();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		<operate href=\"javascript:delNews();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
				"</operates>";
tableString += "</table>";

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(81634,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(81632,user.getLanguage())+",javascript:doAdd(1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(81633,user.getLanguage())+",javascript:doAdd(2),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(81632,user.getLanguage()) %>" class="e8_btn_top" onclick="doAdd(1)"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(81633,user.getLanguage()) %>" class="e8_btn_top" onclick="doAdd(2)"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top" onclick="doDelete()"/>
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
	<form id=weaverA name=weaverA method=post action="materialListChld.jsp">
		<input type="hidden" name="operate" value="">
		<input type="hidden" name="IDS" value="">
		  	<wea:layout type="4col">
	     	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>'>
		      <wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
		      <wea:item>
		        	<input type="text" id="name" name="name" value="<%=name%>" class="InputStyle">
		      </wea:item>
		      
					
		      <wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
		      <wea:item>
		       	   <select name="newstype">
						<option value="" <%="".equals(newstype)?"selected":""%> ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						<option value="1" <%="1".equals(newstype)?"selected":""%>><%=SystemEnv.getHtmlLabelName(81632,user.getLanguage())%></option>
						<option value="2" <%="2".equals(newstype)?"selected":""%>><%=SystemEnv.getHtmlLabelName(81633,user.getLanguage())%></option>
				 </select>
		      </wea:item>
		 
	      </wea:group>
	      
		<!-- 操作 -->
	     <wea:group context="">
	    	<wea:item type="toolbar">
		        <input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		    </wea:item>
	    </wea:group>
	    </wea:layout>
 </form>
</div>
 
	 
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/></td></tr>
 

</body>

<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/wechat/js/wechatNews_wev8.js"></script>
<script language="javascript">

function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}
function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("#name").val(name);
	doSubmit();
} 

function doSubmit()
{
	document.forms[0].submit();
}



function delNews(id){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
   		window.top.Dialog.confirm(str,function(){
        jQuery("input[name=operate]").val("del");
        jQuery("input[name=IDS]").val(id);
        document.forms[0].submit();
    });
}

function doDelete(){
	var deleteids = _xtable_CheckedCheckboxId();
	if(deleteids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}else{
	    var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
   		window.top.Dialog.confirm(str,function(){
	        jQuery("input[name=operate]").val("del");
	        jQuery("input[name=IDS]").val(deleteids.substr(0,deleteids.length-1));
	        document.forms[0].submit();
	    });
    }
}       

function doAdd(type){
	parent.location.href="/wechat/material.jsp?newstype="+type;
}
var diag_vote;

function closeDialog(){
	alert(2);
	diag_vote.close();
}	
function previewNews(id){
	openNewsPreview('/wechat/materialView.jsp?newsid='+id,"<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>");

}




function editNews(id){
	parent.location.href="/wechat/material.jsp?newsid="+id;
}

</script>

</html>
