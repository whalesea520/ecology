
<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*,java.util.*,weaver.hrm.*" %>
<%@ page import="weaver.general.Util,weaver.hrm.common.*" %>
<!-- added by wcd 2014-07-18 [E7 to E8] -->
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="AllSubordinate" class="weaver.hrm.resource.AllSubordinate" scope="page"/>
<jsp:useBean id="SptmForLeave" class="weaver.hrm.resource.SptmForLeave" scope="page"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
<!--
td{font-size:12px}
.title{font-weight:bold;font-size:20px}
-->
</style>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	response.setContentType("application/vnd.ms-excel");
	String departmentid=Util.null2String(request.getParameter("departmentid"));
	String resourceid=Util.null2String(request.getParameter("resourceid"));
	String fromdate =Util.null2String(request.getParameter("fromdate"));
	String todate =Util.null2String(request.getParameter("todate"));

	String attendancetype = Util.null2String(request.getParameter("attendancetype"));
	String attendancetypename = Util.null2String(request.getParameter("attendancetypename"));
	String filename = SystemEnv.getHtmlLabelName(16547,user.getLanguage());
	filename += fromdate+"_"+todate;
	response.setHeader("Content-disposition","attachment;filename="+new String(filename.getBytes("GBK"),"iso8859-1")+".xls");
	
	String hrmid="";
	ArrayList hrmids = new ArrayList();
	hrmids.add(""+user.getUID());
	AllSubordinate.getAll(""+user.getUID());
	while(AllSubordinate.next()){
		hrmids.add(AllSubordinate.getSubordinateID());
	}

	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+SystemEnv.getHtmlLabelName(670,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String isself = Util.null2String(request.getParameter("isself"));
	isself = "1";
	
	String leavesqlwhere = "";
	String leavetype = "";
	String otherleavetype = "";
	if(!attendancetype.equals("")){
		if(Util.TokenizerString2(attendancetype,"_")[0].equals("otherleavetype")){
			otherleavetype = Util.TokenizerString2(attendancetype,"_")[1];
			leavesqlwhere = " and leavetype = 4 and otherleavetype = " + otherleavetype;
		}else{
			leavetype = Util.TokenizerString2(attendancetype,"_")[1];
			leavesqlwhere = " and leavetype = " + leavetype;
		}
	}

	Calendar today = Calendar.getInstance();
	if(fromdate.equals("")) {
		fromdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
						 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-01" ;
	}

	if(todate.equals("")) {
		todate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
						 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
						 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
	}

	String querystr = "";
	if(!departmentid.equals("")) querystr += " and a.departmentid = "+departmentid;
	if(HrmUserVarify.checkUserRight("HrmResource:Absense",user)) {
		if(!resourceid.equals("")) querystr += " and a.resourceid = "+resourceid ;
	} else {
		if(!resourceid.equals("")) 
			querystr += " and a.resourceid = "+resourceid ;
		else {
			for(int i=0 ; i<hrmids.size() ; i++){
				if(i==0)
					hrmid=(String)hrmids.get(i);
				else
					hrmid+=","+(String)hrmids.get(i);
			}
			querystr += " and a.resourceid in ("+hrmid+")" ;
		}
	}
	querystr += " and ((a.fromdate <= '"+todate+"' and a.fromdate >= '"+fromdate+"') or "+
				" (a.todate <= '"+todate+"' and a.todate >= '"+fromdate+"') or (a.todate >= '"+todate+"' and a.fromdate <= '"+fromdate+"')) " ;
	querystr += leavesqlwhere;
	
	String backfields = "c.lastname,a.resourceid,a.leavetype,a.otherleavetype,a.fromdate,a.fromtime,a.todate,a.totime,a.leavedays,a.leavereason,a.requestid,b.requestname ";
	String fromSql  = " bill_bohaileave a left join workflow_requestbase b on a.requestid = b.requestid left join HrmResource c on a.resourceId = c.id ";
	String sqlWhere = " where b.currentnodetype = 3 "+querystr;
	StringBuilder sql = new StringBuilder();
	sql.append(" select ").append(backfields)
	.append(" from ").append(fromSql).append(sqlWhere)
	.append(" order by a.fromdate ,a.fromtime");
	rs.executeSql(sql.toString());
%>
  <table class="ListStyle" border="1" width="100%">
	<tr>
		<td colspan="7" align="center" ><font size=4><b><%=filename%></b></font></td>
	</tr>
	<tr class="Header">
		<th width="20%"><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%></th>
		<th width="10%"><%=SystemEnv.getHtmlLabelName(827, user.getLanguage())%></th>
		<th width="10%"><%=SystemEnv.getHtmlLabelName(828, user.getLanguage())%></th>
		<th width="10%"><%=SystemEnv.getHtmlLabelName(1881, user.getLanguage())%></th>
		<th width="15%"><%=SystemEnv.getHtmlLabelName(742, user.getLanguage())%></th>
		<th width="15%"><%=SystemEnv.getHtmlLabelName(743, user.getLanguage())%></th>
		<th width="20%"><%=SystemEnv.getHtmlLabelName(791, user.getLanguage())%></th>
	</tr>
	<%
		while (rs.next()) {%>
	<tr>
		<td align="left"><%=Tools.vString(rs.getString("requestname"))%></td>
		<td align="left"><%=Tools.vString(rs.getString("lastname"))%></td>
		<td align="left"><%=Tools.vString(rs.getString("leavedays"))%></td>
		<td align="left"><%=new weaver.hrm.resource.SptmForLeave().getLeaveType(Tools.vString(rs.getString("leavetype")),Tools.vString(rs.getString("otherleavetype")))%></td>
		<td align="left"><%=new weaver.hrm.common.SplitPageTagFormat().colFormat(Tools.vString(rs.getString("fromdate")),"{cmd:append[+"+Tools.vString(rs.getString("fromtime"))+"]}")%></td>
		<td align="left"><%=new weaver.hrm.common.SplitPageTagFormat().colFormat(Tools.vString(rs.getString("todate")),"{cmd:append[+"+Tools.vString(rs.getString("totime"))+"]}")%></td>
		<td align="left"><%=Tools.vString(rs.getString("leavereason"))%></td>
	</tr>
	<%	}%>
  </table>