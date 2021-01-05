<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Time"%>
<%@page import="weaver.email.domain.MailContact"%>
<%@page import="weaver.email.service.MailResourceService"%>
<%@page import="weaver.email.service.LabelManagerService"%>
<%@ page import="weaver.splitepage.transform.SptmForMail" %>

<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="org.apache.commons.lang.StringUtils"%> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="adci" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page" />
<%!
    public JSONObject getSearchObj(String name, String to) {
        JSONObject jObject = new JSONObject();
        jObject.put("name", name);
        jObject.put("to", to);
        return jObject;
    }
%>

<%
	String q = java.net.URLDecoder.decode(Util.null2String(request.getParameter("q")), "UTF-8");
	if(q.isEmpty()){
		return;
	}
	cms.initUserName(user.getUID());
	JSONArray resultArray = new JSONArray();
    
	StringBuffer sql = new StringBuffer();
	sql.append("select distinct mailUserName as name, mailaddress as email from mailUserAddress where userId="+ user.getUID() +" and ( mailaddress like '%"+q+"%' or mailUserName like '%"+q+"%' )");
	sql.append(" union ");
	
	String sqlWhere = " #### like '%" + q + "%'";
	String sqlWhere2 = "";
	if(adci.isUseAppDetach()){
		String appdetawhere = adci.getScopeSqlByHrmResourceSearch(user.getUID()+"",false, "resource_hr");
		String tempstr= (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
		sqlWhere2 += tempstr;
	}
	sql.append(" select distinct lastname as name, email from HrmResource hr where (status =0 or status = 1 or status = 2 or status = 3) and email is not null and ("+sqlWhere.replaceAll("####","lastname")+" or "+sqlWhere.replaceAll("####","pinyinlastname")+" or "+sqlWhere.replaceAll("####","email")+")  "+sqlWhere2);
	sql.append(" union ");
    
	//找到用户能看到的所有客户
	//如果属于总部级的CRM管理员角色，则能查看到所有客户。
	rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + user.getUID());
	if (rs.next()) {
		sql.append(" select distinct name,email from CRM_CustomerInfo where (deleted=0 or deleted is null)  and  email is not null and ("+sqlWhere.replaceAll("####","name")+" or "+sqlWhere.replaceAll("####","email")+") ");
	} else {
		String leftjointable = CrmShareBase.getTempTable(user.getUID()+"");
		sql.append(" select distinct t1.name,t1.email "
			+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
			+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null) and t1.email is not null and "+sqlWhere.replaceAll("####","t1.name")+" ");
	}
    
	rs.executeSql("select distinct name, email from (" + sql.toString() + ") a where email is not null");
	while(rs.next()){
	    String email = Util.null2String(rs.getString("email"));
        if(StringUtils.isNotEmpty(email)) {
            resultArray.add(getSearchObj(rs.getString("name"), email));
        }
	}
    
    out.clearBuffer();
    out.println(resultArray.toString());
%>