
<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*,java.util.*,weaver.hrm.*" %>
<%@ page import="weaver.general.Util,weaver.hrm.common.*" %>
<!-- added by wcd 2014-07-17 [E7 to E8] -->
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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
	String fromdate = Util.fromScreen(request.getParameter("fromdate") , user.getLanguage());
	String enddate = Util.fromScreen(request.getParameter("enddate") , user.getLanguage());
	String department = Util.fromScreen(request.getParameter("department") , user.getLanguage());
	String filename = SystemEnv.getHtmlLabelName(16674,user.getLanguage());
	filename += fromdate+"_"+enddate;
	response.setHeader("Content-disposition","attachment;filename="+new String(filename.getBytes(),"iso8859-1")+".xls");
	
	Calendar thedate = Calendar.getInstance();
	if( fromdate.equals("") || enddate.equals("")) {
		thedate.add(Calendar.DATE , 0) ; 
		fromdate = Util.add0(thedate.get(Calendar.YEAR), 4) + "-" + 
				   Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
				   Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
		thedate.add(Calendar.DATE , 7) ; 
		enddate = Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
				  Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
				  Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
	}
	ArrayList selectdates = new ArrayList();
	ArrayList selectweekdays = new ArrayList();

	String resourceSql = "";
	String backfields = " a.id,a.resourceid,a.shiftdate,a.shiftid,b.lastname,b.departmentid,c.shiftname,b.seclevel "; 
	String fromSql  = " HrmArrangeShiftInfo a left join Hrmresource b on a.resourceid = b.id left join HrmArrangeShift c on a.shiftid = c.id ";
	String sqlWhere = "";
	String jsonStr = "";

	int fromyear = Util.getIntValue(fromdate.substring(0 , 4)) ; 
    int frommonth = Util.getIntValue(fromdate.substring(5 , 7)) ; 
    int fromday = Util.getIntValue(fromdate.substring(8 , 10)) ; 
    String tempdate = fromdate ; 

    thedate.set(fromyear,frommonth - 1 , fromday) ; 

    while( tempdate.compareTo(enddate) <= 0 ) {
        selectdates.add(tempdate) ; 
        selectweekdays.add("" + thedate.get(Calendar.DAY_OF_WEEK)) ; 

        thedate.add(Calendar.DATE , 1) ; 
        tempdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                    Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                    Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
    }

	resourceSql = "select a.id from hrmresource a, (select min(level_from) as minLevel,max(level_to) as maxLevel from HrmArrangeShiftSet where sharetype = 2 ";
    String relatedSql = "";
	String departmentSql = "";
	if(!department.equals("")) {
		relatedSql = " and relatedId = "+department;
        departmentSql = " and departmentid = " + department ; 
    } 
	resourceSql += relatedSql+" group by sharetype) b where seclevel between b.minLevel and b.maxLevel "+departmentSql;
	sqlWhere += " where b.id in ("+resourceSql+") ";
	StringBuilder sql = new StringBuilder()
	.append(" select ").append(backfields)
	.append(" from ").append(fromSql)
	.append(sqlWhere).append(" and shiftdate between '"+fromdate+"' and '"+enddate+"' ")
	.append(" order by b.seclevel asc,a.id asc,a.shiftdate asc");
    rs.executeSql(sql.toString()) ; 
	
	StringBuilder sqlResult = new StringBuilder();
	sqlResult.append("{json:[");
    while( rs.next() ) { 
		sqlResult.append("{resourceid:'").append(Util.null2String(rs.getString("resourceid"))).append("',")
		.append("shiftdate:'").append(Util.null2String(rs.getString("shiftdate"))).append("',")
		.append("shiftname:'").append(Util.null2String(rs.getString("shiftname"))).append("'},");
    }
	jsonStr = sqlResult.toString();
	if(jsonStr.endsWith(",")){
		jsonStr = jsonStr.substring(0,jsonStr.length()-1);
	}
	jsonStr += "]}";
	
	backfields = "a.resourceid,b.lastname,b.seclevel";
	fromSql  = " (select a.resourceid from HrmArrangeShiftInfo a left join Hrmresource b on a.resourceid = b.id "+sqlWhere+" group by a.resourceid ) a left join HrmResource b on a.resourceid = b.id";
	sql.setLength(0);
	sql.append(" select ").append(backfields)
	.append(" from ").append(fromSql)
	.append(" order by b.seclevel");
	rs.executeSql(sql.toString());
%>
  <table class="ListStyle" border="1">
	<tr class="Header">
		<th width="7%"><%=SystemEnv.getHtmlLabelName(413, user.getLanguage())%></th>
		<%
			for(int i = 0 ; i < selectdates.size() ; i++ ) {
				String selectDate = String.valueOf(selectdates.get(i));
				String showDate = Tools.formatDate(selectDate,"M"+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+"d"+SystemEnv.getHtmlLabelName(390,user.getLanguage()))+"(";
				showDate += new weaver.hrm.common.SplitPageTagFormat().colFormat(String.valueOf(selectweekdays.get(i)),"{cmd:array["+user.getLanguage()+";1=16106,2=16100,3=16101,4=16102,5=16103,6=16104,7=16105]}");
				showDate+=")";
		%>
		<th width="<%=93/selectdates.size()%>%"><%=showDate%></th>
		<%	}%>
	</tr>
	<%
		while (rs.next()) {%>
	<tr>
		<td><%=Tools.vString(rs.getString("lastname"))%></td>
		<%
			String resourceid = Tools.vString(rs.getString("resourceid"));
			for(int i = 0 ; i < selectdates.size() ; i++ ) {
				String selectDate = String.valueOf(selectdates.get(i));
		%>
		<td><%=new weaver.hrm.common.SplitPageTagFormat().colFormat(resourceid,"{cmd:json[shiftname;resourceid="+resourceid+"+and+shiftdate="+selectDate+";"+jsonStr+"]}")%></td>
		<%	}%>
	</tr>
	<%	}%>
  </table>