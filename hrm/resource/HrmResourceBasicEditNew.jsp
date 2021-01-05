
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.hrm.definedfield.HrmFieldManager"%>
<%@page import="weaver.hrm.util.html.HtmlElement"%>
<%@page import="org.json.JSONObject"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.login.Account"%>
<%@ page import="weaver.login.VerifyLogin,
								 weaver.docs.docs.CustomFieldManager"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="JobCallComInfo" class="weaver.hrm.job.JobCallComInfo" scope="page"/>
<jsp:useBean id="JobtitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="HrmResourceFile" class="weaver.hrm.tools.HrmResourceFile" scope="page"/>
<jsp:useBean id="HrmFieldGroupComInfo" class="weaver.hrm.definedfield.HrmFieldGroupComInfo" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<%@page import="weaver.systeminfo.systemright.CheckSubCompanyRight"%>
<%@page import="weaver.hrm.moduledetach.ManageDetachComInfo"%>

<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
<%
 List<String> lsSamePair = new ArrayList<String>();
 String id = request.getParameter("id");
 String isView = request.getParameter("isView");
 boolean isHr = false;
 rs.executeProc("HrmResource_SelectByID",id);
 rs.next();
 String departmentidtmp = Util.null2String(rs.getString("departmentid"));
 String f_weaver_belongto_userid = HrmUserVarify.getcheckUserRightUserId("HrmResourceEdit:Edit",user,departmentidtmp);
 if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentidtmp)){
	  isHr = true;
	}
 String hasLoginid = "".equals(Util.null2String(ResourceComInfo.getLoginID(id),""))?"false":"true";
 int scopeId = -1;
 
 // no edit 
 
boolean isSelf=false;
if (id.equals(""+user.getUID()) ){
	isSelf = true;
}

String subcompanyid = Util.toScreen(rs.getString("subcompanyid1"),user.getLanguage()) ;
if(subcompanyid==null||subcompanyid.equals("")||subcompanyid.equalsIgnoreCase("null")) subcompanyid="-1";

int operatelevel=-1;
CheckSubCompanyRight CheckSubCompanyRight = new CheckSubCompanyRight() ;
ManageDetachComInfo ManageDetachComInfo = new ManageDetachComInfo() ;

//人力资源模块是否开启了管理分权，如不是，则不显示框架，直接转向到列表页面(新的分权管理)
int hrmdetachable=0;
if(session.getAttribute("hrmdetachable")!=null){
    hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
}else{
	boolean isUseHrmManageDetach=ManageDetachComInfo.isUseHrmManageDetach();
	if(isUseHrmManageDetach){
	   hrmdetachable=1;
	   session.setAttribute("detachable","1");
	   session.setAttribute("hrmdetachable",String.valueOf(hrmdetachable));
	}else{
	   hrmdetachable=0;
	   session.setAttribute("detachable","0");
	   session.setAttribute("hrmdetachable",String.valueOf(hrmdetachable));
	}
}

if(hrmdetachable==1){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Integer.parseInt(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user))
        operatelevel=2;
}
String status = Util.toScreen(rs.getString("status"),user.getLanguage()) ;

if((isSelf||operatelevel>0)&&!status.equals("10")){
	 
}else{
    response.sendRedirect("/notice/noright.jsp") ;
	return ; 
}
 
%>
<%@ include file="/hrm/resource/uploader.jsp" %>
<head>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  <link href="/hrm/css/Contacts_wev8.css" rel="stylesheet" type="text/css" />
	<link href="/hrm/css/Public_wev8.css" rel="stylesheet" type="text/css" />
  <SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
  <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
  <SCRIPT language="javascript" src="/js/checknumber_wev8.js"></script>
  <script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
	<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
	<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
  <style type="text/css">
	.InputStyle{width:30%!important;}
	.inputstyle{width:30%!important;}
	.Inputstyle{width:30%!important;}
	.inputStyle{width:30%!important;}
	.e8_os{width:30%!important;}
	select.InputStyle{width:10%!important;} 
	select.inputstyle{width:10%!important;} 
	select.inputStyle{width:10%!important;} 
	select.Inputstyle{width:10%!important;} 
	textarea.InputStyle{width:70%!important;} 
	</style>
<SCRIPT language="javascript">
var common = new MFCommon();
function showAlert(msg){
    window.top.Dialog.alert(msg);
}
function showConfirm(msg){
    window.top.Dialog.confirm(msg,function(){
		checkPass();
		return true;
	},function(){
		return false;
	})
    //return confirm(msg);
}
function checkPass(){
    saveBtn.disabled = true;
    document.resourcebasicinfo.submit() ;
}

function onBelongToChange(){
	val = jQuery("#accounttype").val();
	if(val=="0"){
		hideEle("belongtodata");
		jQuery("input[name=belongto]").attr("ismustinput","1")
	}
	else {
		showEle("belongtodata");
		if (jQuery("input[name=belongto]").val() == "" ||jQuery("input[name=belongto]").val() == "-1"){
			jQuery("input[name=belongto]").attr("ismustinput","2")
			jQuery("#belongtospanimg").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		}
	} 
}

jQuery(document).ready(function(){
	if($("#accounttype").length>0){
		$("#accounttype").change(function(){
	  	onBelongToChange();
		});
	}

	//绑定照片上传事件
    jQuery("input[name=photoid]").bind("onchange",function(event){
        check_photo(event);
    });
})
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
</head>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(61,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();

boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String ifinfo = Util.null2String(request.getParameter("ifinfo"));//检查loginid参数
String workcode ="";
String lastname ="";
String costcenterid ="";
String mobileshowtype = "";
String sql = "";
sql = "select costcenterid,mobileshowtype from HrmResource where id = "+Util.getIntValue(id,-1);
rs.executeSql(sql);
if(rs.next()){
  costcenterid = Util.null2String(rs.getString("costcenterid"));
  mobileshowtype = Util.null2String(rs.getString("mobileshowtype"));
}
HashMap<String,String> mapHideData = new HashMap<String,String>();
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewBasicInfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
String needinputitems = "";
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<iframe id="checkHas" style="display:none"></iframe>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="dosave(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
		  <input type=button class="e8_btn_top" onclick="viewBasicInfo();" value="<%=SystemEnv.getHtmlLabelName(1290, user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM name=resourcebasicinfo id=resourcebasicinfo action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<input class=inputstyle type=hidden name=operation >
<input class=inputstyle type=hidden id=id name=id value="<%=id%>">
<input class=inputstyle type=hidden name=isView value="<%=isView%>">
<input class=inputstyle type=hidden name=isfromtab value="<%=isfromtab%>"> 
<input class=inputstyle type=hidden name=scopeid value="<%=scopeId%>">
<input class=inputstyle type=hidden name=costcenterid value="<%=costcenterid%>">
<input class=inputstyle type=hidden id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>">
<%
if(ifinfo.equals("y")){
%>
 <DIV>
<font color=red size=2>
<%=SystemEnv.getHtmlLabelName(22160,user.getLanguage())%>
</div>
<%}%>
 	<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
<%
HrmFieldGroupComInfo.setTofirstRow();
HrmFieldManager hfm = new HrmFieldManager("HrmCustomFieldByInfoType",scopeId);
CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
hfm.getHrmData(Util.getIntValue(id));
cfm.getCustomData(Util.getIntValue(id));
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
	%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(grouplabel,user.getLanguage())%>' attributes="<%=groupattr %>">	
<%
	while(hfm.next()){
		int fieldlabel=Util.getIntValue(hfm.getLable());
		String fieldName=hfm.getFieldname();
		int fieldId=hfm.getFieldid();
		int type = hfm.getType();
		String dmlurl = hfm.getDmrUrl();
		int fieldhtmltype = Util.getIntValue(hfm.getHtmlType());
		String fieldValue="";
		if(hfm.isBaseField(fieldName)){
			fieldValue = hfm.getHrmData(fieldName);
			if(hfm.isUse() && hfm.isMand() && !fieldName.equals("managerid"))  needinputitems+= ","+fieldName;
		}else{
			if(hfm.getHtmlType().equals("6") && groupid!=1 && groupid!=2 && groupid!=3 && !HrmListValidate.isValidate(41)){
				continue;
			}
			fieldValue = cfm.getData("field"+hfm.getFieldid());
			if(hfm.isUse() && hfm.isMand())  needinputitems+= ",customfield"+hfm.getFieldid();
		}
		if(!hfm.isUse()){
			mapHideData.put(fieldName,fieldValue);
			continue;
		}
		
		if(fieldName.equals("loginid")||fieldName.equals("jobactivity")||fieldName.equals("departmentvirtualids"))continue;
		
		if(fieldName.equals("systemlanguage") && !isMultilanguageOK)continue;
		if(fieldName.equals("accounttype") && !flagaccount)continue;
		if(fieldName.equals("workcode"))workcode=fieldValue;
		if(fieldName.equals("lastname")){
			lastname=fieldValue;
			lastname = lastname.endsWith("\\")&&!lastname.endsWith("\\\\") == true ? lastname+ "\\" :lastname;
		}
		JSONObject hrmFieldConf = hfm.getHrmFieldConf(fieldName);
		String attr = "{}";
		if(fieldName.equals("belongto"))attr = "{\"samePair\":\"belongtodata\",'display':'none'}";
		if(fieldName.equals("status")){
			//状态不可编辑
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		<wea:item>
            <%if(fieldValue.equals("0")){%><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%><%}%>
			<%if(fieldValue.equals("1")){%><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%><%}%>
			<%if(fieldValue.equals("2")){%><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%><%}%>
			<%if(fieldValue.equals("3")){%><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%><%}%>
			<%if(fieldValue.equals("4")){%><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%><%}%>
			<%if(fieldValue.equals("5")){%><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%><%}%>
			<%if(fieldValue.equals("6")){%><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%><%}%>
			<%if(fieldValue.equals("7")){%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%><%}%>
			<%if(fieldValue.equals("10")){%><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%><%}%>
			<input class=inputstyle type=hidden name=status value="<%=fieldValue%>">
		</wea:item>
		<%}else if(fieldName.equals("mobile")){
			RemindSettings hrmsettings=(RemindSettings)application.getAttribute("hrmsettings");
		  String mobileShowSet = Util.null2String(hrmsettings.getMobileShowSet());
		  String mobileShowType = Util.null2String(hrmsettings.getMobileShowType());
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></wea:item>
		<wea:item>
		  <%=((HtmlElement)Class.forName(hrmFieldConf.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, hrmFieldConf, user) %>
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
		<%
		}else if(fieldName.equals("resourceimageid")){
		//照片特殊处理
		%>
		<%if(!fieldValue.equals("0")&&!fieldValue.equals("") ){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></wea:item>
      	<wea:item>
      		<div id="boxb" >
      		<BUTTON class=delbtn accessKey=D onClick="delpic()" type="button" title="<%=SystemEnv.getHtmlLabelName(16075,user.getLanguage())%>"></BUTTON>
      		<span style="vertical-align: middle;"><%=SystemEnv.getHtmlLabelName(16075,user.getLanguage())%></span>
      		<input class=inputstyle type=hidden name=oldresourceimage value="<%=fieldValue%>">
      		</div>
      		<div id="boxa" style="display: none">
      		<input class=inputstyle type=file name=photoid onchange="check_photo(event)" value="<%=fieldValue%>" style="width: 300px" accept="image/*">
      		
      		</div>
      	</wea:item>
			<%}else{%>
			<wea:item ><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></wea:item>
			<wea:item><input class=inputstyle type="file" name="photoid" onchange="check_photo(event)" value='<%=fieldValue%>' style="width: 300px" accept="image/*"></wea:item>
			<wea:item>&nbsp;</wea:item>
			<wea:item>(<%=SystemEnv.getHtmlLabelName(21130,user.getLanguage())%>:400*600)</wea:item>
			<%}%>
			<%if(!fieldValue.equals("0")&&fieldValue.length()>0){%>
			<wea:item attributes="{'id':'boxc'}"><%=SystemEnv.getHtmlLabelName(33470,user.getLanguage())%></wea:item>
 				<wea:item>
 				
 				<div id="boxd"><img class="ContactsAvatar" style="right: 0;z-index: 999" border=0 id=resourceimage src="/weaver/weaver.file.FileDownload?fileid=<%=fieldValue%>"></div>
 				<div id="boxe" style="display: none"> (<%=SystemEnv.getHtmlLabelName(21130,user.getLanguage())%>:400*600)</div>
 				</wea:item>
					
			<%} %>
		<% }else if(hfm.getHtmlType().equals("6")){
        	String[] resourceFile = HrmResourceFile.getResourceFile(""+id, scopeId, hfm.getFieldid());
        	int maxsize = 100;
       %>
     <wea:item attributes='<%=attr %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
     <wea:item attributes='<%=attr %>'>
      <div id="uploadDiv" name="uploadDiv" maxsize="<%=maxsize%>" resourceId="<%=id%>" scopeId="<%=scopeId %>" fieldId="<%=hfm.getFieldid()%>"></div>
      <div>
        <%=resourceFile[1] %>
      	<input class=inputstyle type="hidden" id="customfield<%=hfm.getFieldid()%>" name="customfield<%=hfm.getFieldid()%>" value="<%=resourceFile[0].equals("")?"":"1" %>" onchange='checkinput("customfield<%=hfm.getFieldid()%>","customfield<%=hfm.getFieldid()%>span");'>
      		<SPAN id="customfield<%=hfm.getFieldid()%>span">
      		<%
							  if(hfm.isMand()&&resourceFile[0].equals("")) {
							%>
							    <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
							<%
							  }
							%>
					</SPAN>
      </div>
     </wea:item>
		<%}else if(fieldName.equals("departmentid")){
		hrmFieldConf.put("rightStr","HrmResourceEdit:Edit");
       %>
	<wea:item attributes='<%=attr %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item attributes='<%=attr %>'>
		<%=((HtmlElement)Class.forName(hrmFieldConf.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, hrmFieldConf, user) %>
	</wea:item>
	<%}else if(fieldName.equals("systemlanguage")){
       %>
	<wea:item attributes='<%=attr %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item attributes='<%=attr %>'>
         <%=LanguageComInfo.getLanguagename(""+fieldValue)%>   
	</wea:item>
	<%}else{%>
		<wea:item attributes='<%=attr %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=attr %>'>
			<%=((HtmlElement)Class.forName(hrmFieldConf.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, hrmFieldConf, user) %>
		</wea:item>
	<%}
	}
%>
</wea:group>
<%} %>
</wea:layout>
<%
Iterator<Map.Entry<String,String>> iter = mapHideData.entrySet().iterator();
while (iter.hasNext()) {
Map.Entry<String,String> entry = iter.next();
String fieldname = entry.getKey();
String fieldvalue = entry.getValue();
%>
<input type="hidden" name="<%=fieldname %>" value="<%=fieldvalue %>">
<%}%>
</FORM>
<script type="text/javascript">

function changeaa(){
	$("#boxa").show();
	$("#boxe").show();
	$("#boxb").hide();
	$("#boxd").hide();
	$("#boxc").text("");
}

function onShowJobtitle(){ 
	url=encode("/hrm/jobtitles/JobTitlesBrowser.jsp?sqlwhere= where jobdepartmentid="+jQuery("input[name=departmentid]").val()+"&fromPage=add");
	url="/systeminfo/BrowserMain.jsp?mouldID=hrm&url="+url;
	return url;
	
	url=encode("/hrm/jobtitles/JobTitlesBrowser.jsp?sqlwhere= where jobdepartmentid="+jQuery("input[name=departmentid]").val()+"&fromPage=add");
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
	if (data!=null){
		if (data.id != 0 ){
			jQuery("#jobtitlespan").html(data.name);
			jQuery("input[name=jobtitle]").val(data.id);
		}else{
			jQuery("#jobtitlespan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name=jobtitle]").val("");
		}
	}
}


function onShowDepartment(){
    url=encode("/hrm/company/DepartmentBrowser3.jsp?isedit=1&rightStr=HrmResourceEdit:Edit&selectedids="+resourcebasicinfo.departmentid.value);
    url = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url="+url;
    return url;
    
	 issame = false;
	 if(datas){
		  if(datas.id!= 0){
			   if(datas.id == resourcebasicinfo.departmentid.value){
			    	issame = true;
			   }
			   departmentspan.innerHTML = datas.name;
			   resourcebasicinfo.departmentid.value=datas.id;
		   }else{
			   departmentspan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			   resourcebasicinfo.departmentid.value="";
		  }
		  if(!issame){
			  jobtitlespan.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			  resourcebasicinfo.jobtitle.value="";
		  }
	 }
}
</script>
 <script type="text/javascript">
 //参考workflowswfupload.js
  var saveBtn;
  var upfilesnum=0;//获得上传文件总数
  function encode(str){
       return escape(str);
    }  
  function checkMobile() {
	  if(jQuery("#mobile").val() == null || jQuery("#mobile").val() == ''){
		  return true;
	  }
	  var cellphone=/1[3-8]+\d{9}/;
	  if(!cellphone.test(jQuery("#mobile").val())) {
		  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83707,user.getLanguage())%>");
		  document.resourcebasicinfo.mobile.focus();
		  return false;
	  } else {
		  return true;
	  }
  }
  function dosave(obj){
  if(!checkMail()) return false;
  //if(!checkMobile()) return false;
		saveBtn = obj;
   if(jQuery("#accounttype").val()=="1"){
  	if (jQuery("input[name=belongto]").val() == "" ||jQuery("input[name=belongto]").val() == "-1"){
  		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
  		return false;
  	}
  }
  if(check_form(document.resourcebasicinfo,'<%=needinputitems%>')) {
	try{
		var oldDeptId = "<%=departmentidtmp%>";
		var newDeptId = $GetEle("departmentid").value;
		if(newDeptId != oldDeptId){
			if("true" == "<%=hasLoginid%>"){
				var result = common.ajax("cmd=checkNewDeptUsers&arg="+newDeptId+"&currentUserId=<%=id%>");
				if(result && result == "true"){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81926,user.getLanguage())%>");
					return false;
				}
			}
		}
	}catch(e){}
	 	jQuery("div[name=uploadDiv]").each(function(){
	 		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
	   	if(oUploader.getStats().files_queued>0){
	   		upfilesnum+=oUploader.getStats().files_queued;
	   		oUploader.startUpload();
	   	}
	   });
	 	if(upfilesnum==0) doSaveAfterAccUpload();
		}
	}
function doSaveAfterAccUpload(){
  var frmLastName = encodeURI(document.all("lastname").value);//url编码 utf-8；
  var frmworkcode = encodeURI(jQuery("#workcode").val());//url编码 utf-8；
  var lastname = "<%=java.net.URLEncoder.encode(lastname,"utf-8")%>";
    
  if(jQuery("input[name=managerid]").val()==""){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16072,user.getLanguage())%>",function(){
	 		//校验电子邮件
  	if(!chkMail()) return false;
  	if(<%=flagaccount%>){
	  	if(document.resourcebasicinfo.accounttype.value ==0){
	    	if(document.resourcebasicinfo.departmentid.value==""||
     			document.resourcebasicinfo.jobtitle.value==""||
     			document.resourcebasicinfo.locationid.value==""){
    			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
  			}else{
    			if(document.resourcebasicinfo.costcenterid.value=="") document.resourcebasicinfo.costcenterid.value=1;
    			if(check_formM(document.resourcebasicinfo,'lastname,locationid')){
      			document.resourcebasicinfo.operation.value = "editbasicinfo";
      			if(frmLastName!=lastname&&jQuery("#workcode").val()!="<%=workcode%>"){
        			jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName+"&workcode="+frmworkcode;
      			}else if(jQuery("#workcode").val()!="<%=workcode%>"){
        			jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?workcode="+frmworkcode;
      			}else if(frmLastName!=lastname){
        			jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName;
      			}else{
        			saveBtn.disabled = true;
        			document.resourcebasicinfo.submit() ;
      			}
    			}
  			}
	  	}else{
	    	if(document.resourcebasicinfo.departmentid.value==""||
     			 document.resourcebasicinfo.jobtitle.value==""||
	 				 document.resourcebasicinfo.belongto.value==""||
     			 document.resourcebasicinfo.locationid.value==""){
     			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
  			}else{
    			if(document.resourcebasicinfo.costcenterid.value=="")document.resourcebasicinfo.costcenterid.value=1;
    			if(check_formM(document.resourcebasicinfo,'lastname,locationid')){
      			document.resourcebasicinfo.operation.value = "editbasicinfo";
	      		if(frmLastName!=lastname&&jQuery("#workcode").val()!="<%=workcode%>"){
        			jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName+"&workcode="+frmworkcode;
      			}else if(jQuery("#workcode").val()!="<%=workcode%>"){
        			jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?workcode="+frmworkcode;
      			}else if(frmLastName!=lastname){
        			jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName;
      			}else{
        			saveBtn.disabled = true;
        			document.resourcebasicinfo.submit() ;
      			}
    			}
  			}
	  	}
	  }else{
	  	if(document.resourcebasicinfo.departmentid.value==""||
     		 document.resourcebasicinfo.jobtitle.value==""||
     		 document.resourcebasicinfo.locationid.value==""){
     		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
  		}else{
    		if(document.resourcebasicinfo.costcenterid.value=="")document.resourcebasicinfo.costcenterid.value=1;
    		if(check_formM(document.resourcebasicinfo,'lastname,locationid')){
      		document.resourcebasicinfo.operation.value = "editbasicinfo";
	      	if(frmLastName!=lastname&&jQuery("#workcode").val()!="<%=workcode%>"){
       			jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName+"&workcode="+frmworkcode;
   			}else if(jQuery("#workcode").val()!="<%=workcode%>"){
     			jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?workcode="+frmworkcode;
   			}else if(frmLastName!=lastname){
     			jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName;
   			}else{
     			saveBtn.disabled = true;
     			document.resourcebasicinfo.submit() ;
   			}
 			}
  		}
	  }
	},function(){
	  	return false;
	  });
	}else{
		//校验电子邮件
  	if(!chkMail()) return false;
  	if(<%=flagaccount%>){
	  	if(document.resourcebasicinfo.accounttype.value ==0){
	    	if(document.resourcebasicinfo.departmentid.value==""||
     			 document.resourcebasicinfo.jobtitle.value==""||
     			 document.resourcebasicinfo.locationid.value==""){
     			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
  			}else{
    			if(document.resourcebasicinfo.costcenterid.value=="")document.resourcebasicinfo.costcenterid.value=1;
    			if(check_formM(document.resourcebasicinfo,'lastname,locationid')){
      			document.resourcebasicinfo.operation.value = "editbasicinfo";
      			if(jQuery("#lastname").val()!="<%=lastname%>"&&jQuery("#workcode").val()!="<%=workcode%>"){
        			jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName+"&workcode="+frmworkcode;
        			//checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val()+"&workcode="+jQuery("#workcode").val();
			      }else if(jQuery("#workcode").val()!="<%=workcode%>"){
			        	jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?workcode="+frmworkcode;
			        //checkHas.src="HrmResourceCheck.jsp?workcode="+jQuery("#workcode").val();
			      }else if(jQuery("#lastname").val()!="<%=lastname%>"){
			        jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName;
			        //checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val();
			      }else{
        			saveBtn.disabled = true;
        			document.resourcebasicinfo.submit() ;
      			}
      		}
  		  }
	  	}else{
	  		if(document.resourcebasicinfo.departmentid.value==""||
     			document.resourcebasicinfo.jobtitle.value==""||
	 				document.resourcebasicinfo.belongto.value==""||
     			document.resourcebasicinfo.locationid.value==""){
     	 			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
  			}else{
    			if(document.resourcebasicinfo.costcenterid.value=="")document.resourcebasicinfo.costcenterid.value=1;
    			if(check_formM(document.resourcebasicinfo,'lastname,locationid')){
      			document.resourcebasicinfo.operation.value = "editbasicinfo";
	      		if(jQuery("#lastname").val()!="<%=lastname%>"&&jQuery("#workcode").val()!="<%=workcode%>"){
        			jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName+"&workcode="+frmworkcode;
        			//checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val()+"&workcode="+jQuery("#workcode").val();
			      }else if(jQuery("#workcode").val()!="<%=workcode%>"){
			        	jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?workcode="+frmworkcode;
			        //checkHas.src="HrmResourceCheck.jsp?workcode="+jQuery("#workcode").val();
			      }else if(jQuery("#lastname").val()!="<%=lastname%>"){
			        jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName;
			        //checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val();
			      }else{
        			saveBtn.disabled = true;
        			document.resourcebasicinfo.submit() ;
      			}
    			}
  			}
	  	}
		}else{
	  	if(document.resourcebasicinfo.departmentid.value==""||
     		 document.resourcebasicinfo.jobtitle.value==""||
     		 document.resourcebasicinfo.locationid.value==""){
     		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
  		}else{
    		if(document.resourcebasicinfo.costcenterid.value=="")document.resourcebasicinfo.costcenterid.value=1;
    		if(check_formM(document.resourcebasicinfo,'lastname,locationid')){
      		document.resourcebasicinfo.operation.value = "editbasicinfo";
      		if(jQuery("#lastname").val()!="<%=lastname%>"&&jQuery("#workcode").val()!="<%=workcode%>"){
       			jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName+"&workcode="+frmworkcode;
       			//checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val()+"&workcode="+jQuery("#workcode").val();
		      }else if(jQuery("#workcode").val()!="<%=workcode%>"){
		        	jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?workcode="+frmworkcode;
		        //checkHas.src="HrmResourceCheck.jsp?workcode="+jQuery("#workcode").val();
		      }else if(jQuery("#lastname").val()!="<%=lastname%>"){
		        jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName;
		        //checkHas.src="HrmResourceCheck.jsp?lastname="+jQuery("#lastname").val();
		      }else{
       			saveBtn.disabled = true;
       			document.resourcebasicinfo.submit() ;
     			}
    		}
  		}
	  }
	}
}

 function delpic(){
      if(confirm("<%=SystemEnv.getHtmlLabelName(83460,user.getLanguage())%>")){
	  //document.resourcebasicinfo.operation.value = "delpic";
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
    
  jQuery(document).ready(function(){
    //绑定附件上传
    if(jQuery("div[name=uploadDiv]").length>0)
    	jQuery("div[name=uploadDiv]").each(function(){
        bindUploaderDiv($(this),"relatedacc"); 
      });
  });
  
  function filedel(inputname,spanname,fileid){
  	jQuery("#file"+fileid).remove();
  	//删除附件
		jQuery.ajax({
		type:'post',
		url:'uploaderOperate.jsp',
		data:{"cmd":"delete","fileId":fileid},
		dataType:'text',
		success:function(msg){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20461, user.getLanguage())%>");
		},
		error:function(){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20462, user.getLanguage())%>");
		}
		});
  }
  
  function downloads(files)
  { 
  	$G("fileDownload").src="/weaver/weaver.file.FileDownload?fileid="+files+"&download=1";
  }
  
  jQuery(document).ready(function(){
	<%if(departmentidtmp.length()>0){%>
	showEle("itemjobtitle");
	<%}%>
	
	<%for(int i=0;lsSamePair!=null&&i<lsSamePair.size();i++){%>
   hideGroup("<%=lsSamePair.get(i)%>");
   <%}%>
	})

function chkMail(){
	if(!document.forms[0].enddate || document.resourcebasicinfo.email.value == ''){
		return true;
	}

	var email = document.resourcebasicinfo.email.value;
	var pattern =  /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i;
	chkFlag = pattern.test(email);
	if(chkFlag){
		return true;
	}
	else
	{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24570,user.getLanguage())%>");
		document.resourcebasicinfo.email.focus();
		return false;
	}
	}
	
	function checkMail(){
		if(jQuery("#email").val()==null || jQuery("#email").val()==''){
			return true;
		}
		var email = jQuery("#email").val();
		var pattern =  /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i;
		chkFlag = pattern.test(email);
		if(chkFlag){
			return true;
		}else{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24570,user.getLanguage())%>");
			jQuery("#email").focus();
			return false;
		}
	}
	
	function onShowBrowser(id,url,linkurl,type1,ismand){
    spanname = "customfield"+id+"span";
	inputname = "customfield"+id;
	if (type1== 2 || type1 == 19){
		if (type1 == 2){
			onWorkFlowShowDate(spanname,inputname,ismand);
		}else{
			onWorkFlowShowTime(spanname,inputname,ismand);
		}
	}else{
		if (type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170&& type1!=168){
			tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids);
		}else if (type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
            tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?selectedids="+tmpids)
		}else if (type1==37){
            tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?documentids="+tmpids)
		}else{
			tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids)
		}
		if (id1!=null){
			if (type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65|| type1==168){
				if (id1.id!= ""  && id1.id!= "0"){
					ids = id1.id.split(",");
					names =id1.name.split(",");
					sHtml = "";
					id1ids="";
					id1idnum=0;
					for( var i=0;i<ids.length;i++){
						if(ids[i]!=""){
							curid=ids[i];
							curname=names[i];					
							sHtml = sHtml+"<a href="+linkurl+curid+">"+curname+"</a>&nbsp;";
							if(id1idnum==0){
								id1ids=curid;
								id1idnum++;
							}else{
								id1ids=id1ids+","+curid;
								id1idnum++;
							}
						}
					}
					
					jQuery("#customfield"+id+"span").html(sHtml);
					jQuery("input[name=customfield"+id+"]").val(id1ids);					
				}else{
					if (ismand==0){
						jQuery("#customfield"+id+"span").html("");
					}else{
						jQuery("#customfield"+id+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
						}
					jQuery("input[name=customfield"+id+"]").val("");
				}
			}else{
			   if  (id1.id!="" && id1.id!= "0"){
			        if (linkurl == ""){
						jQuery("#customfield"+id+"span").html(id1.name);
					}else{
						jQuery("#customfield"+id+"span").html("<a href="+linkurl+id1.id+">"+id1.name+"</a>");
					}
					jQuery("input[name=customfield"+id+"]").val(id1.id);
			   }else{
					if (ismand==0){
						jQuery("#customfield"+id+"span").html("");
					}else{
						jQuery("#customfield"+id+"span").html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
					}
					jQuery("input[name=customfield"+id+"]").val("");
				}
			}
		}
	}
}

function onShowResourceConditionBrowserBack(e,dialogId,name){
	if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
		var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
		var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
		var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
		var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
		var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
		var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
		var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
		var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);
	
		var sHtml = "";
		var fileIdValue = "";
		shareTypeValues = shareTypeValues.substr(1);
		shareTypeTexts = shareTypeTexts.substr(1);
		relatedShareIdses = relatedShareIdses.substr(1);
		relatedShareNameses = relatedShareNameses.substr(1);
		rolelevelValues = rolelevelValues.substr(1);
		rolelevelTexts = rolelevelTexts.substr(1);
		secLevelValues = secLevelValues.substr(1);
		secLevelTexts = secLevelTexts.substr(1);
	
		var shareTypeValueArray = shareTypeValues.split("~");
		var shareTypeTextArray = shareTypeTexts.split("~");
		var relatedShareIdseArray = relatedShareIdses.split("~");
		var relatedShareNameseArray = relatedShareNameses.split("~");
		var rolelevelValueArray = rolelevelValues.split("~");
		var rolelevelTextArray = rolelevelTexts.split("~");
		var secLevelValueArray = secLevelValues.split("~");
		var secLevelTextArray = secLevelTexts.split("~");
		for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {
	
			var shareTypeValue = shareTypeValueArray[_i];
			var shareTypeText = shareTypeTextArray[_i];
			var relatedShareIds = relatedShareIdseArray[_i];
			var relatedShareNames = relatedShareNameseArray[_i];
			var rolelevelValue = rolelevelValueArray[_i];
			var rolelevelText = rolelevelTextArray[_i];
			var secLevelValue = secLevelValueArray[_i];
			var secLevelText = secLevelTextArray[_i];
	
			fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
					+ relatedShareIds + "_" + rolelevelValue + "_"
					+ secLevelValue;

			if (shareTypeValue == "1") {
				sHtml = sHtml + "," + shareTypeText + "("
						+ relatedShareNames + ")";
			} else if (shareTypeValue == "2") {
				sHtml = sHtml
						+ ","
						+ shareTypeText
						+ "("
						+ relatedShareNames
						+ ")"
						+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValue
						+ "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage())%>";
			} else if (shareTypeValue == "3") {
				sHtml = sHtml
						+ ","
						+ shareTypeText
						+ "("
						+ relatedShareNames
						+ ")"
						+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValue
						+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage())%>";
			} else if (shareTypeValue == "4") {
				sHtml = sHtml
						+ ","
						+ shareTypeText
						+ "("
						+ relatedShareNames
						+ ")"
						+ "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>="
						+ rolelevelText
						+ "  <%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValue
						+ "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage())%>";
			} else {
				sHtml = sHtml
						+ ","
						+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValue
						+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage())%>";
			}
		}
				
		sHtml = sHtml.substr(1);
		fileIdValue = fileIdValue.substr(1);

		jQuery("#"+name).val(fileIdValue);
		jQuery("#"+name+"span").html(sHtml);
	}else{
		if (ismand == 0) {
			jQuery("#"+name+"span").html("");
		} else {
			jQuery("#"+name+"span").html("<img src='/images/BacoError.gif' align=absmiddle>");
		}
		jQuery("#"+name).val("");
	}
}

jQuery(document).ready(function(){
	if(jQuery("#accounttype").val() =="1"){
		onBelongToChange();
		jQuery("input[name=belongto]").attr("ismustinput","2")
	}
})
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
