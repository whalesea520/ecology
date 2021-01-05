
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.common.util.string.StringUtil"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
	String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage()) + SystemEnv.getHtmlLabelName(216,user.getLanguage());
	String customerId=Util.null2String(request.getParameter("customerId"));
	String contacterId=Util.null2String(request.getParameter("contacterId"));
	String parentid=Util.null2String(request.getParameter("parentid"));
	String direction=Util.null2String(request.getParameter("direction"));
	String name= "";
	String jobtitle= "";
	String email= "";
	String mobilephone= "";
	String phoneoffice= "";
	String imcode= "";
	String attitude= "";
	String attention= "";
	String title= "";
	
	if(StringUtil.isNotNullAndEmpty(contacterId)){
		RecordSet rs = new RecordSet();
		rs.execute("select firstname,jobtitle,email,mobilephone,phoneoffice,imcode,attitude,attention,title from crm_customercontacter where id = "+contacterId);
		rs.first();
		name=Util.null2String(rs.getString("firstname"));
		jobtitle=Util.null2String(rs.getString("jobtitle"));
		email=Util.null2String(rs.getString("email"));
		mobilephone=Util.null2String(rs.getString("mobilephone"));
		phoneoffice=Util.null2String(rs.getString("phoneoffice"));
		imcode=Util.null2String(rs.getString("imcode"));
		attitude=Util.null2String(rs.getString("attitude"));
		attention=Util.null2String(rs.getString("attention"));
		title=Util.null2String(rs.getString("title"));
	}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	String titleName = SystemEnv.getHtmlLabelName(81294,user.getLanguage());
	if(StringUtil.isNotNullAndEmpty(contacterId)){
		titleName = SystemEnv.getHtmlLabelName(31229,user.getLanguage());
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=titleName%>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input id="mindnew" class="e8_btn_top middle" onclick="doSave()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver action="" method=post >
<wea:layout type="2col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(25034,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<wea:required id="firstnameimage" required="true">
					<input  class=inputstyle style="width: 300px" type=text name=firstname value="<%=name %>" onchange='checkinput("firstname","firstnameimage")'>
				</wea:required>
			</wea:item>
			
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<wea:required id="titleimage" required="true">
				<select id="title"  name=title  onchange='checkinput("title","titleimage")'>
					<option value="" ></option>
					<%
					String sqlTitle = "select id ,fullname from CRM_ContacterTitle ";
					RecordSet rsTitle = new RecordSet();
					rsTitle.execute(sqlTitle);
					while(rsTitle.next()){
						String id = Util.null2o(rsTitle.getString("id"));
						String fullname = Util.null2String(rsTitle.getString("fullname"));
						if(title.equals(id)){%>
							<option value="<%=id %>" selected="selected"><%=fullname%></option>
						<%}else{%>
							<option value="<%=id %>"><%=fullname%></option>
						<% }}%>
					</select>
					</wea:required>
			</wea:item>
			
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<wea:required id="jobtitleimage" required="true">
					<input  class=inputstyle style="width: 300px" type=text name=jobtitle onchange='checkinput("jobtitle","jobtitleimage")' value="<%=jobtitle %>">
				</wea:required>
			</wea:item>
			
			
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<input  class=inputstyle style="width: 300px" type=text name=mobilephone value="<%=mobilephone %>"/>
			</wea:item>
			
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<input  class=inputstyle style="width: 300px" type=text name=phoneoffice value="<%=phoneoffice %>"/>
			</wea:item>
			
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(20869,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<input  class=inputstyle style="width: 300px" type=text name=email value="<%=email %>"/>
			</wea:item>
			
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(25101,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<input  class=inputstyle style="width: 300px" type=text name=imcode value="<%=imcode %>"/>
			</wea:item>
			
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(34060,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<select id="attitude"  name=attitude >
				<option value=""></option>
					<%
					String[] arr = {"支持我方","未表态","未反对","反对"};
					if(StringUtil.isNullOrEmpty(attitude)){%>
					<option value="未表态" selected="selected">未表态</option>
					<option value="支持我方" >支持我方</option>
					<option value="未反对" >未反对</option>
					<option value="反对" >反对</option>
					<%}else{
						for(String a : arr){
							if(attitude.trim().equals(a)){%>
								<option value="<%=a%>" selected="selected"><%=a%></option>
							<%}else{%>
								<option value="<%=a%>"><%=a%></option>
							<% }}}%>
					</select>
			</wea:item>
			
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(84267,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<textarea  class=inputstyle style="width: 300px;height:60px" type=text  name=attention ><%=attention %></textarea>
			</wea:item>
			
		</wea:group>
</wea:layout>
</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

<script language=javascript>
$(function(){
	checkinput("firstname","firstnameimage");
	checkinput("title","titleimage");
	checkinput("jobtitle","jobtitleimage");
	
});
function doSave(){
	if(check_form(weaver,'firstname') && check_form(weaver,'title') && check_form(weaver,'jobtitle')){
			$("#mindnew").attr('value','保存中...');
			$("#mindnew").attr('disabled',true);
			$.post("/CRM/contacter/contacterMindOperate.jsp",
				{ "customerId":"<%=customerId%>",
				  "contacterId":"<%=contacterId%>",//contacterId
				  "direction":"<%=direction%>",
				  "parentid":"<%=parentid%>",
				  "firstname":$("input[name='firstname']").val(),
				  "title":$("select[name='title'] option:selected").val(),
    			  "jobtitle":$("input[name='jobtitle']").val(),
    			  "mobilephone":$("input[name='mobilephone']").val(),
    			  "phoneoffice":$("input[name='phoneoffice']").val(),
    			  "email":$("input[name='email']").val(),
    			  "imcode": $("input[name='imcode']").val(),
    			  "attention": $("textarea[name='attention']").val(),
    			  "attitude": $("select[name='attitude'] option:selected").val()
				}, function(data,status){
			 			parent.tabcontentframe.location.reload();
    					parent.getDialog(window).close();
 					 });
			}
	    }


</script>
</BODY>
</HTML>
