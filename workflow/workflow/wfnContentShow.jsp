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
	</script>	<script type="text/javascript">
		var parentWin = parent.parent.getParentWindow(parent);
		var dialog = parent.parent.getDialog(parent);
		function SelAll(obj){
		  if($(obj).is(":checked")){
			  $("input[title=shownode]").each(function(){
			       changeCheckboxStatus($(this),true);
			  });
		  }else{
		  	  $("input[title=shownode]").each(function(){
			       changeCheckboxStatus($(this),false);
			  });
		  }		  
		}
	</script>
</HEAD>
<%
//String wfid=Util.null2String(request.getParameter("wfid"));
//String workflowId = wfid.split("_")[0];
//String nodeid = wfid.split("_")[1];
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String ishtml=Util.null2String(request.getParameter("ishtml"));
String resourceids=Util.null2String(request.getParameter("resourceids"));
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSure(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
/*RCMenu += "{"+SystemEnv.getHtmlLabelName(21738,user.getLanguage())+",javascript:checkAll(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;*/
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onclear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content" style="height: 100%!important;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("68,15935",user.getLanguage()) %>'/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout>
 <wea:group context="<%=SystemEnv.getHtmlLabelName(17139, user.getLanguage())%>">
 <wea:item attributes="{'isTableList':'true'}">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="WorkflowNodeBrowserMulti.jsp" method=post>
<TABLE ID=BrowseTable class=ListStyle cellspacing=0 STYLE="margin-top:0">
<TR class=header>
<TH width=50%><span style="display: inline-block;"><input type="checkbox" class="InputStyle"  onclick="SelAll(this)"><%=SystemEnv.getHtmlLabelName( 556 ,user.getLanguage())%></span></TH>
<TH width=50%><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></TH>
</tr>
<%
int i=0;
int rowNum=0;
List<String> wfnTypeList = new ArrayList<String>();
if(ishtml.equals("1")){ 
	wfnTypeList.add("viewdesc_comments2");
	wfnTypeList.add("viewdesc_deptname2");
	wfnTypeList.add("viewdesc_operator2");
	wfnTypeList.add("viewdesc_date2");
	wfnTypeList.add("viewdesc_time2");
	wfnTypeList.add("viewdesc_signdoc2");
	wfnTypeList.add("viewdesc_signworkflow2");
	wfnTypeList.add("viewdesc_signupload2");
	wfnTypeList.add("viewdesc_mobilesource2");
}else{
	wfnTypeList.add("viewdesc_comments");
	wfnTypeList.add("viewdesc_deptname");
	wfnTypeList.add("viewdesc_operator");
	wfnTypeList.add("viewdesc_date");
	wfnTypeList.add("viewdesc_time");
	wfnTypeList.add("viewdesc_signdoc");
	wfnTypeList.add("viewdesc_signworkflow");
	wfnTypeList.add("viewdesc_signupload");
	wfnTypeList.add("viewdesc_mobilesource");
}
List wfnNameList = new ArrayList();
wfnNameList.add(SystemEnv.getHtmlLabelName(21662, user.getLanguage()));
wfnNameList.add(SystemEnv.getHtmlLabelName(15390, user.getLanguage()));
wfnNameList.add(SystemEnv.getHtmlLabelName(17482, user.getLanguage()));
wfnNameList.add(SystemEnv.getHtmlLabelName(21663, user.getLanguage()));
wfnNameList.add(SystemEnv.getHtmlLabelName(15502, user.getLanguage()));
wfnNameList.add(SystemEnv.getHtmlLabelName(857, user.getLanguage()));
wfnNameList.add(SystemEnv.getHtmlLabelName(1044, user.getLanguage()));
wfnNameList.add(SystemEnv.getHtmlLabelName(22194, user.getLanguage()));
wfnNameList.add(SystemEnv.getHtmlLabelName(129021, user.getLanguage()));

for(int j = 0;j<wfnTypeList.size();j++){
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
	<TD>
		<input type="checkbox" title="shownode" value="1" name="checkbox_<%=rowNum %>" id="checkbox_<%=rowNum %>" <%if(resourceids.indexOf(wfnTypeList.get(j))!=-1||resourceids.equals("1")){%>checked<%} %>>
		<input type="hidden" id="printNodes_<%=rowNum%>" name="printNodes_<%=rowNum%>" value="<%=wfnTypeList.get(j)%>">
    	<input type="hidden" id="printNodesName_<%=rowNum%>" name="printNodesName_<%=rowNum%>" value="<%=wfnNameList.get(j) %>">
	</TD>
	<TD>
	 <%=wfnNameList.get(j) %>
	</TD>

</TR>
<%
rowNum++;
}
%>

<input type="hidden" id="rowNum" name="rowNum" value="<%=rowNum%>">
</TABLE></FORM>
</wea:item>
</wea:group>
</wea:layout>
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
		});
	</script>
</div>
</div>
</BODY></HTML>
<script language="javascript">
function onSure(){
    var printNodes="";
    var printNodesName="";
	var rowNum=jQuery("#rowNum").val();
	var index = 0;
	
	for(i=0;i<rowNum;i++){
		if(document.getElementById("checkbox_"+i).checked){
			index++;
			printNodes=printNodes+","+document.getElementById("printNodes_"+i).value;
			printNodesName=printNodesName+","+document.getElementById("printNodesName_"+i).value;
		}
	}
    if(printNodes!=""){
		printNodes=printNodes.substr(1);
		printNodesName=printNodesName.substr(1);
	}
    
	if(index == 9){
		if(<%=ishtml.equals("1")%>){
			printNodes = "viewdesc_all2";
		}else{
			printNodes = "viewdesc_all";
		}
		printNodesName = "<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>";
	}
	
  	var returnjson  = {id:printNodes,name:printNodesName} ;
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
		document.getElementById("checkbox_"+i).status = true;
	}
	onSure();
}

function onclear(){
    js_btnclear_onclick();
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