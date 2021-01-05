 <%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ page import="java.math.*" %>
 <%@ page import="weaver.fna.budget.BudgetHandler"%>
 <jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
 <jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
 <jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
 <jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
 <jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
 <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>
<%

boolean wfmonitor="true".equals(session.getAttribute(userid+"_"+requestid+"wfmonitor"))?true:false;                //流程监控人
%>
 <form name="frmmain" method="post" action="FnaBudgetChgApplyOperation.jsp" enctype="multipart/form-data">
 <input type="hidden" name="needwfback" id="needwfback" value="1" />
 <input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
 <input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
 <input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>

     <%@ include file="/workflow/request/WorkflowManageRequestBody.jsp" %>

     <script language=javascript>
         fieldorders = new Array() ;
         isedits = new Array() ;
         ismands = new Array() ;
         var organizationidismand=0;
         var organizationidisedit=0;
         var _FnaBillRequestJsFlag = 1;
     </script>
	<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
     <script type='text/javascript' src='/dwr/interface/BudgetHandler.js'></script>
     <script type='text/javascript' src='/dwr/engine.js'></script>
     <script type='text/javascript' src='/dwr/util.js'></script>
	<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<script type="text/javascript">
var browserUtl_subject = "<%=new BrowserComInfo().getBrowserurl("22")+"%26fromWfFnaBudgetChgApply=1" %>";
var browserUtl_hrm = "<%=new BrowserComInfo().getBrowserurl("1") %>%3Fshow_virtual_org=-1";
var browserUtl_dep = "<%=new BrowserComInfo().getBrowserurl("4") %>%3Fshow_virtual_org=-1";
var browserUtl_sub = "<%=new BrowserComInfo().getBrowserurl("164") %>%3Fshow_virtual_org=-1";
var browserUtl_prj = "<%=new BrowserComInfo().getBrowserurl("8") %>";
var browserUtl_crm = "<%=new BrowserComInfo().getBrowserurl("7") %>";
var browserUtl_fcc = "<%=new BrowserComInfo().getBrowserurl("251") %>";
</script>
<%
//获取明细表设置
WFNodeDtlFieldManager.resetParameter();
WFNodeDtlFieldManager.setNodeid(Util.getIntValue(""+nodeid));
WFNodeDtlFieldManager.setGroupid(0);
WFNodeDtlFieldManager.selectWfNodeDtlField();
String dtladd = WFNodeDtlFieldManager.getIsadd();
String dtledit = WFNodeDtlFieldManager.getIsedit();
String dtldelete = WFNodeDtlFieldManager.getIsdelete();
String dtldefault = WFNodeDtlFieldManager.getIsdefault();
String dtlneed = WFNodeDtlFieldManager.getIsneed();

RecordSet rs_11 = new RecordSet();
boolean fnaBudgetOAOrg = false;//OA组织机构
boolean fnaBudgetCostCenter = false;//成本中心
rs_11.executeSql("select * from FnaSystemSet");
if(rs_11.next()){
	fnaBudgetOAOrg = 1==rs_11.getInt("fnaBudgetOAOrg");
	fnaBudgetCostCenter = 1==rs_11.getInt("fnaBudgetCostCenter");
}

int subjectFieldId = 0;
RecordSet.executeSql("select * from workflow_billfield where billid = 159  and   fieldname='subject' ");
if(RecordSet.next()){
	subjectFieldId = RecordSet.getInt("id");
}

String uid = "" + creater;

String uname = ResourceComInfo.getLastname(uid);
String udept = ResourceComInfo.getDepartmentID(uid);
String udeptname = DepartmentComInfo.getDepartmentname(udept);
String usubcom = DepartmentComInfo.getSubcompanyid1(udept);
weaver.hrm.company.SubCompanyComInfo scci = new weaver.hrm.company.SubCompanyComInfo();
String usubcomname = scci.getSubCompanyname(usubcom);
int colcount = 0;
int colwidth = 0 ;

String temporganizationidisview="0";
String temporganizationidisedit="0";
String temporganizationidismandatory="0";
String temprogtypeisview="0";

setFieldPropertiesList(RecordSet, fieldids, fieldlabels,  fieldhtmltypes, fieldtypes, fieldnames, fieldviewtypes, formid);

// 确定字段是否显示，是否可以编辑，是否必须输入
isfieldids.clear() ;              //字段队列
isviews.clear() ;              //字段是否显示队列
isedits.clear() ;              //字段是否可以编辑队列
ismands.clear() ;              //字段是否必须输入队列

RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
	String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
	int thefieldidindex = fieldids.indexOf( thefieldid ) ;
	if( thefieldidindex == -1 ) continue ;
	String theisview = Util.null2String(RecordSet.getString("isview")) ;
	String theisedit = Util.null2String(RecordSet.getString("isedit"));
	String theismandatory = Util.null2String(RecordSet.getString("ismandatory"));
	String thefieldname=(String)fieldnames.get(thefieldidindex);
	//                 if(nodetype.equals("0")){
	//                     if(thefieldname.equals("organizationtype")||thefieldname.equals("organizationid")||thefieldname.equals("budgetperiod")||thefieldname.equals("subject")){
	//                        theisview="1";
	//                        theisedit="1";
	//                        theismandatory="1";
	//                    }
	//                 }
	if(thefieldname.equals("organizationid")){
		temporganizationidisview=theisview;
		temporganizationidisedit=theisedit;
		temporganizationidismandatory=theismandatory;
	}
	if(thefieldname.equals("organizationtype")) temprogtypeisview=theisview;
	if( theisview.equals("1") ) colcount ++ ;
	isfieldids.add(thefieldid);
	isviews.add(theisview);
	isedits.add(theisedit);
	ismands.add(theismandatory);
}
if(temporganizationidisview.equals("1")&&temprogtypeisview.equals("0")) colcount++;
if( colcount != 0 ) colwidth = 95/colcount ;

ArrayList viewfieldnames = new ArrayList() ;

// 得到每个字段的信息并在页面显示
int detailfieldcount = -1 ;
String needcheckdtl="";

int recorderindex = 0 ;
%>

<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelName(27575,user.getLanguage()) %>'>
		<wea:item type="groupHead">
			&nbsp;
			<%if(dtladd.equals("1")){%>
            <input type=button  Class="addbtn" type=button accessKey=A onclick="addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
            <%}%>
            <%if(dtladd.equals("1") || dtldelete.equals("1")){%>
            <input type=button  Class="delbtn" type=button accessKey=E onclick="deleteRow1();" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></input>
            <%} %>
		</wea:item>
		<wea:item attributes="{\"isTableList\":\"true\"}">
             <table class="ListStyle" cellspacing=1   id="oTable">
               <COLGROUP>
               <tr class=header>
               <td width="5%">&nbsp;</td>
               
<%
for(int i=0;i<fieldids.size();i++){         // 循环开始

	String fieldid=(String)fieldids.get(i);  //字段id
	String isview="0" ;    //字段是否显示
	String isedit="0" ;    //字段是否可以编辑
	String ismand="0" ;    //字段是否必须输入

	int isfieldidindex = isfieldids.indexOf(fieldid) ;
	if( isfieldidindex != -1 ) {
	 isview=(String)isviews.get(isfieldidindex);    //字段是否显示
	 isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
	 ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
	}
	String fieldname = "" ;                         //字段数据库表中的字段名
	String fieldlable = "" ;                        //字段显示名
	int languageid = 0 ;

	fieldname=(String)fieldnames.get(i);
	if(! isview.equals("1") &&fieldname.equals("organizationtype")){
		isview=temporganizationidisview;
		isedit=temporganizationidisedit;
		ismand=temporganizationidismandatory;
	}
	if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环


	languageid = user.getLanguage() ;
	fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(i),0),languageid );

	viewfieldnames.add(fieldname) ;
%>
                 <td width="<%=colwidth%>%"><%=fieldlable%></td>
                 <script language=javascript>
<% 
	if (fieldname.equals("organizationid")) { 
		detailfieldcount++ ;
		if(ismand.equals("1")) needcheckdtl += ",organizationid_\"+insertindex+\"";
%>
                     fieldorders[<%=detailfieldcount%>] = 1 ;
                     organizationidismand=<%=ismand%>;
                     organizationidisedit=<%=isedit%>;
<% 
	} else if (fieldname.equals("subject")) { 
		detailfieldcount++ ;
		if(ismand.equals("1")) needcheckdtl += ",subject_\"+insertindex+\"";
%>
                     fieldorders[<%=detailfieldcount%>] = 2 ;
<% 
	} else if (fieldname.equals("budgetperiod")) {
		detailfieldcount++ ;
		if(ismand.equals("1")) needcheckdtl += ",budgetperiod_\"+insertindex+\"";
%>
                     fieldorders[<%=detailfieldcount%>] = 3 ;
<% 
	} else if (fieldname.equals("relatedprj")) {
		detailfieldcount++ ;
		if(ismand.equals("1")) needcheckdtl += ",relatedprj_\"+insertindex+\"";
%>
                     fieldorders[<%=detailfieldcount%>] = 4 ;
<% 
	} else if (fieldname.equals("relatedcrm")) { 
		detailfieldcount++ ;
		if(ismand.equals("1")) needcheckdtl += ",relatedcrm_\"+insertindex+\"";
%>
                     fieldorders[<%=detailfieldcount%>] = 5 ;
<%
	} else if (fieldname.equals("description")) { 
		detailfieldcount++ ;
		if(ismand.equals("1")) needcheckdtl += ",description_\"+insertindex+\"";
%>
                     fieldorders[<%=detailfieldcount%>] = 6 ;
<% 
	} else if (fieldname.equals("oldamount")) { 
		detailfieldcount++ ;
%>
                     fieldorders[<%=detailfieldcount%>] = 7 ;
<% 
	} else if (fieldname.equals("applyamount")) { 
		detailfieldcount++ ;
		if(ismand.equals("1")) needcheckdtl += ",applyamount_\"+insertindex+\"";
%>
                     fieldorders[<%=detailfieldcount%>] = 8 ;
<% 
	}else if (fieldname.equals("amount")) {
		detailfieldcount++ ;
		if(ismand.equals("1")) needcheckdtl += ",amount_\"+insertindex+\"";
%>
                     fieldorders[<%=detailfieldcount%>] = 9 ;
<% 
	} else if (fieldname.equals("changeamount")) { 
		detailfieldcount++ ;
%>
                     fieldorders[<%=detailfieldcount%>] = 10 ;
<% 
	} else if (fieldname.equals("organizationtype")) { 
		detailfieldcount++ ;
		if(ismand.equals("1")) needcheckdtl += ",organizationtype_\"+insertindex+\"";
%>
                     fieldorders[<%=detailfieldcount%>] = 11 ;
<% 
	} 
%>
                     isedits[<%=detailfieldcount%>] = <%=isedit%> ;
                     ismands[<%=detailfieldcount%>] = <%=ismand%> ;
                 </script>
<%          
}
sql="select *  from Bill_FnaBudgetChgApplyDetail where id="+billid+" order by dsporder";
RecordSet.executeSql(sql);
while(RecordSet.next()) {
	recorderindex ++ ;
}
%>
               </tr>
<!--页面过大，将显示明细信息拆分-->
<jsp:include page="/workflow/request/ManageFnaBudgetChgApply1.jsp" flush="true">
	<jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />

    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="deleted" value="<%=deleted%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="nextnodetype" value="<%=nextnodetype%>" />
    <jsp:param name="isreopen" value="<%=isreopen%>" />
    <jsp:param name="isreject" value="<%=isreject%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	<jsp:param name="currentdate" value="<%=currentdate%>" />
	<jsp:param name="currenttime" value="<%=currenttime%>" />
	<jsp:param name="docfileid" value="<%=docfileid%>" />
    <jsp:param name="newdocid" value="<%=newdocid%>" />
    <jsp:param name="topage" value="<%=topage%>" />
    <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
    <jsp:param name="dtldelete" value="<%=dtldelete%>" />
   
    <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />
</jsp:include>
             </table>
		</wea:item>
	</wea:group>
</wea:layout>
     <br>
     <input type='hidden' id=nodesnum name=nodesnum value="<%=recorderindex%>">
	 <input type='hidden' id="indexnum" name="indexnum" value="<%=recorderindex%>">
	 <input type='hidden' id=rowneed name=rowneed value="<%=dtlneed %>">
<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">

     <%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
 </form>



 <script language=javascript>
 document.all("needcheck").value+=",<%=needcheck%>";
 rowindex = <%=recorderindex%> ;
 insertindex=<%=recorderindex%>;
 deleteindex=0;
 deletearray = new Array() ;
 thedeletelength=0;

 function addRow()
 {
	 var rowColor = getRowClassName();
     oRow = oTable.insertRow(rowindex+1);
	 curindex=parseInt( $GetEle('nodesnum').value);
     for(j=0; j < fieldorders.length+1; j++) {
         oCell = oRow.insertCell(-1); 
         oCell.style.height=24;
         //oCell.style.background= rowColor;
         oCell.className = rowColor;
         if( j == 0 ) {
             var oDiv = document.createElement("div");
             var sHtml = "<input type='checkbox' name='check_node' value='"+insertindex+"'>";
             oDiv.innerHTML = sHtml;
             oCell.appendChild(oDiv);
         } else {
             dsporder = fieldorders[j-1] ;
             isedit = isedits[j-1] ;
             ismand = ismands[j-1] ;

             if( isedit != 1 ) {
                 switch (dsporder) {
                     case 1 :
                        var oDiv = document.createElement("div");
                        <%if(fnaBudgetOAOrg){ %>
                        var sHtml = "<span id='organizationspan_"+insertindex+"'>" ;
                        sHtml += "<a href='/hrm/company/HrmDepartmentDsp.jsp?id=<%=udept%>'><%=udeptname%></a>"; sHtml += "</span><input type=hidden id='organizationid_"+insertindex+"' name='organizationid_"+insertindex+"' value='<%=udept%>'>" ;
                        <%}else{ %>
                        var sHtml = "";
                        <%} %>
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                     case 8 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='oldamountspan_"+insertindex+"'></span><input type=hidden id='oldamount_"+insertindex+"' name='oldamount_"+insertindex+"' value=''>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 10 :
                        var oDiv = document.createElement("div");
                        sHtml = "<span id='changeamountspan_"+insertindex+"'></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 11 :
                         var oDiv = document.createElement("div");
                         <%if(fnaBudgetOAOrg){ %>
                         var sHtml = "<input type=hidden id='organizationtype_"+insertindex+"' name='organizationtype_"+insertindex+"' value=3><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>" ;
                         <%}else{ %>
                         var sHtml = "";
                         <%} %>
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    default:
                        var oDiv = document.createElement("div");
                        var sHtml = "&nbsp;";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                 }
             } else {
                 switch (dsporder)  {
                     case 1 :
                         var oDiv = document.createElement("div");

					    oDiv.innerHTML = "<span id='organizationid_"+insertindex+"wrapspan'></span>"+
					    	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"organizationid_"+insertindex+"\" id=\"organizationid_"+insertindex+"\" value=\"\">"+
					    	"";
					    oCell.appendChild(oDiv);

                        <%if(fnaBudgetOAOrg){ %>
                        onShowOrganizationBtn(ismand, insertindex, "<%=udept %>", "<%=udeptname %>");
                        <%}else if(fnaBudgetCostCenter){ %>
                        onShowOrganizationBtn(ismand, insertindex, "", "");
                        <%} %>
                        
                        break ;
                     case 2 :
                         var oDiv = document.createElement("div");

                         var detailbrowclick = "onShowBrowser2_fna('subject_"+insertindex+"','"+browserUtl_subject+"','','22','"+ismand+"')";
                         oDiv.innerHTML = "<span id='subject_"+insertindex+"wrapspan'></span>"+
                         	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"subject_"+insertindex+"\" id=\"subject_"+insertindex+"\" value=\"\">"+
                         	"";
                         oCell.appendChild(oDiv);
                         
                         onShowSubjectBtn("subject_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=22" );
                         //initE8Browser("subject_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=22&bdf_wfid=<%=workflowid%>&bdf_fieldid=<%=subjectFieldId%>");
                         
                         break ;
                     case 3 :
                        var oDiv = document.createElement("div");

                        var detailbrowclick = "onShowBrowser2_fna('budgetperiod_"+insertindex+"','','','2','"+ismand+"')";
                        oDiv.innerHTML = "<span id='budgetperiod_"+insertindex+"wrapspan'></span>"+
                        	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"budgetperiod_"+insertindex+"\" id=\"budgetperiod_"+insertindex+"\" value=\"\">"+
                        	"";
                        oCell.appendChild(oDiv);

                        initE8Browser("budgetperiod_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "");
                        
                        break ;
                     case 4 :
                         var oDiv = document.createElement("div");

                         var detailbrowclick = "onShowBrowser2_fna('relatedprj_"+insertindex+"','"+browserUtl_prj+"','','8','"+ismand+"')";
                         oDiv.innerHTML = "<span id='relatedprj_"+insertindex+"wrapspan'></span>"+
                         	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"relatedprj_"+insertindex+"\" id=\"relatedprj_"+insertindex+"\" value=\"\">"+
                         	"";
                         oCell.appendChild(oDiv);
                         
 						initE8Browser("relatedprj_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=8");
                         
                         break ;
                     case 5 :
                         var oDiv = document.createElement("div");

                         var detailbrowclick = "onShowBrowser2_fna('relatedcrm_"+insertindex+"','"+browserUtl_crm+"','','7','"+ismand+"')";
                         oDiv.innerHTML = "<span id='relatedcrm_"+insertindex+"wrapspan'></span>"+
                         	//"<input type=\"hidden\" viewtype=\""+ismand+"\" temptitle=\"\" name=\"relatedcrm_"+insertindex+"\" id=\"relatedcrm_"+insertindex+"\" value=\"\">"+
                         	"";
                         oCell.appendChild(oDiv);

 						initE8Browser("relatedcrm_"+insertindex, insertindex, ismand, "", "", detailbrowclick, "/data.jsp?type=7");
                         
                         break ;
                     case 6 :
                         var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:85%  id='description_"+insertindex+"' name='description_"+insertindex+"'  onBlur='" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(description_"+ insertindex+",descriptionspan_"+insertindex+");" ;
                        sHtml += "'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='descriptionspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                     case 7 :
                         var oDiv = document.createElement("div");
                        sHtml = "<span id='oldamountspan_"+insertindex+"'></span><input type=hidden id='oldamount_"+insertindex+"' name='oldamount_"+insertindex+"' value=''>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                     case 8 :
                         var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:99%  id='applyamount_"+insertindex+"' name='applyamount_"+insertindex+"' maxlength='10' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(applyamount_"+ insertindex+",applyamountspan_"+insertindex+");" ;
                        sHtml += "changeapplynumber("+ insertindex+");'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='applyamountspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                     case 9 :
                        var oDiv = document.createElement("div");
                        var sHtml = "<nobr><input type='text' class=inputstyle style=width:99%  id='amount_"+insertindex+"' name='amount_"+insertindex+"' maxlength='10' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);" ;
                        if(ismand == 1)
                            sHtml += "checkinput1(amount_"+ insertindex+",amountspan_"+insertindex+");" ;
                        sHtml += "changenumber("+ insertindex+");'>" ;
                        if(ismand == 1)
                            sHtml += "<span id='amountspan_"+insertindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                     case 10 :
                         var oDiv = document.createElement("div");
                        sHtml = "<span id='changeamountspan_"+insertindex+"'></span>";
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                    case 11 :
                         var oDiv = document.createElement("div");
                        var sHtml = "<select id='organizationtype_"+insertindex+"' name='organizationtype_"+insertindex+"' onchange='clearSpan("+insertindex+")'>"+
                        <%if(fnaBudgetOAOrg){ %>
                        	"<option value=2 default><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>"+
                        	"<option value=1><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>"+
                        	"<option value=3><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option>"+
                        <%} %>
                        <%if(fnaBudgetCostCenter){ %>
                        	"<option value='<%=FnaCostCenter.ORGANIZATION_TYPE+"" %>'><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></option>"+
                        <%} %>
                        	"</select>" ;
                        oDiv.innerHTML = sHtml;
                        oCell.appendChild(oDiv);
                        break ;
                 }
             }
         }
     }
     if ("<%=needcheckdtl%>" != ""){
        document.all("needcheck").value += "<%=needcheckdtl%>";
    }
     insertindex = insertindex*1 +1;
     rowindex = curindex*1 +1;
     $GetEle("nodesnum").value = rowindex;
	 $GetEle("indexnum").value = insertindex;
     try{jQuery('body').jNice();}catch(ex1){}
     try{beautySelect();}catch(ex1){}
 }
 
 <%
 if(dtldefault.equals("1") && recorderindex == 0)
 {
 %>
 addRow();
 <%
 RecordSet.executeSql(" select defaultrows from workflow_NodeFormGroup where nodeid=" + nodeid + " and groupid=0");
 RecordSet.next();
 int defaultrows = Util.getIntValue(RecordSet.getString("defaultrows"),0);
 %>
 var defaultrows = <%=defaultrows %>;
 for(var k = 0; k < parseInt(defaultrows)-1; k++) {
 addRow();						
 }
 <%	
 }
 %>

function changenumber(index){
    if(document.all("amount_"+index)&&document.all("oldamountspan_"+index)){
   	//TD12002 审批预算值大于0时预算差额以审批预算为准计算
	var aproveamount = Number(eval(toFloat(document.all("amount_"+index).value,0)));
    if(aproveamount > 0) {
    	changeval=eval(toFloat(document.all("amount_"+index).value,0)) -eval(toFloat(document.all("oldamountspan_"+index).innerHTML,0));
    } else {
    	changeapplynumber(index);
    	return;
    }
    //changeval=eval(toFloat(document.all("amount_"+index).value,0)) -eval(toFloat(document.all("oldamountspan_"+index).innerHTML,0));
    if(document.all("changeamountspan_"+index)) document.all("changeamountspan_"+index).innerHTML=changeval.toFixed(3);
    }
}

function changeapplynumber(index){
    if(document.all("applyamount_"+index)&&document.all("oldamountspan_"+index)){
	//TD12002 审批预算值大于0时预算差额以审批预算为准计算
	var aproveamount = Number("0");
	if(document.all("amount_"+index)) {
		aproveamount = Number(eval(toFloat(document.all("amount_"+index).value,0)));
	}
    if(aproveamount > 0) {
    	changenumber(index);
    	return;
    } else {
    	changeval=eval(toFloat(document.all("applyamount_"+index).value,0)) -eval(toFloat(document.all("oldamountspan_"+index).innerHTML,0));
    }
    //changeval=eval(toFloat(document.all("applyamount_"+index).value,0)) -eval(toFloat(document.all("oldamountspan_"+index).innerHTML,0));
    if(document.all("changeamountspan_"+index)) document.all("changeamountspan_"+index).innerHTML=changeval.toFixed(3);
    }
}
 function toFloat(str , def) {
     if(isNaN(parseFloat(str))) return def ;
     else return str ;
 }

 function toInt(str , def) {
     if(isNaN(parseInt(str))) return def ;
     else return str ;
 }

 function deleteRow1()
 {
     var flag = false;
	var ids = document.getElementsByName('check_node');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
		if(isdel()){
             len = document.forms[0].elements.length;
             var i=0;
             var therowindex = 0 ;
             var rowsum1 = 0;
             for(i=len-1; i >= 0;i--) {
                 if (document.forms[0].elements[i].name=='check_node')
                     rowsum1 += 1;
             }
             for(i=len-1; i >= 0;i--) {
                 if (document.forms[0].elements[i].name=='check_node'){
                     if(document.forms[0].elements[i].checked==true) {
                         therowindex = document.forms[0].elements[i].value ;
                         deletearray[thedeletelength] = therowindex ;
                         thedeletelength ++ ;
                         oTable.deleteRow(rowsum1);
                         rowindex--;
                     }
                     rowsum1 -=1;
                 }
             }
        }
		$GetEle("nodesnum").value = rowindex ;
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
 }

//wfbrowvaluechange(this, 'subject_"+insertindex+"', "+insertindex+")"
function wfbrowvaluechange(obj, fieldid, index) {
	//alert("obj="+obj+";fieldid="+fieldid+";index="+index);

	 if((typeof fieldid)=="string"){
		if(fieldid.indexOf('organizationtype')>-1 || fieldid.indexOf('organizationid')>-1  
			|| fieldid.indexOf('subject')>-1 || fieldid.indexOf('budgetperiod')>-1){

			var organizationtypeval = jQuery("#organizationtype_" + index).val();
			var organizationidval = jQuery("#organizationid_" + index).val();
			var subjid = jQuery("#subject_" + index).val();
	
			getBudget(index, organizationtypeval, organizationidval, subjid);
		
			if(checkSameSubject_E8(index)){
				alert("<%=SystemEnv.getHtmlNoteName(98,user.getLanguage())%>");	
				jQuery("#"+fieldid+"span").attr("realValue","");
				jQuery("#"+fieldid+"span").html("");
				jQuery("#"+fieldid).val(""); 
			}
		}
	}
}

function clearSpan(index) {
	if(jQuery("#organizationid_"+index+"span").length>0&&organizationidisedit==1){
		if(organizationidismand==1){
			jQuery("#organizationid_"+index+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
		}else{
			jQuery("#organizationid_"+index+"span").html("");
		}
		jQuery("#organizationid_"+index+"span")[0].parentElement.parentElement.style.background=jQuery("#organizationtype_"+index)[0].parentElement.parentElement.style.background;
		if (jQuery("#organizationid_" + index).length>0){
			jQuery("#organizationid_"+index).val("");
		}
		if (jQuery("#hrmremainspan_" + index).length>0) {
			jQuery("#hrmremainspan_" + index).html("");
		}
		if (jQuery("#deptremainspan_" + index).length>0) {
			jQuery("#deptremainspan_" + index).html("");
		}
		if (jQuery("#subcomremainspan_" + index).length>0) {
			jQuery("#subcomremainspan_" + index).html("");
		}
		if (jQuery("#fccremainspan_" + index).length>0) {
			jQuery("#fccremainspan_" + index).html("");
		}
	}
	
	onShowOrganizationBtn(organizationidismand, index, "", "");
   
}
function onShowOrganizationBtn(organizationidismand, insertindex, _browserId, _browserName) {
	jQuery("#organizationid_"+insertindex).val("");
   jQuery("#organizationid_"+insertindex+"wrapspan").html("");
   
	var orgType = jQuery("#organizationtype_"+insertindex).val();
	
	var btnType = "4";//部门
	var browserUtl = browserUtl_dep;
   if (orgType == "3"){//个人
   	btnType = "1";
   	browserUtl = browserUtl_hrm;
   }else if (orgType == "2"){//部门
   	btnType = "4";
   	browserUtl = browserUtl_dep;
   }else if (orgType == "1"){//分部
   	btnType = "164";
   	browserUtl = browserUtl_sub;
   }else if (orgType == "<%=FnaCostCenter.ORGANIZATION_TYPE+"" %>"){//成本中心
   	btnType = "251";
   	browserUtl = browserUtl_fcc;
   }

	var detailbrowclick = "onShowBrowser2_fna('organizationid_"+insertindex+"','"+browserUtl+"','','"+btnType+"','"+organizationidismand+"')";
	initE8Browser("organizationid_"+insertindex, insertindex, organizationidismand, _browserId, _browserName, detailbrowclick, "/data.jsp?show_virtual_org=-1&type="+btnType);

	if(checkSameSubject_E8(insertindex)){
		var subjectName = jQuery("#subject_" + insertindex+"span").text();
		alert("<%=SystemEnv.getHtmlNoteName(98,user.getLanguage())%>");
		return;
	}
}

function onShowSubjectBtn(fieldId, insertindex, ismand, fieldvalue, showname, detailbrowclick, url ){
	initE8Browser(fieldId, insertindex, ismand, fieldvalue, showname, detailbrowclick, "javascript:getSubjectId_completeUrl('"+fieldId+"','"+insertindex+"')");
}

function getSubjectId_completeUrl(fieldId, insertindex){
	var __orgType = jQuery("#organizationtype_"+insertindex).val();
	var __orgId = jQuery("#organizationid_"+insertindex).val();
	return "/data.jsp?type=22&orgType="+__orgType+"&orgId="+__orgId+"&fromFnaRequest=1&bdf_wfid=<%=workflowid%>&bdf_fieldid=<%=subjectFieldId%>";
}

function callback(o, index) {
	jQuery("#oldamountspan_" + index).html(o);
	jQuery("#oldamount_" + index).val(o);
	changenumber(index);
	changeapplynumber(index);
}
function getBudget(index, organizationtype, organizationid, subjid) {
	var budgetperiod = jQuery("#budgetperiod_"+index).val();
	if(subjid!=""&&organizationtype!=""&&organizationid!=""&&budgetperiod!=""){
		var _data = "budgetfeetype="+subjid+"&orgtype="+organizationtype+"&orgid="+organizationid+"&applydate="+budgetperiod;
		jQuery.ajax({
			url : "/workflow/request/BudgetHandlerGetBudgetByDate.jsp",
			type : "post",
			processData : false,
			data : _data,
			dataType : "html",
			success: function do4Success(msg){
				callback(msg, index);
			}
		});	
	}else{
		callback("", index);
	}
}




//TD31699 lv 检查在当前预算是否已经存在 
function checkSameSubject(currentSubjectValue,currentBudgetPeriodValue, ismand, index){
	var result = false;
	var nodesnum = document.frmmain.nodesnum.value;
	var maxIndex = 0;
	if(nodesnum!=null && nodesnum!='' ){
		maxIndex = parseInt(nodesnum);
	}
	if(document.all("budgetperiod_" + index)){
		currentBudgetPeriodValue = currentBudgetPeriodValue.substring(0,7);
		//alert("index="+index+"\n"+"currentSubjectValue="+currentSubjectValue+"\n"+"currentBudgetPeriodValue="+currentBudgetPeriodValue);
		for(var i=0;i<maxIndex;i++){
			if(document.all("subject_" + i) && i!=maxIndex ){			
				var indexSubjectValue = document.all("subject_" + i).value;
				var indexBudgetPeriodValue = document.all("budgetperiod_" + i).value;
				indexBudgetPeriodValue = indexBudgetPeriodValue.substring(0,7);
				//alert("i="+i+"\n"+"indexSubjectValue="+indexSubjectValue+"\n"+"indexBudgetPeriodValue="+indexBudgetPeriodValue);
				if(currentBudgetPeriodValue == indexBudgetPeriodValue && currentSubjectValue == indexSubjectValue){
					result = true;
					break;
				}
					
			}
		}
	}
	//alert(result);
	return result;
}

function checknumber1(objectname)
{
	valuechar = objectname.value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=".") isnumber = true ;}
	if(isnumber) objectname.value = "" ;
}

 </script>

<%!
	public void setFieldPropertiesList(RecordSet RecordSet,List fieldids,List fieldlabels, List fieldhtmltypes,List fieldtypes,List fieldnames,List fieldviewtypes,int formid){
		fieldids.clear() ;
		fieldlabels.clear() ;
		fieldhtmltypes.clear() ;
		fieldtypes.clear() ;
		fieldnames.clear() ;
		fieldviewtypes.clear() ;

		RecordSet.executeProc("workflow_billfield_Select",formid+"");
		while(RecordSet.next()){
			String theviewtype = Util.null2String(RecordSet.getString("viewtype")) ;
			if( !theviewtype.equals("1") ) continue ;   // 如果是单据的主表字段,不显示

			fieldids.add(Util.null2String(RecordSet.getString("id")));
			fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
			fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
			fieldtypes.add(Util.null2String(RecordSet.getString("type")));
			fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
			fieldviewtypes.add(theviewtype);
		}  
	
	}
%>
