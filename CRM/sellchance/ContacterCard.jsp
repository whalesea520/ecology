
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
	String crmIds = Util.null2String(request.getParameter("crmIds"));
	String customerid = Util.null2String(request.getParameter("customerid"));
	
	String datatype = Util.null2String(request.getParameter("datatype"),"1");
	String keyword = Util.null2String(request.getParameter("keyword")); 
	String firstname_str = Util.null2String(request.getParameter("firstname")); 
	String mobilephone_str = Util.null2String(request.getParameter("mobilephone")); 
	String email_str = Util.null2String(request.getParameter("email")); 
	String imcode_str = Util.null2String(request.getParameter("imcode")); 
	
	SplitPageParaBean sppb = new SplitPageParaBean();
	SplitPageUtil spu = new SplitPageUtil();
	
	String backfields="t1.id,t1.firstname,t1.title,t1.phoneoffice,t1.mobilephone,t1.email,t1.jobtitle,t1.department,t1.imcode";
	String sqlFrom="CRM_CustomerContacter t1";
	String sqlWhere="t1.customerid is not null ";
	
	
	//获取我的客户默认联系记录
	if(from.equals("default")){
		backfields += ",t2.contactdate";
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
	
		sqlFrom  = " CRM_CustomerContacter t1,"+
			"(select contacterid,crmid,createdate as contactdate "+
			" from WorkPlan where type_n = '3' "+("".equals(datestr)?"":"and createdate>='"+datestr+"'")+" and contacterid is not null) t2 ";
		sqlWhere=" t1.id=t2.contacterid";
	}
	
	if(!crmIds.equals("")){
		sqlWhere+=" and t1.customerid in ("+crmIds+")";
	}
	if(!customerid.equals("")){
		sqlWhere+=" and t1.customerid in ("+customerid+")";
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
	sppb.setPrimaryKey("t1.id");
	if(from.equals("default")){
		sppb.setSqlOrderBy("contactdate");
	}else{
		sppb.setSqlOrderBy("t1.id");
	}
	sppb.setSortWay(sppb.DESC);
	sppb.setDistinct(true);
	spu.setSpp(sppb);
	
 // System.err.println("select "+backfields+" from "+sqlFrom+" where "+sqlWhere);
	
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
		<col width="48%">
		<col width="48%">
		<col width="4%">
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
				<div class="citem"><%=SystemEnv.getHtmlLabelName(84386,user.getLanguage())%>:<%=email%></div>
				<div class="citem"><%=SystemEnv.getHtmlLabelName(25101,user.getLanguage())%>:<%=imcode%></div>
			</td>
		</tr>
	</table>
</div>
<%}%>
<div id="discusspage" class="kkpager" style="text-align:right;margin-top:8px;padding-right:10px;"></div>
<%}else{%>
<div class="norecord"><%=SystemEnv.getHtmlLabelName(83320,user.getLanguage())%></div>
<%}%>
<br>
</div>

<form id="mainForm">
	<input type="hidden" name="datatype" id="datatype" value="<%=datatype%>"/>
	
	<input type="hidden" name="mobilephone" id="mobilephone" value="<%=mobilephone_str%>"/>
	<input type="hidden" name="email" id="email" value="<%=email_str%>"/>
	<input type="hidden" name="imcode" id="imcode" value="<%=imcode_str%>"/>
	
</form>
</body>
<script>
$(document).ready(function(){
	
	var params=$("#mainForm").serialize();
	
	var pageUrl="/CRM/sellchance/ContacterCard.jsp?crmIds=<%=crmIds%>&keyword=<%=keyword%>&"+params;
	initPageInfo(<%=totalpage%>,<%=pageindex%>,pageUrl);
	
	var height=$(window).height()-30;
	$("#maininfo").height(height);

});

</script>

