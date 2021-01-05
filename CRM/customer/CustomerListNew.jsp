<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.URLDecoder"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="CustomerService" class="weaver.crm.customer.CustomerService" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
int userid=user.getUID();
String labelid=Util.null2String(request.getParameter("labelid"),"my");       //标签id my我的客户，all全部客户，attention关注客户
String resourceid=Util.null2String(request.getParameter("resourceid"),""+userid);    //被查看人id
String viewtype=Util.null2String(request.getParameter("viewtype"),"0");              //查看类型 0仅本人，1包含下属，2仅下属
String sector=Util.null2String(request.getParameter("sector"));
String status=Util.null2String(request.getParameter("status"));
String name =URLDecoder.decode(Util.null2String(request.getParameter("name")));
String leftjointable = CrmShareBase.getTempTable(""+userid);
String backfields="id,name,manager,case when t3.customerid is not null then 1 else 0 end as important";
String sqlFrom=" CRM_CustomerInfo t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid "+
			   " left join (select customerid from CRM_Attention where resourceid="+resourceid+") t3 on t1.id=t3.customerid ";
String sqlWhere=" t1.deleted = 0  and t1.id = t2.relateditemid ";
if(labelid.equals("my")){  //我的客户
	if(viewtype.equals("0")){ //仅本人客户
		sqlWhere+=" and t1.manager="+resourceid;
	}else if(viewtype.equals("1")){ //包含下属
		String subResourceid=CustomerService.getSubResourceid(resourceid); //所有下属
		if(!subResourceid.equals("")) {
		    sqlWhere+=" and (t1.manager="+resourceid+" or t1.manager in("+subResourceid+"))";
		}else {
		    sqlWhere+=" and t1.manager="+resourceid;
		}
			
	}else if(viewtype.equals("2")){ //仅下属
		String subResourceid=CustomerService.getSubResourceid(resourceid); //所有下属
		if(!subResourceid.equals("")) {
		    sqlWhere+=" and t1.manager in("+subResourceid+")";
		}else {
		    sqlWhere+=" and t1.manager in(-999)";
		}
			
	}
}else if(labelid.equals("attention")){
	sqlWhere+=" and t3.customerid is not null";
}else if(labelid.equals("new")){
	sqlFrom+=" left join CRM_ViewLog2 t5 on t1.id=t5.customerid ";
	sqlWhere+=" and t1.id=t5.customerid and t1.manager="+userid;
}else if(!labelid.equals("all")){
	sqlFrom+=" left join (select customerid from CRM_Customer_label where labelid="+labelid+") t4 on t1.id=t4.customerid";
	sqlWhere+=" and t1.id=t4.customerid ";
}
if(!"".equals(status)){
	sqlWhere+=" and status="+status;
}
if(!"".equals(sector)){
	sqlWhere+=" and sector="+sector;
}
if(!"".equals(name)){
	sqlWhere+=" and name like '%"+name+"%'";
}
String orderBy = "t1.id";
String tableInfo = "";
String tableString="<table pageId=\""+PageIdConst.CRM_CustomerList+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_CustomerList,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"checkbox\">";
tableString+="<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"Desc\" sqlprimarykey=\"t1.id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlisdistinct=\"true\" />";
tableString+="<head>"+
"<col name='name' width='70%' text='"+SystemEnv.getHtmlLabelNames("1268",user.getLanguage())+"' column='name' onclick='javascript:alert(1);' transmethod='weaver.crm.Maint.CRMTransMethod.getCustomerName' otherpara='column:id' orderkey='t1.name' target='_blank'/>"+
"<col name='manager' width='20%' text='"+SystemEnv.getHtmlLabelNames("1278",user.getLanguage())+"' column='manager' transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename' href='/hrm/resource/HrmResource.jsp' linkkey='id' orderkey='t1.manager' target='_blank'/>"+
"<col name='important' width='10%' text='"+SystemEnv.getHtmlLabelNames("25436",user.getLanguage())+"' column='important' transmethod='weaver.crm.Maint.CRMTransMethod.getImportant' otherpara='column:id' target='_blank'/>"+
"</head>";
tableString+="</table>"; 
%>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
