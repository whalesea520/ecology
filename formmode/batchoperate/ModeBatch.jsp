<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<style>
		#loading{
		    position:absolute;
		    left:45%;
		    background:#ffffff;
		    top:40%;
		    padding:8px;
		    z-index:20001;
		    height:auto;
		    border:1px solid #ccc;
		}
	</style>
</HEAD>
<body>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(81453,user.getLanguage()); //批量操作库设置
	String needfav ="1";
	String needhelp ="";
	
	String expendname = Util.null2String(request.getParameter("expendname"));
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

<form name="frmSearch" method="post" action="/formmode/batchoperate/ModeBatch.jsp">
	<table class="ViewForm">
		<COLGROUP>
			<COL width="15%">
			<COL width="35%">
			<COL width="15%">
			<COL width="35%">
		</COLGROUP>
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(81454,user.getLanguage())%><!-- 操作名称 -->
			</td>
			<td class=Field>
				<input class="inputstyle" id="expendname" name="expendname" type="text" value="<%=expendname%>">
			</td>
			<td>
				<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%><!-- 模块名称 -->
			</td>
			<td class="Field">
		  		 <!-- button type="button" class=Browser id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></button-->
		  		 <span id=modeidspan><%=modename%></span>
		  		 <input type="hidden" name="modeid" id="modeid" value="<%=modeid%>">
			</td>
		</tr>
		<tr style="height:1px"><td colspan=4 class=Line></td></tr>
	</table>
</form>

<%
String SqlWhere = " where a.modeid = b.id and a.isbatch = 1";
if(!expendname.equals("")){
	SqlWhere += " and a.expendname like '%"+expendname+"%' ";
}
if(!modeid.equals("")){
	SqlWhere += " and a.modeid = '"+modeid+"'";
}

String perpage = "10";
String backFields = "a.id,a.modeid,a.expendname,a.showtype,a.hrefid,a.hreftype,a.hreftarget,a.opentype,a.isshow,a.showorder,b.modename,a.expenddesc ";
String sqlFrom = "from mode_pageexpand a,modeinfo b ";
//out.println("select " + backFields + "	"+sqlFrom + "	"+ SqlWhere);
String tableString=""+
	"<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
		"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
			"<head>"+                             
				"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(81454,user.getLanguage())+"\" column=\"expendname\" orderkey=\"expendname\" target=\"_self\" linkkey=\"id\" linkvaluecolumn=\"id\" href=\"/formmode/batchoperate/ModeBatchEdit.jsp\"/>"+//操作名称
				"<col width=\"70%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"expenddesc\"/>"+//描述
				//"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(23724,user.getLanguage())+"\" column=\"showtype\" orderkey=\"showtype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getShowType\"/>"+
				//"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(30173,user.getLanguage())+"\" column=\"opentype\" orderkey=\"opentype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getOpenType\"/>"+
				//"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(30174,user.getLanguage())+"\" column=\"hreftype\" orderkey=\"hreftype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getHrefType\"/>"+
				//"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(30181,user.getLanguage())+"\" column=\"hrefid\" orderkey=\"hrefid\" otherpara=\"column:hreftype\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getHrefName\"/>"+
				//"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(30178,user.getLanguage())+"\" column=\"hreftarget\" orderkey=\"hreftarget\"/>"+
				//"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15603,user.getLanguage())+"\" column=\"isshow\" orderkey=\"isshow\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getIsShow\"/>"+
				//"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"showorder\" orderkey=\"showorder\"/>"+
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
	})

    function doSubmit(){
        enableAllmenu();
        document.frmSearch.submit();
    }
    function doAdd(){
		enableAllmenu();
        location.href="/formmode/batchoperate/ModeBatchAdd.jsp?modeid=<%=modeid%>";
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

</BODY>
</HTML>
