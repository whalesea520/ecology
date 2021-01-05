
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetP" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<jsp:useBean id="ContacterShareBase" class="weaver.crm.ContacterShareBase" scope="page"/>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<%
String CustomerID = request.getParameter("CustomerID");
String contractId = request.getParameter("contractId");
String isfromtab  = Util.null2String(request.getParameter("isfromtab"),"false");
int rownum=0;
int rownum1=0;
String needcheck="name";

String useridcheck=""+user.getUID();

boolean canview=false;
boolean canedit=false;
boolean canprove=false;
boolean isdelete = false;
int sharelevel = ContacterShareBase.getRightLevelForContacter(user.getUID()+"" , contractId);
if(sharelevel > 0 ){
	 canview=true;
	 if(sharelevel == 2){
		canedit=true;	  
		isdelete=true;
	 }else if (sharelevel == 3 || sharelevel == 4){
		canedit=true;
		canprove=true;
		isdelete=true;
	 }
}
if (!canedit) response.sendRedirect("/notice/noright.jsp") ;
/*check right end*/

RecordSet.executeProc("CRM_Contract_SelectById",contractId);
RecordSet.next();
String sellChanceId = RecordSet.getString("sellChanceId");
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage()) + SystemEnv.getHtmlLabelName(93,user.getLanguage())+" : " + "<a href =/CRM/data/ViewCustomer.jsp?CustomerID=" + CustomerID + ">" +  Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(CustomerID),user.getLanguage()) + "</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY onbeforeunload="protectContract()">
<!-- added by cyril on 2008-06-13 for TD:8828 -->
<script language=javascript src="/js/checkData_wev8.js"></script>
<!-- end by cyril on 2008-06-13 for TD:8828 -->
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%if(isdelete&&RecordSet.getInt("status")==0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:delContract("+contractId+","+CustomerID+"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;   
}%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%if(isfromtab.equals("false")){ %> 
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(16260,user.getLanguage()) %>"/>
</jsp:include>
<%} %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input class="e8_btn_top middle" onclick="doSave(this)" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="SystemEnv.getHtmlLabelName(23036,user.getLanguage())" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<div class="zDialog_div_content" style="height:497px;">
<FORM id=weaver name=weaver action="/CRM/data/ContractOperation.jsp" method=post  >
<input type="hidden" name="method" value="edit">
<input type="hidden" name="contractId" value="<%=contractId%>">
<input type="hidden" name="isfromtab" value="<%=isfromtab %>">
<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(2227,user.getLanguage())%></wea:item>
		<wea:item>
			<%
				String sellChanceName = "";
				RecordSet2.executeSql("select subject from CRM_SellChance where id="+sellChanceId);
				while(RecordSet2.next()){
					sellChanceName = RecordSet2.getString("subject");
				}
				                        
			%>
			<brow:browser viewType="0" name="sellChanceId" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/sellchance/SellChanceBrowser.jsp"
		         browserValue='<%=sellChanceId%>' 
		         browserSpanValue = '<%=sellChanceName%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp?type=sellchance" width="197px" ></brow:browser> 
		</wea:item>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="nameimage" required="true">
				<INPUT class=InputStyle maxLength=50 size=30 name="name" onchange='checkinput("name","nameimage")'  style="width: 166px;"
					value="<%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>">
			</wea:required>
		</wea:item>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(6083,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=InputStyle id=typeId  name=typeId style="width: 138px;">
			<% 
				String typeIdStr = Util.toScreen(RecordSet.getString("TypeId"),user.getLanguage());
	         	while(ContractTypeComInfo.next()){ %>
					<option value=<%=ContractTypeComInfo.getContractTypeid()%> <%if  (typeIdStr.equals(ContractTypeComInfo.getContractTypeid())) 				{%>selected<%}%>><%=ContractTypeComInfo.getContractTypename()%></option>
			<%}%>
			</select>
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(1265,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="docId" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp"
		         browserValue='<%=RecordSet.getString("docId")%>' 
		         browserSpanValue = '<%=DocComInfo.getDocname(RecordSet.getString("docId"))%>'
		         isSingle="true" hasBrowser="true"  hasInput="false" isMustInput='1'
		         completeUrl="/data.jsp" width="197px" ></brow:browser> 
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(534,user.getLanguage())%></wea:item>
		<wea:item><INPUT class=InputStyle maxLength=10 size=17 name="price" style="width: 166px;" onKeyPress="ItemNum_KeyPress('price')" onBlur='checknumber("price")' onchange='checkinput("price","pricename")' value='<%=Util.toScreen(RecordSet.getString("price"),user.getLanguage())%>'><SPAN ID=pricename></SPAN></wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="crmId" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
		         browserValue='<%=RecordSet.getString("crmId")%>' 
		         browserSpanValue = '<%=CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("crmId"))%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp?type=7" width="197px" ></brow:browser>
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="contacterID" 
		         browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/CRM/data/ContactBrowser.jsp?customerid="+CustomerID%>'
		         browserValue='<%=RecordSet.getString("contacterId")%>' 
		         browserSpanValue = '<%=Util.toScreen(CustomerContacterComInfo.getCustomerContacternameByID(RecordSet.getString("contacterId")),user.getLanguage())%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl='<%="/data.jsp?type=customerContacter&whereClause=customerid="+CustomerID%>' width="197px" ></brow:browser>
		</wea:item>
		         
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=InputStyle id=status name=status style="width: 138px;">
		        <option value="0" <%if (RecordSet.getInt("status")==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></option>
				<!--option value="1" <%if (RecordSet.getInt("status")==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></option>
				<option value="2" <%if (RecordSet.getInt("status")==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6095,user.getLanguage())%></option-->
			</select>
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="manager" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
	         browserValue='<%=RecordSet.getString("manager")%>' 
	         browserSpanValue = '<%= Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	         completeUrl="/data.jsp" width="197px" ></brow:browser> 
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON class=Calendar type="button" onclick="onShowDate('startDatespan','startdate')"></BUTTON> 
				<SPAN id=startDatespan ><%=Util.toScreen(RecordSet.getString("startDate"),user.getLanguage())%></SPAN>
				<input type="hidden" name="startdate" value="<%=RecordSet.getString("startDate")%>">
        </wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON class=Calendar type="button" onclick="onShowDate('endDatespan','enddate')"></BUTTON> 
				<SPAN id=endDatespan ><%=Util.toScreen(RecordSet.getString("endDate"),user.getLanguage())%></SPAN> 
				<input type="hidden" name="enddate" value="<%=RecordSet.getString("endDate")%>">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="ProjID" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
		         browserValue='<%=RecordSet.getString("projid")%>' 
		         browserSpanValue = '<%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(RecordSet.getString("projid")),user.getLanguage())%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp?type=8" width="197px" ></brow:browser> 
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(6078,user.getLanguage())%></wea:item>
		<wea:item><INPUT type=checkbox name="isremind" value="0" <%if (RecordSet.getInt("isRemind") == 0) {%>checked<%}%>
			 onclick="changeDiv()"></wea:item>
		
		<wea:item attributes="{'id':'beforeTd'}"><%=SystemEnv.getHtmlLabelName(6077,user.getLanguage())%></wea:item>
		<wea:item attributes="{'id':'beforeTd'}">
			<wea:required id="beforeimage" required="true">
				<INPUT class=InputStyle maxLength=2 size=10 name="before" onKeyPress="ItemCount_KeyPress()" 
				onBlur='checknumber("before")' onchange='checkinput("before","beforeimage")' 
				value = "<%=RecordSet.getString("remindDay")%>">
			</wea:required>
		</wea:item>
	
	</wea:group>
	
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%>'>
		<wea:item type="groupHead">
			<input type="button" class="addbtn" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(15128, user.getLanguage())%>" onclick="addRow();">
			<input type="button" class="delbtn" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>" onclick="javascript:if(isdel()){deleteRow()};">
		</wea:item>
		
		<wea:item attributes="{'colspan':'full'}">
			 <TABLE class=ListStyle cellspacing=1  cols=10 id="oTable">
			 	<colgroup>
					<col width="5%">
					<col width="15%">
					<col width="5%">
					<col width="15%">
					<col width="10%">
					<col width="10%">
					<col width="7%">
					<col width="8%">
					<col width="15%">
					<col width="10%">
				</colgroup>
			
			 	<tr class=header>
		           <td class=Field><input type="checkbox" name="node_total" onclick="setCheckState(this)"/></td>
		    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></td>
		    	   <td class=Field><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></td>
		    	   <td class=Field><%=SystemEnv.getHtmlLabelName(649,user.getLanguage())%></td>
		    	   <td class=Field><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></td>
				   <td class=Field><%=SystemEnv.getHtmlLabelName(15130,user.getLanguage())%></td>
		           <td class=Field><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
		    	   <td class=Field><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></td>
				   <td class=Field><%=SystemEnv.getHtmlLabelName(1050,user.getLanguage())%></td>
				   <td class=Field><%=SystemEnv.getHtmlLabelName(6078,user.getLanguage())%></td>
		    	</tr>
		    	
			<%
				int i=0;
				boolean isLight = true;	
				if(!sellChanceId.equals("")&&1!=1){
			
				RecordSet.executeProc("CRM_Product_SelectByID",sellChanceId);
				while (RecordSet.next()) {
				%>
				<tr>
					<td>
						<input type='checkbox' name='check_node' value='0' <%if (Util.getIntValue(RecordSet.getString("factnumber_n"),0)>0) {%>disabled<%}%>>
						<input type='hidden' name='canDeleteP_<%=i%>' value='<%if (Util.getIntValue(RecordSet.getString("factnumber_n"),0)==0) {%>0<%}else{%>1<%}%>' >
						<!--0为能删除-->
						<input type='hidden' name='productId_<%=i%>' value='<%=RecordSet.getString("id")%>' >
					</td>
					<td>
						<brow:browser viewType="0" name='<%="productname_"+i%>' 
					         browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser_wev8.js"
					         browserValue='<%=RecordSet.getString("productid")%>' 
					         browserSpanValue = '<%=Util.toScreen(AssetComInfo.getAssetName(RecordSet.getString("productid")),user.getLanguage())%>'
					         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
					         completeUrl="/data.jsp?type=product" width="150px" ></brow:browser> 
					</td>
					<td>			
						<span class=InputStyle id="assetunitid_<%=i%>span"><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(RecordSet.getString("assetunitid")),user.getLanguage())%></span> 
						<input type="hidden" name="assetunitid_<%=i%>"  id="assetunitid_<%=i%>" value="<%=RecordSet.getString("assetunitid")%>">
					</td>
					<td>
						<brow:browser viewType="0" name='<%="currencyid_"+i%>' 
					         browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp"
					         browserValue='<%=RecordSet.getString("currencyid")%>' 
					         browserSpanValue = '<%=Util.toScreen(CurrencyComInfo.getCurrencyname(RecordSet.getString("currencyid")),user.getLanguage())%>'
					         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
					         completeUrl="/data.jsp?type=12" width="150px" ></brow:browser> 
					</td>
					<td>
						<input type=text class='InputStyle' id="productPrice_<%=i%>"  name="productPrice_<%=i%>" onKeyPress="ItemNum_KeyPress('productPrice_<%=i%>')" onBlur="checknumber1(this);sumPrices(<%=i%>);sumTotalPrices()" size=17 value="<%=RecordSet.getString("salesprice")%>" onchange='checkinput("productPrice_<%=i%>","productPrice_<%=i%>span")' maxlength=17><span id="productPrice_<%=i%>span"></span>
					</td>
					<td>
						<input type=text class='InputStyle' id="productDepreciation_<%=i%>"  name="productDepreciation_<%=i%>" onKeyPress="ItemCount_KeyPress()" onBlur="checknumber1(this);sumPrices(<%=i%>);sumTotalPrices()" size=5 maxLength=3 value="100" onchange='checkinput("productDepreciation_<%=i%>","productDepreciation_<%=i%>span")'>%<span id="productDepreciation_<%=i%>span"></span></td>
					<td>
						<input type=text class='InputStyle' name="productNumber_<%=i%>" onKeyPress='ItemCount_KeyPress()' onBlur="checknumber1(this);sumPrices(<%=i%>);sumTotalPrices()" size=10 value="<%=RecordSet.getString("salesnum")%>" onchange='checkinput("productNumber_<%=i%>","productNumber_<%=i%>span")' maxlength=4><span id="productNumber_<%=i%>span"></span>	
					</td>
					<td>
						<input type=text class='InputStyle' id="productPrices_<%=i%>"  name="productPrices_<%=i%>" onKeyPress="ItemNum_KeyPress('productPrices_<%=i%>')" onBlur="checknumber1(this);sumTotalPrices()" size=17 value="<%=RecordSet.getString("totelprice")%>" maxlength=17>	
					</td>
					<td>
						<BUTTON class=Calendar type="button" onclick='onShowDate("productDatespan_<%=i%>","productDate_<%=i%>")'></BUTTON> 
						<SPAN id="productDatespan_<%=i%>"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
						<input type="hidden" name = "productDate_<%=i%>" value="">	
					</td>
					<td >
						<INPUT type=checkbox name="productIsRemind_<%=i%>" value=0 checked>	
					</td>
		 		</tr>
				<%
					i++;
					}
					rownum = RecordSet.getCounts();
				}else{
					RecordSetP.executeProc("CRM_ContractProduct_Select",contractId);
					while (RecordSetP.next()) {
				%>
				<tr class="DataLight">
					<td ><input type='checkbox' name='check_node' value='0' <%if (Util.getIntValue(RecordSetP.getString("factnumber_n"),0)>0) {%>disabled<%}%>>
						<input type='hidden' name='canDeleteP_<%=i%>' value='<%if (Util.getIntValue(RecordSetP.getString("factnumber_n"),0)==0) {%>0<%}else{%>1<%}%>' >
						<!--0为能删除-->
						<input type='hidden' name='productId_<%=i%>' value='<%=RecordSetP.getString("id")%>' >
					</td>
			 	    <td >
			 	    	<brow:browser viewType="0" name='<%="productname_"+i%>' 
					         browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser_wev8.js"
					         browserValue='<%=RecordSetP.getString("productid")%>' 
					         browserSpanValue = '<%=Util.toScreen(AssetComInfo.getAssetName(RecordSetP.getString("productid")),user.getLanguage())%>'
					         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
					         completeUrl="/data.jsp?type=product" width="150px" ></brow:browser> 
					</td>
				    <td >			
						<span class=InputStyle id="assetunitid_<%=i%>span"><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(RecordSetP.getString("unitId")),user.getLanguage())%></span> 
						<input type="hidden" name="assetunitid_<%=i%>"  id="assetunitid_<%=i%>" value="<%=RecordSetP.getString("unitId")%>">
					</td>
				    <td >
						<brow:browser viewType="0" name='<%="currencyid_"+i%>' 
					         browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp"
					         browserValue='<%=RecordSetP.getString("currencyid")%>' 
					         browserSpanValue = '<%=Util.toScreen(CurrencyComInfo.getCurrencyname(RecordSetP.getString("currencyid")),user.getLanguage())%>'
					         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
					         completeUrl="/data.jsp?type=12" width="150px" ></brow:browser> 
					</td>
					<td >
						<input type=text class='InputStyle' id="productPrice_<%=i%>"  name="productPrice_<%=i%>" onKeyPress="ItemNum_KeyPress('productPrice_<%=i%>')" onBlur="checknumber1(this);sumPrices(<%=i%>);sumTotalPrices()" size=17 value="<%=RecordSetP.getString("price")%>" onchange='checkinput("productPrice_<%=i%>","productPrice_<%=i%>span")' maxlength=17><span id="productPrice_<%=i%>span"></span>
					</td>
					<td >
						<input type=text class='InputStyle' id="productDepreciation_<%=i%>"  name="productDepreciation_<%=i%>" onKeyPress="ItemCount_KeyPress()" onBlur="checknumber1(this);sumPrices(<%=i%>);sumTotalPrices()" size=5 maxLength=3 value="<%=RecordSetP.getString("depreciation")%>" onchange='checkinput("productDepreciation_<%=i%>","productDepreciation_<%=i%>span")'>%<span id="productDepreciation_<%=i%>span"></span></td>
					<td >
						<input type=text class='InputStyle' name="productNumber_<%=i%>" onKeyPress='ItemNum_KeyPress("productNumber_<%=i%>");checkProductNumber(<%=i%>)' onBlur="checknumber1(this);sumPrices(<%=i%>);sumTotalPrices()" size=10 value="<%=RecordSetP.getString("number_n")%>" onchange='checkinput("productNumber_<%=i%>","productNumber_<%=i%>span")'><span id="productNumber_<%=i%>span"></span>	
					</td>
			 	    <td >
						<input type=text class='InputStyle' id="productPrices_<%=i%>"  name="productPrices_<%=i%>" onKeyPress="ItemNum_KeyPress('productPrices_<%=i%>')" onBlur="checknumber1(this);sumTotalPrices()" size=17 value="<%=RecordSetP.getString("sumPrice")%>" maxlength=17>	
					</td>
				    <td >
						<BUTTON class=Calendar type="button" onclick='onShowDate("productDatespan_<%=i%>","productDate_<%=i%>")'></BUTTON> 
						<SPAN id="productDatespan_<%=i%>"><%=RecordSetP.getString("planDate")%></SPAN>
						<input type="hidden" name = "productDate_<%=i%>" value="<%=RecordSetP.getString("planDate")%>">	
					</td>
					<td >
						<INPUT type=checkbox name="productIsRemind_<%=i%>" value=0 <% if (RecordSetP.getInt("isRemind") == 0) {%>checked<%}%>>	
					</td>
				</tr>
				<%
				i++;
				}
				rownum = RecordSetP.getCounts();
				}%>
				<input type="hidden" name="rownum" value="<%=rownum%>"> 
		 	</TABLE>
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15131,user.getLanguage())%>'>
		<wea:item type="groupHead">
			<input type="button" class="addbtn" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(15128, user.getLanguage())%>" onclick="addRow1();">
			<input type="button" class="delbtn" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>" onclick="javascript:if(isdel()){deleteRow1()};">
		</wea:item>
		<wea:item attributes="{'colspan':'full'}">
			<TABLE class=ListStyle cellspacing=1  cols=8 id="mTable">
				<colgroup>
					<col width="5%">
					<col width="15%">
					<col width="10%">
					<col width="15%">
					<col width="15%">
					<col width="10%">
					<col width="15%">
					<col width="10%">
				</colgroup>
			
		    	<tr class=header>
		           <td class=Field><input type="checkbox" name="node1_total" onclick="setCheckState(this)"/></td>
		    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15132,user.getLanguage())%></td>
		    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15133,user.getLanguage())%></td>
		           <td class=Field><%=SystemEnv.getHtmlLabelName(1462,user.getLanguage())%></td>
		    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15134,user.getLanguage())%></td>
		    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15135,user.getLanguage())%></td>
				   <td class=Field><%=SystemEnv.getHtmlLabelName(15136,user.getLanguage())%></td>
				   <td class=Field><%=SystemEnv.getHtmlLabelName(6078,user.getLanguage())%></td>
		    	</tr>
				<%
				int j = 0;
				RecordSetM.executeProc("CRM_ContractPayMethod_Select",contractId);
				while (RecordSetM.next()) {
				%>
					<tr class="DataLight">
						<td ><input type="checkbox" name="check_nodeM" value="0" <%if  (Util.getDoubleValue(RecordSetM.getString("factprice"),0)>0) {%>disabled<%}%>>
							<input type='hidden' name='canDeleteM_<%=j%>' value='<%if (Util.getDoubleValue(RecordSetM.getString("factprice"),0)==0) {%>0<%}else{%>1<%}%>' >
							<!--0为能删除-->
							<input type='hidden' name='payMethodId_<%=j%>' value='<%=RecordSetM.getString("id")%>' ></td>
				
			    	   <td ><input class='InputStyle' name="paymethodName_<%=j%>" id="paymethodName_<%=j%>" value="<%=RecordSetM.getString("prjName")%>" onchange='checkinput("paymethodName_<%=j%>","paymethodName_<%=j%>span")'><span class=InputStyle id="paymethodName_<%=j%>span"></span></td>
			    	   <td >
			   
					    <%if  (Util.getDoubleValue(RecordSetM.getString("factprice"),0)>0){ %>
						   
						<% if (RecordSetM.getInt("typeId") == 1) {%><%=SystemEnv.getHtmlLabelName(15137,user.getLanguage())%><%} else {%><%=SystemEnv.getHtmlLabelName(15138,user.getLanguage())%><%}%>
						<input type="hidden" name = "paymethodType_<%=j%>" value="<%=RecordSetM.getInt("typeId")%>">
						<%}else{%>
						<select  class=InputStyle name="paymethodType_<%=j%>" onclick="onSelectStart(this,<%=j%>)" onchange="onSelectChange(this,<%=j%>)">
							<option value=1 <% if (RecordSetM.getInt("typeId") == 1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15137,user.getLanguage())%></option>
							<option value=2 <% if (RecordSetM.getInt("typeId") == 2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15138,user.getLanguage())%></option>
						</select> 
							<input type="hidden" name = "paymethodType_<%=j%>_hidden" value="">
						<%}%>
					  </td>
	    	   		  <td >
					   <%if  (Util.getDoubleValue(RecordSetM.getString("factprice"),0)>0) 
						   {%>
						   <SPAN id="BudgetTypespan_<%=j%>"><%=Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(RecordSetM.getString("feetypeid")),user.getLanguage())%></SPAN>
						<input type="hidden" name = "BudgetType_<%=j%>" value="<%=RecordSetM.getString("feetypeid")%>">
						   
						   <%}else{
							   String url = "";
								if (RecordSetM.getInt("typeId") ==2){
									url="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?feetype=1";
								}else{
									url="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?feetype=2";
								}
						   %>
						<brow:browser viewType="0" name='<%="BudgetType_"+j%>' 
					         browserUrl='<%=url%>'
					         browserValue='<%=RecordSetM.getString("feetypeid")%>' 
					         browserSpanValue = '<%=Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(RecordSetM.getString("feetypeid")),user.getLanguage())%>'
					         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
					         completeUrl="/data.jsp?type=FnaBudgetfeeTypeMulti" width="150px" ></brow:browser> 
					          
						 <%}%>
			        </td>
	               
					<td >
						<%if  (Util.getDoubleValue(RecordSetM.getString("factprice"),0)>0) 
						{%>
						<input type=text readonly = true class='InputStyle' id="paymethodPrice_<%=j%>"  name="paymethodPrice_<%=j%>" onKeyPress="ItemNum_KeyPress('paymethodPrice_<%=j%>')" onBlur="checknumber1(this)" size=17 value="<%=RecordSetM.getString("payPrice")%>" onchange='checkinput("paymethodPrice_<%=j%>","paymethodPrice_<%=j%>span")' maxlength=17><span id="paymethodPrice_<%=j%>span"></span>
						<%}else{%>
						<input type=text class='InputStyle' id="paymethodPrice_<%=j%>"  name="paymethodPrice_<%=j%>" onKeyPress="ItemNum_KeyPress('paymethodPrice_<%=j%>')" onBlur="checknumber1(this)" size=17 value="<%=RecordSetM.getString("payPrice")%>" onchange='checkinput("paymethodPrice_<%=j%>","paymethodPrice_<%=j%>span")' maxlength=17><span id="paymethodPrice_<%=j%>span"></span>
						<%}%>
				    </td>
				    
			 	    <td >
						<BUTTON type="button" class=Calendar onclick='onShowDate("paymethodDatespan_<%=j%>","paymethodDate_<%=j%>")'></BUTTON>
						<SPAN id="paymethodDatespan_<%=j%>"><%=RecordSetM.getString("payDate")%></SPAN>
						<input type="hidden" name = "paymethodDate_<%=j%>" value="<%=RecordSetM.getString("payDate")%>">   
					</td>
	
				    <td ><input type=text class='InputStyle' id="paymethodDesc_<%=j%>"  name="paymethodDesc_<%=j%>" value="<%=RecordSetM.getString("qualification")%>"></td>
		            <td >
		            	<INPUT type=checkbox name="paymethodIsRemind_<%=j%>" value=0 <% if (RecordSetM.getInt("isRemind") == 0) {%>checked<%}%>>
				    </td>
	    		</tr>
				<%
				j++;
				}
				rownum1 = RecordSetM.getCounts();
				%>
			<input type="hidden" name="rownum1" value="<%=rownum1%>">  
   			</table> 
		</wea:item>
		<wea:item attributes="{'colspan':'full'}"></wea:item>
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
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/OrderValidator_wev8.js"></SCRIPT>
<SCRIPT language="javascript">

var parentWin = null;
if("<%=isfromtab%>" == "true"){
	parentWin = parent;
}else{
	parentWin = parent.getParentWindow(window);
}

function setCheckState(obj){
	var name = obj.name;
	if(obj.name == "node_total"){
		jQuery("input[name='check_node']").each(function(){
			changeCheckboxStatus(this,obj.checked);
 		});
	}else{
		jQuery("input[name='check_nodeM']").each(function(){
			changeCheckboxStatus(this,obj.checked);
 		});
	}
	
}

function onShowSellChanceId(){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/sellchance/SellChanceBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data){
		if(data.id!=""){
			sellChanceIdSpan.innerHTML = "<A href='/CRM/sellchance/ViewSellChance.jsp?id="+data.id+"'>"+data.name+"</A>"
			weaver.sellChanceId.value=data.id
			weaver.sellChanceIdSpanTemp.value="<A href='/CRM/sellchance/ViewSellChance.jsp?id="+data.id+"'>"+data.name+"</A>"
			weaver.action="ContractAdd.jsp?CustomerID=<%=CustomerID%>"
			window.onbeforeunload=null
			weaver.submit()
		}else{ 
			sellChanceIdSpan.innerHTML = ""
			weaver.sellChanceId.value=""
		}
	}
}

function onShowBudgetType(spanname,inputename,paymethodType){
	var link="";
	if (document.all(paymethodType).value ==2){
		link="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype='1'";
	}else{
		link="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype='2'";
	}
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	data = window.showModalDialog(link,
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
	if (data){
		if (data.id!=""){
			document.all(spanname).innerHTML = data.name
			document.all(inputename).value = data.id
		}else{
			document.all(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			document.all(inputename).value=""
		}
	}

}


function onGetProduct(spanname1,inputename1,spanname2,inputename2,spanname3,inputename3,inputename4,inputename5){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
	if (data){
		if (data.id!=""){
			spanname1.innerHTML = "<A href='/lgc/asset/LgcAsset.jsp?paraid="+wuiUtil.getJsonValueByIndex(data,0)+"'>"+wuiUtil.getJsonValueByIndex(data,1)+"</A>"
			inputename1.value=wuiUtil.getJsonValueByIndex(data,0)
			spanname2.innerHTML = wuiUtil.getJsonValueByIndex(data,3)
			inputename2.value = wuiUtil.getJsonValueByIndex(data,2)
			spanname3.innerHTML = wuiUtil.getJsonValueByIndex(data,5)
			inputename3.value = wuiUtil.getJsonValueByIndex(data,4)
			inputename4.value = wuiUtil.getJsonValueByIndex(data,6)
			inputename5.value = wuiUtil.getJsonValueByIndex(data,6)
		}else{
			spanname1.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			inputename1.value = ""
			spanname2.innerHTML = ""
			inputename2.value = ""
			spanname3.innerHTML = ""
			inputename3.value = ""
			inputename4.value = "0"
			inputename5.value = "0"
		}
	}
	sumTotalPrices()
}

function onSelectChange(obj,index){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(25464,user.getLanguage())%>",function(){
		var url = "";
		if (obj.value ==2){
			url="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?feetype=1";
		}else{
			url="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?feetype=2";
		}
		
		var childindex = jQuery(obj).attr("name").substring(jQuery(obj).attr("name").indexOf("_")+1);
		jQuery("#BudgetTypespan_"+childindex+"span_n").html("");
		$("#BudgetTypespan_"+childindex+"span_n").e8Browser({
		   name:"BudgetType_"+childindex,
		   viewType:"0",
		   browserValue:"0",
		   isMustInput:"1",
		   browserSpanValue:"",
		   hasInput:true,
		   linkUrl:"#",
		   isSingle:true,
		   completeUrl:"/data.jsp?type=FnaBudgetfeeTypeMulti",
		   browserUrl:url,
		   width:"150px",
		   hasAdd:false
		  });
	}); 
}

function onSelectStart(obj,index){
	document.getElementById("paymethodType_"+index).value=obj.options.value;
}

rowindex = "<%=rownum%>";
rowindex1 = "<%=rownum1%>";

function addRow()
{
	ncol = jQuery(oTable).attr("cols");
	oRow = oTable.insertRow(-1);
	oRow.setAttribute("class","DataLight");
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
            case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0' ><input type='hidden' name='canDeleteP_"+rowindex+"' value='0' ><input type='hidden' name='productId_"+rowindex+"' value='0' >"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;			
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<span id='productname_"+rowindex+"span_n'></span> ";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				
				$("#productname_"+rowindex+"span_n").e8Browser({
				   name:"productname_"+rowindex,
				   viewType:"0",
				   browserValue:"0",
				   isMustInput:"2",
				   browserSpanValue:"",
				   hasInput:true,
				   linkUrl:"#",
				   isSingle:true,
				   completeUrl:"/data.jsp?type=product",
				   browserUrl:"/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp",
				   width:"150px",
				   hasAdd:false,
				   _callback:'callBackSelectUpdate'
				  });
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span id=assetunitid_"+rowindex+"span></span> "+
        					"<input type='hidden' name='assetunitid_"+rowindex+"'  id=assetunitid_"+rowindex+">";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<span id='currencyid_"+rowindex+"span_n'></span> ";oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				$("#currencyid_"+rowindex+"span_n").e8Browser({
				   name:"currencyid_"+rowindex,
				   viewType:"0",
				   browserValue:"0",
				   isMustInput:"2",
				   browserSpanValue:"",
				   hasInput:true,
				   linkUrl:"#",
				   isSingle:true,
				   completeUrl:"/data.jsp?type=12",
				   browserUrl:"/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp",
				   width:"150px",
				   hasAdd:false,
				   isSingle:true
				  });	
				break;                
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class='InputStyle' id='productPrice_"+rowindex+"'  name='productPrice_"+rowindex+"' onKeyPress=ItemNum_KeyPress('productPrice_"+rowindex+"') onBlur='checknumber1(this);sumPrices("+rowindex+");sumTotalPrices()' size=17 onchange=checkinput('productPrice_"+rowindex+"','productPrice_"+rowindex+"span') value='0'><span id=productPrice_"+rowindex+"span></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;

			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class='InputStyle' id='productDepreciation_"+rowindex+"'  name='productDepreciation_"+rowindex+"' onKeyPress='ItemCount_KeyPress()' onBlur='checknumber1(this);sumPrices("+rowindex+");sumTotalPrices()' size=5 maxLength=3 value = 100 onchange=checkinput('productDepreciation_"+rowindex+"','productDepreciation_"+rowindex+"span')>%<span id=productDepreciation_"+rowindex+"span></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;


			case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class='InputStyle' name='productNumber_"+rowindex+"' onKeyPress=ItemNum_KeyPress('productNumber_"+rowindex+"');checkProductNumber("+rowindex+") onBlur='checknumber1(this);sumPrices("+rowindex+");sumTotalPrices()' size=10 value='1' onchange=checkinput('productNumber_"+rowindex+"','productNumber_"+rowindex+"span')><span id=productNumber_"+rowindex+"span></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;               
            case 7: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class='InputStyle' id='productPrices_"+rowindex+"'  name='productPrices_"+rowindex+"' onKeyPress=ItemNum_KeyPress('productPrices_"+rowindex+"') onBlur='checknumber1(this);sumTotalPrices()' size=17 value='0' onchange=checkinput('productPrices_"+rowindex+"','productPrices_"+rowindex+"span')><span id=productPrices_"+rowindex+"span></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			 case 8: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON type='button' class=Calendar onclick=onShowDate('productDatespan_" + rowindex + "','productDate_" + rowindex + "')></BUTTON> <SPAN id=productDatespan_" + rowindex + "><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN> <input type='hidden' name = productDate_" + rowindex + ">";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			 case 9: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<INPUT type=checkbox name=productIsRemind_" + rowindex + " value=0 checked>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
		}
	}
	rowindex = rowindex*1 +1;
	weaver.rownum.value=rowindex;	
	jQuery('body').jNice(); 
}


function addRow1()
{
	ncol = jQuery(mTable).attr("cols");
	oRow = mTable.insertRow(-1);
	oRow.setAttribute("class","DataLight");
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
            case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_nodeM' value='0' ><input type='hidden' name='canDeleteM_"+rowindex1+"' value='0' ><input type='hidden' name='payMethodId_"+rowindex1+"' value='0' >"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;			
			case 1:
				var oDiv = document.createElement("div");
				var sHtml =  "<input class='InputStyle' name='paymethodName_"+rowindex1+"' id='paymethodName_"+rowindex1+"' onchange=checkinput('paymethodName_"+rowindex1+"','paymethodName_"+rowindex1+"span') ><span id=paymethodName_"+rowindex1+"span><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<select class=InputStyle style='width:93px'  name=paymethodType_"+rowindex1+" onclick=onSelectStart(this,"+rowindex1+") onchange=onSelectChange(this,"+rowindex1+")><option value=1><%=SystemEnv.getHtmlLabelName(15137,user.getLanguage())%></option><option value=2><%=SystemEnv.getHtmlLabelName(15138,user.getLanguage())%></option></select>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span id='BudgetTypespan_"+rowindex1+"span_n'></span> ";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				
				var url = "";
				if (document.all("paymethodType_"+rowindex1).value ==2){
					url="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?feetype=1";
				}else{
					url="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?feetype=2";
				}
				
				$("#BudgetTypespan_"+rowindex1+"span_n").e8Browser({
				   name:"BudgetType_"+rowindex1,
				   viewType:"0",
				   browserValue:"0",
				   isMustInput:"1",
				   browserSpanValue:"",
				   hasInput:true,
				   linkUrl:"#",
				   isSingle:true,
				   completeUrl:"/data.jsp?type=FnaBudgetfeeTypeMulti",
				   browserUrl:url,
				   width:"150px",
				   hasAdd:false
				  });	
				  break;
			case 4:
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class='InputStyle' id='paymethodPrice_"+rowindex1+"'  name='paymethodPrice_"+rowindex1+"' onKeyPress=ItemNum_KeyPress('paymethodPrice_"+rowindex1+"') onBlur='checknumber1(this)' size=17 onchange=checkinput('paymethodPrice_"+rowindex1+"','paymethodPrice_"+rowindex1+"span') maxlength=10><span id=paymethodPrice_"+rowindex1+"span><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;                
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON type='button' class=Calendar onclick=onShowDate('paymethodDatespan_" + rowindex1 + "','paymethodDate_" + rowindex1 + "')></BUTTON> <SPAN id=paymethodDatespan_" + rowindex1 + "><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN> <input type='hidden' name = paymethodDate_" + rowindex1 + ">";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	

			case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class='InputStyle' id='paymethodDesc_"+rowindex1+"'  name='paymethodDesc_"+rowindex1+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
				
			 case 7: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<INPUT type=checkbox name=paymethodIsRemind_" + rowindex1 + " value=0 checked>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
		}
	}
	rowindex1 = rowindex1*1 +1;
	weaver.rownum1.value=rowindex1;	
	jQuery('body').jNice(); 
	beautySelect();
}

function callBackSelectUpdate(event,data,fieldId,oldid){
	var number = fieldId.substring(fieldId.indexOf("_")+1);
	jQuery.post("/CRM/sellchance/SellChanceOperation.jsp",{"method":"getProductInfo","productId":data.id},function(info){
		info = jQuery.trim(info);
		info = eval('('+info+')');
		jQuery("#assetunitid_"+number).val(info.assetunitid);//单位
		jQuery("#assetunitid_"+number+"span").html(info.assetunitname);
		
		jQuery("#currencyid_"+number).val(info.currencyid);
		var currencyname = "<a style=\"max-width:104px;\" href=\"#1\" onclick=\"return false;\">"+info.currencyname+"</a>";
		_writeBackData("currencyid_"+number,2,{id:info.currencyid,name:currencyname},{hasInput:true});
		
		var currencyname = "<span class='e8_showNameClass'><a style='max-width:104px;' href='#"+info.currencyid+"'"+
							" onclick='return false;'>"+info.currencyname+"</a>"+
							" <span id="+info.currencyid+" class='e8_delClass' style='opacity: 0; visibility: hidden;'>&nbsp;x&nbsp;</span></span></span>";
			
		jQuery("#productPrice_"+number).val(info.salesprice);//单价
		sumPrices(number);//计算单个总价
		sumTotalPrices();//计算总价
	})
}


function deleteRow()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
    for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	} 
	
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1);	
			}
			rowsum1 -=1;
		}	
	}	
}


function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
    for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_nodeM')
			rowsum1 += 1;
	} 
	
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_nodeM'){
			if(document.forms[0].elements[i].checked==true) {
				mTable.deleteRow(rowsum1);	
			}
			rowsum1 -=1;
		}	
	}	
}
function checkProductNumber(rowval){
	count_number = document.all("productNumber_"+rowval).value;
	if(count_number.indexOf(".")!=-1 && (window.event.keyCode>=48) && (window.event.keyCode<=57)){

	}else{
		if(count_number==0 && window.event.keyCode==45 && window.event.keyCode==46){
			window.event.keyCode=0;
		}
		if(count_number>=10000000 && window.event.keyCode!=46){
			window.event.keyCode=0;
		}
	}
}
function sumPrices(rowval){
	count_total = 0 ;
	count_Depreciation = 0;
	count_number = 0;	
	count_total = document.all("productPrice_"+rowval).value;
	count_Depreciation = eval(toInt(document.all("productDepreciation_"+rowval).value,100));
	count_number = eval(toFloat(document.all("productNumber_"+rowval).value,0));
	
	count_total = toFloat(count_total/ 100)  * count_Depreciation  * count_number ;
	if(count_number>99999999.99){
    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19330,user.getLanguage())%>");
    	document.all("productNumber_"+rowval).value=1;
	}
    if(count_total>999999999999999.99){
    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19330,user.getLanguage())%>");
    	document.all("productNumber_"+rowval).value=1;
    }else{
		document.all("productPrices_"+rowval).value = toPrecision(count_total,2) ; 
	}
}

function sumTotalPrices(){

    rowindex = eval(toInt(document.all("rownum").value,0));
    count_sum=0;
    for(i=0;i<rowindex;i++){
		if ((document.all("productname_"+i))!=null) {
        count_sum += toPrecision(eval(toFloat(document.all("productPrices_"+i).value,0)),2);
		}
    }
    if(count_sum>999999999999999.99){
    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19330,user.getLanguage())%>");
    }
	document.all("price").value = toPrecision(count_sum,2) ;
}

/**
return a number with a specified precision.
*/
function toPrecision(aNumber,precision){
	var temp1 = Math.pow(10,precision);
	var temp2 = new Number(aNumber);

	return isNaN(Math.round(temp1*temp2) /temp1)?0:Math.round(temp1*temp2) /temp1 ;
}

function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}
function toInt(str , def) {
	if(isNaN(parseInt(str))) return def ;
	else return str ;
}

function doSave(obj){
	window.onbeforeunload=null;
	var parastr = "<%=needcheck%>" ;	
	parastr +=",docId,price,crmId,contacterID,manager,startdate,enddate,before";
	for(i=0; i<document.all("rownum").value ; i++) {
		parastr += ",productname_"+i ;
		parastr += ",productPrice_"+i ;
		parastr += ",productDepreciation_"+i ;
		parastr += ",productNumber_"+i ;
		parastr += ",productPrices_"+i ;
		parastr += ",productDate_"+i ;
	}

	for(i=0; i<document.all("rownum1").value ; i++) {
		parastr += ",paymethodName_"+i ;
		parastr += ",paymethodPrice_"+i ;
		parastr += ",paymethodDate_"+i ;
		//parastr += ",BudgetType_"+i ;

	}
	if(check_form(document.weaver,parastr)){
	//alert(document.weaver.sellChanceIdSpanTemp.value);
		//added by lupeng 2004.05.21 for TD461.
		if (!checkOrderValid("startdate", "enddate")) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(54,user.getLanguage())%>");
			return;
		}
		//end
		obj.disabled = true;
		document.weaver.submit();
	}
}

function protectContract(){
	if(!checkDataChange())//added by cyril on 2008-06-13 for TD:8828
		event.returnValue="<%=SystemEnv.getHtmlLabelName(18957,user.getLanguage())%>";
}

function changeDiv(){
	if(jQuery("input[name='isremind']").attr("checked")){
		jQuery("td[name='beforeTd']").show();
	}else{
		jQuery("td[name='beforeTd']").hide();
	}
}
function delContract(contractId,customerid) {
  window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
      jQuery.post("/CRM/data/ContractOperation.jsp",{"method":"deleteContract","contractId":contractId,"crmId":customerid},function(){
     closeDialog();
      })
  });       

}
jQuery(function(){
	checkinput("name","nameimage");
	checkinput("before","beforeimage");
	
	changeDiv();
});

createTags();//added by cyril on 2008-06-13 for td:8828
</SCRIPT>
</BODY>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
