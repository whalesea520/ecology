<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
  String resourceids = Util.null2String(request.getParameter("resourceids"));
%>
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSure(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//QC160970
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(21738,user.getLanguage())+",javascript:checkAll(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
*/
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
   <jsp:param name="mouldID" value="wokflow"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("68,17139",user.getLanguage()) %>'/>
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
String ishtml=Util.null2String(request.getParameter("ishtml"));
int i=0;
int rowNum=0;
List<String> wfnTypeList = new ArrayList<String>();
List<String> wfnNameList = new ArrayList<String>();
if(ishtml.equals("1")){
	wfnTypeList.add("viewtype_approve2");
	wfnTypeList.add("viewtype_realize2");
	wfnTypeList.add("viewtype_forward2");
	wfnTypeList.add("viewtype_postil2");
	wfnTypeList.add("view_handleForward2");
	wfnTypeList.add("view_takingOpinions2");
	wfnTypeList.add("viewtype_tpostil2");
	wfnTypeList.add("viewtype_recipient2");
	wfnTypeList.add("viewtype_rpostil2");
	wfnTypeList.add("viewtype_reject2");
	wfnTypeList.add("viewtype_superintend2");
	wfnTypeList.add("viewtype_over2");
	wfnTypeList.add("viewtype_intervenor2");
}else{
	wfnTypeList.add("viewtype_approve");
	wfnTypeList.add("viewtype_realize");
	wfnTypeList.add("viewtype_forward");
	wfnTypeList.add("viewtype_postil");
	wfnTypeList.add("view_handleForward");
	wfnTypeList.add("view_takingOpinions");
	wfnTypeList.add("viewtype_tpostil");
	wfnTypeList.add("viewtype_recipient");
	wfnTypeList.add("viewtype_rpostil");;
	wfnTypeList.add("viewtype_reject");
	wfnTypeList.add("viewtype_superintend");
	wfnTypeList.add("viewtype_over");
	wfnTypeList.add("viewtype_intervenor");
}
wfnNameList.add(SystemEnv.getHtmlLabelName(615, user.getLanguage()));//提交
wfnNameList.add(SystemEnv.getHtmlLabelName(142, user.getLanguage()));//批准
wfnNameList.add(SystemEnv.getHtmlLabelName(6011, user.getLanguage()));//转发
wfnNameList.add(SystemEnv.getHtmlLabelNames("6011,1006", user.getLanguage()));//转发批注
wfnNameList.add(SystemEnv.getHtmlLabelName(23745, user.getLanguage()));//转办
wfnNameList.add(SystemEnv.getHtmlLabelName(82578, user.getLanguage()));//意见征询
wfnNameList.add(SystemEnv.getHtmlLabelNames("82578,117", user.getLanguage()));//意见征询回复
wfnNameList.add(SystemEnv.getHtmlLabelName(2084, user.getLanguage()));//抄送
wfnNameList.add(SystemEnv.getHtmlLabelNames("2084,1006", user.getLanguage()));//抄送批注
wfnNameList.add(SystemEnv.getHtmlLabelName(236, user.getLanguage()));//退回
wfnNameList.add(SystemEnv.getHtmlLabelName(21223, user.getLanguage()));//督办
wfnNameList.add(SystemEnv.getHtmlLabelName(18360, user.getLanguage()));//强制归档
wfnNameList.add(SystemEnv.getHtmlLabelName(18913, user.getLanguage()));//流程干预
for(int j = 0;j<wfnTypeList.size();j++){
	if(i==0){
		i=1;
%>
<script type="text/javascript">
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
	if(index == 13){
		<%if(ishtml.equals("1")){%>
			printNodes = "viewtype_all2";
		<%}else{%>
			printNodes = "viewtype_all";
		<%}%>
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
</script>
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
</TABLE>
</FORM>
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
<script language="javascript">


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
</BODY></HTML>