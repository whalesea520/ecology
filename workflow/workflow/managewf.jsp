<!DOCTYPE html>
<%@ page import="weaver.workflow.workflow.WfRightManager"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="WFInfo" class="weaver.workflow.workflow.WFManager" scope="page" />
<jsp:useBean id="WFMainManager" class="weaver.workflow.workflow.WFMainManager" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<%
	int typeid=Util.getIntValue(request.getParameter("typeid"),0);
	WfRightManager wfrm = new WfRightManager();
	boolean hasPermission = wfrm.hasPermission2(0, user, WfRightManager.OPERATION_CREATEDIR);
	//if(typeid == 0){
	//	hasPermission = wfrm.hasPermission2(0, user, WfRightManager.OPERATION_CREATEDIR);
	//}else{
	//	hasPermission = wfrm.hasPermission(typeid,0, user, WfRightManager.OPERATION_CREATEDIR);
	//}
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !hasPermission){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));
	if ("".equals(isWorkflowDoc)) {
	    isWorkflowDoc = "0";
	}

	WFMainManager.resetParameter();
	String isTemplate=Util.getIntValue(Util.null2String(request.getParameter("isTemplate")),0)+"";
	String tabletitlename=SystemEnv.getHtmlLabelName(18499,user.getLanguage()) + SystemEnv.getHtmlLabelName(33439,user.getLanguage());
	String memotitle=SystemEnv.getHtmlLabelName(18499,user.getLanguage()) + SystemEnv.getHtmlLabelName(433,user.getLanguage());
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= Util.getIntValue(Util.null2String(session.getAttribute("queryParam_subcompanyId")),-1);
    int operatelevel=0;
    String hasRightSub = "";
    
    if (detachable == 1) {
        //查询只读以上权限分部ID字符串
        hasRightSub=SubCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowManage:All",-1);    
        if(subCompanyId == -1){
            if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
                operatelevel= 2;    
            }
        }else{
            operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
        }
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user))
            operatelevel=2;
    }
    session.setAttribute("managefield_subCompanyId2",String.valueOf(subCompanyId));
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
    if(isTemplate.equals("1")){
        titlename=SystemEnv.getHtmlLabelName(18334,user.getLanguage());
        tabletitlename=SystemEnv.getHtmlLabelName(18151,user.getLanguage());
        memotitle=SystemEnv.getHtmlLabelName(433,user.getLanguage());
    }
%>
<jsp:setProperty name="WFMainManager" property = "*"/>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();		
});
function mnToggleleft(){
	var f = window.parent.oTd1.style.display;
	if (f != null) {
		if(f==''){
			window.parent.oTd1.style.display='none';
			<%if(detachable==1){%>
			window.parent.parent.oTd1.style.display='none';
			<%}%>
		}else{ 
			window.parent.oTd1.style.display='';
			<%if(detachable==1){%>
			window.parent.parent.oTd1.style.display='';
			<%}%>
		}
	}
}
function CheckAll(checked) {
len = document.form2.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.form2.elements[i].name=='delete_wf_id') {
    if(document.form2.elements[i].disabled == false){
    document.form2.elements[i].checked=(checked==true?true:false);
    }
} } }


function unselectall(){
    if(document.form2.checkall0.checked){
	document.form2.checkall0.checked =0;
    }
}
function confirmdel() {
	len = document.form2.elements.length;
	var i=0;
	var hasitem = 0;
	for( i=0; i<len; i++) {
		if (document.form2.elements[i].name=='delete_wf_id') {
			if(document.form2.elements[i].checked==true)
				hasitem = 1;
		}
	}
	if(hasitem == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>!");
		return false;
	}
	return confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>？") ;
}

function OpenNewWindow(sURL,w,h){
  var iWidth = 0 ;
  var iHeight = 0 ;
  iWidth=(window.screen.availWidth-10)*w;
  iHeight=(window.screen.availHeight-50)*h;
  ileft=(window.screen.availWidth - iWidth)/2;
  itop= (window.screen.availHeight - iHeight + 50)/2;
  var szFeatures = "" ;
  szFeatures =	"resizable=no,status=no,menubar=no,width=" +
				iWidth + ",height=" + iHeight*h + ",top="+itop+",left="+ileft
  window.open(sURL,"",szFeatures)
}

</script>
</head>
<body style="overflow-y:auto;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	String wfid=""+Util.getIntValue(request.getParameter("wfid"),0);
	String formid=""+Util.getIntValue(request.getParameter("formid"),0);
	String wfname=Util.null2String(request.getParameter("wfname"));
	String wfdes=Util.null2String(request.getParameter("wfdes"));
	String wfnameQuery=Util.null2String(request.getParameter("wfnameQuery"));
	String isclose=""+Util.getIntValue(request.getParameter("isclose"),0);
    String templatestr="";
    if(isTemplate.equals("1")){
       templatestr=" and isTemplate=1";
    }else{
       templatestr=" and (isTemplate is null or isTemplate <> 1)";
    }
    session.setAttribute("treeleft"+isTemplate,typeid+"");
    Cookie ck = new Cookie("treeleft"+isTemplate+user.getUID(),typeid+"");  
    ck.setMaxAge(30*24*60*60);
    //added by cyril on 2008-08-20 for td:9215
    session.setAttribute("treeleft_cnodeid"+isTemplate,wfid+"");
    ck = new Cookie("treeleft_cnodeid"+isTemplate+user.getUID(),wfid+"");  
    ck.setMaxAge(30*24*60*60);
    response.addCookie(ck);
  	//end by cyril on 2008-08-20 for td:9215
%>
 <form name="form2" method="post"  action="managewf.jsp">
<%
if(!isWorkflowDoc.equals("1")){
	if(operatelevel>0){
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addwf(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	}
	if(operatelevel>1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitData(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	}
	
	if(operatelevel>0){
	/*
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClick(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	*/
	//add by xhheng @ 2004/12/08 for TDID 1317
	if(RecordSet.getDBType().equals("db2")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:wflogdb2() ,_self} " ;
	}else{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:wflog() ,_self} " ;
	}
	RCMenuHeight += RCMenuHeightStep ;
	}
}else{
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addOfficalWf(),_self}" ;
	//RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20230,user.getLanguage())+",javascript:detachOfficalWf(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
} %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">			
			<%if(!isWorkflowDoc.equals("1")){ %>
				<%if(operatelevel>0){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())%>" class="e8_btn_top" onclick="parent.location='addwf.jsp?isTemplate=<%=isTemplate %>&typeid=<%=typeid%>'"/>
				<%} %>
				<%if(operatelevel>1){ %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
				<%} %>
			<%}else{%>
				<!--
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" class="e8_btn_top" onclick="newOfficalWf();"/>
				-->
				<input type="button" value="<%=SystemEnv.getHtmlLabelNames("611,33684",user.getLanguage())%>" class="e8_btn_top" onclick="addOfficalWf();"/>	
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(20230,user.getLanguage())%>" class="e8_btn_top" onclick="detachOfficalWf();"/>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" value="<%=wfnameQuery%>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
	
		<!-- bpf start 2013-10-29 -->
		<div class="advancedSearchDiv" id="advancedSearchDiv">
		<wea:layout type="fourCol">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(33806,user.getLanguage())%></wea:item>
			    <wea:item>
		    	    <span>
			    	 	<brow:browser viewType="0" name="typeid"
									browserValue='<%=typeid+"" %>'
									browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
									_callback="" width="250px"
									hasInput="false" isSingle="true" hasBrowser="true"
									isMustInput="1" completeUrl="/data.jsp"
									browserDialogWidth="600px"
									browserSpanValue='<%=WorkTypeComInfo.getWorkTypename(typeid+"")%>'>
						</brow:browser>
		    		</span> 
			    </wea:item>
		    	<wea:item><%=tabletitlename%></wea:item>
		    	<wea:item><input type=text name=wfnameQuery class=Inputstyle size="30" value='<%=wfnameQuery%>'></wea:item>
		    </wea:group>
		    <wea:group context="">
		    	<wea:item type="toolbar">
		    		<input class="e8_btn_submit" type="submit" name="search" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>"/>
		    		<input class="e8_btn_cancel" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage()) %>"/>
					<input class="e8_btn_cancel" type="button" id="cancel" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>"/>
		    	</wea:item>
		    </wea:group>
		</wea:layout>
</div>		
<%
	StringBuffer whereBuffer = new StringBuffer();
	whereBuffer.append("where (isvalid<>3 or isvalid is null)");
	if(isTemplate.equals("1")){
	    whereBuffer.append(" and istemplate='1'"); 
	}else{
	    whereBuffer.append(" and (istemplate is null or istemplate<>'1') ");
	}
	if (!"".equals(Util.fromScreen(wfnameQuery.trim(),user.getLanguage()))) {
	    whereBuffer.append(" and workflowname like '%" + Util.fromScreen(wfnameQuery.trim(),user.getLanguage()) + "%'");
	}else{
	    whereBuffer.append(" and workflowname like '%" + wfnameQuery + "%' ");
	}
	if(isWorkflowDoc.equals("1")){
	    whereBuffer.append(" and isWorkflowDoc = 1");
	}
	if(typeid != 0){
	    whereBuffer.append(" and workflowtype = "+typeid);
	}
	
	String wftypeids = "";
	if(hasPermission && -1 == subCompanyId){
	    wftypeids = wfrm.getAllWfTypeIds(user.getUID());    
	}
	//当开启分权时
	if(detachable == 1){
		if(!"".equals(wftypeids) && !"".equals(hasRightSub)){
		    if(isTemplate.equals("1")){
		        whereBuffer.append(" and ( templateid in ("+wftypeids+") or subcompanyid in ("+hasRightSub+"))");
		    }else{
		        whereBuffer.append(" and ( id in ("+wftypeids+") or subcompanyid in ("+hasRightSub+"))");
		    }
		   
		}else if(!"".equals(wftypeids)){
		    if(isTemplate.equals("1")){
		        whereBuffer.append(" and templateid in ("+wftypeids+")");
		    }else{
		        whereBuffer.append(" and id in ("+wftypeids+")");
		    }
		    //当该用户未选择机构时
		}else if(!"".equals(hasRightSub)){
		    //whereBuffer.append(" and subcompanyid in ("+hasRightSub+")");
			String[] strArry = hasRightSub.split(",");
			StringBuffer sqlAppendIn = new StringBuffer("");
		if (strArry != null) {
			sqlAppendIn.append(" (subcompanyid").append (" in ( ");
			for (int y = 0; y < strArry.length; y++) {
				sqlAppendIn.append("'").append(strArry[y] + "',");
				if ((y + 1) % 1000 == 0 && (y + 1) < strArry.length) {
					sqlAppendIn.deleteCharAt(sqlAppendIn.length() - 1);
					sqlAppendIn.append(" ) or ").append("subcompanyid").append (" IN (");
				}
			}
			sqlAppendIn.deleteCharAt(sqlAppendIn.length() - 1);
			sqlAppendIn.append(" ))");
		}
		    String sqlAppend = sqlAppendIn.toString();
		    whereBuffer.append(" and "+sqlAppend);
		}
	    if(subCompanyId != -1){
	        whereBuffer.append(" and subcompanyid  = " + subCompanyId);
	    }
	}else{
	    //当未开启分权,有指定路径维护的流程也可以维护
	    if(!"".equals(wftypeids) && !HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	        if(isTemplate.equals("1")){
	            whereBuffer.append(" and templateid in ("+wftypeids+")");
	        }else{
	            whereBuffer.append(" and id in ("+wftypeids+")");    
	        }
	        
	    }
	}
String sqlWhere = whereBuffer.toString();
String orderby =" dsporder asc, workflowname ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,workflowname,workflowdesc,istemplate,workflowtype,dsporder,subcompanyid,isbill,formid,officalType ";
String fromSql  = " workflow_base ";
String colString = "";
	if(isWorkflowDoc.equals("1")){
		colString += "<col width=\"20%\"  text=\""+tabletitlename+"\" column=\"id\" otherpara=\""+isTemplate+"\" orderkey=\"id\" transmethod=\"weaver.workflow.workflow.WFMainManager.getWfNameForWfDoc\"/>";
	}else{
		colString += "<col width=\"20%\"  text=\""+tabletitlename+"\" column=\"id\" otherpara=\""+isTemplate+"\" orderkey=\"id\" transmethod=\"weaver.workflow.workflow.WFMainManager.getWfName\"/>";
	}

		colString += "<col width=\"30%\"  text=\""+memotitle+"\" column=\"workflowdesc\" orderkey=\"workflowdesc\" />";
if(!isWorkflowDoc.equals("1")){
	colString += "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15600,user.getLanguage())+"\" column=\"isbill\" orderkey=\"isbill\" otherpara=\"column:formid+"+user.getLanguage()+"\" transmethod=\"weaver.workflow.workflow.WFMainManager.getFormName\"/>"+
                 "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(33806,user.getLanguage())+"\" column=\"workflowtype\" orderkey=\"workflowtype\" transmethod=\"weaver.workflow.workflow.WFMainManager.getWorkflowTypeName\"/>";

    colString += "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dsporder\" orderkey=\"dsporder\"/>";
}else{
	colString += "<col display=\"false\" width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(15600,user.getLanguage())+"\" column=\"isbill\" orderkey=\"isbill\" otherpara=\"column:formid+"+user.getLanguage()+"\" transmethod=\"weaver.workflow.workflow.WFMainManager.getFormName\"/>"+
                "<col display=\"false\" width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(33806,user.getLanguage())+"\" column=\"workflowtype\" orderkey=\"workflowtype\" transmethod=\"weaver.workflow.workflow.WFMainManager.getWorkflowTypeName\"/>";
    colString += "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(23775,user.getLanguage())+"\" column=\"officalType\" transmethod=\"weaver.workflow.workflow.WFMainManager.getWfOfficalType\" otherpara=\""+user.getLanguage()+"\"/>";
    colString += "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(25005,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.workflow.workflow.WFMainManager.getWfOfficalStatus\" otherpara=\""+user.getLanguage()+"\"/>";

    colString += "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dsporder\" orderkey=\"dsporder\"/>";
}
String operateString = "";
if(!isWorkflowDoc.equals("1")){
	operateString += "	<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"0\"/>"+
				"	<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"	<operate href=\"javascript:onLog();\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" index=\"2\"/>";
}else{
	operateString += "		<operate href=\"javascript:openCreateDocStatus();\" text=\""+SystemEnv.getHtmlLabelName(31676,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:closeCreateDocStatus();\" text=\""+SystemEnv.getHtmlLabelName(18096,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"1\"/>"+
				"		<operate href=\"javascript:editOfficalWf();\" text=\""+SystemEnv.getHtmlLabelName(32485,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"2\"/>"+
				"<operate href=\"javascript:onEditForwfDoc();\" text=\""+SystemEnv.getHtmlLabelName(21954,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"3\"/>"+
				"<operate href=\"javascript:detachOfficalWf();\" text=\""+SystemEnv.getHtmlLabelName(20230,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"4\"/>"+
	"	<operate isalwaysshow=\"true\" href=\"javascript:onOffLog1();\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" index=\"5\"/>";
}
tableString =   " <table pageId=\""+PageIdConst.WF_WORKFLOW_MANAGEWF+"\" instanceid=\"workflowbaseTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_MANAGEWF,user.getUID())+"\" >";
if(!isWorkflowDoc.equals("1")){
tableString+=" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id+"+isTemplate+"+"+isWorkflowDoc+"+" + detachable + "+column:subcompanyid+"+ user.getUID()+ "\" showmethod=\"weaver.workflow.workflow.WFMainManager.getCheckBox\" />";
}
                tableString+="       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
              		colString+
                "       </head>"+
                "		<operates>"+
                "		<popedom column=\"id\" otherpara=\""+isTemplate+"+"+isWorkflowDoc+"+" + detachable + "+column:subcompanyid+"+ user.getUID() + "\" transmethod=\"weaver.workflow.workflow.WFMainManager.getCanDelTypeList\"></popedom> "+
               operateString+
				"		</operates>"+                  
                " </table>";
                
%>
<TABLE width="100%" cellspacing=0>
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>
<%if(!isWorkflowDoc.equals("1")){ %>			
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.WF_WORKFLOW_MANAGEWF %>"/>
<%}else{ %>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.OFFICALWORKFLOWLIST %>"/>
<%} %>

<input type=hidden name=wfid value="<%= wfid %>">
<input type=hidden name=typeid value="<%= typeid %>">
<input type=hidden name=formid value="<%= formid %>">
<input type=hidden name=wfname value="<%= wfname %>">
<input type=hidden name=wfdes value="<%= wfdes %>">
<input type=hidden name=isTemplate value="<%=isTemplate%>">		
<input type=hidden name=isWorkflowDoc value="<%=isWorkflowDoc%>">		
	</td>
</tr>
</TABLE>

        </form>

   <script language="javascript">


var dialog = null;

function closeDialog(id){
	if(dialog)dialog.close();
	editOfficalWf(id);
}

function openCreateDocStatus(id){
	//以ajax方式提交
	jQuery.ajax({
		url:"officalwf_operation.jsp",
		type:"post",
		data:{
			operation:"setCreateDoc",
			wfid:id,
			status:1
		},
		complete:function(xhr,status){
			_table.reLoad();
		}
	});
}

function closeCreateDocStatus(id){
	//以ajax方式提交
	jQuery.ajax({
		url:"officalwf_operation.jsp",
		type:"post",
		data:{
			operation:"setCreateDoc",
			wfid:id,
			status:0
		},
		complete:function(xhr,status){
			_table.reLoad();
		}
	});
}

function editOfficalWf(id){
	if(!id){
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelNames("18015,18622",user.getLanguage()) %>');
		return;
	}
	dialog = new top.Dialog();
	dialog.currentWindow = window; 
	var url = "/docs/tabs/DocCommonTab.jsp?wfid="+id+"&_fromURL=49&isdialog=1&isWorkflowDoc=<%=isWorkflowDoc%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("32485",user.getLanguage())%>";
	dialog.Width = 860;
	dialog.Height = 600;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function addOfficalWf(){
	dialog = new top.Dialog();
	dialog.currentWindow = window; 
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=48&isdialog=1&isWorkflowDoc=<%=isWorkflowDoc%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("611,23167",user.getLanguage())%>";
	dialog.Width = 400;
	dialog.Height = 210;
	dialog.URL = url;
	dialog.show();
}

function newOfficalWf(){
	dialog = new top.Dialog();
	dialog.currentWindow = window; 
	var url = "/docs/tabs/DocCommonTab.jsp?_fromURL=76&isdialog=1&isWorkflowDoc=<%=isWorkflowDoc%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,23167",user.getLanguage())%>";
	dialog.Width = 500;
	dialog.Height = 400;
	dialog.URL = url;
	dialog.show();
}

function detachOfficalWf(id){
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
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(125402,user.getLanguage())%>",function() {
		//以ajax方式提交
		jQuery.ajax({
			url:"officalwf_operation.jsp",
			type:"post",
			data:{
				operation:"detachOfficalWf",
				wfid:id
			},
			complete:function(xhr,status){
				_table.reLoad();
			}
		});
	});
}


function submitData()
{
	var wfids = "";
	$("input[name='chkInTableTag']").each(function(){
	if($(this).attr("checked"))			
		wfids = wfids +$(this).attr("checkboxId")+",";
	});
	if(wfids=="") {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return ;
	}
	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
	        form2.action="delwfs.jsp?wfids="+wfids;
			form2.submit();
			enableAllmenu();
				}, function () {}, 320, 90,false);
}

if("<%=isclose%>"==1){
	parent.wfleftFrame.location="wfmanage_left2.jsp?isTemplate=<%=isTemplate%>";
}

function submitClear()
{
	btnclear_onclick();
}

function wfSearch(){
	form2.action="managewf.jsp";
	form2.submit();
	enableAllmenu();
}
function wflogdb2(){
    window.location="/systeminfo/SysMaintenanceLog.jsp?isdialog=no&_fromURL=3&sqlwhere=<%=xssUtil.put("where int(operateitem)=85"+templatestr)%>";
}
function wflog(){
    window.location="/systeminfo/SysMaintenanceLog.jsp?isdialog=no&_fromURL=3&sqlwhere=<%=xssUtil.put("where operateitem=85"+templatestr)%>";
}
</script>
</body>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">

function addwf(){
	window.parent.location = "addwf.jsp?isTemplate=<%=isTemplate%>&typeid=<%=typeid%>&iscreat=1";
}

function onEdit(id){
	
   var link = $("#"+id).parent().parent().children().eq(1).children().eq(0).attr("href");
   if(!link){
       link = $("#_xTable_"+id).parent().parent().parent().children().eq(1).children().eq(0).attr("href");
   }
   link=link.substring(link.lastIndexOf("/")+1);
   window.parent.location=link;			
}

function onLog(wfid){
	dialog=new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Model=true;
	dialog.Width=1000;
	dialog.Height=600;
	dialog.URL="/workflow/workflow/WFLog.jsp?wfid="+wfid;
	dialog.Title="<%=SystemEnv.getHtmlLabelName(17480,user.getLanguage()) %>";
	dialog.show();
}

function onEditForwfDoc(id){
	
	if(!id){
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelNames("18015,18622",user.getLanguage()) %>');
		return;
	}
	dialog = new top.Dialog();
	dialog.currentWindow = window; 
	var url = "/workflow/workflow/addwf.jsp?wfid="+id+"&src=editwf&isdialog=1&isWorkflowDoc=<%=isWorkflowDoc%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("21954",user.getLanguage())%>";
	dialog.Width = jQuery(top.window).width()-30;
	dialog.Height = jQuery(top.window).height()-30;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function onDel(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
       form2.action="delwfs.jsp?wfids="+id+",";
	form2.submit();
	enableAllmenu();
		}, function () {}, 320, 90,false);
}

function onBtnSearchClick(){
	var typename=$("input[name='flowTitle']",parent.document).val();
	typename = encodeURI(typename);
	$("input[name='wfnameQuery']").val(typename);
	window.location="/workflow/workflow/managewf.jsp?isWorkflowDoc=<%=isWorkflowDoc%>&wfnameQuery="+typename+"&isTemplate=<%=isTemplate%>&typeid=<%=typeid%>";
}

function onOffLog(id){
	_onViewLog(220,id);
}

function daoru(){
}		
</script>
</html>
