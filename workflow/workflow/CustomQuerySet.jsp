<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
</head>
<%
if(!HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20773,user.getLanguage())+SystemEnv.getHtmlLabelName(19653,user.getLanguage());
String needfav ="1";
String needhelp ="";

String shortName = Util.null2String(request.getParameter("shortName"));
String otype=Util.null2String(session.getAttribute("customquery_otype"));
int subcompanyid=Util.getIntValue(Util.null2String(session.getAttribute("customquery_subcompanyid")),0);
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel = -1;
if(detachable==1){                                                    
	if(subcompanyid>0){
	    operatelevel = checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowCustomManage:All", subcompanyid);
	}else{
		int tempsubcompanyid2[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowCustomManage:All",2);
		if(null!=tempsubcompanyid2 && tempsubcompanyid2.length > 0){
		    operatelevel = 2;
		}else{
		    tempsubcompanyid2 = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowCustomManage:All",1);
		    if(null!=tempsubcompanyid2 && tempsubcompanyid2.length > 0){
		        operatelevel = 1;
		    }
		}
	}
}else{
    operatelevel = 2;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	if(operatelevel > 0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javaScript:newDialog(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javaScript:deltype(),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<TABLE class=Shadow>
<tr>
<td valign="top">
<form name="frmSearch" method="post" action="/workflow/workflow/CustomQuerySet.jsp" >
	<input type="hidden" name="otype" value="<%=otype%>" />
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<%if(operatelevel > 0){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>" class="e8_btn_top" onclick="newDialog()"/>
				<%} %>	
				<%if(operatelevel > 1){%>	
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="deltype()"/>
				<%}%>
				<input type="text" class="searchInput" name="flowTitle" value="<%=shortName%>"/>
				&nbsp;&nbsp;&nbsp;
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
			
	<div id="tabDiv" >
		<span class="toggleLeft" title="<%=SystemEnv.getHtmlLabelName(32814,user.getLanguage())%>" onclick="mnToggleleft()"><%if(detachable==1){%><%=SystemEnv.getHtmlLabelName(33553,user.getLanguage())%>/<%}%><%=SystemEnv.getHtmlLabelName(33234,user.getLanguage())%></span>
		<span id="hoverBtnSpan" class="hoverBtnSpan">
		<span class="selectedTitle"><%=SystemEnv.getHtmlLabelName(20773,user.getLanguage())%></span>
		</span>
	</div>
		
	<!-- bpf start 2013-10-29 -->
	<div class="advancedSearchDiv" id="advancedSearchDiv" style="text-align:left;">
		<wea:layout attributes="{'cw1':'30%','cw2':'70%'}">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(20773,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			    <wea:item>
			    	<input type="text" name="shortName" class="inputStyle" value='<%=shortName%>'>
			    	<input type="hidden" name="subcompanyid" value="<%=subcompanyid %>">
			    </wea:item>
		    </wea:group>
		    <wea:group context="">
		    	<wea:item type="toolbar">
		    		<input class="e8_btn_submit" type="submit" name="submit2" value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/>
		    		<input class="e8_btn_cancel" type="button" name="reset" onclick="onReset();" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"/>
		    		<input class="e8_btn_cancel" type="button" id="cancel" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/>
		    	</wea:item>
		    </wea:group>
		</wea:layout>
	</div>
	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_CUSTOMQUERYSET %>"/>
</form>

<%
StringBuffer buffer  = new StringBuffer();

buffer.append(" where 1=1 ");
if(Util.getIntValue(otype,0)>0){
	if(rs.getDBType().equals("oracle")){
	    buffer.append(" and nvl(QUERYTYPEID,0)=").append(Util.getIntValue(otype,0));
	}else{
	    buffer.append(" and isnull(QUERYTYPEID,0)=").append(Util.getIntValue(otype,0));
	}
}
if(subcompanyid>0){
	if(rs.getDBType().equals("oracle")){
	    buffer.append("and nvl(subcompanyid,0)=").append(subcompanyid);
	}else{
	    buffer.append("and isnull(subcompanyid,0)=").append(subcompanyid);
	}
}
if(StringUtils.isNotBlank(shortName)){
    buffer.append(" and Customname like '%").append(shortName).append("%'");
    
}

if(detachable == 1 && user.getUID() != 1){
    String hasRightSub=subCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowCustomManage:All",-1);
	if(StringUtils.isNotBlank(hasRightSub)){
	    buffer.append(" and subcompanyid in(").append(hasRightSub).append(")");
	}else{
	    buffer.append(" and 1=2");
	}
}
String sqlWhere = buffer.toString();	
String orderby =" Customname,id ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,formID,isBill,Querytypeid,Customname,Customdesc,workflowids,subCompanyId ";
String fromSql  = " workflow_custom ";
String para1 = "column:isBill+"+user.getLanguage();
tableString =   " <table instanceid=\"workflowcustomQuerytypeTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_CUSTOMQUERYSET,user.getUID())+"\" >";
tableString+= 	"		<checkboxpopedom  id=\"checkbox\" popedompara=\"column:subcompanyid+"+ user.getUID()+"+"+detachable+"\" showmethod=\"weaver.workflow.workflow.CustomQueryManager.getCheckBox\" />";
tableString+=   "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"false\" />";
tableString+=   "       <head>";
tableString+=   "           <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(20773,user.getLanguage())+"\" column=\"Customname\" orderkey=\"Customname\" otherpara=\"column:id+"+user.getLanguage()+"\" transmethod=\"weaver.workflow.workflow.CustomQueryManager.getCustomQuerySetLink\"/>";
tableString+=   "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15451,user.getLanguage())+"\" column=\"formID\" otherpara=\""+para1+"\" orderkey=\"formID\" transmethod=\"weaver.workflow.workflow.CustomQueryManager.getFormName\" />";
tableString+=   "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"Customdesc\" orderkey=\"Customdesc\" />";
if(detachable==1){
tableString+=   "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.workflow.CustomQueryManager.getsubcomName\"/>";
}
tableString+=   "       </head>";
tableString+=   "		<operates>";
tableString+=	"       <popedom otherpara=\"column:subcompanyid+"+ user.getUID()+"+"+detachable+"\" transmethod=\"weaver.workflow.workflow.CustomQueryManager.getCanDelTypeList\"></popedom> ";
tableString+=   "		<operate href=\"javascript:showEditDialog();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"0\"/>";
tableString+=	"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>";
tableString+=	"		</operates>";
tableString+=   " </table>";
%>

<TABLE width="100%" cellspacing=0>
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>
</td>
</tr>
</TABLE>
<script type="text/javascript">
    function doSubmit(){
        enableAllmenu();
        document.frmSearch.submit();
    }
    function doAdd(){
        enableAllmenu();
      	<%if(detachable==1){%>
        location.href="/workflow/workflow/CustomQueryAdd.jsp?Querytypeid=<%=otype%>&subcompanyid=<%=subcompanyid%>";
        <%}else{%>
        location.href="/workflow/workflow/CustomQueryAdd.jsp?Querytypeid=<%=otype%>";
        <%}%>
    }
</script>
</BODY>
<script type="text/javascript">

	function showEditDialog(id){

		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/workflow/CustomQueryEditTab.jsp?otype=<%=otype%>&id=" + id;
		
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>" + "<%=SystemEnv.getHtmlLabelName(20785,user.getLanguage())%>";
		dialog.Width = 900;
		dialog.Height = 500;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();

	}

	var diag_vote
	   jQuery(document).ready(function () {
		$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
		$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		$("#tabDiv").remove();		
	});

	function newDialog(){
		diag_vote = new window.top.Dialog();
		diag_vote.currentWindow = window;
		diag_vote.Width = 550;
		diag_vote.Height = 330;
		diag_vote.Modal = true;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" + "<%=SystemEnv.getHtmlLabelName(20785,user.getLanguage())%>";
		diag_vote.URL = "/workflow/workflow/CustomQueryAdd.jsp?otype=<%=otype%>&dialog=1";
		diag_vote.isIframe=false;
		diag_vote.show();
	}

	function closeDialog(){
		diag_vote.close();
	}

	function deltype(){
		var typeids = "";
		$("input[name='chkInTableTag']").each(function(){
		if($(this).attr("checked"))			
			typeids = typeids +$(this).attr("checkboxId")+",";
		});
		if(typeids=="") return ;
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
							window.location="/workflow/workflow/CustomOperation.jsp?otype=<%=otype%>&operation=customdeletes&typeids="+typeids;
					}, function () {}, 320, 90,true);
	}

	function onDel(id){
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
				window.location="/workflow/workflow/CustomOperation.jsp?otype=<%=otype%>&operation=customdelete&id="+id;
		}, function () {}, 320, 90,true);		
	}

	function mnToggleleft(){
		var f = window.parent.oTd1.style.display;

		if (f != null) {
			if (f=='')
				{window.parent.oTd1.style.display='none';}
			else
				{ window.parent.oTd1.style.display='';}
		}
	}	

	function mnToggleleft(){
		var f = window.parent.oTd1.style.display;

		if (f != null) {
			if (f=='')
				{window.parent.oTd1.style.display='none';}
			else
				{ window.parent.oTd1.style.display='';}
		}
	}


	function onBtnSearchClick(){
		var typename=$("input[name='flowTitle']",parent.document).val();
		 try{
		typename = encodeURI(typename);
	}catch(e){
		if(window.console)console.log(e)
	 }
		$("input[name='shortName']").val(typename);
		window.location="/workflow/workflow/CustomQuerySet.jsp?otype=<%=otype%>&shortName="+typename+"&subcompanyid=<%=subcompanyid%>";
	}	

	function onReset() {
		jQuery('input[name="flowTitle"]', parent.document).val('');
		jQuery('input[name="shortName"]').val('');
	}
</script>
</HTML>
