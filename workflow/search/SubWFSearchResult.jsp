


<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>



<%

int mainRequestId = Util.getIntValue(request.getParameter("mainRequestId"),0);

String workflowid =  Util.null2String(request.getParameter("workflowid"));
String nodetype = Util.null2String(request.getParameter("nodetype"));
String requestlevel = Util.null2String(request.getParameter("requestlevel"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate= Util.null2String(request.getParameter("todate"));
String creatertype = Util.null2String(request.getParameter("creatertype"));
String createrid = Util.null2String(request.getParameter("createrid"));
String fromdate2 = Util.null2String(request.getParameter("fromdate2"));
String todate2 = Util.null2String(request.getParameter("todate2"));


String newsql="";

if(!workflowid.equals("")){
    newsql+=" and t1.workflowid in("+workflowid+")" ;
}

if(!nodetype.equals("")){
	newsql += " and t1.currentnodetype='"+nodetype+"'";
}

if(!fromdate.equals("")){
	newsql += " and t1.createdate>='"+fromdate+"'";
}

if(!todate.equals("")){
	newsql += " and t1.createdate<='"+todate+"'";
}

if(!fromdate2.equals("")){
	newsql += " and t1.createdate>='"+fromdate2+"'";
}

if(!todate2.equals("")){
	newsql += " and t1.createdate<='"+todate2+"'";
}

if(!createrid.equals("")){
	newsql += " and t1.creater='"+createrid+"'";
	newsql += " and t1.creatertype= '"+creatertype+"' ";
}

if(!requestlevel.equals("")){
	newsql += " and t1.requestlevel="+requestlevel;
}

String sqlwhere="";

sqlwhere="where t1.mainRequestId="+mainRequestId;

String orderby = "";

sqlwhere +=" "+newsql ;
if(RecordSet.getDBType().equals("oracle"))
{
	sqlwhere += " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
}
else
{
	sqlwhere += " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ";
}

orderby="t1.createdate ,t1.createtime";


int perpage=10;

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSearch(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",WFSearch.jsp,_self}" ;
RCMenuHeight += RCMenuHeightStep ;

%>

<FORM id=weaver name=frmmain method=post action="SubWFSearchResult.jsp">

<input name=mainRequestId type=hidden value="<%=mainRequestId%>">

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

<table class="viewform">
  <colgroup>
  <col width="10%">
  <col width="20%">
  <col width="5">
  <col width="10%">
  <col width="20%">
  <col width="5%">
  <col width="10%">
  <col width="20">
  <tbody>
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
    <td class=field>
     <button class=browser onClick="onShowWorkFlow('workFlowId','workflowspan')"></button>
	<span id=workflowspan>
	<%=WorkflowComInfo.getWorkflowname(workflowid)%>
	</span>
	<input name=workflowid type=hidden value="<%=workflowid%>">
    
    </td>

    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></td>
    <td class=field>
     <select class=inputstyle  size=1 name=nodetype style=width:150>
     <option value="">&nbsp;</option>
     <option value="0" <% if(nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
     	<option value="1" <% if(nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
     	<option value="2" <% if(nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
     	<option value="3" <% if(nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
     </select>
    </td>
    <td>&nbsp;</td>
    <td ><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></td>
	<td class=field>
	<select class=inputstyle  name=requestlevel style=width:140 size=1>
	  <option value=""> </option>
	  <option value="0" <% if(requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
	  <option value="1" <% if(requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
	  <option value="2" <% if(requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
	</select>
	</td>
  </tr>
  <TR><TD class=Line colSpan=8></TD></TR>
 <tr>

    <td><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></td>
    <td class=field><BUTTON class=calendar id=SelectDate  onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>
      <SPAN id=fromdatespan ><%=fromdate%></SPAN>
      -&nbsp;&nbsp;<BUTTON class=calendar id=SelectDate2 onclick="gettheDate(todate,todatespan)"></BUTTON>
      <SPAN id=todatespan ><%=todate%></SPAN>
	  <input type="hidden" name="fromdate" value="<%=fromdate%>"><input type="hidden" name="todate" value="<%=todate%>">
    </td>

      <td>&nbsp;</td>
      <td ><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
	  <td class=field>
	  <select class=inputstyle  name=creatertype>
<%if(!user.getLogintype().equals("2")){%>
	  <option value="0"<% if(creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
<%}%>
	  <option value="1"<% if(creatertype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
	  </select>
	  &nbsp
	  <button class=browser onClick="onShowResource()"></button>
	<span id=resourcespan><% if(creatertype.equals("0")){%><%=ResourceComInfo.getResourcename(createrid)%><%}%>
    <% if(creatertype.equals("1")){%><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(createrid),user.getLanguage())%><%}%></span>
	<input name=createrid type=hidden value="<%=createrid%>"></td>
	<td>&nbsp;</td>

    <td><%=SystemEnv.getHtmlLabelName(17994,user.getLanguage())%></td>
    <td class=field><BUTTON class=calendar id=SelectDate3  onclick="gettheDate(fromdate2,fromdatespan2)"></BUTTON>
      <SPAN id=fromdatespan2 ><%=fromdate2%></SPAN>
      -&nbsp;&nbsp;<BUTTON class=calendar id=SelectDate4 onclick="gettheDate(todate2,todatespan2)"></BUTTON>
      <SPAN id=todatespan2 ><%=todate2%></SPAN>
	  <input type="hidden" name="fromdate2" value="<%=fromdate2%>"><input type="hidden" name="todate2" value="<%=todate2%>">
    </td>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_SEARCH_SUBWFSEARCHRESULT%>"/>
  </tr> <TR><TD class=Line colSpan=8></TD></TR>
  </tbody>
</table>


</form>


 <TABLE width="100%">
 
                 
                   
                    <tr>
                     
                      <td valign="top">                                                                                    
                          <%
                           String tableString = "";
                          
                            if(perpage <2) perpage=10;                                 
                        
                            String backfields = " t1.requestid, t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status,t1.requestlevel,t1.currentnodeid ";
                            String fromSql  = " from workflow_requestbase t1 ";
                            String sqlWhere = sqlwhere;

                         String paraTwo="column:requestid+"+user.getUID();

                         tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_SEARCH_SUBWFSEARCHRESULT,user.getUID())+"\" >"+
                                                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                                                 "			<head>";
                         tableString+="				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                         tableString+="				<col width=\"16%\"  text=\""+SystemEnv.getHtmlLabelName(15525,user.getLanguage())+"\" column=\"requestid\" orderkey=\"t1.requestid\"   transmethod=\"weaver.general.WorkFlowTransMethod.getSubWFReceiver\" />";
                         tableString+="				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";
                         tableString+="				<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""+user.getLanguage()+"\"/>";
                         tableString+="				<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"t1.requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getSubWFRequestDescription\"  otherpara=\""+paraTwo+"\"/>";

                         tableString+="			    <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17994,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
                         tableString+="			    <col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" orderkey=\"t1.status\" />";
                         tableString+="			</head>"+   			
                                      "</table>"; 
                        

                          %>
                          
                          <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
                      </td>
                    </tr>
                  </TABLE>

<!--   added by xwj for td2023 on 2005-05-20  end  -->
     
<table align=right>
   <tr>
   <td>&nbsp;</td>
   <td>
   <%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
   %>
 <td>&nbsp;</td>
   </tr>
	  </TABLE>
	  
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



<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
<script language=vbs>
sub onShowResource()
	tmpval = document.all("creatertype").value
	if tmpval = "0" then
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	else
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	end if
	if NOT isempty(id) then
	        if id(0)<> "" then
		resourcespan.innerHtml = id(1)
		frmmain.createrid.value=id(0)
		else
		resourcespan.innerHtml = ""
		frmmain.createrid.value=""
		end if
	end if

end sub
</script>

<SCRIPT language="javascript">

function OnSearch(){
		document.frmmain.submit();
}


</script>
<script language=vbs src="/js/browser/WorkFlowBrowser.vbs"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
