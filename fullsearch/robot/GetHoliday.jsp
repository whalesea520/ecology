
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@page import="java.util.*"%>
<%@ page import="weaver.general.*" %>
<%@page import="net.sf.json.JSONObject"%><%@page import="weaver.hrm.User"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="net.sf.json.JsonConfig"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
    int subCompanyId = 0;
	int departmentId = 0;
	int userid = 0;
	userid=user.getUID();
	if(userid>0){
		departmentId=Util.getIntValue(ResourceComInfo.getDepartmentID(""+userid),0);
	}

	//根据departmentId给、subCompanyId赋值
	if(departmentId>0){
		subCompanyId=Util.getIntValue(DepartmentComInfo.getSubcompanyid1(""+departmentId),0);
	}

	Map result = new HashMap();
	String begindate=Util.null2String(request.getParameter("begindate"));
	String enddate=Util.null2String(request.getParameter("enddate"));
	ArrayList workDays = new ArrayList(); 
	ArrayList holidays = new ArrayList();
	Map<String,String> holidayRemarks = new HashMap<String,String>(); 
    User tempUser=new User();
    String countryid="";

    String sql="select id,lastname,subcompanyid1,countryid from HrmResource where 1=1 ";    
    if(userid>0)
		sql=sql+" and id="+userid;
    if(departmentId>0)
		sql=sql+" and departmentid="+departmentId; 
    if(subCompanyId>0)
		sql=sql+" and subcompanyid1="+subCompanyId; 
    recordSet.execute(sql);
    if(recordSet.next()){
    	countryid=recordSet.getString("countryid");
    }
	//查询公众假日和调配休息日
	StringBuffer sb=new StringBuffer();
	sb.append(" select holidaydate,changetype,holidayname ").append("   from HrmPubHoliday ").append("  where holidayDate >= '").append(begindate).append("' and holidayDate <= '").append(enddate).append("'");

	if(countryid!=null&&(!(countryid.trim().equals("")))){
				sb.append(" and countryId=").append(countryid);
			}
	RecordSet rs=new RecordSet();
	rs.executeSql(sb.toString());
	while(rs.next()){
		if(rs.getString("changetype").equals("1")||rs.getString("changetype").equals("3")){
			holidays.add(Util.null2String(rs.getString("holidaydate")));
		}else{
			workDays.add(Util.null2String(rs.getString("holidaydate")));
		}
		holidayRemarks.put(rs.getString("holidaydate"),rs.getString("holidayname"));
	}
	result.put("workdays", workDays);
	result.put("holidays", holidays);
	result.put("holidayRemarks", holidayRemarks);
	JSONObject obj = JSONObject.fromObject(result);
	out.clearBuffer();
	out.print(obj.toString());
%>