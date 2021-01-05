
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="EAssistantViewMethod" class="weaver.fullsearch.EAssistantViewMethod" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String id =Util.null2String(request.getParameter("id"));

String ask = Util.null2String(request.getParameter("ask"));

String userID = ""+user.getUID();


int perpage=Util.getPerpageLog();
if(perpage<10) perpage=10;
String sqlwhere="where faqstatus=0 ";
if(ask!=null&&!"".equals(ask)){
	sqlwhere+=" and faqDesc like '%"+ask+"%' ";
}

String backFields = " id,faqDesc,faqcreateId";
String sqlFrom = " Fullsearch_FaqDetail t1";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"E_QuestionTable\" tabletype=\"radio\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"60%\"  text=\""+SystemEnv.getHtmlLabelName(24419,user.getLanguage())+"\" column=\"faqDesc\" otherpara=\"column:id\" orderkey=\"faqDesc\"  transmethod=\"weaver.fullsearch.EAssistantViewMethod.getQuestionInfo\"/>"+
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\"  column=\"faqcreateId\" orderkey=\"faqcreateId\"  transmethod=\"weaver.fullsearch.EAssistantViewMethod.getMangerResource\"/>"+
			  "</head>"+
			  "</table>";
 

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32689,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage());
String needfav ="1";
String needhelp ="";
 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:resetCondtionAVS(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btn_cancle(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="e8_btn_top" onclick="doSearch()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
 
	


<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<div class="zDialog_div_content" >
		<form id=SearchForm name=SearchForm method=post action="QuestionBrowser.jsp">
		<input type="hidden" name="id" value="<%=id %>">
			<wea:layout type="2Col">
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
				      <wea:item><%=SystemEnv.getHtmlLabelName(24419,user.getLanguage())%></wea:item>
				      <wea:item>
				          <input type="text" id="ask" name="ask" value="<%=ask%>" class="InputStyle">
				      </wea:item>
			     </wea:group>
			     </wea:layout>
	 	</form>
	 	<div style="overflow:auto;height:390px">
	 	<wea:layout type="2Col">
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(33046,user.getLanguage())%>' attributes="{'groupDisplay':'none'}" >
				      <wea:item attributes="{'isTableList':'true'}" >
				          <wea:SplitPageTag isShowTopInfo="true" tableString='<%=tableString%>'  mode="run"/>
				      </wea:item>
			     </wea:group>
			</wea:layout>
	 	</div
 		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2Col">
				<!-- 操作 -->
			     <wea:group context="">
			    	<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(2083,user.getLanguage())%>" class="e8_btn_submit" onclick="doSubmit(0)">
					  <input type="button" value="<%=SystemEnv.getHtmlLabelName(130380,user.getLanguage())%>" class="e8_btn_submit" onclick="doSubmit(1)">
					  <input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" onclick="btn_cancle()">
				    </wea:item>
			    </wea:group>
		    </wea:layout>
		</div>
	</td>
</tr>
</table>
</BODY>
</HTML>

<script language="javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin =parent.parent.parent.parent.getParentWindow(window.parent.parent);
	dialog = parent.parent.parent.parent.getDialog(window.parent.parent);
}catch(e){}

jQuery(document).ready(function(){

});

var checkids="";
var checknames="";

function btn_cancle(){
parentWin.closeDialog();
	
}

function doSubmit(flag)
{
	checkids=_xtalbe_radiocheckId;
	checknames=$('#name_'+checkids).html();
	var returnjson= {id:checkids,name:checknames};
	if(checkids!=""){
	  	parentWin.cbFun(returnjson,flag);
 	}else{
 		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130387,user.getLanguage())%>");
 	}
}

function doSearch()
{
    document.SearchForm.submit();
}

function openQuestion(id){
	var url = "/fullsearch/ViewFaqDetailLib.jsp?faqId="+id;
	window.open(url);
}

function closeDialog(){
	dialog.close();
}
</script>
