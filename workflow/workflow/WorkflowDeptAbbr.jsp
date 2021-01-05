<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>
 <%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<html>
<%


boolean canEdit=false;
String enableDeptcode="";
if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	canEdit=true;
}
	String isclose=Util.null2String(request.getParameter("isclose"));
    String ajax=Util.null2String(request.getParameter("ajax"));
	int workflowId=Util.getIntValue(Util.null2String(request.getParameter("workflowId")),0);
	RecordSet.executeSql("select enableDeptcode from workflow_deptAbbr where workflowId="+workflowId+" and enableDeptcode=1");
	if(RecordSet.next())enableDeptcode="1";
	int formId=Util.getIntValue(Util.null2String(request.getParameter("formId")),0);
	String isBill=Util.null2String(request.getParameter("isBill"));
	int fieldId=Util.getIntValue(request.getParameter("fieldId"),-1);
    CodeBuild codeBuild = new CodeBuild(formId,isBill,workflowId);
	boolean isWorkflowSeqAlone=codeBuild.isWorkflowSeqAlone(RecordSet,workflowId);
    String departmentNameOfSearch = Util.null2String(request.getParameter("departmentNameOfSearch"));
    String subCompanyIds = Util.null2String(request.getParameter("subCompanyIds"));
	if(subCompanyIds.equals("")){
		int[] subCompanyIdArray=CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"WorkflowManage:All");

        for(int i=0;i<subCompanyIdArray.length;i++){
            subCompanyIds+=","+subCompanyIdArray[i];
        }
        if(subCompanyIds.length()>1){
            subCompanyIds=subCompanyIds.substring(1);
        }
	}
	if(subCompanyIds.equals("")){
		subCompanyIds="0";
	}
	String subCompanyNames="";
    ArrayList subCompanyIdList=Util.TokenizerString(subCompanyIds,",");
	for(int i=0;i<subCompanyIdList.size();i++){
		subCompanyNames+=","+SubCompanyComInfo.getSubCompanyname((String)subCompanyIdList.get(i));
	}
	if(subCompanyNames.equals("")){
		subCompanyNames=subCompanyNames.substring(1);
	}
	
	String attributes = "{'groupOperDisplay':'none','samePair':'abbrtable','groupDisplay':'none','itemAreaDisplay':'none'}"; 	
	String radioCheck1 = "checked";
	String radioCheck2 = "";
	String disabled = "";
	if(fieldId==-1){
		radioCheck1 = "";
		radioCheck2 = "";
		disabled = "disabled";
	}else{
	
		if("1".equals(enableDeptcode)){
			radioCheck1 = "checked";
			radioCheck2 = "";
		}else{
			radioCheck1 = "";
			radioCheck2 = "checked";
			attributes = "{'groupOperDisplay':'none','samePair':'abbrtable','groupDisplay':'','itemAreaDisplay':''}"; 
		}
	}	
	
	int rowNum=0;
 %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33872,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(124,user.getLanguage());

String needfav ="";
String needhelp ="";
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" >
//function onShowMultiSubcompanyBrowserByDec(inputename, showname, ismand) {
//    tmpids = $GetEle(inputename).value;
//    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiSubcompanyBrowserByDec.jsp?selectedids=" + $GetEle(inputename).value + "+selectedDepartmentIds=" + tmpids)
//
 //   if (data) {
//        if (data.id != "") {
//           
 //           resourceids = data.id;
//		    resourcename = data.name;
//		    var sHtml = "";
//		    resourceids = resourceids.substring(1);
//		    resourcename = resourcename.substring(1);
//		    ids = resourceids.split(",");
//		    names =resourcename.split(",");
//		    for( var i=0;i<ids.length;i++){
//			    if(ids[i]!=""){
//			    	sHtml = sHtml+names[i]+"</a>&nbsp";
//	        	}
//	        }
 //           $GetEle(showname).innerHTML = sHtml;
 //           $GetEle(inputename).value = resourceids;
 //       } else {
//            if (ismand == 1) {
//                $GetEle(showname).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absMiddle></img>";
//            } else {
//                $GetEle(showname).innerHTML = "";
//            };
//            $GetEle(inputename).value = "";
//        }
//    }
//}

var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);

function onShowMultiSubcompanyBrowserByDec() {
	var tmpids = jQuery("#subCompanyIds").val();
	
    var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids=" + tmpids;
	var dialogurl = url;
	var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = dialogurl;
		dialog.callbackfun = function (paramobj, id1) {
			if (id1 != null) {
				var rid = wuiUtil.getJsonValueByIndex(id1, 0);
				var rname = wuiUtil.getJsonValueByIndex(id1, 1);
			    var sHtml = "";
				if (rid.indexOf(",") == 0) {
					rid = rid.substr(1);
					rname = rname.substr(1);
				}
				var idArray = rid.split(",");
				var nameArray = rname.split(",");
				for ( var _i = 0; _i < idArray.length; _i++) {
					var curid = idArray[_i];
					var curname = nameArray[_i];
					sHtml += wrapshowhtml($G("subCompanyIds").getAttribute("viewtype"), 
							"<a title='" + curname + "' href='" + url + 
							curid + "' target='_new'>" + curname + "</a>&nbsp", curid);
				}
				jQuery("#subCompanyIdsspan").html(sHtml);
				jQuery("#subCompanyIds").val(rid);
				hoverShowNameSpan(".e8_showNameClass");
			}
		};
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())%>";
		dialog.Width = 550 ;
		dialog.Height = 600;
		dialog.Drag = true;
		dialog.show();
}

function wrapshowhtml(viewtype, ahtml, id) {
	var ismust = 1;
	if (viewtype == '1') {
		ismust = 2;
	}
	var str = "<span class=\"e8_showNameClass\">";
	str += ahtml;
	str += "<span class=\"e8_delClass\" id=\"" + id + "\" onclick=\"del(event,this," + ismust + ",false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>";
	return str;
}

function onSearchDeptAbbr(obj) {
	obj.disabled = true;
	formDeptAbbr.action="WorkflowDeptAbbr.jsp" ;
	formDeptAbbr.submit();
}
function onSaveDeptAbbr(obj) {
	obj.disabled = true;
	formDeptAbbr.action="WorkflowDeptAbbrOperation.jsp" ;
	formDeptAbbr.submit();
}
function onCancelDeptAbbr(obj){
	//window.location="/workflow/workflow/WFCode.jsp?ajax=1&wfid=<%=workflowId%>";
	dialog.close();	
}

if("<%=isclose%>"==1){
	parentWin.location="WFCode.jsp?ajax=<%=ajax%>&wfid=<%=workflowId%>";
	dialog.close();	
}

function enableShowOrHide(val){
	if(val=="1"){
		hideGroup("abbrtable");
	}else{
    	showGroup("abbrtable");
	}
}
</script>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

if(!"1".equals(enableDeptcode)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearchDeptAbbr(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}

if(canEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSaveDeptAbbr(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

if(ajax.equals("1")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onCancelDeptAbbr(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<form id="formDeptAbbr" name="formDeptAbbr" method=post action="WorkflowDeptAbbrOperation.jsp" >
<input name=ajax type=hidden value="<%=ajax%>">
<input name=workflowId type=hidden value="<%=workflowId%>">
<input name=formId type=hidden value="<%=formId%>">
<input name=isBill type=hidden value="<%=isBill%>">
<input name=fieldId type=hidden value="<%=fieldId%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%if(canEdit){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_cancle"  class="e8_btn_top" onclick="onSaveDeptAbbr(this)">
		<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col">
<%--
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%>' >
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(32619,user.getLanguage())%> &nbsp;&nbsp; <input name="enableDeptcode" <%=radioCheck1 %> <%=disabled %> type="radio" onclick="enableShowOrHide('1')" value="1"></input>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(32622,user.getLanguage())%> &nbsp;&nbsp; <input name="enableDeptcode" <%=radioCheck2 %> type="radio" <%=disabled %> onclick="enableShowOrHide('2')" value=""></input>
		</wea:item>
	</wea:group> --%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>' >
		<wea:item><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></wea:item>
		<wea:item><input type=text name=departmentNameOfSearch class=Inputstyle value='<%=departmentNameOfSearch%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
		<wea:item>
		    <%--<button class=browser onClick="onShowMultiSubcompanyBrowserByDec('subCompanyIds','subCompanyIdsSpan',0)"></button>
			<span id=subCompanyIdsSpan><%=subCompanyNames%></span>
			<input name=subCompanyIds type=hidden  value="<%=subCompanyIds%>"> 
			<%=subCompanyIds%> <%=subCompanyNames%>
			--%>
			<brow:browser viewType="0" name="subCompanyIds" browserValue="" 
		          browserSpanValue="" width="auto"
		          browserOnClick="onShowMultiSubcompanyBrowserByDec()" 
		          hasInput="true" isSingle="false" hasBrowser="true" isMustInput='1' 
		          completeUrl="/data.jsp?type=164" needHidden="true" ></brow:browser>
		</wea:item>		
	</wea:group>	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(22216,user.getLanguage())%>' >
		<wea:item attributes="{'isTableList':'true'}">
			<table class=ListStyle cellspacing=1 >
			    <colgroup>
			  		<col width="50%">
			  		<col width="50%">
			  	</colgroup>
			    <tr class=header>
				    <td><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></td>
				    <td><%=SystemEnv.getHtmlLabelName(22216,user.getLanguage())%></td>
			    </tr>
				<%
				if(fieldId>0||fieldId<=-2){
				int tempFieldValue=0;
				String tempAbbr =null;
				
				Map deptAbbrDefMap=new HashMap();
				RecordSet.executeSql("select * from workflow_deptAbbrDef");
				while(RecordSet.next()){
					tempFieldValue=Util.getIntValue(RecordSet.getString("departmentId"));
					tempAbbr=Util.null2String(RecordSet.getString("abbr"));
					deptAbbrDefMap.put(""+tempFieldValue,tempAbbr);
				}
				
				String trClass="DataLight";
				
				String tempFieldValueName=null;
				int tempRecordId=0;
				
				
				StringBuffer abbrSb=new StringBuffer();
				if(isWorkflowSeqAlone){
				   abbrSb.append(" select HrmDepartment.id as fieldValue,HrmDepartment.departmentName as fieldValueName ,workflow_deptAbbr.id as recordId,workflow_deptAbbr.abbr ")
						 .append("   from HrmDepartment ")
						 .append("   left join (select * from workflow_deptAbbr ")
						 .append(" 	             where fieldId=").append(fieldId)
						 .append(" 				 and workflowId=").append(workflowId)
						 .append(" 			    )workflow_deptAbbr ")
						 .append("    on	HrmDepartment.id=workflow_deptAbbr.fieldValue  ")
						 .append(" where (HrmDepartment.canceled is null or HrmDepartment.canceled='0') ")
					     .append("   and HrmDepartment.subCompanyId1 in(").append(subCompanyIds).append(") ");
				    if(!departmentNameOfSearch.equals("")){
						abbrSb
						 .append("   and HrmDepartment.departmentName like '%").append(departmentNameOfSearch).append("%' ");
					}
				   abbrSb.append(" order by HrmDepartment.showOrder asc,HrmDepartment.id asc  ");
				}else{
				   abbrSb.append(" select HrmDepartment.id as fieldValue,HrmDepartment.departmentName as fieldValueName ,workflow_deptAbbr.id as recordId,workflow_deptAbbr.abbr ")
						 .append("   from HrmDepartment ")
						 .append("   left join (select * from workflow_deptAbbr ")
						 .append(" 	             where fieldId=").append(fieldId)
						 .append(" 				   and formId=").append(formId)
						 .append(" 				   and isBill='").append(isBill).append("' ")
						 .append(" 			    )workflow_deptAbbr ")
						 .append("    on	HrmDepartment.id=workflow_deptAbbr.fieldValue  ")
						 .append(" where (HrmDepartment.canceled is null or HrmDepartment.canceled='0') ")
					     .append("   and HrmDepartment.subCompanyId1 in(").append(subCompanyIds).append(") ");  
				    if(!departmentNameOfSearch.equals("")){
						abbrSb
						 .append("   and HrmDepartment.departmentName like '%").append(departmentNameOfSearch).append("%' ");
					}
				   abbrSb.append(" order by HrmDepartment.showOrder asc,HrmDepartment.id asc  ");
				}
				
				RecordSet.executeSql(abbrSb.toString());
					while(RecordSet.next()){
					tempFieldValue     =Util.getIntValue(RecordSet.getString("fieldValue"),0);
					tempFieldValueName   =Util.null2String(RecordSet.getString("fieldValueName"));
					tempRecordId  =Util.getIntValue(RecordSet.getString("recordId"),0);
					tempAbbr=Util.null2String(RecordSet.getString("abbr"));
					if(tempAbbr.equals("")){
						tempAbbr=Util.null2String((String)deptAbbrDefMap.get(""+tempFieldValue));
					}
				%>
				<tr class="<%=trClass%>">
				    <td  height="23" align="left"><%=tempFieldValueName%>
				      <input type="hidden" name="abbr<%=rowNum%>_fieldValue" value="<%=tempFieldValue%>">
				    </td>
				      <input type="hidden" name="abbr<%=rowNum%>_recordId" value="<%=tempRecordId%>">
				    <td  height="23" align="left">
				<%if(canEdit){%>
						<input class=Inputstyle type="text" <%if(enableDeptcode.equals("1")){%>readonly<%} %>  name="abbr<%=rowNum%>_abbr" value="<%=tempAbbr%>" maxlength=20 >
				<%}else{%>
						<%=tempAbbr%>
				<%}%>
					</td>
				</tr>

				<%
				    rowNum+=1;
				    if(trClass.equals("DataLight")){
						trClass="DataDark";
					}else{
						trClass="DataLight";
					}
				  }
				}
				%>
			</table>		
		</wea:item>
	</wea:group>	
</wea:layout>

<input type="hidden" value="<%=rowNum%>" name="rowNum">

</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
</html>
