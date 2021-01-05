<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>    
</head>
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(30063,user.getLanguage());//自定义页面设置
String needfav ="1";
String needhelp ="";

String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));
String customname = Util.null2String(request.getParameter("customname"));
String creater=Util.null2String(request.getParameter("creater"));
String sql = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:doSubmit(),_self} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javaScript:doAdd(),_self} " ;//新建
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<form name="frmSearch" method="post" action="/formmode/custompage/CustomList.jsp">
	<table class="ViewForm">
		<COLGROUP>
			<COL width="15%">
			<COL width="35%">
			<COL width="15%">
			<COL width="35%">
		</COLGROUP>
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%><!-- 名称 -->
			</td>
			<td class="Field">
				<input type="text" name="customname" class="inputStyle" value="<%=customname%>">
			</td>
			<td>
				<%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><!-- 创建人 -->
			</td>
			<td class="Field">
		  		 <button type="button" class=Browser id=createrSelect onClick="onShowResource(creater,createrspan)" name=createrSelect></BUTTON>
		  		 <span id=createrspan><%=ResourceComInfo.getResourcename(creater)%></span>
		  		 <input type="hidden" name="creater" id="creater" value="<%=creater%>">
			</td>
		</tr>
		<tr style="height:1px"><td colspan=4 class=Line></td></tr>
		
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%><!-- 创建日期 -->
			</td>
			<td class="Field">
				<button type=button  class=calendar id=SelectDate3  onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>
				<SPAN id=fromdatespan ><%=fromdate%></SPAN>
				-&nbsp;&nbsp;<button type=button  class=calendar id=SelectDate4 onclick="gettheDate(todate,todatespan)"></BUTTON>
				<SPAN id=todatespan ><%=todate%></SPAN>
				<input type="hidden" name="fromdate" value="<%=fromdate%>">
				<input type="hidden" name="todate" value="<%=todate%>">
			</td>
		</tr>
		<tr style="height:1px"><td colspan=4 class=Line></td></tr>
	</table>
</form>

<%
String SqlWhere = " where 1=1 ";
if(!customname.equals("")){
	SqlWhere += " and a.customname like '%"+customname+"%'";
}
if(!creater.equals("")&&!creater.equals("0")){
	SqlWhere += " and a.creater = " + creater+ " ";
}
if(!fromdate.equals("")){
	SqlWhere += " and a.createdate >= '" + fromdate+ "' ";
}
if(!todate.equals("")){
	SqlWhere += " and a.createdate <= '" + todate+ "' ";
}

String perpage = "10";
String backFields = "a.id,a.creater,a.customname,a.customdesc,a.createdate,a.createtime";
String sqlFrom = " from mode_custompage a";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
				  "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
				  "<head>"+                             
				  		  //名称
						  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"customname\" orderkey=\"customname\" target=\"_self\" linkkey=\"id\" linkvaluecolumn=\"id\" href=\"/formmode/custompage/CustomPageEdit.jsp\"/>"+
						  //创建人
						  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
						  //创建日期
						  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate,createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.formmode.custompage.CustomPageUtil.getCreateDate\"/>"+
						  //描述
						  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"customdesc\" orderkey=\"customdesc\"/>"+
						  //查看菜单地址
						  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(28624,user.getLanguage())+"\" column=\"id\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.custompage.CustomPageUtil.getAddress\" />"+
				  "</head>"+
			  "</table>";


%>

<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<script type="text/javascript">
	$(document).ready(function(){//onload事件
		//$(".loading", window.parent.document).hide(); //隐藏加载图片
	})

    function doSubmit(){
        enableAllmenu();
        document.frmSearch.submit();
    }
    function doAdd(){
		enableAllmenu();
		location.href = "/formmode/custompage/CustomPageAdd.jsp";
    }
    function onShowModeSelect(inputName, spanName){
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	} 
    }

    function onShowResource(inputName, spanName) {
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	} 
    }

    function viewmenu(id){
    	var url = "/formmode/custompage/CustomPageData.jsp?id="+id;
    	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);//查看菜单地址
    }
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

</BODY></HTML>
