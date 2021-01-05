
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.util.CrmFieldComInfo"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.*" %>
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/CRM/data/uploader.jsp" %>
<%!
/**
 * @Date June 21,2004
 * @Author Charoes Huang
 * @Description 检测是否是个人用户的添加
 */
	private boolean isPerUser(String type){
		RecordSet rs = new RecordSet();
		String sqlStr ="Select * From CRM_CustomerType WHERE ID = "+type+" and candelete='n' and canedit='n' and fullname='个人用户'";
		rs.executeSql(sqlStr);
		if(rs.next()){
			return true;
		}
		return false;
	}
%>
<%

String type = Util.null2String(request.getParameter("type1"));
String name = Util.fromScreen2(Util.null2String(request.getParameter("name1")),user.getLanguage());
Map map = new HashMap();
map.put("type",type);
map.put("name",name);
map.put("manager",user.getUID());

// check the "type" null value added by lupeng 2004-8-9. :)
/*Added by Charoes Huang On June 21,2004*/
if(!type.equals("") && isPerUser(type)){
	//request.getRequestDispatcher("AddPerCustomer.jsp").forward(request,response); 
	//return;
}


boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","c1");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();
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
<SCRIPT language="javascript" src="/hrm/area/browser/areabrowser.js"></script>
<LINK href="/hrm/area/browser/areabrowser.css" type=text/css rel=STYLESHEET>
<style type="">
	input{
		width : 100px;
	}

</style>

<script language=javascript >
var upfilesnum=0;//获得上传文件总数
function checkSubmit(obj){
	window.onbeforeunload=null;
	// if(check_form(weaver,"<%= CrmUtil.getFieldIsMustInfo("CRM_CustomerInfo")%>")){
	if(jQuery("img[src='/images/BacoError_wev8.gif']").length ==0){
		obj.disabled = true; // added by 徐蔚绛 for td:1553 on 2005-03-22
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
 	weaver.submit();
}

function protectCus(){
	if(!checkDataChange())//added by cyril on 2008-06-12 for TD:8828
		event.returnValue="<%=SystemEnv.getHtmlLabelName(18675,user.getLanguage())%>";
}
function mailValid() {
	var emailStr = document.all("CEmail").value;
	emailStr = emailStr.replace(" ","");
	if (!checkEmail(emailStr)) {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");
		document.all("CEmail").focus();
		return;
	}
}
function checktext(){
	if(document.all("introduction").value.length>100){
		document.all("introduction").value=document.all("introduction").value.substring(0,99);
		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(84349,user.getLanguage())%>100');
		return;
	
	}


}

 jQuery(document).ready(function(){
    //绑定附件上传
    if(jQuery("div[name=uploadDiv]").length>0){
    	jQuery("div[name=uploadDiv]").each(function(){
	    	
	        bindUploaderDiv($(this)); 
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

</HEAD>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY onbeforeunload="protectCus()">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location='/CRM/data/AddCustomerExist.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="checkSubmit(this)" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
<div class="zDialog_div_content" style="padding-bottom: 20px;">
<FORM id=weaver name= weaver action="/CRM/data/CustomerOperation.jsp" method=post enctype="multipart/form-data">
<input type="hidden" name="method" value="add">

<wea:layout type="4Col" attributes="{'expandAllGroup':'true'}">
		
	<%
	CrmFieldComInfo comInfo = new CrmFieldComInfo() ;
	rs.execute("select t1.*,t2.* from CRM_CustomerDefinFieldGroup t1  left join "+
			"(select groupid,count(groupid) groupcount from CRM_CustomerDefinField where isopen=1 and usetable = 'CRM_CustomerInfo' group by groupid) t2 "+
			"on t1.id=t2.groupid "+
			"where t1.usetable = 'CRM_CustomerInfo' and t2.groupid is not null order by t1.dsporder asc");
	while(rs.next()){
		String groupid = rs.getString("id");
		int groupcount = Util.getIntValue(rs.getString("groupcount"),0);
		if(0 == groupcount){
			continue;
		}
		%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(rs.getInt("grouplabel"),user.getLanguage())%>' attributes="{'isColspan':'false'}">
			<% while(comInfo.next()){
				if("CRM_CustomerInfo".equals(comInfo.getUsetable())&&groupid.equals(comInfo.getGroupid().toString())){
			%>
				<wea:item><%=CrmUtil.getHtmlLableName(comInfo , user)%></wea:item>
				<wea:item><%=CrmUtil.getHtmlElementSetting(comInfo ,Util.null2String(map.get(comInfo.getFieldname())), user)%></wea:item>
			<%}}%>	
		</wea:group>
		
	<%}%>
		
</wea:layout>
</FORM>
</div>
</BODY>
</HTML>
