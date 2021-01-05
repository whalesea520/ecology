<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
    String selectitemname = Util.null2String(request.getParameter("selectitemname"));
    String selectitemdesc = Util.null2String(request.getParameter("selectitemdesc"));
    int hasdetail = Util.getIntValue(request.getParameter("hasdetail"),-1);
    
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
	
	function btn_cancle(){
		dialog.closeByHand();
	}
</script>
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
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btn_cancle(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top" onclick="onBtnSearchClick();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<form name="frmSearch" method="post" id="frmSearch" action="selectItemBrowser.jsp">
	<wea:layout type="fourCol">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			    <wea:item><input type=text name="selectitemname" id="selectitemname" class=Inputstyle value='<%=selectitemname %>'></wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(124889,user.getLanguage())%></wea:item>
		    	<wea:item>
		    	    <select name="hasdetail" id="hasdetail">
						<option value=""></option>
						<option value="0" <%if(hasdetail==0){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
						<option value="1" <%if(hasdetail==1){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(82677,user.getLanguage())%></option>
					</select>	
		    	
		    	</wea:item>
		    </wea:group>
	</wea:layout>
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


tableString =   " <table instanceid=\"workflowTypeListTable\" tabletype=\"none\" pagesize=\""+pageSize+"\" >"+
				" <checkboxpopedom  id=\"checkbox\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"DESC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"2%\" hide=\"true\"  text=\"ID\" column=\"id\" orderkey=\"id\" />"+
                "           <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"selectitemname\" orderkey=\"selectitemname\" />"+
                "           <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"selectitemdesc\" orderkey=\"selectitemdesc\" />"+
                "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(124889,user.getLanguage())+"\" column=\"hasdetail\" orderkey=\"hasdetail\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.selectItem.SelectItemManager.hasDetail\"/>"+
                "       </head>"+
                " </table>";
%>

<TABLE width="100%" cellspacing=0>
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>	
</div>	
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="submitClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btn_cancle();">
			</wea:item>
		</wea:group>
</wea:layout>
</div>

</BODY>
<script type="text/javascript">
function afterDoWhenLoaded(){
	jQuery(".ListStyle").children("tbody").find("tr[class!='Spacing']").bind("click",function(){
	    var name = $(this).find("td:eq(2)").html().trim();
	    var id = $(this).find("td:eq(1)").text().trim();
	    var url = "<a title='" + name + "' href='javaScript:eidtSelectItem("+id+")'>" + name + "</a>";
	    
		var returnjson = {id:id,name:url};
		if(dialog){
		    try{
		        dialog.callback(returnjson);
		    }catch(e){}
			try{
		        dialog.close(returnjson);
			}catch(e){}
		}else{  
		    window.parent.returnValue  = returnjson;
		    window.parent.close();
		}		
	});
};

var diag_vote;
jQuery(document).ready(function () {
	resizeDialog(document);
});

function submitClear()
{
	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

function onBtnSearchClick(){
	$("#frmSearch").submit();
}



</script>
</HTML>
