<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
	<link REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css">
	<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
	<script type="text/javascript">
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}
	</script>
</HEAD>
<%
String fieldname = Util.null2String(request.getParameter("fieldname"));
String sqlwhere = "";
String isbill = "-1";
String detailtable = Util.null2String(request.getParameter("detailtable"));
String fieldhtmltype = Util.null2String(request.getParameter("fieldhtmltype"));
String billid = Util.null2String(request.getParameter("billid"));
int isdetail = Util.getIntValue(request.getParameter("isdetail"), 0);
int fieldid = Util.getIntValue(request.getParameter("fieldid"), 0);
isbill = Util.null2String(request.getParameter("isbill"));
sqlwhere = " where fieldhtmltype="+fieldhtmltype+" and billid="+billid+" ";
if(!detailtable.equals("")){
    detailtable = detailtable.replace(" ","");
	sqlwhere+=" and detailtable='"+detailtable+"' ";
}
if(fieldid>0){
    sqlwhere+=" and id!="+fieldid+" ";
}
int pagesize = 15;


if ("1".equals(isbill)) {
	if(!"".equals(fieldname)){
		//sqlwhere += " and fieldname like '%"+fieldname+"%' ";
		sqlwhere += " and exists (SELECT 1 FROM htmllabelinfo h WHERE h.indexid=b.fieldlabel AND h.labelname LIKE '%"+fieldname+"%' AND h.languageid="+user.getLanguage()+") ";
	}
}else{
	if(!"".equals(fieldname)){
		sqlwhere += " and fieldname like '%"+fieldname+"%' ";
		//sqlwhere += " and exists (SELECT 1 FROM htmllabelinfo h WHERE h.indexid=workflow_billfield.fieldlabel AND h.labelname LIKE '%"+fieldname+"%' AND h.languageid="+user.getLanguage()+") ";
	}
}


sqlwhere+= " and selectItemType IN ('1','2') ";
sqlwhere+= "  AND EXISTS (SELECT 1 FROM mode_selectitempagedetail s1,workflow_SelectItem s2 "+
           "              WHERE  s1.id=s2.pubid AND s2.fieldid=b.id "+
           "                     AND (s1.cancel IS NULL OR s1.cancel!='1') "+
     	   "                     AND exists(SELECT 1 FROM mode_selectitempagedetail s3 WHERE s3.pid=s1.id AND (s3.cancel IS NULL OR s3.cancel!='1') HAVING COUNT(1)>0) "+ 
     	   " )";


String orderby =" id ";
String backfields = " ";
String fromSql  = " ";

if ("1".equals(isbill)) {
    if (isdetail == 0) {
    	backfields = " id as fieldid, fieldlabel,fieldname, 0 as isdetail, 0 as fieldorder, '' as description, '' as optionkey,fieldhtmltype,type ";
 		fromSql=" workflow_billfield b ";
 		sqlwhere += " and viewtype = 0 ";
    }else{
    	backfields = " id as fieldid, fieldlabel,fieldname, 1 as isdetail, 0 as fieldorder, '' as description, '' as optionkey,fieldhtmltype,type ";
 		fromSql=" workflow_billfield b ";
 		sqlwhere +=" and viewtype <> 0 ";
    }
 	sqlwhere += " and not exists (select 1 from workflow_billfield b1 where b1.pubchilchoiceid = b.id and b1.billid="+billid+" )";
}else{
	if (isdetail == 0) {
    	backfields = " id as fieldid ,fieldname, fieldname as fieldlabel, 0 as isdetail, 0 as fieldorder, description, '' as optionkey,fieldhtmltype,type ";
 		fromSql=" workflow_formdict b ";
    }else{
    	backfields = " id as fieldid,fieldname, fieldname as fieldlabel, 1 as isdetail, 0 as fieldorder, description, '' as optionkey,fieldhtmltype,type ";
 		fromSql=" workflow_formdictdetail b ";
    }
}

//System.out.println("select "+backfields+" from "+fromSql+" "+sqlwhere+" order by "+orderby);

%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" onclick="onSubmit()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="selectItemSupFieldBrowser.jsp" method=post>
<input type="hidden" id="detailtable" name="detailtable" value="<%=detailtable%>">
<input type="hidden" id="isbill" name="isbill" value="<%=isbill%>">
<input type="hidden" id="fieldhtmltype" name="fieldhtmltype" value="<%=fieldhtmltype%>">
<input type="hidden" id="billid" name="billid" value="<%=billid%>">
<input type="hidden" id="isdetail" name="isdetail" value="<%=isdetail%>">
<input type="hidden" id="isbill" name="isbill" value="<%=isbill%>">
<input type="hidden" id="fieldid" name="fieldid" value="<%=fieldid%>">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></wea:item>
		<wea:item><input name=fieldname class="InputStyle" value='<%=fieldname%>'></wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item>&nbsp;</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			
			<% 
			String tableString = "";
			tableString =   " <table instanceid=\"workflowTypeListTable\" tabletype=\"none\" pagesize=\""+pagesize+"\" >"+
							//" <checkboxpopedom  id=\"checkbox\" />"+
			                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlisdistinct=\"true\" />"+
			                "       <head>"+
			                "           <col width=\"0%\" hide=\"true\" text=\"fieldid\" column=\"fieldid\"  />"+										 
							"  			<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(15456,user.getLanguage())+"\" column=\"fieldlabel\" otherpara=\""+isbill+"+"+user.getLanguage()+"\" transmethod=\"weaver.workflow.selectItem.SelectItemManager.getFieldLable\"/>"+
							"  			<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(124937,user.getLanguage())+"\" column=\"fieldname\" />"+
							"		</head>"+
							"</table>";
			%>
				<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="submitClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</BODY>

<script language="javascript">
function afterDoWhenLoaded(){
	hideTH();
	jQuery(".ListStyle").children("tbody").find("tr[class!='Spacing']").bind("click",function(){
		var returnjson = {
			id:$($(this).children()[1]).text(),
			name:$($(this).children()[2]).text(),
		};
		if(dialog){
		    dialog.callback(returnjson);
		}else{  
		    window.parent.returnValue  = returnjson;
		    window.parent.close();
		}
	});

};


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

function onClear()
{
	submitClear() ;
}
function onSubmit()
{
	SearchForm.submit();
}
function onClose()
{
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.close() ;
	}	
}

</script>
</HTML>
