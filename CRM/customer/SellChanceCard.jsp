
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.Maint.CustomerContacterComInfo"%>
<%@page import="weaver.crm.Maint.ContacterTitleComInfo"%>
<%@page import="weaver.crm.report.CRMContractTransMethod"%>
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
<jsp:useBean id="CRMContractTransMethod" class="weaver.crm.report.CRMContractTransMethod" scope="page"/>
<jsp:useBean id="CustomerService" class="weaver.crm.customer.CustomerService" scope="page" />
<%
	String customerid = Util.null2String(request.getParameter("customerid"));
%>
<script type="text/javascript" src="/cowork/js/kkpager/kkpager_wev8.js"></script>
<link rel="stylesheet" href="/cowork/js/kkpager/kkpager_wev8.css" type="text/css"/>

<link rel="stylesheet" href="/CRM/css/Base_wev8.css" type="text/css"/>

<script type="text/javascript" src="/CRM/js/customerUtil_wev8.js"></script>

<body style="background-color:#F9F9F9">

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
	String preyield_0 = Util.null2String(request.getParameter("preyield")); 
	String preyield_1 = Util.null2String(request.getParameter("preyield_1")); 
	String sellstatusid = Util.null2String(request.getParameter("sellstatusid")); 
	String endtatusid_0 = Util.null2String(request.getParameter("endtatusid")); 

	String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
	String  backfields  =  "t1.id,t1.subject,t1.predate,t1.preyield,t1.probability,t1.sellstatusid,t1.createdate,t1.createtime,t1.endtatusid,t1.CustomerID,defactor,sufactor ";     
	String  sqlFrom=" CRM_SellChance  t1,"+leftjointable+" t2,CRM_CustomerInfo t3 ";
	String  sqlWhere=" t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.relateditemid and customerid="+customerid;
	
	//获取我的客户默认联系记录
	if(from.equals("default")){
		
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
		
		
		sqlFrom  = " CRM_SellChance t1,("+sqlstr+searchstr+") t2 ";
		sqlWhere="  t1.customerid= t2.cutomerid";
		
	}
	
	
	if(!"".equals(keyword)){
		sqlWhere+=" and t1.subject like '%"+keyword+"%'";
	}
	if (!preyield_0.equals("")) {
		sqlWhere += " and t1.preyield >= '" + preyield_0 + "'";
	}

	if (!preyield_1.equals("")) {
		sqlWhere += " and t1.preyield <= '" + preyield_1 + "'";
	}
	if (!endtatusid_0.equals("") && !endtatusid_0.equals("4")) {
		sqlWhere += " and t1.endtatusid = '" + endtatusid_0 + "'";
	}

	if (!sellstatusid.equals("")) {
		sqlWhere += " and t1.sellstatusid = '" + sellstatusid + "'";
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
	
	if(!"".equals(datestr)&&from.equals("default")){
		sqlWhere+=" and t1.createdate>='"+datestr+"'";
	}	
	
	SplitPageParaBean sppb = new SplitPageParaBean();
	SplitPageUtil spu = new SplitPageUtil();
	
	sppb.setBackFields(backfields);
	sppb.setSqlFrom(sqlFrom);
	sppb.setSqlWhere(" where "+sqlWhere);
	sppb.setPrimaryKey("t1.id");
	sppb.setSqlOrderBy("t1.id");
	sppb.setSortWay(sppb.DESC);
	spu.setSpp(sppb);

	int pagesize=10;
	int pageindex = Util.getIntValue(request.getParameter("pageindex"),1);
	int recordCount = spu.getRecordCount();
	rs = spu.getCurrentPageRsNew(pageindex,pagesize);
	
	int totalpage = recordCount / pagesize;
	if(recordCount - totalpage * pagesize > 0) totalpage = totalpage + 1;
	
	if(rs.getCounts()>0){
		while(rs.next()){
			String sellchanceid=rs.getString("id");
			String subject=rs.getString("subject"); //商机名称
			String predate=rs.getString("predate"); //销售预期
			String preyield=rs.getString("preyield"); //预期收益
			String probability=rs.getString("probability"); //可能性
			String createdate=rs.getString("createdate"); //创建日期
			String sellstatus=CRMContractTransMethod.getCRMSellStatus(rs.getString("sellstatusid")); //销售状态
			String endtatusid=CRMContractTransMethod.getPigeonholeStatus(rs.getString("endtatusid"),user.getLanguage()+""); //归档状态
			String defactor=CRMContractTransMethod.getCrmFailfactorName(rs.getString("defactor")); //失败因素
			String sufactor=CRMContractTransMethod.getCrmSuccessfactorName(rs.getString("sufactor")); //失败因素
		    
			
%>
<div class="contacter" style="padding:0px;">
	<div style="background:#f4f7fb;padding-left:5px;">
		<table style="width:100%" cellpadding="0" cellspacing="0">
			<col width="30%">
			<col width="35%">
			<col width="35%">
			<tr style="height:30px;">
				<td style="background:#f4f7fb;padding-left:5px;">
					<span class="cname" onclick="openFullWindowHaveBar('/CRM/sellchance/ViewSellChanceTab.jsp?id=<%=sellchanceid%>')">
						<%=subject%>
					</span>
				</td>
				<td style="background:#f4f7fb" colspan="2" align="right">
					<span title="<%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%>">
						<img src="/CRM/images/icon_profit_wev8.png" align="absmiddle">&nbsp;<span class="fcolor"><%=preyield%></span>
					</span>
					<span title="创建时间" style="margin-right:10px;margin-left:10px;">
						<img src="/CRM/images/icon_data_wev8.png" align="absmiddle">&nbsp;<%=createdate%>
					</span>
				</td>
			</tr>
		</table>
	</div>
	<table style="width:100%" cellpadding="0" cellspacing="0">
		<col width="30%">
		<col width="35%">
		<col width="35%">
		<tr>
			<td style="padding-left:10px;">
				<div class="citem"><%=SystemEnv.getHtmlLabelName(2247,user.getLanguage())%>:<span class="fcolor"><%=predate%></span></div>
				<div class="citem"><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%>:<%=sellstatus%></div>
			</td>
			<td>
				<div class="citem"><%=SystemEnv.getHtmlLabelName(25006,user.getLanguage())%>:<span class="fcolor"><%=probability%></span></div>
				<div class="citem"><%=SystemEnv.getHtmlLabelName(15103,user.getLanguage())%>:<%=sufactor%></div>
			</td>
			<td colspan="2">
				<div class="citem"><%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%>:<span class="fcolor"><%=endtatusid%></span></div>
				<div class="citem"><%=SystemEnv.getHtmlLabelName(15104,user.getLanguage())%>:<%=defactor%></div>
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
	
	<input type="hidden" name="preyield" id="preyield" value="<%=preyield_0%>"/>
	<input type="hidden" name="preyield_1" id="preyield_1" value="<%=preyield_1%>"/>
	<input type="hidden" name="sellstatusid" id="sellstatusid" value="<%=sellstatusid%>"/>
	<input type="hidden" name="endtatusid" id="endtatusid" value="<%=endtatusid_0%>"/>
	
</form>


</body>
<script>
$(document).ready(function(){
	var params=$("#mainForm").serialize();
	
	var pageUrl="/CRM/customer/SellChanceCard.jsp?customerid=<%=customerid%>&keyword=<%=keyword%>&"+params;
	initPageInfo(<%=totalpage%>,<%=pageindex%>,pageUrl);
	
	var height=$(window).height()-20;
	$("#maininfo").height(height);

});

</script>


