
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
  <head>
    
    

	
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
  </head>
  <%
  String titlename="";
  String ebaseid = Util.null2String(request.getParameter("ebaseid"));
  String isDialog = Util.null2String(request.getParameter("isDialog"));
  String loginview = Util.null2String(request.getParameter("loginview"));
  String hpname = Util.null2String(request.getParameter("flowTitle"));
  String sqlWhere = " where hi.id=hl.hpid and hi.id=he.hpid and he.isuse=1 and ebaseid='"+ebaseid+"'";
  if("1".equals(loginview)||"".equals(loginview)) sqlWhere+=" and subcompanyid= -1 ";
  else  sqlWhere+=" and subcompanyid>0 ";//登陆后页面
  if("oracle".equals( rs.getDBType())){
	  sqlWhere+=" and instr( hl.areaelements, he.id)>0 ";
  }else if("sqlserver".equals( rs.getDBType())){
	  sqlWhere+="  and  charindex(cast(he.id as varchar)+',',hl.areaelements)>0 ";
  }
  
  if(!"".equals(hpname))sqlWhere += " and infoname like '%"+hpname+"%'";
  %>
  <body style="overflow: hidden;">
     <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<form id="ReferencesFrom" name="ReferencesFrom" method="post" action="PortalReferencesInfo.jsp">
    <table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
    <input type="hidden" name="ebaseid" value="<%=ebaseid %>"/>
    <input type="hidden" name="loginview" value="<%=loginview %>"/>
		<tr>
			<td width="160px">					
			</td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type=button class="e8_btn_top" onclick="onDelAll();" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>"/>
				<input type="text" class="searchInput" name="flowTitle"/>
				&nbsp;&nbsp;&nbsp;
				<input type="hidden" value="<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>" class="advancedSearch" onclick="jQuery('#advancedSearchDiv').toggle('fast');return false;"/>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<div class="advancedSearchDiv" id="advancedSearchDiv">
	</div>
</form>
	<%
	//得到pageNum 与 perpage
	int perpage =10;
	//设置好搜索条件15528
	String tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\" valign=\"top\">"
	  + "<sql backfields=\" hi.id,infoname,infodesc,hplastdate \" sqlform=\" from hpinfo hi,hpLayout hl,hpElement he \" sqlorderby=\"\"  sqlprimarykey=\"hi.id\" sqlsortway=\"\" sqlwhere=\""+sqlWhere+"\" sqlisdistinct=\"true\" />"+
		"<head >"+
			"<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(15528,user.getLanguage())+"\"   column=\"infoname\"/>"+
			"<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(33461,user.getLanguage())+"\"   column=\"infodesc\"/>"+
			"<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(19521,user.getLanguage())+"\"   column=\"hplastdate\"/>"+
		"</head>"
			 + "<operates><popedom transmethod=\"weaver.splitepage.transform.SptmForPortalElements.getOperateReferences\"></popedom> "
			 + "<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(33462,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"
		+"</operates></table>";
	%>
<TABLE width="100%" class="LayoutTable">
	<TR>
		<TD valign="top">
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"   />
		</TD>
	</TR>
</TABLE>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
		</wea:item>
	</wea:group>
	</wea:layout>
</div>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	if(!"1".equals(isDialog)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location.href='/admincenter/portalEngine/PortalElements.jsp',_self} " ;
		RCMenuHeight += RCMenuHeightStep ;	
	}
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:onDelAll(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %> 					   
  </body>
</html>
<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:onSearch});	
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
	});
	
	function onSearch(){
		ReferencesFrom.submit();
	}
	
	function onDelAll(){
		var hpids = "";
		jQuery("input[name='chkInTableTag']").each(function(){
			if(jQuery(this).attr("checked")){	
				hpids = hpids +jQuery(this).attr("checkboxid")+",";
			}
		});
		if(hpids!="")
			onDel(hpids);
	}
	
	function onDel(hpid){
		var str = "<%=SystemEnv.getHtmlLabelName(22161,user.getLanguage())+SystemEnv.getHtmlLabelName(127957,user.getLanguage())%>";
		top.Dialog.confirm(str,function(){
			jQuery.post("/admincenter/portalEngine/PortalElementoperation.jsp?operate=delReferences&module=Portal&ebaseid=<%=ebaseid%>&hpid="+hpid,
			function(data){if(data.indexOf("OK")!=-1) location.reload();});
		});
	}
	
	function onCancel(){
		var dialog = parent.parentDialog;   //弹出窗口的引用，用于关闭页面
		dialog.close();
	}
	
</script>
