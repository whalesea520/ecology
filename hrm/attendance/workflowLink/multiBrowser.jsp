<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<!-- Added by wcd 2016-04-27[流程出口] -->

<HTML><HEAD>
	<link REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script type="text/javascript">
		var parentWin = parent.parent.getParentWindow(parent);
		var dialog = parent.parent.getDialog(parent);
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("15587",user.getLanguage())%>");
		}catch(e){}
	</script>
</HEAD>
<%
String printNodes=Util.null2String(request.getParameter("printNodes"));
List printNodesList=Util.TokenizerString(printNodes,",");
String wfid=Util.null2String(request.getParameter("wfid"));
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="WorkflowNodeBrowserMulti.jsp" method=post>

<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSure(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:js_btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=2 id=btnclear onclick="js_btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<TABLE ID=BrowseTable class=ListStyle cellspacing=1 style="margin-top:0;width:100%;" >
<TR class=header>
<TH width=20%><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></TH>
<TH width=20%>ID</TH>
<TH width=20%><%=SystemEnv.getHtmlLabelName(15611,user.getLanguage())%></TH>
<TH width=20%><%=SystemEnv.getHtmlLabelName(33413,user.getLanguage())%></TH>
<TH width=20%><%=SystemEnv.getHtmlLabelNames("15075,15587",user.getLanguage())%></TH>
</tr>
<%
		int i=0;
		int rowNum=0;
		String linkName=null;
		String linkCondition=null;
		String linkId = null;
		String isReject = "0";
		
		StringBuffer printNodesSb=new StringBuffer();
		printNodesSb.append("select id,isreject,linkname,conditioncn from workflow_nodelink")
					.append(" where workflowId=").append(wfid);
		RecordSet.executeSql(printNodesSb.toString());
		while(RecordSet.next()){
			linkId = Util.null2String(RecordSet.getString("id"));
			linkName=Util.null2String(RecordSet.getString("linkname"));
			linkCondition=Util.null2String(RecordSet.getString("conditioncn"));
			isReject = Util.null2String(RecordSet.getString("isreject"));

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
	<TD><input type=checkbox value=1 name="checkbox_<%=rowNum%>" <%=printNodesList.indexOf(linkId)>=0?"checked":""%> ></TD>
    <input class=inputstyle type=hidden name="printNodes_<%=rowNum%>" value="<%=linkId%>">
    <input class=inputstyle type=hidden name="printNodesName_<%=rowNum%>" value="<%=linkName%>">
	<TD><%=linkId%></TD>
	<TD><%=linkName%></TD>
	<TD><%=linkCondition%></TD>
	<TD><%=isReject.equals("1")?SystemEnv.getHtmlLabelName(236,user.getLanguage()):""%></TD>

</TR>
<%
	rowNum++;
}
%>

<input class=inputstyle type=hidden name=rowNum value="<%=rowNum%>">
</TABLE></FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" accessKey=O  id=btnok  value="<%="O-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="onSure();">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="js_btnclear_onclick();">
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
</BODY></HTML>

<script language="javascript">
function onSure(){
    var printNodes="";
    var printNodesName="";
	var rowNum=$("input[name=rowNum]").val();

	for(i=0;i<rowNum;i++){
		if($("input[name=checkbox_"+i+"]")[0].checked){
			printNodes=printNodes+","+$("input[name=printNodes_"+i+"]").val();
			printNodesName=printNodesName+","+$("input[name=printNodesName_"+i+"]").val();
		}
	}
    if(printNodes!=""){
		printNodes=printNodes.substr(1);
		printNodesName=printNodesName.substr(1);
	}
    var returnjson = {id:printNodes,name:printNodesName};
	if(dialog){
			try{
		     dialog.close(returnjson);
	
		 }catch(e)
		 {
		 		console.log(e);
		 }
	   try{
        dialog.callback(returnjson);
     }catch(e)
     {
     		console.log(e);
     	}
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
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

function onClose(){
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.close() ;
	}	
}
</script>