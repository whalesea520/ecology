
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%>
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
<BODY> 
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//add by xwj on 2005-03-25 for TD 1554
RCMenu += "{"+"Excel,javascript:ContractExport(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%
String operation = Util.null2String(request.getParameter("operation"));
String chanceid = Util.null2String(request.getParameter("chanceid"));
String chanceids = Util.null2String(request.getParameter("chanceids"));
if("delete".equals(operation)){
	rs.executeProc("CRM_SellChance_Delete",chanceid);
    rs.executeProc("CRM_Product_Delete",chanceid);
}

if("batch".equals(operation)){

	chanceids = chanceids.substring(0,chanceids.length()-1);
	
	rs.execute("delete CRM_SellChance WHERE id in ("+chanceids+")");
	rs.execute("delete CRM_ProductTable WHERE sellchanceid in ("+chanceids+")");
}

String selectType = Util.null2String(request.getParameter("selectType"));//all 查询所有；process 查询进行中；expire 到期提醒
int resource=Util.getIntValue(request.getParameter("viewer"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
if(perpage<=1 )	perpage=10;
String resourcename=ResourceComInfo.getResourcename(resource+"");

String datetype = Util.null2String(request.getParameter("datetype"));
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());

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
String subject = Util.fromScreen(request.getParameter("subject"),user.getLanguage());

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

String sqlwhere="t1.id != 0 " ;;

if(resource!=0){
	sqlwhere+=" and t3.manager="+resource;
}

if(!"".equals(datetype) && !"6".equals(datetype)){
	sqlwhere += " and t1.predate >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
	sqlwhere += " and t1.predate <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
}

if(!fromdate.equals("")){
	sqlwhere+=" and t1.predate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	sqlwhere+=" and t1.predate<='"+enddate+"'";
}
if(!subject.equals("")){
	sqlwhere+=" and t1.subject like '%"+subject+"%'";
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
		
		sqlwhere+=" and t1.subCompanyId in "+subCompanyIds;
		
	}else if(includeSubCompany.equals("3")){
		String subCompanyIds = subCompanyId;
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubCompanyLists(subCompanyId,list);
		for(int i=0;i<list.size();i++){
			subCompanyIds += ","+(String)list.get(i);
		}
		subCompanyIds = "("+subCompanyIds+")";

		sqlwhere+=" and t1.subCompanyId in "+subCompanyIds;
	}else{
		sqlwhere+=" and t1.subCompanyId="+subCompanyId;
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

		sqlwhere+=" and t1.departmentId in "+departmentIds;
	}else if(includeSubDepartment.equals("3")){
		String departmentIds = departmentId;
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubDepartmentLists(departmentId,list);
		for(int i=0;i<list.size();i++){
			departmentIds += ","+(String)list.get(i);
		}
		departmentIds = "("+departmentIds+")";

		sqlwhere+=" and t1.departmentId in "+departmentIds;		
	}else{
		sqlwhere+=" and t1.departmentId="+departmentId;
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

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

session.setAttribute("sqlwhere",sqlwhere);
%>


<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="deleteInfos()" type="button"  value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
			<input type="text" class="searchInput"  id="searchSubject" name="searchSubject" value="<%=subject%>" onchange="searchSubject()"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<!-- 高级搜索 -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >	
<form id=weaver name=frmmain method=post action="/CRM/sellchance/SellChanceReportDetail.jsp?selectType=<%=selectType %>">
<input type=hidden id=pagenum name=pagenum value="<%=pagenum%>">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="customer" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
			         browserValue='<%=customer%>' 
			         browserSpanValue = '<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customer),user.getLanguage())%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=7" width="174px" ></brow:browser> 
		</wea:item>
		
		<%if(!user.getLogintype().equals("2")){%>
		<wea:item ><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="viewer" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			         browserValue='<%=resource+""%>' 
			         browserSpanValue = '<%=Util.toScreen(resourcename,user.getLanguage())%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp" width="174px" ></brow:browser> 
		</wea:item>
		<%}%>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%> </wea:item>
		<wea:item>
			<select text style="width: 120px;" class=InputStyle id=sellstatusid name=sellstatusid>
				
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
			</select>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%></wea:item>
		<wea:item>
			<select text style="width: 120px;" class=InputStyle id=endtatusid  name=endtatusid>
				<option value=4 <%if(endtatusid.equals("4")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%> </option>
				<option value=1 <%if(endtatusid.equals("1")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%> </option>
				<option value=2 <%if(endtatusid.equals("2")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%> </option>
				<option value=0 <%if(endtatusid.equals("0")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%> </option>
			</select>
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>' attributes="{'itemAreaDisplay':'none'}" >
		<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
		<wea:item>
			<span style="margin-right: 10px;">
				<select style="width: 120px;" class=InputStyle name="includeSubCompany" style="width: 100px;padding-left: 10px;">
					<option value="1" <%if(includeSubCompany.equals("1")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
					<option value="2" <%if(includeSubCompany.equals("2")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18920,user.getLanguage())%></option>
					<option value="3" <%if(includeSubCompany.equals("3")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18921,user.getLanguage())%></option>
				</select>
			</span>
			
			<span>
				<brow:browser viewType="0" name="subCompanyId" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
				         browserValue='<%=subCompanyId+""%>' 
				         browserSpanValue = '<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subCompanyId),user.getLanguage())%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				         completeUrl="/data.jsp?type=164" width="174px" ></brow:browser> 
			</span>
			
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		<wea:item>
			<span style="margin-right: 10px;">
				<select class=InputStyle style="width: 120px;" name="includeSubDepartment" style="width: 100px;padding-left: 10px;">
					<option value="1" <%if(includeSubDepartment.equals("1")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
					<option value="2" <%if(includeSubDepartment.equals("2")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18917,user.getLanguage())%></option>
					<option value="3" <%if(includeSubDepartment.equals("3")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18918,user.getLanguage())%></option>
				</select>
			</span>
			
			<span>
				<brow:browser viewType="0" name="departmentId" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
				         browserValue='<%=departmentId+""%>' 
				         browserSpanValue = '<%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentId),user.getLanguage())%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				         completeUrl="/data.jsp?type=4" width="174px" ></brow:browser> 
			</span>        
			
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%>  </wea:item>
		<wea:item>
			<INPUT  class=InputStyle maxLength=20 size=6 id="preyield" name="preyield" style="width: 100px;"   onKeyPress="ItemNum_KeyPress()" 
				onBlur='checknumber("preyield");comparenumber()' value="<%=preyield%>">
			-- <INPUT  class=InputStyle maxLength=20 size=6 id="preyield_1" name="preyield_1" style="width: 100px;"   onKeyPress="ItemNum_KeyPress()" 
			onBlur='checknumber("preyield_1");comparenumber()' value="<%=preyield_1%>">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="product" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp"
			         browserValue='<%=product%>' 
			         browserSpanValue = '<%=Util.toScreen(AssetComInfo.getAssetName(product),user.getLanguage())%>'
			         isSingle="true" hasBrowser="true"  hasInput="false" isMustInput='1'
			         completeUrl="/data.jsp" width="174px" ></brow:browser>
			         
		</wea:item >
		
		<wea:item><%=SystemEnv.getHtmlLabelName(15103,user.getLanguage())%> </wea:item>
		<wea:item>
			<select text style="width: 120px;" class=InputStyle id=sufactor name=sufactor>
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
			<select text style="width: 120px;" class=InputStyle id=defactor name=defactor>
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
		
		<wea:item><%=SystemEnv.getHtmlLabelName(2247,user.getLanguage())%></wea:item>
        <wea:item>
	         <span>
	        	<SELECT  id="datetype" name="datetype" onchange="onChangetype(this)" style="width: 120px;">
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
				<BUTTON type="button" class=calendar id=Selecwea:itemate onclick=getfromDate()></BUTTON>&nbsp;
				<SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
				<input type="hidden" name="fromdate" value=<%=fromdate%>>
				－&nbsp;<BUTTON type="button" class=calendar id=Selecwea:itemate onclick=getendDate()></BUTTON>&nbsp;
				<SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
				<input type="hidden" name="enddate" value=<%=enddate%>>  
			</span>
		</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="searchBtn"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>	
</form>
</div>


<%
  	String  tableString  =  "";
  	String  backfields  =  "t1.id,t1.subject,t1.predate,t1.preyield,t1.probability,t1.sellstatusid,t1.createdate,t1.createtime,t1.endtatusid,t1.CustomerID ";     
   	String  fromSql=" CRM_SellChance  t1,"+leftjointable+" t2,CRM_CustomerInfo t3 ";
    String  sqlmei=" and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.relateditemid ";
	String linkstr = "";
	linkstr = "/CRM/data/ViewCustomer.jsp";
  	String orderby  =  "t1.createdate,t1.createtime";
  	String ordertype = "ASC";
  	if(!sqlwhere.equals("")){
  		sqlwhere += sqlmei;
  	}
  			
  	if("process".equals(selectType)){
  		sqlwhere +=" and t1.endtatusid = 0";
  		ordertype = "DESC";
  	}
  			
  	if("expire".equals(selectType)){
  		String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
  		if(rs.getDBType().equals("oracle")){
  			sqlwhere +=" and t1.endtatusid = 0 and t1.createdate||' '||t1.createtime <= '"+date+"'";
  		}else{
  			sqlwhere +=" and t1.endtatusid = 0 and t1.createdate +' '+t1.createtime <= '"+date+"'";
  		}
  				
  	}
  	String operateString= "<operates width=\"15%\">";
  	operateString+=" <popedom transmethod=\"weaver.crm.sellchance.SellChangeRoprtTransMethod.getSellPopedom\"  otherpara=\"column:endtatusid+column:customerid+"+user.getUID()+"\"></popedom> ";
  	operateString+="     <operate  href=\"javascript:openInfo()\" otherpara=\"column:customerid\" text=\""+SystemEnv.getHtmlLabelName(360,user.getLanguage())+"\"   index=\"0\"/>";
  	operateString+="     <operate  href=\"javascript:editInfo()\" otherpara=\"column:customerid\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_fullwindow\"  index=\"1\"/>";
  	operateString+="     <operate  href=\"javascript:deleteInfo()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>";
  	operateString+="     <operate  href=\"javascript:contactInfo()\" otherpara=\"column:customerid\" text=\""+SystemEnv.getHtmlLabelName(15153,user.getLanguage())+"\" target=\"_self\"  index=\"3\"/>";
  	operateString+="</operates>";
    tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pageId=\""+PageIdConst.CRM_Sellchance+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_Sellchance,user.getUID(),PageIdConst.CRM)+"\" >"+
  				"<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlorderby=\""+orderby+"\" sqlprimarykey=\"t1.id\" sqlsortway=\""+ordertype+"\"  sqlisdistinct=\"true\"  />"+
  				"<checkboxpopedom showmethod=\"weaver.crm.sellchance.SellChangeRoprtTransMethod.getSellCheckInfo\" popedompara=\"column:endtatusid+column:customerid+"+user.getUID()+"\"  />"+
  				"<head>";
  	tableString+=" <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" column=\"id\" orderkey=\"subject\" otherpara=\"column:subject\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getCRMSellSubject\"/>";
    tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(2247,user.getLanguage())+"\" column=\"predate\" orderkey=\"t1.predate\" />";
    tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(2248,user.getLanguage())+"\"  column=\"preyield\" orderkey=\"t1.preyield\"/>";
    tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(2249,user.getLanguage())+"\" column=\"probability\" orderkey=\"t1.probability\" transmethod=\"\"/>";
    tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate\" transmethod=\"\"/>";
    tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(2250,user.getLanguage())+"\" column=\"sellstatusid\" orderkey=\"t1.sellstatusid\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getCRMSellStatus\"/>";
    tableString+="<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(15112,user.getLanguage())+"\" column=\"endtatusid\" orderkey=\"t1.endtatusid\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getPigeonholeStatus\" otherpara=\""+user.getLanguage()+"\"/>";
	tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(136,user.getLanguage())+"\" href=\""+linkstr+"\" linkkey=\"CustomerID\" column=\"customerid\" orderkey=\"t1.customerid\" transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\" />";
    tableString+="</head>";
    tableString+=operateString+"</table>";
 %>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_Sellchance%>">
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
		

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
			alert("<%=SystemEnv.getHtmlLabelName(15243,user.getLanguage())%>！");			
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

function openInfo(id ,customerid ){
	var url="/CRM/sellchance/SellChanceOperation.jsp?chanceid="+id+"&method=reopen&customer="+customerid;
	openFullWindowHaveBar(url);
}

var diag = null;
function callback(){
	if(diag)
		diag.close();
	_table.reLoad();
}
function closeDialog(){
	if(diag)
		diag.close();
	_table.reLoad();
}
function editInfo(id , customerid){
	
	diag = getDialog("<%=SystemEnv.getHtmlLabelNames("93,2227",user.getLanguage())%>",800,600);
	diag.URL="/CRM/sellchance/EditSellChance.jsp?CustomerID="+customerid+"&chanceid="+id;
	diag.ShowButtonRow=false;
	diag.show();
	document.body.click();
}

function deleteInfo(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
		jQuery.post("/CRM/sellchance/SellChanceOperation.jsp",{"chanceid":id,"method":"del"},function(){
			_table.reLoad();
		});
		
	});
}

function deleteInfos(){
	var chanceids = _xtable_CheckedCheckboxId();
	if("" == chanceids){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");  
		return;
	}

	jQuery.post("/CRM/sellchance/SellChanceReportNew.jsp",{"chanceids":chanceids,"operation":"batch"});
	_table.reLoad();
}
function contactInfo(id ,customerid){
	
	diag = getDialog("<%=SystemEnv.getHtmlLabelNames("367,15153",user.getLanguage())%>",800,600);
	diag.URL="/CRM/sellchance/ViewSellChanceMessage.jsp?id="+id;
	diag.ShowButtonRow=false;
	diag.show();
	document.body.click();
}

function showInfo(id){
	diag = getDialog("<%=SystemEnv.getHtmlLabelNames("367,2227",user.getLanguage())%>",800,600);
	diag.URL="/CRM/sellchance/ViewSellChance.jsp?isfromtab=false&id="+id;
	diag.ShowButtonRow=false;
	diag.show();
	document.body.click();

}

$(document).ready(function(){
			
	jQuery("#topTitle").topMenuTitle({searchFn:null});
	jQuery("#hoverBtnSpan").hoverBtn();
	
	if("<%=datetype%>" == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}		
});

function getDialog(title,width,height){
    diag =new window.top.Dialog();
    diag.currentWindow = window; 
    diag.Modal = true;
    diag.Drag=true;
	diag.Width =width?width:800;
	diag.Height =height?height:600;
	diag.ShowButtonRow=true;
	diag.Title = title;
	return diag;
} 
</script>
<!-- modified by xwj 2005-03-25 for TD 1554 -->
<iframe id="searchexport" style="display:none"></iframe>
<script language=javascript>
function ContractExport(){
     _xtable_getAllExcel();
}

function searchSubject(){
	var searchSubject = jQuery("#searchSubject").val();
	window.frmmain.action = "/CRM/sellchance/SellChanceReportDetail.jsp?selectType=<%=selectType %>&subject="+searchSubject;
	window.frmmain.submit();
}
</script>

</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
