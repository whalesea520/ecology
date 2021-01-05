
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SearchComInfo1" class="weaver.proj.search.SearchComInfo" scope="session" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />

<%
 if(!HrmUserVarify.checkUserRight("NetworkSegmentStrategy:All",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
String id = Util.null2String(request.getParameter("id"));
String qname = Util.null2String(request.getParameter("flowTitle"));
String inceptipaddress = Util.null2String(request.getParameter("inceptipaddress"));
String endipaddress = Util.null2String(request.getParameter("endipaddress"));
String segmentdesc = Util.null2String(request.getParameter("segmentdesc"));
//System.out.println("============================");
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(21384,user.getLanguage());
String needfav ="1";
String needhelp ="";

//TD3968
//added by hubo,2006-03-23
int perpage=Util.getIntValue(request.getParameter("perpage"),10);

/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

String backFields = "id,inceptipaddress,endipaddress,createrid,createdate,createtime,segmentdesc";
String sqlFrom = " from HrmnetworkSegStr";
String sqlWhere = " where 1=1 ";

if(qname.length()>0){
	sqlWhere += " and (inceptipaddress like '%"+qname+"%' or endipaddress like '%"+qname+"%') ";
}

if(inceptipaddress.length()>0){
	sqlWhere += " and inceptipaddress like '%"+inceptipaddress+"%' ";
}

if(endipaddress.length()>0){
	sqlWhere += " and endipaddress like '%"+endipaddress+"%' ";
}

if(segmentdesc.length()>0){
	sqlWhere += " and segmentdesc like '%"+segmentdesc+"%' ";
}

//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
	       operateString+=" <popedom></popedom> ";
	       operateString+="     <operate href=\"javascript:openDialog();\" isalwaysshow='true' text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	       operateString+="     <operate href=\"javascript:doDel()\" isalwaysshow='true' text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
	       operateString+="     <operate href=\"javascript:onLog()\" isalwaysshow='true' text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
	       operateString+="</operates>";	
String tabletype="checkbox";
if(HrmUserVarify.checkUserRight("NetworkSegmentStrategy:All", user)){
	tabletype = "checkbox";
}

String tableString=""+
			  "<table  pagesize=\""+perpage+"\" tabletype=\""+tabletype+"\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
			  operateString+
			  "<head>"+                             
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(21385,user.getLanguage())+"\" column=\"id\" otherpara=\"column:inceptipaddress+column:endipaddress\" transmethod=\"weaver.hrm.HrmTransMethod.getIpAddress\" />"+
					  "<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(21386,user.getLanguage())+"\" column=\"segmentdesc\"   target=\"_self\" linkvaluecolumn=\"id\" />"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"createrid\" orderkey=\"createrid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+
					  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\" otherpara=\"column:createtime\" transmethod=\"weaver.hrm.tools.IpTransMethod.getDateTime\" orderkey=\"createdate\"/>"+
			  "</head>"+
			  "<operates width=\"5%\">"+
			  "    <operate href=\"javascript:onDelete()\"  text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"  index=\"0\"/>"+
			  "</operates>"+
			  "</table>";
%>
<html>
<head>
<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"/hrm/tools/NetworkSegmentStrategyOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
						_table.reLoad();
					}
				}
			});
		}
	});
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=NetworkSegmentStrategyAdd";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(21384,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=NetworkSegmentStrategyEdit&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(21384,user.getLanguage())%>";
	}
	dialog.Width = 480;
	dialog.Height = 229;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=101 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=101")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:openDialog(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
*/
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>" /> 
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;">
	<TABLE class=ViewForm>
		<COLGROUP>
			<COL width="20%">
			<COL width="30%">
			<COL width="20%">
			<COL width="30%">
		<TBODY>
     <TR>
       <TD><%=SystemEnv.getHtmlLabelName(21387,user.getLanguage())%></TD>
       <TD class=Field><input class=inputstyle type=text style="width: 95%" value="<%=inceptipaddress %>" name="inceptipaddress"></TD>
       <TD><%=SystemEnv.getHtmlLabelName(21388,user.getLanguage())%></TD>
       <TD class=Field><input class=inputstyle  type=text style="width: 95%" value="<%=endipaddress %>" name="endipaddress"></TD>
     </TR>
   	 <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
	   <TR>
       <TD><%=SystemEnv.getHtmlLabelName(21386,user.getLanguage())%></TD>
       <TD class=Field><input class=inputstyle type=text style="width: 95%" value="<%=segmentdesc %>" name="segmentdesc"></TD>
     	 <td class=Field></td>
     	 <td class=Field></td>
     </TR>
     <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
     <tr align="center">
     	<td colspan="4" class="btnTd">
     		<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
     	</td>
     </tr>
		</TBODY>
	</TABLE>
</div>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/></td>
</form>
<form><input type="hidden" name="s" value="<%=sqlWhere%>"/></form>
</body>
</html>
