<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.workflow.WfRightManager" %>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />

<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="../../js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />
<%
String ajax=Util.null2String(request.getParameter("ajax"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
int subcompanyid= Util.getIntValue(Util.null2String(session.getAttribute(wfid+"subcompanyid")),-1);
int operateLevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subcompanyid,user,haspermission,"WorkflowManage:All");
int rowsum=0;
String isbill="0";
int formid=0;
String iscust="";
String sql ="select formid,isbill,iscust from workflow_base where id="+wfid ;
RecordSet.executeSql(sql);
if(RecordSet.next()){
    formid=Util.getIntValue(RecordSet.getString("formid"),0);
    isbill=Util.null2String(RecordSet.getString("isbill"));
    iscust=Util.null2String(RecordSet.getString("iscust"));
}
%>
<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	if(operateLevel > 0){
	    if(!ajax.equals("1")){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(this),_self} " ;
	    }else{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:wfurgersave(this),_self} " ;
	    }
		RCMenuHeight += RCMenuHeightStep;
	}
%>
<form id="wfurgerform" name="wfurgerform" method=post action="wfurger_operation.jsp" >
<%if(ajax.equals("1")){%>
<input type="hidden" name="ajax" value="1">
<%}%>
<input type="hidden" name="selectindex">
<input type="hidden" name="selectvalue">
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="editoperatorgroup" name="src">
<input type="hidden" value="0" name="groupnum">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21219,user.getLanguage())%>'>
		<wea:item attributes="{'colspan':'full','isTableList':'true'}">
			<table width=100% class="ListStyle">
				<tr class="DataLight">
					<td width=11%>
						<input type=radio  name=operategroup checked value=1 onclick="onChangetypeByUrger(this.value)"><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>
					</td>
					<td width=11%>
						<input type=radio  name=operategroup value=2 onclick="onChangetypeByUrger(this.value)"><%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())%>
					</td>
					<td width=11%>
						<input type=radio  name=operategroup value=3 onclick="onChangetypeByUrger(this.value)"><%=SystemEnv.getHtmlLabelName(15550,user.getLanguage())%>
					</td>
					<td width=11%>
						<input type=radio  name=operategroup value=4 onclick="onChangetypeByUrger(this.value)"><%=SystemEnv.getHtmlLabelName(15551,user.getLanguage())%>
					</td>
					<td width=11%>
						<input type=radio  name=operategroup value=5 onclick="onChangetypeByUrger(this.value)"><%=SystemEnv.getHtmlLabelName(15552,user.getLanguage())%> </td>
					<td width=11%>
						<input type=radio  name=operategroup value=6 onclick="onChangetypeByUrger(this.value)"><%=SystemEnv.getHtmlLabelName(15553,user.getLanguage())%>
					</td>
					<td width=11%>
						<input type=radio  name=operategroup value=7 onclick="onChangetypeByUrger(this.value)"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>
					</td>
				</tr>
			</table>
			</wea:item>
			<wea:item>
				<jsp:include page="WFUrger_inner.jsp" flush="true">
					<jsp:param value="<%=isbill %>" name="isbill"/>
					<jsp:param value="<%=formid %>" name="formid"/>
				</jsp:include>
			</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21219,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>'>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>
		</wea:item>	
		<wea:item>
			<%if(!ajax.equals("1")){%>
				<button type="button"  class=Browser onclick="onShowBrowser4s('<%=wfid%>','<%=formid%>','<%=isbill%>')"></button>
			<%}else {%>
				<button type="button"  class=Browser onclick="onShowBrowsersByWFU(this,'<%=wfid %>','<%=formid%>','<%=isbill%>')"></button>
			<%}%>
			<input type=hidden name=wfconditionss id=wfconditionss>
			<input type=hidden name=wfconditioncn id=wfconditioncn>
			<input type=hidden name=rulemaplistids id=rulemaplistids>
			<input type=hidden name=wffromsrc id=wffromsrc value="2">
			<span id="wfconditions"></span>
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33562,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
		<wea:item type="groupHead">
			<%if(!ajax.equals("1")){%>
				<input type='button' class='addbtn' accessKey=A onclick="addRow();" title="A-<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%>"/>
				<input type='button' class='delbtn' accessKey=D onclick="if(isdel()){deleteRow();}" title="D-<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%>"/>
			<%}else{%>
				<input type='button' class='addbtn' accessKey=A onclick="addRowByUrger();" title="A-<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%>"/>
				<input type='button' class='delbtn' accessKey=D onclick="deleteRowByUrger();" title="D-<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%>"/>
			<%}%>		
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<%if(!ajax.equals("1")){%>
				<table class=ListStyle cellspacing=0   cols=5 id="oTable">
			<%}else{%>
				<table class=ListStyle cellspacing=0   cols=5 id="oTableByUrger">
			<%}%>
			<COLGROUP>
				<COL width="10%">
				<COL width="12%">
				<COL width="16%">
				<COL width="17%">
				<COL width="35%">
			</COLGROUP>
			<tr class=header>
	            <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
			</tr>

<%
ArrayList ids = new ArrayList();
ArrayList names = new ArrayList();
ids.clear();
names.clear();

if(isbill.equals("0"))
  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
else
  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " " ;

RecordSet.executeSql(sql);
while(RecordSet.next()){
	ids.add(RecordSet.getString("id"));
    if(isbill.equals("0")) names.add(Util.null2String(RecordSet.getString("name")));
	else names.add(SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage()));
}


//the record in db
int colorcount=0;
RecordSet.executeSql("select * from workflow_urgerdetail where workflowid="+wfid+" order by id");
String oldids="-1";
while(RecordSet.next()){
	int detailid = RecordSet.getInt("id");
	int type = RecordSet.getInt("utype");
	int objid = RecordSet.getInt("objid");
	int level = RecordSet.getInt("level_n");
	int level2 = RecordSet.getInt("level2_n");

    String jobobj=RecordSet.getString("jobobj");
    String jobfield=RecordSet.getString("jobfield");
    String conditions=RecordSet.getString("conditions");
    String conditioncn=RecordSet.getString("conditioncn");
	oldids=oldids+","+detailid;
if(colorcount==0){
		colorcount=1;
%>
<tr class="DataLight">
<%
	}else{
		colorcount=0;
%>
<tr class="DataDark">
	<%
	}
	%>
    <%if(!ajax.equals("1")){%>
		<td height="23"><input type='checkbox' name='wfcheck_node' value="<%=detailid%>" >
    <%}else{%>
		<td height="23"><input type='checkbox' name='wfcheck_node' value="<%=detailid%>" rowindex=<%=rowsum%>>
    <%}%>
<input type="hidden" name="group_<%=rowsum%>_type" size=25 value="<%=type%>" >
<input type="hidden" name="group_<%=rowsum%>_id" size=25 value="<%=objid%>">
<input type="hidden" name="group_<%=rowsum%>_jobobj" value="<%=jobobj%>">
<input type="hidden" name="group_<%=rowsum%>_jobfield" value="<%=jobfield%>">
<input type="hidden" name="group_<%=rowsum%>_level" size=25 value="<%=level%>">
<input type="hidden" name="group_<%=rowsum%>_level2" size=25 value="<%=level2%>">
<input type="hidden" name="group_<%=rowsum%>_condition" size=25 value="<%=conditions%>">
<input type="hidden" name="group_<%=rowsum%>_conditioncn" size=25 value="<%=conditioncn%>">
<input type="hidden" name="group_<%=rowsum%>_oldid" size=25 value="<%=detailid%>">
</td>
<td height="23">
<%
if(type==1)
{%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><%}
if(type==2)
	{%><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%> <%}
if(type==3)
	{%><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <%}
if(type==4)
	{%><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%> <%}
if(type==5)
	{%><%=SystemEnv.getHtmlLabelName(15555,user.getLanguage())%> <%}
if(type==6)
	{%><%=SystemEnv.getHtmlLabelName(15559,user.getLanguage())%> <%}
if(type==7)
	{%><%=SystemEnv.getHtmlLabelName(15562,user.getLanguage())%> <%}
if(type==8)
	{%><%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%> <%}
if(type==9)
	{%><%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%> <%}
if(type==10)
	{%><%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%> <%}
if(type==11)
	{%><%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%> <%}
if(type==12)
	{%><%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%> <%}
if(type==13)
	{%><%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%> <%}
if(type==14)
	{%><%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%> <%}
if(type==15)
	{%><%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%> <%}
if(type==16)
	{%><%=SystemEnv.getHtmlLabelName(15575,user.getLanguage())%> <%}
if(type==17)
	{%><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%> <%}
if(type==18)
	{%><%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%> <%}
if(type==19)
	{%><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%> <%}
if(type==20)
	{%><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%> <%}
if(type==21)
	{%><%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%> <%}
if(type==22)
	{%><%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%> <%}
if(type==23)
	{%><%=SystemEnv.getHtmlLabelName(2113,user.getLanguage())%> <%}
if(type==24)
	{%><%=SystemEnv.getHtmlLabelName(15580,user.getLanguage())%> <%}
if(type==25)
	{%><%=SystemEnv.getHtmlLabelName(15581,user.getLanguage())%> <%}
if(type==30)
    {%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%> <%}
if(type==31)
	{%><%=SystemEnv.getHtmlLabelName(15560,user.getLanguage())%> <%}
if(type==32)
	{%><%=SystemEnv.getHtmlLabelName(15561,user.getLanguage())%> <%}
if(type==33)
	{%><%=SystemEnv.getHtmlLabelName(15565,user.getLanguage())%> <%}
if(type==34)
	{%><%=SystemEnv.getHtmlLabelName(15568,user.getLanguage())%> <%}
if(type==35)
	{%><%=SystemEnv.getHtmlLabelName(15572,user.getLanguage())%> <%}
if(type==36)
	{%><%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%> <%}
if(type==37)
	{%><%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%> <%}
if(type==38)
	{%><%=SystemEnv.getHtmlLabelName(15563,user.getLanguage())%> <%}
if(type==39)
	{%><%=SystemEnv.getHtmlLabelName(15578,user.getLanguage())%> <%}
if(type==40)
	{%><%=SystemEnv.getHtmlLabelName(18676,user.getLanguage())%> <%}
if(type==41)
	{%><%=SystemEnv.getHtmlLabelName(18677,user.getLanguage())%> <%}
if(type==42)
	{%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> <%}
if(type==43)
	{%><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%> <%}
if(type==44)
	{%><%=SystemEnv.getHtmlLabelName(17204,user.getLanguage())%> <%}
if(type==45)
	{%><%=SystemEnv.getHtmlLabelName(18678,user.getLanguage())%> <%}
if(type==46)
	{%><%=SystemEnv.getHtmlLabelName(18679,user.getLanguage())%><%}
if(type==47)
	{%><%=SystemEnv.getHtmlLabelName(18680,user.getLanguage())%> <%}
if(type==48)
	{%><%=SystemEnv.getHtmlLabelName(18681,user.getLanguage())%> <%}
if(type==49)
	{%><%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%> <%}
if(type==50)
	{%><%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%> <%}
if(type==58)
	{%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%> <%}
if(type==59)
	{%><%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())+SystemEnv.getHtmlLabelName(6086,user.getLanguage())%> <%}
if(type==60)
	{%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%> <%}
if(type==61)
	{%><%=SystemEnv.getHtmlLabelName(126610,user.getLanguage())%> <%}
%>
</td>
<td  height="23">
<%
switch (type){
case 1:
case 22:
%>
<%="<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+objid+"' target='_blank'>"+DepartmentComInfo.getDepartmentname(""+objid)+"</a>"%>
<%
break;
case 2:
RecordSet1.executeSql("select rolesmark from hrmroles where id = "+objid);
RecordSet1.next();
%>
<%=RecordSet1.getString(1)%>
<%
break;
case 3:

%>
<%="<a href='/hrm/resource/HrmResource.jsp?id="+objid+"' target='_blank'>"+ResourceComInfo.getResourcename(""+objid)+"</a>"%>
<%
break;
case 5:
case 49:
case 6:
case 7:
case 8:
case 9:
case 10:
case 11:
case 12:
case 13:
case 14:
case 15:
case 16:
case 23:
case 24:
case 31:
case 32:
case 33:
case 34:
case 35:
case 38:
case 42:
case 43:
case 44:
case 45:
case 46:
case 47:
case 48:
case 59:
case 60:
	int index=ids.indexOf(""+objid);
	if(index!=-1){
%>
<%=names.get(index)%>
<%	}
break;
case 20:
%>
<%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(""+objid),user.getLanguage())%>
<%
break;
case 21:
%>
<%=Util.toScreen(CustomerStatusComInfo.getCustomerStatusname(""+objid),user.getLanguage())%>
<%
break;
case 30:
%>
<%="<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+objid+"' target='_blank'>"+SubCompanyComInfo.getSubCompanyname(""+objid)+"</a>"%>
<%
break;
case 50:
int indexs=ids.indexOf(""+objid);
//System.out.print(indexs);
if(indexs!=-1){
%>
<%=names.get(indexs)%>/
<%	}%>
<%=RolesComInfo.getRolesname(""+level)%>
<%
break;
case 58://岗位
	String jobtitlenames = "";
	RecordSet1.executeSql("SELECT jobtitlename FROM HrmJobTitles where id in("+jobobj+")");
	while(RecordSet1.next()){
		if("".equals(jobtitlenames)){
			jobtitlenames = RecordSet1.getString(1);
		}else{
			jobtitlenames += ","+RecordSet1.getString(1);
		}
	}
%>
	<%=jobtitlenames%>
<%
break;
}
%>

</td>
<td height="23">
<%
switch (type){
case 1:
case 4:
case 7:
case 9:
case 11:
case 12:
case 14:
case 19:
case 20:
case 21:
case 22:
case 23:
case 25:
case 30:
case 31:
case 32:
case 33:
case 34:
case 35:
case 36:
case 37:
case 38:
case 39:
case 45:
case 46:
case 42:
%>
<%if(level2!=-1){%>
<%=level%>-<%=level2%>
<%}else{%>
>=<%=level%>
<%}%>
<%
break;
case 2:
 if(level==0){%>
<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
<%}else if(level==1){%>
<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
<%}else if(level==2){%>
<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
<%}
break;
case 58:
case 60:{
	String relatedid = "";
	String relatedsharename = "";
	int index = -1;
	ArrayList relatedsharelist=Util.TokenizerString(jobfield,",");
	for(int i=0;i<relatedsharelist.size();i++){
        if(relatedsharename.equals("")){
            if(level==0) relatedsharename=DepartmentComInfo.getDepartmentname((String)relatedsharelist.get(i));
            if(level==1) relatedsharename=SubCompanyComInfo.getSubCompanyname((String)relatedsharelist.get(i));
            if(level==3){
            	relatedid = (String)relatedsharelist.get(i);
	            index=ids.indexOf(""+relatedid);
				if(index!=-1){
					relatedsharename=String.valueOf(names.get(index));
				}
            }
        }else{
            if(level==0) relatedsharename+=","+DepartmentComInfo.getDepartmentname((String)relatedsharelist.get(i));
            if(level==1) relatedsharename+=","+SubCompanyComInfo.getSubCompanyname((String)relatedsharelist.get(i));
            if(level==3){
            	relatedid = (String)relatedsharelist.get(i);
            	index=ids.indexOf(""+relatedid);
				if(index!=-1){
					relatedsharename += ","+String.valueOf(names.get(index));
				}
            }
        }
	}
	if(level==0){%>
	<%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"("+relatedsharename+")"%>
	<%}else if(level==1){%>
	<%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"("+relatedsharename+")"%>
	<%}else if(level==2){%>
	<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
	<%}else if(level==3){%>
	<%=SystemEnv.getHtmlLabelName(21740,user.getLanguage())+"("+relatedsharename+")"%>
	<%}
	break;
}
case 59:
case 61:{
	if(level==0){%>
	<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
	<%}else if(level==1){%>
	<%=SystemEnv.getHtmlLabelName(21837,user.getLanguage())%>
	<%}else if(level==2){%>
	<%=SystemEnv.getHtmlLabelName(126607,user.getLanguage())%>
	<%}else if(level==3){%>
	<%=SystemEnv.getHtmlLabelName(126608,user.getLanguage())%>
	<%}else if(level==4){%>
	<%=SystemEnv.getHtmlLabelName(30792,user.getLanguage())%>
	<%}else if(level==5){%>
	<%=SystemEnv.getHtmlLabelName(19436,user.getLanguage())%>
	<%}else if(level==6){%>
	<%=SystemEnv.getHtmlLabelName(27189,user.getLanguage())%>
	<%}
	break;
}
}%>
</td>
<td><%=conditioncn%></td>
</tr>

<%
rowsum += 1;
}
oldids=oldids+",";
%>
<input type="hidden" name="oldids" size=25 value="<%=oldids%>">

</table>		
		</wea:item>
	</wea:group>	
</wea:layout>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<jsp:include page="WFUrger_script.jsp">
	<jsp:param value="<%=ajax %>" name="ajax"/>
	<jsp:param value="<%=rowsum %>" name="rowsum"/>
</jsp:include>
</form>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/e8_btn_addOrdel_wev8.js"></script>
</body>
