
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
<%
int userid=user.getUID();

int index=Util.getIntValue(request.getParameter("index"));                 //下标 
int pagesize=Util.getIntValue(request.getParameter("pagesize"));           //每一次取多少

String labelid=Util.null2String(request.getParameter("labelid"),"my");       //标签id my我的商机，all全部商机，attention关注商机，expire到期商机


String customerid=Util.null2String(request.getParameter("customerid"));
String creater=Util.null2String(request.getParameter("creater"));    //被查看人id
String selltypesid=Util.null2String(request.getParameter("selltypesid"));
String sellstatusid=Util.null2String(request.getParameter("sellstatusid"));
String endtatusid=Util.null2String(request.getParameter("endtatusid"));
String includeSubCompany=Util.null2String(request.getParameter("includeSubCompany"));
String subCompanyId=Util.null2String(request.getParameter("subCompanyId"));
String includeSubDepartment=Util.null2String(request.getParameter("includeSubDepartment"));
String departmentId=Util.null2String(request.getParameter("departmentId"));
String preyield=Util.null2String(request.getParameter("preyield"));
String preyield_1=Util.null2String(request.getParameter("preyield_1"));
String datetype=Util.null2String(request.getParameter("datetype"));
String fromdate=Util.null2String(request.getParameter("fromdate"));
String enddate=Util.null2String(request.getParameter("enddate"));
String productId=Util.null2String(request.getParameter("productId"));
String sufactor=Util.null2String(request.getParameter("sufactor"));
String defactor=Util.null2String(request.getParameter("defactor"));

String creater_str = Util.null2String(request.getParameter("creater_str"));
String containsSub = Util.null2String(request.getParameter("containsSub"),"0"); //0为包含下级，1为不包含下级
String sellstatusid_str = Util.null2String(request.getParameter("sellstatusid_str"));
String predate_str = Util.null2String(request.getParameter("predate_str"));
String probability_str = Util.null2String(request.getParameter("probability_str"));
String contactTime_str = Util.null2String(request.getParameter("contactTime_str"));
String preyield_str = Util.null2String(request.getParameter("preyield_str"));
String subject =URLDecoder.decode( Util.null2String(request.getParameter("subject")));
String probability=Util.null2String(request.getParameter("probability"));
String probability_1=Util.null2String(request.getParameter("probability_1"));

SplitPageParaBean sppb = new SplitPageParaBean();
SplitPageUtil spu = new SplitPageUtil();

if(!creater_str.equals("")){
	userid = Util.getIntValue(creater_str);
}
String leftjointable = CrmShareBase.getTempTable(""+userid);

//String backfields="id,name,manager,case when t3.customerid is not null then 1 else 0 end as important";
//String sqlFrom=" CRM_CustomerInfo t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid "+
//			   " left join (select customerid from CRM_Attention where resourceid="+resourceid+") t3 on t1.id=t3.customerid ";
//String sqlWhere=" t1.deleted = 0  and t1.id = t2.relateditemid ";

String  tableString  =  "";
String  backfields  =  "t1.id,t1.subject,t1.creater,t1.predate,t1.preyield,t1.probability,"+
	"	t1.sellstatusid,t1.createdate,t1.createtime,t1.endtatusid,t1.CustomerID ,t3.sellchanceid important";
String  sqlFrom=" CRM_SellChance  t1 left join "+leftjointable+" t2 on t1.customerid = t2.relateditemid"+
				" left join (select sellchanceid from CRM_SellchanceAtt where resourceid="+userid+") t3 on t1.id=t3.sellchanceid left join CRM_CustomerInfo cc on cc.id=t1.customerid";
String  sqlWhere=" t1.customerid = t2.relateditemid and cc.deleted=0 ";

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
if(!"".equals(creater)){
	sqlWhere+=" and t1.creater="+creater;
}
if(!"".equals(subject)){
	sqlWhere+=" and t1.subject like '%"+subject+"%'";
}
if(!"".equals(customerid)){
	sqlWhere+=" and t1.customerid = '"+customerid+"'";
}
if(!"".equals(selltypesid)){
	sqlWhere+=" and t1.selltypesid = '"+selltypesid+"'";
}
if(!"".equals(sellstatusid)){
	sqlWhere+=" and t1.sellstatusid = '"+sellstatusid+"'";
}
if(!"".equals(sellstatusid_str)){
	sqlWhere+=" and t1.sellstatusid = '"+sellstatusid_str+"'";
}
if(!"".equals(endtatusid)){
	sqlWhere+=" and t1.endtatusid = '"+endtatusid+"'";
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
if(!"".equals(preyield_str)){
		switch(Util.getIntValue(preyield_str)){
		case 0:
			preyield_1 = "5";
			break;
		case 1:
			preyield = "5";
			preyield_1 = "10";
			break;
		case 2:
			preyield = "10";
			preyield_1 = "20";
			break;
		case 3:
			preyield = "20";
			preyield_1 = "50";
			break;
		case 4:
			preyield = "50";
			preyield_1 = "100";
			break;
		case 5:
			preyield = "100";
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
if(!"".equals(datetype) && !"6".equals(datetype)){
	sqlWhere += " and t1.predate >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
	sqlWhere += " and t1.predate <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
}
if("6".equals(datetype) && !fromdate.equals("")){
	sqlWhere+=" and t1.predate>='"+fromdate+"'";
}
if("6".equals(datetype) && !enddate.equals("")){
	sqlWhere+=" and t1.predate<='"+enddate+"'";
}
if(!"".equals(predate_str)){
	int year = Util.getIntValue(predate_str.split("-")[0]);
	int month = Util.getIntValue(predate_str.split("-")[1]);
	sqlWhere += " and t1.predate >= '"+TimeUtil.getYearMonthFirstDay(year ,month)+"'";
	sqlWhere += " and t1.predate <= '"+TimeUtil.getYearMonthEndDay(year ,month)+"'";
}

if(!productId.equals("")){
	sqlWhere+=" and t1.id in (select sellchanceid from CRM_ProductTable where productid ="+productId+")";
}

if(!sufactor.equals("")){
	sqlWhere+=" and t1.sufactor="+sufactor;
}

if(!defactor.equals("")){
	sqlWhere+=" and t1.defactor="+defactor;
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
			sqlWhere += " and EXISTS(select tt.createDate from (select createDate from workplan where sellchanceid = t1.id and rownum=1 order by createDate desc)as tt where to_date(tt.createDate,'yyyy-MM-dd') <= to_date('"+UncontactTime+"','yyyy-MM-dd'))";
		}else if(11==Util.getIntValue(contactTime_str)){//无联系记录
			sqlWhere += " and not EXISTS(select createDate from workplan where sellchanceid = t1.id )";
		}
		if(!contactTime.equals("")){
			sqlWhere += " and EXISTS(select tt.createDate from (select createDate from workplan where sellchanceid = t1.id and rownum=1 order by createDate desc)as tt where to_date(tt.createDate,'yyyy-MM-dd') >= to_date('"+contactTime+"','yyyy-MM-dd'))";
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
//System.err.println("sqlWhere :"+sqlWhere);
String orderby="";

int pageindex=Util.getIntValue(request.getParameter("pageindex"),1);
sppb.setBackFields(backfields);
sppb.setSqlFrom(sqlFrom);
sppb.setSqlWhere(" where "+sqlWhere);
sppb.setPrimaryKey("t1.id");
sppb.setSqlOrderBy(orderby);
sppb.setSortWay(sppb.DESC);
spu.setSpp(sppb);
//System.err.println("select "+backfields+" from "+sqlFrom+" where "+ sqlWhere);
RecordSet.execute("select distinct t1.CustomerID from "+sqlFrom+" where "+sqlWhere);
StringBuffer crmIdBuffer = new StringBuffer();
while(RecordSet.next()){
	crmIdBuffer.append(RecordSet.getString("CustomerID")+",");
}
String crmIds = crmIdBuffer.toString();
if(!crmIds.equals("")){
	crmIds = crmIds.substring(0,crmIds.length()-1);
}
int recordCount = spu.getRecordCount();
RecordSet = spu.getCurrentPageRsNew(pageindex,pagesize);
if(recordCount>0){
    while(RecordSet.next()){
    	
    	String sellchanceid=RecordSet.getString("id");
    	String sellchanceName=RecordSet.getString("subject");
    	String manager=RecordSet.getString("creater");
    	String important=RecordSet.getString("important");
    	
 %>
	<tr class="DataLight">
	  <td nowrap style="padding-left: 0px;padding-right: 0px;">
		 <input type="checkbox" id="" value=<%=sellchanceid%> name='check_node'  important="<%=important.equals("")?"0":"1" %>"/>
	  </td>
	  <td  valign="middle"  title="<%=sellchanceName%>" style="word-break:break-all;cursor:pointer;padding-left:5px;" onclick="viewDetail(<%=sellchanceid%>,this)">
	        <%=sellchanceName%>
	  </td>
	  <td style="width:45px;padding-left:5px;white-space:nowrap;overflow: hidden;text-overflow:ellipsis" title="<%=ResourceComInfo.getLastname(manager)%>">
	     <a href="javascript:void(0)" onclick="pointerXY(event);openhrm('<%=manager%>');return false;"><%=ResourceComInfo.getLastname(manager)%></a>
	  </td>
	  <td style="width:18px;padding-left:0px;padding-right:3px;padding-left:3px;">
	     <div class='<%=important.equals("")?"important_no":"important"%>' _important='<%=important.equals("")?"0":"1"%>' _sellchanceid='<%=sellchanceid%>' onclick='markImportant(this)'></div>
	  </td>
	</tr>
 <% 
   }
   out.println("<script>viewDefault('"+crmIds+"')</script>");

   if(pageindex==1){
	  out.println("<script>setTotal("+recordCount+")</script>");
   }
}else{   
%>
  <tr class="DataLight">
  	<td align="center" colspan="4" style="text-align:center;border:0px;"><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage())%></td>
  </tr>	
<%}%>

