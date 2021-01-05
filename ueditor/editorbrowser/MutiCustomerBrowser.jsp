
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="RecordSetCT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>

<style type="text/css">
#departmentid, #country1 {
	width:100%;
}
</style>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<%
String name = Util.null2String(request.getParameter("name"));
String engname = Util.null2String(request.getParameter("engname"));
String type = Util.null2String(request.getParameter("type"));
String city = Util.null2String(request.getParameter("City"));
String country1 = Util.null2String(request.getParameter("country1"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("resourceids"));
String crmManager = Util.null2String(request.getParameter("crmManager"));
String sectorInfo = Util.null2String(request.getParameter("sectorInfo"));
String customerStatus = Util.null2String(request.getParameter("customerStatus"));
String customerDesc = Util.null2String(request.getParameter("customerDesc"));
String customerSize = Util.null2String(request.getParameter("customerSize"));

String customerStatusName = CustomerStatusComInfo.getCustomerStatusname(customerStatus);

String customerDescName = Util.null2String(CustomerDescComInfo.getCustomerDescname(customerDesc));
String customerSizeName = Util.null2String(CustomerSizeComInfo.getCustomerSizename(customerSize));
String sectorInfoName = Util.null2String(SectorInfoComInfo.getSectorInfoname(sectorInfo));

String resourceids ="";
String resourcenames ="";

int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
}
if(!engname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.engname like '%" + Util.fromScreen2(engname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and t1.engname like '%" + Util.fromScreen2(engname,user.getLanguage()) +"%' ";
}
if(!type.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.type = "+ type ;
	}
	else
		sqlwhere += " and t1.type = "+ type;
}
if(!city.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.city = " + city ;
	}
	else
		sqlwhere += " and t1.city = " + city ;
}
if(!country1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.country = "+ country1 ;
	}
	else
		sqlwhere += " and t1.country = "+ country1;
}
if(!departmentid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.department =" + departmentid +" " ;
	}
	else
		sqlwhere += " and t1.department =" + departmentid +" " ;
}
if(!crmManager.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.manager =" + crmManager +" " ;
	}
	else
		sqlwhere += " and t1.manager =" + crmManager +" " ;
}
if(!sectorInfo.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.sector = "+ sectorInfo ;
	}
	else
		sqlwhere += " and t1.sector = "+ sectorInfo;
}
if(!customerStatus.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.status = "+ customerStatus ;
	}
	else
		sqlwhere += " and t1.status = "+ customerStatus;
}else{
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.status <>1 ";
	}
	else
		sqlwhere += " and t1.status <>1 ";
}
if(!customerDesc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.description = "+ customerDesc ;
	}
	else
		sqlwhere += " and t1.description = "+ customerDesc;
}
if(!customerSize.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.size_n = "+ customerSize ;
	}
	else
		sqlwhere += " and t1.size_n = "+ customerSize;
}

String sqlstr = "";
if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.id != 0 " ;
}

String temptable1="";
String leftjointable = CrmShareBase.getTempTableByBrowser(""+user.getUID());

//添加判断权限的内容--new*/
if(user.getLogintype().equals("1")){
   temptable1="  CRM_CustomerInfo t1 "+sqlwhere+" and t1.deleted<>1 and "+leftjointable;
}else{
   temptable1="  CRM_CustomerInfo t1 "+sqlwhere+" and t1.deleted<>1 and t1.agent="+user.getUID();
}

%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.weaver.submit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.weaver.reset(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</HEAD>

<BODY>
<div class="zDialog_div_content">
<FORM id=weaver  name=weaver STYLE="margin-bottom:0" action="MutiCustomerBrowser.jsp" method=post>
<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
<input type="hidden" name="pagenum" value=''>
<input type="hidden" name="resourceids" value="">
<input type="hidden" name="crmManager" value="<%=crmManager%>">
<input type="hidden" name="temptable1" value="<%=temptable1 %>">

<wea:layout type="4col">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></wea:item>
		<wea:item><input class=InputStyle  name=name value='<%=name%>' style="width: 150px;"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle  name=engname value="<%=engname%>" style="width: 150px;">
		</wea:item>
		
		
		<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=InputStyle id=type name=type style="width: 150px;">
			<option value=""></option>
			<%if(!Util.null2String(request.getParameter("sqlwhere")).equals("where t1.type in (3,4)")){%>
				<%while(CustomerTypeComInfo.next()){%>		  
					  <option value="<%=CustomerTypeComInfo.getCustomerTypeid()%>" <%if(type.equalsIgnoreCase(CustomerTypeComInfo.getCustomerTypeid())) {%>selected<%}%>><%=CustomerTypeComInfo.getCustomerTypename()%></option>
				<%}%>
			<%}else{%>
				<%while(CustomerTypeComInfo.next()){
					if(CustomerTypeComInfo.getCustomerTypeid().equals("3") || CustomerTypeComInfo.getCustomerTypeid().equals("4")){
				%>		  
					 <option value="<%=CustomerTypeComInfo.getCustomerTypeid()%>" <%if(type.equalsIgnoreCase(CustomerTypeComInfo.getCustomerTypeid())) {%>selected<%}%>><%=CustomerTypeComInfo.getCustomerTypename()%></option>
					<%}
				}%>
			<%}%>
			</select>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="City" 
			 browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp"
			 browserValue='<%=city%>' 
			 browserSpanValue = '<%=CityComInfo.getCityname(city)%>'
			 isSingle="true" hasBrowser="true"  hasInput="false" isMustInput='1'
			 completeUrl="/data.jsp?type=58" width="80%" ></brow:browser> 
		</wea:item>
		
		
		<%if(!user.getLogintype().equals("2")){%>
	
			<wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></wea:item>
			<wea:item>
				<select class=InputStyle id=country1 name=country1 style="width: 150px;">
					<option value=""></option>
					<%while(CountryComInfo.next()){%>		  
				  		<option value="<%=CountryComInfo.getCountryid()%>" <%if(country1.equalsIgnoreCase(CountryComInfo.getCountryid())) {%>selected<%}%>><%=CountryComInfo.getCountryname()%></option>
				  	<%}%>
				</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
			<wea:item>
				<select class=InputStyle style="width: 150px;" id=departmentid name=departmentid>
					<option value=""></option>
					<% while(DepartmentComInfo.next()) {  
						String tmpdepartmentid = DepartmentComInfo.getDepartmentid() ;
					%>
					  <option title="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(),user.getLanguage())%>" value=<%=tmpdepartmentid%> <% if(tmpdepartmentid.equals(departmentid)) {%>selected<%}%>>
					  <%=Util.toScreen(DepartmentComInfo.getDepartmentname(),user.getLanguage())%></option>
					<%}%>
				</select>
			</wea:item>
		<%}else{%>
			<wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></wea:item>
			<wea:item>
				<select class=InputStyle id=country1 name=country1 style="width: 150px;">
					<option value=""></option>
					<%while(CountryComInfo.next()){%>		  
					  <option value="<%=CountryComInfo.getCountryid()%>" <%if(country1.equalsIgnoreCase(CountryComInfo.getCountryid())) {%>selected<%}%>><%=CountryComInfo.getCountryname()%></option>
					<%}%>
				</select>
			</wea:item>
			<wea:item></wea:item><wea:item> </wea:item>
		<%}%>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="customerStatus" style="width: 150px;">
				<option value="">全部</option>
				<%
					RecordSetCT.execute("select id , fullname from CRM_CustomerStatus");
					while(RecordSetCT.next()){
						String tmpid = RecordSetCT.getString("id");
						if(customerStatus.equals(tmpid)){
							out.println("<option value='"+tmpid+"' selected='selected' >"+RecordSetCT.getString("fullname")+"</optin>");
						}else{
							out.println("<option value='"+tmpid+"'>"+RecordSetCT.getString("fullname")+"</optin>");
						}
					}
		
				%>
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="customerDesc" style="width: 150px;">
				<option value="">全部</option>
				<%
					RecordSetCT.execute("select id , fullname from CRM_CustomerDesc");
					while(RecordSetCT.next()){
						String tmpid=RecordSetCT.getString("id");
						if(customerDesc.equals(tmpid)){
							out.println("<option value='"+tmpid+"' selected='selected' >"+RecordSetCT.getString("fullname")+"</optin>");
						}else{
							out.println("<option value='"+tmpid+"'>"+RecordSetCT.getString("fullname")+"</optin>");
						}
					}
				%>
			</select>
		</wea:item>	
	
	
		<wea:item><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="customerSize" style="width: 150px;">
				<option value="">全部</option>
				<%
					RecordSetCT.execute("select id , fullname from CRM_CustomerSize");
					while(RecordSetCT.next()){
						String tmpid=RecordSetCT.getString("id");
						if(customerSize.equals(tmpid)){
							out.println("<option value='"+tmpid+"' selected='selected' >"+RecordSetCT.getString("fullname")+"</optin>");
						}else{
							out.println("<option value='"+tmpid+"'>"+RecordSetCT.getString("fullname")+"</optin>");
						}
					}
				%>
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="sectorInfo"  
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp"
		         browserValue='<%=sectorInfo%>' 
		         browserSpanValue = '<%=sectorInfoName%>'
		         isSingle="true" hasBrowser="true"  hasInput="false" isMustInput='1'
		         completeUrl="/data.jsp?type=sector" width="80%" ></brow:browser>
		         
		</wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context=""  attributes="{'groupDisplay':'none'}">
					<wea:item>
						<div id="dialog">
							<div id='colShow'></div>
						</div>
					</wea:item>
				</wea:group>
			</wea:layout>
		</wea:item>
	</wea:group>
	
</wea:layout>

</FORM>	
</div>


	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>


</BODY></HTML>

<script type="text/javascript">

var parentWin = null;
var dialog = null;
try{
	dialog = parent.getDialog(window);
}catch(e){}

var temptable1 = "<%=temptable1%>";
jQuery(document).ready(function(){
 		showMultiDocDialog("<%=check_per%>");
});


function showMultiDocDialog(selectids){
	
	var config = null;
	config= rightsplugingForBrowser.createConfig();
    config.srchead=["<%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%>"];
    config.container =$("#colShow");
    config.searchLabel="";
    config.hiddenfield="id";
    config.saveLazy = true;//取消实时保存
    config.srcurl = "/CRM/data/MutiCustomerBrowserAjax.jsp?src=src";
    config.desturl = "/CRM/data/MutiCustomerBrowserAjax.jsp?src=dest&resourceids=<%=check_per%>";
    config.pagesize = 10;
    config.formId = "weaver";
    config.selectids = selectids;
	try{
		config.dialog = dialog;
	}catch(e){
	    dialog.close();
	}
   	jQuery("#colShow").html("");
    rightsplugingForBrowser.createRightsPluing(config);
    jQuery("#btnok").bind("click",function(){
		 dialog.OKEvent();
    });
    jQuery("#btncancel").bind("click",function(){
    	  dialog.close();
    });
    jQuery("#btnsearch").bind("click",function(){
    	rightsplugingForBrowser.system_btnsearch_onclick(config);
    });
}
function btnOnSearch(){
 jQuery("#btnsearch").trigger("click");
}


var btnok_onclick = function(){
       dialog.OKEvent();
}

var btnclear_onclick = function(){
	jQuery("#btnclear").click();
}

function onClose(){
	 if(dialog){
    	dialog.close()
    }else{
	    window.parent.close();
	}
}
</script>

