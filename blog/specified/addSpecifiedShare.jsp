
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%

if (!HrmUserVarify.checkUserRight("blog:specifiedShare", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(28205,user.getLanguage()); 
String needfav ="1";
String needhelp ="";

int userid=user.getUID();

String operation=Util.null2String(request.getParameter("operation"));
String specifiedid=Util.null2String(request.getParameter("specifiedid"));

String tempName="";
String isUsed="1";
String tempContent="";

String sqlstr="select * from blog_specifiedShare where specifiedid="+specifiedid;
RecordSet.execute(sqlstr);
%>
<html>
  <head>
    <LINK href="/css/Weaver_wev8.css" type='text/css' rel='STYLESHEET'>
	<LINK href="/blog/css/blog_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
	<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
    <script language="javascript" src="/js/datetime_wev8.js"></script>
    <script language="javascript"  src="/js/JSDateTime/WdatePicker_wev8.js"></script>
  </head>
  <body>
 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="blog"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(2112,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="zDialog_div_content" style="height: 496px;">
<form action="/blog/BlogSettingOperation.jsp" method="post"  id="mainform" enctype="multipart/form-data">
    <input type="hidden" value="addSpecified" name="operation"/> 
    <wea:layout>
    	<wea:group context='<%=SystemEnv.getHtmlLabelName(28209,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(28209,user.getLanguage())%></wea:item>  
			<wea:item>
				<brow:browser viewType="0" name="specifiedid" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			         browserValue='<%=specifiedid%>' 
			         browserSpanValue = '<%=Util.toScreen(ResourceComInfo.getResourcename(""+specifiedid),user.getLanguage())%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp" width="80%" ></brow:browser> 
			</wea:item>  	
    	</wea:group>
    	
  		<wea:group context='<%=SystemEnv.getHtmlLabelName(19025,user.getLanguage())%>' attributes="{'itemAreaDisplay':'block'}">
  			<wea:item type="groupHead">
				<input type="button" class="addbtn" onclick="addShare()" title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"/>
	    		<input type="button" class="delbtn" onclick="javascript:delShare()" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"/>
			</wea:item>
  		
  			<wea:item attributes="{'colspan':'2','isTableList':'true'}">
  				<table id="shareList" width="100%;" class="ListStyle" style="vertical-align: top;">
				<COLGROUP>
				<COL width="5%">
				<COL width="20%">
				<COL width="30%">
				<COL width="25%">
                <COL width="20%">
				<tbody>
					<tr class="HeaderForXtalbe">
						<th><input type="checkbox" name="seclevel_total" onclick="setCheckState(this)"/></th>
						<th><%=SystemEnv.getHtmlLabelName(23243,user.getLanguage())%></th><!-- 条件类型 -->
						<th><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())+SystemEnv.getHtmlLabelName(345,user.getLanguage())%></th><!-- 条件内容 --> 
						<th align="center"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th> <!-- 安全级别 -->
                        <th align="center"><%="可查看时间"%></th><!-- 可查看时间 -->
					</tr>
					<%
					
					BlogDao blogDao=new BlogDao();
					List alist=blogDao.getSpecifiedShareList(specifiedid); 
					int index = 0;
					for(int i=0;i<alist.size();i++){
					  HashMap hm=(HashMap)alist.get(i);
					  String typeName=SystemEnv.getHtmlLabelName(Util.getIntValue((String)hm.get("typeName")),user.getLanguage());
					  String contentName=(String)hm.get("contentName");
					  String content = (String)hm.get("content");
					  if(!"".equals(content)){
						  content = content.substring(1,content.length()-1);
					  }
					  String seclevel=(String)hm.get("seclevel");
					  String shareid=(String)hm.get("shareid");
                      String canViewMinTime = (String)hm.get("canViewMinTime");
                      if("-1".equals(canViewMinTime)) {
                          canViewMinTime = "";
                      }
					  int type=Util.getIntValue(hm.get("type")+"");
					  String clickMethod="";
					  
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
					      <td><%=typeName%></td>
					      <td>
					        <input type="hidden" name="sharetype" value="<%=hm.get("type")%>">
							<input type="hidden" name=relatedshareid value="<%=","+content+","%>" class="relatedshareid_<%=index %>">
							<input type="hidden" name="shareid" value="<%=hm.get("shareid")%>"> 
							<input type="hidden" value="<%=hm.get("seclevel")%>" name="seclevel"/>
							<input type="hidden" value="<%=hm.get("seclevelMax")%>" name="seclevelMax"/>
							
							<%if(type <= 5){ %>
							<brow:browser viewType="0" name="relatedshareid" 
								 browserUrl='<%=browserUrlStr %>'
								 browserValue='<%=content%>' 
								 browserSpanValue = '<%=hm.get("contentName")+""%>'
								 isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2' index='<%=index+"" %>'
								 completeUrl='<%=completeUrlStr %>' width="300px" 
								 _callback="callBackSelectUpdate" afterDelCallback="callBackDelUpdate"></brow:browser>
							<%} %>	 
					      </td>
					      <td align="center"><%=type==1?"":seclevel+" - "+hm.get("seclevelMax")%></td>
                          <td align="center">
                              <input id="canViewMinTime_<%=index %>" name="canViewMinTime_<%=index %>" type="hidden" value="<%=canViewMinTime %>">
                              <button type="button" class=CalendarNew onclick="getDate('canViewMinTimespan_<%=index %>','canViewMinTime_<%=index %>')" style="vertical-align: middle;"></button>
                              <span id="canViewMinTimespan_<%=index %>"><%=canViewMinTime %></span>
                          </td>
					   </tr>	
			      <%}%>
				</tbody>
			</table>
  			</wea:item>
  		</wea:group>
    </wea:layout>
</form>  

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
<script type="text/javascript">
  
  jQuery(function(){
		jQuery("#objName").css("font-size","16px");
  });
  
 function onShowResourceOnly(inputid,spanid,isNeed){
  var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
  if(id1){
	  var id=id1.id;
	  var name=id1.name;
	  if(id!=""){
	     jQuery("#"+inputid).val(id);
	     jQuery("#"+spanid).html("<a href='javaScript:openhrm("+id+");' onclick='pointerXY(event);'>"+name+"</a>");
	  }else{
	     jQuery("#"+inputid).val("");
	     if(isNeed)
	        jQuery("#"+spanid).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	     else
	        jQuery("#"+spanid).html(""); 
	  }
  }
}

function setCheckState(obj){
	var checkboxs = jQuery("input[name='seclevel_ck']").each(function(){
		changeCheckboxStatus(this,obj.checked);
 	});
}

 </script>
 
 <script>

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
    if($("#mainform").find("img[src='/images/BacoError_wev8.gif']").length>0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30933,user.getLanguage())%>");
		return;
	}
   if(check_form(mainform,"specifiedid")){
      $('input[name^="canViewMinTime_"]').attr("name", "canViewMinTime");
      jQuery("#mainform").submit();
   }
  }
  function delShare(obj,shareid){
  
  	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
  		for(var k=document.getElementsByName("seclevel_ck").length-1;k>-1;k--){
	         if(document.getElementsByName("seclevel_ck")[k].checked==true){
	     		var shareid = document.getElementsByName("seclevel_ck")[k].value;
	     		if(shareid!="0"){
	     			jQuery.post("/blog/BlogSettingOperation.jsp",
	     					{"operation":"deleteSpecifiedShare","specifiedid":"<%=specifiedid%>","shareid":shareid});
         			jQuery(jQuery("input[name=seclevel_ck]")[k]).parent().parent().parent().remove(); 
	     		}else{
	     			jQuery(jQuery("input[name=seclevel_ck]")[k]).parent().parent().parent().remove();
	     		}
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
        "   <td align='center'>"+getCanViewMinTime()+"</td>"+
		"</tr>";	
		jQuery("#shareList tbody").append(str);	
		
		$("#relatedshareid"+index+"_span_n").e8Browser({
		   name:"relatedshareid",
		   viewType:"0",
		   browserValue:"0",
		   isMustInput:"2",
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
	
  function getShareTypeStr(){
		return  "<select class='sharetype inputstyle'  name='sharetype' number="+index+" onChange=\"onChangeConditiontype(this)\" >"+
		"	<option value='1' selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>" +
        "	<option value='2'><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>" +
        "	<option value='3'><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>" +
        "	<option value='4'><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>" +
        "	<option value='5'><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>"+
        "	<option value='6'><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>"+
        "</select>";        
	}	
	
	
  function getShareContentStr(){
       return  "<input type='hidden' name='shareid' value='0'>"+
				"<input name='relatedshareid' type='hidden' class='relatedshareid_"+index+"'>"+
				"<span id='relatedshareid"+index+"_span_n'></span>";
	}	
	
	function getSecLevel(){ 
		return "<span class='shareSecLevel' style='display:none;'><input class='inputstyle' style='width:30px;text-align:center' name='seclevel' value='10'  onblur='checkcount(this)'/>"+
			" - <input class='inputstyle' style='width:30px;text-align:center' name='seclevelMax' value='100'  onblur='checkcount(this)'/>"+
			"</span>";
	}
  
  
    function getOptStr(){
		return 	"<a onclick='delShare(this)' href='javascript:void(0)' class='spanDelete'><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>";
	}
    
    function getCanViewMinTime() {
        var today = new Date();
        today.setTime(today.getTime());
        var s1 = today.getFullYear()+"-" + (today.getMonth()+1) + "-" + today.getDate();
        return '<input id="canViewMinTime_'+index+'" name="canViewMinTime_'+index+'" type="hidden" value="' + s1 + '">'
            + '<button type="button" class=CalendarNew onclick="getDate(\'canViewMinTimespan_'+index+'\',\'canViewMinTime_'+index+'\')" style="vertical-align: middle;"></button>'
            + '<span id="canViewMinTimespan_'+index+'">' + s1 + '</span>';
    }
	
	function onChangeConditiontype(obj){
		var thisvalue=jQuery(obj).val();
		var jQuerytr=jQuery(obj.parentNode.parentNode);
		
		
		var number = jQuery(obj).closest("tr").find(".sharetype").attr("number");
		
		
		var completeUrlStr = "";
		var browserUrlStr = "";
		if(thisvalue == 1){
			completeUrlStr = "/data.jsp";
			browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
		}
		if(thisvalue == 2){
			completeUrlStr = "/data.jsp?type=164";
			browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp";
		}
		if(thisvalue == 3){
			completeUrlStr = "/data.jsp?type=57";
			browserUrlStr ="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp";
		}	
		if(thisvalue == 4){
			completeUrlStr = "/data.jsp?type=65";
			browserUrlStr ="/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp";
		}	
		if(thisvalue == 5){//岗位
			completeUrlStr = "/data.jsp?type=hrmjobtitles";
			browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp";
		}
		
		if(thisvalue == 6){//所有人
			$("#relatedshareid"+number+"_span_n").val("");
			$("#relatedshareid"+number+"_span_n").find("img[src='/images/BacoError_wev8.gif']").remove();
			$("#relatedshareid"+number+"_span_n").hide();
			
		}else{
			$("#relatedshareid"+number+"_span_n").show();
			$("#relatedshareid"+number+"_span_n").e8Browser({
			   name:"relatedshareid",
			   viewType:"0",
			   browserValue:"0",
			   isMustInput:"2",
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
  
   function callBackSelectUpdate(event,data,fieldId,oldid){
		var sharetype=$("#"+fieldId).parents("tr:first").find("select[name=sharetype]").val();
		var content=jQuery("#"+fieldId).val();
		if(sharetype!="4"){
			content=","+jQuery("#"+fieldId).val()+",";
		}
		jQuery("."+fieldId).val(content);
	}
	
	function callBackDelUpdate(text,fieldId,params){
		var sharetype=$("#"+fieldId).parents("tr:first").find("select[name=sharetype]").val();
		var content=jQuery("#"+fieldId).val();
		if(sharetype!="4"){
			content=","+jQuery("#"+fieldId).val()+",";
		}
		jQuery("."+fieldId).val(content);
	}
</script>
</html>
