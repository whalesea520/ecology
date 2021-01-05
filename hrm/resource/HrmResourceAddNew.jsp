<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.definedfield.HrmFieldManager"%>
<%@ page import="weaver.hrm.util.html.HtmlElement"%>
<%@ page import="java.util.*,weaver.docs.docs.CustomFieldManager,weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="HrmFieldGroupComInfo" class="weaver.hrm.definedfield.HrmFieldGroupComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="HrmResourceFile" class="weaver.hrm.tools.HrmResourceFile" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%@page import="org.json.JSONObject"%>
<%@ include file="/hrm/resource/uploader.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%!
//2004-6-16 Edit by Evan:得到user的级别，总部的user可以看到所有部门，分部和部门级的user只能看到所属的部门
    private String getDepartmentSql(User user){
        String sql ="";
        String rightLevel = HrmUserVarify.getRightLevel("HrmResourceEdit:Edit",user);
        int departmentID = user.getUserDepartment();
        int subcompanyID = user.getUserSubCompany1();
        if(rightLevel.equals("2") ){
          //总部级别的，什么也不返回
        }else if (rightLevel.equals("1")){ //分部级别的
          sql = " WHERE subcompanyid1="+subcompanyID ;
        }else if (rightLevel.equals("0")){ //部门级别
          sql = " WHERE id="+departmentID ;
        }
        //System.out.println("sql = "+sql);
        return sql;
    }
//End Edit
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
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
    document.resource.submit() ;
}

function onBelongToChange(){
	val = jQuery("#accounttype").val();
	if(val=="0"){
		hideEle("belongtodata");
	}
	else {
		showEle("belongtodata");
		if (jQuery("input[name=belongto]").val() == ""){
			jQuery("#belongtospanimg").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		}
		
		jQuery("input[name=belongto]").attr("ismustinput","2");
	} 
}


jQuery(document).ready(function(){
  //绑定附件上传
  if(jQuery("div[name=uploadDiv]").length>0)
  	jQuery("div[name=uploadDiv]").each(function(){
      bindUploaderDiv($(this),"relatedacc"); 
    });
    
  jQuery("input[name=belongto]").bind("propertychange",function(){
    	if(jQuery("input[name=belongto]").val()==""){
		jQuery("#belongtospanimg").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	}
    });

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
<SCRIPT language="javascript" src="/js/chechinput_wev8.js"></script>
	<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
</HEAD>
<%
List<String> lsSamePair = new ArrayList<String>();
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String f_weaver_belongto_userid = HrmUserVarify.getcheckUserRightUserId("HrmResourceAdd:Add",user);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";

String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
if("".equals(subcompanyid1) && !"".equals(departmentid)){
	subcompanyid1 = DepartmentComInfo.getSubcompanyid1(departmentid);
}
boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();
String ifinfo = Util.null2String(request.getParameter("ifinfo"));//检查loginid参数

int scopeId = -1;
String needinputitems = "";

int operatelevel= 0;
String hrmdetachable="0";
int rolelevel = -2;
boolean isUseHrmManageDetach=ManageDetachComInfo.isUseHrmManageDetach();
String defaultDept = "",defaultSub = "";
if("1".equals(session.getAttribute("detachable"))){
	if("1".equals(session.getAttribute("hrmdetachable"))){
		hrmdetachable = "1";
	}
}
if(user.getUID() != 1){
	if("1".equals(hrmdetachable)){
		operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceAdd:Add",Util.getIntValue(subcompanyid1,-1));
	}else{
		if(HrmUserVarify.checkUserRight("HrmResourceAdd:Add", user)){
				 String sql = "select max(a.rolelevel) as rolelevel from hrmrolemembers a ,systemrightroles b,systemrights c,systemrightdetail d" +
		                    " where a.roleid=b.roleid and b.rightid=c.id and c.id=d.rightid " +
		                    "and a.rolelevel>=b.rolelevel and a.resourceid=" + user.getUID() +
		                    " and d.rightdetail='HrmResourceAdd:Add'";
		         RecordSet.executeSql(sql);
		         RecordSet.next();
		         rolelevel = Util.getIntValue(RecordSet.getString("rolelevel"),-2);
		         ArrayList<String> childList = new ArrayList<String>();
		         
		         if(rolelevel == 0){//部门
		         	DepartmentComInfo.getAllChildDeptByDepId(childList,user.getUserDepartment()+"");
		         	defaultDept = user.getUserDepartment()+"";
			         if(childList.size() > 0){
			         	for(String dept : childList){
			         		defaultDept += ","+dept;
			         	}
			         }
		         }else if(rolelevel == 1){//分部
		         	defaultSub = user.getUserSubCompany1()+"";
		         	SubCompanyComInfo.getAllChildSubcompanyId(user.getUserSubCompany1()+"",defaultSub);
		         }
			 operatelevel = 2;
		}
	}

}else{
	operatelevel = 2;
}
if(Util.getIntValue(subcompanyid1,-1) == -1){
	operatelevel = 2;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel >= 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSaveAndToList(this),_TOP} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32720,user.getLanguage())+",javascript:doSaveAndNew(this),_TOP} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(33199,user.getLanguage())+",javascript:doSaveAndNext(this),_TOP} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<iframe id="checkHas" src="" style="display:none"></iframe>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%
if(operatelevel >= 1){
		 %>
			<input type=button class="e8_btn_top" onclick="doSaveAndToList(this);" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>">
			<input type=button class="e8_btn_top" onclick="doSaveAndNew(this);" value="<%=SystemEnv.getHtmlLabelName(32720,user.getLanguage())%>">
			<input type=button class="e8_btn_top" onclick="doSaveAndNext(this);" value="<%=SystemEnv.getHtmlLabelName(33199,user.getLanguage())%>">
			<%
			}
			 %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
/*登录名冲突*/
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<%
      if(ifinfo.equals("y")){
      %>
      <DIV>
     <font color=red size=2>
     <%=SystemEnv.getHtmlLabelName(25170,user.getLanguage())%>
      </div>
     <%}%>
<FORM name=resource id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<input class=inputstyle type=hidden name=cmd value="">
<input class=inputstyle type=hidden name=scopeid value="<%=scopeId%>">
<INPUT class=inputstyle id=costcenterid type=hidden name=costcenterid value='1'>
<input class=inputstyle type=hidden name=operation value="addresourcebasicinfo">
<input class=inputstyle type=hidden id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>">
<%
  String sql = "select max(id) from HrmResource";
  rs.executeSql(sql);
  rs.next();
  int id = rs.getInt(1);
  sql = "select max(id) from HrmCareerApply";
  rs.executeSql(sql);
  rs.next();
  if(id<rs.getInt(1)){
    id = rs.getInt(1);
  }
    id +=1;
  int socopeId=-1;  
%>
<input class=inputstyle type=hidden name=id value="<%=id%>">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
<%
HrmFieldGroupComInfo.setTofirstRow();
HrmFieldManager HrmFieldManager = new HrmFieldManager("HrmCustomFieldByInfoType",socopeId);
while(HrmFieldGroupComInfo.next()){
	int grouptype = Util.getIntValue(HrmFieldGroupComInfo.getType());
	if(grouptype!=socopeId)continue; 
	int grouplabel = Util.getIntValue(HrmFieldGroupComInfo.getLabel());
	int groupid = Util.getIntValue(HrmFieldGroupComInfo.getid());
	HrmFieldManager.getCustomFields(groupid);
	if(HrmFieldManager.getGroupCount()==0)continue;
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
	while(HrmFieldManager.next()){
		if(!HrmFieldManager.isUse())continue;
		int fieldlabel=Util.getIntValue(HrmFieldManager.getLable());
		String fieldName=HrmFieldManager.getFieldname();
		if(fieldName.equals("loginid")||fieldName.equals("jobactivity"))continue;
		String fieldValue="";
		if(HrmFieldManager.isBaseField(fieldName)){
			if(HrmFieldManager.isUse()&&HrmFieldManager.isMand()&& !fieldName.equals("managerid"))  needinputitems+= ","+fieldName;
		}else{
			if(HrmFieldManager.getHtmlType().equals("6") && groupid!=1 && groupid!=2 && groupid!=3 && !HrmListValidate.isValidate(41)){
				continue;
			}
			if(HrmFieldManager.isUse()&&HrmFieldManager.isMand())  needinputitems+= ",customfield"+HrmFieldManager.getFieldid();
		}
		if(fieldName.equals("departmentid")){
			fieldValue = departmentid;
		}
		JSONObject hrmFieldConf = HrmFieldManager.getHrmFieldConf(fieldName);
		String attr = "{}";
		if(fieldName.equals("belongto"))attr = "{\"samePair\":\"belongtodata\",'display':'none'}";
		if(!flagaccount&&(fieldName.equals("accounttype")||fieldName.equals("belongto")))continue;
		
		if(fieldName.equals("mobile")){
			RemindSettings hrmsettings=(RemindSettings)application.getAttribute("hrmsettings");
		  String mobileShowSet = Util.null2String(hrmsettings.getMobileShowSet());
		  String mobileShowType = Util.null2String(hrmsettings.getMobileShowType());
		  String mobileShowTypeDefault = Util.null2String(hrmsettings.getMobileShowTypeDefault());
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></wea:item>
		<wea:item>
		  <%=((HtmlElement)Class.forName(hrmFieldConf.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, hrmFieldConf, user) %>
		  <%if(mobileShowSet.equals("1")){%>
			<select name="mobileshowtype" style="width: 165px">
			 	<%if(mobileShowType.indexOf("1")!=-1){ %>
			 	<option value="1" <%=mobileShowTypeDefault.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(2161,user.getLanguage())%></option>
			 	<%}if(mobileShowType.indexOf("2")!=-1){ %>
			 	<option value="2" <%=mobileShowTypeDefault.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32670,user.getLanguage())%></option>
			 	<%}if(mobileShowType.indexOf("3")!=-1){ %>
			 	<option value="3" <%=mobileShowTypeDefault.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32671,user.getLanguage())%></option>
			 	<%} %>
		 	</select>
		 <%}else{%>
		 	<input class="inputstyle" type="hidden" name="mobileshowtype" value="<%=mobileShowTypeDefault%>">
		 <%}%>
		</wea:item>		
		<%
		}else if(fieldName.equals("resourceimageid")){
			//照片特殊处理
			%>
			<%if(!fieldValue.equals("0")&&!fieldValue.equals("") ){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></wea:item>
	      	<wea:item>
	      		<BUTTON class=delbtn accessKey=D onClick="delpic()" type="button" title="<%=SystemEnv.getHtmlLabelName(16075,user.getLanguage())%>"></BUTTON>
	      		<span style="vertical-align: middle;"><%=SystemEnv.getHtmlLabelName(16075,user.getLanguage())%></span>
	      		<input class=inputstyle type=hidden name=oldresourceimage value="<%=id%>">
	      	</wea:item>
				<%}else{%>
				<wea:item><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></wea:item>
				<wea:item><input class=inputstyle type="file" onchange="check_photo(event)" name="photoid" value='<%=fieldValue%>' style="width: 300px" accept="image/*"></wea:item>
				<wea:item>&nbsp;</wea:item>
								<wea:item>(<%=SystemEnv.getHtmlLabelName(21130,user.getLanguage())%>:400*450)</wea:item>
				<%}%>
				<%if(!fieldValue.equals("0")&&fieldValue.length()>0){%>
				<wea:item><%=SystemEnv.getHtmlLabelName(33470,user.getLanguage())%></wea:item>
	 				<wea:item><img class="ContactsAvatar" style="right: 0;z-index: 999" border=0 id=resourceimage src="/weaver/weaver.file.FileDownload?fileid=<%=fieldValue%>"></div></wea:item>
				<%} %>
			<% 
			}else if(HrmFieldManager.getHtmlType().equals("6")){
        	int maxsize = 100;
       %>
       	<wea:item><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
				<wea:item>
        <div id="uploadDiv" name="uploadDiv" maxsize="<%=maxsize%>" resourceId="<%=id%>" scopeId="<%=scopeId %>" fieldId="<%=HrmFieldManager.getFieldid()%>"></div>
        <div>
        	<input class=inputstyle type="hidden" id="customfield<%=HrmFieldManager.getFieldid()%>" name="customfield<%=HrmFieldManager.getFieldid()%>" value="" onchange='checkinput("customfield<%=HrmFieldManager.getFieldid()%>","customfield<%=HrmFieldManager.getFieldid()%>span");'>
        	<SPAN id="customfield<%=HrmFieldManager.getFieldid()%>span">
      		<%
							  if(HrmFieldManager.isMand()) {
							%>
							    <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
							<%
							  }
							%>
					</SPAN>
        </div>
        </wea:item>
	<%}else if(fieldName.equals("departmentid")){
		hrmFieldConf.put("rightStr","HrmResourceAdd:Add");
       %>
	<wea:item attributes='<%=attr %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item attributes='<%=attr %>'>
		<%=((HtmlElement)Class.forName(hrmFieldConf.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, hrmFieldConf, user) %>
	</wea:item>
	<%}else{ %>
	<wea:item attributes='<%=attr %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item attributes='<%=attr %>'>
		<%=((HtmlElement)Class.forName(hrmFieldConf.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, hrmFieldConf, user) %>
	</wea:item>
	<%
	}
	}
%>
</wea:group>
<%} %>
</wea:layout>
</FORM>
<script language="JavaScript">
function onShowDepartment(){//考虑分权浏览框
//2004-6-16 Edit by Evan :传sql参数给部门浏览页面
	url=encode("/hrm/company/DepartmentBrowser3.jsp?isedit=1&rightStr=HrmResourceAdd:Add&sqlwhere=<%=xssUtil.put(getDepartmentSql(user))%>&selectedids="+jQuery("input[name=departmentid]").val());
    url = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url="+url;
    return url;
    //data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
//2004-6-16 End Edit
	issame = false;
	if (data!=null){
		if (data.id != 0 ){
			if (data.id == jQuery("input[name=departmentid]").val()){
				issame = true;
			}
			jQuery("#departmentspan").html(data.name);
			jQuery("input[name=departmentid]").val(data.id);
		}else{
			jQuery("#departmentspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name=departmentid]").val("");
		}
		if (issame == false){
				jQuery("#jobtitlespan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				jQuery("input[name=jobtitle]").val("");
			//	costcenterspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			//	resource.costcenterid.value=""
		}
	}
}

function onShowCostCenter(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp?sqlwhere= where departmentid="+jQuery("input[name=departmentid]").val());
	if (data!=null){
		if (data.id != 0 ){
			jQuery("#costcenterspan").html(data.name);
			jQuery("input[name=costcenterid]").val(data.id);
		}else{
			jQuery("#costcenterspan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name=costcenterid]").val("");
		}
	}
}

function onShowJobtitle(){
	url=encode("/hrm/jobtitles/JobTitlesBrowser.jsp?fromPage=add");
	url="/systeminfo/BrowserMain.jsp?url="+url;
	return url;
}

function onBelongto(){
	return "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?from=add&sqlwhere=<%=xssUtil.put("where (accounttype=0 or accounttype=null or accounttype is null)")%>";
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?from=add&sqlwhere=(accounttype is null or accounttype=0)");
	if (data!=null){
		if (data.id != ""){
			jQuery("#belongtospan").html("<A href='/hrm/resource/HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>");
			jQuery("input[name=belongto]").val(data.id);
		}else{
			jQuery("#belongtospan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			jQuery("input[name=belongto]").val("");
		}
	}
}

var saveBtn ;
function encode(str){     
       return escape(str);
    }

function doSaveAndToList(obj) {
	document.resource.cmd.value="";
	doSave(obj);
}

function doSaveAndNew(obj) {
	document.resource.cmd.value="SaveAndNew";
	doSave(obj);
}

function doSaveAndNext(obj) {
	document.resource.cmd.value="SaveAndNext";
	doSave(obj);
}

var upfilesnum=0;//获得上传文件总数
function doSave(obj){
  if(!checkMail()) return false;
  saveBtn = obj;
  if(check_form(document.resource,'<%=needinputitems%>')) {
  	jQuery("div[name=uploadDiv]").each(function(){
  		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
    	if(oUploader.getStats().files_queued>0){
    		upfilesnum+=oUploader.getStats().files_queued;
    		oUploader.startUpload();
    	}
    });
  	if(upfilesnum==0) doSaveAfterAccUpload(obj);
 	}
}

function doSaveAfterAccUpload(obj) {
	var frmLastName = encodeURI(document.all("lastname").value);//url编码 utf-8；
	var frmworkcode = encodeURI(jQuery("#workcode").val());//url编码 utf-8；
  if(jQuery("input[name=managerid]").val()==""){
	  window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16072,user.getLanguage())%>",function(){
	 {
 		//校验电子邮件
  	if(!chkMail()) return false;
	  if(<%=flagaccount%>){
			if(document.resource.accounttype.value ==0){
			  if(document.resource.departmentid.value==""||
		     document.resource.costcenterid.value==""||
		     document.resource.jobtitle.value==""||
		     document.resource.locationid.value==""){
		     	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		  	}else{
		    	if(check_form(document.resource,'lastname,locationid')){
		      //document.resource.submit() ;
		      //alert("HrmResourceCheck.jsp?lastname="+document.all("lastname").value+"&workcode="+document.all("workcode").value);
		
		      jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName+"&workcode="+frmworkcode;
		    	}
  			}  
	  	}else{
			  if(document.resource.departmentid.value==""||
		     document.resource.costcenterid.value==""||
		     document.resource.jobtitle.value==""||
			   document.resource.belongto.value==""||
		     document.resource.locationid.value==""){
		     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
		  	}else{

		    	if(check_form(document.resource,'lastname,locationid')){
		      //document.resource.submit() ;
		      //alert("HrmResourceCheck.jsp?lastname="+document.all("lastname").value+"&workcode="+document.all("workcode").value);
		
		      jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName+"&workcode="+frmworkcode;
		    }
		  }  
	  }}else{
	  if(document.resource.departmentid.value==""||
     document.resource.costcenterid.value==""||
     document.resource.jobtitle.value==""||
     document.resource.locationid.value==""){
     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
  }else{
    if(check_form(document.resource,'lastname,locationid')){
      //document.resource.submit() ;
      //alert("HrmResourceCheck.jsp?lastname="+document.all("lastname").value+"&workcode="+document.all("workcode").value);

      jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName+"&workcode="+frmworkcode;
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
			if(document.resource.accounttype.value ==0){
			  if(document.resource.departmentid.value==""||
		     document.resource.costcenterid.value==""||
		     document.resource.jobtitle.value==""||
		     document.resource.locationid.value==""){
		     	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		  	}else{
		    	if(check_form(document.resource,'lastname,locationid')){
		      //document.resource.submit() ;
		      //alert("HrmResourceCheck.jsp?lastname="+document.all("lastname").value+"&workcode="+document.all("workcode").value);
		
		      jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName+"&workcode="+frmworkcode;
		    	}
  			}  
	  	}else{
			  if(document.resource.departmentid.value==""||
		     document.resource.costcenterid.value==""||
		     document.resource.jobtitle.value==""||
			   document.resource.belongto.value==""||
		     document.resource.locationid.value==""){
		     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
		  	}else{

		    	if(check_form(document.resource,'lastname,locationid')){
		      //document.resource.submit() ;
		      //alert("HrmResourceCheck.jsp?lastname="+document.all("lastname").value+"&workcode="+document.all("workcode").value);
		
		      jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName+"&workcode="+frmworkcode;
		    }
		  }  
	  }}else{
	  if(document.resource.departmentid.value==""||
     document.resource.costcenterid.value==""||
     document.resource.jobtitle.value==""||
     document.resource.locationid.value==""){
     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>")
  }else{
    if(check_form(document.resource,'lastname,locationid')){
      //document.resource.submit() ;
      //alert("HrmResourceCheck.jsp?lastname="+document.all("lastname").value+"&workcode="+document.all("workcode").value);

     jQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName+"&workcode="+frmworkcode;
    }
  }
	  }
  }
  

}

jQuery(document).ready(function(){
	$("#accounttype").change(function(){
  	onBelongToChange();
	});
	 <%for(int i=0;lsSamePair!=null&&i<lsSamePair.size();i++){%>
   hideGroup("<%=lsSamePair.get(i)%>");
   <%}%>
})

function chkMail(){
	if(!document.forms[0].enddate || document.resource.email.value == ''){
		return true;
	}

	var email = document.resource.email.value;
	var pattern =  /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i;
	chkFlag = pattern.test(email);
	if(chkFlag){
		return true;
	}
	else
	{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24570,user.getLanguage())%>");
		document.resource.email.focus();
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
</script>


<script language="vbs">
sub onShowBrowser11(id,id2,url,linkurl,type1,ismand)

	if type1= 2 or type1 = 19 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		document.all("span"+id2).innerHtml = id1
		document.all("dateField"+id).value=id1
	else
		if type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("dateField"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
		else
			tmpids = document.all("dateField"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
		end if
		if NOT isempty(id1) then
			if type1 = 17 or type1 = 18 or type1=27 or type1=37 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all("dateField"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					document.all("span"+id2).innerHtml = sHtml

				else
					if ismand=0 then
						document.all("span"+id2).innerHtml = empty
					else
						document.all("span"+id2).innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("dateField"+id).value=""
				end if

			else
			   if  id1(0)<>""   and id1(0)<> "0"  then
			        if linkurl = "" then
						document.all("span"+id2).innerHtml = id1(1)
					else
						document.all("span"+id2).innerHtml = "<a href="&linkurl&id1(0)&">"&id1(1)&"</a>"
					end if
					document.all("dateField"+id).value=id1(0)
				else
					if ismand=0 then
						document.all("span"+id2).innerHtml = empty
					else
						document.all("span"+id2).innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("dateField"+id).value=""
				end if
			end if
		end if
	end if
end sub
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src='/js/datetime_wev8.js?rnd="+Math.random()+"'></script>
<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()+"'></script>
</HTML>
