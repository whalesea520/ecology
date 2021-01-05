<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
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
int iswaitdo= Util.getIntValue(request.getParameter("iswaitdo"),0) ;
String userid = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
String logintype = ""+user.getLogintype();    
int usertype = 0;
if(userid.equals("")) {
	userid = ""+user.getUID();
	if(logintype.equals("2")) usertype= 1;
}
//out.print(Util.numtochinese("4341009009.12"));
String moudle=Util.null2String(request.getParameter("moudle"));
String createrid=Util.null2String(request.getParameter("createrid"));
String docids=Util.null2String(request.getParameter("docids"));
String crmids=Util.null2String(request.getParameter("crmids"));
String hrmids=Util.null2String(request.getParameter("hrmids"));
String prjids=Util.null2String(request.getParameter("prjids"));
String creatertype=Util.null2String(request.getParameter("creatertype"));
String workflowid=""+Util.getIntValue(request.getParameter("workflowid"));
String nodetype=Util.null2String(request.getParameter("nodetype"));
String requeststatus=Util.null2String(request.getParameter("requeststatus"));
if(requeststatus.equals("")) requeststatus=Util.null2String((String)session.getAttribute("requeststatus_"+userid));
String fromdate=Util.null2String(request.getParameter("fromdate"));
String todate=Util.null2String(request.getParameter("todate"));
String lastfromdate=Util.null2String(request.getParameter("lastfromdate"));
String lasttodate=Util.null2String(request.getParameter("lasttodate"));
String requestmark=Util.null2String(request.getParameter("requestmark"));
String branchid=Util.null2String(request.getParameter("branchid"));
int during=Util.getIntValue(request.getParameter("during"),0);
int order=Util.getIntValue(request.getParameter("order"),0);
int isdeleted=Util.getIntValue(request.getParameter("isdeleted"));
String requestname=Util.fromScreen2(request.getParameter("requestname"),user.getLanguage());
requestname=requestname.trim();
int subday1=Util.getIntValue(request.getParameter("subday1"),0);
int subday2=Util.getIntValue(request.getParameter("subday2"),0);
int maxday=Util.getIntValue(request.getParameter("maxday"),0);
int state=Util.getIntValue(request.getParameter("state"),0);
String requestlevel=Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());
String customid=Util.null2String(request.getParameter("customid"));
boolean issimple=Util.null2String(request.getParameter("issimple")).equals("true")?true:false;
String searchtype=Util.null2String(request.getParameter("searchtype"));
int isresearch=Util.getIntValue(request.getParameter("isresearch"),0);
Hashtable conht=new Hashtable();    
if(isresearch==1){
if(requestmark.equals("")) requestmark=Util.null2String((String)session.getAttribute("requestmark_"+userid));
if(isdeleted<0) isdeleted=Util.getIntValue((String)session.getAttribute("isdeleted_"+userid),0);
if(nodetype.equals("")) nodetype=Util.null2String((String)session.getAttribute("nodetype_"+userid));
if(fromdate.equals("")) fromdate=Util.null2String((String)session.getAttribute("fromdate_"+userid));
if(todate.equals("")) todate=Util.null2String((String)session.getAttribute("todate_"+userid));
if(during==0) during=Util.getIntValue((String)session.getAttribute("during_"+userid),0);
//ypc 2012-09-03 注释此行代码
//if(createrid.equals("")) createrid=Util.null2String((String)session.getAttribute("createrid_"+userid));
// ypc System.out.println("Createrid="+createrid);
if(docids.equals("")) docids=Util.null2String((String)session.getAttribute("docids_"+userid));
if(crmids.equals("")) crmids=Util.null2String((String)session.getAttribute("crmids_"+userid));
if(prjids.equals("")) prjids=Util.null2String((String)session.getAttribute("prjids_"+userid));
if(hrmids.equals("")) hrmids=Util.null2String((String)session.getAttribute("hrmids_"+userid));
if(requestname.equals("")) requestname=Util.null2String((String)session.getAttribute("requestname_"+userid));
if(requestlevel.equals("")) requestlevel=Util.null2String((String)session.getAttribute("requestlevel_"+userid));
conht=(Hashtable)session.getAttribute("conhashtable_"+userid);    
}
String tempcustomid=customid;
String isbill="0";
String formID="0";
String customname="";
String workflowname="";
String titlename ="";
if(!customid.equals("")){
    rs.execute("select * from workflow_custom where id="+customid);
    if(rs.next()){
        isbill=Util.null2String(rs.getString("isbill"));
        formID=Util.null2String(rs.getString("formid"));
        customname=Util.null2String(rs.getString("customname"));
        titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+customname;
        workflowid="";
    }
}else{
    isbill=WorkflowComInfo.getIsBill(workflowid);
    formID=WorkflowComInfo.getFormId(workflowid);
    workflowname=WorkflowComInfo.getWorkflowname(workflowid);
    titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+workflowname;
    if(rs.getDBType().equals("oracle")){
        rs.execute("select id from workflow_custom where isbill='"+isbill+"'and formid="+formID+" and (workflowids is null or ','||to_char(workflowids)||',' like '%,'||'"+workflowid+"'||',%') order by id");
    }else{
        rs.execute("select id from workflow_custom where isbill='"+isbill+"'and formid="+formID+" and (workflowids is null or convert(varchar,workflowids) ='' or ','+convert(varchar,workflowids)+',' like '%,'+'"+workflowid+"'+',%') order by id");
    }
    if(rs.next()){
        tempcustomid=Util.null2String(rs.getString("id"));
    }
}
String imagefilename = "/images/hdDOC_wev8.gif";
String needfav ="1";
String needhelp ="";
customid = tempcustomid;
%>
<BODY>
<%  
if(tempcustomid.equals("")){
    response.sendRedirect("/workflow/search/WFCustomSearch.jsp?workflowid="+workflowid+"&issimple="+issimple);
    return;
}
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:location.href='/workflow/search/WFCustomSearchBySimple.jsp?workflowid="+workflowid+"&customid="+customid+"&issimple="+issimple+"&searchtype="+searchtype+"',_self}" ;
RCMenuHeight += RCMenuHeightStep ;
if(issimple){
RCMenu += "{"+SystemEnv.getHtmlLabelName(19048,user.getLanguage())+",javascript:location.href='/workflow/search/WFCustomSearchBySimple.jsp?isresearch="+isresearch+"&workflowid="+workflowid+"&customid="+customid+"&issimple="+!issimple+"&searchtype="+searchtype+"',_top}} " ;
}else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(18016,user.getLanguage())+",javascript:location.href='/workflow/search/WFCustomSearchBySimple.jsp?isresearch="+isresearch+"&workflowid="+workflowid+"&customid="+customid+"&issimple="+!issimple+"&searchtype="+searchtype+"',_top}} " ;
}
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CustomSearch.jsp?searchtype="+searchtype+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="frmmain" method="post" action="WFCustomSearchTemp.jsp">
<input name=iswaitdo type=hidden value="<%=iswaitdo%>">
<input name=workflowid type=hidden value="<%=workflowid%>">
<input name=customid type=hidden value="<%=customid%>">
<input name=issimple type=hidden value="<%=issimple%>">
<input name=searchtype type=hidden value="<%=searchtype%>">
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
  <%if(!issimple){%>
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
    <td><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></td>
    <td class=field>

    <%if (!moudle.equals("1")) {%><button type=button  class=Browser <%if(customid.equals("")){%>onClick="onShowWorkFlowSerach('workflowid','workflowspan')" <%}else{%>onclick="onShowFormWorkFlow('workflowid','workflowspan')"<%}%>></button><%}%>
	<span id=workflowspan>
	<%=workflowname%>
	</span>
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
  </tr><TR style="height:1px;" class=Separartor><TD class="Line" COLSPAN=5></TD></TR>

  <!--TR class=Separartor><TD class="Line1" COLSPAN=5></TD></TR-->
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
	<!-- ypc 2012-09-03 -->
	<input name=branchid type=hidden  value="<%=branchid%>">
    </td>

    </tr>
	<TR style="height:1px;"><TD class="Line" COLSPAN=5></TD></TR>

<!--tr><TD class="Line1" COLSPAN=5></TD></TR-->
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
   <TR style="height:1px;" class=Separartor><TD class="Line" COLSPAN=5></TD></TR>
  <%}else{%>
  <TR class="Title"><th COLSPAN=5><%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%></th></TR>
  <TR style="height:1px;" class=Separartor><TD class="Line1" COLSPAN=5></TD></TR>
  <%}%>
   <input type='checkbox' name='check_con' style="display:none">
<%//以下开始列出自定义查询条件
String sql="";
if(customid.equals("")){
if(isbill.equals("0")){
	//update by td77374
	//下面查询主表属性字段
	String sql1= " select 'B' isdetail, min(Workflow_CustomDspField.queryorder) as queryorder ,min(Workflow_CustomDspField.showorder) as showorder ,Workflow_CustomDspField.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fielddbtype as dbtype, workflow_formdict.fieldhtmltype as httype,workflow_formdict.type as type from Workflow_CustomDspField,Workflow_Custom, workflow_formdict,workflow_fieldlable,workflow_formfield where workflow_formfield.formid="+formID+" and workflow_formfield.fieldid=workflow_fieldlable.fieldid and  Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.formid="+formID+" and Workflow_Custom.isbill='0'  and Workflow_CustomDspField.ifquery='1' and workflow_fieldlable.formid = Workflow_Custom.formid and workflow_fieldlable.isdefault = 1 and workflow_fieldlable.fieldid =Workflow_CustomDspField.fieldid and workflow_formdict.id = Workflow_CustomDspField.fieldid ";
sql1+=" group by Workflow_CustomDspField.fieldid,fieldname,workflow_fieldlable.fieldlable,workflow_formdict.fielddbtype, workflow_formdict.fieldhtmltype,workflow_formdict.type" ;
//下面查询设置的要查询的明细表字段属性
String sql2= "select 'C' isdetail,min(Workflow_CustomDspField.queryorder) as queryorder, min(Workflow_CustomDspField.showorder) as showorder, Workflow_CustomDspField.fieldid as id, fieldname as name, workflow_fieldlable.fieldlable as label, workflow_formdictdetail.fielddbtype as dbtype, workflow_formdictdetail.fieldhtmltype as httype, workflow_formdictdetail.type as type from Workflow_CustomDspField, Workflow_Custom, workflow_formdictdetail, workflow_fieldlable, workflow_formfield where workflow_formfield.formid ="+formID+" and workflow_formfield.fieldid = workflow_fieldlable.fieldid and Workflow_CustomDspField.customid = Workflow_Custom.id and Workflow_Custom.formid ="+formID+" and Workflow_Custom.isbill = '0' and Workflow_CustomDspField.ifquery = '1' and workflow_fieldlable.formid = Workflow_Custom.formid and workflow_fieldlable.isdefault = 1 and workflow_fieldlable.fieldid = Workflow_CustomDspField.fieldid and workflow_formdictdetail.id = Workflow_CustomDspField.fieldid group by Workflow_CustomDspField.fieldid, fieldname, workflow_fieldlable.fieldlable, workflow_formdictdetail.fielddbtype, workflow_formdictdetail.fieldhtmltype, workflow_formdictdetail.type ";  
sql += "select * from( "+sql1+" union all "+sql2 ;
}else if(isbill.equals("1")){
	if(RecordSet.getDBType().equals("oracle")){
		   sql = "select * from (select 'A' isdetail,workflow_billfield.viewtype,min(Workflow_CustomDspField.queryorder) as queryorder ,min(Workflow_CustomDspField.showorder) as showorder ,workflow_billfield.id as id,workflow_billfield.fieldname as name,to_char(workflow_billfield.fieldlabel) as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type from workflow_billfield,Workflow_CustomDspField,Workflow_Custom where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.formid="+formID+" and Workflow_Custom.isbill='1'  and Workflow_CustomDspField.ifquery='1' and workflow_billfield.billid="+formID+"  and   workflow_billfield.id=Workflow_CustomDspField.fieldid ";
	    }else{
			sql = "select * from (select 'A' isdetail,workflow_billfield.viewtype,min(Workflow_CustomDspField.queryorder) as queryorder ,min(Workflow_CustomDspField.showorder) as showorder ,workflow_billfield.id as id,workflow_billfield.fieldname as name,convert(varchar,workflow_billfield.fieldlabel) as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type from workflow_billfield,Workflow_CustomDspField,Workflow_Custom where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.formid="+formID+" and Workflow_Custom.isbill='1'  and Workflow_CustomDspField.ifquery='1' and workflow_billfield.billid="+formID+"  and   workflow_billfield.id=Workflow_CustomDspField.fieldid ";
	    }
	    sql+=" group by workflow_billfield.id,workflow_billfield.fieldname,workflow_billfield.fieldlabel,workflow_billfield.fielddbtype, workflow_billfield.fieldhtmltype,workflow_billfield.type,workflow_billfield.viewtype" ;
}
}else{
if(isbill.equals("0")){
	//下面查询主表属性字段
	String sql1= " select 'B' isdetail, min(Workflow_CustomDspField.queryorder) as queryorder ,min(Workflow_CustomDspField.showorder) as showorder ,Workflow_CustomDspField.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fielddbtype as dbtype, workflow_formdict.fieldhtmltype as httype,workflow_formdict.type as type from Workflow_CustomDspField,Workflow_Custom, workflow_formdict,workflow_fieldlable,workflow_formfield where workflow_formfield.formid="+formID+" and workflow_formfield.fieldid=workflow_fieldlable.fieldid and  Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.formid="+formID+" and Workflow_Custom.isbill='0'  and Workflow_CustomDspField.ifquery='1' and workflow_fieldlable.formid = Workflow_Custom.formid and workflow_fieldlable.isdefault = 1 and workflow_fieldlable.fieldid =Workflow_CustomDspField.fieldid and workflow_formdict.id = Workflow_CustomDspField.fieldid ";
	sql1+=" group by Workflow_CustomDspField.fieldid,fieldname,workflow_fieldlable.fieldlable,workflow_formdict.fielddbtype, workflow_formdict.fieldhtmltype,workflow_formdict.type" ;
	//下面查询设置的要查询的明细表字段属性
	String sql2= "select 'C' isdetail,min(Workflow_CustomDspField.queryorder) as queryorder, min(Workflow_CustomDspField.showorder) as showorder, Workflow_CustomDspField.fieldid as id, fieldname as name, workflow_fieldlable.fieldlable as label, workflow_formdictdetail.fielddbtype as dbtype, workflow_formdictdetail.fieldhtmltype as httype, workflow_formdictdetail.type as type from Workflow_CustomDspField, Workflow_Custom, workflow_formdictdetail, workflow_fieldlable, workflow_formfield where workflow_formfield.formid ="+formID+" and workflow_formfield.fieldid = workflow_fieldlable.fieldid and Workflow_CustomDspField.customid = Workflow_Custom.id and Workflow_Custom.formid ="+formID+" and Workflow_Custom.isbill = '0' and Workflow_CustomDspField.ifquery = '1' and workflow_fieldlable.formid = Workflow_Custom.formid and workflow_fieldlable.isdefault = 1 and workflow_fieldlable.fieldid = Workflow_CustomDspField.fieldid and workflow_formdictdetail.id = Workflow_CustomDspField.fieldid group by Workflow_CustomDspField.fieldid, fieldname, workflow_fieldlable.fieldlable, workflow_formdictdetail.fielddbtype, workflow_formdictdetail.fieldhtmltype, workflow_formdictdetail.type ";  
	sql += "select * from( "+sql1+" union all "+sql2 ;
}else if(isbill.equals("1")){
    if(RecordSet.getDBType().equals("oracle")){
    	sql = "select * from (select 'A' isdetail,workflow_billfield.viewtype,Workflow_CustomDspField.queryorder ,Workflow_CustomDspField.showorder ,workflow_billfield.id as id,workflow_billfield.fieldname as name,to_char(workflow_billfield.fieldlabel) as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type from workflow_billfield,Workflow_CustomDspField,Workflow_Custom where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.id="+customid+" and Workflow_Custom.isbill='1'  and Workflow_CustomDspField.ifquery='1' and workflow_billfield.billid=Workflow_Custom.formid  and   workflow_billfield.id=Workflow_CustomDspField.fieldid ";
    }else{
		sql = "select * from (select 'A' isdetail,workflow_billfield.viewtype,Workflow_CustomDspField.queryorder ,Workflow_CustomDspField.showorder ,workflow_billfield.id as id,workflow_billfield.fieldname as name,convert(varchar,workflow_billfield.fieldlabel) as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type from workflow_billfield,Workflow_CustomDspField,Workflow_Custom where Workflow_CustomDspField.customid=Workflow_Custom.id and Workflow_Custom.id="+customid+" and Workflow_Custom.isbill='1'  and Workflow_CustomDspField.ifquery='1' and workflow_billfield.billid=Workflow_Custom.formid  and   workflow_billfield.id=Workflow_CustomDspField.fieldid ";
    }
}
}
String vpsql=",0 viewtype";
if(isbill.equals("0"))vpsql="";
if(issimple){
	sql+=" union select 'A' isdetail"+vpsql+",queryorder,showorder,fieldid as id,'' as name,'' as label,'' as dbtype,'' as httype,0 as type from Workflow_CustomDspField where ifquery='1' and fieldid in(-1,-2,-3,-4,-5,-6,-7,-8,-9,-10) and customid="+tempcustomid;
}else{
   sql+=" union select 'A' isdetail"+vpsql+",queryorder,showorder,fieldid as id,'' as name,'' as label,'' as dbtype,'' as httype,0 as type from Workflow_CustomDspField where ifquery='1' and fieldid in(-7,-9,-10) and customid="+tempcustomid;
}
sql+=") a order by isdetail,a.queryorder,a.showorder,a.id";
int i=0;
int tmpcount = 0;
RecordSet.execute(sql);
//out.print(sql);
while (RecordSet.next())
{tmpcount++;
i++;
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");
String htmltype = RecordSet.getString("httype");
String type = RecordSet.getString("type");
String id = RecordSet.getString("id");
String isdetail = "";
if(isbill.equals("1")){
	isdetail=RecordSet.getString("viewtype");
}else{
	isdetail=RecordSet.getString("isdetail").equals("C")?"1":"";
}
String dbtype = Util.null2String(RecordSet.getString("dbtype"));
if(isbill.equals("1"))
	label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
if(isdetail.equals("1"))label+="("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+")";
/*
 初始化创建日期   -3
 节点类型         -6
 创建人           -4
 接收日期         -7
 工作流           -5
 当前状况         -8
 紧急程度         -2
 未操作者         -9
 请求说明         -1
*/
if(id.equals("-1")){
    id="_1";
    name="requestname";
    label=SystemEnv.getHtmlLabelName(1334,user.getLanguage());
    htmltype="1";
    type="1";
}else if(id.equals("-2")){
    id="_2";
    name="requestlevel";
    label=SystemEnv.getHtmlLabelName(15534,user.getLanguage());
    htmltype="5";
    type="1";
}else if(id.equals("-3")){
    id="_3";
    name="createdate";
    label=SystemEnv.getHtmlLabelName(722,user.getLanguage());
    htmltype="3";
    type="2";
}else if(id.equals("-4")){
    id="_4";
    name="creater";
    label=SystemEnv.getHtmlLabelName(882,user.getLanguage());
    htmltype="3";
    type="17";
}else if(id.equals("-5")){
    id="_5";
    name="workflowid";
    label=SystemEnv.getHtmlLabelName(259,user.getLanguage());
    htmltype="3";
    type="-5";
}else if(id.equals("-6")){
    id="_6";
    name="nodetype";
    label=SystemEnv.getHtmlLabelName(15536,user.getLanguage());
    htmltype="5";
    type="1";
}else if(id.equals("-7")){
    id="_7";
    name="receivedate";
    label=SystemEnv.getHtmlLabelName(17994,user.getLanguage());
    htmltype="3";
    type="2";
}else if(id.equals("-8")){
    id="_8";
    name="isdeleted";
    label=SystemEnv.getHtmlLabelName(169,user.getLanguage());
    htmltype="5";
    type="1";
}else if(id.equals("-9")){
    id="_9";
    name="userid";
    label=SystemEnv.getHtmlLabelName(16354,user.getLanguage());
    htmltype="3";
    type="1";
}else if(id.equals("-10")){
    id="_10";
    name="requeststatus";
    label=SystemEnv.getHtmlLabelName(19061,user.getLanguage());
    htmltype="5";
    type="1";
}
String display="display:'';";
if(issimple) display="display:none;";
String checkstr="";
if("1".equals(conht.get("con_"+id))) checkstr="checked";
String tmpvalue="";
String tmpvalue1="";
String tmpname="";
if(isresearch==1){
    tmpvalue=Util.null2String((String)conht.get("con_"+id+"_value"));
    tmpvalue1=Util.null2String((String)conht.get("con_"+id+"_value1"));
    tmpname=Util.null2String((String)conht.get("con_"+id+"_name"));
}
%>
<input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
<input type=hidden name="con<%=id%>_type" value="<%=type%>">
<input type=hidden name="con<%=id%>_colname" value="<%=name%>">

<%if (i%2 !=0) {%><tr><%}%>
<td><input type='checkbox' name='check_con' title="<%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%>" value="<%=id%>" style="display:none" <%=checkstr%>> <%=label%></td>
<%
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){  //文本框
    int tmpopt=3;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),3);
%>
<td class=field>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<%if(!htmltype.equals("2")){//TD9319 屏蔽掉多行文本框的“等于”和“不等于”操作，text数据库类型不支持该判断%>
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>     <!--等于-->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>   <!--不等于-->
<%}%>
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>   <!--包含-->
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>   <!--不包含-->

</select>
<input type=text class=InputStyle style="width:50%" name="con<%=id%>_value"   onblur="changelevel(this,'<%=tmpcount%>')" value="<%=tmpvalue%>">
<SPAN id=remind style='cursor:hand' title='<%=SystemEnv.getHtmlLabelName(84556,user.getLanguage())%>'>
<IMG src='/images/remind_wev8.png' align=absMiddle>
</SPAN>    
</td>
<%}
else if(htmltype.equals("1")&& !type.equals("1")){  //数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->
    int tmpopt=2;
    int tmpopt1=4;
    if(isresearch==1) {
        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),2);
        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),4);
    }
%>
<td class=field>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value" onblur="checknumber('con<%=id%>_value');changelevel1(this,$G('con<%=id%>_value1'),'<%=tmpcount%>')" value="<%=tmpvalue%>">
<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value1"  onblur="checknumber('con<%=id%>_value1');changelevel1(this,$G('con<%=id%>_value'),'<%=tmpcount%>')" value="<%=tmpvalue1%>">
</td>
<%
}
else if(htmltype.equals("4")){   //check类型
%>
<td class=field >
<input type=checkbox value=1 name="con<%=id%>_value"  onchange="changelevel(this,'<%=tmpcount%>')" <%if(tmpvalue.equals("1")){%>checked<%}%>>

</td>
<%}
else if(htmltype.equals("5")){  //选择框
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>

<td class=field>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>

<select class=inputstyle  name="con<%=id%>_value"  onchange="changelevel(this,'<%=tmpcount%>')" >
<option value="" ></option>
<%
char flag=2;
if(id.equals("_6")){
%>
    <option value="0" <%if (nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
    <option value="1" <%if (nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
    <option value="2" <%if (nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
    <option value="3" <%if (nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
<%
}else if(id.equals("_2")){
%>
    <option value="0" <%if (requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
	<option value="1" <%if (requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
	<option value="2" <%if (requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
<%
}else if(id.equals("_8")){
%>
    <option value="0" <%if (isdeleted==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
    <option value="1" <%if (isdeleted==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
    <option value="2" <%if (isdeleted==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
<%
}else if(id.equals("_10")){
	%>
		<option value="0" <%if (requeststatus.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16658,user.getLanguage())%></option>
		<option value="1" <%if (requeststatus.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24627,user.getLanguage())%></option>
		<option value="2" <%if (requeststatus.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22487,user.getLanguage())%></option>
		<option value="3" <%if (requeststatus.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2084,user.getLanguage())%></option>
		<option value="4" <%if (requeststatus.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19081,user.getLanguage())%></option>
		<option value="5" <%if (requeststatus.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21950,user.getLanguage())%></option>
	<%
}else{
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
%>
<option value="<%=tmpselectvalue%>" <%if (tmpvalue.equals(""+tmpselectvalue)) {%>selected<%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
<%}
}%>
</select>
</td>

<%} else if(htmltype.equals("3") && type.equals("1")){//浏览框单人力资源  条件为多人力 (like not lik)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("9")){//浏览框单文挡  条件为多文挡 (like not lik)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("4")){//浏览框单部门  条件为多部门 (like not lik)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
	<%} else if(htmltype.equals("3") && type.equals("7")){//浏览框单客户  条件为多客户 (like not lik)
        int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
<%} else if(htmltype.equals("3") && type.equals("8")){//浏览框单项目  条件为多项目 (like not lik)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
<%} else if(htmltype.equals("3") && type.equals("16")){//浏览框单请求  条件为多请求 (like not lik)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
<%}else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别
    int tmpopt=1;
    int tmpopt1=3;
    if(isresearch==1) {
        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),3);
    }
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value"  onblur="changelevel1(this,$G('con<%=id%>_value1'),'<%=tmpcount%>')"  value="<%=tmpvalue%>">
<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value1"  onblur="changelevel1(this,$G('con<%=id%>_value'),'<%=tmpcount%>')"  value="<%=tmpvalue1%>" >
</td>
<%}//职位安全级别end

else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //日期
    int tmpopt=2;
    int tmpopt1=4;
    if(isresearch==1) {
        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),2);
        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),4);
    }
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%><%}%>
<button type=button  class=calendar
<%if(type.equals("2")){%>
 onclick="onSearchWFQTDate(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1,'<%=tmpcount%>')"
<%}else{%>
 onclick ="onSearchWFQTTime(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1,'<%=tmpcount%>')"
<%}%>
 ></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpvalue%></span>
<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%><%}%>
<button type=button  class=calendar
<%if(type.equals("2")){%>
 onclick="onSearchWFQTDate(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value,'<%=tmpcount%>')"
<%}else{%>
 onclick ="onSearchWFQTTime(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value,'<%=tmpcount%>')"
<%}%>
 ></button>
<input type=hidden name="con<%=id%>_value1" value="<%=tmpvalue1%>">
<span name="con<%=id%>_value1span" id="con<%=id%>_value1span"><%=tmpvalue1%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("17")){
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("37")){//浏览框  多选筐条件为单选筐(多文挡)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("57")){//浏览框  多选筐条件为单选筐（多部门）
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("135")){//浏览框  多选筐条件为单选筐（多项目 ）
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("152")){//浏览框  多选筐条件为单选筐（多请求 ）
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("18")){//浏览框  多选筐条件为单选筐
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%}
else if(htmltype.equals("3") && type.equals("160")){//浏览框  多选筐条件为单选筐
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if (htmltype.equals("3") && (type.equals("224") || type.equals("225")||type.equals("226") || type.equals("227"))){
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
	if(type.equals("226") || type.equals("227")){
		urls+="?type="+dbtype+"|"+id+"&fromReport=1&fromReportformid="+formID+"&fromReportisbill="+isbill;
	}else{
		urls+="?type="+dbtype+"|"+id+"&fromReport=1&fromReportformid="+formID+"&fromReportisbill="+isbill;
	}
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
	<td class=field >
	<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
	<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
	<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
	</select>
	<button type=button  class=Browser onclick="onShowBrowser2('<%=id%>','<%=urls%>','<%=type%>','<%=tmpcount%>')"></button>
	<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
	<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
	<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
	</td>
<%
} else if(htmltype.equals("3") && type.equals("142")){//浏览框多收发文单位
String urls = "/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp";
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
<button type=button  class=Browser onclick="onShowBrowser('<%=id%>','<%=urls%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%}
else if(htmltype.equals("3") && (type.equals("141")||type.equals("56")||type.equals("27")||type.equals("118")||type.equals("65")||type.equals("64")||type.equals("137"))){//浏览框
String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowser('<%=id%>','<%=urls%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%}
else if(htmltype.equals("3") && id.equals("_5")){//工作流浏览框
    tmpname="";
    ArrayList tempvalues=Util.TokenizerString(tmpvalue,",");
    for(int k=0;k<tempvalues.size();k++){
        if(tmpname.equals("")){
            tmpname=WorkflowComInfo.getWorkflowname((String)tempvalues.get(k));
        }else{
            tmpname+=","+WorkflowComInfo.getWorkflowname((String)tempvalues.get(k));
        }
    }
%>
<td class=field >
<input type=hidden  name="con<%=id%>_opt" value="1">
<%if(customid.equals("")){%>
<button type=button  class=Browser onClick="onShowWorkFlowSerach('workflowid','workflowspan')"></button>
<span id=workflowspan>
	<%=workflowname%>
</span>
<%}else{%>
<button type=button  class=Browser onclick="onShowCQWorkFlow('con<%=id%>_value','con<%=id%>_valuespan','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
<%}%>
</td>
<%} else if (htmltype.equals("3") && (type.equals("161") || type.equals("162"))){
    String urls=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype;     // 自定义浏览按钮
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>

<button class=Browser onclick="onShowBrowserCustom('<%=id%>','<%=urls%>','<%=tmpcount%>','<%=type%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if (htmltype.equals("3")){
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowser('<%=id%>','<%=urls%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if (htmltype.equals("6")){   //附件上传同多文挡
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"   >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%}else{
%>
  <td class=field>&nbsp;</td>
<%
}
%>
<%if (i%2 !=0) {%><td>&nbsp;</td><%}%>
<%if (i%2 ==0) {%></tr>
<TR class=Separartor style="height:1px;"><td class=field class="Line" COLSPAN=5></TD></TR><%}%>
<%
}%>
<%if (i%2 !=0) {%></tr>
<TR class=Separartor style="height:1px;"><td class=field class="Line" COLSPAN=5></TD></TR><%}%>  
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
<script language="javascript" src="/js/datetime_wev8.js"></script>

<script language="javascript">

function onShowFormWorkFlow(inputname, spanname) {
	var tmpids = $G(inputname).value;
	var url = uescape("?customid=<%=customid%>&value=<%=isbill%>_<%=formID%>_"
			+ tmpids);
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"
			+ url;

	disModalDialogRtnM(url, inputname, spanname);
}
function onShowCQWorkFlow(inputname, spanname, tmpindex) {
	var tmpids = $G(inputname).value;
	var url = uescape("?customid=<%=customid%>&value=<%=isbill%>_<%=formID%>_"
			+ tmpids);
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"
			+ url;

	disModalDialogRtnM(url, inputname, spanname);
	if ($G(inputname).value == "") {
		document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	} else {
		document.getElementsByName("check_con")[tmpindex * 1].checked = true;
	}
}

function submitData()
{
	if (check_form(frmmain,''))
		document.frmmain.submit();
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
function changelevel(obj,tmpindex){
    if(obj.value!=""){
 		document.frmmain.check_con[tmpindex*1].checked = true;
    }else{
        document.frmmain.check_con[tmpindex*1].checked = false;
    }
}
function changelevel1(obj1,obj,tmpindex){
    if(obj.value!=""||obj1.value!=""){
 		document.frmmain.check_con[tmpindex*1].checked = true;
    }else{
        document.frmmain.check_con[tmpindex*1].checked = false;
    }
}
function onSearchWFQTDate(spanname,inputname,inputname1,tmpindex){
	var oncleaingFun = function(){
		  $(spanname).innerHTML = '';
		  $(inputname).value = '';
          if($(inputname).value==""&&$(inputname1).value==""){
              document.frmmain.check_con[tmpindex*1].checked = false;
          }
		}
		var language=readCookie("languageidweaver");
		if(language==8)
			languageStr ="en";
		else if(language==9)
			languageStr ="zh-tw";
		else
			languageStr ="zh-cn";
		if(window.console){
		   //console.log("language "+language+" languageStr="+languageStr);
		}
		WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;document.frmmain.check_con[tmpindex*1].checked = true;},oncleared:oncleaingFun});
}
function onSearchWFQTTime(spanname,inputname,inputname1,tmpindex){
    var dads  = document.all.meizzDateLayer2.style;
    setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop;
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft;
	var ttyp  = spanname.type;
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop;
		tleft += spanname.offsetLeft;
	}
	dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
	dads.left = tleft;
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
    CustomQuery=1;
    outValue1 = inputname1;
    outValue2=tmpindex;
}
function uescape(url){
    return escape(url);
}
function mouseover(){
	this.focus();
}
//window.frames["rightMenuIframe"].document.body.attachEvent("onmouseover",mouseover);    
if (window.addEventListener){
	window.frames["rightMenuIframe"].document.body.addEventListener("mouseover", mouseover, false);
}else if (window.attachEvent){
	window.frames["rightMenuIframe"].document.body.attachEvent("onmouseover", mouseover);
}else{
	window.frames["rightMenuIframe"].document.body.onmouseover=mouseover;
}	

</script>



<script type="text/javascript">

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			var ret_id = wuiUtil.getJsonValueByIndex(id, 0);
			var ret_name = wuiUtil.getJsonValueByIndex(id, 1);
			if(ret_id.indexOf(",")==0){
				ret_id = ret_id.substring(1);
				ret_name = ret_name.substring(1);
			}
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ ret_id + "'>"
						+ ret_name + "</a>";
			} else {
				spanobj.innerHTML = ret_name;
			}
			inputobj.value = ret_id;
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
	
	//ypc 2012-09-03 修改
	//此处的$("createrid") 的id 传入错误 导致获取不到选中的分支机构的 id 所以后面把分支机构作为查询条件的时候查询不出该分支机构下的流程
	//disModalDialog(url, $G("branchspan"), $G("createrid"), false); 
	disModalDialog(url, $G("branchspan"), $G("branchid"), false);
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
	if(type1==224||type1==225||type1==226||type1==227){
			tmpids = $G("con" + id + "_value").value;
			id1 = window.showModalDialog(url);
			if(id1){
				var _value="";
				if (id1 != null) {
					if(type1==224||type1==225){
						_value=id1.id;
					}else{
						_value=id1[0];
					}
				}
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
					$G("con" + id + "_valuespan").innerHTML = _value;
					jQuery("input[name=con" + id + "_value]").val(_value);
					jQuery("input[name=con" + id + "_name]").val(_value);
				} else {
					$G("con" + id + "_valuespan").innerHTML = "";
					$G("con" + id + "_value").value = "";
					$G("con" + id + "_name").value = "";
				}
			}
	}else{
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
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=<%=xssUtil.put(" where isvalid='1' ")%>");
	temp = $G(inputname).value;
	if(retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "0" && wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
			$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
			$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
			
			if (temp != wuiUtil.getJsonValueByIndex(retValue, 0)) {
				$G("frmmain").action = "WFCustomSearchBySimple.jsp";
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

function onShowBrowserCustom(id,url,tmpindex,type1){
	  var tmpids = $G("con" + id + "_value").value;
	  var urlarry = url.split("url=");
	  var urls = urlarry[0]+"url="+escape(urlarry[1]+"&beanids="+tmpids);
	  id1 = window.showModalDialog(urls);
	  //alert(id1);
	  if(id1!=null){
		  resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
          resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
          resourcedesc = wuiUtil.getJsonValueByIndex(id1, 2);
	      if(resourceids!= ""){
		      if(type1 == 161){
		          ids = resourceids;
		          names = resourcename;
		          descs = resourcedesc;
		    	  $G("con"+id+"_valuespan").innerHTML = ""+names+"&nbsp;";
		    	  $G("con"+id+"_value").value=ids;
		    	  $G("con"+id+"_name").value=names;
		      }
		     if(type1 == 162){
		    	 ids = resourceids.substr(1);
	             names = resourcename.substr(1);
	             descs = resourcedesc.substr(1);
			     var sHtml = "";
			     var resourceidArray = ids.split(",");
		         var resourcenameArray = names.split(",");
		         var resourcedescArray = descs.split(",");
		         //alert(ids);
		         for ( var i = 0; i < resourceidArray.length; i++) {
		                var curid = resourceidArray[i];
		                var curname = resourcenameArray[i];
		                var curdesc = resourcedescArray[i];
		                if(curname!=''){
		                	sHtml += curname + "&nbsp;";	
		                }
		            }
			     
		         //$G(spanname).innerHTML = sHtml;
			     $G("con"+id+"_valuespan").innerHTML = sHtml;
			     $G("con"+id+"_value").value=ids;
			     $G("con"+id+"_name").value=names;
		    }
	   }else{
		   $G("con"+id+"_valuespan").innerHTML = "";
		   $G("con"+id+"_value").value="";
		   $G("con"+id+"_name").value="";
	   }
	  }
	  if ($G("con" + id + "_value").value == "") {
	        document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	  } else {
	        document.getElementsByName("check_con")[tmpindex * 1].checked = true;
	  }
	}

</script>

</body>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>