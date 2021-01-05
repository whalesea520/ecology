
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("18125",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->/salary/formula1.jsp");
	}
</script>
</HEAD>
<BODY>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15828,user.getLanguage());
String needfav ="1";
String needhelp ="";
String scope = Util.null2String(request.getParameter("scope"));
String subcompanyid = Util.null2String(request.getParameter("subc"));
String scopetype = Util.null2String(request.getParameter("st"));
String scopevalue = Util.null2String(request.getParameter("sv"));

String supids=SubCompanyComInfo.getAllSupCompany(subcompanyid);
String sqlwhere = "";
String sqlwhere2 = "";
String sqlwhere1="";
if(scope.equals("0")){
  sqlwhere = " select * from HrmSalaryItem where applyscope=0";
  sqlwhere2 = " select * from hrmschedulediff where salaryable!=1 and workflowid=5 and diffscope=0";
}
else if(scope.equals("1")){
    if(supids.endsWith(",")){
    supids=supids.substring(0,supids.length()-1);
  sqlwhere = " select * from HrmSalaryItem where applyscope=0 or (applyscope>0 and subcompanyid="+subcompanyid+") or (applyscope=2 and subcompanyid in("+supids+"))";
   sqlwhere2 = " select * from hrmschedulediff where salaryable!=1 and workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid="+subcompanyid+") or (diffscope=2 and subcompanyid in("+supids+")))";
    }else{
  sqlwhere = " select * from HrmSalaryItem where applyscope=0 or (applyscope>0 and subcompanyid="+subcompanyid+")";
  sqlwhere2 = " select * from hrmschedulediff where salaryable!=1 and workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid="+subcompanyid+"))";
    }
}else if(scope.equals("2")){
    if(supids.endsWith(",")){
    supids=supids.substring(0,supids.length()-1);
  sqlwhere = " select * from HrmSalaryItem where applyscope=0 or (applyscope=2 and subcompanyid in("+supids+","+subcompanyid+"))";
  sqlwhere2 = " select * from hrmschedulediff where salaryable!=1 and workflowid=5 and (diffscope=0 or (diffscope=2 and subcompanyid in("+supids+","+subcompanyid+")))";
    }else{
  sqlwhere = " select * from HrmSalaryItem where applyscope=0 or (applyscope=2 and subcompanyid="+subcompanyid+")";
  sqlwhere2 = " select * from hrmschedulediff where salaryable!=1 and workflowid=5 and (diffscope=0 or (diffscope=2 and subcompanyid="+subcompanyid+"))";
    }
}
   // System.out.println(sqlwhere);
sqlwhere += " order by showorder ";
rs.execute(sqlwhere);

   //System.out.println(sqlwhere);
rs2.execute(sqlwhere2);

ArrayList targetid=new ArrayList();
ArrayList targetname=new ArrayList();
if(scopetype.equals("0")){//全部
   if(scope.equals("0"))
  sqlwhere1 = " select b.* from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and b.areatype=0";
else if(scope.equals("1")){
    if(supids.length()>0){
  sqlwhere1 = " select b.* from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and (b.areatype=0 or (b.areatype=3  and a.companyordeptid="+subcompanyid+") or (b.areatype=1  and b.subcompanyid="+subcompanyid+") or (b.areatype=2 and b.subcompanyid in("+supids+","+subcompanyid+")))";
    }else
  sqlwhere1 = " select b.* from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and (b.areatype=0 or (b.areatype=3 and a.companyordeptid="+subcompanyid+") or (b.areatype=1  and b.subcompanyid="+subcompanyid+") or (b.areatype=2  and b.subcompanyid="+subcompanyid+"))";
}else if(scope.equals("2")){
    if(supids.length()>0){
  sqlwhere1 = " select b.* from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and (b.areatype=0 or (b.areatype=2 and b.subcompanyid in("+supids+","+subcompanyid+")))";
    }else
  sqlwhere1 = " select b.* from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and (b.areatype=0 or (b.areatype=2 and b.subcompanyid="+subcompanyid+"))";
}
rs1.executeSql(sqlwhere1);
 while (rs1.next()) {
                targetid.add(rs1.getString("id"));
                targetname.add(rs1.getString("targetname"));
        }
}else if(scopetype.equals("2")) {//分部
    sqlwhere1 = "select * from hrm_compensationtargetset where areatype<2";
    rs1.executeSql(sqlwhere1);
    if (scopevalue.indexOf(",") > 0) {

        while (rs1.next()) {
            if (rs1.getString("areatype").equals("0")) {
                targetid.add(rs1.getString("id"));
                targetname.add(rs1.getString("targetname"));
            }
        }
    } else {
        while (rs1.next()) {
            if (rs1.getString("areatype").equals("0") || rs1.getString("subcompanyid").equals(scopevalue)) {
                targetid.add(rs1.getString("id"));
                targetname.add(rs1.getString("targetname"));
            }
        }
    }
    sqlwhere1 = "select * from hrm_compensationtargetset where areatype=2";
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        String subid = rs1.getString("subcompanyid");
        ArrayList allsubcoms = new ArrayList();
        allsubcoms.add(subid);
        SubCompanyComInfo.getSubCompanyLists(subid, allsubcoms);
        if (allsubcoms.containsAll(Util.TokenizerString(scopevalue, ","))) {
            targetid.add(rs1.getString("id"));
            targetname.add(rs1.getString("targetname"));
        }

    }
    sqlwhere1 = "select b.id,b.targetname from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and b.areatype=3 and a.companyordeptid in (" + scopevalue + ") group by b.id,b.targetname having count(a.companyordeptid)=" + Util.TokenizerString(scopevalue, ",").size();
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
                targetid.add(rs1.getString("id"));
                targetname.add(rs1.getString("targetname"));
        }
}else if(scopetype.equals("3")) {//部门
    sqlwhere1 = "select * from hrm_compensationtargetset where areatype=0";
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        targetid.add(rs1.getString("id"));
        targetname.add(rs1.getString("targetname"));
    }
    sqlwhere1 = "select * from hrm_compensationtargetset where areatype=1";
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        String subid = rs1.getString("subcompanyid");
        ArrayList depts = new ArrayList();
        while (DepartmentComInfo.next()) {
            if (DepartmentComInfo.getSubcompanyid1().equals(subid))
                depts.add(DepartmentComInfo.getDepartmentid());
        }
        if (depts.containsAll(Util.TokenizerString(scopevalue, ","))) {
            targetid.add(rs1.getString("id"));
            targetname.add(rs1.getString("targetname"));
        }
    }
    sqlwhere1 = "select * from hrm_compensationtargetset where areatype=2";
    rs1.executeSql(sqlwhere1);
    ArrayList arr_subids = new ArrayList();
    ArrayList arr_scopevalue = Util.TokenizerString(scopevalue, ",");
    for (Iterator iter = arr_scopevalue.iterator(); iter.hasNext();) {
        String thesubcomid = DepartmentComInfo.getSubcompanyid1((String) iter.next());
        if (!arr_subids.contains(thesubcomid))
            arr_subids.add(thesubcomid);
    }
    String subids = "";
    for (Iterator iter = arr_subids.iterator(); iter.hasNext();) {
        if (subids.equals(""))
            subids = subids + (String) iter.next();
        else
            subids = subids + "," + (String) iter.next();
    }

    while (rs1.next()) {
        String subid = rs1.getString("subcompanyid");
        ArrayList allsubcoms = new ArrayList();
        allsubcoms.add(subid);
        SubCompanyComInfo.getSubCompanyLists(subid, allsubcoms);
        if (allsubcoms.containsAll(Util.TokenizerString(subids, ","))) {
            targetid.add(rs1.getString("id"));
            targetname.add(rs1.getString("targetname"));
        }

    }
    sqlwhere1 = "select b.id,b.targetname from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and b.areatype=3 and a.companyordeptid in (" + subids + ") group by b.id,b.targetname having count(a.companyordeptid)=" + Util.TokenizerString(subids, ",").size();
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        targetid.add(rs1.getString("id"));
        targetname.add(rs1.getString("targetname"));
    }
    sqlwhere1 = "select b.id,b.targetname from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and b.areatype=4 and a.companyordeptid in (" + scopevalue + ") group by b.id,b.targetname having count(a.companyordeptid)=" + Util.TokenizerString(scopevalue, ",").size();
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        targetid.add(rs1.getString("id"));
        targetname.add(rs1.getString("targetname"));
    }
}else if(scopetype.equals("4")){//人力资源

    sqlwhere1 = "select * from hrm_compensationtargetset where areatype=0";
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        targetid.add(rs1.getString("id"));
        targetname.add(rs1.getString("targetname"));
    }
    sqlwhere1 = "select * from hrm_compensationtargetset where areatype=1";
    rs1.executeSql(sqlwhere1);
    ArrayList arr_deptids=new ArrayList();
    ArrayList arr_scopevalue = Util.TokenizerString(scopevalue, ",");
    for (Iterator iter = arr_scopevalue.iterator(); iter.hasNext();) {
        String thedeptid = ResourceComInfo.getDepartmentID((String)iter.next());
        if (!arr_deptids.contains(thedeptid))
            arr_deptids.add(thedeptid);
    }
    String deptids = "";
    for (Iterator iter = arr_deptids.iterator(); iter.hasNext();) {
        if (deptids.equals(""))
            deptids = deptids + (String) iter.next();
        else
            deptids = deptids + "," + (String) iter.next();
    }
    while (rs1.next()) {
        String subid = rs1.getString("subcompanyid");
        ArrayList depts = new ArrayList();
        while (DepartmentComInfo.next()) {
            if (DepartmentComInfo.getSubcompanyid1().equals(subid))
                depts.add(DepartmentComInfo.getDepartmentid());
        }
        if (depts.containsAll(Util.TokenizerString(deptids, ","))) {
            targetid.add(rs1.getString("id"));
            targetname.add(rs1.getString("targetname"));
        }
    }
    sqlwhere1 = "select * from hrm_compensationtargetset where areatype=2";
    rs1.executeSql(sqlwhere1);
    ArrayList arr_subids = new ArrayList();
    for (Iterator iter = arr_deptids.iterator(); iter.hasNext();) {
        String thesubcomid = DepartmentComInfo.getSubcompanyid1((String) iter.next());
        if (!arr_subids.contains(thesubcomid))
            arr_subids.add(thesubcomid);
    }
    String subids = "";
    for (Iterator iter = arr_subids.iterator(); iter.hasNext();) {
        if (subids.equals(""))
            subids = subids + (String) iter.next();
        else
            subids = subids + "," + (String) iter.next();
    }

    while (rs1.next()) {
        String subid = rs1.getString("subcompanyid");
        ArrayList allsubcoms = new ArrayList();
        allsubcoms.add(subid);
        SubCompanyComInfo.getSubCompanyLists(subid, allsubcoms);
        if (allsubcoms.containsAll(Util.TokenizerString(subids, ","))) {
            targetid.add(rs1.getString("id"));
            targetname.add(rs1.getString("targetname"));
        }

    }
    sqlwhere1 = "select b.id,b.targetname from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and b.areatype=3 and a.companyordeptid in (" + subids + ") group by b.id,b.targetname having count(a.companyordeptid)=" + Util.TokenizerString(subids, ",").size();
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        targetid.add(rs1.getString("id"));
        targetname.add(rs1.getString("targetname"));
    }
    sqlwhere1 = "select b.id,b.targetname from hrm_comtargetsetdetail a,hrm_compensationtargetset b where a.targetid=b.id and b.areatype=4 and a.companyordeptid in (" + deptids + ") group by b.id,b.targetname having count(a.companyordeptid)=" + Util.TokenizerString(scopevalue, ",").size();
    rs1.executeSql(sqlwhere1);
    while (rs1.next()) {
        targetid.add(rs1.getString("id"));
        targetname.add(rs1.getString("targetname"));
    }

}
%>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%  
		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btok(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btclose(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btclear(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
%>
	    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="zDialog_div_content">
<form name="weaver">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
<wea:group context='<%=SystemEnv.getHtmlLabelName(83481,user.getLanguage()) %>'>
	<wea:item attributes="{'colspan':'full','isTableList':'true'}">
		<select id="checks0" name="checks0" onchange="getText0()" style="width: 100px">
		<option></option>
		<%while(rs.next()){
		if(!rs.getString("itemtype").equals("9")){%>
		<option value='<%=rs.getString("id")%>' alias='<%=rs.getString("itemcode")%>'><%=rs.getString("itemname")%></option>
		<%}else{%>
		<option value='<%=rs.getString("id")+"_1"%>' alias='<%=rs.getString("itemcode")+"_1"%>'><%=rs.getString("itemname")+"("+SystemEnv.getHtmlLabelName(6087,user.getLanguage())+")"%></option>
		<option value='<%=rs.getString("id")+"_2"%>' alias='<%=rs.getString("itemcode")+"_2"%>'><%=rs.getString("itemname")+"("+SystemEnv.getHtmlLabelName(1851,user.getLanguage())+")"%></option>
		<%}%>
		<%}%>
		</select>
		<select id="checks" name="checks" onchange="getText()" style="width: 100px">
			<option></option>
			<%while(rs2.next()){%>
			<option value='<%=rs2.getString("id")%>'><%=rs2.getString("diffname")%></option>
			<%}%>
		</select>
    <select id = 'timescope' name = 'timescope' style="width: 100px">
	    <option value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>
	    <option value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>
	    <option value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>
	    <option value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>
    </select>
		<select id = 'checks1' name = 'checks1' onchange="getText1()" style="width: 100px">
     <option></option>
     <%for(Iterator iter=targetid.iterator();iter.hasNext();){
         String value=(String)iter.next();
         String label=(String)targetname.get(targetid.indexOf(value));
     %>
      <option value=<%=value%>><%=label%></option>
     <%}%>
    </select>
	  <span>
			<%=SystemEnv.getHtmlLabelName(33443 , user.getLanguage())%>
			<img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/+_wev8.png" onmouseover="jsChangeBackImg(this,'+hot_wev8.png')" onmouseout="jsChangeBackImg(this,'+_wev8.png')" onclick="jsSetConditons('+')">
			<img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/-normal_wev8.png" onmouseover="jsChangeBackImg(this,'-hot_wev8.png')" onmouseout="jsChangeBackImg(this,'-normal_wev8.png')" onclick="jsSetConditons('-')">
			<img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/chennormal_wev8.png" onmouseover="jsChangeBackImg(this,'chenhot_wev8.png')" onmouseout="jsChangeBackImg(this,'chennormal_wev8.png')" onclick="jsSetConditons('*')">
			<img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/chunormal_wev8.png" onmouseover="jsChangeBackImg(this,'chuhot_wev8.png')" onmouseout="jsChangeBackImg(this,'chunormal_wev8.png')" onclick="jsSetConditons('/')">
			<img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/(normal_wev8.png" onmouseover="jsChangeBackImg(this,'(hot_wev8.png')" onmouseout="jsChangeBackImg(this,'(normal_wev8.png')" onclick="jsSetConditons('(')">
			<img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/)normal_wev8.png" onmouseover="jsChangeBackImg(this,')hot_wev8.png')" onmouseout="jsChangeBackImg(this,')normal_wev8.png')" onclick="jsSetConditons(')')">
		</span>
	</wea:item>
	<wea:item attributes="{'isTableList':'true','colspan':'full'}">
		<table width="620px" id="formulaTable">
			<colgroup>
			<col width="30%">
			<col width="70%">
			<tr>
				<td>
					<textarea class=inputstyle readonly="true" rows="8" cols="30" id=formula name=formula style="color: #FF0000;font-size: 10pt;width: 500px;height: 100%"></textarea>
					<input type="hidden" name="formulaid" id="formulaid">
				</td>
				<td>
					<table class=viewform >
					<COLGROUP> <COL width="33%"> <COL width="33%"> <COL width="33%"><TBODY>
						<tr>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/7normal_wev8.png" onmouseover="jsChangeBackImg(this,'7hot_wev8.png')" onmouseout="jsChangeBackImg(this,'7normal_wev8.png')" onclick="jsSetConditons('7')"></td>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/8normal_wev8.png" onmouseover="jsChangeBackImg(this,'8hot_wev8.png')" onmouseout="jsChangeBackImg(this,'8normal_wev8.png')" onclick="jsSetConditons('8')"></td>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/9normal_wev8.png" onmouseover="jsChangeBackImg(this,'9hot_wev8.png')" onmouseout="jsChangeBackImg(this,'9normal_wev8.png')" onclick="jsSetConditons('9')"></td>
						</tr>
						<tr>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/4normal_wev8.png" onmouseover="jsChangeBackImg(this,'4hot_wev8.png')" onmouseout="jsChangeBackImg(this,'4normal_wev8.png')" onclick="jsSetConditons('4')"></td>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/5normal_wev8.png" onmouseover="jsChangeBackImg(this,'5hot_wev8.png')" onmouseout="jsChangeBackImg(this,'5normal_wev8.png')" onclick="jsSetConditons('5')"></td>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/6normal_wev8.png" onmouseover="jsChangeBackImg(this,'6hot_wev8.png')" onmouseout="jsChangeBackImg(this,'6normal_wev8.png')" onclick="jsSetConditons('6')"></td>
						</tr>
						<tr>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/1normal_wev8.png" onmouseover="jsChangeBackImg(this,'1hot_wev8.png')" onmouseout="jsChangeBackImg(this,'1normal_wev8.png')" onclick="jsSetConditons('1')"></td>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/2normal_wev8.png" onmouseover="jsChangeBackImg(this,'2hot_wev8.png')" onmouseout="jsChangeBackImg(this,'2normal_wev8.png')" onclick="jsSetConditons('2')"></td>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/3normal_wev8.png" onmouseover="jsChangeBackImg(this,'3hot_wev8.png')" onmouseout="jsChangeBackImg(this,'3normal_wev8.png')" onclick="jsSetConditons('3')"></td>
						</tr>
						<tr>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/0normal_wev8.png" onmouseover="jsChangeBackImg(this,'0hot_wev8.png')" onmouseout="jsChangeBackImg(this,'0normal_wev8.png')" onclick="jsSetConditons('0')"></td>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/dotnormal_wev8.png" onmouseover="jsChangeBackImg(this,'dothot_wev8.png')" onmouseout="jsChangeBackImg(this,'dotnormal_wev8.png')" onclick="jsSetConditons('.')"></td>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/backnormal_wev8.png" onmouseover="jsChangeBackImg(this,'backhot_wev8.png')" onmouseout="jsChangeBackImg(this,'backnormal_wev8.png')" onclick="jsSetConditons('←')"></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</wea:item>
</wea:group>
</wea:layout>
</form>
<%rs.beforFirst();rs2.beforFirst();%>
<form name="weaver1">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(83482 , user.getLanguage())%>'>
		<wea:item attributes="{'colspan':'full','isTableList':'true'}">
		<select id="checks0_1" name="checks0_1" onchange="getText0_1()" style="width: 100px">
		<option></option>
		<%while(rs.next()){
		if(!rs.getString("itemtype").equals("9")){%>
		<option value='<%=rs.getString("id")%>' alias='<%=rs.getString("itemcode")%>'><%=rs.getString("itemname")%></option>
		<%}else{%>
		<option value='<%=rs.getString("id")+"_1"%>' alias='<%=rs.getString("itemcode")+"_1"%>'><%=rs.getString("itemname")+"("+SystemEnv.getHtmlLabelName(6087,user.getLanguage())+")"%></option>
		<option value='<%=rs.getString("id")+"_2"%>' alias='<%=rs.getString("itemcode")+"_2"%>'><%=rs.getString("itemname")+"("+SystemEnv.getHtmlLabelName(1851,user.getLanguage())+")"%></option>
		<%}%>
		<%}%>
		</select>
		<select id="checks_1" name="checks_1" onchange="getText_1()" style="width: 100px">
		<option></option>
		<%while(rs2.next()){%>
		<option value='<%=rs2.getString("id")%>'><%=rs2.getString("diffname")%></option>
		<%}%>
		</select>
    <select  id = 'timescope1' name = 'timescope1' style="width: 100px">
    <option value=1><%=SystemEnv.getHtmlLabelName(17138 , user.getLanguage())%></option>
    <option value=2><%=SystemEnv.getHtmlLabelName(19483 , user.getLanguage())%></option>
    <option value=3><%=SystemEnv.getHtmlLabelName(17495 , user.getLanguage())%></option>
    <option value=4><%=SystemEnv.getHtmlLabelName(19398 , user.getLanguage())%></option>
    </select>
		<select id = 'checks1_1' name = 'checks1_1' onchange="getText1_1()" style="width: 100px">
     <option></option>
     <%for(Iterator iter=targetid.iterator();iter.hasNext();){
         String value=(String)iter.next();
         String label=(String)targetname.get(targetid.indexOf(value));
     %>
      <option value=<%=value%>><%=label%></option>
     <%}%>
     </select>
  		<span>
				<%=SystemEnv.getHtmlLabelName(33443 , user.getLanguage())%>
				<img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/+_wev8.png" onmouseover="jsChangeBackImg(this,'+hot_wev8.png')" onmouseout="jsChangeBackImg(this,'+_wev8.png')" onclick="jsSetConditons1('+')">
				<img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/-normal_wev8.png" onmouseover="jsChangeBackImg(this,'-hot_wev8.png')" onmouseout="jsChangeBackImg(this,'-normal_wev8.png')" onclick="jsSetConditons1('-')">
				<img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/chennormal_wev8.png" onmouseover="jsChangeBackImg(this,'chenhot_wev8.png')" onmouseout="jsChangeBackImg(this,'chennormal_wev8.png')" onclick="jsSetConditons1('*')">
				<img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/chunormal_wev8.png" onmouseover="jsChangeBackImg(this,'chuhot_wev8.png')" onmouseout="jsChangeBackImg(this,'chunormal_wev8.png')" onclick="jsSetConditons1('/')">
				<img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/(normal_wev8.png" onmouseover="jsChangeBackImg(this,'(hot_wev8.png')" onmouseout="jsChangeBackImg(this,'(normal_wev8.png')" onclick="jsSetConditons1('(')">
				<img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/)normal_wev8.png" onmouseover="jsChangeBackImg(this,')hot_wev8.png')" onmouseout="jsChangeBackImg(this,')normal_wev8.png')" onclick="jsSetConditons1(')')">
			</span>
		</wea:item>
	<wea:item attributes="{'isTableList':'true','colspan':'full'}">
		<table width="620px" id="formulaTable">
			<colgroup>
			<col width="30%">
			<col width="70%">
			<tr>
				<td>
					<textarea class=inputstyle readonly="true" rows="8" cols="30" id=formula1 name=formula1 style="color: #FF0000;font-size: 10pt;width: 500px;height: 100%"></textarea>
					<input type="hidden" name="formulaid1" id="formulaid1">
				</td>
				<td>
					<table class=viewform width="100%" id="formulaTable1">
					<COLGROUP> <COL width="33%"> <COL width="33%"> <COL width="33%"><TBODY>
						<tr>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/7normal_wev8.png" onmouseover="jsChangeBackImg(this,'7hot_wev8.png')" onmouseout="jsChangeBackImg(this,'7normal_wev8.png')" onclick="jsSetConditons1('7')"></td>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/8normal_wev8.png" onmouseover="jsChangeBackImg(this,'8hot_wev8.png')" onmouseout="jsChangeBackImg(this,'8normal_wev8.png')" onclick="jsSetConditons1('8')"></td>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/9normal_wev8.png" onmouseover="jsChangeBackImg(this,'9hot_wev8.png')" onmouseout="jsChangeBackImg(this,'9normal_wev8.png')" onclick="jsSetConditons1('9')"></td>
						</tr>
						<tr>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/4normal_wev8.png" onmouseover="jsChangeBackImg(this,'4hot_wev8.png')" onmouseout="jsChangeBackImg(this,'4normal_wev8.png')" onclick="jsSetConditons1('4')"></td>							
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/5normal_wev8.png" onmouseover="jsChangeBackImg(this,'5hot_wev8.png')" onmouseout="jsChangeBackImg(this,'5normal_wev8.png')" onclick="jsSetConditons1('5')"></td>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/6normal_wev8.png" onmouseover="jsChangeBackImg(this,'6hot_wev8.png')" onmouseout="jsChangeBackImg(this,'6normal_wev8.png')" onclick="jsSetConditons1('6')"></td>
						</tr>
						<tr>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/1normal_wev8.png" onmouseover="jsChangeBackImg(this,'1hot_wev8.png')" onmouseout="jsChangeBackImg(this,'1normal_wev8.png')" onclick="jsSetConditons1('1')"></td>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/2normal_wev8.png" onmouseover="jsChangeBackImg(this,'2hot_wev8.png')" onmouseout="jsChangeBackImg(this,'2normal_wev8.png')" onclick="jsSetConditons1('2')"></td>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/3normal_wev8.png" onmouseover="jsChangeBackImg(this,'3hot_wev8.png')" onmouseout="jsChangeBackImg(this,'3normal_wev8.png')" onclick="jsSetConditons1('3')"></td>
						</tr>
						<tr>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/0normal_wev8.png" onmouseover="jsChangeBackImg(this,'0hot_wev8.png')" onmouseout="jsChangeBackImg(this,'0normal_wev8.png')" onclick="jsSetConditons1('0')"></td>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/dotnormal_wev8.png" onmouseover="jsChangeBackImg(this,'dothot_wev8.png')" onmouseout="jsChangeBackImg(this,'dotnormal_wev8.png')" onclick="jsSetConditons1('.')"></td>
							<td align="center"><img style="vertical-align: middle;" src="/hrm/finance/salary/salayimage/backnormal_wev8.png" onmouseover="jsChangeBackImg(this,'backhot_wev8.png')" onmouseout="jsChangeBackImg(this,'backnormal_wev8.png')" onclick="jsSetConditons1('←')"></td>
						</tr>
					</table>
				</td>
				</tr>
			</table>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
    <wea:group context="">
    	<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit"  class="zd_btn_submit" onclick="btok();">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btclose();">   
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit"  class="zd_btn_submit" onclick="btclear();">
    	</wea:item>
   	</wea:group>
  </wea:layout>
</div>
<script language="javascript">
function jsSetConditons1(newEntry){
	var v=jQuery("#formula1").val();
	var reg=/[+\-*/]/;
	if (newEntry=="←")
	{
		jQuery("#formula1").val("");
		jQuery("#formulaid1").va("");
		return;
	}
	if ((reg.test(newEntry)&&reg.test(v.substring(v.length-1,v.length))))
	{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
	}
	jQuery("#formula1").val(jQuery("#formula1").val()+newEntry);
	jQuery("#formulaid1").val(jQuery("#formulaid1").val()+newEntry);
}

function jsChangeBackImg(obj,imgname){
	jQuery(obj).attr("src","/hrm/finance/salary/salayimage/"+imgname)
}

function jsSetConditons(newEntry){
	var v=jQuery("#formula").val();
	var reg=/[+\-*/]/;
	if (newEntry=="←")
	{
		jQuery("#formula").val("");
		jQuery("#formulaid").val("");
		return;
	}
	if ((reg.test(newEntry)&&reg.test(v.substring(v.length-1,v.length))))
	{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
	}
	jQuery("#formula").val(jQuery("#formula").val()+newEntry);
	jQuery("#formulaid").val(jQuery("#formulaid").val()+newEntry);
}
</script>
<script>
 var parentWin = parent.parent.getParentWindow(parent);
 var dialog = parent.parent.getDialog(parent);

function getText()
{
       var reg=/[+\-*/\(\)]/;
       var v=jQuery("#formula").val();
       if (jQuery("#checks").val()=="")
       {
       window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       jQuery("#formula").val(jQuery("#formula").val() + document.weaver.checks.options[document.weaver.checks.selectedIndex].text);
       var temp;
       temp="@"+jQuery("#checks").val()+"@";
       jQuery("#formulaid").val(jQuery("#formulaid").val()+temp);
}
function getText0()
{
       var reg=/[+\-*/\(\)]/;
       var v=jQuery("#formula").val();
        if (jQuery("#checks0").val()=="")
       {
       window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       jQuery("#formula").val(jQuery("#formula").val() + document.weaver.checks0.options[document.weaver.checks0.selectedIndex].text);
       var temp;
       temp="#"+jQuery("#checks0").val()+"#";
       jQuery("#formulaid").val(jQuery("#formulaid").val()+temp);
}
function getText1()
{
       var reg=/[+\-*/\(\)]/;
       var v=jQuery("#formula").val();
       if (jQuery("#checks1").val()=="")
       {
       window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       jQuery("#formula").val(jQuery("#formula").val() + document.weaver.checks1.options[document.weaver.checks1.selectedIndex].text+ "("+document.weaver.timescope.options[document.weaver.timescope.selectedIndex].text+")");
       var temp;
       temp="$"+jQuery("#checks1").val()+"("+document.weaver.timescope.value+")"+"$";
       jQuery("#formulaid").val(jQuery("#formulaid").val()+temp);
}
function getText2()
{
       var reg=/[+\-*/\(\)]/;
       var v=jQuery("#formula").val();
        if (jQuery("#countsalary").val()=="")
       {
       window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       jQuery("#formula").val(jQuery("#formula").val() + jQuery("#countsalary").html());
       var temp;
       temp="^";
       jQuery("#formulaid").val(jQuery("#formulaid").val()+temp);
}

function getText_1()
{
       var reg=/[+\-*/\(\)]/;
       var v=jQuery("#formula1").val();
        if (jQuery("#checks_1").val()=="")
       {
       window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       jQuery("#formula1").val(jQuery("#formula1").val() + document.weaver1.checks_1.options[document.weaver1.checks_1.selectedIndex].text);
       var temp;
       temp="@"+jQuery("#checks_1").val()+"@";
       jQuery("#formulaid1").val(jQuery("#formulaid1").val()+temp);
}
function getText0_1()
{
       var reg=/[+\-*/\(\)]/;
       var v=jQuery("#formula1").val();
        if (jQuery("#checks0_1").val()=="")
       {
       window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       jQuery("#formula1").val(jQuery("#formula1").val() + document.weaver1.checks0_1.options[document.weaver1.checks0_1.selectedIndex].text);

       var temp;
       temp="#"+jQuery("checks0_1").val()+"#";
       jQuery("#formulaid1").val(jQuery("#formulaid1").val()+temp);
}
function getText1_1()
{
       var reg=/[+\-*/\(\)]/;
       var v=jQuery("#formula1").val();
       if (jQuery("#checks1_1").val()=="")
       {
       window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       jQuery("#formula1").val(jQuery("#formula1").val() + document.weaver1.checks1_1.options[document.weaver1.checks1_1.selectedIndex].text+ "("+document.weaver1.timescope1.options[document.weaver1.timescope1.selectedIndex].text+")");
       var temp;
       temp="$"+jQuery("#checks1_1").val()+"("+document.weaver1.timescope1.value+")"+"$";
       jQuery("#formulaid1").val(jQuery("#formulaid1").val()+temp);
}
function getText2_1()
{
       var reg=/[+\-*/\(\)]/;
       var v=jQuery("#formula1").val();
        if (jQuery("#countsalary1").val()=="")
       {
       window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");
       return;
       }
       if (!reg.test(v.substring(v.length-1,v.length))&&(v!=""))
		{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18098,user.getLanguage())%>");
		return;
		}
       jQuery("#formula1").val(jQuery("#formula1").val() + jQuery("#countsalary1").html());
       var temp;
       temp="^";
       jQuery("#formulaid1").val(jQuery("#formulaid1").val()+temp);
}
function btclear(){
var returnjson = {id:"",name:""};
	if(dialog){
	   try{
	    dialog.callback(returnjson);
	   }catch(e){}
	   try{
	    dialog.close(returnjson);
	   }catch(e){}
	}else{  
	    window.parent.returnValue  = returnjson;
	window.parent.close();
	 }
}

function  btok(){
	var id,name;
	id=jQuery("#formulaid").val()+";"+jQuery("#formulaid1").val();
	name=jQuery("#formula").val()+";"+jQuery("#formula1").val();
	var returnjson = {id:id,name:name};
	if(dialog){
	   try{
	    dialog.callback(returnjson);
	   }catch(e){}
	   try{
	    dialog.close(returnjson);
	   }catch(e){}
	}else{  
	    window.parent.returnValue  = returnjson;
	window.parent.close();
	 }
}
function btclose(){
if(dialog){
	   try{
	    dialog.close();
	   }catch(e){}
	}else{  
	    window.parent.close();
	 }
}
</script>
</BODY>
</HTML>
