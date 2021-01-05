
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.crm.customer.CustomerService"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CoworkTransMethod" class="weaver.general.CoworkTransMethod" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerService" class="weaver.crm.customer.CustomerService" scope="page" />
<%
int userid=user.getUID();

int index=Util.getIntValue(request.getParameter("index"));                 //下标 
int pagesize=Util.getIntValue(request.getParameter("pagesize"));           //每一次取多少

String labelid=Util.null2String(request.getParameter("labelid"),"my");       //标签id my我的客户，all全部客户，attention关注客户
String resourceid=Util.null2String(request.getParameter("resourceid"),""+userid);    //被查看人id
String viewtype=Util.null2String(request.getParameter("viewtype"),"0");              //查看类型 0仅本人，1包含下属，2仅下属

String sector=Util.null2String(request.getParameter("sector"));
String status=Util.null2String(request.getParameter("status"));

String name =URLDecoder.decode( Util.null2String(request.getParameter("name")));

SplitPageParaBean sppb = new SplitPageParaBean();
SplitPageUtil spu = new SplitPageUtil();

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
		if(!subResourceid.equals(""))
			sqlWhere+=" and (t1.manager="+resourceid+" or t1.manager in("+subResourceid+"))";
	}else if(viewtype.equals("2")){ //仅下属
		String subResourceid=CustomerService.getSubResourceid(resourceid); //所有下属
		if(!subResourceid.equals(""))
			sqlWhere+=" and t1.manager in("+subResourceid+")";
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

String orderby="";

int pageindex=Util.getIntValue(request.getParameter("pageindex"),1);

sppb.setBackFields(backfields);
sppb.setSqlFrom(sqlFrom);
sppb.setSqlWhere(" where "+sqlWhere);
sppb.setPrimaryKey("id");
sppb.setSqlOrderBy(orderby);
sppb.setSortWay(sppb.DESC);
spu.setSpp(sppb);

int recordCount = spu.getRecordCount();
RecordSet2 = spu.getCurrentPageRsNew(pageindex,pagesize);
%>

<%
if(recordCount>0){
    while(RecordSet2.next()){
    	
    	String customerid=RecordSet2.getString("id");
    	String customerName=RecordSet2.getString("name");
    	String manager=RecordSet2.getString("manager");
    	String important=RecordSet2.getString("important");
    	
 %>
	<tr class="DataLight">
	  <td nowrap style="padding-left: 0px;padding-right: 0px;">
		 <input type="checkbox" id="" value=<%=customerid%> name='check_node'  important="<%=important %>"/>
	  </td>
	  <td  valign="middle"  title="<%=customerName%>" style="word-break:break-all;cursor:pointer;padding-left:5px;" onclick="viewDetail(<%=customerid%>,this)">
	        <%=customerName%>
	  </td>
	  <td style="width:45px;padding-left:5px;white-space:nowrap;overflow: hidden;text-overflow:ellipsis" title="<%=ResourceComInfo.getLastname(manager)%>">
	     <a href="javascript:void(0)" onclick="pointerXY(event);openhrm('<%=manager%>');return false;"><%=ResourceComInfo.getLastname(manager)%></a>
	  </td>
	  <td style="width:18px;padding-left:0px;padding-right:3px;padding-left:3px;">
	     <div class='<%=important.equals("1")?"important":"important_no"%>' _important='<%=important%>' _customerid='<%=customerid%>' onclick='markImportant(this)'></div>
	  </td>
	</tr>
 <% 
   }
   if(pageindex==1){
	  out.println("<script>setTotal("+recordCount+")</script>");
   }
}else{   
%>
  <tr class="DataLight">
  	<td align="center" colspan="4" style="text-align:center;border:0px;"><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage())%></td>
  </tr>	
<%}%>

