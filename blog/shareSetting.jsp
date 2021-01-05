
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogCommonUtils"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.blog.BlogShareManager"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type='text/css' rel='STYLESHEET'>
<LINK href="css/blog_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language="javascript" src="/js/datetime_wev8.js"></script>
<script language="javascript"  src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</head>
<body>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17714,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<div id="divTopMenu"></div>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
 String userid=""+user.getUID();
 BlogShareManager shareManager=new BlogShareManager();
%>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form action="BlogSettingOperation.jsp?operation=add" method="post"  id="mainform" enctype="multipart/form-data">

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19025,user.getLanguage())%>'>
		<wea:item type="groupHead">
			<input type="button" class="addbtn" onclick="addShare()" title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"/>
    		<input type="button" class="delbtn" onclick="javascript:delShare()" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"/>
		</wea:item>
		
		<wea:item attributes="{'colspan':'2','isTableList':'true'}">
			<table id="shareList" class="ListStyle" cellspacing="1" style="font-size: 9pt;margin-bottom: 20px">
				<COLGROUP>
				<COL width="10%">
				<COL width="15%">
				<COL width="45%">
				<COL width="15%">
                <COL width="15%">
				<tbody>
					<tr class="HeaderForXtalbe">
						<th><input type="checkbox" name="seclevel_total" onclick="setCheckState(this)"/></th>
						<th><%=SystemEnv.getHtmlLabelName(23243,user.getLanguage())%></th><!-- 条件类型 -->
						<th><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())+SystemEnv.getHtmlLabelName(345,user.getLanguage())%></th><!-- 条件内容 --> 
						<th><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th><!-- 安全级别 --> 
                        <th><%="可查看时间"%></th><!-- 可查看时间 -->
					</tr>
				   <%
					List alist=shareManager.getShareConditionStrList(""+userid);
				    int index = 0;
					for(int i=0;i<alist.size();i++){
					  HashMap hm = (HashMap)alist.get(i);
					  String typeName=SystemEnv.getHtmlLabelName(Util.getIntValue((String)hm.get("typeName")),user.getLanguage());
					  String contentName=(String)hm.get("contentName");
					  String content = (String)hm.get("content");
					  int type=Util.getIntValue(hm.get("type").toString());
					  
					  if(type <= 4 && !"".equals(content)){
						  content = content.substring(1,content.length()-1);
					  }
					  String seclevel=(String)hm.get("seclevel");
					  String seclevelMax=(String)hm.get("seclevelMax");
					  String shareid=(String)hm.get("shareid");
					  String canViewMinTime = (String)hm.get("canViewMinTime");
                      if("-1".equals(canViewMinTime)) {
                          canViewMinTime = "";
                      }
					  
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
						  case 5://所有人
								//completeUrlStr = "/data.jsp?type=hrmjobtitles";
								//browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids=";
								break;
						  case 7://申请人
							  	completeUrlStr = "/data.jsp";
							  	browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids=";
							  	break;
						 default:
							 	break;
					  }	
				   %>
				   <tr class="DataLight">
				   	  <td><input type="checkbox" style="display:<%=(6 != type && 8 != type)?"":"none"%>" name="seclevel_ck" value="<%=shareid %>"/></td>
				      <td><%=typeName %></td>
				      <td>
				      	<input type="hidden" name=relatedshareid value="<%=","+content+","%>" class="relatedshareid_<%=index %>">
				      	<input type="hidden" name="shareid" value="<%=shareid%>"> 
				      	<input type="hidden" name="sharetype" value="<%=hm.get("type")%>">
				      	<input type="hidden" value="<%=hm.get("seclevel")%>" name="seclevel"/>
				      	<input type="hidden" value="<%=hm.get("seclevelMax")%>" name="seclevelMax"/>
						<%if(6 != type && 8 != type && 5 != type){
						    //System.out.println("type=" + type);
						    //System.out.println(completeUrlStr);
						    //System.out.println(browserUrlStr);
						    //System.out.println(content);
						    content = BlogCommonUtils.trimExtraComma(content);
                            %>
						<brow:browser viewType="0" name="relatedshareid" 
							 browserUrl='<%=browserUrlStr %>'
							 browserValue='<%=content%>' 
							 browserSpanValue = '<%=contentName+""%>'
							 isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2' index='<%=index+"" %>'
							 completeUrl='<%=completeUrlStr %>' width="90%" 
							 _callback="callBackSelectUpdate" afterDelCallback="callBackDelUpdate"></brow:browser> 
						<%}else{out.println(contentName);} %>
				      </td>
				      <td align="center"><%if(6 != type && 8 != type && 1 != type && 7 != type){out.println(seclevel +" - "+seclevelMax); }%></td>
                      <td align="center">
                        <% if(type == 8 || type == 6 || type == 7) { //默认分享，上级，关注者 %>
                        <input  name="canViewMinTime" type="hidden" />
                        <% } else { %>
                          <input id="canViewMinTime_<%=index %>" name="canViewMinTime_<%=index %>" type="hidden" value="<%=canViewMinTime %>">
            	          <button type="button" class=CalendarNew onclick="getDate('canViewMinTimespan_<%=index %>','canViewMinTime_<%=index %>')" style="vertical-align: middle;"></button>
            	          <span id="canViewMinTimespan_<%=index %>"><%=canViewMinTime %></span>
                        <% } %>
                      </td>
				   </tr>
			  <% }%>
				</tbody>
			</table>

		</wea:item>
	</wea:group>
</wea:layout>
</form>			
</body>

<script>

function setCheckState(obj){
	var checkboxs = jQuery("input[name='seclevel_ck']").each(function(){
		changeCheckboxStatus(this,obj.checked);
 	});
}

jQuery(function(){
	jQuery('body').jNice(); 
});

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
    $('input[name^="canViewMinTime_"]').attr("name", "canViewMinTime");
    jQuery("#mainform").submit();
  
  }
  function delShare(obj,shareid){
    if($("input[name=seclevel_ck]:checked").length==0){
    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>！");
    	return ;
    }
  	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
	  	for(var k=document.getElementsByName("seclevel_ck").length-1;k>-1;k--){
	         if(document.getElementsByName("seclevel_ck")[k].checked==true){
	     		var shareid = document.getElementsByName("seclevel_ck")[k].value;
	     		if(shareid!="0"){
	     			jQuery.post("/blog/BlogSettingOperation.jsp", {"operation":"delete","shareid":shareid});
	     		}
	     		jQuery(jQuery("input[name=seclevel_ck]")[k]).parent().parent().parent().remove(); 
	         }
	     }
  	});
  }
  
  var index=0;
  function addShare(){
		var str="<tr class='DataLight'>"+
		"   <td><input type='checkbox' name='seclevel_ck' value='0'/></td>"+
		"	<td>"+getShareTypeStr()+"</td>"+
		"	<td>"+getShareContentStr("relatedshareid_"+index)+"</td>"+
		"	<td align='center'>"+getSecLevel()+"</td>"+		
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
		   width:"90%",
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
        // 1：人员，2：分部，3：部门，4：角色，5：所有人
        // 6：上机，7：申请人，8：指定共享人
        
        // 10：岗位，11：同部门、12：同分部、13：下级部门、14：下级分部、15：直接下属、16：所有下属
  
		return  "<select class='sharetype inputstyle'  name='sharetype' id='sharetype_"+index+"' number="+index+" onChange=\"onChangeConditiontype(this)\" >"+
		"	<option value='1' selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>" +
        "	<option value='2'><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>" +
        "	<option value='3'><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>" +
        "	<option value='4'><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>" +
        "	<option value='5'><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>"+
        /*
        "   <option value='10'><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>"+
        "   <option value='11'><%=SystemEnv.getHtmlLabelName(18511,user.getLanguage())%></option>"+
        "   <option value='12'><%=SystemEnv.getHtmlLabelName(18512,user.getLanguage())%></option>"+
        "   <option value='13'><%=SystemEnv.getHtmlLabelName(17587,user.getLanguage())%></option>"+
        "   <option value='14'><%=SystemEnv.getHtmlLabelName(17898,user.getLanguage())%></option>"+
        "   <option value='15'><%=SystemEnv.getHtmlLabelName(81863,user.getLanguage())%></option>"+
        "   <option value='16'><%=SystemEnv.getHtmlLabelName(17494,user.getLanguage())%></option>"+
        */
        "</select>";        
	}	
	
	
  function getShareContentStr(fieldId){
		return  "<input type='hidden' name='shareid' value='0'>"+
				"<input name='relatedshareid' type='hidden' class='relatedshareid_"+index+"'>"+
				"<span id='relatedshareid"+index+"_span_n'></span>";
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
	
	function getSecLevel(){ 
		return "<span class='shareSecLevel' style='display:none;'><input class='inputstyle' style='width:30px;text-align:center' name='seclevel' value='10'  onblur='checkcount(this)'/>"+
			"-<input class='inputstyle' style='width:30px;text-align:center' name='seclevelMax' value='100'  onblur='checkcount(this)'/>"+
			"</span>";
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
		var number = jQuery(obj).closest("tr").find(".sharetype").attr("number");
		var completeUrlStr = "";
		var browserUrlStr = "";
        
        
		if(thisvalue == 1){//人员
			completeUrlStr = "/data.jsp";
			browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
		}
		if(thisvalue == 2){// 分部
			completeUrlStr = "/data.jsp?type=164";
			browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp";
		}
		if(thisvalue == 3){  //部门
			completeUrlStr = "/data.jsp?type=57";
			browserUrlStr ="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp";
		}	
		if(thisvalue == 4){  //角色
			completeUrlStr = "/data.jsp?type=65";
			browserUrlStr ="/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp";
		}
        
        // thisvalue==5 //所有人
        /*
        if(thisvalue == 10) {
            completeUrlStr = "/data.jsp?type=hrmjobtitles";
            browserUrlStr ="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids=";
        }
        */
        
		if(thisvalue !=5){	
			$("#relatedshareid"+number+"_span_n").show();	
			$("#relatedshareid"+number+"_span_n").e8Browser({
			     name:"relatedshareid",
			     viewType:"0",
			     browserValue: this.value,
			     isMustInput:"2",
			     browserSpanValue:"",
			     hasInput:true,
			     linkUrl:"#",
			     isSingle:true,
			     completeUrl:completeUrlStr,
			     browserUrl:browserUrlStr,
			     width:"90%",
			     hasAdd:false,
			     isSingle:false,
			     index:number,
			     _callback:'callBackSelectUpdate'
			  });	
		}else{
			$("#relatedshareid"+number+"_span_n").val("");
			$("#relatedshareid"+number+"_span_n").find("img[src='/images/BacoError_wev8.gif']").remove();
			$("#relatedshareid"+number+"_span_n").hide();
		}
		
		
		jQuery(obj).parents("tr").find(".shareSecLevel").hide();
		if(thisvalue!=1){
			jQuery(obj).parents("tr").find(".shareSecLevel").show();
		}	
	}
  
</script>

</html>
