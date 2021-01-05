<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

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
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
}


if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>

<%

String parentid = Util.fromScreen(request.getParameter("paraid"),user.getLanguage());
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
boolean canedit = HrmUserVarify.checkUserRight("EditProjectType:Edit",user);


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

    if(canedit){
        RCMenu += "{"+SystemEnv.getHtmlLabelNames("611",user.getLanguage())+",javascript:onShare("+parentid+"),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;


        RCMenu += "{"+SystemEnv.getHtmlLabelNames("32136",user.getLanguage())+",javascript:batchDel(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }


%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=form2 name=form2 action="/proj/Maint/PrjTypeShareDsp.jsp" >
<input type="hidden" name="assortid" value="<%=parentid %>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
<% 
if(canedit){
	%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("611",user.getLanguage())%>" class="e8_btn_top" onclick="onShare(<%=parentid %>);"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("32136",user.getLanguage())%>" class="e8_btn_top" onclick="batchDel()"/>
	
	<%
}

%>		
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;">
</div>	

<%

String sqlWhere = " where relateditemid="+parentid;

if(!"".equals(nameQuery)){
	//sqlWhere+=" and sharetype like '%"+nameQuery+"%'";
}


String orderby =" id ";
String tableString = "";
int perpage=6;                                 
String backfields = " id,relateditemid,sharetype,seclevel,seclevelmax,rolelevel,sharelevel,userid,departmentid,roleid,foralluser,crmid,subcompanyid ";
String fromSql  = " Prj_T_ShareInfo ";

tableString =   " <table instanceid=\"CptCapitalAssortmentTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.proj.util.ProjectTransUtil.getCanDelPrjTypeShare' />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"DESC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("21956",user.getLanguage())+"\" column=\"sharetype\" orderkey=\"sharetype\" otherpara=\""+"{'languageid':"+user.getLanguage()+"}"+"\" transmethod='weaver.proj.util.ProjectTransUtil.getShareTypeName'  />"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("106",user.getLanguage())+"\" column=\"id\" orderkey=\"id\" otherpara=\""+"{'languageid':"+user.getLanguage()+",'sharetablename':'Prj_T_ShareInfo'}"+"\" transmethod='weaver.cpt.util.CommonTransUtil.getShareObjectName' />"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("683",user.getLanguage())+"\" column=\"seclevel\" orderkey=\"seclevel\" otherpara=\"column:seclevelmax+column:sharetype\" transmethod='weaver.cpt.util.CommonTransUtil.getSeclevel' />"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("385",user.getLanguage())+"\" column=\"sharelevel\" orderkey=\"sharelevel\" otherpara=\""+"{'languageid':"+user.getLanguage()+"}"+"\" transmethod='weaver.proj.util.ProjectTransUtil.getShareLevelName' />"+
                "       </head>"+
                "     <popedom column=\"id\"  ></popedom> "+
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
		var url="/proj/Maint/PrjTypeAddShare.jsp?isdialog=1&assortmentid="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83849",user.getLanguage())%>";
		openDialog(url,title,500,290);
	}
}
function onDel(id){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83600",user.getLanguage())%>',function(){
			jQuery.post(
				"/proj/data/TypeShareOperation.jsp",
				{"method":"delete","id":id},
				function(data){
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
		jQuery.post(
			"/proj/data/TypeShareOperation.jsp",
			{"method":"batchdelete","id":typeids},
			function(data){
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
</script>

<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>	
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
});
</script>
<%} %>
</BODY>
</HTML>
