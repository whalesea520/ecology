
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.crm.customer.CustomerService"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CoworkTransMethod" class="weaver.general.CoworkTransMethod" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerService" class="weaver.crm.customer.CustomerService" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
int userid=user.getUID();
String labelid=Util.null2String(request.getParameter("labelid"),"my");       //标签id my我的商机，all全部商机，attention关注商机，expire到期商机
String creater=Util.null2String(request.getParameter("creater"));    //被查看人id
String includeSubCompany=Util.null2String(request.getParameter("includeSubCompany"));
String subCompanyId=Util.null2String(request.getParameter("subCompanyId"));
String includeSubDepartment=Util.null2String(request.getParameter("includeSubDepartment"));
String departmentId=Util.null2String(request.getParameter("departmentId"));
String preyield=Util.null2String(request.getParameter("preyield"));
String preyield_1=Util.null2String(request.getParameter("preyield_1"));
String predate=Util.null2String(request.getParameter("predate"));
String fromdate=Util.null2String(request.getParameter("fromdate"));
String enddate=Util.null2String(request.getParameter("enddate"));
String productId=Util.null2String(request.getParameter("productId"));
String creater_str = Util.null2String(request.getParameter("creater_str"));
String containsSub = Util.null2String(request.getParameter("containsSub"),"0"); //0为包含下级，1为不包含下级
String sellstatusid_str = Util.null2String(request.getParameter("sellstatusid_str"));
String predate_str = Util.null2String(request.getParameter("predate_str"));
String probability_str = Util.null2String(request.getParameter("probability_str"));
String contactTime_str = Util.null2String(request.getParameter("contactTime_str"));
String preyield_str = Util.null2String(request.getParameter("preyield_str"));
String probability=Util.null2String(request.getParameter("probability"));
String probability_1=Util.null2String(request.getParameter("probability_1"));
String subject=Util.null2String(request.getParameter("name"));

RecordSet.execute("select creater from CRM_SellChance");
while(RecordSet.next()){
    String createrId = RecordSet.getString("creater");
    String deptId = ResourceComInfo.getDepartmentID(createrId);
    String scId = ResourceComInfo.getSubCompanyID(createrId);
    String sql = "update CRM_SellChance set departmentId = '"+deptId+"',subCompanyId = '"+scId+"' where creater = '"+createrId+"'";
    RecordSet.execute(sql);
}
if(!creater_str.equals("")){
	userid = Util.getIntValue(creater_str);
}
String leftjointable = CrmShareBase.getTempTable(""+userid);
String  backfields  =  "t1.id,t1.subject,t1.creater,t1.predate,t1.preyield,t1.probability,"+
	"	t1.sellstatusid,t1.createdate,t1.createtime,t1.endtatusid,t1.CustomerID ,case when t3.sellchanceid is not null then 1 else 0 end as important";
String  sqlFrom=" CRM_SellChance  t1 left join "+leftjointable+" t2 on t1.customerid = t2.relateditemid"+
				" left join (select sellchanceid from CRM_SellchanceAtt where resourceid="+userid+") t3 on t1.id=t3.sellchanceid left join CRM_CustomerInfo cc on cc.id=t1.customerid";
String  sqlWhere=" t1.customerid = t2.relateditemid and cc.deleted=0 ";
if(!"".equals(subject)){
	sqlWhere+=" and t1.subject like '%"+subject+"%'";
}
if(labelid.equals("my")){  //我的商机
	if("".equals(creater))
	creater = user.getUID()+"";
}else if(labelid.equals("attention")){
	sqlWhere+=" and t3.sellchanceid is not null";
}else if(labelid.equals("expire")){
	String date=TimeUtil.getCurrentDateString();//currentdate
	String date1= TimeUtil.dateAdd(date,-30);//currentdate-30
	sqlWhere +=" and t1.predate >= '"+date1+"' and t1.predate <= '"+date+"'";
}else if(!labelid.equals("all")){
	sqlFrom+=" left join (select sellchanceid from CRM_Sellchance_label where labelid="+labelid+") t4 on t1.id=t4.sellchanceid";
	sqlWhere+=" and t1.id=t4.sellchanceid ";
}
if(creater_str.equals("")){
	creater_str = creater;
}
if(!"".equals(sellstatusid_str)){
	sqlWhere+=" and t1.sellstatusid = '"+sellstatusid_str+"'";
}
if(!"".equals(predate_str)){
	int year = Util.getIntValue(predate_str.split("-")[0]);
	int month = Util.getIntValue(predate_str.split("-")[1]);
	sqlWhere += " and t1.predate >= '"+TimeUtil.getYearMonthFirstDay(year ,month)+"'";
	sqlWhere += " and t1.predate <= '"+TimeUtil.getYearMonthEndDay(year ,month)+"'";
}
if(!"".equals(preyield_str)){
	switch(Util.getIntValue(preyield_str)){
		case 0:
			preyield_1 = "50000";
			break;
		case 1:
			preyield = "50000";
			preyield_1 = "100000";
			break;
		case 2:
			preyield = "100000";
			preyield_1 = "200000";
			break;
		case 3:
			preyield = "200000";
			preyield_1 = "500000";
			break;
		case 4:
			preyield = "500000";
			preyield_1 = "1000000";
			break;
		case 5:
			preyield = "1000000";
			break;
	}
}
if(!preyield.equals("")){
	sqlWhere+=" and t1.preyield>="+preyield;
}
if(!preyield_1.equals("")){
	sqlWhere+=" and t1.preyield<="+preyield_1;
}
if(!"".equals(probability_str)){
	switch(Util.getIntValue(probability_str)){
		case 0:
			sqlWhere += " and 100 * probability <= 30";
			break;
		case 1:
			sqlWhere += " and 100 * probability >= 30 and 100 * probability <= 50";
			break;
		case 2:
			sqlWhere += " and 100 * probability >= 50 and 100 * probability <= 70";
			break;
		case 3:
			sqlWhere += " and 100 * probability >= 70 and 100 * probability <= 90";
			break;
		case 4:
			sqlWhere += " and 100 * probability >= 90";
			break;
	}
}
if(!probability.equals("")){
	sqlWhere+=" and t1.probability>="+probability;
}
if(!probability_1.equals("")){
	sqlWhere+=" and t1.probability<="+probability_1;
}
rs.execute("select fieldhtmltype ,type,fieldname , candel,groupid from CRM_CustomerDefinField where usetable = 'CRM_SellChance' and issearch= 1 and isopen=1");
String fieldName = "";
String fieldValue = "";
String htmlType = "";
String type= "";
while(rs.next()){
	fieldName = rs.getString("fieldName");
	fieldValue = Util.null2String(Util.null2String(request.getParameter(fieldName)));
	htmlType = rs.getString("fieldhtmltype");
	type = rs.getString("type");
	if(fieldName.equals("") || fieldValue.equals("")){
		continue;
	}
	if(fieldName.equals("predate")){
		if(!"".equals(predate) && !"6".equals(predate)){
			sqlWhere += " and t1.predate >= '"+TimeUtil.getDateByOption(predate+"","0")+"'";
			sqlWhere += " and t1.predate <= '"+TimeUtil.getDateByOption(predate+"","")+"'";
		}
		if("6".equals(predate) && !fromdate.equals("")){
			sqlWhere+=" and t1.predate>='"+fromdate+"'";
		}
		if("6".equals(predate) && !enddate.equals("")){
			sqlWhere+=" and t1.predate<='"+enddate+"'";
		}
	}else if(htmlType.equals("1") && (type.equals("2") || type.equals("3"))){//单行文本为数值类型
		sqlWhere +=  " and t1."+fieldName+" = "+fieldValue;
	}else if((htmlType.equals("5") || htmlType.equals("3"))&&!type.equals("162")){//下拉框 和 浏览框
		sqlWhere += " and t1."+fieldName+" = "+fieldValue;
	}else{
		sqlWhere += " and t1."+fieldName+" like '%"+fieldValue+"%'";
	}
}

if(!creater_str.equals("")){
	if(containsSub.equals("0")){ //仅本人
		sqlWhere+=" and t1.creater="+creater_str;
	}else if(containsSub.equals("1")){ //包含下属
		String subResourceid=CustomerService.getSubResourceid(creater_str); //所有下属
		if(!subResourceid.equals("")){
			sqlWhere+=" and (t1.creater="+creater_str+" or t1.creater in("+subResourceid+"))";
		}
	}
}

if(!productId.equals("")){
	sqlWhere+=" and t1.id in (select sellchanceid from CRM_ProductTable where productid ="+productId+")";
}

if(!"".equals(contactTime_str)){
	String UncontactTime = "";
	String contactTime = "";
	String date_str = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
	switch(Util.getIntValue(contactTime_str)){
		case 0:
			UncontactTime = TimeUtil.dateAdd(date_str,-3);
			break;
		case 1:
			UncontactTime = TimeUtil.dateAdd(date_str,-7);
			break;
		case 2:
			UncontactTime = TimeUtil.dateAdd(date_str,-14);
			break;
		case 3:
			UncontactTime = TimeUtil.dateAdd(date_str,-30);
			break;
		case 4:
			UncontactTime = TimeUtil.dateAdd(date_str,-90);
			break;
		case 5:
			UncontactTime = TimeUtil.dateAdd(date_str,-180);
			break;
		case 6:
			UncontactTime = TimeUtil.dateAdd(date_str,-365);
			break;
		case 7:
			contactTime = date_str;
			break;
		case 8:
			contactTime = TimeUtil.dateAdd(date_str,-7);
			break;
		case 9:
			contactTime = TimeUtil.dateAdd(date_str,-30);
			break;
		case 10:
			contactTime = TimeUtil.dateAdd(date_str,-90);
			break;
	}
	if(RecordSet.getDBType().equals("oracle")){
		if(!UncontactTime.equals("")&&11!=Util.getIntValue(contactTime_str)){
			sqlWhere += " and EXISTS(select createDate from workplan tt where id=(select id from (select id,sellchanceid,createdate from workplan order by createdate desc) where sellchanceid = t1.id and rownum<=1 and to_date(tt.createDate,'yyyy-MM-dd') <= to_date('"+UncontactTime+"','yyyy-MM-dd')))";
		}else if(11==Util.getIntValue(contactTime_str)){//无联系记录
			sqlWhere += " and not EXISTS(select createDate from workplan where sellchanceid = t1.id )";
		}
		if(!contactTime.equals("")){
			sqlWhere += " and EXISTS(select createDate from workplan tt where sellchanceid = t1.id and to_date(tt.createDate,'yyyy-MM-dd') >= to_date('"+contactTime+"','yyyy-MM-dd'))";
		}
	}else{
		if(!UncontactTime.equals("")&&11!=Util.getIntValue(contactTime_str)){
			sqlWhere += " and EXISTS(select tt.createDate from (select top 1 createDate from workplan where sellchanceid = t1.id  order by createDate desc)as tt where tt.createDate <= '"+UncontactTime+"')";
		}else if(11==Util.getIntValue(contactTime_str)){//无联系记录
			sqlWhere += " and not EXISTS(select createDate from workplan where sellchanceid = t1.id )";
		}
		if(!contactTime.equals("")){
			sqlWhere += " and EXISTS(select tt.createDate from (select top 1 createDate from workplan where sellchanceid = t1.id  order by createDate desc)as tt where tt.createDate >= '"+contactTime+"')";
		}
	}
}
if(!subCompanyId.equals("")&&!subCompanyId.equals("0")){//客户经理分部ID
	 if(includeSubCompany.equals("2")){
		String subCompanyIds = "";
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubCompanyLists(subCompanyId,list);
		for(int i=0;i<list.size();i++){
			subCompanyIds += ","+(String)list.get(i);
		}
		if(list.size()>0)subCompanyIds = subCompanyIds.substring(1);
		subCompanyIds = "("+subCompanyIds+")";
		sqlWhere+=" and t1.subCompanyId in "+subCompanyIds;
	}else if(includeSubCompany.equals("3")){
		String subCompanyIds = subCompanyId;
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubCompanyLists(subCompanyId,list);
		for(int i=0;i<list.size();i++){
			subCompanyIds += ","+(String)list.get(i);
		}
		subCompanyIds = "("+subCompanyIds+")";

		sqlWhere+=" and t1.subCompanyId in "+subCompanyIds;
	}else{
		sqlWhere+=" and t1.subCompanyId="+subCompanyId;
	}
}
if(!departmentId.equals("")){//客户经理部门ID
	if(includeSubDepartment.equals("2")){
		String departmentIds = "";
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubDepartmentLists(departmentId,list);
		for(int i=0;i<list.size();i++){
			departmentIds += ","+(String)list.get(i);
		}
		if(list.size()>0)departmentIds = departmentIds.substring(1);
		departmentIds = "("+departmentIds+")";
		sqlWhere+=" and t1.departmentId in "+departmentIds;
	}else if(includeSubDepartment.equals("3")){
		String departmentIds = departmentId;
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubDepartmentLists(departmentId,list);
		for(int i=0;i<list.size();i++){
			departmentIds += ","+(String)list.get(i);
		}
		departmentIds = "("+departmentIds+")";
		sqlWhere+=" and t1.departmentId in "+departmentIds;		
	}else{
		sqlWhere+=" and t1.departmentId="+departmentId;
	}
}
RecordSet.execute("select distinct t1.CustomerID from "+sqlFrom+" where "+sqlWhere);
StringBuffer crmIdBuffer = new StringBuffer();
while(RecordSet.next()){
	crmIdBuffer.append(RecordSet.getString("CustomerID")+",");
}
String crmIds = crmIdBuffer.toString();
if(!crmIds.equals("")){
	crmIds = crmIds.substring(0,crmIds.length()-1);
}
	String tableString = "";
	String orderby = "t1.id";
	tableString = " <table pageId=\""+PageIdConst.CRM_SellChanceList+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_SellChanceList,user.getUID(),PageIdConst.CRM)+"\"  tabletype=\"checkbox\">"+
				  " <sql backfields=\""+backfields+"\" sqlform=\""+sqlFrom+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"/>"+
				  " <checkboxpopedom showmethod=\"weaver.crm.sellchance.SellChangeRoprtTransMethod.getSellCheckInfo\" popedompara=\"column:endtatusid+column:customerid+"+user.getUID()+"\"  />"+
				  " <head>"+
	              " <col name='subject' width=\"70%\"  text=\""+SystemEnv.getHtmlLabelName(82534,user.getLanguage())+"\" column=\"subject\" orderkey=\"subject\" otherpara=\"column:id\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getSellChanceName\"/>"+
	              " <col name='creater' width='20%' text='"+SystemEnv.getHtmlLabelNames("1278",user.getLanguage())+"' column='creater' transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename' href='/hrm/resource/HrmResource.jsp' linkkey='id' orderkey='t1.creater' target='_blank'/>"+
	              " <col name='important' width='10%' text='关注' column='important' transmethod='weaver.crm.report.CRMContractTransMethod.getImportant' otherpara='column:id' target='_blank'/>"+
	              "	</head>"+
	 			  " </table>";
out.println("<script>viewDefault('"+crmIds+"')</script>");
%>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
