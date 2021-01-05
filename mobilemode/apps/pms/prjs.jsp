<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.prj.util.PrjCardUtil" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>

<%@ page import="org.apache.commons.logging.Log" %>
<%@ page import="org.apache.commons.logging.LogFactory" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>

<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLDecoder" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%
//response.setHeader("cache-control", "no-cache");
//response.setHeader("pragma", "no-cache");
//response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

int _userid = Util.getIntValue(request.getParameter("userid"));

//User user = HrmUserVarify.getUser (request , response) ;
//if(user == null){
	UserManager userManager = new UserManager();
	User user = userManager.getUserByUserIdAndLoginType(_userid, "1");
//}
%>





<%	
	String currentDateString = TimeUtil.getCurrentDateString();
	String[] currentDateStringArray = currentDateString.split("-");
	String yyyyMM = currentDateStringArray[0]+"-"+currentDateStringArray[1]; 

	String userid = user.getUID()+"";
	String creater = Util.fromScreen3(request.getParameter("creater"), user.getLanguage());
	if(false){
		userid = "2";//user.getUID()+"";
		creater = "2";//Util.fromScreen3(request.getParameter("creater"), user.getLanguage());
	}
	int maintype = Util.getIntValue((String)request.getSession().getAttribute("CRM_MAINTYPE"),1);
	String subject = Util.fromScreen3(request.getParameter("subject"), user.getLanguage());
	String creatertype = Util.fromScreen3(request.getParameter("creatertype"), user.getLanguage());
	String createDateFrom = Util.fromScreen3(request.getParameter("createDateFrom"), user.getLanguage());
	String createDateTo = Util.fromScreen3(request.getParameter("createDateTo"), user.getLanguage());
	String type = Util.fromScreen3(request.getParameter("type"), user.getLanguage());
	String statusid = Util.fromScreen3(Util.null2String(request.getParameter("statusid")), user.getLanguage());
	String statusid2 = Util.fromScreen3(request.getParameter("statusid2"), user.getLanguage());
	String attention=Util.null2String(request.getParameter("attention"));
	String subcompanyId = Util.fromScreen3(request.getParameter("subcompanyId"), user.getLanguage());
	String departmentId = Util.fromScreen3(request.getParameter("deptId"), user.getLanguage());
	
	String desc = Util.fromScreen3(request.getParameter("desc"), user.getLanguage());
	String size = Util.fromScreen3(request.getParameter("size"), user.getLanguage());
	String sector = Util.fromScreen3(request.getParameter("sector"), user.getLanguage());
	String source = Util.fromScreen3(request.getParameter("source"), user.getLanguage());
	
	String province = Util.fromScreen3(request.getParameter("province"), user.getLanguage());
	String city = Util.fromScreen3(request.getParameter("city"), user.getLanguage());
	
	String nocontact = Util.fromScreen3(request.getParameter("nocontact"), user.getLanguage());
	String contacttype = Util.fromScreen3(request.getParameter("contacttype"), user.getLanguage());
	String keyname = URLDecoder.decode(Util.null2String(request.getParameter("keyname")),"utf-8");
	
	String remind = Util.fromScreen3(request.getParameter("remind"), user.getLanguage());
	String isnew = Util.fromScreen3(request.getParameter("isnew"), user.getLanguage()); 

	String manyd = URLDecoder.decode(Util.null2String(request.getParameter("manyd")),"utf-8");/*满意度*/
	String kehulxr = URLDecoder.decode(Util.null2String(request.getParameter("kehulxr")),"utf-8");/*客户联系人*/
	String jieduan = URLDecoder.decode(Util.null2String(request.getParameter("jieduan")),"utf-8");/*阶段*/
	String ribao = URLDecoder.decode(Util.null2String(request.getParameter("ribao")),"utf-8");/*日报*/

	String customerid1 = URLDecoder.decode(Util.null2String(request.getParameter("customerid1")),"utf-8");/*具体某一个项目的id*/

	String orderBy1 = Util.fromScreen3(request.getParameter("orderBy1"), user.getLanguage());
	String orderBy1_text = Util.fromScreen3(request.getParameter("orderBy1_text"), user.getLanguage());
	
	if((statusid!=null && statusid.trim().length()>0) || 
			(keyname!=null && keyname.trim().length()>0)){
		request.getSession().removeAttribute("isFromProjectReport_ids");
		request.getSession().removeAttribute("isFromProjectReport_p1");
		request.getSession().removeAttribute("isFromProjectReport_p2");
		request.getSession().removeAttribute("isFromProjectReport_p3");
	}

	String isFromProjectReport_ids = Util.null2String((String)request.getSession().getAttribute("isFromProjectReport_ids"));
	String isFromProjectReport_p1 = Util.null2String((String)request.getSession().getAttribute("isFromProjectReport_p1"));
	String isFromProjectReport_p2 = Util.null2String((String)request.getSession().getAttribute("isFromProjectReport_p2"));
	String isFromProjectReport_p3 = Util.null2String((String)request.getSession().getAttribute("isFromProjectReport_p3"));

	if(ribao.length() > 0){/*如果是title上的日报传过来的过滤条件则，自动过滤掉，左侧菜单的日报过滤条件*/
		statusid = "30007";
		nocontact = ribao;
	}
	
	String currentdate = TimeUtil.getCurrentDateString();

	if("".equals(creater)){
		creater = userid;
	}
	if(!creater.equals(userid)){
		userid = creater;
	}

	//out.println("statusid="+statusid+"<br />");
	StringBuffer sqlsb = new StringBuffer();
	//List prjIdList = PrjCardUtil.getPrjIdList(userid, statusid, manyd, nocontact, user, kehulxr, jieduan, sqlsb, customerid1, keyname);
	String sqlPrjId = PrjCardUtil.getPrjIdList(userid, statusid, manyd, nocontact, user, kehulxr, jieduan, sqlsb, customerid1, keyname, "cbi", orderBy1_text, 
			isFromProjectReport_ids, isFromProjectReport_p1, isFromProjectReport_p2, isFromProjectReport_p3);
	//out.println(sqlPrjId);
    
    String backfields = " cbi.id, cbi.projName, cbi.planApprovalDate, cbi.projManager,pc.warningName ,cbi.lastPrjState ,datediff(DAY,cbi.lastUpdateDailyDate,CONVERT(varchar(100), GETDATE(), 23)) cnt ";
    String fromSql = " from proj_CardBaseInfo cbi left join proj_warning pc on pc.cbi_id=cbi.id";
    String sqlWhere = " where  1=1 "+sqlPrjId;
	

	int _pagesize = Util.getIntValue(request.getParameter("pageSize"),20);
	int _total = 0;//总数1844
	String sql_cnt = "select count(distinct cbi.id) "+fromSql+sqlWhere;
	//out.println(sql_cnt);
	rs.executeSql(sql_cnt);
	if(rs.next()){
		_total = rs.getInt(1);
	}
	request.getSession().setAttribute("CRM_LIST_SQL",backfields+" "+fromSql+" "+sqlWhere);
	request.getSession().setAttribute("CRM_LIST_SQL_orderBy1",orderBy1);
%>


				<%if(_total==0){ %>
				{"totalSize":0, "datas":[]}
				<%}else{ %>
				<jsp:include page="Operation.jsp">
					<jsp:param value="get_list_data" name="operation"/>
					<jsp:param value='<%=Util.getIntValue(request.getParameter("pageNo"),1)%>' name="currentpage"/>
					<jsp:param value="<%=_pagesize %>" name="pagesize"/>
					<jsp:param value="<%=_total %>" name="total"/>
					<jsp:param value="<%=_userid %>" name="userid"/>
				</jsp:include>
				<%} %>
	
