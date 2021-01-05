
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordAddress" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
char flag = 2;
RecordSet.executeProc("CRM_AddressType_SelectAll","");
if(RecordSet.getFlag()!=1)
{
	response.sendRedirect("/CRM/DBError.jsp?type=FindData");
	return;
}

RecordSetC.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSetC.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
RecordSetC.first();

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
 if(useridcheck.equals(RecordSetC.getString("agent"))) {
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
<style type="">
.hoverDivChild{
		color:#0071c2;
		filter: alpha(opacity = 100);
		-moz-opacity: 1;
		opacity: 1; 
		background-color:#b6e1fd;
        overflow:hidden;   
        z-index:10003;
}
	
.operHoverSpanChild{
	height:100%;
	display:-moz-inline-box;
	display:inline-block;color:#656867;padding-left:5px;padding-right:5px;
}
.operHover_handChild{
	cursor:pointer;
}
.operHoverSpan_hoverChild{
	color:#0071c2;
}

.operHoverSpanChild a{
	text-decoration: none!important;
	color:gray!important;
}

.operHoverSpanChild a:hover{
	color:#0071c2!important;
}

.e8operateChild{
	background-image:url("/images/ecology8/operate_wev8.png");
	background-repeat:no-repeat;
	width:16px;
	background-position:50% 50%;
	height:25px;
	cursor:pointer;
	float:right;
}

</style>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(110,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+RecordSetC.getString("id")+"'>"+Util.toScreen(RecordSetC.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{colspan:2,'isTableList':'true'}">
			<wea:layout type="table" attributes="{'cols':'5','cws':'20%,20%,20%,20%,20%'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(84368,user.getLanguage())%>'>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(377,user.getLanguage()) %></wea:item>
		        	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(800,user.getLanguage()) %></wea:item>
		        	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(493,user.getLanguage()) %></wea:item>
		        	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(110,user.getLanguage()) %></wea:item>
		        	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1899,user.getLanguage()) %></wea:item>
		        	
	        		<wea:item><%=CountryComInfo.getCountrydesc(RecordSetC.getString("country"))%> </wea:item>
	        		<wea:item><%=ProvinceComInfo.getProvincename(RecordSetC.getString("province"))%></wea:item>
	        		<wea:item><%=CityComInfo.getCityname(RecordSetC.getString("city"))%></wea:item>
	        		<wea:item><%=Util.toScreen(RecordSetC.getString("address1"),user.getLanguage())%></wea:item>
	        		<wea:item><%=Util.toScreen(RecordSetC.getString("zipcode"),user.getLanguage())%></wea:item>
				</wea:group>
			</wea:layout>
		</wea:item>
		
   	 <%	
       	while(RecordSet.next()){ 
       		String title = RecordSet.getString("fullname");
       		String typeid = RecordSet.getString("id");
       		
       		RecordAddress.execute("select city, id, country ,province,county,address1 ,  zipcode"+
					" from CRM_CustomerAddress where typeid = "+typeid+" and customerid = "+CustomerID);
       		String info = RecordAddress.getCounts() == 0 ?"{'itemAreaDisplay':'none'}":"";
       		
     %>
	    <wea:item attributes="{colspan:2,'isTableList':'true'}">
	    	<wea:layout type="table" attributes="{'cols':'6','cws':'2%,19%,19%,19%,19%,19%'}">
	    		<wea:group context='<%=title %>' attributes="<%=info %>">
   					<wea:item type="groupHead">
   						<input type="button" class="addbtn" onclick="addAddress(<%=RecordSet.getString("id") %>)" />
	        		 	<input type="button" class="delbtn" onclick="deleteInfo(<%=RecordSet.getString("id") %>)" />
        		 	</wea:item>
	    			
	    			
	    			<wea:item type="thead"><input type="checkbox" typeid='<%=typeid%>' class="checkall"></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(377,user.getLanguage()) %></wea:item>
		        	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(800,user.getLanguage()) %></wea:item>
		        	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(493,user.getLanguage()) %></wea:item>
		        	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(110,user.getLanguage()) %></wea:item>
		        	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1899,user.getLanguage()) %></wea:item>
					
					
					
					<%while(RecordAddress.next()){%>
						<wea:item><input type="checkbox" addressid='<%=RecordAddress.getString("id") %>' class="check_<%=typeid %>"></wea:item>
						<wea:item><%=CountryComInfo.getCountrydesc(RecordAddress.getString("country"))%> </wea:item>
						<wea:item><%=ProvinceComInfo.getProvincename(RecordAddress.getString("province"))%></wea:item>
						<wea:item><%=CityComInfo.getCityname(RecordAddress.getString("city"))%></wea:item>
						<wea:item><%=RecordAddress.getString("address1")%></wea:item>
						<wea:item>
							<%=RecordAddress.getString("zipcode").trim()%>
							<div class="e8operateChild" style="position:absolute; top: 2px;right:0px;float:right; ">&nbsp;</div>
							<div class="hoverDivChild" style="position:absolute; top: 2px;right:0px;height: 30px; line-height: 30px; float:right !important;display:none; text-align: right !important;">
								<span class="operHoverSpanChild operHover_handChild">
									<a href="javascript:showAddress(<%=RecordAddress.getString("id") %>)" target="_self" title="<%=SystemEnv.getHtmlLabelName(367,user.getLanguage()) %>">
										&nbsp;<%=SystemEnv.getHtmlLabelName(367,user.getLanguage()) %>&nbsp;
									</a>
								</span>
							
							
								<span class="operHoverSpanChild operHover_handChild">
									<a href="javascript:void(0)" onclick="javascript:deleteAddress(<%=RecordAddress.getString("id") %>)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>">
										&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>&nbsp;
									</a>
								</span>
							
							</div>
						</wea:item>
					<%} %>
	    		</wea:group>
	    	</wea:layout>
	    </wea:item>    
	        
    <%} %>	
	</wea:group>
</wea:layout>
<script type="text/javascript">

var dialog=null;

function callback(){
	if(dialog)
		dialog.close();
	location.reload();
}
jQuery(function(){
	jQuery(".e8operateChild").parents("td").css("position","relative");

	jQuery(".checkall").bind("click",function(){
		var typeid = jQuery(this).attr("typeid")
		changeCheckboxStatus(jQuery(".check_"+typeid),jQuery(this).is(":checked"));
	});
	
	jQuery(".e8operateChild").hover(
		function(){
			jQuery(this).parent("td").find(".hoverDivChild").show();
		},
		function(){
			jQuery(this).parent("td").find(".hoverDivChild").hide();
		}
	)
	
	jQuery(".hoverDivChild").hover(
		function(){
			jQuery(this).show();
		},
		function(){
			jQuery(this).hide();
		}
	)
});



function addAddress(typeid){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/CRM/data/AddAddress.jsp?TypeID="+typeid+"&CustomerID=<%=CustomerID%>";
	dialog.Title ="<%=SystemEnv.getHtmlLabelName(611 ,user.getLanguage())+SystemEnv.getHtmlLabelName(110 ,user.getLanguage())+SystemEnv.getHtmlLabelName(87 ,user.getLanguage())%>";
	
	dialog.Width = 550;
	dialog.Height =550;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function deleteInfo(typeid){
	if(jQuery(".check_"+typeid+":checked").length == 0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686 ,user.getLanguage())%>");
		return;
	}
	
	var obj = jQuery(".check_"+typeid+":checked");
	var ids = "";
	for(var i=0; i< obj.length ; i++){
		ids += jQuery(obj[i]).attr("addressid")+",";
	}
	ids = ids.substring(0,ids.length-1);
	deleteAddress(ids)
}

function deleteAddress(addressid){
	
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097 ,user.getLanguage())%>",function(){
		jQuery.post("AddressOperation.jsp",{"method":"deleteInfo","ids":addressid},function(){
			location.reload();
		});
	})
}



function showAddress(addressid){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/CRM/data/EditAddress.jsp?id="+addressid+"&CustomerID=<%=CustomerID%>";
	dialog.Title ="<%=SystemEnv.getHtmlLabelName(367 ,user.getLanguage())+SystemEnv.getHtmlLabelName(110 ,user.getLanguage())+SystemEnv.getHtmlLabelName(87 ,user.getLanguage())%>";
	
	dialog.Width = 550;
	dialog.Height =550;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</BODY>
</HTML>
