
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
boolean canedit=false;
if(HrmUserVarify.checkUserRight("SendDoc:Manage",user)) {
	canedit=true;
   }

String name="";
String desc="";
String id=Util.null2String(request.getParameter("id"));
if(!id.equals("")){
	RecordSet.executeSql("select * from DocSendDocNumber where id = "+id);
	if(RecordSet.next()){
	 name=Util.null2String(RecordSet.getString("name"));
	 desc=Util.null2String(RecordSet.getString("desc_n"));

	}
}
String qname = Util.null2String(request.getParameter("flowTitle"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmmain").submit();
}

var dialog = null;

function closeDialog(){
	dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,16980",user.getLanguage())%>";
		dialog.URL = "/docs/tabs/DocCommonTab.jsp?_fromURL=32&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,16980",user.getLanguage())%>";
		dialog.URL = "/docs/tabs/DocCommonTab.jsp?_fromURL=32";
	}
	dialog.Width = 600;
	dialog.Height = 213;
	dialog.Drag = true;
	dialog.show();
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16980,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){
if(id.equals("")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:_onViewLog(339),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="frmmain" id="frmmain">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<% if(canedit){ %>
				<% if(id.equals("")){%>
					<input type="button" name="newBtn" onclick="openDialog();" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"/>
				<%}%>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle"  value="<%=qname %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>

<%if(canedit){%>
<div id="formDiv" style="display:none;">
<FORM id=weaverA name=weaverA action="docNumberOperation.jsp" method=post  >
<%if(id.equals("")){%>
	<input class=inputstyle type="hidden" name="method" value="add">
<%}else{%>
	<input class=inputstyle type="hidden" name="method" value="edit">
	<input class=inputstyle type="hidden" name="id" value="<%=id%>">
<%}%>
<TABLE class=Viewform cellspacing="0" cellpadding="0">
  <COLGROUP>
  <COL width="15%">
  <COL width=85%>
  <TBODY>
  <TR class=Spacing>
          <TD class=Sep1 colSpan=4></TD></TR>

          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field>
              <input name=name class=inputstyle style="width:60%" value="<%=Util.convertInput2DB(name)%>" onchange='checkinput("name","nameimage")'><SPAN id=nameimage><%if(name.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
		  </TD>
        </TR>
        <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field>
              <input class=inputstyle name=desc  style="width:60%" value="<%if(!desc.equals("")){%><%=desc%><%}%>">
		  </TD>
        </TR>
       <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
  </TBODY>
</TABLE>
</FORM>
</div>

<FORM id=weaverD  action="docNumberOperation.jsp" method=post>
<input class=inputstyle type="hidden" name="method" value="delete">
<input class=inputstyle type="hidden" name="IDs" id="IDs" value="">
<%}%>


<%
	String sqlWhere = "1=1";
	if(!qname.equals("")){
		sqlWhere = " name like '%"+qname+"%'";
	}
	
	String  operateString= "";
	if(canedit){
	operateString = "<operates width=\"20%\">";
	 	       operateString+=" <popedom transmethod=\"weaver.general.KnowledgeTransMethod.getNKISOperate\" otherpara=\""+canedit+"\"></popedom> ";
	 	       operateString+="     <operate href=\"javascript:openDialog()\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="</operates>";	
	 }	
										
	String tableString=""+
	   "<table pageId=\""+PageIdConst.DOC_DOCNUMBERLIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DOCNUMBERLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"checkbox\">"+
	    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getDocNumberOperate\"  popedompara=\""+canedit+"\" />"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"DocSendDocNumber\" sqlorderby=\"showOrder\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+							 
			 "<col width=\"44%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\"  column=\"name\"/>"+
			 "<col width=\"50%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"desc_n\"/>"+
			 "<col width=\"6%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"showOrder\"/>"+
	   "</head>"+
	   "</table>";
%> 
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.DOC_DOCNUMBERLIST %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />

</FORM>
</body>
</html>
<script language=javascript>
function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
		jQuery("#IDs").val(id);
		jQuery('#weaverD').submit();
	});
}

</script>
