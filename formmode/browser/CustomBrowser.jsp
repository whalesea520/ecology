<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>    
</head>
<%
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(28497,user.getLanguage());//自定义浏览按钮设置
String needfav ="1";
String needhelp ="";

String customname = Util.null2String(request.getParameter("customname"));
String modeid=Util.null2String(request.getParameter("modeid"));
String modename = "";
String sql = "";
if(!modeid.equals("")){
	sql = "select modename from modeinfo where id = " + modeid;
	rs.executeSql(sql);
	while(rs.next()){
		modename = Util.null2String(rs.getString("modename"));
	}
}
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

<form name="frmSearch" method="post" action="/formmode/browser/CustomBrowser.jsp">
	<table class="ViewForm">
		<COLGROUP>
			<COL width="15%">
			<COL width="35%">
			<COL width="15%">
			<COL width="35%">
		</COLGROUP>
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(28498,user.getLanguage())%><!-- 自定义浏览按钮名称 -->
			</td>
			<td class="Field">
				<input type="text" name="customname" class="inputStyle" value="<%=customname%>">
			</td>
			<td>
				<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%><!-- 模块名称 -->
			</td>
			<td class="Field">
		  		 <button type="button" class=Browser id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></BUTTON>
		  		 <span id=modeidspan><%=modename%></span>
		  		 <input type="hidden" name="modeid" id="modeid" value="<%=modeid%>">
			</td>
		</tr>
		<tr style="height:1px"><td colspan=4 class=Line></td></tr>
	</table>
</form>

<%
//select a.modeid,a.customname,a.customdesc,b.modename from mode_customsearch a,modeinfo b where a.modeid = b.id
String SqlWhere = " where a.modeid = b.id";
if(!customname.equals("")){
	SqlWhere += " and a.customname like '%"+customname+"%'";
}
if(!modeid.equals("")){
	SqlWhere += " and a.modeid = '"+modeid+"'";
}


String perpage = "10";
String backFields = "a.id,a.modeid,a.customname,a.customdesc,b.modename";
String sqlFrom = " from mode_custombrowser a,modeinfo b";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
				  "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
				  "<head>"+                
				  		  //自定义浏览按钮名称
						  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(28498,user.getLanguage())+"\" column=\"customname\" target=\"_self\" linkkey=\"id\" linkvaluecolumn=\"id\" href=\"/formmode/browser/CustomBrowserEdit.jsp\" orderkey=\"customname\"/>"+
						  //模块名称
						  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(28485,user.getLanguage())+"\" column=\"modename\" orderkey=\"modename\"/>"+
						  //描述
						  "<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"customdesc\" orderkey=\"customdesc\"/>"+
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
		$(".loading", window.parent.document).hide(); //隐藏加载图片
		if($("#modeid").val()=='0'){
			if(confirm("<%=SystemEnv.getHtmlLabelName(30776,user.getLanguage())%>")){ //请先保存基本信息！
				window.parent.document.getElementById('modeBasicTab').click();
			}else{
				$('.href').hide();
			}
		}
	})

    function doSubmit(){
        enableAllmenu();
        document.frmSearch.submit();
    }
    function doAdd(){
		enableAllmenu();
        location.href="/formmode/browser/CustomBrowserAdd.jsp?modeid=<%=modeid%>&customname=<%=customname%>";
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
</script>

</BODY></HTML>
