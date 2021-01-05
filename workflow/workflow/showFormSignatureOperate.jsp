
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTwo" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.workflow.request.RevisionConstants" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<body>
<%
int design = Util.getIntValue(request.getParameter("design"),0);
int wfid = Util.getIntValue(request.getParameter("wfid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);

String isFormSignature= Util.null2String(request.getParameter("isFormSignature"));
if(!isFormSignature.equals("1")){
	isFormSignature="0";
}
String toAllNode = Util.null2String(request.getParameter("toAllNode"));

int formSignatureWidth= Util.getIntValue(request.getParameter("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
int formSignatureHeight= Util.getIntValue(request.getParameter("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);

String src = Util.null2String(request.getParameter("src"));

if(src.equals("")){
	//RecordSet.executeSql("select isFormSignature from workflow_flownode where workflowId="+wfid+" and nodeId="+nodeid);
	RecordSet.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight from workflow_flownode where workflowId="+wfid+" and nodeId="+nodeid);
	if(RecordSet.next()){
		isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
		formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
		formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
	}
}

if(src.equals("save")){
	//RecordSet.executeSql("update workflow_flownode set isFormSignature='"+isFormSignature+"' where workflowId="+wfid+" and nodeId="+nodeid);
	RecordSet.executeSql("update workflow_flownode set isFormSignature='"+isFormSignature+"',formSignatureWidth="+formSignatureWidth+",formSignatureHeight="+formSignatureHeight+" where workflowId="+wfid+" and nodeId="+nodeid);
	if("1".equals(toAllNode)&&"1".equals(isFormSignature)){
		int tempNodeId=0;
		RecordSet.executeSql("select nodeId from workflow_flownode where workflowId="+wfid+" and nodeId<>"+nodeid);
		while(RecordSet.next()){
			tempNodeId = Util.getIntValue(RecordSet.getString("nodeid"), 0);
			if(tempNodeId > 0){
				RecordSetTwo.executeSql("update workflow_flownode set formSignatureWidth="+formSignatureWidth+",formSignatureHeight="+formSignatureHeight+" where workflowId="+wfid+" and nodeId="+tempNodeId);
			}
		}
	}
}

%>

<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(21424,user.getLanguage()) ;
    String needfav = "";
    String needhelp = "";
%>

<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
}
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

if(design==1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:designOnClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
else {
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="showFormSignatureOperate.jsp" method="post">
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="" name="src">
<input type="hidden" value="<%=nodeid%>" name="nodeid">
<input type="hidden" value="<%=design%>" name="design">

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

		    <TABLE class="viewform">
		    <COLGROUP>
		    <COL width="25%">
		    <COL width="75%">
		    <TR class="Title">
			    <TD><%=SystemEnv.getHtmlLabelName(21424,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=inputstyle type="checkbox" name="isFormSignature" value="1" onclick="showAttribute()"  <%   if("1".equals(isFormSignature)) {%> checked <% } %> ></TD>
		    </TR>
		    <TR class="Spacing">
		        <TD class="Line" colSpan=2></TD>
		    </TR>
		    <TR>
			    <TD height="10" colspan="2"></TD>
		    </TR>
		    </TABLE>
			
			<DIV id="attributeDiv" <% if("1".equals(isFormSignature)) { %> style="display:block" <% } else { %> style="display:none" <% } %>>
			                    <!--================== 表单签章属性 ==================-->
                                <TABLE class="viewform">
                                    <COLGROUP>
                                       <COL width="25%">
                                       <COL width="75%">
                                    <TR class="Title">
                                        <TH><%=SystemEnv.getHtmlLabelName(21829,user.getLanguage())%></TH>
                                        <TH><INPUT class=inputstyle type="checkbox" name="toAllNode" value="1"><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%></TH>
                                    </TR>                                
                                    <TR class="Spacing">
                                        <TD class="Line1" colSpan=2></TD>
                                    </TR>
                                    <!--================== 表单签章宽度 ==================-->
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(21830,user.getLanguage())%></TD>
                                        <TD class=Field>
									        <input type="text" name="formSignatureWidth" value="<%=formSignatureWidth%>" maxlength="4" size="4"  onKeyPress="ItemCount_KeyPress()" onChange='checknumber("formSignatureWidth");checkinput("formSignatureWidth","formSignatureWidthImage")'>
                                            <SPAN id=formSignatureWidthImage></SPAN>
                                            <%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%>
                                        </TD>
                                    </TR>
                                    <TR class="Spacing">
                                        <TD class="Line" colSpan=2></TD>
                                    </TR>
                                    <!--================== 表单签章高度 ==================-->
                                    <TR >
                                        <TD><%=SystemEnv.getHtmlLabelName(21831,user.getLanguage())%></TD>
                                        <TD class=Field>
 									        <input type="text" name="formSignatureHeight" value="<%=formSignatureHeight%>" maxlength="4" size="4"  onKeyPress="ItemCount_KeyPress()" onChange='checknumber("formSignatureHeight");checkinput("formSignatureHeight","formSignatureHeightImage")'>
                                            <SPAN id=formSignatureHeightImage></SPAN>
                                            <%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%>
                                        </TD>
                                    </TR>

                                    <TR class="Spacing">
                                        <TD class="Line" colSpan=2></TD>
                                    </TR>
                                </TABLE>
			</DIV>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>


</form>

</body>
</html>

<script language=javascript>

function showAttribute(){
    if(document.all("isFormSignature").checked){
        document.all("attributeDiv").style.display = "block";
    }else{
    	document.all("attributeDiv").style.display = "none";
    }
}

function onSave(){
	if(!document.all("isFormSignature").checked||check_form(document.SearchForm,'formSignatureWidth,formSignatureHeight')){
		document.all("src").value="save";
		document.SearchForm.submit();
	}
}


function onClose(){
    <%if("1".equals(isFormSignature)){%>
        window.parent.returnValue = "1"
    <%}else{%>
        window.parent.returnValue = "0"
    <%}%>
	window.parent.close();
}

<%
if(src.equals("save") && design==0){
%>
onClose();
<%
}	
%>

//工作流图形化确定
function designOnClose() {
	window.parent.design_callback('showFormSignatureOperate');
}
</script>



