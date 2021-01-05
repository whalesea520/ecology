<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
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
				url:"HrmBankOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
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
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmBankAdd&isdialog=1";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(15812,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmBankEdit&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(15812,user.getLanguage())%>";
	}
	dialog.Width = 500;
	dialog.Height = 203;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onLog(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=33 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=33")%>";
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
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(389,user.getLanguage());
String needfav ="1";
String needhelp ="";

String bankname = Util.null2String(request.getParameter("bankname"));
String bankdesc = Util.null2String(request.getParameter("bankdesc"));

String qname = Util.null2String(request.getParameter("flowTitle"));

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmBankAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmBank:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmBankAdd:Add", user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<%}if(HrmUserVarify.checkUserRight("HrmBankAdd:Add", user)){ %>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelNames("15812,399",user.getLanguage())%></wea:item>
			<wea:item><input type="text" id="bankname" name="bankname" class="inputStyle" value='<%=bankname%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("15812,15767",user.getLanguage())%></wea:item>
			<wea:item><input type="text" id="bankdesc" name="bankdesc" class="inputStyle" value=<%=bankdesc%>></wea:item>
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</form>
<%
String backfields = " id, bankname, bankdesc ,(select count(id) from hrmresource b where b.bankid1 = a.id) as result  "; 
String fromSql  = " from HrmBank a ";
String sqlWhere = " where 1 = 1 ";
String orderby = " id " ;
String tableString = "";

if(!qname.equals("")){
	sqlWhere += " and bankname like '%"+qname+"%'";
}		

if (!"".equals(bankname)) {
	sqlWhere += " and bankname like '%"+bankname+"%'";
	}  	  	

if (!"".equals(bankdesc)) {  
	sqlWhere += " and bankdesc like '%"+bankdesc+"%'"; 	  	
}

//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getHrmBankOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmBankEdit:Edit", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmBankEdit:Delete", user)+":"+HrmUserVarify.checkUserRight("HrmBank:log", user)+":"+HrmUserVarify.checkUserRight("HrmBankAdd:add", user)+":+column:result+\"></popedom> ";
operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
operateString+="</operates>";	
 String tabletype="checkbox";
 if(HrmUserVarify.checkUserRight("HrmBankEdit:Delete", user)){
 	tabletype = "checkbox";
 }
 
tableString =" <table pageId=\""+PageIdConst.HRM_BankList+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_BankList,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getHrmBankCheckbox\" id=\"checkbox\" popedompara=\"column:result\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelNames("15812,399",user.getLanguage()) + "\" column=\"bankname\" orderkey=\"bankname\" />"+
    "				<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelNames("15812,15767",user.getLanguage()) + "\" column=\"bankdesc\" orderkey=\"bankdesc\" />"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_BankList %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
</body>
</html>
