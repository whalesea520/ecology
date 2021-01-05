
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page"/>





<%
String treeDocFieldId=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID;

String treeDocFieldName=DocTreeDocFieldComInfo.getTreeDocFieldName(treeDocFieldId);

String refresh = Util.null2String(request.getParameter("refresh"));

String optype = Util.null2String(request.getParameter("optype"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%= !treeDocFieldName.equals("")?treeDocFieldName:SystemEnv.getHtmlLabelName(20482,user.getLanguage()) %>");
	}catch(e){}
	</script>
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
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function() {
		//var idArr = id.split(",");
		//for(var i=0;i<idArr.length;i++){
			jQuery.ajax({
				url:"DocTreeDocFieldOperation.jsp?isdialog=1&operation=Delete",
				type:"post",
				data:{
					id:id
				},
				complete:function(xhr,status){
					//if(i==idArr.length-1){
						_table.reLoad();
						parent.parent.refreshTreeMain(<%=treeDocFieldId%>,null);
					//}
				}
			});
		//}
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
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=12&isdialog=1&superiorFieldId="+id;
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,32520",user.getLanguage())%>";
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=13&from=edit&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,32520",user.getLanguage())%>";
	}
	dialog.Width = 600;
	dialog.Height = 321;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function openDialog2(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=12&isdialog=1&id="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,32520",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 321;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function openDialog3(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=12&isdialog=1&superiorFieldId="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,32520",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 321;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

jQuery(document).ready(function(){
	<%if("1".equals(refresh)){%>
		parent.parent.refreshTreeMain(<%=treeDocFieldId%>,null);
	<%}else if("2".equals(refresh)){%>
		parent.parent.refreshTreeMain(<%=treeDocFieldId%>,null,{add:true});
	<%}%>
});

</script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19410,user.getLanguage());
String needfav ="1";
String needhelp ="";
String qname = Util.null2String(request.getParameter("flowTitle"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!optype.equals("1")){
	if(HrmUserVarify.checkUserRight("DummyCata:Maint", user)){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	}
}else{  

	if(HrmUserVarify.checkUserRight("DummyCata:Maint", user)){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog3("+DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID+"),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	}
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:_onViewLog(270),_top} " ;
RCMenuHeight += RCMenuHeightStep ;


%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("DummyCata:Maint", user)){ %>
				<%if(!optype.equals("1")){ %>
					<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
				<%}else{ %>
					<input type=button class="e8_btn_top" onclick="openDialog3(<%=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID %>);" value="<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
				<%} %>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>


<FORM id=weaver name=frmMain action="DocTreeDocFieldOperation.jsp" method=post>
		
		<wea:layout>
			<%if(!optype.equals("1")){ %>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(24764,user.getLanguage())%></wea:item>
				<wea:item>
					<wea:required id="treeDocFieldNameImage" required="true" value='<%=treeDocFieldName%>'>
						<INPUT class=InputStyle  name=treeDocFieldName value="<%=treeDocFieldName%>" onchange='checkinput("treeDocFieldName","treeDocFieldNameImage")'>
					</wea:required>
				</wea:item>
			</wea:group>
			<%}else{ %>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(32866,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
					<wea:item attributes="{'isTableList':'true'}">
						<%
							String sqlWhere = "superiorFieldId="+treeDocFieldId;
							if(!qname.equals("")){
								sqlWhere += " and treeDocFieldName like '%"+qname+"%'";
							}							
							String  operateString= "";
							if(HrmUserVarify.checkUserRight("DummyCata:Maint", user)){
							operateString = "<operates width=\"20%\">";
							 	       operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getVirDirOperate\"></popedom> ";
							 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
							 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
							 	       operateString+="     <operate href=\"javascript:openDialog2()\" text=\""+SystemEnv.getHtmlLabelName(19413,user.getLanguage())+"\" index=\"2\"/>";
							 	       operateString+="     <operate href=\"javascript:openDialog3()\" text=\""+SystemEnv.getHtmlLabelName(19412,user.getLanguage())+"\" index=\"3\"/>";
							 	      // operateString+="     <operate href=\"javascript:openDialog4()\" text=\""+SystemEnv.getHtmlLabelName(1507,user.getLanguage())+"\" index=\"4\"/>";
							 	       operateString+="</operates>";	
							 }	
							String tableString=""+
							   "<table instanceid=\"docMouldTable\" pageId=\""+PageIdConst.DOC_TREECATEGORROOTLIST+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_TREECATEGORROOTLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
							    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getVirDirCheckbox\" popedompara = \"column:id\" />"+
							   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"DocTreeDocField\" sqlorderby=\"showOrder\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
							   operateString+
							   "<head>"+							 
									 "<col width=\"40%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(24764,user.getLanguage())+"\"  href=\"/docs/category/DocTreeTab.jsp?_fromURL=3\" column=\"treeDocFieldName\" linkkey=\"id\" linkvaluecolumn=\"id\" target=\"_parent\" orderkey=\"treeDocFieldName\"/>"+
									 "<col width=\"40%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"treeDocFieldDesc\"/>"+
									 "<col width=\"20%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"showOrder\"/>"+
							   "</head>"+
							   "</table>";
						%> 
						<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
					</wea:item>
				</wea:group>
			<%} %>
		</wea:layout>
		


   <input type=hidden name=operation>
   <input type=hidden name=id value="<%=treeDocFieldId%>">
 </FORM>

<%if(optype.equals("1")){ %>
	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_TREECATEGORROOTLIST %>"/>
<%} %>

</BODY></HTML>


<script language=javascript>

function onSave(){
	document.frmMain.operation.value="RootEditSave";
	document.frmMain.submit();
}

</script>
