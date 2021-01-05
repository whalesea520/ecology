
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.util.CrmFieldComInfo"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/CRM/data/uploader.jsp" %>
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String TypeID = Util.null2String(request.getParameter("TypeID"));
char flag = 2;

RecordSetT.executeProc("CRM_AddressType_SelectByID",TypeID);
if(RecordSetT.getFlag()!=1)
{
	response.sendRedirect("/CRM/DBError.jsp?type=FindData_EA0");
	return;
}
RecordSetT.first();

RecordSetC.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSetC.getCounts()<=0){
	response.sendRedirect("/base/error/DBError.jsp?type=FindData_EA1");
	return;
}
RecordSetC.first();

boolean isNull = false;
RecordSet.executeProc("CRM_CustomerAddress_Select",TypeID+flag+CustomerID);
if(RecordSet.getCounts()<=0){//新增地址，之前没有过客户地址信息
	RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
	isNull = true;
}
RecordSet.first();

boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","c3");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();

/*权限判断－－Begin*/

String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSetC.getString("department") ;
boolean canedit=false;
boolean isCustomerSelf=false;

//String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype=1 and userid="+user.getUID();

//RecordSetV.executeSql(ViewSql);

//if(RecordSetV.next())
//{
//	 if(RecordSetV.getString("sharelevel").equals("2") || RecordSetV.getString("sharelevel").equals("3") || RecordSetV.getString("sharelevel").equals("4")){
//		canedit=true;	
//	 }
//}
int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>1) canedit=true;

if(user.getLogintype().equals("2") && CustomerID.equals(useridcheck)){
isCustomerSelf = true ;
}
if(useridcheck.equals(RecordSetC.getString("agent"))){ 
	 canedit=true;
 }

if(RecordSetC.getInt("status")==7 || RecordSetC.getInt("status")==8){
	canedit=false;
}

/*权限判断－－End*/

if(!canedit && !isCustomerSelf) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
 }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>

<SCRIPT language="javascript" src="/hrm/area/browser/areabrowser_wev8.js"></script>
<LINK href="/hrm/area/browser/areabrowser.css" type=text/css rel=STYLESHEET>

</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(110,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+RecordSetC.getString("id")+"'>"+Util.toScreen(RecordSetC.getString("name"),user.getLanguage())+"</a>";

String temStr="";
temStr+=SystemEnv.getHtmlLabelName(110,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+Util.toScreen(RecordSetT.getString("fullname"),user.getLanguage());
titlename+="&nbsp;&nbsp;&nbsp;&nbsp;"+temStr;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(110 ,user.getLanguage())+SystemEnv.getHtmlLabelName(87 ,user.getLanguage())%>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="zDialog_div_content" style="height: 445px;">
<FORM id=weaver name=weaver action="/CRM/data/AddressOperation.jsp" method=post onsubmit='return check_form(this,"Address1")'>
<input type="hidden" name="method" value="add">
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
<input type="hidden" name="TypeID" value="<%=TypeID%>">
<wea:layout attributes="{'expandAllGroup':'true'}">

	<%
	CrmFieldComInfo comInfo = new CrmFieldComInfo() ;
	rs.execute("select t1.*,t2.* from CRM_CustomerDefinFieldGroup t1 left join "+
			"(select groupid,count(groupid) groupcount from CRM_CustomerDefinField where isopen=1 and usetable = 'CRM_CustomerAddress' group by groupid) t2 on t1.id=t2.groupid "+
			"where t1.usetable = 'CRM_CustomerAddress' and t2.groupid is not null order by t1.dsporder asc");
	while(rs.next()){
		String groupid = rs.getString("id");
		int groupcount = Util.getIntValue(rs.getString("groupcount"),0);
		if(0 == groupcount){
			continue;
		}
		%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(rs.getInt("grouplabel"),user.getLanguage())%>'>
			<% while(comInfo.next()){
				if("CRM_CustomerAddress".equals(comInfo.getUsetable())&&groupid.equals(comInfo.getGroupid().toString())){
					if(comInfo.getFieldname().equals("city")||comInfo.getFieldname().equals("district")){%>
					<wea:item><%=CrmUtil.getHtmlLableName(comInfo , user)%></wea:item>
					<wea:item>
						<div areaType="<%=comInfo.getFieldname().equals("district")?"citytwo":comInfo.getFieldname() %>" areaName="<%=comInfo.getFieldname() %>" areaValue="" 
							areaSpanValue=""  areaMustInput="1"  areaCallback="callBack"  class="_areaselect" id="_areaselect_<%=comInfo.getFieldname() %>id"></div>																	
					</wea:item>						
				<% 	}else{
				%>
					<wea:item><%=CrmUtil.getHtmlLableName(comInfo , user)%></wea:item>
					<wea:item><%=CrmUtil.getHtmlElementSetting(comInfo ,"", user)%></wea:item>
				<%	}
			}}%>	
		</wea:group>
	<%} %>	
</wea:layout>
</FORM>
</div>

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
<script type="text/javascript">

var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);
var upfilesnum=0;//获得上传文件总数

function doSave(){
	obj.disabled = true; // added by 徐蔚绛 for td:1553 on 2005-03-22
	if(jQuery("img[src='/images/BacoError_wev8.gif']").length ==0){
		jQuery("div[name=uploadDiv]").each(function(){
	  		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
	    	if(oUploader.getStats().files_queued>0){
	    		upfilesnum+=oUploader.getStats().files_queued;
	    		oUploader.startUpload();
	    	}
	    });
	    if(upfilesnum==0) doSaveAfterAccUpload();
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
	}
	
}

function doSaveAfterAccUpload(){
	window.weaver.submit();
}

jQuery(document).ready(function(){

	areromancedivs();
   //绑定附件上传
   if(jQuery("div[name=uploadDiv]").length>0){
    	jQuery("div[name=uploadDiv]").each(function(){
	    	
	        bindUploaderDiv($(this)); 
	        // alert(this).find("#uploadspan").length);
	        jQuery(this).find("#uploadspan").append($(this).attr("checkinputImage"));
	        
	        if($(this).attr("ismust") == 1){
		        var fieldNameSpan = $(this).attr("fieldNameSpan");
		        jQuery(this).find(".progressCancel.progressCancel").live("click",function(){
		        	
		       		var childLength = jQuery(this).parents(".fieldset").find(".progressWrapper:visible[id!='"+jQuery(this).parents(".progressWrapper").attr("id")+"']").length;  
					 if(childLength==0){
					 	if(jQuery("#"+fieldNameSpan).html()==""){
					 		jQuery("#"+fieldNameSpan).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					 	}
					 }    
		        });
	        }
    	});
    } 
    
   jQuery("input[type=checkbox]").each(function(){
	  if(jQuery(this).attr("tzCheckbox")=="true"){
	   	jQuery(this).tzCheckbox({labels:['','']});
	  }
 	});
 });
</script>
</BODY>
</HTML>
