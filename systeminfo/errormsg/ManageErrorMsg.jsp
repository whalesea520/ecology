<%@ page import="weaver.general.Util" %>
<%@ page import="java.net.URLDecoder" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="LabelMainManager" class="weaver.systeminfo.label.LabelMainManager" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("System:LabelManage",user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String hasTab = Util.null2String(request.getParameter("hasTab"));
	if(!hasTab.equals("1")){
		response.sendRedirect("/docs/tabs/DocCommonTab.jsp?_fromURL=85");
		return;
	}
%>
<HTML><HEAD>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmmain").attr("action","/systeminfo/errormsg/ManageErrorMsg.jsp?hasTab=<%=hasTab %>");
	jQuery("#frmmain").submit();
}
function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=90&isdialog=1";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("26473,176",user.getLanguage())%>";
		dialog.Height = 400;
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=91&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,176",user.getLanguage())%>";
		dialog.Height = 400;
	}
	dialog.Width = 600;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
function onLog(id){
	_onViewLog(420,"",id);
}
function exportMsg(){
	jQuery("#frmmain").attr("action","/systeminfo/errormsg/ErrorMsgOperation.jsp?operation=export&hasTab=<%=hasTab %>");
	jQuery("#frmmain").submit();
}

function importMsg(){
	parent.location.href="/docs/tabs/DocCommonTab.jsp?_fromURL=99&isdialog=1"
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(81485,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(25700,user.getLanguage());
String needfav ="1";
String needhelp ="";
String indexdesc = Util.null2String(request.getParameter("indexdesc"));
String id = Util.null2String(request.getParameter("id"));
RecordSet.executeSql("select * from syslanguage where activable=1 order by id asc");
int count = 0;//显示5列
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:exportMsg(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("32935,25700",user.getLanguage())+",javascript:importMsg(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:_onViewLog(418),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="exportMsg();" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage())%>"></input>
			<input type="text" class="searchInput" name="flowTitle" id="flowTitle"  onchange="setKeyword('flowTitle','indexdesc','frmmain');"  value="<%=indexdesc %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name="frmmain" id="frmmain" method="post" action="ManageErrorMsg.jsp?hasTab=<%=hasTab %>">
	<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
				<wea:item>ID</wea:item>
				<wea:item>
					<input type="text" id="id" name="id" value="<%=id %>"/>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
				<wea:item>
					<input type="text" id="indexdesc" name="indexdesc" value="<%=indexdesc %>"/>
				</wea:item>
				<%while(false && RecordSet.next()){ 
					if(count++>=5)break;
				%>
					<wea:item><%=RecordSet.getString("language")%></wea:item>
					<wea:item>
						<input type="text" id="name_<%=RecordSet.getString("id") %>" name="name_<%=RecordSet.getString("id")%>" value="<%=Util.null2String(request.getParameter("name_"+RecordSet.getString("id"))) %>"/>
					</wea:item>
				<%} %>
			</wea:group>
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
</form>
<%
	String sqlWhere = "1=1";
	String sqlfrom = "(select * from ( "+
			"select a.id as id,b.indexdesc, cname,ename,twname,elname,flname from ("+
					"select a.indexid as id,a.msgname as cname,c.msgname as ename,d.msgname as twname ,e.msgname as elname,f.msgname as flname  from (select  * from ErrorMsgInfo where languageid='#cname#')a " +
						"left join (select * from ErrorMsgInfo where languageid='#twname#')d on a.indexid = d.indexid "+ 
						"left join (select * from ErrorMsgInfo where languageid='#ename#')c on a.indexid = c.indexid "+ 
						"left join (select * from ErrorMsgInfo where languageid='#elname#')e on a.indexid = e.indexid "+
						"left join (select * from ErrorMsgInfo where languageid='#flname#')f on a.indexid = f.indexid "+
				") a,ErrorMsgIndex b where a.id=b.id) m) ff " ;
				
	if(!"".equals(id)){
		sqlWhere += " and id = '"+id+"'";
	}
	if(!"".equals(indexdesc)){
		sqlWhere += " and indexdesc like '%"+indexdesc+"%'";
	}
	String cname = "";
	String ename = "";
	String twname = "";
	String elname = "";
	String flname = "";
	if(RecordSet.next()){
		cname = Util.null2String(request.getParameter("name_"+RecordSet.getInt("id")));
		if(!"".equals(cname)){
			sqlWhere += " and cname like '%"+cname+"%'";
		}
		sqlfrom = sqlfrom.replaceFirst("#cname#",RecordSet.getString("id"));
	}else{
		sqlfrom = sqlfrom.replaceFirst("#cname#","7");
	}
	if(RecordSet.next()){
		ename = Util.null2String(request.getParameter("name_"+RecordSet.getInt("id")));
		if(!"".equals(ename)){
			sqlWhere += " and ename like '%"+ename+"%'";
		}
		sqlfrom = sqlfrom.replaceFirst("#ename#",RecordSet.getString("id"));
	}else{
		sqlfrom = sqlfrom.replaceFirst("#ename#","8");
	}
	if(RecordSet.next()){
		twname = Util.null2String(request.getParameter("name_"+RecordSet.getInt("id")));
		if(!"".equals(twname)){
			sqlWhere += " and twname like '%"+twname+"%'";
		}
		sqlfrom = sqlfrom.replaceFirst("#twname#",RecordSet.getString("id"));
	}else{
		sqlfrom = sqlfrom.replaceFirst("#twname#","9");
	}
	if(RecordSet.next()){
		elname = Util.null2String(request.getParameter("name_"+RecordSet.getInt("id")));
		if(!"".equals(elname)){
			sqlWhere += " and elname like '%"+elname+"%'";
		}
		sqlfrom = sqlfrom.replaceFirst("#elname#",RecordSet.getString("id"));
	}else{
		sqlfrom = sqlfrom.replaceFirst("#elname#","0");
	}
	if(RecordSet.next()){
		flname = Util.null2String(request.getParameter("name_"+RecordSet.getInt("id")));
		if(!"".equals(flname)){
			sqlWhere += " and flname like '%"+flname+"%'";
		}
		sqlfrom = sqlfrom.replaceFirst("#flname#",RecordSet.getString("id"));
	}else{
		sqlfrom = sqlfrom.replaceFirst("#flname#","0");
	}

	RecordSet.beforFirst();
	
	String  operateString= "";
	operateString = "<operates width=\"20%\">";
	 	       operateString+=" <popedom></popedom> ";
	 	       operateString+="     <operate isalwaysshow=\"true\" href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate isalwaysshow=\"true\" href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelNames("25484,83",user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="</operates>";	
	 String tabletype="none";
	String tableString=""+
	   "<table pageId=\""+PageIdConst.SYS_SYSTEM_ERROR_LIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.SYS_SYSTEM_ERROR_LIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\""+Util.toHtmlForSplitPage(sqlfrom)+"\" sqlorderby=\"ff.id\"  sqlprimarykey=\"ff.id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+							 
			 "<col width=\"10%\" text=\"ID\" column=\"id\"  orderkey=\"ff.id\"/>"+
			 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"indexdesc\" orderkey=\"indexdesc\"/>";
			 if(RecordSet.next()){
			 	tableString+="<col width=\"20%\"  text=\""+RecordSet.getString("language")+"\" column=\"cname\" orderkey=\"cname\"/>";
			 }
			 if(RecordSet.next()){
			 	tableString += "<col width=\"20%\"  text=\""+RecordSet.getString("language")+"\" column=\"ename\" orderkey=\"ename\"/>";
			 }
			 if(RecordSet.next()){
			 	tableString += "<col width=\"20%\"  text=\""+RecordSet.getString("language")+"\" column=\"twname\" orderkey=\"twname\"/>";
			 }
			 if(RecordSet.next()){
			 	tableString += "<col width=\"20%\"  text=\""+RecordSet.getString("language")+"\" column=\"elname\" orderkey=\"elname\"/>";
			 }
			 if(RecordSet.next()){
			 	tableString += "<col width=\"20%\"  text=\""+RecordSet.getString("language")+"\" column=\"flname\" orderkey=\"flname\"/>";
			 }
	   	tableString = tableString + "</head>"+
	   "</table>";
%> 
<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.SYS_SYSTEM_ERROR_LIST %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
</BODY>
</HTML>
