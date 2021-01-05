
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.blog.BlogShareManager"%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type='text/css' rel='STYLESHEET'>
<LINK href="css/blog_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
</head>
<body>
<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(2112,user.getLanguage()); //微博应用设置
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<% 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
 String tempid=""+Util.getIntValue(request.getParameter("tempid"),0);
 String isSystem=Util.null2String(request.getParameter("isSystem"));
 
 BlogDao blogDao=new BlogDao();
 String sql="select * from blog_template where id="+tempid;
 RecordSet recordSet=new RecordSet();
 recordSet.execute(sql);
 String tempName="";
 if(recordSet.next())
	 tempName=recordSet.getString("tempName");
%>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="blog"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(2112,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="doSave()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="zDialog_div_content" style="height: 320px;">
<form action="BlogSettingOperation.jsp?operation=addTempShare" method="post"  id="mainform" enctype="multipart/form-data">
<input type="hidden" name="tempid" value="<%=tempid%>">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(83160,user.getLanguage())%>'>
		<wea:item type="groupHead">
			<input type="button" class="addbtn" onclick="addShare()" title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"/>
    		<input type="button" class="delbtn" onclick="javascript:deleteShare()" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"/>
		</wea:item>
		
		<wea:item attributes="{'colspan':'2','isTableList':'true'}">
			<table id="shareList" width="100%;" class="ListStyle" style="vertical-align: top;">
				<COLGROUP>
				<COL width="5%">
				<COL width="20%">
				<COL width="50%">
				<COL width="25%">
				<tbody>
					<tr class="HeaderForXtalbe">
						<th><input type="checkbox" name="seclevel_total" onclick="setCheckState(this)"/></th>
						<th><%=SystemEnv.getHtmlLabelName(23243,user.getLanguage())%></th><!-- 条件类型 -->
						<th><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())+SystemEnv.getHtmlLabelName(345,user.getLanguage())%></th><!-- 条件内容 --> 
						<th align="center"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th> <!-- 安全级别 -->
					</tr>
				   <%
					List alist=blogDao.getTempShareList(tempid);
				    int index = 0;
					for(int i=0;i<alist.size();i++){
					  HashMap hm=(HashMap)alist.get(i);
					  String typeName=SystemEnv.getHtmlLabelName(Util.getIntValue((String)hm.get("typeName")),user.getLanguage());
					  String seclevel=(String)hm.get("seclevel");
					  String seclevelMax = (String)hm.get("seclevelMax");
					  String shareid=(String)hm.get("shareid");
					  String content = (String)hm.get("content");
					  if(!"".equals(content)){
						  content = content.substring(1,content.length()-1);
					  }
					  int type=Util.getIntValue(hm.get("type")+"");
					  String completeUrlStr = "";
					  String browserUrlStr = "";
					  index--;
					  switch(type){
						  case 1://人员
							  	completeUrlStr = "/data.jsp";
							  	browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids=";
							  	break;
						  case 2://分部
							  	completeUrlStr = "/data.jsp?type=164";
								browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=";
								break;
						  case 3://部门
								completeUrlStr = "/data.jsp?type=57";
								browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=";
								break;
						  case 4://角色
								completeUrlStr = "/data.jsp?type=65";
								browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp?selectedids=";
								break;
						  case 5://岗位
								completeUrlStr = "/data.jsp?type=hrmjobtitles";
								browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids=";
								break;
						 default:
							 	break;
					  }	
					  
						
				   %>
					   <tr class="DataLight">
					   	  <td><input type="checkbox" name="seclevel_ck" value="<%=shareid %>"/></td>
					      <td><%=typeName %></td>
					      <td style="word-break:break-all">
					      	<input type="hidden" name="shareid" value="<%=hm.get("shareid")%>"> 
					        <input type="hidden" name="sharetype" value="<%=hm.get("type")%>">
							<input type="hidden" value="<%=hm.get("seclevel")%>" name="secLevel"/>
							<input type="hidden" value="<%=seclevelMax%>" name="secLevelMax"/>
							<input type="hidden" name=relatedshareid value="<%=","+content+","%>" class="relatedshareid_<%=index %>">
							<%if(type <= 5){ %>
							<brow:browser viewType="0" name="relatedshareid" 
								 browserUrl='<%=browserUrlStr %>'
								 browserValue='<%=content%>' 
								 browserSpanValue = '<%=hm.get("contentName")+""%>'
								 isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='1' index='<%=index+"" %>'
								 completeUrl='<%=completeUrlStr %>' width="300px" 
								 _callback="callBackSelectUpdate" afterDelCallback="callBackDelUpdate"></brow:browser> 
					      	<%} %>
					      </td>
					      <td align="center"><%=type==1?"":seclevel+" - "+seclevelMax%></td>
					   </tr>	
					   <tr style="height: 1px"><td class=Line colspan=4></td></tr>
			  		<%}%>
				</tbody>
			</table>
		</wea:item>
	</wea:group>
</wea:layout>
</form>			
</div>

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
</body>
<script>

jQuery(function(){
	jQuery("#objName").css("font-size","16px");
})

function setCheckState(obj){
	var checkboxs = jQuery("input[name='seclevel_ck']").each(function(){
		changeCheckboxStatus(this,obj.checked);
 	});
}

  function checkcount(obj)
 {
	valuechar =jQuery(obj).val().split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) {
		charnumber = parseInt(valuechar[i]);
		if( isNaN(charnumber) && (valuechar[i]!="-" || (valuechar[i]=="-" && i!=0))){
			isnumber = true ;
		}
		if (valuechar.length==1 && valuechar[i]=="-"){
		    isnumber = true ;
		}
	}
	if(isnumber){
		jQuery(obj).val("0");
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23086,user.getLanguage())%>");
	}
}

  function doSave(){
    jQuery("#mainform").submit();
  
  }
  
  function deleteShare(){
	  window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
	  	for(var k=document.getElementsByName("seclevel_ck").length-1;k>-1;k--){
	         if(document.getElementsByName("seclevel_ck")[k].checked==true){
	     		
	     		var shareid = document.getElementsByName("seclevel_ck")[k].value;
	     		
	     		if(shareid!="0"){
	     			jQuery.post("BlogSettingOperation.jsp?operation=deleteTempShare&shareid="+shareid);
	     			jQuery(jQuery("input[name=seclevel_ck]")[k]).parent().parent().parent().remove();
	     		}else{
	     			jQuery(jQuery("input[name=seclevel_ck]")[k]).parent().parent().parent().remove();
	     		}
	     		// alert(jQuery(jQuery("input[name=seclevel_ck]")[k]).parent().html());
	     		
	         }
	     }
	  });
  }
  
  var index=0;
  function addShare(){
		var str="<tr class='DataLight'>"+
		"   <td><input type='checkbox' name='seclevel_ck' value='0'/></td>"+
		"	<td>"+getShareTypeStr()+"</td>"+
		"	<td>"+getShareContentStr()+"</td>"+
		"	<td align='center'>"+getSecLevel()+"</td>"+		
		// "	<td align='left'>"+getOptStr()+"</td>"+
		"</tr>";	
		jQuery("#shareList tbody").append(str);	
		
		$("#relatedshareid"+index+"_span_n").e8Browser({
		   name:"relatedshareid",
		   viewType:"0",
		   browserValue:"0",
		   isMustInput:"1",
		   browserSpanValue:"",
		   hasInput:true,
		   linkUrl:"#",
		   isSingle:true,
		   completeUrl:"/data.jsp",
		   browserUrl:"/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids=",
		   width:"300px",
		   hasAdd:false,
		   isSingle:false,
		   index:index,
		   _callback:'callBackSelectUpdate'
		  });	
		index++;
		jQuery('body').jNice();
		beautySelect();
	}
	
  function callBackSelectUpdate(event,data,fieldId,oldid){
		var sharetype=$("#"+fieldId).closest("tr:first").find("select[name=sharetype]").val();
		if(sharetype!="4"){
			var content=","+jQuery("#"+fieldId).val()+",";
			jQuery("."+fieldId).val(content);
		}
	}
	
	function callBackDelUpdate(text,fieldId,params){
		var sharetype=$("#"+fieldId).closest("tr:first").find("select[name=sharetype]").val();
		if(sharetype!="4"){
			var content=","+jQuery("#"+fieldId).val()+",";
			jQuery("."+fieldId).val(content);
		}
	}
		
  function getShareTypeStr(){
  		var htmlstr="";
		htmlstr= "<select class='sharetype inputstyle'  name='sharetype' number="+index+" onChange=\"onChangeConditiontype(this)\" >"+
		"	<option value='1' selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>";
		<%if(isSystem.equals("")){%>
        htmlstr+="	<option value='2'><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>" +
        "	<option value='3'><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>" +
        "	<option value='4'><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>" +
        "	<option value='5'><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>"+
        "	<option value='6'><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>";
        <%}%>
        htmlstr+="</select>";
		return htmlstr;
	}	
	
	
  	function getShareContentStr(){
		return  "<input type='hidden' name='shareid' value='0'>"+
				"<input name='relatedshareid' type='hidden' class='relatedshareid_"+index+"'>"+
				"<span id='relatedshareid"+index+"_span_n'></span>";
	}	
	
	function getSecLevel(){ 
		return "<span class='shareSecLevel' style='display:none;'><input class='inputstyle' style='width:30px;text-align:center' name='secLevel' value='10'  onblur='checkcount(this)'/>"+
			" - <input class='inputstyle' style='width:30px;text-align:center' name='secLevelMax' value='100'  onblur='checkcount(this)'/>"+
			"</span>";
	}
  
  
    function getOptStr(){
		return 	"<a onclick='delShare(this)' href='javascript:void(0)' class='spanDelete'><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>";
	}  
	
	function onChangeConditiontype(obj){
		var thisvalue=jQuery(obj).val();
		var jQuerytr=jQuery(obj.parentNode.parentNode);
		// jQuerytr.find(".shareSecLevel").hide();
		
		var number = jQuery(obj).closest("tr").find(".sharetype").attr("number");
		
		var completeUrlStr = "";
		var browserUrlStr = "";
		if(thisvalue == 1){//人员
			completeUrlStr = "/data.jsp";
			browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids=";
		}
		if(thisvalue == 2){//分部
			completeUrlStr = "/data.jsp?type=164";
			browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=";
		}
		if(thisvalue == 3){//部门
			completeUrlStr = "/data.jsp?type=57";
			browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=";
		}
		if(thisvalue == 4){//角色
			completeUrlStr = "/data.jsp?type=65";
			browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp?selectedids=";
		}
		if(thisvalue == 5){//岗位
			completeUrlStr = "/data.jsp?type=hrmjobtitles";
			browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids=";
		}
		if(thisvalue == 6){//所有人
			$("#relatedshareid"+number+"_span_n").hide();
		}else{
			$("#relatedshareid"+number+"_span_n").show();
			$("#relatedshareid"+number+"_span_n").e8Browser({
			   name:"relatedshareid",
			   viewType:"0",
			   browserValue:"0",
			   isMustInput:"1",
			   browserSpanValue:"",
			   hasInput:true,
			   linkUrl:"#",
			   isSingle:true,
			   completeUrl:completeUrlStr,
			   browserUrl:browserUrlStr,
			   width:"300px",
			   hasAdd:false,
			   isSingle:false,
			   index:number,
			   _callback:'callBackSelectUpdate'
			  });	
		}
		if(thisvalue!=1){
			jQuery(obj).closest("tr").find(".shareSecLevel").show();
		}else{
			jQuery(obj).closest("tr").find(".shareSecLevel").hide();
		}	
		
	}
  
</script>
</html>
