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
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
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

String capitalid = Util.fromScreen(request.getParameter("capitalid"),user.getLanguage());
String assortname = Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(capitalid),user.getLanguage());
String nameQuery=Util.null2String(request.getParameter("flowTitle"));

boolean displayAll	=	false;
boolean canedit     =   false;
boolean canview    =   false;
boolean canviewlog	 = false;

/*可否编辑*/
//if(HrmUserVarify.checkUserRight("CptCapitalEdit:Edit",user))  {
	//canedit		=	true;
//}


/*共享权限判断*/
/*共享权限判断*/
RecordSetShare.executeSql(CommonShareManager.getSharLevel("cpt", capitalid, user) );

if( RecordSetShare.next() ) {
	int sharelevel = Util.getIntValue(RecordSetShare.getString(1), 0) ;
	if( sharelevel == 2 ) {
		canedit     =   true;
		canviewlog	 = true;
	}
	canview    =   true ;
}

/**
RecordSetShare.executeProc("CptCapitalShareInfo_SbyRelated",capitalid);
while(RecordSetShare.next()){
	if(RecordSetShare.getInt("sharetype")==1){
	  if(RecordSetShare.getInt("userid")==user.getUID()){
		    canview=true;
		if(RecordSetShare.getInt("sharelevel")==2){
			canedit=true;
			canviewlog=true;
		}
	  }
	}else if(RecordSetShare.getInt("sharetype")==2){
	  if(RecordSetShare.getInt("departmentid")==user.getUserDepartment()){
		  if(RecordSetShare.getInt("seclevel")<=Util.getIntValue(user.getSeclevel())){
			canview=true;
			if(RecordSetShare.getInt("sharelevel")==2){
				canedit=true;
				canviewlog=true;
			}
		  }
	  }
	}else if(RecordSetShare.getInt("sharetype")==3){
		if(CheckUserRight.checkUserRight(""+user.getUID(),RecordSetShare.getString("roleid"),RecordSetShare.getString("rolelevel"))){
			if((RecordSetShare.getString("rolelevel").equals("0") && user.getUserDepartment()==RecordSet.getInt("department")) || (RecordSetShare.getString("rolelevel").equals("1") && user.getUserSubCompany1()==RecordSet.getInt("subcompanyid1")) || (RecordSetShare.getString("rolelevel").equals("2")) ){
				  if(RecordSetShare.getInt("seclevel")<=Util.getIntValue(user.getSeclevel())){
					canview=true;
					if(RecordSetShare.getInt("sharelevel")==2){
						canedit=true;
						canviewlog=true;
					}
				  }
			}
	   }
	}else if(RecordSetShare.getInt("sharetype")==4){
		if(RecordSetShare.getInt("seclevel")<=Util.getIntValue(user.getSeclevel())){
			canview=true;
			if(RecordSetShare.getInt("sharelevel")==2){
				canedit=true;
				canviewlog=true;
			}
		}
	}
}
**/
String pageId=Util.null2String(PropUtil.getPageId("cpt_cptcapitalsharedsp"));
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
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("611",user.getLanguage())+",javascript:onShare("+capitalid+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("32136",user.getLanguage())+",javascript:batchDel(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=form2 name=form2 action="/cpt/maintenance/CptCapitalShareDsp.jsp" >
<input type="hidden" name="capitalid" value="<%=capitalid %>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
<%
if(canedit){
	%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("611",user.getLanguage())%>" class="e8_btn_top" onclick="onShare(<%=capitalid %>);"/>
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

String sqlWhere = " where relateditemid="+capitalid;

if(!"".equals(nameQuery)){
	//sqlWhere+=" and assortmentname like '%"+nameQuery+"%'";
}


String orderby =" id ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,relateditemid,sharetype,seclevel,rolelevel,sharelevel,userid,departmentid,roleid,foralluser,crmid,isdefault,seclevelmax ";
String fromSql  = " CptCapitalShareInfo ";

tableString =   " <table pageId=\""+pageId+"\"  instanceid=\"CptCapitalAssortmentTable\" tabletype=\"checkbox\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"cpt")+"\"  >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.cpt.util.CapitalTransUtil.getCanDelCptAssortmentShare' />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"DESC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelNames("21956",user.getLanguage())+"\" column=\"sharetype\" orderkey=\"sharetype\" otherpara=\""+"{'languageid':"+user.getLanguage()+"}"+"\" transmethod='weaver.cpt.util.CapitalTransUtil.getShareTypeName'  />"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelNames("106",user.getLanguage())+"\" column=\"id\" orderkey=\"id\" otherpara=\""+"{'languageid':"+user.getLanguage()+",'sharetablename':'CptCapitalShareInfo'}"+"\" transmethod='weaver.cpt.util.CommonTransUtil.getShareObjectName' />"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelNames("683",user.getLanguage())+"\" column=\"seclevel\" orderkey=\"seclevel\" otherpara=\"column:seclevelmax+column:sharetype\" transmethod='weaver.cpt.util.CommonTransUtil.getSeclevel' />"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelNames("3005",user.getLanguage())+"\" column=\"sharelevel\" orderkey=\"sharelevel\" otherpara=\""+"{'languageid':"+user.getLanguage()+"}"+"\" transmethod='weaver.cpt.util.CapitalTransUtil.getShareLevelName' />"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelNames("18495",user.getLanguage())+"\" column=\"isdefault\" orderkey=\"isdefault\" otherpara=\""+"{'languageid':"+user.getLanguage()+"}"+"\" transmethod='weaver.cpt.util.CommonTransUtil.getIsDefaultShareName' />"+
                "       </head>";
                if(canedit){
                	tableString+="     <popedom column=\"id\"  ></popedom> "+
                            "		<operates>"+
            					"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelNames("91",user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
            				"		</operates>";
                }
                                
                tableString+=" </table>";
%>

<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />
<script type="text/javascript">


function onShare(id){
	if(id){
		var url="/cpt/capital/CptCapitalAddShare.jsp?isdialog=1&capitalid="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83614",user.getLanguage())%>";
		openDialog(url,title,500,290);
	}
}
function onDel(id){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83616",user.getLanguage())%>',function(){
			jQuery.post(
				"/cpt/capital/ShareOperation.jsp",
				{"method":"delete","id":id,"capitalid":"<%=capitalid %>"},
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
			"/cpt/capital/ShareOperation.jsp",
			{"method":"batchdelete","id":typeids,"capitalid":"<%=capitalid %>"},
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
 
function onBtnSearchClick(){
	form2.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});
</script>
</BODY>
</HTML>
