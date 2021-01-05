
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.docs.category.security.AclManager" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />


<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<html><head>

<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>

<%
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String wtid = Util.null2String(request.getParameter("wtid"));

	RecordSet.execute("select useapprovewf, approvewf from worktask_base where id="+wtid);
	RecordSet.next();

	int useapprovewf = Util.getIntValue(RecordSet.getString("useapprovewf"), 0);
	int approvewf = Util.getIntValue(RecordSet.getString("approvewf"), 0);

%>

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(21931,user.getLanguage())+",javascript:useSetto(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="onSave()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(21931,user.getLanguage()) %>" class="e8_btn_top middle" onclick="useSetto()"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM METHOD="POST" name="frmMain" id="frmMain" ACTION="WTApproveWfOperation.jsp">
<INPUT TYPE="hidden" NAME="operation">
<INPUT TYPE="hidden" NAME="wtid" value="<%=wtid%>">

<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	      <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
 
	         <wea:item><%=SystemEnv.getHtmlLabelName(19540, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" name="useapprovewf" onclick="showContent(this);" value="1" <%if(useapprovewf == 1){%>checked<%}%> >
	         </wea:item>
           <%if(useapprovewf == 1){%>
		        <wea:item attributes="{'samePair':\"objtr\"}" ><%=SystemEnv.getHtmlLabelName(15057, user.getLanguage())%></wea:item>
				<wea:item attributes="{'samePair':\"objtr\"}" >	
	          		<span id="approvewfSP" >
			       <brow:browser viewType="0" name="approvewf" id="approvewf" browserValue='<%=(approvewf > 0?(""+approvewf):"")%>' 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=where isvalid=1 and  formid=207 and isbill=1" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="280px"
							completeUrl="/data.jsp?type=-99991&whereClause= isbill=1  and formid=207"  
							browserSpanValue='<%=WorkflowComInfo.getWorkflowname(""+approvewf)%>'></brow:browser>	
						   &nbsp;&nbsp;&nbsp;
						   <SPAN style="cursor: pointer;">
								 <IMG src="/wechat/images/remind_wev8.png" align=absMiddle title="<%=SystemEnv.getHtmlLabelName(21966, user.getLanguage())+ SystemEnv.getHtmlLabelName(21967, user.getLanguage())%>">
						   </SPAN>
	            </wea:item>
	       <%}else{ %>
	            <wea:item attributes="{'samePair':\"objtr\",'display':\"none\"}" ><%=SystemEnv.getHtmlLabelName(15057, user.getLanguage())%></wea:item>
				<wea:item attributes="{'samePair':\"objtr\",'display':\"none\"}" >	
	          		<span id="approvewfSP" >
			       <brow:browser viewType="0" name="approvewf" id="approvewf" browserValue='<%=(approvewf > 0?(""+approvewf):"")%>' 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=where isvalid=1 and  formid=207 and isbill=1" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="280px"
							completeUrl="/data.jsp?type=-99991&whereClause= isbill=1  and formid=207"  
							browserSpanValue='<%=WorkflowComInfo.getWorkflowname(""+approvewf)%>'></brow:browser>	
							&nbsp;&nbsp;&nbsp;
				   			<SPAN style="cursor: pointer;">
								 <IMG src="/wechat/images/remind_wev8.png" align=absMiddle title="<%=SystemEnv.getHtmlLabelName(21966, user.getLanguage())+ SystemEnv.getHtmlLabelName(21967, user.getLanguage())%>">
						   </SPAN>
			     </span>	
	            </wea:item>
	       
	       <%} %>
	   
	    </wea:group>

	</wea:layout>

</FORM>
</BODY>
</html>

<SCRIPT LANGUAGE="JavaScript">

function onSave(obj){
    if($GetEle("useapprovewf").checked&&(jQuery("#approvewf").val()=="0"||jQuery("#approvewf").val()=='')) {
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>");
		return ;
	}
	document.frmMain.operation.value="editapprovewf";
	document.frmMain.submit();
}

function showContent(obj){
	if(obj.checked == true){
		showEle("objtr");
	}else{
		hideEle("objtr", true);
	}
}

function onShowWorkflow(inputName, spanName){
	url=encode("/workflow/workflow/WorkflowBrowser.jsp?isValid=1&sqlwhere=where isbill=1 and formid=207 ");
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
	
	if (data!=null){ 
	    if (data.id!= 0){
	    	jQuery(spanName).html(data.name);
			jQuery(inputName).val(data.id);
		} else {
			jQuery(spanName).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery(inputName).val("0");
	    }
	}
}

function encode(str){
    return escape(str);
}

var dialog ;
function useSetto(){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(21931,user.getLanguage()) %>";
    dialog.URL = "/worktask/base/WorktaskList.jsp?wtid=<%=wtid%>&usesettotype=4&useapprovewf=<%=useapprovewf%>&approvewf=<%=approvewf%>";
	dialog.Width = 660;
	dialog.Height = 660;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.show();
}

function MainCallback(){
	dialog.close();
	window.location.reload();
}

</SCRIPT>

