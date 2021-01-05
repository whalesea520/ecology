<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" /> <!--added by xwj for td2044 on 2005-05-30-->
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(621,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;   
%>

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
<%
int finished = Util.getIntValue(request.getParameter("finished"),-1);
int contacttype = Util.getIntValue(request.getParameter("contacttype"),0);
String resource = Util.null2String(request.getParameter("viewer"));
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=10;
String resourcename=ResourceComInfo.getResourcename(resource+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String description=Util.fromScreen(request.getParameter("description"),user.getLanguage());
String ownerid2=Util.fromScreen(request.getParameter("ownerid2"),user.getLanguage()); //客户id

String viewernames = Util.fromScreen(request.getParameter("viewernames"),user.getLanguage());
String checkDeptIds = Util.fromScreen(request.getParameter("checkDeptId"),user.getLanguage());
String checkDeptnames = Util.fromScreen(request.getParameter("checkDeptnames"),user.getLanguage());

String sqlwhere=" ";
boolean isOracle = false;
boolean isDb2 = false;
isOracle = RecordSet.getDBType().equals("oracle");
isDb2 = RecordSet.getDBType().equals("db2");
if(!resource.equals("")){//Modify by 杨国生 2004-10-25 For TD1267
	sqlwhere+= " and t1.createrid in (" + resource + ") ";
}

if(!checkDeptIds.equals("")){
	sqlwhere+= " and t1.deptid in (" + checkDeptIds + ") ";
}

if(!fromdate.equals("")){
	sqlwhere+=" and t1.begindate>='"+fromdate+"'";
}
if(!enddate.equals("")){
  	sqlwhere+=" and t1.begindate<='"+enddate+"'";
}
if( finished != -1 ){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.status = '"+finished +"'";
	else 	sqlwhere+=" and t1.status = '"+finished +"'" ;
}
if( contacttype != 0 ){
	sqlwhere+=" and t1.urgentLevel = '"+contacttype +"'";
}
if( !description.equals("") ){
	sqlwhere+=" and t1.description like '%"+description +"%'";
}
if(!ownerid2.equals("")){
	sqlwhere+=" and t1.createrid='"+ownerid2+"'";
}

String sqlstr = "";

String logintype = ""+user.getLogintype();
%>
<form id=weaver name=frmmain method=post action="CRMContactLogRp.jsp">
<table class=ViewForm>
  <colgroup>
  <col width="10%">
  <col width="25%">
  <col width="10%">
  <col width="25%">
  <col width="10%">
  <col width="20%">
  <tbody>
  <tr>
  <%if(!user.getLogintype().equals("2")){%>
  <td><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></td>
    <td class=field><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%>:<button type="button" class=browser onClick="onShowResource()"></button>
  <span id=viewerspan><%=viewernames%></span>
  <input type=hidden name=viewernames value="<%=viewernames%>">
  <input type=hidden name=viewer value="<%=resource%>">

  <br><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>:<button class=Browser type="button" id=SelectDeparment onClick="onShowParent('owner2span2','ownerid2')"></button>
  <span id=owner2span2>
  <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(ownerid2+""),user.getLanguage())%>
  </span>
  <input type="hidden" name="ownerid2" value="<%=ownerid2%>">
  </td>                    
  <%}%>
  <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
  <td class=field>
  <BUTTON class=calendar type="button" id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
  <input type="hidden" name="fromdate" value=<%=fromdate%>>－&nbsp;<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
  <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
  <input type="hidden" name="enddate" value=<%=enddate%>>
  </td>

  <td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
  <td class=field>
  <select class=InputStyle  size="1" name="finished">
			<option value="-1" <%if (finished == -1) {%>selected<%}%>> </option>
			<option value="0" <%if (finished == 0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%></option>
			<option value="1" <%if (finished == 1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%></option>
			<option value="2" <%if (finished == 2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
			</select>
  </td>
  </TR>
  <tr style="height: 1px"><td class=Line colspan=6></td></tr>
  <tr> 
  <TD><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
  <TD class=Field>
    <BUTTON class=Browser id=SelectDepID onClick="onShowDepartment()"></BUTTON>
	<span id=deptName><%=checkDeptnames%></span>
	<INPUT class=saveHistory id=checkDeptnames type=hidden name=checkDeptnames value="<%=checkDeptnames%>">
	<INPUT class=saveHistory id=checkDeptId type=hidden name=checkDeptId value="<%=checkDeptIds%>">
  </TD>
  <TD><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></TD>
  <TD class=Field>
      <select  class=InputStyle size="1" name="contacttype">
			<option value="0" <%if (contacttype == 0 ) { %>selected<%}%>> </option>
			<option value="1" <%if (contacttype == 1 ) { %>selected<%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
			<option value="2" <%if (contacttype == 2 ) { %>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
			<option value="3" <%if (contacttype == 3 ) { %>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>			
      </select>
  </TD>
  <TD><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></TD>
  <TD class=Field><input style="InputStyle" name="description" size="25" maxlength="50" value="<%=description %>"/></TD>
  </TR>
  <tr style="height: 1px"><td class=Line colspan=6></td></tr>

</tbody>
</table>
<br>
<%
String condition = "";
rs.executeSql("select id from HrmRoleMembers where roleid = 8 and resourceid = " + user.getUID());
if (rs.next()) {
	condition = " (select id from CRM_CustomerInfo where deleted=0 or deleted is null) as customerIds ";
} else {
	String leftjointable = CrmShareBase.getTempTable(user.getUID()+"");
	condition = " (select distinct a.id "
		+ " from CRM_CustomerInfo a left join " + leftjointable + " b on a.id = b.relateditemid "
		+ " where a.id = b.relateditemid and (a.deleted=0 or a.deleted is null)) as customerIds";
}

String language=String.valueOf(user.getLanguage());
String backFields = " t1.id, t1.begindate,  t1.begintime, t1.crmid, t1.name, t1.status, t1.resourceid, t1.agentId, t1.urgentLevel, t1.description , t1.createrType,t1.createdate,t1.createtime";
String sqlFrom = " WorkPlan t1 ";
//String whereclause=" where id in ( SELECT DISTINCT t1.id FROM WorkPlan t1, WorkPlanShareDetail  t2 "+ sqlwhere +" and t1.id = t2.workid and t2.usertype="+logintype+"  and t2.userid="+user.getUID() + " and t1.type_n = '3')";
String whereclause=" where exists (select 1 from "+condition+" where t1.crmid=customerids.id and t1.crmid not like '%,%') and t1.type_n=3 "+sqlwhere;
//out.println(backFields + sqlFrom + whereclause);
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"t1.id\" sqlorderby=\"t1.createdate,t1.createtime\" sqlsortway=\"desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(whereclause)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" otherpara=\""+language+"\" transmethod=\"weaver.splitepage.transform.SptmForCrm.getStatusName\"/>"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(229,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" target=\"_fullwindow\" linkkey=\"workid\" linkvaluecolumn=\"id\" href=\"/workplan/data/WorkPlan.jsp\"/>"+
					  "<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(345,user.getLanguage())+"\" column=\"description\"/>"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"urgentLevel\" orderkey=\"urgentLevel\"   otherpara=\""+language+"\" transmethod=\"weaver.splitepage.transform.SptmForCrm.getUrgentName\"/>"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1268,user.getLanguage())+"\" column=\"crmid\" orderkey=\"crmid\" otherpara=\""+language+"\"  transmethod=\"weaver.splitepage.transform.SptmForCrm.getCrmName\"/>"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15525,user.getLanguage())+"\" column=\"resourceid\" orderkey=\"resourceid\" otherpara=\""+language+"+column:createrType\" transmethod=\"weaver.splitepage.transform.SptmForCrm.getReceiveName\"/>"+
					  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(1275,user.getLanguage())+"\"  column=\"begindate\" orderkey=\"begindate\" otherpara=\"column:begintime\" transmethod=\"weaver.splitepage.transform.SptmForCrm.getTime\"/>"+ 
			  "</head>"+
			  "</table>";
%>
<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/>

</form>
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
<script type="text/javascript">
function onShowResource(){

	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if(data){
		if(data.id!=""){
			var namestmp = data.name;
			var idstmp = data.id;
			namestmp = namestmp.substring(1);
			idstmp = idstmp.substring(1);
			viewerspan.innerHTML = namestmp
			frmmain.viewernames.value = namestmp
			frmmain.viewer.value = idstmp
		}else{ 
			viewerspan.innerHTML = ""
			frmmain.viewernames.value = "";
			frmmain.viewer.value=""
		}
	}
}

function onShowDepartment(){

	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if(data){
		if(data.id!=""){
			var namestmp = data.name;
			var idstmp = data.id;
			namestmp = namestmp.substring(1);
			idstmp = idstmp.substring(1);
			deptName.innerHTML = namestmp
			frmmain.checkDeptnames.value = namestmp
			frmmain.checkDeptId.value = idstmp
		}else{ 
			deptName.innerHTML = ""
			frmmain.checkDeptnames.value = "";
			frmmain.checkDeptId.value=""
		}
	}
}

function onShowParent(tdname,inputename){
	
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data){
	    if (data.id!=""){
	        document.all(tdname).innerHTML = data.name
	        document.all(inputename).value=data.id
	        document.all("usertype").value="2"
	
	        document.all("ownerspan").innerHTML = ""
	        document.all("ownerid").value = ""
	
	        document.all("doccreateridspan").innerHTML = ""
	        document.all("doccreaterid").value = ""
	
	    }else{
	        document.all(tdname).innerHTML = ""
	        document.all(inputename).value=""
	        document.all("usertype").value=""
	    }
	}
}
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript">
document.onkeydown=keyListener;
function keyListener(e){
    e = e ? e : event;   
    if(e.keyCode == 13){    
    	frmmain.submit();    
    }    
}
</script>
</html>