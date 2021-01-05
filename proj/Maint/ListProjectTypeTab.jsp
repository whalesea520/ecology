<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.proj.util.PropUtil"%>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
    String nameQuery1 = Util.null2String(request.getParameter("flowTitle"));
    String nameQuery = Util.null2String(request.getParameter("nameQuery"));
    String typedesc = Util.null2String(request.getParameter("typedesc"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>

</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
String canAdd="false";
String canEdit="false";
String canDel="false";
String canShare="false";



if(HrmUserVarify.checkUserRight("EditProjectType:Edit", user)){
	canEdit="true";
	canShare="true";
}

if(HrmUserVarify.checkUserRight("AddProjectType:add", user)){
	canAdd="true";
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addSub(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("EditProjectType:Delete", user)){
	canDel="true";
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:batchDel(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}


String pageId=Util.null2String(PropUtil.getPageId("prj_listprojecttypetab"));
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE class=Shadow>
<tr>
<td valign="top">
<form name="frmSearch" method="post" >
<input type="hidden" name="pageId" id="pageId" value="<%=pageId  %>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%
		if(HrmUserVarify.checkUserRight("AddProjectType:add", user)){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("82",user.getLanguage())%>" class="e8_btn_top"  onclick="addSub()"/>
			<%
		}
		%>
		<%
		if(HrmUserVarify.checkUserRight("EditProjectType:Delete", user)){
			
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("32136",user.getLanguage())%>" class="e8_btn_top" onclick="batchDel()"/>
			<%
		}
		%>
			
			
			<input type="text" class="searchInput" name="flowTitle" value="<%=nameQuery1 %>" />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
		<div class="advancedSearchDiv" id="advancedSearchDiv">
			<wea:layout type="4col">
			    <wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
			    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
				    <wea:item><input  name=nameQuery class=InputStyle value='<%=nameQuery %>'></wea:item>
			    	<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
			    	<wea:item><input  name=typedesc class=InputStyle value='<%=typedesc %>'></wea:item>
			    </wea:group>
			    <wea:group context="">
			    	<wea:item type="toolbar">
			    		<input class="zd_btn_submit" type="submit" name="submit1" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>"/>
			    		<input class="zd_btn_cancle" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
			    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>"  />
			    	</wea:item>
			    </wea:group>
			</wea:layout>
		</div>
	</form>		
<%

//String popedomOtherpara=canEdit+"_"+canDel+"_"+canShare;
String popedomOtherpara="";

//操作列参数
JSONObject operatorInfo=new JSONObject();
operatorInfo.put("userid", user.getUID());
operatorInfo.put("usertype", user.getLogintype());
operatorInfo.put("languageid", user.getLanguage());
operatorInfo.put("operatortype", "prj_prjtype");//操作项类型
operatorInfo.put("operator_num", 4);//操作项数量
operatorInfo.put("operator_val", popedomOtherpara);



String sqlWhere = " where 1=1 ";

if(!"".equals(nameQuery1)){
	sqlWhere+=" and type.fullname like '%"+nameQuery1+"%'";
}
if(!"".equals(nameQuery)){
	sqlWhere+=" and type.fullname like '%"+nameQuery+"%'";
}
if(!"".equals(typedesc)){
	sqlWhere += " and description like '%"+typedesc+"%' ";
}

String orderby =" type.dsporder,type.id ";
int perpage=10;                                 
String backfields = " type.id,fullname,description,wfid,protypecode,workflowname,insertworkplan,type.dsporder ";
String fromSql  = " Prj_ProjectType type LEFT JOIN Workflow_base base ON (type.wfid = base.id) ";

String tableString=""+
        "<table  pageId=\""+pageId+"\"  instanceid=\"CptCapitalAssortmentTable\"  tabletype=\"checkbox\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"prj")+"\"  >"+
        " <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.proj.util.ProjectTransUtil.getCanDelPrjType' />"+
        "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlprimarykey=\"type.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" />"+
        "<head>";
        if("true".equalsIgnoreCase(canEdit)||"true".equalsIgnoreCase(canDel)||"true".equalsIgnoreCase(canShare)){
        	tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15795,user.getLanguage())+"\" column=\"fullname\" orderkey=\"fullname\" otherpara=\"column:id\"  transmethod=\"weaver.cpt.util.CommonTransUtil.onDetailEdit\" />";
        }else{
        	tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15795,user.getLanguage())+"\" column=\"fullname\" orderkey=\"fullname\"  />";
        }
              tableString+=
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(21942,user.getLanguage())+"\" column=\"protypecode\"  orderkey=\"protypecode\"/>"+
              "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15057,user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\"/>"+
              "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(33130,user.getLanguage())+"\" column=\"insertworkplan\" orderkey=\"insertworkplan\" otherpara='"+user.getLanguage()+"' transmethod='weaver.proj.util.ProjectTransUtil.getTrueOrFalse'/>"+
              "<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dsporder\" orderkey=\"dsporder\" />"+                             
        "</head>"+
        "<operates width=\"5%\">"+
         "   <popedom column='id' otherpara='"+operatorInfo.toString() +"' transmethod='weaver.proj.util.ProjectTransUtil.getOperates'  ></popedom>"+
        "    <operate href=\"javascript:onDetailEdit()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
        "    <operate href=\"javascript:onDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
        "    <operate href=\"javascript:onCreate()\" text=\""+SystemEnv.getHtmlLabelName(21945,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
        "    <operate href=\"javascript:onShare()\" text=\""+SystemEnv.getHtmlLabelName(2112,user.getLanguage())+"\" target=\"_self\" index=\"3\"/>"+
        "</operates>"+
        "</table>"; 
%>

<!-- listinfo -->
<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />
</td>
</tr>
</TABLE>

</BODY>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">


function newDialog(type,id){
	if(id){
		var url="/proj/Maint/CheckProjectType.jsp?isdialog=1&id="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83847",user.getLanguage())%>";
		openDialog(url,title,600,380);
	}
}

function addSub(){
	var url="/proj/Maint/AddProjectType.jsp?isdialog=1";
	var title="<%=SystemEnv.getHtmlLabelNames("83848",user.getLanguage())%>";
	openDialog(url,title,500,330);
}
function onDetailEdit(id){
	var url="/proj/Maint/EditProjectType.jsp?isdialog=1&id="+id;
	var title="<%=SystemEnv.getHtmlLabelNames("83843",user.getLanguage())%>";
	openDialog(url,title,680,450,false,true);
}
function onCreate(id){
	var url="/proj/Maint/EditProjectType.jsp?isdialog=1&id="+id+"&tabid=3";
	var title="<%=SystemEnv.getHtmlLabelNames("83843",user.getLanguage())%>";
	openDialog(url,title,680,450,false,true);
}
function onShare(id){
	var url="/proj/Maint/EditProjectType.jsp?isdialog=1&id="+id+"&tabid=2";
	var title="<%=SystemEnv.getHtmlLabelNames("83843",user.getLanguage())%>";
	openDialog(url,title,680,450,false,true);
}

function onDel(id){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83600",user.getLanguage())%>',function(){
			jQuery.post(
				"/proj/Maint/ProjectTypeOperation.jsp",
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
		jQuery.ajax({
			url : "/proj/Maint/ProjectTypeOperation.jsp",
			type : "post",
			async : true,
			data : {"method":"batchdelete","id":typeids},
			dataType : "json",
			contentType: "application/x-www-form-urlencoded; charset=utf-8", 
			success: function do4Success(msg){
				if(msg&&msg.referenced){
					var info="";
					for(var i=0;i<msg.referenced.length;i++){
						info+=msg.referenced[i]+" ";
					}
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83851",user.getLanguage())%>:\n"+info);
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>");
				}
				_table.reLoad();
				
			}
		});
	});
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem = 44 and relatedid="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("32061",user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}


function onBtnSearchClick(){
	frmSearch.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});

</script>
</HTML>
