
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<%int linkType = Util.getIntValue(request.getParameter("linktype"),1);  %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
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
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
		jQuery.ajax({
			url:"/workflow/workflow/officalwf_operation.jsp",
			type:"post",
			dataType:"json",
			data:{
				wfid:id,
				operation:"delProcess"
			},
			beforeSend:function(){
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
			},
			complete:function(){
				e8showAjaxTips("",false);
			},
			success:function(data){
				_table.reLoad();
			}
		});
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
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=78&linktype=<%=linkType%>&isdialog=1";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,"+(linkType==1?"26528":(linkType==2?"33682":"33683"))+",33691",user.getLanguage())%>";
		dialog.Height = 400;
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=78&linktype=<%=linkType%>&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,"+(linkType==1?"26528":(linkType==2?"33682":"33683"))+",33691",user.getLanguage())%>";
		dialog.Height = 400;
	}
	dialog.Width = 600;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onEDPstatus(id,status){
	if(!id){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	jQuery.ajax({
		url:"/workflow/workflow/officalwf_operation.jsp",
		type:"post",
		dataType:"json",
		data:{
			wfid:id,
			operation:"edpstatus",
			status:status
		},
		beforeSend:function(){
			e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>",true);
		},
		complete:function(){
			e8showAjaxTips("",false);
		},
		success:function(data){
			_table.reLoad();
		}
	});
}

function onDisabled(id){
	onEDPstatus(id,0);
}

function onEnabled(id){
	onEDPstatus(id,1);
}

function setInstrutions(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=79&isdialog=1&id="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("22409,33508",user.getLanguage())%>";
	dialog.Height = 400;
	dialog.Width = 600;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

</script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(65,user.getLanguage());
String needfav ="1";
String needhelp ="";
String qname = Util.null2String(request.getParameter("flowTitle"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:_onViewLog(345),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<%
	String  operateString= "";
	String sqlWhere = "linkType="+linkType;
	operateString = "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getPDOperate\" otherpara=\"column:isSys\" otherpara2=\"column:status\"></popedom> ";
	 	       operateString+="     <operate href=\"javascript:onDisabled()\" text=\""+SystemEnv.getHtmlLabelName(18096,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"javascript:onEnabled()\" text=\""+SystemEnv.getHtmlLabelName(31676,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"2\"/>";
	 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"3\"/>";
	 	       operateString+="     <operate href=\"javascript:setInstrutions();\" text=\""+SystemEnv.getHtmlLabelNames("22409,33508",user.getLanguage())+"\" index=\"4\"/>";
	 	       operateString+="</operates>";	
	String tabletype = "checkbox";
	String tableString=""+
	   "<table pageId=\""+PageIdConst.DOC_PROCESSLIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_PROCESSLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
	    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getPDCheckbox\" popedompara = \"column:isSys\" />"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"workflow_processdefine\" sqlorderby=\"sortorder\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+							 
			 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelNames("26528,33691",user.getLanguage())+"\" column=\"label\"/>"+
			 "<col width=\"20%\"  transmethod=\"weaver.general.KnowledgeTransMethod.getLabel\" column=\"shownamelabel\" otherpara=\"7\" text=\""+SystemEnv.getHtmlLabelName(30828,user.getLanguage())+"\"/>"+
			 "<col width=\"10%\"  transmethod=\"weaver.general.KnowledgeTransMethod.getPDStatus\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" otherpara=\""+user.getLanguage()+"\"/>"+
			 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"sortorder\"/>"+
	   "</head>"+
	   "</table>";
%> 
<input type="hidden" name="pageId" _showCol="false" id="pageId" value="<%= PageIdConst.DOC_PROCESSLIST %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
</BODY>
</HTML>
