
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%--@ page import="weaver.general.Util" --%>

<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String type = Util.null2String(request.getParameter("type"));
String name = Util.fromScreen2(Util.null2String(request.getParameter("name")).trim(),user.getLanguage());
String CRM_CustomerInfo_SelectName = "";
String TooManyRecord = "";
if(!name.equals("")){
	CRM_CustomerInfo_SelectName = "select count(id) recordcount from CRM_CustomerInfo where deleted<>1 and name like '%" + name +"%'" ;
	RecordSet.executeSql(CRM_CustomerInfo_SelectName);
	if(RecordSet.next()){

		if(RecordSet.getInt("recordcount")>20){
			TooManyRecord="true";
		}else{
			CRM_CustomerInfo_SelectName = "select * from CRM_CustomerInfo where deleted<>1 and name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%'" ;
			RecordSet.executeSql(CRM_CustomerInfo_SelectName);
			TooManyRecord="false";
		}
	}
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'name')){
        weaver.submit();
    }
}

function doNext() {
 
  //alert ("/CRM/data/AddCustomer.jsp?name1="+document.weaver.name.value+"&type1="+document.weaver.type.value);
  //modify by xhheng @20050221 for TD 1321
  document.location.href="/CRM/data/AddCustomer.jsp?name1="+document.weaver.name.value+"&type1="+document.weaver.type.value;<%--Modified by xwj for td1552 on 2005-03-22--%>
}
function setCustomerName(){
	
	jQuery("input[name='name']").val(jQuery("#name2").val());
	if(check_form(weaver,'name')){
        weaver.submit();
    }
	
}

jQuery(function(){
	checkinput("name","Nameimage");
	
	<%if(TooManyRecord.equals("false")&&RecordSet.getCounts()==0){%>
		document.continue1.submit() ;
	<%}%>
});
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

if(TooManyRecord.equals("false")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1256,user.getLanguage())+",javascript:doNext(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=continue1 name= continue1 action="/CRM/data/AddCustomer.jsp" method=post >
<input type="hidden" name="name1" value="<%=name%>">
<input type="hidden" name="type1" value="<%=type%>">
</form>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="checkSubmit()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>



<FORM id=weaver name= weaver action="/CRM/data/AddCustomerExist.jsp" method=post onsubmit='return check_form(this,"name")'>
<wea:layout type="2col" attributes="{cw1:50,cw2:200}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
		<wea:item>
			 <select class=InputStyle  name=type style="width: 150px;">
			  <%
				String isSelect="";
				while (CustomerTypeComInfo.next()) {
					isSelect="";
					if(type.equals(CustomerTypeComInfo.getCustomerTypeid())){
						isSelect="Selected";
					}
			  %>
			  	<option value="<%=CustomerTypeComInfo.getCustomerTypeid()%>"  <%=isSelect%>>
			  		<%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(),user.getLanguage())%></option>
			  <%}%>
		  </select>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="Nameimage" required="true">
				<INPUT class=InputStyle maxLength=100 name="name" 
					onchange='checkinput("name","Nameimage")' STYLE="width:250px" value="<%=name%>" 
						onkeydown="if(event.keyCode==222){return false;}">
			</wea:required>
		</wea:item>
		
		<wea:item attributes="{colspan:2}"><%=SystemEnv.getHtmlLabelName(20272,user.getLanguage())%></wea:item>
		
		<wea:item attributes="{colspan:2}"><%=SystemEnv.getHtmlLabelName(20273,user.getLanguage())%></wea:item>
		
		
		<%
		if(TooManyRecord.equals("true")){%>
			<wea:item attributes="{colspan:2}">
			<P><span class=fontred><%=SystemEnv.getHtmlLabelName(15126,user.getLanguage())%>!</span></P>
			</wea:item>
		<%}%>
		
	</wea:group>
</wea:layout>

<%if(RecordSet.getCounts()>0){ %>
		<wea:layout attributes="{cols:5}" type="table">
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%></wea:item>
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></wea:item>					
			
				
				<%while(RecordSet.next()){%>
					<wea:item><a target="_blank" href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString(1)%>"><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></a></wea:item>
					<wea:item><%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(RecordSet.getString("type")),user.getLanguage())%></wea:item>
					<wea:item><%=Util.toScreen(RecordSet.getString("typebegin"),user.getLanguage())%></wea:item>
					<wea:item><%=Util.toScreen(CityComInfo.getCityname(RecordSet.getString("city")),user.getLanguage())%></wea:item>
					<wea:item><a target="_blank" href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("manager")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%></a></wea:item>
				<%} %>
			</wea:group>			
		</wea:layout>		
<%} %>

</FORM>



</BODY>
</HTML>
