
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*,weaver.file.Prop" %>
<%@ page import="weaver.hrm.*,weaver.hrm.common.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response) ;
	String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
	String src = Util.null2String(request.getParameter("src"));
	String type = Util.null2String(request.getParameter("type"),"query");
	String isNoAccount = Util.null2String(request.getParameter("isNoAccount"));
	String check_per = Util.null2String(request.getParameter("selectids"));
	if(check_per.trim().startsWith(",")){
		check_per = check_per.substring(1);
	}
	String roleids = Tools.getURLDecode(request.getParameter("roleid"));
	boolean isoracle = rs.getDBType().equals("oracle");
	ArrayList resourcrole = Util.TokenizerString(roleids,"_");
	String[] resourcroles = roleids.split("_");
	check_per="";
	String roleid="0";
	if (resourcrole.size()>0)
		roleid=""+resourcrole.get(0);
	if (resourcrole.size()==2){
		check_per=Util.null2String(""+resourcrole.get(1));
	}
	StringTokenizer st = new StringTokenizer(check_per,",");
	int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
	int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
	String sqlWhere = " where 1=1 ";
	JSONObject json = new JSONObject();
	if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件
		JSONArray jsonArr = new JSONArray();
		String id=null;
		if(st!=null){
			while(st.hasMoreTokens()){
				id = st.nextToken();
				String departmentname = DepartmentComInfo.getDepartmentname(resourceComInfo.getDepartmentID(id));
				String subcompanyname = SubCompanyComInfo.getSubCompanyname(resourceComInfo.getSubCompanyID(id));
				
				JSONObject tmp = new JSONObject();
				tmp.put("id",id);
				tmp.put("lastname",resourceComInfo.getLastname(id));
				tmp.put("departmentname",departmentname);
				tmp.put("subcompanyname",subcompanyname);
				jsonArr.add(tmp);
			}
		}
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
		return;
	}else{//左侧待选择列表的sql条件
		String lastname = Tools.getURLDecode(request.getParameter("lastname"));
		int uid = user.getUID();
		int index = roleid.indexOf("a");
		int rolelevel = 0;
		if(index > -1){
			int roledid_tmp = Util.getIntValue(roleid.substring(0, index), 0);
			String rolelevelStr = roleid.substring(index+1);
			
			roleid = ""+roledid_tmp;
			index = rolelevelStr.indexOf("b");
			if(index > -1){
				rolelevel = Util.getIntValue(rolelevelStr.substring(0, index), 0);
				uid = Util.getIntValue(rolelevelStr.substring(index+1), 0);
				if(uid <= 0){
					uid = user.getUID();
				}
			}else{
				rolelevel= Util.getIntValue(rolelevelStr);
			}
		}
		sqlWhere = Util.null2String(request.getParameter("sqlwhere"));
		if(sqlWhere.length()==0)
			sqlWhere =" where 1=1 ";
		if(!roleid.equals("")){
			sqlWhere += " and a.ID in (select t1.ResourceID from hrmrolemembers t1,hrmroles t2 where t1.roleid = t2.ID and t2.ID in ("+roleid+")) " ;
		}
		String sqlAdd = "";
		if(rolelevel != 0){
			if(rolelevel == 1){
				int subcomid = Util.getIntValue(resourceComInfo.getSubCompanyID(""+uid), 0);
				sqlWhere += " and a.subcompanyid1="+subcomid+" ";
			}else if(rolelevel == 2){
				int subcomid = Util.getIntValue(resourceComInfo.getSubCompanyID(""+uid), 0);
				int supsubcomid = Util.getIntValue(SubCompanyComInfo.getSupsubcomid(""+subcomid), 0);
				sqlWhere += " and a.subcompanyid1="+supsubcomid+" ";
			}else if(rolelevel == 3){
				int departid = Util.getIntValue(resourceComInfo.getDepartmentID(""+uid), 0);
				sqlWhere += " and a.departmentid="+departid+" ";
			}
		}
		
		String excludeId = Util.null2String(request.getParameter("excludeId"));
		if(excludeId.length()==0)excludeId=check_per;
		if(excludeId.length()>0){
			sqlWhere += " and a.id not in ("+excludeId+")";
		}

		if(lastname.length() > 0){
			sqlWhere += " and a.lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
		}
		SplitPageParaBean spp = new SplitPageParaBean();
		spp.setBackFields(" a.id,a.lastname,a.departmentid,a.subcompanyid1,a.jobtitle,a.dsporder ");
		spp.setSqlFrom(" from HrmResource a ");
		spp.setSqlWhere(sqlWhere);
		spp.setSqlOrderBy("a.dsporder,a.lastname");
		spp.setPrimaryKey("a.id");
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
			String departmentname = DepartmentComInfo.getDepartmentName(rs.getString("departmentid"));
			String subcompanyname = SubCompanyComInfo.getSubCompanyname(rs.getString("subcompanyid1"));

			tmp.put("id",rs.getString("id"));
			tmp.put("lastname",rs.getString("lastname"));
			tmp.put("departmentname",departmentname);
			tmp.put("subcompanyname",subcompanyname);
			jsonArr.add(tmp);
		}
		json.put("currentPage", pagenum);
		json.put("totalPage", totalPage);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
	}
%>
