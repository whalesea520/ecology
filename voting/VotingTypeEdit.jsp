
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

boolean canmaint = HrmUserVarify.checkUserRight("Voting:Maint",user);
if (!canmaint) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String name = "";
int approver = -1;
String id = Util.null2String(request.getParameter("id"));
if (!id.equals("")) {
	RecordSet.executeSql("select * from voting_type where id ="+id);
	if (RecordSet.next()) {
		name = Util.null2String(RecordSet.getString("typename"));
		approver = Util.getIntValue(RecordSet.getString("approver"),0);
	}
}

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(24111, user.getLanguage());
String needfav = "1";
String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:doSubmit(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="voting"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(24090,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSubmit()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name=frmMain action="VotingTypeOperation.jsp" method=post>
<input type=hidden name=method value="edit">
<input type=hidden name=id value="<%=id%>">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><nobr> 
			<wea:required id="nameimage" required="true">
				<INPUT class=inputstyle type=text maxLength=60 value="<%=name %>" size=25 name=typename id=typename onchange='checkinput("typename","nameimage")'>
			</wea:required>
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%></wea:item>
		<wea:item><nobr> 
	        <brow:browser viewType="0" name="approver" browserValue='<%=(approver > 0?(""+approver):"")%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=where isvalid=1 and isbill=1 and formid=241" 
				hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="280px"
				completeUrl="/data.jsp?type=-99991&whereClause=where isbill=1 and formid=241"  
				browserSpanValue='<%=WorkflowComInfo.getWorkflowname(""+approver)%>'></brow:browser>
		</wea:item>
		
	</wea:group>
</wea:layout>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			    <wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.close();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>

</FORM>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script language=javascript>
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);	
function doSubmit() {	
		if(check_form(frmMain,"typename")){
		   typenamecheck();
		}
}


function typenamecheck(){
     $.ajax({
          data: "",
          type: "POST",
          url: "/voting/VotingTypeOperation.jsp?id="+<%=id%>+"&method=checkname&typename="+$("#typename").val(),
          timeout: 20000,
          success: function (rs) {
             if(rs && rs.trim()=='1'){
                 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84101,user.getLanguage())%>");
             }else{
                frmMain.submit();
             }
          }, fail: function () {
              alert('<%=SystemEnv.getHtmlLabelName(84073,user.getLanguage())%>');
          }
      });
}

function back()
{
	window.history.back(-1);
}


function showFlow(spanName) {
    var result = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1 and formid=241");
    if (result != null) {
        if (wuiUtil.getJsonValueByIndex(result,0)> 0){
          spanName.innerHTML=wuiUtil.getJsonValueByIndex(result,2);
          document.all("approver").value=wuiUtil.getJsonValueByIndex(result,3)+","+wuiUtil.getJsonValueByIndex(result,4)+","+wuiUtil.getJsonValueByIndex(result,1);
        }else{
          spanName.innerHTML="";
          document.all("approver").value="";
        }
    }
}

checkinput("typename","nameimage");
</script>




</BODY></HTML>

