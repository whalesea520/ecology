
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.definedfield.HrmFieldManager"%>
<%@page import="weaver.hrm.util.html.HtmlElement"%>
<%@page import="weaver.docs.docs.CustomFieldManager"%>
<%@page import="org.json.JSONObject"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="HrmFieldGroupComInfo" class="weaver.hrm.definedfield.HrmFieldGroupComInfo" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
<%
 String id = request.getParameter("id");
 String isView = request.getParameter("isView");
 int rightid = 0;
 if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user)){
	   rightid = 3;
}
 if(user.getManagerid().equals("id")){
     rightid = 1;
 }  
 if(user.getUID()==Util.getIntValue(id)){
     rightid = 2;
 }
 if(rightid == 0){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
 }
%>
<head>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  <link href="/hrm/css/Contacts_wev8.css" rel="stylesheet" type="text/css" />
	<link href="/hrm/css/Public_wev8.css" rel="stylesheet" type="text/css" />
  <SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
  <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(621,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>    
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
 if(rightid > 1){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewBasicInfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="dosave();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM name=resourcebasicinfo id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<input class=inputstyle type=hidden name=isfromtab value="<%=isfromtab%>"> 
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<input type=hidden name=view>
	<%
	int scopeId = -1;
String needinputitems = "";

HashMap<String,String> mapHideData = new HashMap<String,String>();
 List<String> lsSamePair = new ArrayList<String>();
HrmFieldGroupComInfo.setTofirstRow();
HrmFieldManager hfm = new HrmFieldManager("HrmCustomFieldByInfoType",scopeId);
CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
hfm.getHrmData(Util.getIntValue(id));
cfm.getCustomData(Util.getIntValue(id));
boolean isWorkroomUse = false;
boolean isWorkroomMust = false;
boolean isMobileUse = false;
boolean isMobileMust = false;
while(HrmFieldGroupComInfo.next()){
	int grouptype = Util.getIntValue(HrmFieldGroupComInfo.getType());
	if(grouptype!=scopeId)continue;
	int grouplabel = Util.getIntValue(HrmFieldGroupComInfo.getLabel());
	int groupid = Util.getIntValue(HrmFieldGroupComInfo.getid());
	hfm.getCustomFields(groupid);
	if(hfm.getGroupCount()==0)continue;
	String groupattr = "{}";
	if(groupid==2 && !HrmListValidate.isValidate(39)){
		groupattr = "{'samePair':'group_"+groupid+"_"+39+"'}";
		lsSamePair.add("group_"+groupid+"_"+39);
	}
	if(groupid!=1 && groupid!=2 && groupid!=3 && !HrmListValidate.isValidate(41) ){
		groupattr = "{'samePair':'group_"+groupid+"_"+41+"'}";
		lsSamePair.add("group_"+groupid+"_"+41);
	}
	
	while(hfm.next()){
		int fieldlabel=Util.getIntValue(hfm.getLable());
		String fieldName=hfm.getFieldname();
		int fieldId=hfm.getFieldid();
		int type = hfm.getType();
		String dmlurl = hfm.getDmrUrl();
		int fieldhtmltype = Util.getIntValue(hfm.getHtmlType());
		String fieldValue="";
		JSONObject hrmFieldConf = hfm.getHrmFieldConf(fieldName);
		if("workroom".equals(fieldName)){
			if(hfm.isMand()){
				isWorkroomUse = true;
				isWorkroomMust = true;
				needinputitems += ","+fieldName;
			}
			if(hfm.isUse()){
				isWorkroomUse = true;
			}
			//System.out.println("fieldName>>>"+fieldName+">>>hfm.isMand()>>>"+hfm.isMand()+">>isUse>"+hfm.isUse()+">>>>"+((HtmlElement)Class.forName(hrmFieldConf.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, hrmFieldConf, user) );
		}else if("mobile".equals(fieldName)){
			if(hfm.isUse()){
				isMobileUse = true;
			}
			if(hfm.isMand()){
				isMobileMust = true;
				needinputitems += ","+fieldName;
			}
		}
	}
}	
	
		RemindSettings hrmsettings=(RemindSettings)application.getAttribute("hrmsettings");
	  String mobileShowSet = Util.null2String(hrmsettings.getMobileShowSet());
	  String mobileShowType = Util.null2String(hrmsettings.getMobileShowType());
	  String sql = "";
	  
	  String coreMailIsUsed = "0";
	  rs.executeSql("select isuse from coremailsetting ");
	  if(rs.next()) {
		  coreMailIsUsed = Util.null2String(rs.getString("isuse"));
	  }
	  
	  sql = "select * from HrmResource where id = "+id;  
	  rs.executeSql(sql);
	  while(rs.next()){    
	    String locationid = Util.null2String(rs.getString("locationid"));
	    String workroom = Util.null2String(rs.getString("workroom"));
	    String telephone = Util.null2String(rs.getString("telephone"));
	    String mobile = Util.null2String(rs.getString("mobile"));
	    String mobileshowtype = Util.null2String(rs.getString("mobileshowtype"));
	    String mobilecall = Util.null2String(rs.getString("mobilecall"));
	    String fax = Util.null2String(rs.getString("fax"));
	    String email = Util.null2String(rs.getString("email"));
	    int systemlanguage = Util.getIntValue(rs.getString("systemlanguage"));    
		String photoid = Util.null2String(rs.getString("resourceimageid"));
	%>
				<wea:layout>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(16076,user.getLanguage())%>'>
					 <wea:item><%=SystemEnv.getHtmlLabelName(16074,user.getLanguage())%></wea:item>
				   <wea:item>
					   <brow:browser viewType="0"  name="locationid" browserValue='<%=locationid %>' 
							browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/location/LocationBrowser.jsp?selectedids="
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
							completeUrl="/data.jsp?type=location" linkUrl="/hrm/location/HrmLocationEdit.jsp?id=" width="200px"
							browserSpanValue='<%=LocationComInfo.getLocationname(locationid)%>'>
						 </brow:browser>
				   </wea:item>
				   <%
				   String item_workroom = "{'samePair':'item_workroom','display':'none'}";
				   	if(isWorkroomUse){
				   		item_workroom = "{'samePair':'item_workroom','display':''}";
				   	}
				    %>
           <wea:item attributes="<%=item_workroom %>"><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></wea:item>
           <wea:item attributes="<%=item_workroom %>">
           	<%
           		if(isWorkroomMust){
           	%>
            <input type=text name=workroom value='<%=workroom%>' style="width: 200px" onblur="checkinput('workroom','workroomspan')" />
            <span id="workroomspan" style="word-break:break-all;word-wrap:break-word">
            <img src='/images/BacoError_wev8.gif' align='absmiddle'></span>
           	<%	
           		}else{
           	%>
           <input type=text name=workroom value='<%=workroom%>' style="width: 200px">
           	<%
           		}
            %>
           </wea:item>          
            
           <wea:item><%=SystemEnv.getHtmlLabelName(661,user.getLanguage())%></wea:item>
           <wea:item><input type=text name=telephone value='<%=telephone%>' style="width: 200px"></wea:item>
			<%
				String item_mobile = "{'samePair':'item_mobile','display':'none'}";
				if(isMobileUse){
					item_mobile = "{'samePair':'item_mobile','display':''}";
				}
			%>
           <wea:item attributes="<%=item_mobile%>"><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></wea:item>
           <wea:item attributes="<%=item_mobile%>">
			<%
				if(isMobileMust){
			%>
					<input type=text name=mobile value='<%=mobile%>' style="width: 200px" onblur="checkinput('mobile','mobilespan')">
					<span id="mobilespan" style="word-break:break-all;word-wrap:break-word">
					<%if("".equals(mobile)){%><img src='/images/BacoError_wev8.gif' align='absmiddle'><%}%>
					</span>
			<%	
				}else{
			%>
					<input type=text name=mobile value='<%=mobile%>' style="width: 200px">
			<%
				}
			%>
           			<%if(mobileShowSet.equals("1")){%>
						<select name="mobileshowtype" style="width: 200px">
							<%if(mobileShowType.indexOf("1")!=-1){ %>
						<option value="1" <%=mobileshowtype.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(2161,user.getLanguage())%></option>
						<%}if(mobileShowType.indexOf("2")!=-1){ %>
						<option value="2" <%=mobileshowtype.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32670,user.getLanguage())%></option>
						<%}if(mobileShowType.indexOf("3")!=-1){ %>
						<option value="3" <%=mobileshowtype.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32671,user.getLanguage())%></option>
						<%} %>
						</select>
					<%}else{%>
						<input class="inputstyle" type="hidden" name="mobileshowtype" value="<%=mobileshowtype%>">
					<%}%>
           </wea:item>
           <wea:item><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></wea:item>
           <wea:item><input type=text name=mobilecall value='<%=mobilecall%>' style="width: 200px"></wea:item>
           <wea:item><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></wea:item>
           <wea:item><input type=text name=fax value='<%=fax%>' style="width: 200px"></wea:item>
           <wea:item><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></wea:item>
           
           <wea:item>
           	   <% if(!"1".equals(coreMailIsUsed)) { %>
               	   <input type=text id=email name=email value='<%=email%>' style="width: 200px">
               <% } else { %>
               	   <%=email%>
                   <input class=inputstyle type=hidden id=email name=email value='<%=email%>'>
               <% } %>
           </wea:item>
           
					 <%if(isMultilanguageOK){%>
					 <wea:item><%=SystemEnv.getHtmlLabelName(16066,user.getLanguage())%></wea:item>
           <wea:item> 
         	<%=LanguageComInfo.getLanguagename(""+systemlanguage)%>         
           </wea:item>
					<%}%>
					
					<%if(!photoid.equals("0")&&!photoid.equals("") ){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></wea:item>
      	<wea:item>
      		<div id="boxb" >
      		<BUTTON class=delbtn accessKey=D onClick="delpic()" type="button" title="<%=SystemEnv.getHtmlLabelName(16075,user.getLanguage())%>"></BUTTON>
      		<span style="vertical-align: middle;"><%=SystemEnv.getHtmlLabelName(16075,user.getLanguage())%></span>
      		<input class=inputstyle type=hidden name=oldresourceimage value="<%=photoid%>">
      		</div>
      		<div id="boxa" style="display: none">
      		<input class=inputstyle type=file onchange="check_photo(event)" name=photoid value="<%=photoid%>" style="width: 300px" accept="image/*">
      		
      		</div>
      	</wea:item>
			<%}else{%>
			<wea:item ><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></wea:item>
			<wea:item><input class=inputstyle type=file name=photoid onchange="check_photo(event)" value='<%=photoid%>' style="width: 300px" accept="image/*"></wea:item>
			<wea:item>&nbsp;</wea:item>
			<wea:item>(<%=SystemEnv.getHtmlLabelName(21130,user.getLanguage())%>:400*600)</wea:item>
			<%}%>
			<%if(!photoid.equals("0")&&photoid.length()>0){%>
			<wea:item attributes="{'id':'boxc'}"><%=SystemEnv.getHtmlLabelName(33470,user.getLanguage())%></wea:item>
 				<wea:item>
 				
 				<div id="boxd"><img class="ContactsAvatar" style="right: 0;z-index: 999" border=0 id=resourceimage src="/weaver/weaver.file.FileDownload?fileid=<%=photoid%>"></div>
 				<div id="boxe" style="display: none"> (<%=SystemEnv.getHtmlLabelName(21130,user.getLanguage())%>:400*600)</div>
 				</wea:item>
					
			<%} %>
					
					</wea:group>
				</wea:layout>  
<%} %>
</FORM>
<script language=vbs>  
  sub onShowLocationID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	locationidspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.locationid.value=id(0)
	else 
	locationidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.locationid.value=""
	end if
	end if
end sub

sub onShowLanguage()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	systemlanguagespan.innerHtml = id(1)
	resource.systemlanguage.value=id(0)
	else 
	systemlanguagespan.innerHtml = ""
	resource.systemlanguage.value=""
	end if
	end if
end sub

</script>
 <script language=javascript>
 jQuery(function(){
 	jQuery("input[name=workroom]").blur();
 });
  function chkMail(){
if(jQuery("#email").val() == ''){
return true;
}

var email = jQuery("#email").val();
var pattern =  /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i;
chkFlag = pattern.test(email);
if(chkFlag){
return true;
}
else
{
window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24570,user.getLanguage())%>");
//document.resourcebasicinfo.email.focus();
return false;
}
}
  function dosave(){
	  if(!chkMail()) return false;
	  //if(!checkMobile()) return false;
	  if(check_formM(document.resourcebasicinfo,'locationid'+'<%=needinputitems%>')){
	  document.resourcebasicinfo.operation.value = "editcontactinfo";
	  document.resourcebasicinfo.submit();
	  }
  }
  function viewBasicInfo(){    
    if(<%=isView%> == 0){
      location = "/hrm/resource/HrmResourceBase.jsp?id=<%=id%>";
    }else{
   	  if('<%=isfromtab%>'=='true')
      	location = "/hrm/resource/HrmResourceBase.jsp?id=<%=id%>";
      else
      	location = "/hrm/resource/HrmResource.jsp?id=<%=id%>";
    }  
  }
  
  function checkMobile() {
	  if(document.resourcebasicinfo.mobile.value == ''){
		  return true;
	  }
	  var cellphone=/1[3-8]+\d{9}/;
	  if(!cellphone.test(document.resourcebasicinfo.mobile.value)) {
		  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83707,user.getLanguage())%>");
		  document.resourcebasicinfo.mobile.focus();
		  return false;
	  } else {
		  return true;
	  }
  }

    function check_formM(thiswins,items)
	{
		thiswin = thiswins
		items = ","+items + ",";
		for(i=1;i<=thiswin.length;i++)
		{
		tmpname = thiswin.elements[i-1].name;
		tmpvalue = thiswin.elements[i-1].value;
		if(tmpname=="locationid"){
			if(tmpvalue == 0){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>"); 
				return false;
			}
		}
		if(tmpvalue==null){
			continue;
		}
		while(tmpvalue.indexOf(" ") == 0)
			tmpvalue = tmpvalue.substring(1,tmpvalue.length);
		
		if(tmpname!="" &&items.indexOf(","+tmpname+",")!=-1 && tmpvalue == ""){
			 window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
			 return false;
			}

		}
		return true;
	}
    function delpic(){
        if(confirm("<%=SystemEnv.getHtmlLabelName(83460,user.getLanguage())%>")){
		  //document.resourcebasicinfo.operation.value = "delpic";
		 // document.resourcebasicinfo.view.value="contactinfo";
		 // document.resourcebasicinfo.submit();
         var id = jQuery("input[name=id]").val();
		  var oldresourceimageid = jQuery("input[name=oldresourceimage]").val();
		  var lastname = jQuery("#lastname").val();
		  jQuery.ajax({
			url : "HrmResourcePicDelete.jsp?lastname="+lastname+"&oldresourceimageid="+oldresourceimageid+"&id="+id+"&t="+new Date().getTime(),
			type : "post",
			success: function (data){
				changeaa();
			 	var oldresourceimage = jQuery("input[name=oldresourceimage]")
			 	oldresourceimage.attr("value","");
			}
		});
       }
  }
    
	function changeaa(){
		$("#boxa").show();
		$("#boxe").show();
		$("#boxb").hide();
		$("#boxd").hide();
		$("#boxc").text("");
	}
 jQuery(document).ready(function(){
     //绑定照片上传事件
     jQuery("input[name=photoid]").bind("onchange",function(event){
         check_photo(event);
     });
 });
 /*验证照片的格式*/
 function check_photo(e){
     var src=e.target || window.event.srcElement; //获取事件源，兼容chrome/IE
     //测试chrome浏览器、IE6，获取的文件名带有文件的path路径
     //下面把路径截取为文件后缀名
     var filename=src.value;
     var imgUrl = filename.substring( filename.lastIndexOf('.')+1 );
     if (imgUrl != '') {
         if (!(imgUrl.toLowerCase()=="gif"||imgUrl.toLowerCase()=="png"||imgUrl.toLowerCase()=="jpg")) {
             if (!!window.ActiveXObject || "ActiveXObject" in window){
                 var fileInput = jQuery("input[name=photoid]");
                 fileInput.replaceWith(fileInput.clone());
             }else{
                 jQuery("input[name=photoid]").val("");
             }
             window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132006, user.getLanguage())%>");
             return;
         }
     }
 }
</script> 
</body>
</html>
