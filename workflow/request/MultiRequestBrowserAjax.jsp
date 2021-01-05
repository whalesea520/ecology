
<%@page import="weaver.fna.general.FnaCommon"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.workflow.workflow.WorkflowVersion"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="MailAndMessage" class="weaver.workflow.request.MailAndMessage"></jsp:useBean>
<jsp:useBean id="WorkflowComInfo"
	class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="crmComInfo"
	class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%!
    public JSONArray sortArray(JSONArray array,String resourceids){
		JSONArray array2 = new JSONArray();
	    String[] resources = resourceids.split(",");
	    for(String resource:resources){
	    	for(int i = 0;i< array.size();i++){
	    		if(array.getJSONObject(i).get("requestid").equals(resource)){
	    			array2.add(array.getJSONObject(i));
	    		}
	    	}
	    }
	    //System.err.print(array2.toString());
	    return array2;
	}
%>
<%
    request.setCharacterEncoding("utf8");
		String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
		String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
		if("".equals(f_weaver_belongto_userid)){
		   f_weaver_belongto_userid = Util.null2String((String)session.getAttribute("f_weaver_belongto_userid"));
		}
		if("".equals(f_weaver_belongto_usertype)){
		   f_weaver_belongto_usertype = Util.null2String((String)session.getAttribute("f_weaver_belongto_usertype"));
		}
		User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
		String userID = String.valueOf(user.getUID());
		int userid2=user.getUID();
		if(f_weaver_belongto_userid != null && !f_weaver_belongto_userid.equals(userID) && !"".equals(f_weaver_belongto_userid)){
		userID = f_weaver_belongto_userid;
		userid2 = Util.getIntValue(f_weaver_belongto_userid,0);
		}
		String belongtoshow = "";				
		RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
					if(RecordSet.next()){
						belongtoshow = RecordSet.getString("belongtoshow");
					}
String userIDAll = String.valueOf(user.getUID());	
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid2 + "");
if(!"".equals(Belongtoids)){
userIDAll = userID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}
	if (user == null) {
		response.sendRedirect("/login/Login.jsp");
		return;
	}
	String resourceids = Util.null2String(request
			.getParameter("systemIds"));
	if(resourceids.startsWith(",")){
		resourceids=resourceids.substring(1);
	}
	String src = Util.null2String(request.getParameter("src"));

	/*begin：处理费用流程请求浏览按钮过滤逻辑代码*/
	String _fnaSqlwhere = "";
	int __requestid = Util.getIntValue(request.getParameter("__requestid"));
	int _fna_wfid = Util.getIntValue(request.getParameter("fna_wfid"));
	int _fna_fieldid = Util.getIntValue(request.getParameter("fna_fieldid"));
	boolean _isEnableFnaWf = false;//是否是启用的Ecology8费控流程
	HashMap<String, String> _isEnableFnaWfHm = FnaCommon.getIsEnableFnaWfHm(_fna_wfid);
	_isEnableFnaWf = "true".equals(_isEnableFnaWfHm.get("isEnableFnaWfE8"));
	int _formId = Util.getIntValue(_isEnableFnaWfHm.get("formId"), 0);
	int _isbill = Util.getIntValue(_isEnableFnaWfHm.get("isbill"), -1);
	if(!_isEnableFnaWf){
		HashMap<String, String> _isEnableFnaRepaymentWfHm = FnaCommon.getIsEnableFnaRepaymentWfHm(_fna_wfid);
		_isEnableFnaWf = "true".equals(_isEnableFnaRepaymentWfHm.get("isEnableFnaRepaymentWf"));
		_formId = Util.getIntValue(_isEnableFnaRepaymentWfHm.get("formId"), 0);
		_isbill = Util.getIntValue(_isEnableFnaRepaymentWfHm.get("isbill"), -1);
	}
	boolean isFnaWfFysqlcReq = false;//是否是报销流程的费用申请流程

	if(_isEnableFnaWf){
		isFnaWfFysqlcReq = FnaCommon.checkFnaWfFieldFnaType(_fna_wfid, _fna_fieldid, 2, 0, "fnaFeeWf");
	}
	if(isFnaWfFysqlcReq){
		String sqlIsNull = "ISNULL";
		String sqlSubString = "SUBSTRING";
		if("oracle".equals(rs.getDBType())){
			sqlIsNull = "NVL";
			sqlSubString = "SUBSTR";
		}
		_fnaSqlwhere += " and exists ( "+
				" select 1 " +
				" from FnaExpenseInfo fei " +
				" where fei.budgetperiodslist is not null " +
				" and fei.sourceRequestid <> "+__requestid+" " +
				" and fei.status = 0 " +
				" and fei.requestid = a.requestid " +
				" GROUP BY fei.organizationid, fei.organizationtype, fei.subject, fei.budgetperiods, fei.budgetperiodslist  " +
				" HAVING SUM("+sqlIsNull+"(fei.amount, 0.00)) > 0.00 " +
				" ) and a.currentnodetype = 3 ";
	}
	/*end：处理费用流程请求浏览按钮过滤逻辑代码*/

	JSONArray jsonArr = new JSONArray();
	JSONObject json = new JSONObject();
	JSONObject tmp = new JSONObject();
	int formid=-1;
	int isbill =-1;
	if (resourceids.trim().startsWith(",")) {
		resourceids = resourceids.substring(1);
	}
	String excludeId = Util.null2String(request
			.getParameter("excludeId"));
	if(excludeId.startsWith(",")){
		excludeId=excludeId.substring(1);
	}
	/*
	Enumeration<String> e=request.getParameterNames();
	while(e.hasMoreElements()){
		String param=e.nextElement();
	}*/
	if ("dest".equalsIgnoreCase(src)) {
		if (!"".equals(resourceids)) {
			String sql = "select requestid,creatertype,requestname, requestnamenew,creater,createdate,createtime from workflow_requestbase where requestid in ("
					+ resourceids + ")";
			RecordSet.executeSql(sql);
			while (RecordSet.next()) {
				String request_id = Util.null2String(RecordSet
						.getString("requestid"));
				String creater_name = Util.null2String(RecordSet
						.getString("creater"));
				String create_date = Util.null2String(RecordSet
						.getString("createdate"));
				String create_time = Util.null2String(RecordSet
						.getString("createtime"));
				String request_name = Util.null2String(RecordSet
                        .getString("requestname"));
				
				
				String request_name_new = Util.null2String(RecordSet.getString("requestnamenew"));
				
				String workflowid = "";
				rs.execute("select workflowid from workflow_requestbase where requestid = "+request_id);
				if(rs.next()){
					workflowid = Util.null2String(rs.getString("workflowid"));
				}
			    ////根据后台设置在MAIL标题后加上流程中重要的字段


		        rs.execute("select formid,isbill from workflow_base where id="+workflowid);
		        if (rs.next())
		        {
		        	formid=rs.getInt(1);
		        	isbill=rs.getInt(2);
		        	
		        }
		        
                String titles = "";
		        if (!"".equals(request_name_new) && !request_name.equals(request_name_new)) {
		            if (request_name_new.indexOf(request_name_new) != -1) {
		                titles = request_name_new.substring(request_name.length() - 1, request_name_new.length());
		            }
		        }
		        
//				String titles=MailAndMessage.getTitle(Util.getIntValue(request_id,-1),Util.getIntValue(workflowid,-1),formid,user.getLanguage(),isbill);
				if (!titles.equals(""))
					request_name=request_name+"<B>("+titles+")</B>";
				String createtype = Util.null2String(RecordSet
						.getString("createtype"));
				if ("1".equals(createtype)){
					creater_name=crmComInfo.getCustomerInfoname(creater_name);
				}else{
					creater_name=ResourceComInfo.getResourcename(creater_name);
				}
				tmp.put("requestid", request_id);
				tmp.put("requestname",request_name);
				tmp.put("creater", creater_name);
				tmp.put("createtime", create_date + " " + create_time);
				jsonArr.add(tmp);
			}
			jsonArr = sortArray(jsonArr,resourceids);
			json.put("currentPage", 1);
			json.put("totalPage", 1);
			json.put("mapList", jsonArr.toString());
			out.println(json.toString());
			return;
		} else {
			json.put("currentPage", 1);
			json.put("totalPage", 1);
			json.put("mapList", jsonArr.toString());
			out.println(json.toString());
			return;
		}
	}
	String createdatestart = Util.null2String(request
			.getParameter("createdatestart"));
	String createdateend = Util.null2String(request
			.getParameter("createdateend"));
	String requestmark = Util.null2String(request
			.getParameter("requestmark"));
	String prjids = Util.null2String(request.getParameter("prjids"));
	String crmids = Util.null2String(request.getParameter("crmids"));
	String isfrom = Util.null2String(request.getParameter("isfrom"));
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	if(workflowid.equals("") || workflowid.equals("0")){
		workflowid = Util.null2String(request.getParameter("flowReport_flowId"));
	}
	
	String currworkflowid = Util.null2String(request.getParameter("currworkflowid"));

	String department = Util.null2String(request
			.getParameter("department"));
	String subid = Util.null2String(request.getParameter("subid"));
	if(department.startsWith(",")){
		department=department.substring(1);
	}
	String fieldid = Util.null2String(request.getParameter("fieldid"));
	String gdtype = "";
	int date2during = 0;
	date2during = Util.getIntValue(request.getParameter("date2during"), 0);
	String sqlgdtype = "select gdtype,jsqjtype from workflow_rquestBrowseFunction WHERE workflowid="+currworkflowid+" AND fieldid="+fieldid;
	rs1.executeSql(sqlgdtype);
	//rs1.writeLog("sqlgdtype==="+sqlgdtype);
	if(rs1.next()){
		gdtype = rs1.getString(1);
		if(date2during==0) 
			date2during = rs1.getInt(2);
	}
	String status = Util.null2String(request.getParameter("status"));
	if("".equals(status)){
		status = gdtype;
	}
	String requestname = Util.null2String(request.getParameter("requestname"));
	String creater = Util.null2String(request.getParameter("creater"));
	if(creater.startsWith(",")){
		creater=creater.substring(1);
	}
	
	String userid = "" + user.getUID();
	String usertype = "0";

	if (user.getLogintype().equals("2"))
		usertype = "1";
	
	if (creater.trim().startsWith(",")) {
		creater = creater.substring(1);
	}
	String sqlwherehead=" where 1=1";
	StringBuffer sqlwhere = new StringBuffer();
	String sqltemp="";

	if (!requestname.equals("")) {
		sqlwhere.append(" and a.requestnamenew like '%"
				+ Util.fromScreen2(requestname, user.getLanguage())
				+ "%' ");
	}
	if (!creater.equals("")) {
		sqlwhere.append(" and a.creater in (" + creater
				+ ") and a.creatertype=0 ");
	}

	if (!createdatestart.equals("")) {
		sqlwhere.append(" and a.createdate >='" + createdatestart + "' ");
	}

	if (!createdateend.equals("")) {
		sqlwhere.append(" and a.createdate <='" + createdateend + "' ");
	}

	if (status.equals("1")) {
		sqlwhere.append(" and a.currentnodetype < 3 ");
	}

	if (status.equals("2")) {
		sqlwhere.append(" and a.currentnodetype = 3 ");
	}

	if (!workflowid.equals("") && !workflowid.equals("0")) {
		if(!workflowid.equals("-999")){
			sqlwhere.append(" and a.workflowid in ( "
				+ WorkflowVersion.getAllVersionStringByWFIDs(workflowid) + ")");
		}else{
			sqlwhere.append(" and a.workflowid in ("+workflowid+")");
		}
	}

	if (!department.equals("") && !department.equals("0")) {
		sqlwhere.append(" and a.creater in (select id from hrmresource where departmentid in ("
				+ department + "))");
	}

	if (!"".equals(subid) && !"0".equals(subid) && !"flowrpt".equals(isfrom)) {
		sqlwhere.append(" and a.creater in (select id from hrmresource where subcompanyid1 in (" + subid + "))");
	}

	if (!"".equals(prjids) && !"0".equals(prjids)) {
		String[] prjidAry = prjids.split(",");
		if (prjidAry.length > 0) {
			sqlwhere.append(" AND (");
			if ("oracle".equals(RecordSet.getDBType())) {
				for (int i = 0; i < prjidAry.length; i++) {
					if (i > 0) {
						sqlwhere.append(" OR ");
					}
					sqlwhere.append("(concat(concat(',' , To_char(a.prjids)) , ',') LIKE '%,"
							+ prjidAry[i] + ",%')");
				}
			} else {
				for (int i = 0; i < prjidAry.length; i++) {
					if (i > 0) {
						sqlwhere.append(" OR ");
					}
					sqlwhere.append("(',' + CONVERT(varchar,a.prjids) + ',' LIKE '%,"
							+ prjidAry[i] + ",%')");
				}
			}
			sqlwhere.append(") ");
		}
	}

	if (!"".equals(crmids) && !"0".equals(crmids)) {
		String[] crmidAry = crmids.split(",");
		if (crmidAry.length > 0) {
			sqlwhere.append(" AND (");
			if ("oracle".equals(RecordSet.getDBType())) {
				for (int i = 0; i < crmidAry.length; i++) {
					if (i > 0) {
						sqlwhere.append(" OR ");
					}
					sqlwhere.append("(concat(concat(',' , To_char(a.crmids)) , ',') LIKE '%,"
							+ crmidAry[i] + ",%')");
				}
			} else {
				for (int i = 0; i < crmidAry.length; i++) {
					if (i > 0) {
						sqlwhere.append(" OR ");
					}
					sqlwhere.append("(',' + CONVERT(varchar,a.crmids) + ',' LIKE '%,"
							+ crmidAry[i] + ",%')");
				}
			}
			sqlwhere.append(") ");
		}
	}

	if (!requestmark.equals("")) {
		sqlwhere.append(" and a.requestmark like '%" + requestmark + "%' ");
	}

	if (sqlwhere.equals(""))
		sqlwhere.append(" and a.requestid <> 0 ");
		
	if (RecordSet.getDBType().equals("oracle")) {
			if(!"flowrpt".equals(isfrom)){
				sqlwhere.append(" and (nvl(a.currentstatus,-1) = -1 or (nvl(a.currentstatus,-1)=0 and a.creater="
						+ user.getUID() + ")) ");
			}
	} else {
		if(!"flowrpt".equals(isfrom)){
			sqlwhere.append(" and (isnull(a.currentstatus,-1) = -1 or (isnull(a.currentstatus,-1)=0 and a.creater="
					+ user.getUID() + ")) ");
		}
	}

	sqlwhere.append(WorkflowComInfo.getDateDuringSql(date2during));	
	/*
	sqlwhere.append(" and exists (select 1 from workflow_currentoperator b,workflow_base c where b.requestid = a.requestid ");
	if(!"flowrpt".equals(isfrom)){
		sqlwhere.append(" and b.userid in ("+userID );
	}
	sqlwhere.append(" )and b.usertype="+usertype
			+" and a.workflowid = c.id" 
			+" and c.isvalid in (1,3) and (c.istemplate is null or c.istemplate<>'1'))");
	*/
	
	sqlwhere.append(" and b.requestid = a.requestid ");
    if(!"flowrpt".equals(isfrom)){
        sqlwhere.append(" and b.userid in ("+userID+")" );
    }
    sqlwhere.append(" and b.usertype="+usertype
            +" and a.workflowid = c.id" 
            +" and c.isvalid in (1,3) and (c.istemplate is null or c.istemplate<>'1')");
	
    sqlwhere.append(" and islasttimes=1 ");
	
	sqlwhere.append(_fnaSqlwhere);
	
	String sqlend=" order by createdate desc, createtime desc";
	String sqlstr = "";
	int perpage = Util
			.getIntValue(request.getParameter("pageSize"), 10);
	int pagenum = Util.getIntValue(request.getParameter("currentPage"),
			1);
   // String sql_counts="select count(a.requestid) RecordSetCounts from workflow_requestbase a"
	//	+ sqlwherehead+sqlwhere.toString().replaceAll("receivedate","createdate");
	//RecordSet.executeSql(sql_counts);
	//int RecordSetCounts = 0;
	//if (RecordSet.next()) {
	//	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
	//}
	//int totalPage = RecordSetCounts / perpage;
	//if (totalPage % perpage > 0 || totalPage == 0) {
	//	totalPage++;
	//}
    if (!excludeId.equals("")) {
		//sqlwhere.append(" and a.requestid not in (" + excludeId + ")");
	}
	if (!resourceids.equals("")) {
		//sqlwhere.append(" and a.requestid not in (" + resourceids + ")");
	}
	if (RecordSet.getDBType().equals("oracle")) {
		sqlstr = "select * from (select row_number() over(order by createdate desc, createtime desc) rn,a.requestid,a.requestname,a.creater,a.createdate,a.createtime,a.creatertype from workflow_requestbase a, workflow_currentoperator b, workflow_base c "
	    +" where 1=1 "+sqlwhere.toString().replaceAll("receivedate","createdate")+" ) where rn > "+(pagenum-1)*perpage+" and rn <="+pagenum*perpage+sqlend;
	}else{
	    sqlstr = "select top "+perpage+" a.requestid,a.requestname,a.creater,a.createdate,a.createtime,a.creatertype from workflow_requestbase a, workflow_currentoperator b, workflow_base c "
	    +" where a.requestid not in (select top "+(pagenum-1)*perpage+" a.requestid from workflow_requestbase a where 1=1 "+sqlwhere.toString().replaceAll("receivedate","createdate")+sqlend+")"
	    +sqlwhere.toString().replaceAll("receivedate","createdate")+sqlend;
	}
	
	//new weaver.general.BaseBean().writeLog("流程查询SQL========"+sqlstr);
    RecordSet.executeSql(sqlstr);
    while(RecordSet.next()){
		String request_id = Util.null2String(RecordSet
				.getString("requestid"));
		String creater_name = Util.null2String(RecordSet
				.getString("creater"));
		String create_date = Util.null2String(RecordSet
				.getString("createdate"));
		String create_time = Util.null2String(RecordSet
				.getString("createtime"));
		String request_name = Util.null2String(RecordSet
				.getString("requestname"));
		String createtype = Util.null2String(RecordSet
				.getString("creatertype"));
		rs.execute("select workflowid from workflow_requestbase where requestid = "+request_id);
		if(rs.next()){
			workflowid = Util.null2String(rs.getString("workflowid"));
		}
		////根据后台设置在MAIL标题后加上流程中重要的字段


        rs.execute("select formid,isbill from workflow_base where id="+workflowid);
        if (rs.next())
        {
        	formid=rs.getInt(1);
        	isbill=rs.getInt(2);
        	
        }
		String titles=MailAndMessage.getTitle(Util.getIntValue(request_id,-1),Util.getIntValue(workflowid,-1),formid,user.getLanguage(),isbill);
		if (!titles.equals(""))
			request_name=request_name+"<B>("+titles+")</B>";
		if ("1".equals(createtype)){
				creater_name=crmComInfo.getCustomerInfoname(creater_name);
			}else{
				creater_name=ResourceComInfo.getResourcename(creater_name);
		}
		tmp.put("requestid", request_id);
		tmp.put("requestname",request_name);
		tmp.put("creater", creater_name);
		tmp.put("createtime", create_date + " " + create_time);
		jsonArr.add(tmp);
	}
	json.put("currentPage", pagenum);
	//json.put("totalPage", totalPage);
	json.put("sql",sqlstr);
	json.put("mapList", jsonArr.toString());
	//System.out.println(sqlstr);
	out.println(json.toString());
	return;
%>