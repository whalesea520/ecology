<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href = "/css/Weaver_wev8.css" type = text/css rel = STYLESHEET>
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
				url:"HrmArrangeShiftOperation.jsp?isdialog=1&operation=deleteshift&id="+idArr[i],
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
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmArrangeShiftAdd";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(16255,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmArrangeShift&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(16255,user.getLanguage())%>";
	}
	dialog.Width = 600;
	dialog.Height = 400;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>

<%
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16255 , user.getLanguage()) ;  
String needfav = "1" ; 
String needhelp = "" ; 
String qname = Util.null2String(request.getParameter("flowTitle"));

boolean CanAdd = HrmUserVarify.checkUserRight("HrmArrangeShift:Maintance" , user) ; 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(1477,user.getLanguage())+",/hrm/schedule/HrmArrangeShiftHistory.jsp,_self} " ;
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
			<%if(CanAdd){ %>
			  <input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			  <input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<%
String backfields = " id, shiftname, shiftbegintime, shiftendtime, validedatefrom "; 
String fromSql  = " from HrmArrangeShift ";
String sqlWhere = " where isHistory=0 ";
String orderby = " id " ;
String tableString = "";

if(!qname.equals("")){
	sqlWhere += " and shiftname like '%"+qname+"%'";
}		

//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom></popedom> ";
 	       if(CanAdd){
 	       	operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\" isalwaysshow='true'/>";
 	       	operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\" isalwaysshow='true'/>";
 	       }
 	       operateString+="</operates>";	
 String tabletype="checkbox";
 
tableString =" <table pageId=\""+PageIdConst.HRM_ArrangeShiftList+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_ArrangeShiftList,user.getUID(),PageIdConst.HRM)+"\" >"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    operateString+
    "			<head>";
    if(CanAdd){
    	tableString +="				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"shiftname\" orderkey=\"shiftname\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmOpenDialogName\" otherpara=\"column:id\"/>";
    }else{
    	tableString +="				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"shiftname\" orderkey=\"shiftname\"/>";
    }
    tableString +="				<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"shiftbegintime\" orderkey=\"shiftbegintime\"/>"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"shiftendtime\" orderkey=\"shiftendtime\"/>"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(19548,user.getLanguage())+"\" column=\"validedatefrom\" orderkey=\"validedatefrom\"/>"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_ArrangeShiftList %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 
</BODY></HTML>
