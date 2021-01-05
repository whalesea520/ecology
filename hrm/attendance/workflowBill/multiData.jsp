<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,weaver.general.*,weaver.hrm.*" %>
<%@ page import="net.sf.json.JSONArray,net.sf.json.JSONObject" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
	User user = HrmUserVarify.getUser(request, response);
	int perpage = strUtil.parseToInt(request.getParameter("pageSize"), 10);
	int pagenum = strUtil.parseToInt(request.getParameter("currentPage"), 1);
	String src = strUtil.vString(request.getParameter("src"));
	String selectids = strUtil.vString(request.getParameter("selectids"));
	if(selectids.startsWith(",")) selectids = selectids.substring(1);
	selectids = strUtil.vString(selectids, strUtil.vString(request.getParameter("systemIds")));
	if(selectids.startsWith(",")) selectids = selectids.substring(1);
	String subCompanyIds = "";
	if(manageDetachComInfo.isUseWfManageDetach()) {
		int subCompany[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowManage:All");
		for(int i = 0; i < subCompany.length; i++) subCompanyIds += (subCompanyIds.length()==0?"":",") +subCompany[i];
	}
	JSONObject json = new JSONObject();
	if(src.equalsIgnoreCase("dest")) {
		JSONArray jsonArr = new JSONArray();
		if(selectids.length() > 0) {
			StringBuffer sql = new StringBuffer();
			sql.append("select t.id,t2.labelname,t.formdes from workflow_bill t left join HtmlLabelInfo t2 on t.namelabel = t2.indexid and languageid = "+user.getLanguage()+" where t.id in ("+selectids+")");
			if(subCompanyIds.length() > 0){
				sql.append(" and t.subcompanyid in ("+subCompanyIds+")");
			}
			rs.executeSql(sql.toString());
			while(rs.next()) {
				JSONObject tmp = new JSONObject();
				tmp.put("id", rs.getString("id"));
				tmp.put("namelabel",rs.getString("labelname"));
				tmp.put("formdes",rs.getString("formdes"));
				jsonArr.add(tmp);
			}
		}
		int totalPage = jsonArr.size();
		if(totalPage%perpage > 0 || totalPage == 0) totalPage++;
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
	} else {
		String namelabel = strUtil.vString(request.getParameter("namelabel"));
		int isBill = strUtil.parseToInt(request.getParameter("isBill"));
		String excludeId = strUtil.vString(request.getParameter("excludeId"), selectids);
		String paramWhere = strUtil.vString(request.getParameter("sqlwhere"));
		String sqlWhere = " where 1=1 ";
		if(excludeId.length()>0) {
			sqlWhere += " and t.id not in ("+excludeId+")";
		}
		if(subCompanyIds.length() > 0){
			sqlWhere += " and t.subcompanyid in ("+subCompanyIds+")";
		}
		if(namelabel.length() > 0) {
			sqlWhere += " and t2.labelname like '%"+namelabel+"%'";
		}
		if(isBill != -1) {
			sqlWhere += " and t.id "+(isBill==0?"<":">")+" 0";
		}
		if(paramWhere.equals("onlystateform")) {
			sqlWhere += " and t.id in (select field002 from hrm_state_proc_set group by field002)";
		}
		SplitPageParaBean spp = new SplitPageParaBean();
		spp.setBackFields(" t.id,t2.labelname,t.formdes ");
		spp.setSqlFrom(" from workflow_bill t left join HtmlLabelInfo t2 on t.namelabel = t2.indexid and languageid = "+user.getLanguage());
		spp.setSqlWhere(sqlWhere);
		spp.setSqlOrderBy("");
		spp.setPrimaryKey("t.id");
		spp.setDistinct(true);
		spp.setSortWay(spp.DESC);
		SplitPageUtil spu = new SplitPageUtil();
		spu.setSpp(spp);

		int totalPage = spu.getRecordCount()/perpage;
		if(totalPage%perpage > 0 || totalPage == 0) totalPage++;
		JSONArray jsonArr = new JSONArray();
		rs = spu.getCurrentPageRs(pagenum, perpage);
		while(rs.next()) {
			JSONObject tmp = new JSONObject();
			tmp.put("id", rs.getString("id"));
			tmp.put("namelabel",rs.getString("labelname"));
			tmp.put("formdes",rs.getString("formdes"));
			jsonArr.add(tmp);
		}
		json.put("currentPage", pagenum);
		json.put("totalPage", totalPage);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
	}
%>
