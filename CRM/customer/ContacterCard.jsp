
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.Maint.CustomerContacterComInfo"%>
<%@page import="weaver.crm.Maint.ContacterTitleComInfo"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page"/>
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page"/>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page"/>
<jsp:useBean id="CustomerService" class="weaver.crm.customer.CustomerService" scope="page" />
<%
	String customerid = Util.null2String(request.getParameter("customerid"));
%>
<script type="text/javascript" src="/cowork/js/kkpager/kkpager_wev8.js"></script>
<link rel="stylesheet" href="/cowork/js/kkpager/kkpager_wev8.css" type="text/css"/>

<link rel="stylesheet" href="/CRM/css/Base_wev8.css" type="text/css"/>

<script type="text/javascript" src="/CRM/js/customerUtil_wev8.js"></script>

<style>
.contacter{
	padding:8px;border:1px solid #DADADA;
	border-left:2px solid #dadada;
	background-color:#fff;
	color:#929393;
	margin:10px;
	font-size:12px;
}
.contacter .cname{
	color:#0D93F6;font-weight:bold;margin-right:5px;font-size:16px;
	cursor:pointer;
}
.contacter .cline{
	border-bottom: 1px solid #dadada
}
.contacter .citem{
	height:30px;line-height:30px;color:#000
}

</style>
<body style="background-color:#F9F9F9;">
<div id="maininfo" class="scroll1" style="overflow: auto;">
<%
	String userid=""+user.getUID();
	String from=Util.null2String(request.getParameter("from"));

	String labelid=Util.null2String(request.getParameter("labelid"),"my");       //标签id my我的客户，all全部客户，attention关注客户
	String resourceid=Util.null2String(request.getParameter("resourceid"),""+userid);    //被查看人id
	String viewtype=Util.null2String(request.getParameter("viewtype"),"0");              //查看类型 0仅本人，1包含下属，2仅下属
	String sector=Util.null2String(request.getParameter("sector")); //行业
	String status=Util.null2String(request.getParameter("status")); //状态
	String name =URLDecoder.decode( Util.null2String(request.getParameter("name"))); //名称
	String datatype = Util.null2String(request.getParameter("datatype"),"1");

	String keyword = Util.null2String(request.getParameter("keyword")); 
	String firstname_str = Util.null2String(request.getParameter("firstname")); 
	String mobilephone_str = Util.null2String(request.getParameter("mobilephone")); 
	String email_str = Util.null2String(request.getParameter("email")); 
	String imcode_str = Util.null2String(request.getParameter("imcode")); 
	
	SplitPageParaBean sppb = new SplitPageParaBean();
	SplitPageUtil spu = new SplitPageUtil();
	
	String backfields="id,firstname,title,phoneoffice,mobilephone,email,jobtitle,department,imcode";
	if(from.equals("default"))
		backfields+=",contactdate";
	String sqlFrom=" CRM_CustomerContacter ";
	String sqlWhere=" customerid="+customerid;
	
	
	//获取我的客户默认联系记录
	if(from.equals("default")){
		
		String leftjointable = CrmShareBase.getTempTable(""+userid);
		String sqlstr="select id as cutomerid,manager from CRM_CustomerInfo t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid ";
		
		String searchstr=" where t1.deleted = 0  and t1.id = t2.relateditemid ";
		if(labelid.equals("my")){  //我的客户
			if(viewtype.equals("0")){ //仅本人客户
				searchstr+=" and t1.manager="+resourceid;
			}else if(viewtype.equals("1")){ //包含下属
				String subResourceid=CustomerService.getSubResourceid(resourceid); //所有下属
				if(!subResourceid.equals(""))
					searchstr+=" and (t1.manager="+resourceid+" or t1.manager in("+subResourceid+"))";
			}else if(viewtype.equals("2")){ //仅下属
				String subResourceid=CustomerService.getSubResourceid(resourceid); //所有下属
				if(!subResourceid.equals(""))
					searchstr+=" and t1.manager in("+subResourceid+")";
			}
		}else if(labelid.equals("attention")){ //关注客户
			sqlstr+=" left join (select customerid from CRM_Attention where resourceid="+resourceid+") t3 on t1.id=t3.customerid ";
			searchstr+=" and t1.id=t3.customerid";
		}else if(labelid.equals("new")){       //新客户
			sqlstr+=" left join CRM_ViewLog2 t5 on t1.id=t5.customerid ";
			searchstr+=" and t1.id=t5.customerid and t1.manager="+userid;
		}else if(!labelid.equals("all")){
			sqlstr+=" left join (select customerid from CRM_Customer_label where labelid="+labelid+") t4 on t1.id=t4.customerid";
			searchstr+=" and t1.id=t4.customerid ";
		}
		
		if(!"".equals(status)){
			searchstr+=" and t1.status="+status;
		}
		if(!"".equals(sector)){
			searchstr+=" and t1.sector="+sector;
		}
		
		
		String datestr="";
		String currentdate=TimeUtil.getCurrentDateString();
		if(datatype.equals("1"))
			datestr=TimeUtil.dateAdd(currentdate,-30);
		else if(datatype.equals("2"))
			datestr=TimeUtil.dateAdd(currentdate,-90);	
		else if(datatype.equals("3"))
			datestr=TimeUtil.dateAdd(currentdate,-180);
		else if(datatype.equals("4"))
			datestr=TimeUtil.dateAdd(currentdate,-365);
		
		sqlFrom  = " CRM_CustomerContacter t3,("+sqlstr+searchstr+") t2,(select contacterid,crmid,createdate as contactdate from WorkPlan where type_n = '3' and contacterid is not null "+("".equals(datestr)?"":"and createdate>='"+datestr+"'")+" ) t1 ";
		sqlWhere=" t3.customerid=t2.cutomerid and t1.crmid=CAST(t2.cutomerid as varchar(10)) and t3.id=t1.contacterid ";
		
	}
	
	
	if(!"".equals(keyword)){
		sqlWhere+=" and firstname like '%"+keyword+"%'";
	}
	if(!"".equals(mobilephone_str)){
		sqlWhere+=" and mobilephone like '%"+mobilephone_str+"%'";
	}
	if(!"".equals(email_str)){
		sqlWhere+=" and email like '%"+email_str+"%'";
	}
	if(!"".equals(imcode_str)){
		sqlWhere+=" and imcode like '%"+imcode_str+"%'";
	}
	sppb.setBackFields(backfields);
	sppb.setSqlFrom(sqlFrom);
	sppb.setSqlWhere(" where "+sqlWhere);
	sppb.setPrimaryKey("id");
	if(from.equals("default"))
		sppb.setSqlOrderBy("contactdate");
	sppb.setSortWay(sppb.DESC);
	sppb.setDistinct(true);
	spu.setSpp(sppb);
	
	int pagesize=10;
	int pageindex = Util.getIntValue(request.getParameter("pageindex"),1);
	int recordCount = spu.getRecordCount();
	rs = spu.getCurrentPageRs(pageindex,pagesize);
	
	int totalpage = recordCount / pagesize;
	if(recordCount - totalpage * pagesize > 0) totalpage = totalpage + 1;

	if(rs.getCounts()>0){
		int index=0;
		while(rs.next()){
			String contacterid=rs.getString("id");
			String firstname=rs.getString("firstname");
			String titleName=ContacterTitleComInfo.getContacterTitlename(rs.getString("title"));
			String jobtitle=rs.getString("jobtitle");
			String department=rs.getString("department");
			String mobilephone=rs.getString("mobilephone");
			String phoneoffice=rs.getString("phoneoffice");
			String email=rs.getString("email");
			String imcode=rs.getString("imcode");
			
			index++;
%>
<div class="contacter" style="<%=index==1?"border-left-color:#0D93F6":""%>">
	<table style="width:100%" cellpadding="0" cellspacing="0">
		<col width="40%">
		<col width="50%">
		<col width="10%">
		<tr style="height:30px;">
			<td class="cline">
				<span class="cname" onclick="openFullWindowHaveBar('/CRM/contacter/ContacterView.jsp?ContacterID=<%=contacterid%>')"><%=firstname%></span><%=titleName%>
			</td>
			<td class="cline">
				<img src="/CRM/images/icon_org_wev8.png" align="top">&nbsp;<span><%=jobtitle%><%=department.equals("")?"":"/"+department%></span>
			</td>
			<td class="cline" align="right" style="cursor:pointer;" title="<%=SystemEnv.getHtmlLabelName(84283,user.getLanguage())%>" onclick="openFullWindowHaveBar('/CRM/contacter/ContacterView.jsp?ContacterID=<%=contacterid%>&tabid=trail')">
				<img src="/CRM/images/icon_trail_wev8.png" align="absmiddle">
			</td>
		</tr>
		<tr>
			<td>
				<div class="citem"><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%>:<%=mobilephone%></div>
				<div class="citem"><%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%>:<%=phoneoffice%></div>
			</td>
			<td colspan="2">
				<div class="citem"><%=SystemEnv.getHtmlLabelName(20869,user.getLanguage())%>:<%=email%></div>
				<div class="citem"><%=SystemEnv.getHtmlLabelName(25101,user.getLanguage())%>:<%=imcode%></div>
			</td>
		</tr>
	</table>
</div>
<%}%>
<div id="discusspage" class="kkpager" style="text-align:right;margin-top:8px;padding-right:10px;"></div>
<%}else{%>
<div class="norecord"><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage())%></div>
<%}%>
<br>
</div>

<form id="mainForm">
	<input type="hidden" name="labelid" id="labelid" value="<%=labelid%>"/>
	<input type="hidden" name="resourceid" id="resourceid" value="<%=resourceid%>"/>
	<input type="hidden" name="viewtype" id="viewtype" value="<%=viewtype%>"/>
	<input type="hidden" name="sector" id="sector" value="<%=sector%>"/>
	<input type="hidden" name="status" id="status" value="<%=status%>"/>
	<input type="hidden" name="datatype" id="datatype" value="<%=datatype%>"/>
	<input type="hidden" name="from" id="from" value="<%=from%>"/>
	
	<input type="hidden" name="mobilephone" id="mobilephone" value="<%=mobilephone_str%>"/>
	<input type="hidden" name="email" id="email" value="<%=email_str%>"/>
	<input type="hidden" name="imcode" id="imcode" value="<%=imcode_str%>"/>
	
</form>


</body>
<script>
$(document).ready(function(){
	
	var params=$("#mainForm").serialize();
	
	var pageUrl="/CRM/customer/ContacterCard.jsp?customerid=<%=customerid%>&keyword=<%=keyword%>&"+params;
	initPageInfo(<%=totalpage%>,<%=pageindex%>,pageUrl);
	
	var height=$(window).height()-30;
	$("#maininfo").height(height);

});

</script>


