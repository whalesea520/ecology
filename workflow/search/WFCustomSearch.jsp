<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="crmComInfo1" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";

int iswaitdo= Util.getIntValue(request.getParameter("iswaitdo"),0) ;

//out.print(Util.numtochinese("4341009009.12"));
String moudle=Util.null2String(request.getParameter("moudle"));
String createrid=Util.null2String(request.getParameter("createrid"));
String docids=Util.null2String(request.getParameter("docids"));
String crmids=Util.null2String(request.getParameter("crmids"));
String hrmids=Util.null2String(request.getParameter("hrmids"));
String prjids=Util.null2String(request.getParameter("prjids"));
String creatertype=Util.null2String(request.getParameter("creatertype"));
String workflowid=Util.null2String(request.getParameter("workflowid"));
String nodetype=Util.null2String(request.getParameter("nodetype"));
String fromdate=Util.null2String(request.getParameter("fromdate"));
String todate=Util.null2String(request.getParameter("todate"));
String lastfromdate=Util.null2String(request.getParameter("lastfromdate"));
String lasttodate=Util.null2String(request.getParameter("lasttodate"));
String requestmark=Util.null2String(request.getParameter("requestmark"));
String branchid=Util.null2String(request.getParameter("branchid"));
int during=Util.getIntValue(request.getParameter("during"),0);
int order=Util.getIntValue(request.getParameter("order"),0);
int isdeleted=Util.getIntValue(request.getParameter("isdeleted"),0);
String requestname=Util.fromScreen2(request.getParameter("requestname"),user.getLanguage());
requestname=requestname.trim();
int subday1=Util.getIntValue(request.getParameter("subday1"),0);
int subday2=Util.getIntValue(request.getParameter("subday2"),0);
int maxday=Util.getIntValue(request.getParameter("maxday"),0);
int state=Util.getIntValue(request.getParameter("state"),0);
String requestlevel=Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());
String issimple=Util.null2String(request.getParameter("issimple"));
String isbill=WorkflowComInfo.getIsBill(workflowid);
String formID=WorkflowComInfo.getFormId(workflowid);
    if (rs.getDBType().equals("oracle")) {
        rs.execute("select id from workflow_custom where isbill='" + isbill + "'and formid=" + formID + " and (workflowids is null or ','||to_char(workflowids)||',' like '%,'||" + workflowid + "||',%') order by id");
    } else {
        rs.execute("select id from workflow_custom where isbill='" + isbill + "'and formid=" + formID + " and (workflowids is null or ','+convert(varchar,workflowids)+',' like '%,'+'" + workflowid + "'+',%') order by id");
    }
    if (rs.next()) {
        response.sendRedirect("/workflow/search/WFCustomSearchBySimple.jsp?workflowid="+workflowid+"&issimple="+issimple);
        return;
    }
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:frmmain.reset(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CustomSearch.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="frmmain" method="post" action="WFCustomSearchTemp.jsp" >
<input name=iswaitdo type=hidden value="<%=iswaitdo%>">
<input name=issimple type=hidden value="<%=issimple%>">
<br>

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


<table class="ViewForm">
  <colgroup>
  <col width="10%">
  <col width="39%">
  <col width="8">
  <col width="10%">
  <col width="39%">
  <tbody>
  <TR class="Title"><th COLSPAN=5><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%></th></TR>
  <TR class=Separartor style="height:1px;"><TD class="Line1" COLSPAN=5></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
    <td class=field>
     <input type=text name=requestmark  style=width:240 class=Inputstyle value="<%=requestmark%>">
     <SPAN id=remind style='cursor:hand' title='<%=SystemEnv.getHtmlLabelName(84556,user.getLanguage())%>'>
    <IMG src='/images/remind_wev8.png' align=absMiddle>
    </SPAN>
    </td>  <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></td>
    <td class=field>
     <select class=inputstyle  size=1 name=isdeleted style=width:240>
     	<option value="0" <%if (isdeleted==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
     	<option value="1" <%if (isdeleted==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
     	<option value="2" <%if (isdeleted==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
     </select>
    </td>

  </tr>
   <TR class=Separartor style="height:1px;"><TD class="Line" COLSPAN=5></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
    <td class=field>
    
    <%if (!moudle.equals("1")) {%><button type=button  class=Browser onClick="onShowWorkFlowSerach('workFlowId','workflowspan')"></button><%}%>
	<span id=workflowspan>
	<%=WorkflowComInfo.getWorkflowname(""+workflowid)%>
	</span>
	<input name=workflowid type=hidden value=<%=workflowid%>>
    </td>
    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></td>
    <td class=field>
     <select class=inputstyle  size=1 name=nodetype style=width:240>
     	<option value="">&nbsp;</option>
     	<option value="0" <%if (nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
     	<option value="1" <%if (nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
     	<option value="2" <%if (nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
     	<option value="3" <%if (nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
     </select>
    </td>
  </tr><TR class=Separartor style="height:1px;"><TD class="Line" COLSPAN=5></TD></TR>
  
  <!--TR class=Separartor style="height:1px;"><TD class="Line1" COLSPAN=5></TD></TR-->
  <tr><td class=5>&nbsp;</td></tr>
  <TR class="Title"><th COLSPAN=5><%=SystemEnv.getHtmlLabelName(401,user.getLanguage())%></th></TR>
  <TR class=Separartor style="height:1px;"><TD class="Line1" COLSPAN=5></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
    <td class=field><button type=button  class=calendar id=SelectDate onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>&nbsp;
      <SPAN id=fromdatespan ><%=fromdate%></SPAN>
      -&nbsp;&nbsp;<button type=button  class=calendar id=SelectDate2 onclick="gettheDate(todate,todatespan)"></BUTTON>&nbsp;
      <SPAN id=todatespan ><%=todate%></SPAN>
	  <input type="hidden" name="fromdate" class=Inputstyle value="<%=fromdate%>"><input type="hidden" name="todate" class=Inputstyle  value="<%=todate%>">
    </td>
    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></td>
    <td class=field>
     <select class=inputstyle  size=1 name=during style=width:240>
     	<option value="">&nbsp;</option>
     	<option value="1" <%if (during==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
     	<option value="2" <%if (during==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15538,user.getLanguage())%></option>
     	<option value="3" <%if (during==3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
     	<option value="4" <%if (during==4) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15540,user.getLanguage())%>7</option>
     	<option value="5" <%if (during==5) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
     	<option value="6" <%if (during==6) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15540,user.getLanguage())%>30</option>
     	<option value="7" <%if (during==7) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15542,user.getLanguage())%></option>
     	<option value="8" <%if (during==8) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15540,user.getLanguage())%>365</option>
     </select>
    </td>
  </tr>
  <TR style="height:1px;"><TD class="Line" COLSPAN=5></TD></TR>
  <tr>
      <td ><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
	  <td class=field>
	  <select class=inputstyle  name=creatertype>
<%if(!user.getLogintype().equals("2")){%>
	  <option value="0" <%if (creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
	 
<%}%>
	  <option value="1" <%if (creatertype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
	  </select>
	  &nbsp
	  <button type=button  class=Browser onClick="onShowResource()"></button>
	<span id=resourcespan>
	<%=ResourceComInfo.getResourcename(createrid)%>
	</span>
	<input name=createrid type=hidden value="<%=createrid%>"></td>
	<td>&nbsp;</td>
 <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><br><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></td>
    <td class=field>
      <button type=button  class=Browser onClick="onShowBranch()"></button>
	<span id=branchspan><%=SubCompanyComInfo.getSubCompanyname(branchid)%></span>
	<input name=branchid type=hidden  value="<%=branchid%>">
    </td> 
 
    </tr> 
	<TR style="height:1px;"><TD class="Line" COLSPAN=5></TD></TR>

<!--tr><TD class="Line1" COLSPAN=5></TD></TR-->
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

sub onShowBranch()
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&frmmain.branchid.value)
	if NOT isempty(id) then
	    if id(0)<> "" then
		branchspan.innerHtml = id(1)
		frmmain.branchid.value=id(0)
		else
		branchspan.innerHtml = ""
		frmmain.branchid.value=""
		end if
	end if
	
end sub
</script>
 <tr><td>&nbsp;</td></tr>

 <TR class="Title"><th COLSPAN=5><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%></th></TR>
  <TR class=Separartor style="height:1px;"><TD class="Line1" COLSPAN=5></TD></TR>
   <tr>
    <td><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
    <td class=field><button type=button  class=Browser onClick="onShowDocids()"></button>
	<span id=docidsspan><%=DocComInfo1.getDocname(docids.equals("")?"0":docids)%></span>
	<input name=docids type=hidden value="<%=docids%>">
    </td>
    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></td>
    <td class=field><button type=button  class=Browser onClick="onShowCrmids()"></button>
	<span id=crmidsspan><%=crmComInfo1.getCustomerInfoname(crmids)%></span>
	<input name=crmids type=hidden value="<%=crmids%>"></td>
  </tr><TR style="height:1px;"><TD class="Line" COLSPAN=5></TD></TR>
  <script language=vbs>
sub onShowDocids()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1")
	if NOT isempty(id) then
	        if id(0)<> "" then
		docidsspan.innerHtml = id(1)
		frmmain.docids.value=id(0)
		else
		docidsspan.innerHtml = ""
		frmmain.docids.value=""
		end if
	end if
end sub

sub onShowCrmids()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		crmidsspan.innerHtml = id(1)
		frmmain.crmids.value=id(0)
		else
		crmidsspan.innerHtml = ""
		frmmain.crmids.value=""
		end if
	end if
end sub
</script>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></td>
    <td class=field><button type=button  class=Browser onClick="onShowPrjids()"></button>
	<span id=prjidsspan><%=ProjectInfoComInfo1.getProjectInfoname(prjids)%></span>
	<input name=prjids type=hidden value="<%=prjids%>"></td>
    <td>&nbsp;</td>
<%if(!user.getLogintype().equals("2")){%>
    <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
    <td class=field><button type=button  class=Browser onClick="onShowHrmids()"></button>
	<span id=hrmidsspan><%=ResourceComInfo.getResourcename(hrmids)%></span>
	<input name=hrmids type=hidden value="<%=hrmids%>">
    </td>
<%}%>

  </tr>
  
  
<TR style="height:1px;"><TD class="Line" COLSPAN=5></TD></TR>
  <tr><td>&nbsp;</td></tr>
  <script language=vbs>
sub onShowHrmids()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		hrmidsspan.innerHtml = id(1)
		frmmain.hrmids.value=id(0)
		else
		hrmidsspan.innerHtml = ""
		frmmain.hrmids.value=""
		end if
	end if
end sub

sub onShowPrjids()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		prjidsspan.innerHtml = id(1)
		frmmain.prjids.value=id(0)
		else
		prjidsspan.innerHtml = ""
		frmmain.prjids.value=""
		end if
	end if
end sub
</script>

 <TR class="Title"><th COLSPAN=5><%=SystemEnv.getHtmlLabelName(19533,user.getLanguage())%></th></TR>
  <TR class=Separartor style="height:1px;"><TD class="Line1" COLSPAN=5></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
    <td class=field><input type=text name=requestname size=30  class=Inputstyle value="<%=requestname%>">
        <SPAN id=remind style='cursor:hand' title='<%=SystemEnv.getHtmlLabelName(84556,user.getLanguage())%>'>
        <IMG src='/images/remind_wev8.png' align=absMiddle>
        </SPAN>
    </td>
	<td>&nbsp;</td>
     <td ><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></td>

	<td class=field>
	<select class=inputstyle  name=requestlevel style=width:240 size=1>
	  <option value=""> </option>
	  <option value="0" <%if (requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
	  <option value="1" <%if (requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
	  <option value="2" <%if (requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
	</select>
	</td>

  </tr>
  </tbody>
</table>

		</td>
		</tr>
		</TABLE>
	</td>
	<td class=field></td>
</tr>
<tr>
	<td class=field height="10" colspan="3"></td>
</tr>
</table>

</form>
<script language="javascript" src="/js/browser/WorkFlowBrowser_wev8.js"></script>



<script type="text/javascript">

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}


</script>

<script type="text/javascript">
function onShowResource() {
	var url = "";
	var tmpval = $G("creatertype").value;
	
	if (tmpval == "0") {
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	} else {
		url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	}
	disModalDialog(url, $G("resourcespan"), $G("createrid"), false);
}

function onShowBranch() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" + $G("branchid").value;
	
	disModalDialog(url, $G("branchspan"), $G("createrid"), false);
}

function onShowDocids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1";
	disModalDialog(url, $G("docidsspan"), $G("docids"), false);
}

function onShowCrmids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	disModalDialog(url, $G("crmidsspan"), $G("crmids"), false);
}

function onShowHrmids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	disModalDialog(url, $G("hrmidsspan"), $G("hrmids"), false);
}

function onShowPrjids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
	disModalDialog(url, $G("prjidsspan"), $G("prjids"), false);
}

function onShowBrowser(id,url,tmpindex) {
	var url = url + "?selectedids=" + $G("con" + id + "_value").value;
	disModalDialog(url, $G("con" + id + "_valuespan"), $G("con" + id + "_value"), false);
	$G("con" + id + "_name").value = $G("con" + id + "_valuespan").innerHTML;

	if ($G("con" + id + "_value").value == ""){
	    document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	} else {
	    document.frmmain.check_con[tmpindex*1].checked = true
	    document.getElementsByName("check_con")[tmpindex * 1].checked = true;
	}
}

function onShowBrowserCustom(id, url, tmpindex, type1) {
	var id1 = window.showModalDialog(url, "", 
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
			var names = wuiUtil.getJsonValueByIndex(id1, 1);
			var descs = wuiUtil.getJsonValueByIndex(id1, 2);
			if (type1 == 161) {
				$G("con" + id + "_valuespan").innerHTML = "<a title='" + ids + "'>" + names + "</a>&nbsp";
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
			if (type1 == 162) {
				var sHtml = "";

				var idArray = ids.split(",");
				var curnameArray = names.split(",");
				var curdescArray = descs.split(",");

				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];

					sHtml = sHtml + "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
				}

				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				$G("con" + id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
			}
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
	if ($G("con" + id + "_value").value == "") {
		document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	} else {
		document.getElementsByName("check_con")[tmpindex * 1].checked = true;
	}
}

function onShowBrowser1(id,url,type1) {
	//var url = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
	if (type1 == 1) {
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
		$G("con" + id + "_valuespan").innerHTML = id1;
		$G("con" + id + "_value").value=id1
	} else if (type1 == 1) {
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
		$G("con"+id+"_value1span").innerHTML = id1;
		$G("con"+id+"_value1").value=id1;
	}
}



function onShowBrowser2(id, url, type1, tmpindex) {
	var tmpids = "";
	var id1 = null;
	if (type1 == 8) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?projectids=" + tmpids);
	} else if (type1 == 9) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?documentids=" + tmpids);
	} else if (type1 == 1) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 4) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?selectedids=" + tmpids
				+ "&resourceids=" + tmpids);
	} else if (type1 == 16) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 7) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 142) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids);
	}
	//id1 = window.showModalDialog(url)
	if (id1 != null) {
		resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
		resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
			$G("con" + id + "_valuespan").innerHTML = resourcename;
			jQuery("input[name=con" + id + "_value]").val(resourceids);
			jQuery("input[name=con" + id + "_name]").val(resourcename);
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
	if ($G("con" + id + "_value").value == "") {
		document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	} else {
		document.getElementsByName("check_con")[tmpindex * 1].checked = true;
	}
}

function onShowMutiHrm(spanname, inputename) {
	tmpids = $G(inputename).value;
	id1 = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
					+ tmpids);
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
			$G(inputename).value = resourceids;

			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");
			for ( var i = 0; i < resourceidArray.length(); i++) {
				var curid = resourceidArray[i];
				var curname = resourcenameArray[i];
				sHtml = sHtml + curname + "&nbsp";
			}

			$G(spanname).innerHTML = sHtml;
			if (spanname.indexOf("remindobjectidspan") != -1) {
				$G("isother").checked = true;
			} else {
				$G("flownextoperator")[0].checked = false;
				$G("flownextoperator")[1].checked = true;
			}
		} else {
			$G(spanname).innerHTML = "";
			$G(inputename).value = "";
			if (spanname.indexOf("remindobjectidspan") != -1) {
				$G("isother").checked = false;
			} else {
				$G("flownextoperator")[0].checked = true;
				$G("flownextoperator")[1].checked = false;
			}
		}
	}
}

function onShowWorkFlowSerach(inputname, spanname) {

	retValue = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp");
	temp = $G(inputname).value;
	if(retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "0" && wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
			$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
			$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
			
			if (temp != wuiUtil.getJsonValueByIndex(retValue, 0)) {
				$G("frmmain").action = "WFCustomSearch.jsp";
				$G("frmmain").submit();
				enablemenuall();
			}
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
			$G("frmmain").action = "WFSearch.jsp";
			$G("frmmain").submit();
		}
	}
}

function disModalDialogRtnM(url, inputname, spanname) {
	var id = window.showModalDialog(url);
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0);
			var names = wuiUtil.getJsonValueByIndex(id, 1);
			
			if (ids.indexOf(",") == 0) {
				ids = ids.substr(1);
				names = names.substr(1);
			}
			
			$G(inputname).value = ids;
			var sHtml = "";
			
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");
			
			for ( var i = 0; i < ridArray.length; i++) {

				var curid = ridArray[i];
				var curname = rNameArray[i];
				if (i != ridArray.length - 1) sHtml += curname + "，"; 
				else sHtml += curname;
			}
			
			$G(spanname).innerHTML = sHtml;
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
}

function changelevel(tmpindex){
	document.frmmain.check_con[tmpindex*1].checked = true;
}

</script>

<!-- 
<script language="vbs">
sub changelevel(tmpindex)
        
 		document.frmmain.check_con(tmpindex*1).checked = true

end sub

sub onShowBrowser(id,url)

		id1 = window.showModalDialog(url)
		if NOT isempty(id1) then
		        if id1(0)<> "" then
				document.all("con"+id+"_valuespan").innerHtml = id1(1)
				document.all("con"+id+"_value").value=id1(0)
				document.all("con"+id+"_name").value=id1(1)
			else
				document.all("con"+id+"_valuespan").innerHtml = empty
				document.all("con"+id+"_value").value=""
				document.all("con"+id+"_name").value=""
			end if
		end if
end sub
sub onShowBrowser1(id,url,type1)

	if type1= 1 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		document.all("con"+id+"_valuespan").innerHtml = id1
		document.all("con"+id+"_value").value=id1
	elseif type1=2 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		document.all("con"+id+"_value1span").innerHtml = id1
		document.all("con"+id+"_value1").value=id1
	end if
end sub

sub onShowBrowser2(id,url,type1)
    
          if type1=8 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
			elseif type1=9 then
            tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
			elseif type1=1 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			elseif type1=4 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			elseif type1=16 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			else type1=7 
			tmpids =document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
           end if
	//id1 = window.showModalDialog(url)
		if NOT isempty(id1) then
			resourceids = id1(0)
			resourcename = id1(1)
			resourceids = Mid(resourceids,2,len(resourceids))
			resourcename = Mid(resourcename,2,len(resourcename))	
			document.all("con"+id+"_valuespan").innerHtml =resourcename 
			document.all("con"+id+"_value").value=resourceids
			document.all("con"+id+"_name").value=resourcename
			else
			document.all("con"+id+"_valuespan").innerHtml = empty
			document.all("con"+id+"_value").value=""
			document.all("con"+id+"_name").value=""
		 end if
		
end sub





sub onShowMutiHrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
		    if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&curname&"&nbsp"
					wend
					sHtml = sHtml&resourcename&"&nbsp"
					document.all(spanname).innerHtml = sHtml
                    if InStr(spanname,"remindobjectidspan")>0 then
                        document.all("isother").checked=true
                    else
                        document.all("flownextoperator")(0).checked=false
                        document.all("flownextoperator")(1).checked=true
                    end if
                else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
                    if InStr(spanname,"remindobjectidspan")>0 then
                        document.all("isother").checked=false
                    else
                        document.all("flownextoperator")(0).checked=true
                        document.all("flownextoperator")(1).checked=false
                    end if
                end if
			end if
end sub

Sub onShowWorkFlowSerach(inputname, spanname)

	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
	temp=document.all(inputname).value
	If (Not IsEmpty(retValue)) Then
		If retValue(0) <> "0" Then
			document.all(spanname).innerHtml = retValue(1)
			document.all(inputname).value = retValue(0)
			if (temp<>retValue(0)) then
            document.frmmain.action="WFCustomSearch.jsp"
			document.frmmain.submit()
			enablemenuall()
			end if
		Else 
		    document.all(inputname).value = ""
			document.all(spanname).innerHtml = ""
			document.frmmain.action="WFSearch.jsp"
			document.frmmain.submit()
			
		End If
	End If
End Sub
</script>
-->
<script language="javascript">


function submitData()
{
	if (check_form(frmmain,''))
		frmmain.submit();
}

function submitClear()
{
	btnclear_onclick();
}
function enablemenuall()
{
for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++)
		{
		window.frames["rightMenuIframe"].document.all.item(a).disabled=true;
}
//window.frames["rightMenuIframe"].event.srcElement.disabled = true;
}
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>