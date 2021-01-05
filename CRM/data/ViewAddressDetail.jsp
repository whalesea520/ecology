
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.util.CrmFieldComInfo"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page"/>
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>

<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
	String TypeID = Util.null2String(request.getParameter("TypeID"));
	
	char flag = 2;
	
	RecordSetT.executeProc("CRM_AddressType_SelectByID",TypeID);
	if(RecordSetT.getFlag()!=1)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData_1");
		return;
	}
	RecordSetT.first();
	
	RecordSetC.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
	if(RecordSetC.getCounts()<=0)
	{
		response.sendRedirect("/base/error/DBError.jsp?type=FindData_2");
		return;
	}
	RecordSetC.first();
	
	RecordSet.executeProc("CRM_CustomerAddress_Select",TypeID+flag+CustomerID);
	boolean isEqual = false;
	if(RecordSet.getCounts()<=0)
	{
		isEqual = true;
	}
	else
	{
		RecordSet.first();
		isEqual = (RecordSet.getInt("isequal")!=0);
	}
	
	boolean hasFF = true;
	    // commented by lupeng 2004-08-17 for TD828
	RecordSetFF.executeProc("Base_FreeField_Select","c3");
	if(RecordSetFF.getCounts()<=0)
		hasFF = false;
	else
		RecordSetFF.first();
	
	
	/*check right begin*/
	
	String useridcheck=""+user.getUID();
	String customerDepartment=""+RecordSetC.getString("department") ;
	
	boolean canview=false;
	boolean canedit=false;
	boolean canviewlog=false;
	boolean canmailmerge=false;
	boolean canapprove=false;
	boolean isCustomerSelf=false;
	
	
	int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
	if(sharelevel>0){
	     canview=true;
	     canviewlog=true;
	     canmailmerge=true;
	     if(sharelevel==2) canedit=true;
	     if(sharelevel==3||sharelevel==4){
	         canedit=true;
	         canapprove=true;
	     }
	}
	
	if(user.getLogintype().equals("2") && CustomerID.equals(useridcheck)){
	isCustomerSelf = true ;
	}
	 if( useridcheck.equals(RecordSetC.getString("agent"))) {
		 canview=true;
		 canedit=true;
		 canviewlog=true;
		 canmailmerge=true;
	
	 }
	if(RecordSetC.getInt("status")==7 || RecordSetC.getInt("status")==8){
		canedit=false;
	}
	
	/*check right end*/
	
	if(!canview && !isCustomerSelf){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(110,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+RecordSetC.getString("id")+"'>"+Util.toScreen(RecordSetC.getString("name"),user.getLanguage())+"</a>";

titlename+="   "+SystemEnv.getHtmlLabelName(110,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+Util.toScreen(RecordSetT.getString("fullname"),user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<% if(canedit || isCustomerSelf) {
	if(isEqual){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(17539,user.getLanguage()) +",javascript:doClick1(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
%>
		<BUTTON  class=Btn accesskey="1"  style="display:none" id=domyfun1  onclick='doClick1()'><U>1</U>-<%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%>&nbsp;<IMG src=/images/BacoCross_wev8.gif border=0 align=absmiddle></BUTTON>
	<%}else{
	
		RCMenu += "{"+SystemEnv.getHtmlLabelName(17540,user.getLanguage())+",javascript:doClick2(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doEdit(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	%>	
		<BUTTON  class=Btn accesskey="1"  style="display:none" id=domyfun2 onclick='doClick2()'><U>1</U>-<%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%>&nbsp;<IMG src=/images/BacoCheck_wev8.gif border=0 align=absmiddle></BUTTON>
		<BUTTON class=btnEdit id=Edit accessKey=E  style="display:none"  onclick='doEdit()'><U>E</U>-<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></BUTTON>
	<%}
}%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(110,user.getLanguage())+SystemEnv.getHtmlLabelName(633,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<%if((canedit || isCustomerSelf) && isEqual){ %>
				<span title="<%=SystemEnv.getHtmlLabelName(17539,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
					<input class="e8_btn_top middle" onclick="doClick1()" type="button"  value="<%=SystemEnv.getHtmlLabelName(17539,user.getLanguage()) %>"/>
				</span>
			<%} %>	
			
			<%if((canedit || isCustomerSelf) && !isEqual){ %>
				<span title="<%=SystemEnv.getHtmlLabelName(17540,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
					<input class="e8_btn_top middle" onclick="doClick2()" type="button"  value="<%=SystemEnv.getHtmlLabelName(17540,user.getLanguage()) %>"/>
				</span>
				<span title="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
					<input class="e8_btn_top middle" onclick="doEdit()" type="button"  value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %>"/>
				</span>
			<%} %>
			
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%>'>
	<%if(isEqual){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>1</wea:item>
		<wea:item><%=Util.toScreen(RecordSetC.getString("address1"),user.getLanguage())%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>2</wea:item>
		<wea:item><%=Util.toScreen(RecordSetC.getString("address2"),user.getLanguage())%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>3</wea:item>
		<wea:item><%=Util.toScreen(RecordSetC.getString("address3"),user.getLanguage())%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
		<wea:item><%=RecordSetC.getString("zipcode")%>  <%=CityComInfo.getCityname(RecordSetC.getString("city"))%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></wea:item>
		<wea:item><%=CountryComInfo.getCountrydesc(RecordSetC.getString("country"))%>  <%=ProvinceComInfo.getProvincename(RecordSetC.getString("province"))%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(644,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(RecordSetC.getString("county"),user.getLanguage())%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></wea:item>
		<wea:item><%=RecordSetC.getString("phone")%>  <%=RecordSetC.getString("fax")%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></wea:item>
		<wea:item><a href="mailto:<%=RecordSetC.getString("email")%>"><%=Util.toScreen(RecordSetC.getString("email"),user.getLanguage())%></a></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></wea:item>
		<wea:item>
			<%
			String contacterId = "";
			String contacterName = "";
			RecordSetC.executeProc("CRM_Find_CustomerContacter", CustomerID);
			RecordSetC.next();
			contacterId = Util.null2String(RecordSetC.getString(1));
			contacterName = Util.null2String(RecordSetC.getString(3));
			%>
			<a href="/CRM/data/ViewContacter.jsp?ContacterID=<%=contacterId%>"><%=contacterName%></a>
		</wea:item>

	<%}else{%>
		<wea:item><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>1</wea:item>
		<wea:item><%=Util.toScreen(RecordSet.getString("address1"),user.getLanguage())%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>2</wea:item>
		<wea:item><%=Util.toScreen(RecordSet.getString("address2"),user.getLanguage())%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>3</wea:item>
		<wea:item><%=Util.toScreen(RecordSet.getString("address3"),user.getLanguage())%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
		<wea:item><%=RecordSet.getString("zipcode")%>  <%=CityComInfo.getCityname(RecordSet.getString("city"))%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></wea:item>
		<wea:item><%=CountryComInfo.getCountrydesc(RecordSet.getString("country"))%>  <%=ProvinceComInfo.getProvincename(RecordSet.getString("province"))%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(644,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(RecordSet.getString("county"),user.getLanguage())%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></wea:item>
		<wea:item><%=RecordSet.getString("phone")%>  <%=RecordSetC.getString("fax")%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></wea:item>
		<wea:item><a href="mailto:<%=RecordSet.getString("email")%>"><%=Util.toScreen(RecordSet.getString("email"),user.getLanguage())%></a></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></wea:item>
		<wea:item>
			<a href="/CRM/data/ViewContacter.jsp?ContacterID=<%=RecordSet.getString("contacter")%>"><%=Util.toScreen(CustomerContacterComInfo.getCustomerContactername(RecordSet.getString("contacter")),user.getLanguage())%></a>
		</wea:item>
 
	<%}%>	
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(17088,user.getLanguage())%>'>
		<%
			CrmFieldComInfo comInfo = new CrmFieldComInfo("CRM_CustomerAddress") ;
			rs.execute("select * from CRM_CustomerAddress where customerid = "+CustomerID+" and typeid = "+TypeID);
			rs.next();
			while(comInfo.next()){
		%>
			<wea:item><%=CrmUtil.getHtmlLableName(comInfo , user)%></wea:item>
			<wea:item><%=CrmUtil.getHmtlElementInfo(comInfo ,rs.getString(comInfo.getFieldname()), user)%></wea:item>
		<%}%>
	</wea:group>
</wea:layout>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script type="text/javascript">

var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);
function doClick1(){
	document.location.href="/CRM/data/AddressOperation.jsp?CustomerID=<%=CustomerID%>&TypeID=<%=TypeID%>&method=toNoEqual";
}
function doClick2(){
	location.href="/CRM/data/AddressOperation.jsp?CustomerID=<%=CustomerID%>&TypeID=<%=TypeID%>&method=toEqual";
}
function doEdit(){
	location.href="/CRM/data/EditAddress.jsp?CustomerID=<%=CustomerID%>&TypeID=<%=TypeID%>&parent=detail"
}
 jQuery(document).ready(function(){
     
    jQuery("input[type=checkbox]").each(function(){
		  if(jQuery(this).attr("tzCheckbox")=="true"){
		   	jQuery(this).tzCheckbox({labels:['','']});
		  }
	 }); 
  });
</script>
</BODY>
</HTML>
