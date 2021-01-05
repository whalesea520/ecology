
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.report.FnaReport"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*,weaver.file.Prop" %>
<%@ page import="weaver.hrm.*,weaver.hrm.common.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.systeminfo.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response) ;

	String src = Util.null2String(request.getParameter("src"));
	String _guid1 = Util.null2String(request.getParameter("_guid1"));

	String check_per = Util.null2String(request.getParameter("systemIds"));
	if(check_per.equals(",")){
		check_per = "";
	}
	if(check_per.trim().startsWith(",")){
		check_per = check_per.substring(1);
	}
	
	String rptTbName = "";
	String rptTypeName = "";
	rs.executeSql("select * from fnaTmpTbLog where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"'");
	if(rs.next()){
		rptTbName = Util.null2String(rs.getString("tbDbName")).trim();
		rptTypeName = Util.null2String(rs.getString("rptTypeName")).trim();
	}
	

	boolean canview = FnaReport.checkUserRight(rptTypeName, user) ;
	if(!canview) {
		response.sendRedirect("/notice/noright.jsp") ; 
		return ; 
	}
	
	HashMap<String, String> retHm = FnaReport.getFnaReportShareLevel(_guid1, user.getUID());
	boolean isView = "true".equals(retHm.get("isView"));//查看
	boolean isEdit = "true".equals(retHm.get("isEdit"));//编辑
	boolean isFull = "true".equals(retHm.get("isFull"));//完全控制
	if(!isView && !isEdit && !isFull) {
		response.sendRedirect("/notice/noright.jsp") ; 
		return ; 
	}
	
	boolean _flag1 = false;
	String _strtmp = "select count(*) cnt from fnaTmpTbLogColInfo where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' \n";
	rs.executeSql(_strtmp);
	if(rs.next() && rs.getInt("cnt") > 0){
		_flag1 = true;
	}

	int orgType = -1;
	if(_flag1){
		_strtmp = "select distinct colType from fnaTmpTbLogColInfo \n" +
				" where colType not in ('"+SystemEnv.getHtmlLabelNames("585,18621", user.getLanguage())+"')\n" +
				" and guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"'";
		rs.executeSql(_strtmp);
		if(rs.next()){
			String colType = Util.null2String(rs.getString("colType")).trim();
			
			if((SystemEnv.getHtmlLabelName(140, user.getLanguage())+"id").equals(colType)){
				orgType = 0;
			}else if((SystemEnv.getHtmlLabelName(141, user.getLanguage())+"id").equals(colType)){
				orgType = 1;
			}else if((SystemEnv.getHtmlLabelName(124, user.getLanguage())+"id").equals(colType)){
				orgType = 2;
			}else if((SystemEnv.getHtmlLabelName(6087, user.getLanguage())+"id").equals(colType)){
				orgType = 3;
			}else if((SystemEnv.getHtmlLabelName(515, user.getLanguage())+"id").equals(colType)){
				orgType = FnaCostCenter.ORGANIZATION_TYPE;
			}
		}
	}else{
		_strtmp = "select distinct orgType from "+rptTbName+" where guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"'";
		rs.executeSql(_strtmp);
		if(rs.next()){
			orgType = rs.getInt("orgType");
		}
	}
	

	Map orgNameMap = new HashMap();
	Map orgCodeMap = new HashMap();
	if(!check_per.equals("")){
		try{
			String strtmp = "select orgId from "+rptTbName+" where orgId in ("+check_per+") and guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' GROUP BY orgId ORDER BY min(id)";
			if(_flag1){
				strtmp = "select colValueInt orgId from fnaTmpTbLogColInfo where colValueInt in ("+check_per+") and guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' ORDER BY id";
			}
			rs.executeSql(strtmp);
			while(rs.next()){
				int orgId = rs.getInt("orgId");
				
				String sql1 = "";
				if(orgType == 1){
					sql1 = "select a.id, a.subcompanyname name, a.subcompanycode code from HrmSubCompany a where a.id = "+orgId;
				}else if(orgType == 2){
					sql1 = "select a.id, a.departmentname name, a.departmentcode code from HrmDepartment a where a.id = "+orgId;
				}else if(orgType == 3){
					sql1 = "select a.id, a.lastname name, a.workcode code from HrmResource a where a.id = "+orgId;
				}else if(orgType == FnaCostCenter.ORGANIZATION_TYPE){
					sql1 = "select a.id, a.name name, a.code code from FnaCostCenter a where a.id = "+orgId;
				}
				
				String _orgName = "";
				String _orgCode = "";
				if(!"".equals(sql1)){
					rs1.executeSql(sql1);
					if(rs1.next()){
						_orgName = Util.null2String(rs1.getString("name"));
						_orgCode = Util.null2String(rs1.getString("code"));
					}
				}
				
				orgNameMap.put(orgId+"", _orgName);
				orgCodeMap.put(orgId+"", _orgCode);
			}
		}catch(Exception e){}
	}
	
	StringTokenizer st = new StringTokenizer(check_per,",");
	int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
	if(src.equalsIgnoreCase("dest")){
		perpage = 99999;
	}
	int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
	JSONObject json = new JSONObject();
	
	if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件
		
		JSONArray jsonArr = new JSONArray();
		if(st!=null){
			while(st.hasMoreTokens()){
				String id = st.nextToken();
				String orgName = Util.null2String((String)orgNameMap.get(id+"")).trim();
				String orgCode = Util.null2String((String)orgCodeMap.get(id+"")).trim();
				JSONObject tmp = new JSONObject();
				tmp.put("id",id);
				tmp.put("orgName",FnaCommon.escapeHtml(orgName));
				tmp.put("orgCode",FnaCommon.escapeHtml(orgCode));
				jsonArr.add(tmp);
			}
		}
	
		int totalPage = jsonArr.size();
		if(totalPage%perpage>0||totalPage==0){
			totalPage++;
		}
	
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
		return;
		
	}else{//左侧待选择列表的sql条件
		
		String orgName = Tools.getURLDecode(request.getParameter("orgName"));
		String orgCode = Tools.getURLDecode(request.getParameter("orgCode"));
		
		String sqlFrom = "select distinct ";
		if(_flag1){
			sqlFrom += " a.colValueInt id ";
		}else{
			sqlFrom += " a.orgId id ";
		}
		if(orgType == 1){
			sqlFrom += ", b.subcompanyname name, b.subcompanycode code, b.showorder showorder";
		}else if(orgType == 2){
			sqlFrom += ", b.departmentname name, b.departmentcode code, b.showorder showorder";
		}else if(orgType == 3){
			sqlFrom += ", b.lastname name, b.workcode code, b.dsporder showorder";
		}else if(orgType == FnaCostCenter.ORGANIZATION_TYPE){
			sqlFrom += ", b.name name, b.code code, b.code showorder";
		}

		if(_flag1){
			sqlFrom += " from fnaTmpTbLogColInfo a ";
		}else{
			sqlFrom += " from "+rptTbName+" a ";
		}
		
		if(orgType == 1){
			if(_flag1){
				sqlFrom += " join HrmSubCompany b on b.id = a.colValueInt ";
			}else{
				sqlFrom += " join HrmSubCompany b on b.id = a.orgId ";
			}
		}else if(orgType == 2){
			if(_flag1){
				sqlFrom += " join HrmDepartment b on b.id = a.colValueInt ";
			}else{
				sqlFrom += " join HrmDepartment b on b.id = a.orgId ";
			}
		}else if(orgType == 3){
			if(_flag1){
				sqlFrom += " join HrmResource b on b.id = a.colValueInt ";
			}else{
				sqlFrom += " join HrmResource b on b.id = a.orgId ";
			}
		}else if(orgType == FnaCostCenter.ORGANIZATION_TYPE){
			if(_flag1){
				sqlFrom += " join FnaCostCenter b on b.id = a.colValueInt ";
			}else{
				sqlFrom += " join FnaCostCenter b on b.id = a.orgId ";
			}
		}
				
		sqlFrom += " where a.guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' ";
		if(_flag1){
			sqlFrom += " and a.colType not in ('"+SystemEnv.getHtmlLabelNames("585,18621", user.getLanguage())+"') ";
		}

		if(!"".equals(orgName)){

			String nameSqlStr = "";
			if(orgType == 1){
				nameSqlStr = "b.subcompanyname";
			}else if(orgType == 2){
				nameSqlStr = "b.departmentname";
			}else if(orgType == 3){
				nameSqlStr = "b.lastname";
			}else if(orgType == FnaCostCenter.ORGANIZATION_TYPE){
				nameSqlStr = "b.name";
			}
			
			sqlFrom += " and "+nameSqlStr+" like '%" + StringEscapeUtils.escapeSql(orgName) +"%' ";
		}
		
		if(!"".equals(orgCode)){

			String codeSqlStr = "";
			if(orgType == 1){
				codeSqlStr = "b.subcompanycode";
			}else if(orgType == 2){
				codeSqlStr = "b.departmentcode";
			}else if(orgType == 3){
				codeSqlStr = "b.workcode";
			}else if(orgType == FnaCostCenter.ORGANIZATION_TYPE){
				codeSqlStr = "b.code";
			}
			
			sqlFrom += " and "+codeSqlStr+" like '%" + StringEscapeUtils.escapeSql(orgCode) +"%' ";
		}
		
		String excludeId = Util.null2String(request.getParameter("excludeId"));
		if(excludeId.length()==0){
			excludeId=check_per;
		}
		if(excludeId.length()>0){
			if(_flag1){
				sqlFrom += " and a.colValueInt not in ("+excludeId+")";
			}else{
				sqlFrom += " and a.orgId not in ("+excludeId+")";
			}
		}
		
		String sqlOrderBy = "showorder,code,name";
		
		new BaseBean().writeLog(sqlFrom);
	
		SplitPageParaBean spp = new SplitPageParaBean();
		spp.setBackFields("*");
		spp.setSqlFrom(" from ( "+sqlFrom+" ) t1 ");
		spp.setSqlWhere("");
		spp.setSqlOrderBy(sqlOrderBy);
		spp.setPrimaryKey("id");
		spp.setDistinct(true);
		spp.setSortWay(spp.ASC);
		SplitPageUtil spu = new SplitPageUtil();
		spu.setSpp(spp);

		int RecordSetCounts = spu.getRecordCount();
		int totalPage = RecordSetCounts/perpage;
		if(totalPage%perpage>0||totalPage==0){
			totalPage++;
		}
		
		rs = spu.getCurrentPageRs(pagenum, perpage);

		JSONArray jsonArr = new JSONArray();
		while(rs.next()) {
			JSONObject tmp = new JSONObject();
			tmp.put("id", rs.getString("id"));
			tmp.put("orgName", FnaCommon.escapeHtml(rs.getString("name")));
			tmp.put("orgCode", FnaCommon.escapeHtml(rs.getString("code")));
			jsonArr.add(tmp);
		}
		json.put("currentPage", pagenum);
		json.put("totalPage", totalPage);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
		
	}
%>