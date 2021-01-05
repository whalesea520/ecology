<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Time"%>
<%@page import="weaver.email.domain.MailContact"%>
<%@page import="weaver.email.service.MailResourceService"%>
<%@page import="weaver.email.service.LabelManagerService"%>
<%@ page import="weaver.splitepage.transform.SptmForMail" %>

<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"%> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>

<%

	StringBuffer sql = new StringBuffer();
	int rows = 5;
	String q = Util.null2String(request.getParameter("q"));
	q=java.net.URLDecoder.decode(q,"UTF-8");
	if(q.equals("")){
		return;
	}
	
	String sqlWhere = "mailaddress like '%"+q+"%' or mailUserName like '%"+q+"%'";
	ArrayList<MailContact> list = cms.getBySql(user.getUID(), sqlWhere);
	String returnStr="";
	for(int i=0;i<list.size();i++){
		MailContact mc = list.get(i);
		returnStr += ",{ name: '"+mc.getMailUserName()+"', to: '"+mc.getMailAddress()+"' }";
	}
	
	sqlWhere = " #### like '%" + q + "%'";
	
	

		sql.append("select id,lastname as name,email from HrmResource where (status =0 or status = 1 or status = 2 or status = 3) and email is not null and ("+sqlWhere.replaceAll("####","lastname")+" or "+sqlWhere.replaceAll("####","pinyinlastname")+" or "+sqlWhere.replaceAll("####","email")+") ");
		sql.append(" union ");
		String condition = "";
		//找到用户能看到的所有客户
		//如果属于总部级的CRM管理员角色，则能查看到所有客户。
		rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + user.getUID());
		if (rs.next()) {
			sql.append("select id,name from CRM_CustomerInfo where (deleted=0 or deleted is null) and and  email is not null ("+sqlWhere.replaceAll("####","name")+" or "+sqlWhere.replaceAll("####","email")+") ");
		} else {
			String leftjointable = CrmShareBase.getTempTable(user.getUID()+"");
			sql.append("select  t1.id,t1.name,t1.email "
				+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
				+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null) and t1.email is not null and "+sqlWhere.replaceAll("####","t1.name")+" ");
		}
		String  json = "";
		//System.out.println(sql);
		rs.executeSql(sql.toString());
		if(rs.getCounts()>0){
			while(rs.next()){
				json += "{to:'"+rs.getString(3)+"',name:'"+rs.getString(2)+"'";
				
				json += "},";
			}
			if(!json.equals("")){
				json =  json.substring(0,json.length()-1) ;
			}
		}
	out.clearBuffer();
	
	out.println("["+returnStr+","+json+"]");
%>