<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="MailMouldComInfo" class="weaver.docs.mail.MailMouldComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
	function onBtnSearchClick(){
		jQuery("#frmmain").submit();
	}
	
	function onDelete(id){
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
		var idArr = id.split(",");
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function() {
			var ajaxNum=0;
		   for(var i=0;i<idArr.length;i++){
			   ajaxNum++;
				//以ajax方式提交
				jQuery.ajax({
					url:"UploadDoc.jsp",
					type:"post",
					data:{
						operation:"delete",
						id:idArr[i]
					},
					complete:function(xhr,status){
							ajaxNum--;
						if(ajaxNum==0)
							_table.reLoad();
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
		var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=28&isdialog=1";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,16218",user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height = 724;
		if(!!id){
			url = "/docs/tabs/DocCommonTab.jsp?_fromURL=29&isdialog=2&id="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,16218",user.getLanguage())%>";
			dialog.Width = 800;
			dialog.Height = 752;
		}
		dialog.maxiumnable = true;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	
	//另存为模板
	function openDialogSaveAs(id){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=29&isdialog=2&operation=add&id="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("33144,350",user.getLanguage())+"..."%>";
		dialog.Width = 800;
		dialog.Height = 692;
		dialog.maxiumnable = true;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	
	function onLog(){
		var dialog = new window.top.Dialog();
		dialog.URL = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&sqlwhere=<%=xssUtil.put("where operateitem =57")%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(17480,user.getLanguage())%>";
		dialog.Width = jQuery(document).width();
		dialog.Height = 610;
		dialog.checkDataChange = false;
		dialog.maxiumnable = true;
		dialog.show();
		
	}
	/*查看模板*/
	function viewDialog(id){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window; 
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=30&isdialog=2&id="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(33025,user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height = 460;
		dialog.checkDataChange = false;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.maxiumnable = true;
		dialog.show();
	}
</script>
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16218,user.getLanguage());

String needfav ="1";
String needhelp ="";
String mouldName = Util.null2String(request.getParameter("flowTitle"));
String subcompanyId = Util.null2String(String.valueOf(session.getAttribute("mailMould_subcompanyid")));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

if(HrmUserVarify.checkUserRight("DocMailMouldAdd:add", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("DocMailMouldEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("DocMailMould:log", user) ){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="DocMould.jsp" name="frmmain" id="frmmain">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%
			if(HrmUserVarify.checkUserRight("DocMailMouldAdd:add", user)){
			%>
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" onclick="javascript:openDialog()"/>
			<%
			}if(HrmUserVarify.checkUserRight("DocMailMouldEdit:Delete", user)){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>" class="e8_btn_top" onclick="onDelete();"/>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" value="<%=mouldName %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<%

String sqlWhere = "1=1";
				if(!mouldName.equals("")){
					sqlWhere = " mouldName like '%"+mouldName+"%'";
				}
				if(Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0)==1){
					sqlWhere += " and subcompanyid="+subcompanyId;
				}	
				

    String  operateString= "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getMailOperate\"  otherpara=\""+HrmUserVarify.checkUserRight("DocMailMouldAdd:add", user)+":"+HrmUserVarify.checkUserRight("DocMailMouldEdit:Edit", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("DocMailMouldEdit:Delete", user)+"\"></popedom> ";
	 	       operateString+="     <operate href=\"javascript:openDialog()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"javascript:openDialogSaveAs()\" text=\""+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="     <operate href=\"javascript:onDelete()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"  index=\"2\"/>";
	 	       operateString+="</operates>";

String tableString=""+
	   "<table instanceid=\"docMouldTable\" pageId=\""+PageIdConst.DOC_MAILMOULDLIST+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_MAILMOULDLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
	   " <checkboxpopedom  showmethod=\"weaver.general.KnowledgeTransMethod.getMailCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"DocMailMould\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+							 
			 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"id\" />"+
			 "<col width=\"60%\" text=\""+SystemEnv.getHtmlLabelName(18151,user.getLanguage())+"\" column=\"mouldName\" transmethod=\"weaver.general.KnowledgeTransMethod.getMailName\" otherpara=\"column:id\" orderkey=\"mouldName\"/>"+
			 "<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(19521 ,user.getLanguage())+"\" column=\"lastModTime\" transmethod=\"weaver.general.KnowledgeTransMethod.getMouldModDate\" />"+
	   "</head>"+
	   "</table>"; 
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_MAILMOULDLIST%>"/>
   <wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 
    
 
 </BODY></HTML>
