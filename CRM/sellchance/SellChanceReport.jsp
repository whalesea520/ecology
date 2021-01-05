
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_count" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs22" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2227,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//add by xwj on 2005-03-25 for TD 1554
RCMenu += "{"+"Excel,javascript:_xtable_getAllExcel(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>


<%
int resource=Util.getIntValue(request.getParameter("viewer"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
String searchName = Util.null2String(request.getParameter("searchName"));
String msg = Util.null2String(request.getParameter("msg"));//report ：报表查看客户信息
int perpage=Util.getPerpageLog();
if(perpage<=1 )	perpage=10;
String resourcename=ResourceComInfo.getResourcename(resource+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String datetype = Util.null2String(request.getParameter("datetype"));

String customer=Util.fromScreen(request.getParameter("customer"),user.getLanguage());
String sellstatusid=Util.fromScreen(request.getParameter("sellstatusid"),user.getLanguage());
String preyield=Util.null2String(request.getParameter("preyield"));
String product=Util.fromScreen(request.getParameter("product"),user.getLanguage());
String preyield_1=Util.null2String(request.getParameter("preyield_1"));
String endtatusid=Util.fromScreen(request.getParameter("endtatusid"),user.getLanguage());
String sufactor=Util.fromScreen(request.getParameter("sufactor"),user.getLanguage());
String defactor=Util.fromScreen(request.getParameter("defactor"),user.getLanguage());
String subCompanyId=Util.fromScreen(request.getParameter("subCompanyId"),user.getLanguage());//客户经理分部ID
String departmentId=Util.fromScreen(request.getParameter("departmentId"),user.getLanguage());//客户经理部门ID
String includeSubCompany=Util.fromScreen(request.getParameter("includeSubCompany"),user.getLanguage());
String includeSubDepartment=Util.fromScreen(request.getParameter("includeSubDepartment"),user.getLanguage());

//added by lupeng 2004.05.21 for TD470.
try {
	Float.parseFloat(preyield);
} catch (NumberFormatException ex) {
	preyield = "";
}

try {
	Float.parseFloat(preyield_1);
} catch (NumberFormatException ex) {
	preyield_1 = "";
}
//end

//out.print(customer);
String sqlwhere="t1.id != 0";
int ViewType = Util.getIntValue(request.getParameter("ViewType"),0);


if(resource!=0){
	sqlwhere+=" and t1.creater="+resource;
}
if(!searchName.equals("")){
	sqlwhere+=" and t1.subject like '%"+searchName+"%'";
}
if(!"".equals(datetype) && !"6".equals(datetype)){
	sqlwhere += " and t1.predate >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
	sqlwhere += " and t1.predate <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
}

if("6".equals(datetype) && !fromdate.equals("")){
	sqlwhere+=" and t1.predate>='"+fromdate+"'";
}
if("6".equals(datetype) && !enddate.equals("")){
	sqlwhere+=" and t1.predate<='"+enddate+"'";
}


if(!sufactor.equals("")){
	sqlwhere+=" and t1.sufactor="+sufactor;
}

if(!defactor.equals("")){
	sqlwhere+=" and t1.defactor="+defactor;
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
		
		sqlwhere+=" and (select subcompanyid1 from HrmDepartment where id =  (select departmentid from HrmResource where id=t1.creater)) in "+subCompanyIds;
		
	}else if(includeSubCompany.equals("3")){
		String subCompanyIds = subCompanyId;
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubCompanyLists(subCompanyId,list);
		for(int i=0;i<list.size();i++){
			subCompanyIds += ","+(String)list.get(i);
		}
		subCompanyIds = "("+subCompanyIds+")";

		sqlwhere+=" and (select subcompanyid1 from HrmDepartment where id =  (select departmentid from HrmResource where id=t1.creater)) in "+subCompanyIds;
	}else{
		sqlwhere+=" and (select subcompanyid1 from HrmDepartment where id =  (select departmentid from HrmResource where id=t1.creater)) = "+subCompanyId;
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

		sqlwhere+=" and (select departmentid from HrmResource where id=t1.creater) in "+departmentIds;
	}else if(includeSubDepartment.equals("3")){
		String departmentIds = departmentId;
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubDepartmentLists(departmentId,list);
		for(int i=0;i<list.size();i++){
			departmentIds += ","+(String)list.get(i);
		}
		departmentIds = "("+departmentIds+")";

		sqlwhere+=" and (select departmentid from HrmResource where id=t1.creater) in "+departmentIds;		
	}else{
		sqlwhere+=" and (select departmentid from HrmResource where id=t1.creater) = "+departmentId;
	}
}
if(!customer.equals("")){
	sqlwhere+=" and t1.customerid="+customer;
}

if(!sellstatusid.equals("")){
	sqlwhere+=" and t1.sellstatusid="+sellstatusid;
}
if(!preyield.equals("")){
	sqlwhere+=" and t1.preyield>="+preyield;
}
if(!preyield_1.equals("")){
	sqlwhere+=" and t1.preyield<="+preyield_1;
}
if(!endtatusid.equals("")&&!endtatusid.equals("4")){
	sqlwhere+=" and t1.endtatusid ="+endtatusid;
}

String sellchanceid="";
if(!product.equals("")){
    String sql_P="select sellchanceid from CRM_ProductTable where productid ="+product;
    rs22.executeSql(sql_P);
    while(rs22.next()){
    	sellchanceid += ","+rs22.getString("sellchanceid");
    }
    if(!sellchanceid.equals("")){
        sellchanceid = sellchanceid.substring(1); 
        sqlwhere+=" and t1.id in("+sellchanceid+")";
    }
    else{//此产品没有客户，则就什么销售机会都没有
        sqlwhere+=" and t1.id < 0";
    }
}
/*
if(user.getLogintype().equals("2")){
	sqlwhere+=" and  t1.agentid!='' and  t1.agentid!='0'";
}
*/
String sqlstr = "";

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

session.setAttribute("sqlwhere",sqlwhere);

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<BODY> 

<%if("report".equals(msg)){ %>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="customer"/>
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(2227,user.getLanguage()) %>"/>
	</jsp:include>
<%} %>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="_xtable_getAllExcel()" type="button"  value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage()) %>"/>
			<!--  input type="text" class="searchInput"  id="searchName"  value=""/>-->
			<%if(!"report".equals(msg)){ %>
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;overflow: auto" >	
<form id=weaver name=frmmain method=post action="SellChanceReport.jsp">
<input type=hidden id=pagenum name=pagenum value="<%=pagenum%>">
<input type="hidden" name="searchName" value="<%=searchName %>">
<wea:layout type="4Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
		<%if(!user.getLogintype().equals("2")){%>
			<wea:item ><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="viewer" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			         browserValue='<%=resource+""%>' 
			         browserSpanValue = '<%=Util.toScreen(resourcename,user.getLanguage())%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp" width="150px" ></brow:browser>
			</wea:item>
		<%}%>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="subCompanyId" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
			         browserValue='<%=subCompanyId%>' 
			         browserSpanValue = '<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subCompanyId),user.getLanguage())%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=164" width="150px" ></brow:browser>
			<select class=InputStyle name="includeSubCompany">
				<option value="1" <%if(includeSubCompany.equals("1")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
				<option value="2" <%if(includeSubCompany.equals("2")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18920,user.getLanguage())%></option>
				<option value="3" <%if(includeSubCompany.equals("3")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18921,user.getLanguage())%></option>
			</select>
		</wea:item>
	
		
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="departmentId" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
			         browserValue='<%=departmentId%>' 
			         browserSpanValue = '<%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentId),user.getLanguage())%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=4" width="150px" ></brow:browser>
			<select class=InputStyle name="includeSubDepartment">
				<option value="1" <%if(includeSubDepartment.equals("1")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
				<option value="2" <%if(includeSubDepartment.equals("2")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18917,user.getLanguage())%></option>
				<option value="3" <%if(includeSubDepartment.equals("3")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18918,user.getLanguage())%></option>
			</select>
		</wea:item>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%>  </wea:item>
		<wea:item>
			<INPUT text class=InputStyle maxLength=20 size=6 id="preyield" name="preyield"    onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield");comparenumber()' value="<%=preyield%>" style="width: 120px">
			-
			<INPUT text class=InputStyle maxLength=20 size=6 id="preyield_1" name="preyield_1"   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1");comparenumber()' value="<%=preyield_1%>" style="width: 120px">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%> </wea:item>
		<wea:item>
			<select text class=InputStyle id=sellstatusid name=sellstatusid>
			  <option value="" <%if(sellstatusid.equals("")){%> selected<%}%> ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				<%  
				String theid="";
				String thename="";
				String sql="select * from CRM_SellStatus ";
				RecordSetM.executeSql(sql);
				while(RecordSetM.next()){
				    theid = RecordSetM.getString("id");
				    thename = RecordSetM.getString("fullname");
				    if(!thename.equals("")){
					%>
					<option value=<%=theid%>  <%if(sellstatusid.equals(theid)){%> selected<%}%> ><%=thename%></option>
					<%}
				}%>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%></wea:item>
		<wea:item>
			<select text class=InputStyle id=endtatusid  name=endtatusid>
				<option value=4 <%if(endtatusid.equals("4")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%> </option>
				<option value=1 <%if(endtatusid.equals("1")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%> </option>
				<option value=2 <%if(endtatusid.equals("2")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%> </option>
				<option value=0 <%if(endtatusid.equals("0")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%> </option>
			</select>
		</wea:item>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="customer" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
			         browserValue='<%=customer%>' 
			         browserSpanValue = '<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customer),user.getLanguage())%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=7" width="150px" ></brow:browser>
		</wea:item>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(2247,user.getLanguage())%></wea:item>
		<wea:item>
			<span>
	        	<SELECT  name="datetype" id="datetype" onchange="onChangetype(this)" style="width: 100px;">
				  <option value="" 	<%if(datetype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="1" <%if(datetype.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
				  <option value="2" <%if(datetype.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
				  <option value="3" <%if(datetype.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
				  <option value="4" <%if(datetype.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
				  <option value="5" <%if(datetype.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
				  <option value="6" <%if(datetype.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
				</SELECT>     
			</span>
        
        	<span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
				<BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
				<SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
				<input type="hidden" name="fromdate" value=<%=fromdate%>>
				－
				<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
				<SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
				<input type="hidden" name="enddate" value=<%=enddate%>>  
			</span>
		</wea:item>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="product" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp"
			         browserValue='<%=product%>' 
			         browserSpanValue = '<%=Util.toScreen(AssetComInfo.getAssetName(product),user.getLanguage())%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=product" width="150px" ></brow:browser>
		</wea:item>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(15103,user.getLanguage())%> </wea:item>
		<wea:item>
			<select text class=InputStyle id=sufactor name=sufactor>
			  <option value="" <%if(sufactor.equals("")){%> selected<%}%> ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				<%  
				String theid_s="";
				String thename_s="";
				String sql_s="select * from CRM_Successfactor ";
				RecordSetM.executeSql(sql_s);
				while(RecordSetM.next()){
				    theid_s = RecordSetM.getString("id");
				    thename_s = RecordSetM.getString("fullname");
				    if(!thename_s.equals("")){
				    %>
					<option value=<%=theid_s%>  <%if(sufactor.equals(theid_s)){%> selected<%}%> ><%=thename_s%></option>
					<%}
				}%>
			</select>
		</wea:item>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(15104,user.getLanguage())%> </wea:item>
		<wea:item>
			<select text class=InputStyle id=defactor  name=defactor>
			  <option value="" <%if(defactor.equals("")){%> selected<%}%> ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				<%  
				String theid_d="";
				String thename_d="";
				String sql_d="select * from CRM_Failfactor ";
				RecordSetM.executeSql(sql_d);
				while(RecordSetM.next()){
				    theid_d = RecordSetM.getString("id");
				    thename_d = RecordSetM.getString("fullname");
				    if(!thename_d.equals("")){
				    %>
					<option value=<%=theid_d%>  <%if(defactor.equals(theid_d)){%> selected<%}%> ><%=thename_d%></option>
					<%}
				}%>
			</select>
		</wea:item>
    
	</wea:group>
	
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="搜索" id="searchBtn"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="重置" class="e8_btn_cancel"  onclick="resetCondition()"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="取消" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</div>

<%
	String  tableString  =  "";
	String  backfields  =  "t1.id,t1.subject,t1.predate,t1.preyield,t1.probability,t1.sellstatusid,t1.createdate,t1.endtatusid,t1.CustomerID,t1.creater,t4.departmentid,t3.manager,t3.department ";     
	String  fromSql=" CRM_SellChance  t1 left join HrmResource t4 on t1.creater = t4.id ,"+leftjointable+" t2,CRM_CustomerInfo t3 ";
	String   sqlmei=" and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.relateditemid";
	String linkstr = "";
	linkstr = "/CRM/data/ViewCustomer.jsp";
	String orderby  =  "";
	if(!sqlwhere.equals("")){
		sqlwhere += sqlmei;
	}
    tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pageId=\""+PageIdConst.CRM_RPSellChance+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_RPSellChance,user.getUID(),PageIdConst.CRM)+"\" >"+
		 "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlorderby=\""+orderby+"\" sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"  sqlisdistinct=\"true\"  />"+
	 	"<head>";
	tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" column=\"id\"  linkkey=\"t1.subject\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getCRMNamecont\" otherpara=\"column:customerid+column:subject\" orderkey=\"t1.subject\" />";
	tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(2247,user.getLanguage())+"\" column=\"predate\" orderkey=\"t1.predate\" />";
    tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(2248,user.getLanguage())+"\"  column=\"preyield\" orderkey=\"t1.preyield\"/>";
    tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(2249,user.getLanguage())+"\" column=\"probability\" orderkey=\"t1.probability\" transmethod=\"\"/>";
    tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate\" transmethod=\"\"/>";
    tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(2250,user.getLanguage())+"\" column=\"sellstatusid\" orderkey=\"t1.sellstatusid\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getCRMSellStatus\"/>";
    tableString+="<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(15112,user.getLanguage())+"\" column=\"endtatusid\" orderkey=\"t1.endtatusid\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getPigeonholeStatus\" otherpara=\""+user.getLanguage()+"\"/>";
	tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(136,user.getLanguage())+"\" href=\""+linkstr+"\" linkkey=\"CustomerID\" column=\"customerid\" orderkey=\"t1.customerid\" transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\" />";
    tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(1278,user.getLanguage())+"\" column=\"creater\"   transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" orderkey=\"t1.creater\" />";
    tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15390,user.getLanguage())+"\" column=\"departmentid\"   transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentmark\" orderkey=\"t4.departmentid\" />";
    tableString+="</head>";
    tableString+="</table>";
     %>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_RPSellChance%>">
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>

<iframe id="searchexport" style="display:none"></iframe>

<%if("report".equals(msg)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout>
			<wea:group context="" attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<%} %>
</body>


<SCRIPT language="javascript">
function OnSubmit(pagenum){
        document.frmmain.pagenum.value = pagenum;
		document.frmmain.submit();
}

function comparenumber() {
    if ((document.frmmain.preyield.value != "") && (document.frmmain.preyield_1.value != "")) {
		lownumber = eval(toFloat(document.all("preyield").value,0));
		highnumber = eval(toFloat(document.all("preyield_1").value,0));		

		if (lownumber > highnumber) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15243,user.getLanguage())%>！");			
		}		
	}	
}

function onChangetype(obj){
	if(obj.value == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
}

function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}

$(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:searchInfo});
	jQuery("#hoverBtnSpan").hoverBtn();
	if("<%=datetype%>" == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
});

function searchInfo(){
	 // alert(jQuery("#searchName").val());
	 jQuery("input[name='searchName']").val(jQuery("#searchName").val());
	 window.frmmain.submit();
}
function ContractExport(){
     _xtable_getAllExcel();
}
</script>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
