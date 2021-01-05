
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
//检查是否有修改经理权限项
if(HrmUserVarify.checkUserRight("EditCustomer:Delete", user)){

}else{
	response.sendRedirect("/notice/noright.jsp") ;
}

String customerids = Util.null2String(request.getParameter("customerids"));
String method = Util.null2String(request.getParameter("method"));
if("change".equals(method)){
	String relatedshareid = Util.null2String(request.getParameter("relatedshareid"));
	//遍历修改客户数据
	if(customerids.endsWith(","))customerids = customerids.substring(0, customerids.length()-1);
	if(!"".equals(customerids)) {
		RecordSet.executeSql("select id,manager as str from crm_CustomerInfo where id in ("+customerids+")");
		String id = "";
		String str = "";
		while(RecordSet.next()){
			id = RecordSet.getString("id");
			str = RecordSet.getString("str");
			rs.executeSql("update CRM_CustomerInfo set manager ='"+relatedshareid+"' where id="+id);
			rs.executeSql("delete from CRM_shareinfo where contents="+str+" and sharetype=1 and relateditemid="+id);

			//修改客户经理重置客户共享
			CrmShareBase.setCRM_WPShare_newCRMManager(id);
			//添加新客户标记
			CustomerModifyLog.modify(id,str,relatedshareid);
		}
	}
	
	//遍历修改结束
	out.println("<script>parent.getParentWindow(window).changeCallback();</script>");
}

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="修改人员"/>
</jsp:include>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="doSave()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
<div class="zDialog_div_content" style="height:196px;">
<FORM id=weaver name=weaver action="/CRM/data/viewHrm.jsp" method=post onsubmit='return check_form(this,"relatedshareid")'>
<input type="hidden" name="method" value="change">
<input type="hidden" name="customerids" value="<%=customerids%>">
<wea:layout>
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21956,user.getLanguage())%></wea:item>
		<wea:item attributes="{'customAttrs':'class=field'}">
			<SELECT class=InputStyle name=sharetype onchange="" style="width: 120px;">
			  <option value="1" selected=selected><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
			</SELECT>
		</wea:item>
		<wea:item attributes="{'samePair':'showsharetype'}"><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'showsharetype'}">
			<div id="resourceDiv">
				<brow:browser viewType="0" name="relatedshareid" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp" width="200px" ></brow:browser> 
			</div>
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

<script language="javascript">
	
	var dialog = parent.getDialog(window); 
	var parentWin = parent.getParentWindow(window);
	jQuery(function(){
		jQuery("#resourceDiv").show();
		hideEle('showseclevel','true');
		jQuery("#resourceDiv").show();
	});
  
	function doSave(){
		var checkinfo = "relatedshareid";
	    if(check_form(weaver,checkinfo)){
	    	// enableAllmenu(); //禁用所有按钮
	        weaver.submit();
	    }
	}
</script>
</BODY>
</HTML>
