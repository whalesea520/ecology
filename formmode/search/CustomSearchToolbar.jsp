<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<html>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>



<%
String formRightStr = "FormManage:All";
int isFromMode = Util.getIntValue(request.getParameter("isFromMode"),0);
if(isFromMode==1){
	formRightStr = "FORMMODEFORM:ALL";
}

if(!HrmUserVarify.checkUserRight(formRightStr, user))
{
	response.sendRedirect("/notice/noright.jsp");
	
	return;
}
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    int isformadd = Util.getIntValue(request.getParameter("isformadd"),0);
    String dialog = Util.null2String(request.getParameter("dialog"));
    String isclose = Util.null2String(request.getParameter("isclose"));
    String isValue = Util.null2String(request.getParameter("isValue"));
%>

<%
    String imageUrl = Util.null2String(request.getParameter("imageUrl"),"");
	String imageid = Util.null2String(request.getParameter("imageid"),"");
	String imageSource = Util.null2String(request.getParameter("imageSource"),"");
	String searchtype = Util.null2String(request.getParameter("type"),"");
%>

<!-- add by xhheng @20050204 for TD 1538-->
<script language=javascript src="/js/weaver_wev8.js"></script>
</head>
<%
	String type="";
	String formname="";
	String formdes="";
	String tablename = "";
	int modelid = 0;
	int formid = 0;
	int languageid = 0;
	int appid = 0;
    String subCompanyId2 = "";
    String subCompanyId3 = "";
    String defaultUrl = "";
    modelid=Util.getIntValue(Util.null2String(request.getParameter("id")),0);
    String titlename = SystemEnv.getHtmlLabelName(27244,user.getLanguage());//批量操作设置
    if(searchtype.equals("1")){
		//根据id获得相应的模块
		RecordSet.executeSql("select * from mode_customsearch where id=" + modelid);
		if(RecordSet.next()){
			//获得对应模块数据库表字段的名称
	    	formid = Util.getIntValue(RecordSet.getString("formid"),0);
			appid =  Util.getIntValue(RecordSet.getString("appid"),0);
			//获得系统登录的语言
			languageid = user.getLanguage();
			//获得模块后根据formid获得相应表的名称
			if(RecordSet.getString("detailtable")== null || RecordSet.getString("detailtable").equals("")){
				RecordSet.executeSql("select a.*,b.labelname from workflow_billfield a left join htmllabelinfo b  on  a.fieldlabel = b.indexid where (fieldhtmltype='1' or fieldhtmltype='2') and viewtype=0 and a.billid= "+ formid +" and b.languageid="+languageid);		
			}else{
				RecordSet.executeSql("select a.*,b.labelname from workflow_billfield a left join htmllabelinfo b  on  a.fieldlabel = b.indexid where (fieldhtmltype='1' or fieldhtmltype='2') and a.billid= "+ formid +" and b.languageid="+languageid);
			}
	    }
    }else{//如果搜索类型是树形
    	RecordSet.executeSql("select * from mode_customtree where id=" + modelid);
    	if(RecordSet.next()){
    		defaultUrl = Util.null2String(RecordSet.getString("defaultaddress"),"");
    	}
    }
		
	RecordSet2.executeSql("select * from mode_toolbar_search where mainid ="+modelid);
	boolean flag = RecordSet2.next();
	if(flag){
		imageUrl = Util.null2String(RecordSet2.getString("imageUrl"));
		imageid = Util.null2String(RecordSet2.getInt("imageid"))+"";
		imageSource = Util.null2String(RecordSet2.getString("imageSource"));
	}
%>

<body style="overflow-y:hidden;">

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSubmit(),_self} " ;//保存
		RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="addform" id="addform" method="post" action="/formmode/setup/toolbar_search_opreate.jsp" >
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="<%=dialog %>" name="dialog">
<input type="hidden" value="<%=modelid %>" name="modelid"> 
<input type="hidden" value="<%=searchtype %>" name="searchType"> 
<wea:layout type="twoCol">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(125071,user.getLanguage()) %>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(125072,user.getLanguage()) %></wea:item>
		<wea:item>
		    <% if(flag){ if(RecordSet2.getInt("isusedsearch")== 1){%>
			<input type="checkbox" id="isUsedSearch" name="isUsedSearch" value="1" tzCheckbox="true" onClick="formCheckAll(this);" checked="checked" >
		    <% }else{%>
		     <input type="checkbox" id="isUsedSearch" name="isUsedSearch" value="0" tzCheckbox="true" onClick="formCheckAll(this);" >	
		   <%}} else{%>
		    <input type="checkbox" id="isUsedSearch" name="isUsedSearch" value="0" tzCheckbox="true" onClick="formCheckAll(this);" >
		    <%} %>
		    <%if(!searchtype.equals("1")){%>
		    <span><font color='red'>&nbsp;<%=SystemEnv.getHtmlLabelName(125070,user.getLanguage())%></font></span>
		    <%} %>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125073,user.getLanguage()) %></wea:item>
		<wea:item>
		    <% if(flag){%>
			 <input type="text" id="searchName" name="searchName"" value="<%=RecordSet2.getString("searchname")%>" >
		    <% }else{%>
		    <input type="text" id="searchName" name="searchName" value="" >
		    <%} %>
		</wea:item>
		<% if(searchtype.equals("1")){  %>		
		<wea:item><%=SystemEnv.getHtmlLabelName(125074,user.getLanguage()) %></wea:item>
		<wea:item>
		     <select style="width:180px;" id="searchField" name="searchField">
		        <%while(RecordSet.next()){
		        	String fieldid = RecordSet.getInt("id")+"";
		        	String comvalue = RecordSet.getString("labelname")+" "+RecordSet.getString("fieldname");
		        	if(fieldid.equals(RecordSet2.getString("searchfield"))){	
		        %>	
		          <option value="<%=fieldid %>" selected><%=comvalue %></option>
		          <%} else{%>
		          <option value="<%=fieldid %>"><%=comvalue %></option>
		        <%}} %> 
		     </select>
		</wea:item>
		<%}%>
		<wea:item><%=SystemEnv.getHtmlLabelName(125075,user.getLanguage()) %></wea:item>
		<wea:item>
		     <a href="#" onclick="toformtab()" id="aurl" <%if(flag){if( RecordSet2.getString("imageurl") != null && !RecordSet2.getString("imageurl").equals("")){%>style="display:none;"<%}}%>>
		         <img id="imageUrl" src="/formmode/images/tjia_wev8.png" style="width:20px;height:20px;">		       
		     </a>	
		     <a href="#" onclick="toformtab()" id="aurl2" <%if(flag){if(RecordSet2.getString("imageurl") != null && !RecordSet2.getString("imageurl").equals("")){%>style="display:block;"<%}else{%>style="display:none;"<%}}else{%>style="display:none;" <%}%>>
		         <img id="imageUrl2"  style="width:20px;height:20px;" <%if(flag){%>src="<%=RecordSet2.getString("imageurl")%>"<%}else{%>src=""<%} %>>	       
		     </a>
		     <input type="hidden" id="imageRelUrl" name="imageRelUrl" value="<%=imageUrl %>">
		     <input type="hidden" name="imageid" id="imageid" value="<%=imageid %>"/>
		     <input type="hidden" id="imageSource" name="imageSource" value="<%=imageSource %>">	
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125076,user.getLanguage()) %></wea:item>
		<wea:item>
		     <% if(flag){%>
			 <input type="text" id="order" name="order" value="<%=RecordSet2.getString("showorder") %>" onblur="validatetext(this);" style="width:200px;">
		    <% }else{%>
		     <input type="text" id="order" name="order" value="0"  onblur="validatetext(this);" style="width:200px;">
		    <%} %>
		     
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</body>
<script type="text/javascript">


$(function(){
   if("<%=searchtype%>" == "2"){
       if("<%=defaultUrl%>" == ""){
           $("#isUsedSearch").attr("disabled",true);
       }
   }
});

  
function toformtab(){
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;		
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(124841,user.getLanguage())%>";//图片上传

	diag_vote.Width = 600;
	diag_vote.Height = 450;
	diag_vote.Modal = true;
	 
	diag_vote.URL = "/formmode/setup/add_toolbarSearch_upload.jsp?dialog=1&isFromMode=1&appid=<%=appid%>";
	diag_vote.isIframe=false;
	diag_vote.show();
}

function doSubmit(){
   if($("#isUsedSearch").attr("checked")){
	   var searchName = $("#searchName").val();
	   var order = $("#order").val();
	   var src = $("#imageUrl2").attr("src");
	   var flag = false;
	   var info = "";
	   if(searchName ==""){
	       info += "<%=SystemEnv.getHtmlLabelName(125073,user.getLanguage()) %>";
	       flag = true;
	   }
	   if(src == ""){
	       if(info.length == 0){
	          info += "<%=SystemEnv.getHtmlLabelName(125075,user.getLanguage()) %>";
	       }else{
	          info += "<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(125075,user.getLanguage()) %>";
	       }
	       flag = true;
	   }
	   if(order == ""){
	       if(info.length == 0){
	          info += "<%=SystemEnv.getHtmlLabelName(125076,user.getLanguage()) %>";
	       }else{
	          info += "<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(125076,user.getLanguage()) %>";
	       }
	       flag = true;
	   }	   
	  if(flag ){
	       info += "<%=SystemEnv.getHtmlLabelName(125083,user.getLanguage()) %>"
	       window.top.Dialog.alert(info);
		   return;
	   }
   }
   $("#addform").submit();	   
}


function validatetext(obj){
    var valid=false;
	var checkrule='^(-?\\d+)(\\.\\d+)?$';
	var dsporder=$(obj).val();
	eval("valid=/"+checkrule+"/.test(\""+dsporder+"\");");
	if (dsporder!=''&&!valid){
		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125084,user.getLanguage()) %>');
		$(obj).val("");
	}
}


function formCheckAll(obj){
	if($("#isUsedSearch").attr("checked")){
	     $(obj).val("1");
	}else{
		 $(obj).val("0");
	} 
}


</script>
</html>
