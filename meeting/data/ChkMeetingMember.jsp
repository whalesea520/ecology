<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.conn.DBUtil" %>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%

	String hrmids=Util.null2String(request.getParameter("hrmids"));
	String crmids=Util.null2String(request.getParameter("crmids"));
	String begindate=Util.null2String(request.getParameter("begindate"));
	String begintime=Util.null2String(request.getParameter("begintime"));
	String enddate=Util.null2String(request.getParameter("enddate"));
	String endtime=Util.null2String(request.getParameter("endtime"));
	String requestid = Util.null2String(request.getParameter("requestid"));
	String meetingids=Util.null2String(request.getParameter("meetingid"));
	String memberconflict=Util.null2String(request.getParameter("memberconflict"));
	if(hrmids.startsWith(",")){
		hrmids=hrmids.substring(1);
	}
	if(hrmids.endsWith(",")){
		hrmids=hrmids.substring(0,hrmids.length()-1);
	}
	if(crmids.startsWith(",")){
		crmids=crmids.substring(1);
	}
	if(crmids.endsWith(",")){
		crmids=crmids.substring(0,crmids.length()-1);
	}
	
	if(!"".equals(requestid)&&!"-1".equals(requestid)) {
		   RecordSet.executeQuery("select approveid from Bill_Meeting where requestid= ?",requestid);
		   if(RecordSet.next()) {
			  meetingids = Util.null2String(RecordSet.getString("approveid"));
		   }
		}
	
	String sql = "";
	if("oracle".equalsIgnoreCase(RecordSet.getDBType())){
		sql = "SELECT m.name,mm.memberid, mm.membertype,m.begindate,m.begintime,m.enddate,m.endtime FROM Meeting m, Meeting_Member2 mm WHERE mm.meetingid = m.id and m.repeatType = 0"
		+" AND m.meetingstatus in (1,2) and m.isdecision<2 and (m.cancel is null or m.cancel<>'1') "
		+" and (mm.memberid IN ("+DBUtil.getParamReplace(hrmids)+") AND mm.membertype = 1) AND m.begindate || ' ' || m.begintime < ? "
		+" AND m.enddate || ' ' || m.endtime > ? ";
		if(!"".equals(meetingids)){
			sql += " AND m.id <> ?";
		}
		if(crmids.length() > 0){
			sql += " UNION ALL "
			+" SELECT m.name,mm.memberid, mm.membertype,m.begindate,m.begintime,m.enddate,m.endtime FROM Meeting m, Meeting_Member2 mm WHERE mm.meetingid = m.id and m.repeatType = 0 "
			+" AND m.meetingstatus in (1,2) and m.isdecision<2 and (m.cancel is null or m.cancel<>'1') "
			+" and (mm.memberid IN ("+DBUtil.getParamReplace(crmids)+") AND mm.membertype = 2) AND m.begindate || ' ' || m.begintime < ? "
			+" AND m.enddate || ' ' || m.endtime > ? ";
			if(!"".equals(meetingids)){
				sql += " AND m.id <> ?";
			}
		}
		
	} else {
		sql = "SELECT m.name,mm.memberid, mm.membertype,m.begindate,m.begintime,m.enddate,m.endtime FROM Meeting m, Meeting_Member2 mm WHERE mm.meetingid = m.id and m.repeatType = 0 "
		+" AND m.meetingstatus in (1,2) and m.isdecision<2 and (m.cancel is null or m.cancel<>'1') "
		+" and (mm.memberid IN ("+DBUtil.getParamReplace(hrmids)+") AND mm.membertype = 1) AND m.begindate + ' ' + m.begintime < ? "
		+" AND m.enddate + ' ' + m.endtime > ? ";
		if(!"".equals(meetingids)){
			sql += " AND m.id <> ?";
		}
		if(crmids.length() > 0){
			sql += " UNION ALL "
			+" SELECT m.name,mm.memberid, mm.membertype,m.begindate,m.begintime,m.enddate,m.endtime FROM Meeting m, Meeting_Member2 mm WHERE mm.meetingid = m.id and m.repeatType = 0 "
			+" AND m.meetingstatus in (1,2) and m.isdecision<2 and (m.cancel is null or m.cancel<>'1') "
			+" and (mm.memberid IN ("+DBUtil.getParamReplace(crmids)+") AND mm.membertype = 2) AND m.begindate + ' ' + m.begintime < ? "
			+" AND m.enddate + ' ' + m.endtime > ? ";
			if(!"".equals(meetingids)){
				sql += " AND m.id <> ?";
			}
		}
	}
	sql += " order by memberid ";
	List params = new ArrayList();
	if("".equals(meetingids)){
		if(crmids.length() > 0){
			RecordSet.executeQuery(sql,DBUtil.trasToList(params,hrmids),enddate+" "+endtime,begindate+" "+begintime,DBUtil.trasToList(params,crmids),enddate+" "+endtime,begindate+" "+begintime);
		}else{
			RecordSet.executeQuery(sql,DBUtil.trasToList(params,hrmids),enddate+" "+endtime,begindate+" "+begintime);
		}
	}else{
		if(crmids.length() > 0){
			RecordSet.executeQuery(sql,DBUtil.trasToList(params,hrmids),enddate+" "+endtime,begindate+" "+begintime,meetingids,DBUtil.trasToList(params,crmids),enddate+" "+endtime,begindate+" "+begintime,meetingids);
		}else{
			RecordSet.executeQuery(sql,DBUtil.trasToList(params,hrmids),enddate+" "+endtime,begindate+" "+begintime,meetingids);
		}
	}
	
if(RecordSet.next()){
		StringBuffer content=new StringBuffer();
		StringBuffer hrmnames = new StringBuffer();
		StringBuffer crmnames = new StringBuffer();
		String membertype = RecordSet.getString("membertype");
		String mid=RecordSet.getString("memberid");
		
		content.append(SystemEnv.getHtmlLabelName(82893, 7)+"：\n");
		if("1".equals(membertype)){
			hrmnames.append(ResourceComInfo.getLastname(mid));
		} else {
			crmnames.append(CustomerInfoComInfo.getCustomerInfoname(mid));
		}
		
		while(RecordSet.next()){
			boolean samePeople=true;
			if(!mid.equals(RecordSet.getString("memberid"))){
				mid=RecordSet.getString("memberid");
				samePeople=false;
			}
			membertype = RecordSet.getString("membertype");
			if("1".equals(membertype)){
				if(hrmnames.length()>0){
					if(!samePeople){
						hrmnames.append(",");
						hrmnames.append(ResourceComInfo.getLastname(RecordSet.getString("memberid")));
					}
				}else{
					hrmnames.append(ResourceComInfo.getLastname(RecordSet.getString("memberid")));
				}
			} else {
				if(crmnames.length()>0){
					if(!samePeople){
						crmnames.append(",");
						crmnames.append(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("memberid")));
					}
				}else{
					crmnames.append(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("memberid")));
				}
			}
		}
		if(hrmnames.length() > 0){
			content.append(SystemEnv.getHtmlLabelName(30042, 7)+":").append("\n").append(hrmnames.toString());
		}
		if(crmnames.length() > 0){
			content.append(SystemEnv.getHtmlLabelName(21313, 7)+":").append("\n").append(crmnames.toString());
		}
		if(memberconflict.equals("1")){
			content.append("\n"+SystemEnv.getHtmlLabelName(32873,7));
		}else if(memberconflict.equals("2")){

			content.append("\n"+SystemEnv.getHtmlLabelName(32874,7));
		}
		
		JSONObject jsn = new JSONObject();
		jsn.put("id", "1");
		jsn.put("msg", content.toString());
		out.print(jsn.toString());
	} else {
		JSONObject jsn = new JSONObject();
		jsn.put("id", "0");
		jsn.put("msg", "0");
		out.print(jsn.toString());
	}
%>
