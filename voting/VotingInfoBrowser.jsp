<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>

<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(24111, user.getLanguage());
String needfav = "1";
String needhelp = "";
%>

<%

String fullname = Util.null2String(request.getParameter("fullname"));
String sqlwhere = "";

if(!fullname.equals("")){
		sqlwhere += " and subject like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
}

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>


<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="voting"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(17599,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="submitData()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelNames("82753",user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="VotingInfoBrowser.jsp" method=post>

<wea:layout type="2col">
  <wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
	<wea:item><%=SystemEnv.getHtmlLabelName(24096,user.getLanguage())%></wea:item>
	<wea:item> <input name='fullname' class='inputstyle' value='<%=fullname%>'></wea:item>
  </wea:group>
  <wea:group context="" attributes="{'groupDisplay':'none'}">
  	<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
  </wea:group>
  <wea:group context="" attributes="{'groupDisplay':'none'}">
	<wea:item attributes="{'isTableList':'true','colspan':'full'}">
		<%
		String tableString="<table  pagesize=\"10\" tabletype=\"none\" valign=\"top\" >"+
		"<sql backfields=\"*\" sqlform=\" from voting \"  sqlorderby=\"createdate , createtime\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlwhere=\""+Util.toHtmlForSplitPage("where 1=1 and (status=1 or status=2) "+sqlwhere)+"\" sqldistinct=\"true\" />"+
		"<head >"+
		 "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\"   column=\"id\" />"+
		 "<col width=\"70%\"  text=\""+SystemEnv.getHtmlLabelName(24096,user.getLanguage())+"\"  column=\"subject\" orderkey=\"subject\" />"+
		"</head>"+ "</table>";
	  	%>
	  	<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
	</wea:item>
  </wea:group>
    
  
</wea:layout>



</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
			    <input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclear_onclick();">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

</BODY></HTML>

<script type="text/javascript">

try{
	parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("16980",user.getLanguage())%>");
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

function submitData(){
	if (check_form(SearchForm,''))
		SearchForm.submit();
}

function submitClear(){
	window.parent.returnValue = {id:"",name:""};
	window.parent.close();
}

 jQuery("#_xTable").bind("click",function(e){
    var target =  e.srcElement||e.target ;
	try{
	    var curRow ;
		if(target.nodeName == "TD" || target.nodeName == "A"){
			curRow=$(target).parents("tr")[0];
		}
		
		if(dialog){
			try{
			    dialog.callback({id:$(curRow.cells[1]).text(),name:$(curRow.cells[2]).text()});
			}catch(e){}
			try{
			dialog.close({id:$(curRow.cells[1]).text(),name:$(curRow.cells[2]).text()});
			}catch(e){}
		}else{
			window.parent.returnValue = {id:$(curRow.cells[1]).text(),name:$(curRow.cells[2]).text()};
			window.parent.close()
		}
	}catch (en) {
		alert(en.message);
	}
});

</script>
