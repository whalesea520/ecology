<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.docs.docs.DocExtUtil" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.WorkPlan.WorkPlanService" %>
<%@ page import="weaver.meeting.Maint.MeetingInterval" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetDB" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="meetingUtil" class="weaver.meeting.MeetingUtil" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
FileUpload fu = new FileUpload(request);
String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();
String SubmiterType = ""+user.getLogintype();
String ClientIP = fu.getRemoteAddr();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

char flag = 2;
String ProcPara = "";
String Sql="";

String method = Util.null2String(fu.getParameter("method"));
String meetingtype=Util.null2String(fu.getParameter("meetingtype"));
String meetingid=Util.null2String(fu.getParameter("meetingid"));

String approvewfid ="";


//参会人员冲突校验
if("chkMember".equals(method)){

	String hrmids=Util.null2String(fu.getParameter("hrmids"));
	String crmids=Util.null2String(fu.getParameter("crmids"));
	String begindate=Util.null2String(fu.getParameter("begindate"));
	String begintime=Util.null2String(fu.getParameter("begintime"));
	String enddate=Util.null2String(fu.getParameter("enddate"));
	String endtime=Util.null2String(fu.getParameter("endtime"));
	
	String meetingids=Util.null2String(fu.getParameter("meetingid"));

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
	String sql = "";
	if("oracle".equalsIgnoreCase(RecordSet.getDBType())){
		sql = "SELECT m.name,mm.memberid, mm.membertype,m.begindate,m.begintime,m.enddate,m.endtime FROM Meeting m, Meeting_Member2 mm WHERE mm.meetingid = m.id and m.repeatType = 0"
		+" AND m.meetingstatus in (1,2) and m.isdecision<2 and (m.cancel is null or m.cancel<>'1') "
		+" and (mm.memberid IN ("+hrmids+") AND mm.membertype = 1) AND m.begindate || ' ' || m.begintime < '"+enddate+" "+endtime+"' "
		+" AND m.enddate || ' ' || m.endtime > '"+begindate+" "+begintime+"' ";
		if(!"".equals(meetingids)){
			sql += " AND m.id <> "+meetingids;
		}
		if(crmids.length() > 0){
			sql += " UNION ALL "
			+" SELECT m.name,mm.memberid, mm.membertype,m.begindate,m.begintime,m.enddate,m.endtime FROM Meeting m, Meeting_Member2 mm WHERE mm.meetingid = m.id and m.repeatType = 0 "
			+" AND m.meetingstatus in (1,2) and m.isdecision<2 and (m.cancel is null or m.cancel<>'1') "
			+" and (mm.memberid IN ("+crmids+") AND mm.membertype = 2) AND m.begindate || ' ' || m.begintime < '"+enddate+" "+endtime+"' "
			+" AND m.enddate || ' ' || m.endtime > '"+begindate+" "+begintime+"' ";
			if(!"".equals(meetingids)){
				sql += " AND m.id <> "+meetingids;
			}
		}
		
	} else {
		sql = "SELECT m.name,mm.memberid, mm.membertype,m.begindate,m.begintime,m.enddate,m.endtime FROM Meeting m, Meeting_Member2 mm WHERE mm.meetingid = m.id and m.repeatType = 0 "
		+" AND m.meetingstatus in (1,2) and m.isdecision<2 and (m.cancel is null or m.cancel<>'1') "
		+" and (mm.memberid IN ("+hrmids+") AND mm.membertype = 1) AND m.begindate + ' ' + m.begintime < '"+enddate+" "+endtime+"' "
		+" AND m.enddate + ' ' + m.endtime > '"+begindate+" "+begintime+"' ";
		if(!"".equals(meetingids)){
			sql += " AND m.id <> "+meetingids;
		}
		if(crmids.length() > 0){
			sql += " UNION ALL "
			+" SELECT m.name,mm.memberid, mm.membertype,m.begindate,m.begintime,m.enddate,m.endtime FROM Meeting m, Meeting_Member2 mm WHERE mm.meetingid = m.id and m.repeatType = 0 "
			+" AND m.meetingstatus in (1,2) and m.isdecision<2 and (m.cancel is null or m.cancel<>'1') "
			+" and (mm.memberid IN ("+crmids+") AND mm.membertype = 2) AND m.begindate + ' ' + m.begintime < '"+enddate+" "+endtime+"' "
			+" AND m.enddate + ' ' + m.endtime > '"+begindate+" "+begintime+"' ";
			if(!"".equals(meetingids)){
				sql += " AND m.id <> "+meetingids;
			}
		}
	}
	//RecordSet.writeLog("asql:"+sql);
	RecordSet.executeSql(sql+" order by memberid");
	if(RecordSet.next()){
		StringBuffer content=new StringBuffer();
		StringBuffer hrmnames = new StringBuffer();
		StringBuffer crmnames = new StringBuffer();
		String membertype = RecordSet.getString("membertype");
		String mid=RecordSet.getString("memberid");
		String name=RecordSet.getString("name");
		if(name.length()>20){
			name=name.substring(0,20)+"...";
		}
		if("1".equals(membertype)){
			hrmnames.append("[").append(ResourceComInfo.getLastname(RecordSet.getString("memberid"))).append("]"+SystemEnv.getHtmlLabelName(82894, user.getLanguage())+"[").append(RecordSet.getString("begindate")).append(" ").append(RecordSet.getString("begintime")).append("-").append(RecordSet.getString("enddate")).append(" ").append(RecordSet.getString("endtime")).append("]"+SystemEnv.getHtmlLabelName(2195, user.getLanguage())+"[").append(name).append("]<br>");
		} else {
			crmnames.append("[").append(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("memberid"))).append("]"+SystemEnv.getHtmlLabelName(82894, user.getLanguage())+"[").append(RecordSet.getString("begindate")).append(" ").append(RecordSet.getString("begintime")).append("-").append(RecordSet.getString("enddate")).append(" ").append(RecordSet.getString("endtime")).append("]"+SystemEnv.getHtmlLabelName(2195, user.getLanguage())+"[").append(name).append("]<br>");
		}
		content.append(SystemEnv.getHtmlLabelName(82893, user.getLanguage())+"：<br><div style=\'overflow-y: auto;max-height:60px;\'>");
		while(RecordSet.next()){
			name=RecordSet.getString("name");
			if(name.length()>20){
				name=name.substring(0,20)+"...";
			}
			boolean samePeople=true;
			if(!mid.equals(RecordSet.getString("memberid"))){
				mid=RecordSet.getString("memberid");
				samePeople=false;
			}
			membertype = RecordSet.getString("membertype");
			if("1".equals(membertype)){
				if(!samePeople&&hrmnames.length()>0){
					hrmnames.append("<br>");
				}
				hrmnames.append("[").append(ResourceComInfo.getLastname(RecordSet.getString("memberid"))).append("]"+SystemEnv.getHtmlLabelName(82894, user.getLanguage())+"[").append(RecordSet.getString("begindate")).append(" ").append(RecordSet.getString("begintime")).append("-").append(RecordSet.getString("enddate")).append(" ").append(RecordSet.getString("endtime")).append("]"+SystemEnv.getHtmlLabelName(2195, user.getLanguage())+"[").append(name).append("]<br>");
			} else {
				if(!samePeople&crmnames.length()>0){
					crmnames.append("<br>");
				}
				crmnames.append("[").append(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("memberid"))).append("]"+SystemEnv.getHtmlLabelName(82894, user.getLanguage())+"[").append(RecordSet.getString("begindate")).append(" ").append(RecordSet.getString("begintime")).append("-").append(RecordSet.getString("enddate")).append(" ").append(RecordSet.getString("endtime")).append("]"+SystemEnv.getHtmlLabelName(2195, user.getLanguage())+"[").append(name).append("]<br>");
			}
		}
		if(hrmnames.length() > 0){
			content.append(SystemEnv.getHtmlLabelName(30042, user.getLanguage())+":").append("<br>").append(hrmnames.toString()).append("");
		}
		if(crmnames.length() > 0){
			content.append(SystemEnv.getHtmlLabelName(21313, user.getLanguage())+":").append("<br>").append(crmnames.toString()).append("");
		}
		content.append("</div>");
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
}

//会议室冲突校验
if("chkRoom".equals(method)){
	String meetingaddress = Util.null2String(fu.getParameter("address"));
	String begindate=Util.null2String(fu.getParameter("begindate"));
	String begintime=Util.null2String(fu.getParameter("begintime"));
	String enddate=Util.null2String(fu.getParameter("enddate"));
	String endtime=Util.null2String(fu.getParameter("endtime"));
	String requestid = Util.null2String(fu.getParameter("requestid"));
	String meetingids=Util.null2String(fu.getParameter("meetingid"));
	List<String> arr=new ArrayList();
	String returnstr = "0";
	if(meetingSetInfo.getRoomConflictChk() == 1 ){
		if(!"".equals(requestid)) {
		   RecordSet.executeSql("select approveid from Bill_Meeting where requestid="+requestid);
		   if(RecordSet.next()) {
			  meetingids = Util.null2String(RecordSet.getString("approveid"));
		   }
		}
			
		RecordSet.executeSql("select address,begindate,enddate,begintime,endtime,id from meeting where meetingstatus in (1,2) and repeatType = 0 and isdecision<2 and (cancel is null or cancel<>'1') and (begindate <= '"+enddate+"' and enddate >='"+begindate+"')");
		while(RecordSet.next()) {
			String begindatetmp = Util.null2String(RecordSet.getString("begindate"));
			String begintimetmp = Util.null2String(RecordSet.getString("begintime"));
			String enddatetmp = Util.null2String(RecordSet.getString("enddate"));
			String endtimetmp = Util.null2String(RecordSet.getString("endtime"));
			String addresstmp = Util.null2String(RecordSet.getString("address"));
			String mid = Util.null2String(RecordSet.getString("id"));

			String str1 = begindate+" "+begintime;
			String str2 = enddatetmp+" "+endtimetmp;
			String str3 = enddate+" "+endtime;
			String str4 = begindatetmp+" "+begintimetmp;

			String[] address=addresstmp.split(",");
			for(int i=0;i<address.length;i++){
				if(!"".equals(meetingaddress) && (","+meetingaddress+",").indexOf(","+address[i]+",")>-1 && !mid.equals(meetingids)) {
					if((str1.compareTo(str2) < 0 && str3.compareTo(str4) > 0)) {
						if(!arr.contains(address[i])){
							arr.add(address[i]);
						}
					}
				}
			}
		}
	}
	for(int i=0;i<arr.size();i++){
		String name=MeetingRoomComInfo.getMeetingRoomInfoname(arr.get(i));
		if("0".equals(returnstr)){
			returnstr="["+name+"]";
		}else{
			returnstr+="<br>["+name+"]";
		}
	}
    out.write(returnstr);
}

//流程中变更会议类型时
if("chgMeetingType".equals(method)){
	meetingtype=Util.null2String(fu.getParameter("meetingType"));
	/*
	String mainId = "";
	String subId = "";
	String secId = "";
	String maxsize = "";
	if(!meetingtype.equals(""))
	{
		RecordSet.executeProc("Meeting_Type_SelectByID",meetingtype);
		if(RecordSet.next())
		{
			String category = Util.null2String(RecordSet.getString("catalogpath"));
		    if(!category.equals(""))
		    {
		    	String[] categoryArr = Util.TokenizerString2(category,",");
		    	mainId = categoryArr[0];
		    	subId = categoryArr[1];
		    	secId = categoryArr[2];
		    }else {
				if(!meetingSetInfo.getMtngAttchCtgry().equals("")){//如果设置了目录，则取值
					String[] categoryArr = Util.TokenizerString2(meetingSetInfo.getMtngAttchCtgry(),",");
					mainId = categoryArr[0];
					subId = categoryArr[1];
					secId = categoryArr[2];
				}
			}
	    }
		if(!secId.equals(""))
		{
			RecordSet.executeSql("select maxUploadFileSize from DocSecCategory where id="+secId);
			RecordSet.next();
		    maxsize = Util.null2String(RecordSet.getString(1));
		    %>
		    <input type=hidden name="mainIds" value='<%=mainId %>'>
		    <input type=hidden name="subIds" value='<%=subId %>'>
		    <input type=hidden name="secIds" value='<%=secId %>'>
		    <input type=hidden name="maxsizes" value='<%=maxsize %>'>
		    <%
		    
		} 
	}
	*/
	//生成召集人的where子句
	String whereclause="";
	int ishead=0 ;
	int isset=0;//是否有设置召集人标识，0没有，1有
	if(!meetingtype.equals("")) {
		RecordSet.executeProc("MeetingCaller_SByMeeting",meetingtype) ;
		
		while(RecordSet.next()){
		    String callertype=RecordSet.getString("callertype") ;
		    int seclevel=Util.getIntValue(RecordSet.getString("seclevel"), 0) ;
		    String rolelevel=RecordSet.getString("rolelevel") ;
		    String thisuserid=RecordSet.getString("userid") ;
		    String departmentid=RecordSet.getString("departmentid") ;
		    String roleid=RecordSet.getString("roleid") ;
		    String foralluser=RecordSet.getString("foralluser") ;
		    String subcompanyid=RecordSet.getString("subcompanyid") ;
		    int seclevelMax=Util.getIntValue(RecordSet.getString("seclevelMax"), 0) ;
		    int jobtitleid=Util.getIntValue(RecordSet.getString("jobtitleid"),0) ;
			int joblevel=Util.getIntValue(RecordSet.getString("jobtitleid"),0) ;
			String joblevelvalue=RecordSet.getString("joblevelvalue");
		    isset=1;
		
		    if(callertype.equals("1")){
		        if(ishead==0)
		            whereclause+=" t1.id="+thisuserid ;
		        if(ishead==1)
		            whereclause+=" or t1.id="+thisuserid ;
		    }
		    if(callertype.equals("2")){
		        if(ishead==0)
		            whereclause+=" t1.id in (select id from hrmresource where departmentid="+departmentid+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
		        if(ishead==1)
		            whereclause+=" or t1.id in (select id from hrmresource where departmentid="+departmentid+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
		    }
		    if(callertype.equals("3")){
				if(ishead==0){
					whereclause+=" t1.id in (select resourceid from hrmrolemembers join hrmresource on  hrmrolemembers.resourceid=hrmresource.id where roleid="+roleid+" and rolelevel >="+rolelevel+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+")" ;
				}
				if(ishead==1){
					whereclause+=" or t1.id in (select resourceid from hrmrolemembers join hrmresource on  hrmrolemembers.resourceid=hrmresource.id where roleid="+roleid+" and rolelevel >="+rolelevel+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+")" ;
				}
			}
		    if(callertype.equals("4")){
		        if(ishead==0)
		            whereclause+=" t1.id in (select id from hrmresource where seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
		        if(ishead==1)
		            whereclause+=" or t1.id in (select id from hrmresource where seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
		    }
		    if(callertype.equals("5")){
		        if(ishead==0)
		            whereclause+=" t1.id in (select id from hrmresource where subcompanyid1="+subcompanyid+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
		        if(ishead==1)
		            whereclause+=" or t1.id in (select id from hrmresource where subcompanyid1="+subcompanyid+" and seclevel >="+seclevel+" and seclevel <= "+seclevelMax+" )" ;
		    }
		    if(callertype.equals("8")){
				if(ishead==0){
					whereclause+=" t1.id in (select id from hrmresource where jobtitle="+jobtitleid;
					if(joblevel==1){
						whereclause+=" and subcompanyid1 in ("+joblevelvalue+")";
					}else if(joblevel==1){
						whereclause+=" and departmentid in ("+joblevelvalue+")";
					}	
					whereclause+=")";
				}
				if(ishead==1){
					whereclause+=" or t1.id in (select id from hrmresource where jobtitle="+jobtitleid;
					if(joblevel==1){
						whereclause+=" and subcompanyid1 in ("+joblevelvalue+")";
					}else if(joblevel==1){
						whereclause+=" and departmentid in ("+joblevelvalue+")";
					}	
					whereclause+=")";		
				}
			}
		    if(ishead==0)   ishead=1;
		}
	}
	if(!whereclause.equals("")) {
		whereclause="where ( " + whereclause;
		whereclause+=" )" ;
		%>
		<input type=hidden class="whereclauses" value='<%=whereclause %>'>
		<%
	}
	
	String hrmids02span = "";
	String hrmids02 = "";
	int hrmCnt = 0;
	if(!meetingtype.equals("")) {
		String[] membersArry  = meetingUtil.getMeetingHrmMembers(meetingtype);
		if(membersArry != null && membersArry.length > 0){
			for(String memberid:membersArry){
				String status=ResourceComInfo.getStatus(memberid);
				if(!status.equals("0")&&!status.equals("1")&&!status.equals("2")&&!status.equals("3"))
					continue;
				hrmids02 += memberid + ",";
				hrmids02span += ResourceComInfo.getResourcename(memberid)+",";
				hrmCnt++;
			}
		}
	}
	if(!"".equals(hrmids02)){
		%>
		<input type=hidden class="hrmids02s" value='<%=hrmids02.substring(0,hrmids02.length() - 1) %>'>
		<input type=hidden class="hrmids02spans" value='<%=hrmids02span %>'>
		<input type=hidden class="hrmCnts" value='<%=hrmCnt %>'>
		<%
	}
	
	String crmids02span = "";
	String crmids02 = "";
	int crmCnt = 0;
	if(!meetingtype.equals("")){
		RecordSet.executeProc("Meeting_Member_SelectByType",meetingtype+flag+"2");
		while(RecordSet.next()){
			crmCnt++;
			crmids02 += RecordSet.getString("memberid") + ",";
			crmids02span += CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("memberid"))+",";
		}
	}
	if(!"".equals(crmids02)){
		%>
		<input type=hidden class="crmids02s" value='<%=crmids02.substring(0,crmids02.length() - 1) %>'>
		<input type=hidden class="crmids02spans" value='<%=crmids02span %>'>
		<input type=hidden class="crmCnts" value='<%=crmCnt %>'>
		<%
	}
	/*
	int servicerows=0;
		if(!meetingtype.equals("")){
		RecordSet.executeProc("Meeting_Service_SelectAll",meetingtype);
		if(RecordSet.getCounts()>0){
		%>
		<table class="ViewForm">
	    <colgroup> <col width="20%"> <col width="80%">
	    </colgroup>
	    <TBODY>
		<TR>
		<TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(2107,user.getLanguage())%></td>
		<td class="fieldvalueClass">
			  <TABLE class="ViewForm">
				<COLGROUP>
				<COL width="15%">
				<COL width="85%">
				<TBODY>
				
		<%
		while(RecordSet.next()){
		%>
				<TR>
				  <td class=Field><%=RecordSet.getString("name")%>(<a href="javaScript:openhrm('<%=RecordSet.getString("hrmid")%> ');" onclick='pointerXY(event);' style="color:blue;"><%=ResourceComInfo.getLastname(RecordSet.getString("hrmid")) %>)</a>&nbsp;</td>
				  <TD class=Field> 
				  <input class=inputstyle type=hidden name=servicename_<%=servicerows%> value="<%=RecordSet.getString("name")%>">
				  <input class=inputstyle type=hidden name=servicehrm_<%=servicerows%> value="<%=RecordSet.getString("hrmid")%>">
			  <TABLE class=viewForm >
				<TBODY>
				<TR>
				  <TD class=Field>
		<%
			ArrayList serviceitems = Util.TokenizerString(RecordSet.getString("desc_n"),",");
			for(int i=0;i<serviceitems.size();i++){
				//String id = RecordSet.getString("id");	
		%>
				  <input class=inputstyle type=checkbox name=serviceitem_<%=servicerows%> value="<%=serviceitems.get(i)%>" >&nbsp;&nbsp;<%=serviceitems.get(i)%>&nbsp;&nbsp;
		<%
			}
		%>
				  </TD>
				</TR>
				<TR>
				  <TD class=Field><%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%>：<input class=inputstyle name=serviceother_<%=servicerows%> maxlength="255" onchange="checkLength()"  style="width:90%"></TD>
				</TR>
				</TBODY>
			  </TABLE>		  
				  
				  </TD>
				</TR>
		<%
			servicerows+=1;
		}
		%>
				</TBODY>
			  </TABLE>
		  </td>
		</TR>
		 <tr style="height: 1px"><td colspan=4 class="Line2"></td></tr>
		</TBODY>
		</table>
		<input class=inputstyle type="hidden" name="servicerows" value="<%=servicerows%>">
		<%}
		}%>
		
		<%
		*/
}

//提前结束重复会议
if("stopIntervalMeeting".equals(method)){
	String enddate=Util.null2String(fu.getParameter("enddate"));
	MeetingInterval mi = new MeetingInterval();
	mi.stopIntervalMeeting(meetingid, enddate);
}

//复制生成会议
if("copyMeeting".equals(method)){
	MeetingInterval mi = new MeetingInterval();
	String newMtId = mi.copyMeetingfromMeeting(meetingid, user.getUID());
	out.print(newMtId);
}
%>
