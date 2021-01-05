
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<jsp:useBean id="formFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="fieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />

<HTML>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(172,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(16370,user.getLanguage());
    String needfav = "";
    String needhelp = "";
	String seccategory = request.getParameter("seccategory");   
	String wordmouldid = request.getParameter("wordmouldid");
	String workflowid=request.getParameter("workflowid");

%>
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
        <script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("16449",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e);
		}
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}
		
		function onClose(){
			 if(dialog){
		    	dialog.close()
		    }else{
			    window.parent.close();
			}
		}
		function btnclear_onclick(){
			if(dialog){
				try{
				dialog.callback({id:"",name:""});
				}catch(e){}
				try{
				dialog.close({id:"",name:""});
				}catch(e){}
		
			}else{
			     window.parent.returnValue = {id:"",name:""};
			     window.parent.close();
			}
		}
	</script>
    </HEAD>
<BODY>
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self}";
	RCMenuHeight += RCMenuHeightStep;  
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self}";
    RCMenuHeight += RCMenuHeightStep;  
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM name="" method="post" action="" >
<%
		String sqlwhere = "docSecCategoryMould.mouldID = DocMouldFile.ID AND docSecCategoryMould.mouldType in (4,8) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + seccategory+" and docSecCategoryMould.mouldID=workflow_mould.mouldid and workflow_mould.seccategory="+seccategory+" and workflow_mould.workflowid="+workflowid+" and workflow_mould.mouldType in (3,4) and  visible=1 ";
		String tableString=""+
			   "<table needPage=\"false\" pagesize=\"10\" tabletype=\"none\">"+
			   "<sql backfields=\"DocMouldFile.ID, DocMouldFile.mouldName\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlform=\"DocSecCategoryMould docSecCategoryMould,  DocMouldFile,workflow_mould\" sqlprimarykey=\"DocMouldFile.ID\"  sqlisdistinct=\"true\" sqlsortway=\"asc\"  />"+
			   "<head>";
			   		tableString+=	 "<col width=\"20%\" hide=\"true\"  text=\"ID\" column=\"id\" />";
			   		tableString += "<col width=\"10%\"  text=\"ID\" column=\"id\"/>";
					tableString += "<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(28050,user.getLanguage())+"\" column=\"mouldName\"/>"+
			   "</head>"+
			   "</table>";      
	  	%>
	  	<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>                                                       
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclear_onclick();">
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
<script language=javascript>

function afterDoWhenLoaded(){
	jQuery("#_xTable").find("table.ListStyle tbody").find("tr[class!='Spacing']").bind("click",function(){
		var tr = jQuery(this);
		var json = {id:tr.children("td:first").next().text(),name:tr.children("td:first").next().next().text()};
		if(dialog){
			try{
			dialog.callback(json);
			}catch(e){}
			try{
			dialog.close(json);
			}catch(e){}
		}else{
		     window.parent.returnValue = json;
		     window.parent.close();
		}
	});
}
</script>
</HTML>
