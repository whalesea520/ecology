<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<HTML>

<%
if(!HrmUserVarify.checkUserRight("HrmArrangeShiftMaintance:Maintance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String qname = Util.null2String(request.getParameter("flowTitle"));
String name = Util.null2String(request.getParameter("name"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16749 , user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<HEAD>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
  <script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
	<script type="text/javascript">
	function onBtnSearchClick(){
		jQuery("#frmmain").submit();
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
					url:"HrmArrangeShiftSetOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
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
		var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmArrangeShiftSetAdd&isdialog=1";
		if(!!id){
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(32766 ,user.getLanguage())%>";
			url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmArrangeShiftSetEdit&isdialog=1&id="+id;
		}else{
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(32766,user.getLanguage())%>";
		}
		dialog.Width = 500;
		dialog.Height = 253;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
</script>
</HEAD>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>    
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:openDialog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=frmmain name=frmmain action="HrmArrangeShiftSet.jsp" method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(21957,user.getLanguage())%></wea:item>
			<wea:item><input type="text" id="name" name="name" class="inputStyle" value=""></wea:item>
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
//modified by wcd 2014-08-05
String backfields = " a.id,a.relatedId,a.sharetype,a.level_from,a.level_to,a.relatedName "; 
String fromSql  = " from( select a.id,a.relatedId,a.sharetype,a.level_from,a.level_to,(case when a.sharetype = 1 then b.subcompanyname else (case when a.sharetype = 2 then c.departmentname else (case when a.sharetype = 3 then d.lastname else (case when a.sharetype = 4 then e.rolesname else (select labelname from HtmlLabelInfo where indexid = 1340 and languageid = "+user.getLanguage()+") end)end)end)end) as relatedName from HrmArrangeShiftSet a left join HrmSubCompany b on a.relatedid = b.id left join HrmDepartment c on a.relatedid = c.id left join HrmResource d on a.relatedid = d.id left join HrmRoles e on a.relatedid = e.id ) a ";
String sqlWhere = " where 1 = 1 ";
String tableString = "";

if(!qname.equals("")){
	sqlWhere += " and relatedName like '%"+qname+"%'";
}else if(!name.equals("")){
	sqlWhere += " and relatedName like '%"+name+"%'";
}


//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom></popedom> ";
 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\" isalwaysshow=\"true\"/>";
 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\" isalwaysshow=\"true\"/>";
 	       operateString+="</operates>";	
 String tabletype="checkbox";
 if(HrmUserVarify.checkUserRight("HrmArrangeShiftMaintance:Maintance", user)){
 	tabletype = "checkbox";
 }
 
tableString =" <table pageId=\""+PageIdConst.HRM_ArrangeShiftSet+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_ArrangeShiftSet,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getHrmArrangeShiftSetCheckbox\" id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"sharetype\" orderkey=\"sharetype\" transmethod=\"weaver.hrm.HrmTransMethod.getShareTypeName\" otherpara=\""+user.getLanguage()+"\"  />"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(21957,user.getLanguage())+"\" column=\"relatedId\" orderkey=\"relatedId\" transmethod=\"weaver.hrm.HrmTransMethod.getRelatedIdName\" otherpara=\"column:sharetype\" />"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"level_from\" orderkey=\"level_from\" otherpara=\"column:level_to\" transmethod=\"weaver.hrm.HrmTransMethod.getLevelShow\" />"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_ArrangeShiftSet %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
</form>
<script language=javascript>
function submitData() {
    document.frmmain.action="HrmArrangeShiftSet.jsp" ; 
    document.frmmain.submit();
}
function CheckAll(obj) {
	var chks=document.getElementsByName("resourceids");
	for(var i=0;i<chks.length;i++)chks[i].checked=obj.checked;

}
</script>

</BODY>
</HTML>
