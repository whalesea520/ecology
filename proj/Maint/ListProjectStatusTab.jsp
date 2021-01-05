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



if(HrmUserVarify.checkUserRight("EditProjectStatus:Edit", user)){
	canEdit="true";
}

if(HrmUserVarify.checkUserRight("AddProjectStatus:add", user)){
	canAdd="true";
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:onEdit(-1),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("EditProjectStatus:Delete", user)){
	canDel="true";
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:batchDel(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}


String pageId=Util.null2String(PropUtil.getPageId("prj_listprojectstatustab"));
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
		if(HrmUserVarify.checkUserRight("AddProjectStatus:add", user)){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("82",user.getLanguage())%>" class="e8_btn_top"  onclick="onEdit(-1)"/>
			<%
		}
		%>
		<%
		if(HrmUserVarify.checkUserRight("EditProjectStatus:Delete", user)){
			
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
operatorInfo.put("operatortype", "prj_prjstatus");//操作项类型
operatorInfo.put("operator_num", 2);//操作项数量
operatorInfo.put("operator_val", popedomOtherpara);



String sqlWhere = " where 1=1 ";

if(!"".equals(nameQuery1)){
	sqlWhere+=" and description like '%"+nameQuery1+"%'";
}
if(!"".equals(nameQuery)){
	sqlWhere+=" and description like '%"+nameQuery+"%'";
}
if(!"".equals(typedesc)){
	sqlWhere += " and summary like '%"+typedesc+"%' ";
}

String orderby =" dsporder,id ";
int perpage=10;                                 
String backfields = " id,fullname,description,summary,issystem,dsporder ";
String fromSql  = " Prj_ProjectStatus   ";

String tableString=""+
        "<table  pageId=\""+pageId+"\"  instanceid=\"CptCapitalAssortmentTable\"  tabletype=\"checkbox\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"prj")+"\"  >"+
        " <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.proj.util.ProjectTransUtil.getCanDelPrjStatus' />"+
        "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlprimarykey=\"id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" />"+
        "<head>";
        if("true".equalsIgnoreCase(canEdit)||"true".equalsIgnoreCase(canDel)){
        	tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"description\" orderkey=\"description\" otherpara=\"column:id\"  transmethod=\"weaver.workflow.workflow.WorkTypeComInfo.getLinkType\" />";
        }else{
        	tableString+="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"description\" orderkey=\"description\"  />";
        }
              tableString+=
              "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"summary\" orderkey=\"summary\" />"+
              "<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dsporder\" orderkey=\"dsporder\" />"+                             
        "</head>"+
        "<operates width=\"5%\">"+
         "   <popedom column='id' otherpara='"+operatorInfo.toString() +"' transmethod='weaver.proj.util.ProjectTransUtil.getOperates'  ></popedom>"+
        "    <operate href=\"javascript:onEdit()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
        "    <operate href=\"javascript:onDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
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
	var url="/proj/Maint/EditProjectStatus.jsp?isdialog=1&id="+id;
	var title="<%=SystemEnv.getHtmlLabelNames("587",user.getLanguage())%>";
	openDialog(url,title,600,380,true);
}

function onEdit(id){
	var url="/proj/Maint/EditProjectStatus.jsp?isdialog=1&id="+id;
	title="<%=SystemEnv.getHtmlLabelNames("587",user.getLanguage())%>";
	openDialog(url,title,600,380,true);
}

function onDel(id){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83600",user.getLanguage())%>',function(){
			jQuery.post(
				"/proj/Maint/ProjectStatusOperation.jsp",
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
			url : "/proj/Maint/ProjectStatusOperation.jsp",
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
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83846",user.getLanguage())%>:\n"+info);
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
