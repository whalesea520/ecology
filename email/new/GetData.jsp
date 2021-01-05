
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.SplitPageParaBean"%>
<%@page import="weaver.general.SplitPageUtil"%>
<%@page import="weaver.file.Prop"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="com.alibaba.fastjson.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="adci" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page" />

<%!
    public JSONObject getSearchObj(String id, String name, String dpid, String department) {
        JSONObject jObject = new JSONObject();
        jObject.put("id", id);
        jObject.put("name", name);
        jObject.put("dpid", dpid);
        jObject.put("department", department);
        return jObject;
    }
%>

<%
    String key_word = java.net.URLDecoder.decode(Util.null2String(request.getParameter("q")), "UTF-8");
    if(key_word.isEmpty()){
    	return;
    }
    JSONArray resultArray = new JSONArray();

    String sqlWhere = "";
    String sqlWhere2 = "";
    if(adci.isUseAppDetach()){
    	String appdetawhere = adci.getScopeSqlByHrmResourceSearch(user.getUID()+"",false, "resource_hr");
    	String tempstr= (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
    	sqlWhere2 += tempstr;
    }
	sqlWhere += " #### like '%" + key_word + "%'";
	String backfields="id,lastname,departmentid";
	String sqlFrom="HrmResource hr";
	sqlWhere="(status =0 or status = 1 or status = 2 or status = 3) and ("+sqlWhere.replaceAll("####","lastname")+" or "+sqlWhere.replaceAll("####","pinyinlastname")+") " + sqlWhere2;
	SplitPageParaBean sppb = new SplitPageParaBean();
	SplitPageUtil spu = new SplitPageUtil();
	sppb.setBackFields(backfields);
	sppb.setSqlFrom(sqlFrom);
	sppb.setSqlWhere(" where "+sqlWhere);
	sppb.setPrimaryKey("id");
	sppb.setSortWay(sppb.ASC);
	sppb.setSqlOrderBy("dsporder");
	spu.setSpp(sppb);

	rs = spu.getCurrentPageRsNew(1, 30);
	while(rs.next()){
		resultArray.add(getSearchObj(rs.getString("id"), rs.getString("lastname"), rs.getString("departmentid"), DepartmentComInfo.getDepartmentname(rs.getString("departmentid"))));
	}
    
    out.clearBuffer();
    out.println(resultArray.toString());
%>
