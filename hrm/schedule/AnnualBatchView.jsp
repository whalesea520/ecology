<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(32758,user.getLanguage()); 
String needfav = "1" ; 
String needhelp = "" ; 

String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
if(subcompanyid.length()==0)subcompanyid="0";
String companyid = Util.null2String(request.getParameter("companyid"));
if(companyid.equals("0")) subcompanyid = companyid;
String showname = "";
if(!subcompanyid.equals("0")) showname = SubCompanyComInfo.getSubCompanyname(subcompanyid);
else showname = CompanyComInfo.getCompanyname("1");
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
jQuery(document).ready(function(){
<%if(showname.length()>0){%>
 parent.setTabObjName('<%=showname%>')
 <%}%>
});
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
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"/hrm/schedule/AnnualBatchOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
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
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=AnnualBatchAdd&subcompanyid=<%=subcompanyid%>";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("26473,21599",user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=AnnualBatchEdit&subcompanyid=<%=subcompanyid%>&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,21599",user.getLanguage())%>";
	}
	dialog.Width = 500;
	dialog.Height = 203;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("AnnualBatch:All",user)) { 
RCMenu += "{"+SystemEnv.getHtmlLabelName(365 , user.getLanguage())+",javascript:openDialog();,_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91 , user.getLanguage())+",javascript:doDel(),_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(21671 , user.getLanguage())+",javascript:onSyn(),_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="searchfrm" name="searchfrm" method=post action="AnnualBatchView.jsp">
<input name="subcompanyid" type="hidden" value="<%=subcompanyid %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("AnnualBatch:All", user)){ %>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col">
	<wea:group context='<%=titlename %>' attributes="{'groupOperDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<%
			String backfields = " id, workingage, annualdays "; 
			String fromSql  = " from HrmAnnualBatchProcess ";
			String sqlWhere = " where subcompanyid= "+subcompanyid;
			String orderby = " workingage " ;
			String tableString = "";
			
			//操作字符串
			String  operateString= "";
			operateString = "<operates width=\"20%\">";
			 	       operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getAnnualBatchOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Edit", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Delete", user)+":"+HrmUserVarify.checkUserRight("HrmJobActivities:log", user)+":"+HrmUserVarify.checkUserRight("HrmJobActivitiesAdd:Add", user)+"\"></popedom> ";
			 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
			 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
			 	       operateString+="</operates>";	
			 String tabletype="checkbox";
			 if(HrmUserVarify.checkUserRight("AnnualPeriod:All", user)){
			 	tabletype = "checkbox";
			 }
			 
			tableString =" <table pageId=\""+PageIdConst.HRM_AnnualBatchView+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_AnnualBatchView,user.getUID(),PageIdConst.HRM)+"\" >"+
					" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getAnnualBatchCheckbox\" id=\"checkbox\"  popedompara=\"column:id\" />"+
					"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
			    		operateString+
			    "			<head>"+
			    "				<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(15878,user.getLanguage())+"\" column=\"workingage\" orderkey=\"workingage\"/>"+
			    "				<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(19517,user.getLanguage())+"\" column=\"annualdays\" orderkey=\"annualdays\"/>"+
			    "			</head>"+
			    " </table>";
			%>
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_AnnualBatchView %>"/>
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 
		</wea:item>
	</wea:group>
</wea:layout>
<script language="javascript">
function onSyn(){
   var ids = _xtable_CheckedCheckboxId();
  if(!ids){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21677,user.getLanguage())%>");
		return;
	}
   if(ids==""){
      window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21677,user.getLanguage())%>");
      return false;
   }else{
     window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21669,user.getLanguage())%>",function(){
     	location.href="/hrm/schedule/AnnualBatchOperation.jsp?operation=syn&subcompanyid=<%=subcompanyid%>&ids="+ids;
     })
  }
}
</script>
</BODY>
</HTML>

