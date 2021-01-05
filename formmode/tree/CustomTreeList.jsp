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
	String titlename = SystemEnv.getHtmlLabelName(30208,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String treename = Util.null2String(request.getParameter("treename"));
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

<form name="frmSearch" method="post" action="/formmode/tree/CustomTreeList.jsp">
	<table class="ViewForm">
		<COLGROUP>
			<COL width="15%">
			<COL width="35%">
			<COL width="15%">
			<COL width="35%">
		</COLGROUP>
		<tr>
			<td>
				<%=SystemEnv.getHtmlLabelName(30209,user.getLanguage())%><!-- 树形名称 -->
			</td>
			<td class=Field>
				<input class="inputstyle" id="treename" name="treename" type="text" value="<%=treename%>">
			</td>
			<!-- 
			<td>
				<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%>
			</td>
			<td class="Field">
		  		 <button type="button" class=Browser id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></button>
		  		 <span id=modeidspan><%=modename%></span>
		  		 <input type="hidden" name="modeid" id="modeid" value="<%=modeid%>">
			</td>
			 -->
		</tr>
		<tr style="height:1px"><td colspan=4 class=Line></td></tr>
	</table>
</form>

<%
String SqlWhere = " where 1 = 1";
if(!treename.equals("")){
	SqlWhere += " and a.treename like '%"+treename+"%' ";
}


String perpage = "10";
String backFields = "a.id,a.modeid,a.treename,a.treedesc,a.creater,a.createdate,a.createtime ";
String sqlFrom = "from mode_customtree a";
//out.println("select " + backFields + "	"+sqlFrom + "	"+ SqlWhere);
String tableString=""+
	"<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
		"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
			"<head>"+                            //树形名称 
				"<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(30209,user.getLanguage())+"\" column=\"treename\" orderkey=\"treename\" target=\"_self\" linkkey=\"id\" linkvaluecolumn=\"id\" href=\"/formmode/tree/CustomTreeView.jsp\"/>"+
				//描述
				"<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"treedesc\"/>"+
				//"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getOpenType\"/>"+
				//"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"opentype\" orderkey=\"opentype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.interfaces.InterfaceTransmethod.getOpenType\"/>"+
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
        location.href="/formmode/tree/CustomTreeAdd.jsp";
        //window.open("/formmode/tree/CustomTreeAdd.jsp");
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
