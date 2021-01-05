<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
if (!HrmUserVarify.checkUserRight("WORKFLOWPUBLICCHOICE:VIEW", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

    String selectitemname = Util.null2String(request.getParameter("selectitemname"));
    String selectitemdesc = Util.null2String(request.getParameter("selectitemdesc"));
    int hasdetail = Util.getIntValue(request.getParameter("hasdetail"),-1);
    
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(124876,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body style="">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClick(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:newDialog(2,0),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:delBatch(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(0),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	
	
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE class=Shadow>
<tr>
<td valign="top">
<form name="frmSearch" method="post" id="frmSearch" action="selectItemSettings.jsp">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">				
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%>" class="e8_btn_top"  onclick="newDialog(2,0)"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="delBatch()"/>
				<input type="text" class="searchInput" name="flowTitle" value="<%=selectitemname %>" />
				&nbsp;&nbsp;&nbsp;
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>		
	<!-- bpf start 2013-10-29 -->
	<div class="advancedSearchDiv" id="advancedSearchDiv">
		<wea:layout type="fourCol">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			    <wea:item><input type=text name="selectitemname" id="selectitemname" class=Inputstyle value='<%=selectitemname %>'></wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		    	<wea:item><input type=text name="selectitemdesc" id="selectitemdesc" class=Inputstyle value='<%=selectitemdesc %>'></wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(124889,user.getLanguage())%></wea:item>
		    	<wea:item>
		    	    <select name="hasdetail" id="hasdetail">
						<option value=""></option>
						<option value="0" <%if(hasdetail==0){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
						<option value="1" <%if(hasdetail==1){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(82677,user.getLanguage())%></option>
					</select>	
		    	
		    	</wea:item>
		    </wea:group>
		    <wea:group context="">
		    	<wea:item type="toolbar">
		    		<input class="e8_btn_submit" type="submit" name="submit2" value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/>
		    		<input class="e8_btn_cancel" type="button"  name="reset" onclick="resetCondtion()"  value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"/>
		    		<input class="e8_btn_cancel" type="button" id="cancel" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/>
		    	</wea:item>
		    </wea:group>
		</wea:layout>
	</div>
</form>		
<%
int pageSize = 15;
String sqlWhere = " where 1=1 ";

if(!"".equals(selectitemname)){
	sqlWhere += " and selectitemname like '%"+selectitemname+"%' ";
}
if(!"".equals(selectitemdesc)){
	sqlWhere += " and selectitemdesc like '%"+selectitemdesc+"%' ";
}
if(hasdetail==0){
	sqlWhere += " and not EXISTS (SELECT 1 FROM mode_selectitempagedetail dt WHERE m.id=dt.mainid and dt.pid!=0) ";
}
if(hasdetail==1){
	sqlWhere += " and EXISTS (SELECT 1 FROM mode_selectitempagedetail dt WHERE m.id=dt.mainid and dt.pid!=0) ";
}

//System.out.println(sqlWhere);
String orderby =" operatetime ";
String tableString = "";
String backfields = " id,selectitemname,selectitemdesc,operatetime,formids,(SELECT case when COUNT(1)>0 then 1 ELSE 0 end FROM mode_selectitempagedetail d WHERE d.mainid=m.id and d.pid!=0) AS hasdetail ";
String fromSql  = " mode_selectitempage m ";


//SELECT id,selectitemname,selectitemdesc,operatetime,formids,(SELECT COUNT(1) FROM mode_selectitempagedetail d WHERE d.mainid=m.id) AS detailcount FROM mode_selectitempage m
//SELECT id,selectitemname,selectitemdesc,operatetime,formids,(SELECT case when COUNT(1)>0 then 1 ELSE 0 end FROM mode_selectitempagedetail d WHERE d.mainid=m.id) AS hasdetail 

tableString =   " <table instanceid=\"workflowTypeListTable\" tabletype=\"checkbox\" pagesize=\""+pageSize+"\" >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod=\"weaver.workflow.selectItem.SelectItemManager.canDel\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"DESC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"selectitemname\" otherpara=\"column:id\" orderkey=\"selectitemname\" transmethod=\"weaver.workflow.selectItem.SelectItemManager.getLinkSelectItem\"/>"+
                "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"selectitemdesc\" orderkey=\"selectitemdesc\" />"+
                "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(124889,user.getLanguage())+"\" column=\"hasdetail\" orderkey=\"hasdetail\" otherpara=\""+user.getLanguage()+"\"  transmethod=\"weaver.workflow.selectItem.SelectItemManager.hasDetail\"/>"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(25295,user.getLanguage())+"\" column=\"operatetime\" orderkey=\"operatetime\"/>"+
                "       </head>"+
                "		<operates>"+
                "		<popedom column=\"id\" transmethod=\"weaver.workflow.selectItem.SelectItemManager.getCanDelList\"></popedom> "+
                "		<operate href=\"javascript:newDialog(1);\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		<operate href=\"javascript:onQuote();\" text=\""+SystemEnv.getHtmlLabelName(33364,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:onLog();\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		</operates>"+                  
                " </table>";
%>

<TABLE width="100%" cellspacing=0>
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
<!--            <input type="hidden" name="pageId" id="pageId" value="<%= pageSize %>"/>-->
        </td>
    </tr>
</TABLE>		
</td>
</tr>
</TABLE>

</BODY>
<script type="text/javascript">
var diag_vote;
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();		
});
function newDialog(type,id){
	//diag_vote = new Dialog();
	var title = "";
	var url = "";
	if(type==1){
		//title = "编辑公共选择框";
		title = "<%=SystemEnv.getHtmlLabelName(124896,user.getLanguage())%>";
		url="/workflow/selectItem/selectItemMain.jsp?topage=selectItemEdit&src=edit&id="+id;
	}else{
		//title = "新建公共选择框";
		title = "<%=SystemEnv.getHtmlLabelName(124895,user.getLanguage())%>";
		url="/workflow/selectItem/selectItemMain.jsp?topage=selectItemEdit&src=add";
	}
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.maxiumnable = true;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}
function closeDialog(){
	diag_vote.close();
}

function delBatch(){		
	var id = _xtable_CheckedCheckboxId();
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		jQuery.ajax({
			url:"selectItemOperator.jsp",
			type:"post",
			data:{
				method:"deles",
				ids:id
			},
			beforeSend:function(xhr){
				try{
					e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(84024,user.getLanguage())%>",true);
				}catch(e){}
			},
			complete:function(xhr){
				e8showAjaxTips("",false);
			},
			success:function(data){
				_table.reLoad();
			}
		});
	});
}	

function onDel(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		jQuery.ajax({
			url:"selectItemOperator.jsp",
			type:"post",
			data:{
				method:"delete",
				id:id
			},
			beforeSend:function(xhr){
				try{
					e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(84024,user.getLanguage())%>",true);
				}catch(e){}
			},
			complete:function(xhr){
				e8showAjaxTips("",false);
			},
			success:function(data){
				_table.reLoad();
			}
		});
	});
}	

function onBtnSearchClick(){
	var flowTitle=$("input[name='flowTitle']",parent.document).val();
	$("input[name='selectitemname']").val(flowTitle);
	$("#frmSearch").submit();
	//window.location="/workflow/selectItem/selectItemSettings.jsp?selectitemname="+flowTitle;
}

function onQuote(id){
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelName(33364,user.getLanguage())%>";
	url="/workflow/selectItem/selectItemMain.jsp?topage=selectItemReferences&id="+id;
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 650;
	diag_vote.maxiumnable = true;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}
function onLog(id){
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%>";
	url="/workflow/selectItem/selectItemMain.jsp?topage=selectItemLog&id="+id;
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 650;
	diag_vote.maxiumnable = true;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}



</script>
</HTML>
