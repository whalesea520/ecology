<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.proj.util.PropUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>

<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/common_wev8.js"></script>
</head>

<%

String parentid = Util.fromScreen(request.getParameter("paraid"),user.getLanguage());
String assortname = Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(parentid),user.getLanguage());
String remindsubmit = Util.fromScreen(request.getParameter("remindsubmit"),user.getLanguage());
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
boolean canedit = true;


%>


<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename ="";
String needfav ="1";
String needhelp ="";

%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<% 

RCMenu += "{"+SystemEnv.getHtmlLabelNames("611",user.getLanguage())+",javascript:onShare("+parentid+"),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelNames("32136",user.getLanguage())+",javascript:batchDel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

/**
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
**/
String pageId=Util.null2String(PropUtil.getPageId("cpt_cptassortmentsharedsp"));
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=form2 name=form2 action="" >
<input type="hidden" name="paraid" value="<%=parentid %>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("611",user.getLanguage())%>" class="e8_btn_top" onclick="onShare(<%=parentid %>);"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("32136",user.getLanguage())%>" class="e8_btn_top" onclick="batchDel()"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;">
	<table class="viewForm">
      <TR>
    	  <td></td>
    	  <td class=Field><select class=inputstyle  name=typeid onChange="wfSearch()" >
    	  	<option value="0">&nbsp;</option>
    	  </select></td>
          <td></td>
          <td class=Field><input type="text" class=inputstyle name="wfnameQuery" size="30" value=""></td>  	  
    	  </TR>
    	<tr>
	    <td  colspan="4" class="btnTd">
			<input type="submit" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>" class="e8_btn_submit"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</td> 
		</tr>
	</table>
</div>	

<%

String sqlWhere = " where assortmentid="+parentid;

if(!"".equals(nameQuery)){
	sqlWhere+=" and assortmentname like '%"+nameQuery+"%'";
}


String orderby =" id ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,assortmentid,sharetype,seclevel,rolelevel,sharelevel,userid,departmentid,roleid,foralluser,crmid,seclevelmax ";
String fromSql  = " CptAssortmentShare ";

tableString =   " <table  pageId=\""+pageId+"\"  instanceid=\"CptCapitalAssortmentTable\" tabletype=\"checkbox\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"cpt")+"\"  >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.cpt.util.CapitalTransUtil.getCanDelCptAssortmentShare' />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"DESC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("21956",user.getLanguage())+"\" column=\"sharetype\" orderkey=\"sharetype\" otherpara=\""+"{'languageid':"+user.getLanguage()+"}"+"\" transmethod='weaver.cpt.util.CapitalTransUtil.getShareTypeName'  />"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("106",user.getLanguage())+"\" column=\"id\" orderkey=\"id\" otherpara=\""+"{'languageid':"+user.getLanguage()+",'sharetablename':'CptAssortmentShare'}"+"\" transmethod='weaver.cpt.util.CommonTransUtil.getShareObjectName' />"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("683",user.getLanguage())+"\" column=\"seclevel\" orderkey=\"seclevel\" otherpara=\"column:seclevelmax+column:sharetype\" transmethod='weaver.cpt.util.CommonTransUtil.getSeclevel' />"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("3005",user.getLanguage())+"\" column=\"sharelevel\" orderkey=\"sharelevel\" otherpara=\""+"{'languageid':"+user.getLanguage()+"}"+"\" transmethod='weaver.cpt.util.CapitalTransUtil.getShareLevelName' />"+
                "       </head>"+
                "     <popedom column=\"id\" ></popedom> "+
                "		<operates>"+
					"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelNames("91",user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		</operates>"+                  
                " </table>";
%>

<!-- listinfo -->
<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />
<script type="text/javascript">


function onShare(id){
	if(id){
		var url="/cpt/maintenance/CptAssortmentAddShare.jsp?isdialog=1&assortmentid="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83671",user.getLanguage())%>";
		openDialog(url,title,500,290);
	}
}
function onDel(id,assortmentid){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83672",user.getLanguage())%>',function(){
			//提示
			var diag_tooltip = new window.top.Dialog();
			diag_tooltip.ShowCloseButton=false;
			diag_tooltip.ShowMessageRow=false;
			//diag_tooltip.hideDraghandle = true;
			diag_tooltip.Width = 300;
			diag_tooltip.Height = 50;
			diag_tooltip.InnerHtml="<div style=\"font-size:12px;\" ><%=SystemEnv.getHtmlLabelName(20204,user.getLanguage()) %><br><img style='margin-top:-20px;' src='/images/ecology8/loadingSearch_wev8.gif' /></div>";
			diag_tooltip.show();
			
			jQuery.post(
				"/cpt/maintenance/AssortShareOperation.jsp",
				{"method":"delete","id":id,"assortid":'<%=parentid %>'},
				function(data){
					diag_tooltip.close();
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
						_table.reLoad();
					});
				}
			);
			
		});
	}
}

function batchDel(){
	var typeids = _xtable_CheckedCheckboxId();
	if(typeids=="") return ;
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83601",user.getLanguage())%>',function(){
		//提示
		var diag_tooltip = new window.top.Dialog();
		diag_tooltip.ShowCloseButton=false;
		diag_tooltip.ShowMessageRow=false;
		//diag_tooltip.hideDraghandle = true;
		diag_tooltip.Width = 300;
		diag_tooltip.Height = 50;
		diag_tooltip.InnerHtml="<div style=\"font-size:12px;\" ><%=SystemEnv.getHtmlLabelName(20204,user.getLanguage()) %><br><img style='margin-top:-20px;' src='/images/ecology8/loadingSearch_wev8.gif' /></div>";
		diag_tooltip.show();
		jQuery.post(
			"/cpt/maintenance/AssortShareOperation.jsp",
			{"method":"batchdelete","id":typeids,"assortid":'<%=parentid %>'},
			function(data){
				diag_tooltip.close();
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
					_table.reLoad();
				});
			}
		);
		
	});
}

</script>


<script language="javascript">
function onShowDepartment(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+jQuery("input[name="+inputename+"]").val());
	if (data!=null){
	    if (data.id != "" && data.id != "0"){
			jQuery("#"+tdname).html(data.name);
			jQuery("input[name="+inputename+"]").val(data.id);
		}else{
			jQuery("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name="+inputename+"]").val("");
		}
	}
}

function onShowResource(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (data!=null){
	    if (data.id != "" && data.id != "0"){
			jQuery("#"+tdname).html(data.name);
			jQuery("input[name="+inputename+"]").val(data.id);
		}else{
			jQuery("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name="+inputename+"]").val("");
		}
	}
}

function onShowRole(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if (data!=null){
	    if (data.id != "" && data.id != "0"){
			jQuery("#"+tdname).html(data.name);
			jQuery("input[name="+inputename+"]").val(data.id);
		}else{
			jQuery("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name="+inputename+"]").val("");
		}
	}
}

 function onSubmit()
{
	//add TD30059 当为部门选项时，用户没有所属部门为0，设置为空，阻止submit提交
	if(document.all("relatedshareid").value=="0"&&document.all("sharetype").value=="2"){
		document.all("relatedshareid").value="";
	}
	//End TD30059 
	if (check_form(weaver,"itemtype,relatedshareid,sharetype,rolelevel,seclevel,sharelevel"))
	weaver.submit();
}

 function back()
{
	window.history.back(-1);
}
 
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});
function onBtnSearchClick(){
	form2.submit();
}
</script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</BODY>
</HTML>
