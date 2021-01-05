
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetP" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page" />
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<jsp:useBean id="ContacterShareBase" class="weaver.crm.ContacterShareBase" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
String CustomerID = request.getParameter("CustomerID");
String contractId = request.getParameter("id");
String isrequest = Util.null2String(request.getParameter("isrequest"));
String isfromtab  = Util.null2String(request.getParameter("isfromtab"),"false");
String needRefresh  = Util.null2String(request.getParameter("needRefresh"),"false");//编辑页面跳转过来，是否需要刷新主页面

int msg = Util.getIntValue(request.getParameter("msg"),0);
CustomerID = ContractComInfo.getContractcrmid(contractId);
int rownum=0;
int rownum1=0;
String needcheck="before";

String useridcheck=""+user.getUID();

boolean canview=false;
boolean canedit=false;
boolean canappove=true;
boolean isdelete = false;
int sharelevel = ContacterShareBase.getRightLevelForContacter(user.getUID()+"" , contractId);
if(sharelevel > 0 ){
	 canview=true;
	 if(sharelevel == 2){
		canedit=true;	
		isdelete=true;
	 }else if (sharelevel == 3 || sharelevel == 4){
		canedit=true;
		isdelete=true;
	 }
}

String sql = "select * from bill_crmcontract where contractid="+contractId;
RecordSetV.executeSql(sql);
if(RecordSetV.next()){
	canappove = false;
}
if(!canview && isrequest.equals("1")){
	//RecordSetV.executeSql("insert into ContractShareDetail (contractid,userid,usertype,sharelevel) values ("+contractId+","+user.getUID()+",1,1)");
	RecordSetV.executeSql("insert into Contract_ShareInfo (relateditemid,sharetype,seclevel,seclevelMax,rolelevel, sharelevel,userid,departmentid,subcompanyid,roleid,foralluser,isdefault)"+
			" values ("+contractId+",1,0,0,0,1,"+user.getUID()+",0,0,0,0,0)");
	canview = true;
}


if (!canview) response.sendRedirect("/notice/noright.jsp") ;
/*check right end*/

RecordSet.executeProc("CRM_Contract_SelectById",contractId);
RecordSet.next();

if(RecordSet.getInt("status")==0&&!canappove) canappove = true;
if(RecordSet.getInt("status")==-1) canappove = false;
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage()) + SystemEnv.getHtmlLabelName(367,user.getLanguage())+" : " + "<a href =/CRM/data/ViewCustomer.jsp?CustomerID=" + CustomerID + ">" +  Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(CustomerID),user.getLanguage()) + "</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<!-- status:0为提交，1为审批结束状态,2为签单,3为执行完成,增加一个新的状态：-1，用来表示审批进行中状态-->
<%if (canedit && RecordSet.getInt("status")==0) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='/CRM/data/ContractEdit.jsp?isfromtab="+isfromtab+"&CustomerID="+CustomerID+"&contractId="+contractId+"',_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>

<%if (canedit && (RecordSet.getInt("status")==0)&& canappove) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15143,user.getLanguage())+",javascript:location='/CRM/data/ContractOperation.jsp?method=approve&isfromtab="+isfromtab+"&crmId="+CustomerID+"&contractId="+contractId+"',_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>

<%if (canedit && (RecordSet.getInt("status")==1)) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(6095,user.getLanguage())+",javascript:location='/CRM/data/ContractOperation.jsp?method=isCustomerCheck&isfromtab="+isfromtab+"&crmId="+CustomerID+"&contractId="+contractId+"',_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>

<%if (canedit && (RecordSet.getInt("status")==2)) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15144,user.getLanguage())+",javascript:location='/CRM/data/ContractOperation.jsp?method=isSuccess&isfromtab="+isfromtab+"&crmId="+CustomerID+"&contractId="+contractId+"',_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>

<%if(canedit && RecordSet.getInt("status")>=1){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+",javascript:location='/CRM/data/ContractOperation.jsp?method=reopen&isfromtab="+isfromtab+"&crmId="+CustomerID+"&contractId="+contractId+"',_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
<%if(isdelete&&RecordSet.getInt("status")==0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:delContract("+contractId+","+CustomerID+"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;   
}%>
<%if(canedit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(2112,user.getLanguage())+",javascript:addShare("+contractId+","+CustomerID+"),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}%>


<%if(isfromtab.equals("false")){ %>  
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(34244,user.getLanguage()) %>"/>
</jsp:include>
<%} %>

<%if (canedit && RecordSet.getInt("status")==0) {%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input class="e8_btn_top middle" onclick="javascript:location.href='/CRM/data/ContractEdit.jsp?isfromtab=<%=isfromtab %>&CustomerID=<%=CustomerID %>&contractId=<%=contractId%>'" type="button"  value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%}%>

<div class="zDialog_div_content" style="height:497px;">
<FORM id=weaver name=weaver action="/CRM/data/ContractOperation.jsp" method=post  >
<input id="savePart" name="savePart" type="hidden">
<input type="hidden" name="method" value="view">
<input type="hidden" name="contractId" value="<%=contractId%>">
<input type="hidden" name="crmId" value="<%=CustomerID%>">
<input type="hidden" name="ProjID" value="<%=RecordSet.getString("projid")%>">
<input type="hidden" name="name" value="<%=RecordSet.getString("name")%>">
<input type="hidden" name="isfromtab"  value="<%=isfromtab %>">
<%if (msg==1) {%>
	<span style="color:red"><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16248,user.getLanguage())%>!</span>
<%}
if (msg==-1) {%>
	<span style="color:red"><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15173,user.getLanguage())%>!</span>
<%}%>


<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(6083,user.getLanguage())%></wea:item>
		<wea:item> <%=Util.toScreen(ContractTypeComInfo.getContractTypename(RecordSet.getString("TypeId")),user.getLanguage())%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(1265,user.getLanguage())%></wea:item>
		<wea:item> 
			<%if(!RecordSet.getString("docId").equals("")){
			ArrayList arrayDocids = Util.TokenizerString(RecordSet.getString("docId"),",");
			for(int i=0;i<arrayDocids.size();i++){
			%>
			<A href='/docs/docs/DocDsp.jsp?id=<%=""+arrayDocids.get(i)%>'><%=DocComInfo.getDocname(""+arrayDocids.get(i))%></a>&nbsp
			<%}}%>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(534,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(RecordSet.getString("price"),user.getLanguage())%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></wea:item>
		<wea:item>
			<a href="/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=RecordSet.getString("crmId")%>">
			<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("crmId")),user.getLanguage())%></a>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></wea:item>
		<wea:item>
			<a href='/CRM/data/ViewContacter.jsp?log=n&ContacterID=<%=RecordSet.getString("contacterId")%>'> 
			<%=Util.toScreen(CustomerContacterComInfo.getCustomerContacternameByID(RecordSet.getString("contacterId")),user.getLanguage())%></a>
		</wea:item>
		
		<%
		String sellChanceIdSpanTemp = "";
		String sellChanceId = "";
		String sellChanceId2 = Util.toScreen(RecordSet.getString("sellChanceId"),user.getLanguage());
		if(!sellChanceId2.equals("")){
			String sellChanceName = "";
			RecordSet2.executeSql("select subject from CRM_SellChance where id="+sellChanceId2);
			if(RecordSet2.next()){
				sellChanceName = RecordSet2.getString("subject");
				sellChanceIdSpanTemp = "<A href='/CRM/sellchance/ViewSellChance.jsp?id="+sellChanceId2+"'>"+sellChanceName+"</A>";
			}
		}
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(2227,user.getLanguage())%></wea:item>
		<wea:item>
			<span id=sellChanceIdSpan><%=sellChanceIdSpanTemp%></span>
			<INPUT class=InputStyle type=hidden name="sellChanceId" value="<%=sellChanceId%>">
		</wea:item>
		
		<%
		RecordSetC.executeProc("CRM_CustomerInfo_SelectByID",RecordSet.getString("crmId")); 
		RecordSetC.next();
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(6097,user.getLanguage())%></wea:item>
		<wea:item><%=RecordSetC.getString("CreditAmount")%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		<wea:item>
		<%
		String statusStr = "";
		switch (RecordSet.getInt("status"))
		{
		case 0 : statusStr=SystemEnv.getHtmlLabelName(615,user.getLanguage()); break;
		case -1 : statusStr=SystemEnv.getHtmlLabelName(2242,user.getLanguage()); break;
		case 1 : statusStr=SystemEnv.getHtmlLabelName(1423,user.getLanguage()); break;
		case 2 : statusStr=SystemEnv.getHtmlLabelName(6095,user.getLanguage()); break;
		case 3 : statusStr=SystemEnv.getHtmlLabelName(555,user.getLanguage()); break;
		default: break;
		}
		%>
		<%=statusStr%>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></wea:item>
		<wea:item><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("manager")%>" target="_blank">		 
			<%= Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%></a>
		</wea:item>
		
		<input type="hidden" name = "manager" value="<%=RecordSet.getString("manager")%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></wea:item>
		<wea:item> <%=Util.toScreen(RecordSet.getString("startDate"),user.getLanguage())%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
		<wea:item> <%=Util.toScreen(RecordSet.getString("endDate"),user.getLanguage())%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></wea:item>
		<wea:item>
			<A href="/proj/data/ViewProject.jsp?ProjID=<%=RecordSet.getString("projid")%>">
			<%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(RecordSet.getString("projid")),user.getLanguage())%></a>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(6078,user.getLanguage())%></wea:item>
		<wea:item>
		<%if (RecordSet.getInt("status")==2 && canedit) {%>
		<INPUT type=checkbox name="isremind"  value=0 <% if (RecordSet.getInt("isRemind") == 0) {%>checked<%}%> onclick="changeDiv()">
		<%} else {
		if (RecordSet.getInt("isRemind") == 0) {%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%} 
		else 
		{%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
		<%}%>
		</wea:item>
		
		<%if (RecordSet.getInt("isRemind") == 0) {%>
			<wea:item><%=SystemEnv.getHtmlLabelName(6077,user.getLanguage())%></wea:item>
			<wea:item>
				<%if (RecordSet.getInt("status")==2 && canedit) {%>
				<INPUT class=InputStyle maxLength=2 size=10 name="before" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("before")' onchange='checkinput("before","beforeimage")' value = "<%=RecordSet.getString("remindDay")%>" ><SPAN id=beforeimage></SPAN>
				<%} else {%>
				<%=Util.toScreen(RecordSet.getString("remindDay"),user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
				<%}%>
			</wea:item>
		<%} %>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(6098,user.getLanguage())%></wea:item>
		<wea:item><%=RecordSetC.getString("CreditTime")%></wea:item>
	
	</wea:group>
	
	<%
		int colNumber=10;
		if (RecordSet.getInt("status")>=2) {
		    colNumber=14;
		}else{
		    colNumber=10;
		}
	%>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%>'>
		<%
		RecordSetP.executeProc("CRM_ContractProduct_Select",contractId);
		if (canedit && (RecordSet.getInt("status")==2) && RecordSetP.getCounts() != 0 ) {%>
		<wea:item type="groupHead">
			<input type="button" class="e8_btn" onclick="doSave(2)" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/>
		</wea:item>
		<%} %>
		
		<wea:item attributes="{'isTableList':'true'}">
			<TABLE class=ListStyle cellspacing=1  cols="<%=colNumber%>" id="oTable">
				<input type="hidden" name = "proId" >
				<input type="hidden" name = "proInfoId" >
				<input type="hidden" name = "proFactNum" >
				<input type="hidden" name = "proFactDate" >
				<input type="hidden" name = "proFormNum" >
			
				<tr class=header>
					<td class=Field>&nbsp;</td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(649,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(15130,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(1050,user.getLanguage())%></td>
					<%if (RecordSet.getInt("status")>=2) {%>
						<td class=Field><%=SystemEnv.getHtmlLabelName(15465,user.getLanguage())%></td>
						<td class=Field><%=SystemEnv.getHtmlLabelName(15145,user.getLanguage())%></td>
						<td class=Field><%=SystemEnv.getHtmlLabelName(15146,user.getLanguage())%></td>
						<td class=Field><%=SystemEnv.getHtmlLabelName(15147,user.getLanguage())%></td>
					<%}%>
					<td class=Field><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())%></td>
				</tr>
				
				<%
				int i=0;
				
				while (RecordSetP.next()) {%>
				<tr>
		           <td >&nbsp;<input type="hidden" name = "productId_<%=i%>" value="<%=RecordSetP.getString("id")%>"></td>
		    	   <td ><a href = "/lgc/asset/LgcAsset.jsp?paraid=<%=RecordSetP.getString("productId")%>"><%=Util.toScreen(AssetComInfo.getAssetName(RecordSetP.getString("productId")),user.getLanguage())%></a></td>
		    	   <td ><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(RecordSetP.getString("unitId")),user.getLanguage())%></td>
		    	   <td ><%=Util.toScreen(CurrencyComInfo.getCurrencyname(RecordSetP.getString("currencyId")),user.getLanguage())%></td>
		    	   <td ><%=RecordSetP.getString("price")%></td>
				   <td ><%=RecordSetP.getString("depreciation")%>%</td>
		           <td ><%=RecordSetP.getString("number_n")%></td>
		    	   <td ><%=RecordSetP.getString("sumPrice")%></td>
				   <td ><%=RecordSetP.getString("planDate")%></td>
				<%if (RecordSet.getInt("status") == 2 && canedit) {%>
	
					<td >
						<input type=text  name="productFormNum_<%=i%>" size=9 class="InputStyle">	
					</td>
					<td >
						<input type=text  name="productFactNumber_<%=i%>" onKeyPress='ItemNum_KeyPress()' onBlur="checknumber1(this)" size=9 value="0" class="InputStyle">
					</td>
					<td>
						<BUTTON type=button class=Calendar onclick='onShowDate1("productFactDatespan_<%=i%>","productFactDate_<%=i%>")'></BUTTON> <SPAN id="productFactDatespan_<%=i%>"><%=RecordSetP.getString("factDate")%></SPAN> <input type="hidden" name = "productFactDate_<%=i%>" value="<%=RecordSetP.getString("factDate")%>">
					</td>
					<td>
						<INPUT type=checkbox name="productisFinish_<%=i%>"  value=0 <% if (RecordSetP.getInt("isFinish") == 0) {%>checked<%}%>>
					</td>
				<%} else if (RecordSet.getInt("status") >= 2){%>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>
						<%if (RecordSetP.getInt("isFinish") == 0) {%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
					</td>
				<%}%>
	
			   	<td>
				<%if (RecordSet.getInt("status")==2 && canedit) {%>
					<INPUT type=checkbox name="productisRemind_<%=i%>"  value="0" <% if (RecordSetP.getInt("isRemind") == 0) {%>checked<%}%>>
				<%}else {
						if (RecordSetP.getInt("isRemind") == 0) {%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>	
				<%}%>
				</td>
	    	</tr>
	    	
			<!--加入发货记录-->
			
			<%//发货记录
			String proId= RecordSetP.getString("id");
			rs1.executeProc("CRM_ContractProInfo_Select",proId);
			int k=0;
			while(rs1.next()){  
				String proInfoId= rs1.getString("id");
				k++;
			%>
				<tr>
				<%if (RecordSet.getInt("status")==2 && canedit) {%>
					<td >&nbsp;<input type="hidden" name = "proid_<%=proId%>_<%=k%>" value="<%=proInfoId%>"></td>  
					<td align=right colspan=8><img border=0 src="/images/ArrowRightBlue_wev8.gif"></img>
					</td>
					<td>
						<input type=text  name="proFormNum_<%=proId%>_<%=k%>" size=9 value="<%=Util.toScreen(rs1.getString("formNum"),user.getLanguage())%>" class="InputStyle">
					</td>
					<td>
						<input type=text  name="proFactNum_<%=proId%>_<%=k%>" onKeyPress='ItemNum_KeyPress()' onBlur="checknumber1(this)" size=9 value="<%=Util.toScreen(rs1.getString("factNum"),user.getLanguage())%>" class="InputStyle">
					</td>
					<td>
						<BUTTON type=button class=Calendar onclick='onShowDate1("proFactDateSpan_<%=proId%>_<%=k%>","proFactDate_<%=proId%>_<%=k%>")'></BUTTON> <SPAN id="proFactDateSpan_<%=proId%>_<%=k%>"><%=rs1.getString("factDate")%></SPAN> <input type="hidden" name = "proFactDate_<%=proId%>_<%=k%>" value="<%=rs1.getString("factDate")%>">
					</td>
					<td  colspan=2>
						<a href='javascript: doSave_1("<%=proId%>","<%=k%>","<%=proInfoId%>")'><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a>&nbsp
						<a href='javascript: doDel_1("<%=RecordSet.getString("projid") %>","<%=proInfoId%>","<%=proId%>")'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
					</td>
	
					<%}else if (RecordSet.getInt("status") >= 2){%>
						<td >&nbsp;</td>                
						<td align=right colspan=8><img border=0 src="/images/ArrowRightBlue_wev8.gif"></img></td>
						<td><%=rs1.getString("formNum")%></td>
						<td><%=rs1.getString("factNum")%></td>
						<td><%=rs1.getString("factDate")%></td>            
						<td >&nbsp</td>
						<td >&nbsp</td>
					<%}%>
				</tr>  	
			<%}%> 
			
			<%if (RecordSet.getInt("status") >= 2){%>
				<tr>	
					<td colspan=9>&nbsp;</td>			
					<td align=left style="color:red">
					<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>
					</td>
					<td align=left style="color:red" colspan=4onShowMDoc>
					<%=RecordSetP.getString("factnumber_n")%>
					</td>
				</tr>
			<%}%>
	
			<%
			i++;	
			}
			rownum = RecordSetP.getCounts();
			%>
			<input type="hidden" name="rownum" value="<%=rownum%>"> 
			</TABLE>
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15131,user.getLanguage())%>'>
		<%
		RecordSetM.executeProc("CRM_ContractPayMethod_Select",contractId);
		if (canedit && (RecordSet.getInt("status")==2) && RecordSetM.getCounts() !=0 ) {%>
		<wea:item type="groupHead">	
			<input type="button" class="e8_btn" onclick="doSave(3)" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/>
		</wea:item>
		<%} %>
		<wea:item attributes="{'isTableList':'true'}">
			<input type="hidden" name = "PayInfoId" >
			<input type="hidden" name = "pay_id" >
			<input type="hidden" name = "paytrueprice" >
			<input type="hidden" name = "paytrueday" >
			<input type="hidden" name = "payFormNum" >
			
			
			<%
				if (RecordSet.getInt("status")>=2) {
				    colNumber=13;
				}else{
				    colNumber=10;
				}
			%>
   		<TABLE class=ListStyle cellspacing=1  cols="<%if (RecordSet.getInt("status")>=2) {%>13<%} else {%>8<%}%>" id="mTable">
       
		<%if (RecordSet.getInt("status")>=2) {%>
		    <COLGROUP>
		    <COL width=1%>
		    <COL width=9%>
		    <COL width=9%>
		    <COL width=9%>
		    <COL width=10%>
		    <COL width=10%>
		    <COL width=9%>
		    <COL width=7%>
		    <COL width=6%>
		    <COL width=9%>
		    <COL width=9%>
		    <COL width=7%>
			<COL width=5%>
		<%}else{%>
			<col width="5%">
			<col width="15%">
			<col width="10%">
			<col width="15%">
			<col width="15%">
			<col width="10%">
			<col width="15%">
			<col width="10%">
		<%} %>  
		<tr class=header>
           <td class=Field>&nbsp;</td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15132,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15133,user.getLanguage())%></td>
           <td class=Field><%=SystemEnv.getHtmlLabelName(1462,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15134,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15135,user.getLanguage())%></td>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(15136,user.getLanguage())%></td>
		   <%if (RecordSet.getInt("status")>=2) {%>
           <td class=Field><%=SystemEnv.getHtmlLabelName(1811,user.getLanguage())%></td>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(15465,user.getLanguage())%></td>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(15149,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15150,user.getLanguage())%></td>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(15147,user.getLanguage())%></td>
		   <%}%>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())%></td>
    	</tr>
		<%
			int j=0;
			
			while (RecordSetM.next()) {
		%>
			<tr>
			<td >&nbsp;<input type="hidden" name = "paymethodId_<%=j%>" value="<%=RecordSetM.getString("id")%>"></td>
			<td ><%=RecordSetM.getString("prjName")%></td>
			<td ><% if (RecordSetM.getInt("typeId") == 1) {%><%=SystemEnv.getHtmlLabelName(15137,user.getLanguage())%><%} else {%><%=SystemEnv.getHtmlLabelName(15138,user.getLanguage())%><%}%></td>
			<td ><%=Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(RecordSetM.getString("feetypeid")),user.getLanguage())%></td>
			<td ><%=RecordSetM.getString("payPrice")%></td>
			<td ><%=RecordSetM.getString("payDate")%></td>
			<td ><%=RecordSetM.getString("qualification")%></td>

            <%
            double price_cc= Util.getDoubleValue(RecordSetM.getString("factPrice"),0);
            double sum = Util.getDoubleValue(RecordSetM.getString("payPrice"));
            double remainsum = sum - price_cc;    
            //如果金额巨大，机器用科学计数法的，要把它转化为String
            String SS=""+remainsum; 
            %>
						
			
			<%if (RecordSet.getInt("status")==2 && canedit) {%>
                <td><%if(SS.indexOf("E") != -1){ //modify TD2084 by xys%>
                    		<%=Util.getPointValue(Util.getfloatToString(""+remainsum))%>
                    <%}else{%>
                    		<%=Util.getPointValue(""+remainsum)%>
                    <%}%>
                </td>

				<td ><input type=text  name="paymethodFormNum_<%=j%>" size=7></td>
				<td >
					<input type=text  name="paymethodFactPrice_<%=j%>" onKeyPress='ItemNum_KeyPress()' 
						onBlur="checknumber1(this)" size=7 value="0.00">	
				</td>
				<td>
					<BUTTON type=button class=Calendar onclick='onShowDate1("paymethodFactDatespan_<%=j%>","paymethodFactDate_<%=j%>")'></BUTTON> <SPAN id="paymethodFactDatespan_<%=j%>"></SPAN> <input type="hidden" name = "paymethodFactDate_<%=j%>" value="">
				</td>
				<td>
					<INPUT type=checkbox name="paymethodisFinish_<%=j%>"  value=0 width=5% 
						<% if (RecordSetM.getInt("isFinish") == 0) {%>checked<%}%>>
				</td>

			<%} else if (RecordSet.getInt("status") >= 2){%>
                <td>
                	<%if(SS.indexOf("E") != -1){ //modify TD2084 by xys%>
                    		<%=Util.getPointValue(Util.getfloatToString(""+remainsum))%>
                    <%}else{%>
                    		<%=Util.getPointValue(""+remainsum)%>
                    <%}%>
                </td>
				<td >&nbsp;</td>
				<td >&nbsp;</td>
				<td >&nbsp;</td>
				</td>
				<td>
					<%if (RecordSetM.getInt("isFinish") == 0) {%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
				</td>

			<%}%>
           <td >
				<%if (RecordSet.getInt("status")==2 && canedit) {%>
					<INPUT type=checkbox name="paymethodisRemind_<%=j%>"  value=0 <% if (RecordSetM.getInt("isRemind") == 0) {%>checked<%}%>>
				<%} else {	
					 if (RecordSetM.getInt("isRemind") == 0) {%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
				<%}%>
			</td>

	    <%//先查看该付款有否记录
	    String payid= RecordSetM.getString("id");
	    rs.executeProc("CRM_PayInfo_SelectAll",payid);
	    int k=0;
	    if(rs.getCounts()>0){
	        while(rs.next()){    
	            String PayInfoId= rs.getString("id");
	    %>
   		<tr id="paytr_<%=PayInfoId%>">
        <%if (RecordSet.getInt("status")==2 && canedit) {%>
            <td >&nbsp;<input type="hidden" name = "payid_<%=payid%>_<%=k%>" value="<%=PayInfoId%>"></td>  
            <td align=right colspan=7><img border=0 src="/images/ArrowRightBlue_wev8.gif"></img>
            </td>
			<td>
                <input type=text  name="payFormNum_<%=payid%>_<%=k%>" size=7 value="<%=rs.getString("formNum")%>">
			</td>
            <td>
                <input type=text  name="trueprice_<%=payid%>_<%=k%>" onKeyPress='ItemNum_KeyPress()' onBlur="checknumber1(this)" size=7 value="<%=rs.getString("factprice")%>"></td>
            <td>
                <BUTTON type=button class=Calendar onclick='onShowDate1("tureDatespan_<%=payid%>_<%=k%>","tureDate_<%=payid%>_<%=k%>")'></BUTTON> <SPAN id="tureDatespan_<%=payid%>_<%=k%>"><%=rs.getString("factdate")%></SPAN> <input type="hidden" name = "tureDate_<%=payid%>_<%=k%>" value="<%=rs.getString("factdate")%>"></td>
            
            <td  colspan=2>
                <a href='javascript: doSave_0("<%=payid%>","<%=k%>","<%=PayInfoId%>")'><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a>&nbsp
                <a href='javascript: doDel_0("<%=RecordSet.getString("projid")%>","<%=PayInfoId%>","<%=payid%>","paytr_<%=PayInfoId%>")'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a></td>

        <%}else if (RecordSet.getInt("status") >= 2){%>
                <td >&nbsp;</td>                
                <td align=right colspan=7><img border=0 src="/images/ArrowRightBlue_wev8.gif"></img></td>
				<td><%=rs.getString("formNum")%></td>
                <td><%=rs.getString("factprice")%></td>
                <td><%=rs.getString("factdate")%></td>            
                <td >&nbsp</td>
                <td >&nbsp</td>
            <%}%>
        </tr>  
 
            
	    <%
	        k++;
	        }%> 
	    <%}%>

		<%if (RecordSet.getInt("status") >= 2){%>
			<tr>
				<td colspan=8>&nbsp;</td>			
				<td align=left style="color:red">
				<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>
				</td>
				<td align=left style="color:red" colspan=4 id="totalPrice_">
				<%=Util.getPointValue(RecordSetM.getString("factPrice"),2,"0")%>
				</td>
			</tr>
		<%}%>

		<%
			j++;
		}
		rownum1 = RecordSetM.getCounts();
		%>
		<input type="hidden" name="rownum1" value="<%=rownum1%>">  
   		</table> 
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
var diag = null;
var parentWin = null;
if("<%=isfromtab%>" == "true"){
	parentWin = parent;
}else{
	parentWin = parent.getParentWindow(window);
}

jQuery(function(){
	if("<%=needRefresh%>" == "true"){
		parentWin.refreshInfo();
	}

})

function closeDialog(){
	parentWin.closeDialog();
}

function callback(){
	if(diag)
		diag.close();
}
function getDialog(title,width,height){
    var diag =new window.top.Dialog();
    diag.currentWindow = window; 
    diag.Modal = true;
    diag.Drag=true;
	diag.Width =width?width:680;
	diag.Height =height?height:420;
	diag.Title = title;
	return diag;
} 

function addShare(contractId , CustomerID){
	diag =getDialog("<%=SystemEnv.getHtmlLabelName(81579,user.getLanguage())%>",600,600);
	diag.URL = "/CRM/data/ContractShareAdd.jsp?contractId="+contractId+"&CustomerID="+CustomerID;
	diag.show();
	document.body.click();
}
</script>

<script language=javascript>

rowindex = "<%=rownum%>";
rowindex1 = "<%=rownum1%>";


function changeDiv(){
	if (document.all("beforeDiv").style.display == "")
	document.all("beforeDiv").style.display = 'none' ;
	else 
	document.all("beforeDiv").style.display = ''	;
}


function doSave(savePart){
	if(check_form(document.weaver,'<%=needcheck%>')){
		document.all("savePart").value=savePart;
		document.weaver.submit();
	}
}

function doSave1(){
	if(check_form(document.Exchange,"ExchangeInfo")){
		document.Exchange.submit();
	}
}


function doSave_0(payid,k,payinfoid){
        r_price = eval(toFloat(document.all("trueprice_"+payid+"_"+k).value,0));
        r_date = document.all("tureDate_"+payid+"_"+k).value;        
        document.all("PayInfoId").value= payinfoid;
        document.all("pay_id").value= payid;
        document.all("paytrueprice").value= r_price;
        document.all("paytrueday").value = r_date;
		document.all("payFormNum").value = document.all("payFormNum_"+payid+"_"+k).value; 
		document.all("method").value = "payedit";
		document.weaver.submit();	
}

function doDel_0(ProjID,PayInfoId,payid,paytrid){
	jQuery.post("/CRM/data/ContractOperation.jsp",
		{"method":"paydel","crmId":"<%=CustomerID%>","ProjID":ProjID,
		"contractId":"<%=contractId%>","PayInfoId":PayInfoId,"payid":payid});
	reloadPro(paytrid);
	
}
function reloadPro(paytrid) {
    document.getElementById(paytrid).style.display="none";
    var temps = 0.00;
    jQuery.each(jQuery('#mTable tr td input:visible:odd'),function(index,item){
      temps +=parseFloat(jQuery(item).val());
     });
     jQuery('#totalPrice_').text(temps.toFixed(2)); 
}
function doSave_1(proid,k,proinfoid){
        document.all("proInfoId").value= proinfoid;
        document.all("proId").value= proid;
        document.all("proFactNum").value= document.all("proFactNum_"+proid+"_"+k).value;
        document.all("proFactDate").value = document.all("proFactDate_"+proid+"_"+k).value;
        document.all("proFormNum").value = document.all("proFormNum_"+proid+"_"+k).value;		
        document.all("method").value = "proedit";
		document.weaver.submit();	
}

function doDel_1(projid,proInfoId,proId){
	jQuery.post("/CRM/data/ContractOperation.jsp",
		{"method":"prodel","crmId":"<%=CustomerID%>","ProjID":projid,
		"contractId":"<%=contractId%>","proInfoId":proInfoId,"proId":proId},function(){
			location.reload();
		});
}

function displaydiv_1()
	{
		if(WorkFlowDiv.style.display == ""){
			WorkFlowDiv.style.display = "none";
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		}
		else{
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
			WorkFlowDiv.style.display = "";
		}
	}


function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}

function delContract(contractId,customerid) {
  window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
      jQuery.post("/CRM/data/ContractOperation.jsp",{"method":"deleteContract","contractId":contractId,"crmId":customerid},function(){
     closeDialog();
      })
  });       

}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
