/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._meeting._data;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.file.FileUpload;
import weaver.docs.docs.DocExtUtil;
import net.sf.json.JSONObject;
import java.util.*;
import weaver.hrm.*;
import weaver.conn.RecordSet;
import weaver.general.Util;
import java.sql.Timestamp;
import weaver.Constants;
import weaver.domain.workplan.WorkPlan;
import weaver.WorkPlan.WorkPlanLogMan;
import weaver.WorkPlan.WorkPlanService;
import weaver.meeting.Maint.MeetingInterval;
import weaver.systeminfo.SystemEnv;

public class _ajaxmeetingoperation__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;
  
  public void
  _jspService(javax.servlet.http.HttpServletRequest request,
              javax.servlet.http.HttpServletResponse response)
    throws java.io.IOException, javax.servlet.ServletException
  {
    javax.servlet.http.HttpSession session = request.getSession(true);
    com.caucho.server.webapp.WebApp _jsp_application = _caucho_getApplication();
    javax.servlet.ServletContext application = _jsp_application;
    com.caucho.jsp.PageContextImpl pageContext = _jsp_application.getJspApplicationContext().allocatePageContext(this, _jsp_application, request, response, null, session, 8192, true, false);
    javax.servlet.jsp.PageContext _jsp_parentContext = pageContext;
    javax.servlet.jsp.JspWriter out = pageContext.getOut();
    final javax.el.ELContext _jsp_env = pageContext.getELContext();
    javax.servlet.ServletConfig config = getServletConfig();
    javax.servlet.Servlet page = this;
    response.setContentType("text/html; charset=utf-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.conn.RecordSet RecordSet;
      RecordSet = (weaver.conn.RecordSet) pageContext.getAttribute("RecordSet");
      if (RecordSet == null) {
        RecordSet = new weaver.conn.RecordSet();
        pageContext.setAttribute("RecordSet", RecordSet);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet RecordSetDB;
      RecordSetDB = (weaver.conn.RecordSet) pageContext.getAttribute("RecordSetDB");
      if (RecordSetDB == null) {
        RecordSetDB = new weaver.conn.RecordSet();
        pageContext.setAttribute("RecordSetDB", RecordSetDB);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.resource.ResourceComInfo ResourceComInfo;
      ResourceComInfo = (weaver.hrm.resource.ResourceComInfo) pageContext.getAttribute("ResourceComInfo");
      if (ResourceComInfo == null) {
        ResourceComInfo = new weaver.hrm.resource.ResourceComInfo();
        pageContext.setAttribute("ResourceComInfo", ResourceComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.crm.Maint.CustomerInfoComInfo CustomerInfoComInfo;
      CustomerInfoComInfo = (weaver.crm.Maint.CustomerInfoComInfo) pageContext.getAttribute("CustomerInfoComInfo");
      if (CustomerInfoComInfo == null) {
        CustomerInfoComInfo = new weaver.crm.Maint.CustomerInfoComInfo();
        pageContext.setAttribute("CustomerInfoComInfo", CustomerInfoComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.meeting.Maint.MeetingSetInfo meetingSetInfo;
      meetingSetInfo = (weaver.meeting.Maint.MeetingSetInfo) pageContext.getAttribute("meetingSetInfo");
      if (meetingSetInfo == null) {
        meetingSetInfo = new weaver.meeting.Maint.MeetingSetInfo();
        pageContext.setAttribute("meetingSetInfo", meetingSetInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.meeting.MeetingUtil meetingUtil;
      meetingUtil = (weaver.meeting.MeetingUtil) pageContext.getAttribute("meetingUtil");
      if (meetingUtil == null) {
        meetingUtil = new weaver.meeting.MeetingUtil();
        pageContext.setAttribute("meetingUtil", meetingUtil);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.meeting.Maint.MeetingRoomComInfo MeetingRoomComInfo;
      MeetingRoomComInfo = (weaver.meeting.Maint.MeetingRoomComInfo) pageContext.getAttribute("MeetingRoomComInfo");
      if (MeetingRoomComInfo == null) {
        MeetingRoomComInfo = new weaver.meeting.Maint.MeetingRoomComInfo();
        pageContext.setAttribute("MeetingRoomComInfo", MeetingRoomComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
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


//\u53c2\u4f1a\u4eba\u5458\u51b2\u7a81\u6821\u9a8c
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
		content.append(SystemEnv.getHtmlLabelName(82893, user.getLanguage())+"\uff1a<br><div style=\'overflow-y: auto;max-height:60px;\'>");
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

//\u4f1a\u8bae\u5ba4\u51b2\u7a81\u6821\u9a8c
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

//\u6d41\u7a0b\u4e2d\u53d8\u66f4\u4f1a\u8bae\u7c7b\u578b\u65f6
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
				if(!meetingSetInfo.getMtngAttchCtgry().equals("")){//\u5982\u679c\u8bbe\u7f6e\u4e86\u76ee\u5f55\uff0c\u5219\u53d6\u503c
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
		    
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((mainId ));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((subId ));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((secId ));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((maxsize ));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      
		    
		} 
	}
	*/
	//\u751f\u6210\u53ec\u96c6\u4eba\u7684where\u5b50\u53e5
	String whereclause="";
	int ishead=0 ;
	int isset=0;//\u662f\u5426\u6709\u8bbe\u7f6e\u53ec\u96c6\u4eba\u6807\u8bc6\uff0c0\u6ca1\u6709\uff0c1\u6709
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
		
      out.write(_jsp_string8, 0, _jsp_string8.length);
      out.print((whereclause ));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      
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
		
      out.write(_jsp_string10, 0, _jsp_string10.length);
      out.print((hrmids02.substring(0,hrmids02.length() - 1) ));
      out.write(_jsp_string11, 0, _jsp_string11.length);
      out.print((hrmids02span ));
      out.write(_jsp_string12, 0, _jsp_string12.length);
      out.print((hrmCnt ));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      
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
		
      out.write(_jsp_string13, 0, _jsp_string13.length);
      out.print((crmids02.substring(0,crmids02.length() - 1) ));
      out.write(_jsp_string14, 0, _jsp_string14.length);
      out.print((crmids02span ));
      out.write(_jsp_string15, 0, _jsp_string15.length);
      out.print((crmCnt ));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      
	}
	/*
	int servicerows=0;
		if(!meetingtype.equals("")){
		RecordSet.executeProc("Meeting_Service_SelectAll",meetingtype);
		if(RecordSet.getCounts()>0){
		
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((SystemEnv.getHtmlLabelName(2107,user.getLanguage())));
      out.write(_jsp_string17, 0, _jsp_string17.length);
      
		while(RecordSet.next()){
		
      out.write(_jsp_string18, 0, _jsp_string18.length);
      out.print((RecordSet.getString("name")));
      out.write(_jsp_string19, 0, _jsp_string19.length);
      out.print((RecordSet.getString("hrmid")));
      out.write(_jsp_string20, 0, _jsp_string20.length);
      out.print((ResourceComInfo.getLastname(RecordSet.getString("hrmid")) ));
      out.write(_jsp_string21, 0, _jsp_string21.length);
      out.print((servicerows));
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((RecordSet.getString("name")));
      out.write(_jsp_string23, 0, _jsp_string23.length);
      out.print((servicerows));
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((RecordSet.getString("hrmid")));
      out.write(_jsp_string24, 0, _jsp_string24.length);
      
			ArrayList serviceitems = Util.TokenizerString(RecordSet.getString("desc_n"),",");
			for(int i=0;i<serviceitems.size();i++){
				//String id = RecordSet.getString("id");	
		
      out.write(_jsp_string25, 0, _jsp_string25.length);
      out.print((servicerows));
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((serviceitems.get(i)));
      out.write(_jsp_string26, 0, _jsp_string26.length);
      out.print((serviceitems.get(i)));
      out.write(_jsp_string27, 0, _jsp_string27.length);
      
			}
		
      out.write(_jsp_string28, 0, _jsp_string28.length);
      out.print((SystemEnv.getHtmlLabelName(375,user.getLanguage())));
      out.write(_jsp_string29, 0, _jsp_string29.length);
      out.print((servicerows));
      out.write(_jsp_string30, 0, _jsp_string30.length);
      
			servicerows+=1;
		}
		
      out.write(_jsp_string31, 0, _jsp_string31.length);
      out.print((servicerows));
      out.write(_jsp_string32, 0, _jsp_string32.length);
      }
		}
      out.write(_jsp_string33, 0, _jsp_string33.length);
      
		*/
}

//\u63d0\u524d\u7ed3\u675f\u91cd\u590d\u4f1a\u8bae
if("stopIntervalMeeting".equals(method)){
	String enddate=Util.null2String(fu.getParameter("enddate"));
	MeetingInterval mi = new MeetingInterval();
	mi.stopIntervalMeeting(meetingid, enddate);
}

//\u590d\u5236\u751f\u6210\u4f1a\u8bae
if("copyMeeting".equals(method)){
	MeetingInterval mi = new MeetingInterval();
	String newMtId = mi.copyMeetingfromMeeting(meetingid, user.getUID());
	out.print(newMtId);
}

      out.write(_jsp_string1, 0, _jsp_string1.length);
    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      _jsp_application.getJspApplicationContext().freePageContext(pageContext);
    }
  }

  private java.util.ArrayList _caucho_depends = new java.util.ArrayList();

  public java.util.ArrayList _caucho_getDependList()
  {
    return _caucho_depends;
  }

  public void _caucho_addDepend(com.caucho.vfs.PersistentDependency depend)
  {
    super._caucho_addDepend(depend);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  public boolean _caucho_isModified()
  {
    if (_caucho_isDead)
      return true;
    if (com.caucho.server.util.CauchoSystem.getVersionId() != 1886798272571451039L)
      return true;
    for (int i = _caucho_depends.size() - 1; i >= 0; i--) {
      com.caucho.vfs.Dependency depend;
      depend = (com.caucho.vfs.Dependency) _caucho_depends.get(i);
      if (depend.isModified())
        return true;
    }
    return false;
  }

  public long _caucho_lastModified()
  {
    return 0;
  }

  public java.util.HashMap<String,java.lang.reflect.Method> _caucho_getFunctionMap()
  {
    return _jsp_functionMap;
  }

  public void init(ServletConfig config)
    throws ServletException
  {
    com.caucho.server.webapp.WebApp webApp
      = (com.caucho.server.webapp.WebApp) config.getServletContext();
    super.init(config);
    com.caucho.jsp.TaglibManager manager = webApp.getJspApplicationContext().getTaglibManager();
    com.caucho.jsp.PageContextImpl pageContext = new com.caucho.jsp.PageContextImpl(webApp, this);
  }

  public void destroy()
  {
      _caucho_isDead = true;
      super.destroy();
  }

  public void init(com.caucho.vfs.Path appDir)
    throws javax.servlet.ServletException
  {
    com.caucho.vfs.Path resinHome = com.caucho.server.util.CauchoSystem.getResinHome();
    com.caucho.vfs.MergePath mergePath = new com.caucho.vfs.MergePath();
    mergePath.addMergePath(appDir);
    mergePath.addMergePath(resinHome);
    com.caucho.loader.DynamicClassLoader loader;
    loader = (com.caucho.loader.DynamicClassLoader) getClass().getClassLoader();
    String resourcePath = loader.getResourcePathSpecificFirst();
    mergePath.addClassPath(resourcePath);
    com.caucho.vfs.Depend depend;
    depend = new com.caucho.vfs.Depend(appDir.lookup("meeting/data/AjaxMeetingOperation.jsp"), 4527612498608656331L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string15;
  private final static char []_jsp_string4;
  private final static char []_jsp_string27;
  private final static char []_jsp_string10;
  private final static char []_jsp_string18;
  private final static char []_jsp_string23;
  private final static char []_jsp_string3;
  private final static char []_jsp_string33;
  private final static char []_jsp_string26;
  private final static char []_jsp_string24;
  private final static char []_jsp_string22;
  private final static char []_jsp_string11;
  private final static char []_jsp_string17;
  private final static char []_jsp_string5;
  private final static char []_jsp_string0;
  private final static char []_jsp_string9;
  private final static char []_jsp_string7;
  private final static char []_jsp_string16;
  private final static char []_jsp_string25;
  private final static char []_jsp_string31;
  private final static char []_jsp_string19;
  private final static char []_jsp_string12;
  private final static char []_jsp_string30;
  private final static char []_jsp_string14;
  private final static char []_jsp_string28;
  private final static char []_jsp_string21;
  private final static char []_jsp_string1;
  private final static char []_jsp_string8;
  private final static char []_jsp_string20;
  private final static char []_jsp_string13;
  private final static char []_jsp_string32;
  private final static char []_jsp_string29;
  private final static char []_jsp_string6;
  private final static char []_jsp_string2;
  static {
    _jsp_string15 = "'>\r\n		<input type=hidden class=\"crmCnts\" value='".toCharArray();
    _jsp_string4 = "'>\r\n		    <input type=hidden name=\"subIds\" value='".toCharArray();
    _jsp_string27 = "&nbsp;&nbsp;\r\n		".toCharArray();
    _jsp_string10 = "\r\n		<input type=hidden class=\"hrmids02s\" value='".toCharArray();
    _jsp_string18 = "\r\n				<TR>\r\n				  <td class=Field>".toCharArray();
    _jsp_string23 = "\">\r\n				  <input class=inputstyle type=hidden name=servicehrm_".toCharArray();
    _jsp_string3 = "\r\n		    <input type=hidden name=\"mainIds\" value='".toCharArray();
    _jsp_string33 = "\r\n		\r\n		".toCharArray();
    _jsp_string26 = "\" >&nbsp;&nbsp;".toCharArray();
    _jsp_string24 = "\">\r\n			  <TABLE class=viewForm >\r\n				<TBODY>\r\n				<TR>\r\n				  <TD class=Field>\r\n		".toCharArray();
    _jsp_string22 = " value=\"".toCharArray();
    _jsp_string11 = "'>\r\n		<input type=hidden class=\"hrmids02spans\" value='".toCharArray();
    _jsp_string17 = "</td>\r\n		<td class=\"fieldvalueClass\">\r\n			  <TABLE class=\"ViewForm\">\r\n				<COLGROUP>\r\n				<COL width=\"15%\">\r\n				<COL width=\"85%\">\r\n				<TBODY>\r\n				\r\n		".toCharArray();
    _jsp_string5 = "'>\r\n		    <input type=hidden name=\"secIds\" value='".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string9 = "'>\r\n		".toCharArray();
    _jsp_string7 = "'>\r\n		    ".toCharArray();
    _jsp_string16 = "\r\n		<table class=\"ViewForm\">\r\n	    <colgroup> <col width=\"20%\"> <col width=\"80%\">\r\n	    </colgroup>\r\n	    <TBODY>\r\n		<TR>\r\n		<TD class=\"fieldnameClass\">".toCharArray();
    _jsp_string25 = "\r\n				  <input class=inputstyle type=checkbox name=serviceitem_".toCharArray();
    _jsp_string31 = "\r\n				</TBODY>\r\n			  </TABLE>\r\n		  </td>\r\n		</TR>\r\n		 <tr style=\"height: 1px\"><td colspan=4 class=\"Line2\"></td></tr>\r\n		</TBODY>\r\n		</table>\r\n		<input class=inputstyle type=\"hidden\" name=\"servicerows\" value=\"".toCharArray();
    _jsp_string19 = "(<a href=\"javaScript:openhrm('".toCharArray();
    _jsp_string12 = "'>\r\n		<input type=hidden class=\"hrmCnts\" value='".toCharArray();
    _jsp_string30 = " maxlength=\"255\" onchange=\"checkLength()\"  style=\"width:90%\"></TD>\r\n				</TR>\r\n				</TBODY>\r\n			  </TABLE>		  \r\n				  \r\n				  </TD>\r\n				</TR>\r\n		".toCharArray();
    _jsp_string14 = "'>\r\n		<input type=hidden class=\"crmids02spans\" value='".toCharArray();
    _jsp_string28 = "\r\n				  </TD>\r\n				</TR>\r\n				<TR>\r\n				  <TD class=Field>".toCharArray();
    _jsp_string21 = ")</a>&nbsp;</td>\r\n				  <TD class=Field> \r\n				  <input class=inputstyle type=hidden name=servicename_".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string8 = "\r\n		<input type=hidden class=\"whereclauses\" value='".toCharArray();
    _jsp_string20 = " ');\" onclick='pointerXY(event);' style=\"color:blue;\">".toCharArray();
    _jsp_string13 = "\r\n		<input type=hidden class=\"crmids02s\" value='".toCharArray();
    _jsp_string32 = "\">\r\n		".toCharArray();
    _jsp_string29 = "\uff1a<input class=inputstyle name=serviceother_".toCharArray();
    _jsp_string6 = "'>\r\n		    <input type=hidden name=\"maxsizes\" value='".toCharArray();
    _jsp_string2 = "\r\n\r\n".toCharArray();
  }
}