<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ include file="/hrm/performance/common.jsp" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="resource" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<% 
  //if (!Rights.getRights("","","","")){//权限判断
  //	response.sendRedirect("/notice/noright.jsp") ;
//	return ;
 //  }
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<STYLE>
	.vis1	{ visibility:"visible" }
	.vis2	{ visibility:"hidden" }
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
//GeneratePro.createAll("workPlan");
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18181,user.getLanguage());
String type=Util.null2String(request.getParameter("type"));  //周期
String planDate=Util.null2String(request.getParameter("planDate"));  
String pName=Util.null2String(request.getParameter("pName"));  
String needfav ="1";
String needhelp ="";
String sum="0";
String resourceId = String.valueOf(user.getUID());	//默认为当前登录用户
String objId=Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
String type_d=Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d"));
if (rs1.getDBType().equals("oracle"))
rs1.executeSql("select sum(percent_n) from workPlan where objId="+objId+" and cycle='"+type+"' and  planType='"+type_d+"' and planDate='"+planDate+"' and type_n='6' ");
else if (rs1.getDBType().equals("db2"))
rs1.executeSql("select sum(double(percent_n)) from workPlan where objId="+objId+" and cycle='"+type+"' and  planType='"+type_d+"' and planDate='"+planDate+"' and type_n='6' ");
else
rs1.executeSql("select sum(convert(float,percent_n)) from workPlan where objId="+objId+" and cycle='"+type+"' and  planType='"+type_d+"' and planDate='"+planDate+"' and type_n='6' ");
if (rs1.next())
{
sum=Util.null2o(rs1.getString(1));
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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

<FORM name=resource id=resource action="PlanOperation.jsp" method=post>
<input type=hidden name=operationType value="planAdd" >
<input type=hidden name=nodesumd>
<input type=hidden name=nodesumu>
<input type=hidden name=sum value=<%=sum%>>
<input type=hidden name=planDate value=<%=planDate%> >
<input type=hidden name=type value=<%=type%> >
<input type=hidden name=pName value=<%=pName%> >
   <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="50%"> 
    <COL width="50%"> 
    <TBODY> 
  
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=10%> <COL width=70%> <TBODY> 
          <TR class=title> 
            <TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=50 size=50 
            name=name  onchange='checkinput("name","nameimage")'>
			<SPAN id=nameimage>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			</SPAN>
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=4 size=4 
            name=percent_n  onchange='checknumber("percent_n");checkinput("percent_n","pimage")'>%
			<SPAN id=pimage>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			</SPAN>
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
            <TD class=Field> 
            <%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%>
              <input class=inputstyle name=type_n type="hidden" value="6">
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
        
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18191,user.getLanguage())%></TD>
            <TD class=Field> 
           <BUTTON type="button" class=Browser id=SelectTargetID onClick="onShowTarget('oppositeGoal','targetidspan')"></BUTTON> 
              <span 
            id=targetidspan><img src="/images/BacoError.gif" 
            align=absMiddle></span> 
              <INPUT class=inputStyle id=oppositeGoal 
            type=hidden name=oppositeGoal>
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
         
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></TD>
            <TD class=Field> 
             <%rs1.execute("select * from HrmPerformancePlanKindDetail order by sort");%>
              <select class=inputStyle id=planProperty 
              name=planProperty>
              <option value="0"> </option>
              <%while (rs1.next()) {%>
                <option value="<%=rs1.getString("id")%>"><%=rs1.getString("planName")%></option>
               <%}%></select>
               <!--计划性质-->
      
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(17478,user.getLanguage())%></TD>
            <TD class=Field> 
               <INPUT type="checkbox" name="isremind" onclick="onNeedRemind()" value="2">
				<SPAN id="remindspan" class="vis2">&nbsp;&nbsp;
				<INPUT name="waketime" maxlength="10" size="5" onKeyPress="ItemNum_KeyPress()" class="InputStyle">&nbsp;
				<SELECT name="unittype">
				<OPTION value="1" selected><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></OPTION>
				<OPTION value="2"><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION>
				</SELECT>
				</SPAN>
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=user.getLastname()%>
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
            <TD class=Field> 
              <BUTTON type="button" class=Browser style="display:" onClick="onShowMultiHrmResourceNeeded('principal','hrmidspan','true')" name=showresource></BUTTON> 
			  <span 
              id=hrmidspan>
              <A href="/hrm/resource/HrmResource.jsp?id=<%=resourceId%>">
		      <%=Util.toScreen(resource.getResourcename(resourceId),user.getLanguage())%></A></span> 
              <INPUT class=inputStyle id=principal 
            type=hidden name=principal value="<%=resourceId%>">
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
        
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18188,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16936,user.getLanguage())%></TD>
            <TD class=Field> 
              <BUTTON type="button" class=Browser style="display:" onClick="onShowMultiHrmResourceNeeded('cowork','coworkidspan','false')" name=showresource></BUTTON> 
			  <span 
              id=coworkidspan></span> 
              <INPUT class=inputStyle id=cowork 
            type=hidden name=cowork>
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18183,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
            <TD class=Field> 
            <!--新增上下游部门/负责人-->
            <input type="hidden" name="upPrincipals">
            <BUTTON type="button" class="WorkPlan" type=button accessKey=A onclick="addRow1()"><U>A</U><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
            <BUTTON type="button" class="WorkPlan"  type=button accessKey=E onclick="deleteRow1()"><U>E</U><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
            <table Class=listStyle cols=2 id="oTable1" width="50%">
	      	<COLGROUP> 
	      	<COL width="10%"><COL width="90%">
	      
	    	</table>
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18184,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
            <TD class=Field> 
              <!--新增上下游部门/负责人-->
             <input type="hidden" name="downPrincipals">
            <BUTTON type="button" class="WorkPlan" type=button accessKey=Q onclick="addRow2()"><U>Q</U><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
            <BUTTON type="button" class="WorkPlan" type=button accessKey=W onclick="deleteRow2()"><U>W</U><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
            <table Class=listStyle cols=2 id="oTable2" width="50%">
	      	<COLGROUP> 
	      	<COL width="10%"><COL width="90%">
	       
	    	</table>
             
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18192,user.getLanguage())%></TD>
            <TD class=Field> 
              <textarea class=inputstyle name=teamRequest  rows="5" style="width:98%""></textarea>
            </TD>
          </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>  
          <TR>         
	<TD><%=SystemEnv.getHtmlLabelName(18182,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON type="button" class="Calendar" id="rSelectBeginDate" onclick="getDate('rbegindatespan','rbegindate')"></BUTTON> 
		  <SPAN id="rbegindatespan">
		  <%=TimeUtil.getCurrentDateString()%></SPAN> 
		  <INPUT type="hidden" name="rbegindate" value="<%=TimeUtil.getCurrentDateString()%>">  
		  &nbsp;&nbsp;&nbsp;
		  <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%><BUTTON type="button" class="Clock" id="rSelectBeginTime" onclick="onShowTime(rbegintimespan,rbegintime)"></BUTTON>
		  <SPAN id="rbegintimespan"></SPAN>
		  <INPUT type="hidden" name="rbegintime" ></TD>
	</TR>
	<TR style="height: 1px;"><TD class="Line" colSpan=2></TD></TR>

	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(18182,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1035,user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON type="button" class="Calendar" id="rSelectEndDate" onclick="getDate('renddatespan','renddate')"></BUTTON> 
		  <SPAN id="renddatespan"></SPAN> 
		  <INPUT type="hidden" name="renddate">  
		  &nbsp;&nbsp;&nbsp;
		  <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%><BUTTON type="button" class="Clock" id="rSelectEndTime" onclick="onShowTime(rendtimespan,rendtime)"></BUTTON>
		  <SPAN id="rendtimespan"></SPAN>
		  <INPUT type="hidden" name="rendtime"></TD>
	</TR>
	<TR style="height: 1px;"><TD class="Line" colSpan=2></TD></TR>
        <TR>          
	<TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON type="button" class="Calendar" id="SelectBeginDate" onclick="getDate('begindatespan','begindate')"></BUTTON> 
		  <SPAN id="begindatespan">
		    <%=TimeUtil.getCurrentDateString()%></SPAN> 
		  <INPUT type="hidden" name="begindate" value="<%=TimeUtil.getCurrentDateString()%>">  
		  &nbsp;&nbsp;&nbsp;
		  <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%><BUTTON type="button" class="Clock" id="SelectBeginTime" onclick="onShowTime(begintimespan,begintime)"></BUTTON>
		  <SPAN id="begintimespan"></SPAN>
		  <INPUT type="hidden" name="begintime"></TD>
	</TR>
	<TR style="height: 1px;"><TD class="Line" colSpan=2></TD></TR>

	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON type="button" class="Calendar" id="SelectEndDate" onclick="getDate('enddatespan','enddate')"></BUTTON> 
		  <SPAN id="enddatespan"></SPAN> 
		  <INPUT type="hidden" name="enddate">  
		  &nbsp;&nbsp;&nbsp;
		  <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%><BUTTON type="button" class="Clock" id="SelectEndTime" onclick="onShowTime(endtimespan,endtime)"></BUTTON>
		  <SPAN id="endtimespan"></SPAN>
		  <INPUT type="hidden" name="endtime"></TD>
	</TR>
	<TR style="height: 1px;"><TD class="Line" colSpan=2></TD></TR>
	 <TR>
	  <TD><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></TD>
	  <TD class="Field">
		<BUTTON type="button" class="Browser" id="SelectCrm" onclick="onShowMultiCustomer('crmid','crmspan')"></BUTTON>		
		<SPAN id="crmspan"></SPAN> 
		<INPUT type="hidden" name="crmid" >
	  </TD>
	</TR>
	<TR style="height: 1px;"><TD class="Line" colSpan=2></TD></TR>
	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON type="button" class="Browser" id="SelectMultiDoc" onclick="onShowMultiDocs('docid','docspan')"></BUTTON>    
	  <SPAN id="docspan"></SPAN>
	  <INPUT type="hidden" name="docid" ></TD>
	</TR>
	<TR style="height: 1px;"><TD class="Line" colSpan=2></TD></TR>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></TD>
		 <TD class="Field">
		 <BUTTON type="button" class="Browser" id="SelectMultiProject" onclick="onShowMultiProject('projectid','projectspan')"></BUTTON>      
		<SPAN id="projectspan"></SPAN>
		<INPUT type="hidden" name="projectid"></TD>
	</TR>
	<TR style="height: 1px;"><TD class="Line" colSpan="2"></TD></TR>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></TD>
		 <TD class="Field">
		 <BUTTON type="button" class="Browser" id="SelectMultiRequest" onclick="onShowMultiRequest('requestid','requestspan')"></BUTTON>      
		<SPAN id="requestspan"></SPAN>
		<INPUT type="hidden" name="requestid"></TD>
	</TR>
	<TR style="height: 1px;"><TD class="Line" colSpan="2"></TD></TR>
	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></TD>
	  <TD class="Field"><TEXTAREA class="InputStyle" name="description" rows="5" style="width:98%" ></TEXTAREA>
      </TD>
	</TR>
	<TR style="height: 1px;"><TD class="Line" colSpan=2></TD></TR>
          </TBODY> 
        </TABLE>
      </TD>
  </FORM>
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

<SCRIPT language="JavaScript" src="/js/browser/CustomerMultiBrowser_wev8.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/browser/DocsMultiBrowser_wev8.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/browser/ProjectMultiBrowser_wev8.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/browser/RequestMultiBrowser_wev8.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/browser/HrmResourceMultiBrowser_wev8.js"></SCRIPT>

<SCRIPT language="JavaScript" src="/js/OrderValidator.js"></SCRIPT>
<SCRIPT language="javascript">
function onShowDepartment(inputname, spanname){
	var inputids=inputname.split("_");
	var inputid=inputids[0];
	var inputid_id=inputids[1];
	var inputnamehrm=inputid+"hrm_"+inputid_id;
	var inputnamehrmspan=inputid+"idspanhrm_"+inputid_id;
	var oldValue=$("input[name="+inputname+"]").val();
	var retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+oldValue);
	
	if(retValue){
		if (retValue.id!= "") {
			$("#"+spanname).html("<A target='_blank' href='/hrm/company/HrmDepartmentDsp.jsp?id="+retValue.id+"'>"+retValue.name+"</A>");
			$("input[name="+inputname+"]").val(retValue.id);
			if(oldValue!=retValue.id){
				$("#"+inputnamehrmspan).html("");
				$("input[name="+inputnamehrm+"]").val("");
			}
		}else{
			$("#"+spanname).html("");
			$("input[name="+inputname+"]").val("");
			$("#"+inputnamehrmspan).html("");
			$("input[name="+inputnamehrm+"]").val("");
		}
	}
	
	
}

function onShowResource(inputname,spanname){
	var o=window.event.srcElement.id
	var os=o.split("_");
	var name=os[0];
	var index1=os[1];
	var heads="";
	if(name=="upPrincipalhrmid"){
		heads="upPrincipal";
	}else{
		heads="downPrincipal";
	}
	heads+="_"+index1;
	var tmpids=$("input[name="+heads+"]").val();
	
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/ResourceBrowser.jsp?departmentId="+tmpids)
	if (datas){
		if (datas[0]!=''){
			$("#"+spanname).html("<A target='_blank' href='/hrm/resource/HrmResource.jsp?id="+datas[0]+"'>"+datas[1]+"</A>");
			$("input[name="+inputname+"]").val(datas[0]);
		}else {
			$("#"+spanname).html("");
			$("input[name="+inputname+"]").val("");
		}
	}
	
}
</SCRIPT>
<SCRIPT language="javascript">
function OnSubmit(){
      
      
    if(check_form(document.resource,"name,percent_n,principal,begindate,rbegindate,oppositeGoal")&&checkall()&&checkp()&&compareDate())
	{	
		document.resource.submit();
		enablemenu();
	}
}
function compareDate()
{
d1=document.resource.begindate.value;
d2=document.resource.enddate.value;
d3=document.resource.rbegindate.value;
d4=document.resource.renddate.value;
if (d1=="") d1="0000-00-00";
if (d2=="") d2="2222-01-01";
if (d3=="") d3="0000-00-00";
if (d4=="") d4="2222-01-01";
if (d1>d2||d3>d4) 
{
alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
return false;
}
return true;
}
function checkp()
{
 if ((parseFloat(document.resource.percent_n.value)+parseFloat(document.resource.sum.value))>100) 
	     {
	     alert("<%=SystemEnv.getHtmlLabelName(18196,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(15223,user.getLanguage())%>"+100);
	     return false;
	     }
	 return true;     
}
function checkall()
{
    document.all("nodesumd").value=rowindex2;
    document.all("nodesumu").value=rowindex1;
    document.all("upPrincipals").value="";
    document.all("downPrincipals").value="";
    for(i=0;i<rowindex1;i++)
    {   
       if ((document.all("upPrincipal_"+i).value!="")&&(document.all("upPrincipalhrm_"+i).value==""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18193,user.getLanguage())%>");
          document.all("upPrincipals").value="";
          return false;
       }
       if ((document.all("upPrincipal_"+i).value=="")&&(document.all("upPrincipalhrm_"+i).value==""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>");
          document.all("upPrincipals").value="";
          return false;
       }
       if ((document.all("upPrincipal_"+i).value=="")&&(document.all("upPrincipalhrm_"+i).value!=""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>");
          document.all("upPrincipals").value="";
          return false;
       }
       document.all("upPrincipals").value=document.all("upPrincipals").value+document.all("upPrincipal_"+i).value+"/"+document.all("upPrincipalhrm_"+i).value+",";
   
    }
      for(j=0;j<rowindex2;j++)
    {
       if ((document.all("downPrincipal_"+j).value!="")&&(document.all("downPrincipalhrm_"+j).value==""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18193,user.getLanguage())%>");
          document.all("downPrincipals").value="";
          return false;
       }
       if ((document.all("downPrincipal_"+j).value=="")&&(document.all("downPrincipalhrm_"+j).value==""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>");
          document.all("upPrincipals").value="";
          return false;
       }
       if ((document.all("downPrincipal_"+j).value=="")&&(document.all("downPrincipalhrm_"+j).value!=""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>");
          document.all("upPrincipals").value="";
          return false;
       }
     document.all("downPrincipals").value=document.all("downPrincipals").value+document.all("downPrincipal_"+j).value+"/"+document.all("downPrincipalhrm_"+j).value+",";  
    }
     
     return true;
}
function onNeedRemind() {
	if (document.all("isremind").checked) 
        document.all("remindspan").className = "vis1";
    else 
        document.all("remindspan").className = "vis2";
}
 

rowindex1 = 0 ;

function addRow1()
{	
	ncol = jQuery('#oTable1').attr("cols");
	oRow = oTable1.insertRow();
	oRow.id="tr_"+rowindex1;
    oRow.customIndex = rowindex1;
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON type='button' id='upPrincipalid_"+rowindex1+"' class=Browser onClick=onShowDepartment('upPrincipal_"+rowindex1+"','upPrincipalidspan_"+rowindex1+"')></BUTTON>" ;
                sHtml=sHtml+"<span id='upPrincipalidspan_"+rowindex1+"'></span>"
			    sHtml=sHtml+"<INPUT class=inputStyle id='upPrincipal_"+rowindex1+"'  type=hidden name='upPrincipal_"+rowindex1+"'>";
				sHtml=sHtml+"<BUTTON type='button' id='upPrincipalhrmid_"+rowindex1+"' class=Browser  onClick=onShowResource('upPrincipalhrm_"+rowindex1+"','upPrincipalidspanhrm_"+rowindex1+"')></BUTTON>";
                sHtml=sHtml+"<span id='upPrincipalidspanhrm_"+rowindex1+"'></span>";
                sHtml=sHtml+"<INPUT class=inputStyle id='upPrincipalhrm_"+rowindex1+"'  type=hidden name='upPrincipalhrm_"+rowindex1+"'>";
				oDiv.innerHTML = sHtml;      
				oCell.appendChild(oDiv);  
				break;
			
			
			
		}
	}
	rowindex1 = rowindex1*1 +1;
}

function deleteRow1()
  
{   
    if(jQuery("input[name='check_type']:checked").length>0&&window.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>?")){
    len = document.forms[0].elements.length;
	for(i=len-1; i >= 0;i--){		
		if(document.forms[0].elements[i].name=='check_type'){
			if(document.forms[0].elements[i].checked==true) {
				delRowIndex = document.forms[0].elements[i].parentNode.parentNode.parentNode.rowIndex;
				oTable1.deleteRow(delRowIndex);
				rowindex1--;
			}
		}
	}
	}
}



rowindex2 = 0 ;

function addRow2()
{	var oTbody = oTable2;
	var ncol = $('#oTable2').attr("cols");
	var oRow = oTbody.insertRow();
	//ncol = oTable2.cols;
	//oRow = oTable2.insertRow();
	oRow.id="tr2_"+rowindex2;
    oRow.customIndex = rowindex2;
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type2' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON type='button' id='downPrincipalid_"+rowindex2+"' class=Browser onClick=onShowDepartment('downPrincipal_"+rowindex2+"','downPrincipalidspan_"+rowindex2+"')></BUTTON>" ;
                sHtml=sHtml+"<span id='downPrincipalidspan_"+rowindex2+"'></span>"
			    sHtml=sHtml+"<INPUT class=inputStyle id='downPrincipal_"+rowindex2+"'  type=hidden name='downPrincipal_"+rowindex2+"'>";
				sHtml=sHtml+"<BUTTON type='button' id='downPrincipalhrmid_"+rowindex2+"' class=Browser  onClick=onShowResource('downPrincipalhrm_"+rowindex2+"','downPrincipalidspanhrm_"+rowindex2+"')></BUTTON>";
                sHtml=sHtml+"<span id='downPrincipalidspanhrm_"+rowindex2+"'></span>";
                sHtml=sHtml+"<INPUT class=inputStyle id='downPrincipalhrm_"+rowindex2+"'  type=hidden name='downPrincipalhrm_"+rowindex2+"'>";
				oDiv.innerHTML = sHtml;      
				oCell.appendChild(oDiv);  
				break;
			
			
			
		}
	}
	rowindex2 = rowindex2*1 +1;
}

function deleteRow2()
{
   if(jQuery("input[name='check_type2']:checked").length>0&&window.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>?")){
   len = document.forms[0].elements.length;
	for(i=len-1; i >= 0;i--){		
		if(document.forms[0].elements[i].name=='check_type2'){
			if(document.forms[0].elements[i].checked==true) {
				delRowIndex = document.forms[0].elements[i].parentNode.parentNode.parentNode.rowIndex;
				oTable2.deleteRow(delRowIndex);
				rowindex2--;
			}
		}
	}
	}
}

function onShowTarget(inputename,spanname){
    var cycle1=<%=type%>
    if ("<%=type%>"=="0") {
         cycle="3"
    }else if("<%=type%>"=="1") {
        cycle="1"
    }else if("<%=type%>"=="2") {
         cycle="0"
	}else if("<%=type%>"=="3") {
         cycle="0"
    }
    var planDate="<%=planDate%>";
    var temp=planDate+"||"+cycle+"-"+cycle1;
    var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/goal/myGoalBrowserForPlan.jsp?temp="+temp);
        if (id1) {
        if (id1.id!="") {
          resourceids = id1.id;
          resourcename = id1.name;
          
          document.all(spanname).innerHTML = resourcename;
          document.all(inputename).value=resourceids;
        }else{
          document.all(spanname).innerHTML ="<IMG src='/images/BacoError.gif' align=absMiddle>"
          document.all(inputename).value=""
        }
      }
}

</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</BODY>
</HTML>
