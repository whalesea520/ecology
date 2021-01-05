<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script type="text/javascript">
		var parentWin = parent.parent.getParentWindow(parent);
		var dialog = parent.parent.getDialog(parent);
	</script>
</HEAD>
<%
String workflowId=Util.null2String(request.getParameter("wfid"));
String titlename = SystemEnv.getHtmlLabelName(32206,user.getLanguage()) ;
String selectedids = Util.null2String(request.getParameter("selectedids"));
List printNodesList = Util.TokenizerString(selectedids,","); 
%>
<BODY>
<div class="zDialog_div_content" style="height: 100%!important;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSure(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(21738,user.getLanguage())+",javascript:checkAll(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onclear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="WorkflowNodeBrowserMulti.jsp" method=post>
<TABLE ID=BrowseTable class=ListStyle cellspacing=0 STYLE="margin-top:0">
<TR class=header>
<TH width=20%><input type="checkbox" id="checknode_all" name="checknode_all" onclick="checknode_all_click();" /></TH>
<TH width=40%><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></TH>
</tr>
<%
int i=0;
int rowNum=0;
String tempPrintNodes=null;
String tempPrintNodesName=null;
String tempPrintNodesType=null;

StringBuffer printNodesSb=new StringBuffer();
printNodesSb.append(" select a.nodeId,b.nodeName,a.nodeType ")
			.append(" from  workflow_flownode a,workflow_nodebase b")
			.append(" where a.workflowId=").append(workflowId)
			.append(" and a.nodeid=b.id")
			//添加本条件, 限制查询条件不包括自由流转中的节点

			.append(" and (b.isFreeNode != '1' OR b.isFreeNode IS null)")
			.append(" order by a.nodeorder,b.id")				
			;
//System.out.println(printNodesSb.toString());
RecordSet.executeSql(printNodesSb.toString());
while(RecordSet.next()){
	tempPrintNodes=Util.null2String(RecordSet.getString("nodeId"));
	tempPrintNodesName=Util.null2String(RecordSet.getString("nodeName"));
	tempPrintNodesType=Util.null2String(RecordSet.getString("nodeType"));

	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
	<%
	}
	%>
	<TD><input type="checkbox" value="1" name="checkbox_<%=rowNum%>" id="checkbox_<%=rowNum%>" <%=printNodesList.contains(tempPrintNodes)?"checked":""%>></TD>	
    <input type="hidden" id="printNodes_<%=rowNum%>" name="printNodes_<%=rowNum%>" value="<%=tempPrintNodes%>">
    <input type="hidden" id="printNodesName_<%=rowNum%>" name="printNodesName_<%=rowNum%>" value="<%=tempPrintNodesName%>">
	<TD><%=tempPrintNodesName%></TD>
	<TD>
<%if(tempPrintNodesType.equals("0")){%><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><%}%>
<%if(tempPrintNodesType.equals("1")){%><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%><%}%>
<%if(tempPrintNodesType.equals("2")){%><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%><%}%>
<%if(tempPrintNodesType.equals("3")){%><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%><%}%>
	</TD>

</TR>
<%
	rowNum++;
}
%>

<input type="hidden" id="rowNum" name="rowNum" value="<%=rowNum%>">
</TABLE></FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" accessKey=O  id=btnok  value="<%="O-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="onSure();">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onclear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			//jquery(".zDialog_div_content").css("height","100%");
		});
	</script>
</div>
</div>
</BODY></HTML>
<script language="javascript">
function checknode_all_click(){
	var state = jQuery("#checknode_all").attr("checked");
	jQuery("input[name^='checkbox_']").each(function(){
		if(state){
			$(this).attr("checked",true).next().addClass("jNiceChecked");
		}else{
			$(this).attr("checked",false).next().removeClass("jNiceChecked");
		}
	});
}

function onSure(){
    var printNodes="";
    var printNodesName="";
	var rowNum=document.getElementById("rowNum").value;

	for(i=0;i<rowNum;i++){
		if(document.getElementById("checkbox_"+i).checked){
			printNodes=printNodes+","+document.getElementById("printNodes_"+i).value;
			printNodesName=printNodesName+","+document.getElementById("printNodesName_"+i).value;
		}
	}
    if(printNodes!=""){
		printNodes=printNodes.substr(1);
		printNodesName=printNodesName.substr(1);
	}
	
  	var returnjson  = {id:printNodes,name:printNodesName} ;
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.close();
	}     
}


function js_btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}     
}

function checkAll(){
	var rowNum=document.getElementById("rowNum").value;
	for(i=0;i<rowNum;i++){
		document.getElementById("checkbox_"+i).checked = true;
	}
	onSure();
}

function onclear(){
    js_btnclear_onclick();
}

function onClose(){
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.close() ;
	}	
}
</script>