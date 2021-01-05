<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.proj.util.PropUtil"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
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
	parentWin = parent.getParentWindow(window);
}


if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#topTitle").topMenuTitle();
	jQuery("#hoverBtnSpan").hoverBtn();
});
</script>
</head>

<%

String parentid = Util.fromScreen(request.getParameter("ProjID"),user.getLanguage());
String assortname = "";
String nameQuery=Util.null2String(request.getParameter("flowTitle"));

/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

//4E8 项目权限等级(默认共享的值设置:项目成员0.5,项目经理2.5,项目经理上级3,项目管理员4;手动共享值设置:查看1,编辑2)
double ptype=Util.getDoubleValue( CommonShareManager.getPrjPermissionType(""+parentid, user),0 );
if(ptype==2.5||ptype==2){
	canview=true;
	canedit=true;
	ismanager=true;
}else if (ptype==3){
	canview=true;
	canedit=true;
	ismanagers=true;
}else if (ptype==4){
	canview=true;
	canedit=true;
	isrole=true;
}else if (ptype==0.5){
	canview=true;
	ismember=true;
}else if (ptype==1){
	canview=true;
	isshare=true;
}

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>


<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename ="";
String needfav ="1";
String needhelp ="";
String pageId=Util.null2String(PropUtil.getPageId("prj_prjsharedsp"));
%>
<BODY>
<%
if("1".equals( isDialog)){
	%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("2112",user.getLanguage()) %>'/>
</jsp:include>
	<%
}
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

if(canedit){
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("611",user.getLanguage())+",javascript:onShare("+parentid+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("32136",user.getLanguage())+",javascript:batchDel(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}


%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=form2 name=form2 action="/proj/data/PrjShareDsp.jsp" >
<input type="hidden" name="capitalid" value="<%=parentid %>">

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

String sqlWhere = " where relateditemid="+parentid;

if(!"".equals(nameQuery)){
	//sqlWhere+=" and assortmentname like '%"+nameQuery+"%'";
}


String orderby =" id ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,relateditemid,sharetype,seclevel,seclevelmax,rolelevel,sharelevel,userid,departmentid,roleid,foralluser,crmid,isdefault ";
String fromSql  = " Prj_ShareInfo ";

tableString =   " <table  pageId=\""+pageId+"\"  instanceid=\"CptCapitalAssortmentTable\" tabletype=\"checkbox\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"prj")+"\"  >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.cpt.util.CapitalTransUtil.getCanDelCptAssortmentShare' />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"DESC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelNames("21956",user.getLanguage())+"\" column=\"sharetype\" orderkey=\"sharetype\" otherpara=\""+"{'languageid':"+user.getLanguage()+"}"+"\" transmethod='weaver.cpt.util.CommonTransUtil.getShareTypeName'  />"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelNames("106",user.getLanguage())+"\" column=\"id\" orderkey=\"id\" otherpara=\""+"{'languageid':"+user.getLanguage()+",'sharetablename':'Prj_ShareInfo'}"+"\" transmethod='weaver.cpt.util.CommonTransUtil.getShareObjectName' />"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelNames("683",user.getLanguage())+"\" column=\"seclevel\" orderkey=\"seclevel\" otherpara=\"column:seclevelmax+column:sharetype\" transmethod='weaver.cpt.util.CommonTransUtil.getSeclevel' />"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelNames("385",user.getLanguage())+"\" column=\"sharelevel\" orderkey=\"sharelevel\" otherpara=\""+"{'languageid':"+user.getLanguage()+"}"+"\" transmethod='weaver.cpt.util.CommonTransUtil.getShareLevelName' />"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelNames("18495",user.getLanguage())+"\" column=\"isdefault\" orderkey=\"isdefault\" otherpara=\""+"{'languageid':"+user.getLanguage()+"}"+"\" transmethod='weaver.cpt.util.CommonTransUtil.getIsDefaultShareName' />"+
                "       </head>";
                if(canedit){
	                tableString+="     <popedom column=\"id\"  ></popedom> "+
	                "		<operates>"+
						"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelNames("91",user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
					"		</operates>";
                }
				
                tableString+= " </table>";
%>

<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />
<%if("1".equals(isDialog)){ %>
<div style="height: 20px;"></div>
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
<script type="text/javascript">


function onShare(id){
	if(id){
		var url="/proj/data/PrjShareAdd.jsp?isdialog=1&taskrecordid="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83816",user.getLanguage())%>";
		openDialog(url,title,500,290);
	}
}
function onDel(id){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83600",user.getLanguage())%>',function(){
			jQuery.post(
				"/proj/data/PrjShareOperation.jsp",
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
			"/proj/data/PrjShareOperation.jsp",
			{"method":"batchdelete","id":typeids,"capitalid":'<%=parentid %>'},
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
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</BODY>
</HTML>
