<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
</HEAD>
<body>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(30091,user.getLanguage());//页面扩展设置
	String needfav ="1";
	String needhelp ="";
	
	String expendname = Util.null2String(request.getParameter("expendname"));
	String modeid=Util.null2String(request.getParameter("modeid"));
	String modename = "";
	int formid=0;
	String sql = "";
	if(!modeid.equals("")){
		sql = "select modename,formid from modeinfo where id = " + modeid;
		rs.executeSql(sql);
		while(rs.next()){
			modename = Util.null2String(rs.getString("modename"));
			formid =rs.getInt("formid");
		}
	}
	
	String subCompanyIdsql = "select subCompanyId from modeinfo where id="+modeid;
	RecordSet recordSet = new RecordSet();
	recordSet.executeSql(subCompanyIdsql);
	int subCompanyId = -1;
	if(recordSet.next()){
		subCompanyId = recordSet.getInt("subCompanyId");
	}
	String userRightStr = "ModeSetting:All";
	Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
	int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
	subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:doSubmit(),_self} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;

if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javaScript:doAdd(),_self} " ;//新建
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="frmSearch" method="post" action="/formmode/setup/expandList.jsp">
<input type="hidden" name="modeid" id="modeid" value="<%=modeid%>">
<table class="e8_tblForm">
<tr>
	<td class="e8_tblForm_label" width="20%">
		<%=SystemEnv.getHtmlLabelName(30170,user.getLanguage())%><!-- 扩展名称 -->
	</td>
	<td class="e8_tblForm_field" width="80%">
		<input class="inputstyle" id="expendname" name="expendname" type="text" value="<%=expendname%>" style="width:80%">
	</td>
	
	<!-- 
	<td class="e8_tblForm_label" width="10%">
		<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%>
	</td>
	<td class="e8_tblForm_field" width="40%">
		<button type="button" class=Browser id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></button>
		<span id=modeidspan><%=modename%></span>
		
	</td>
	 -->
</tr>
</table>
</form>
<br/>

<%
String SqlWhere = " where a.modeid = b.id ";
if(!expendname.equals("")){
	SqlWhere += " and a.expendname like '%"+expendname+"%' ";
}
if(!modeid.equals("")){
	SqlWhere += " and a.modeid = '"+modeid+"'";
}
if(VirtualFormHandler.isVirtualForm(formid)){
 	SqlWhere += " and (a.issystemflag not in (9,100,8)  or a.issystemflag is null)";
}
String perpage = "10";
String backFields = "a.id,a.modeid,a.expendname,a.showtype,a.hrefid,a.hreftype,a.hreftarget,a.opentype,a.isshow,a.showorder,b.modename,a.isbatch,a.issystem,a.issystemflag ";
String sqlFrom = "from mode_pageexpand a,modeinfo b ";
//out.println("select " + backFields + "	"+sqlFrom + "	"+ SqlWhere);
String tableString=""+
	"<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
		"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"showorder\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
			"<head>"+    //扩展名称     
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(30170,user.getLanguage())+"\" column=\"expendname\" orderkey=\"expendname\"  otherpara=\"column:id+column:issystem+column:issystemflag+"+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getExpandNameNewUrl\"/>"+
				//扩展类型
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(81468,user.getLanguage())+"\" column=\"issystem\" orderkey=\"issystem\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getExpandType\"/>"+
				//扩展用途
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(81469,user.getLanguage())+"\" column=\"isbatch\" orderkey=\"isbatch\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getIsBatch\"/>"+
				//显示样式
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(23724,user.getLanguage())+"\" column=\"showtype\" orderkey=\"showtype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getShowType\"/>"+
				//打开方式
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(30173,user.getLanguage())+"\" column=\"opentype\" orderkey=\"opentype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getOpenType\"/>"+
				//链接目标来源
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(30174,user.getLanguage())+"\" column=\"hreftype\" orderkey=\"hreftype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getHrefType\"/>"+
				//链接目标
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(30181,user.getLanguage())+"\" column=\"hrefid\" orderkey=\"hrefid\" otherpara=\"column:hreftype\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getHrefName\"/>"+
				//链接目标地址
				"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(30178,user.getLanguage())+"\" column=\"hreftarget\" orderkey=\"hreftarget\"/>"+
				//是否显示
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15603,user.getLanguage())+"\" column=\"isshow\" orderkey=\"isshow\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getIsShow\"/>"+
				//显示顺序
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"showorder\" orderkey=\"showorder\"/>"+
			"</head>"+
	"</table>";
%>

<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>

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
        location.href="/formmode/setup/expandBase.jsp?modeid=<%=modeid%>";
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
