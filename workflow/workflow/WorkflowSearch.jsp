
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
int uid=user.getUID();
int isTemplate=Util.getIntValue(Util.null2String(request.getParameter("isTemplate")),-1);
String isbill = Util.null2String(request.getParameter("isbill"));
int iswfec=Util.getIntValue(Util.null2String(request.getParameter("iswfec")),0);
String typeid = Util.null2String(request.getParameter("typeid"));
String isWorkflowDoc= Util.null2String(request.getParameter("isWorkflowDoc"));
%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>


</HEAD>

<BODY>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/workflow/workflow/WorkflowSelect.jsp" method=post target="frame2">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	
<%
loadTopMenu = 0;
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.btnsub.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S style="display:none" id=btnsub ><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
loadTopMenu = 0;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T style="display:none" type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
loadTopMenu = 0;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:SearchForm.btnok.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnok accessKey=1 style="display:none" onclick="window.parent.close()" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
loadTopMenu = 0;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+", javascript:SearchForm.btnclear.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
		
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>

<wea:layout type="4col" attributes="{expandAllGroup:true}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774, user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18499,33439",user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle name=workflowname />
		</wea:item>
		<%if(iswfec!=1){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle id=isTemplate name=isTemplate >
	          <option value="" <%if(isTemplate==-1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	          <option value=0 <%if(isTemplate==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></option>
	          <option value=1 <%if(isTemplate==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18334,user.getLanguage())%></option>
	        </select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18411,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle id=isbill name=isbill >
	          <option value="" <%if(isbill.equals("")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	          <option value=0 <%if(isbill.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(700,user.getLanguage())%></option>
	          <option value=1 <%if(isbill.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15590,user.getLanguage())%></option>
	        </select>   
		</wea:item>
		<%} %>
		<wea:item><%=SystemEnv.getHtmlLabelName(33806,user.getLanguage())%></wea:item>
		<wea:item>
						<brow:browser viewType="0" name="typeid"
							browserValue='<%=typeid%>'
							browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
							hasInput="true" isSingle="true"
							hasBrowser="true" isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser"
							browserDialogWidth="600px"
							browserSpanValue='<%=WorkTypeComInfo.getWorkTypename(typeid)%>'></brow:browser>
					</wea:item>
	</wea:group>
</wea:layout>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
<input class=inputstyle type="hidden" name="tabid" >
<input type="hidden" name="iswfec" value="<%=iswfec %>" />
<input type="hidden" id="isWorkflowDoc" name="isWorkflowDoc" value="<%=isWorkflowDoc %>" />
	<!--########//Search Table End########-->
	</FORM>

<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub

Sub btnsub_onclick()
    document.all("tabid").value=2   
    document.SearchForm.submit
End Sub
</SCRIPT>

</BODY>
</HTML>
