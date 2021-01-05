<%
//固定页面头部增加以下代码
weaver.system.CusFormSettingComInfo CusFormSettingComInfo = new weaver.system.CusFormSettingComInfo();
weaver.system.CusFormSetting CusFormSetting= CusFormSettingComInfo.getCusFormSetting("hrm","HrmResourceBase");
if(CusFormSetting!=null){
	if(CusFormSetting.getStatus()==1){
		//原页面
	}else if(CusFormSetting.getStatus()==2){
		//自定义布局页面
		request.getRequestDispatcher("/hrm/resource/HrmResourceBasicEditNew.jsp").forward(request, response);
		return;
	}else if(CusFormSetting.getStatus()==3){
		//自定义页面
		String page_url = CusFormSetting.getPage_url();
		request.getRequestDispatcher(page_url).forward(request, response);
		return;
	}
}
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.login.Account"%>
<%@ page import="weaver.login.VerifyLogin,
								 weaver.docs.docs.CustomFieldManager"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
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
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/hrm/resource/uploader.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
<%
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
 if(!isHr){
	 response.sendRedirect("/notice/noright.jsp") ;
		return ;
 }
 String hasLoginid = "".equals(Util.null2String(ResourceComInfo.getLoginID(id),""))?"false":"true";
 int scopeId = -1;
%>
<head>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  <link href="/hrm/css/Contacts_wev8.css" rel="stylesheet" type="text/css" />
	<link href="/hrm/css/Public_wev8.css" rel="stylesheet" type="text/css" />
  <SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
  <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
  <SCRIPT language="javascript" src="/js/checknumber_wev8.js"></script>
	<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
	<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
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
	}
	else {
		showEle("belongtodata");
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
<input class=inputstyle type=hidden name=id value="<%=id%>">
<input class=inputstyle type=hidden name=isView value="<%=isView%>">
<input class=inputstyle type=hidden name=isfromtab value="<%=isfromtab%>"> 
<input class=inputstyle type=hidden name=scopeid value="<%=scopeId%>">
<input class=inputstyle type=hidden id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>">
  <%
  String sql = "";
  sql = "select * from HrmResource where id = "+Util.getIntValue(id,-1);
  String lastname = "";
  String workcode = "";
  rs.executeSql(sql);
  if(rs.next()){
    workcode = Util.null2String(rs.getString("workcode"));
    lastname = Util.null2String(rs.getString("lastname"));
    lastname = lastname.endsWith("\\")&&!lastname.endsWith("\\\\") == true ? lastname+ "\\" :lastname;
    String sex = Util.null2String(rs.getString("sex"));
    String photoid = Util.null2String(rs.getString("resourceimageid"));

		String departmentid = Util.null2String(rs.getString("departmentid"));
    String costcenterid = Util.null2String(rs.getString("costcenterid"));
    String jobtitle = Util.null2String(rs.getString("jobtitle"));
    String joblevel = Util.null2String(rs.getString("joblevel"));

    String jobactivitydesc = Util.null2String(rs.getString("jobactivitydesc"));
    String managerid = Util.null2String(rs.getString("managerid"));
    String assistantid = Util.null2String(rs.getString("assistantid"));
    String status = Util.null2String(rs.getString("status"));

    String locationid = Util.null2String(rs.getString("locationid"));
    String workroom = Util.null2String(rs.getString("workroom"));
    String telephone = Util.null2String(rs.getString("telephone"));
    String mobile = Util.null2String(rs.getString("mobile"));
    String mobileshowtype = Util.null2String(rs.getString("mobileshowtype"));
    
    String mobilecall = Util.null2String(rs.getString("mobilecall"));
    String fax = Util.null2String(rs.getString("fax"));
    String email = Util.null2String(rs.getString("email"));
    String jobcall = Util.null2String(rs.getString("jobcall"));
    
    String accounttype = Util.null2String(rs.getString("accounttype"));
    if(accounttype.equals(""))  accounttype="0";
    int systemlanguage = Util.getIntValue(rs.getString("systemlanguage"),7);
    List accounts=new VerifyLogin().getAccountsById(Integer.parseInt(id));
		if(accounts==null) accounts=new ArrayList();
    String majorId="";
    if(accounttype.equals("1")){
    Iterator iter=accounts.iterator();
    while(iter.hasNext()){
    Account major=(Account)iter.next();
    if(major.getType()==0){
    majorId=""+major.getId();
    break;
}
}
}
%>
<%
if(ifinfo.equals("y")){
%>
 <DIV>
<font color=red size=2>
<%=SystemEnv.getHtmlLabelName(22160,user.getLanguage())%>
</div>
<%}%>
				<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">     
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
						<wea:item><input class=inputstyle type=text id=workcode name=workcode value='<%=workcode%>' onchange="this.value=trim(this.value)" style="width: 300px;"></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
						<wea:item>
						  <INPUT class=InputStyle maxLength=30 size=30 id="lastname" name="lastname" value="<%=lastname%>" onchange='checkinput("lastname","lastnamespan");this.value=trim(this.value)' style="width: 300px;">
							<SPAN id=lastnamespan>
							<%
							  if(lastname.equals("")) {
							%>
							    <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
							<%
							  }
							%>
						  </SPAN>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></wea:item>
						<wea:item>
							<select class=inputstyle name=sex value="<%=sex%>" style="width: 80px;">
							 <option value="0" <%if(sex.equals("0")){%>selected<%}%> > <%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
							 <option value="1" <%if(sex.equals("1")){%>selected<%}%> > <%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
							</select>
						</wea:item>
						<%if(flagaccount){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(17745,user.getLanguage())%></wea:item>
						<wea:item>
							<select class=inputstyle id=accounttype  name=accounttype onchange="onBelongToChange()" style="width: 80px;">
						 		<option <%if(accounttype.equals("0")){%>selected<%}%> value="0"><%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%></option>
								<option <%if(accounttype.equals("1")){%>selected<%}%> value="1"><%=SystemEnv.getHtmlLabelName(17747,user.getLanguage())%></option>
							</select>
						</wea:item>
						<%}%>
						<wea:item attributes="{\"samePair\":\"belongtodata\",'display':'none'}"><%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%></wea:item>
						<wea:item attributes="{\"samePair\":\"belongtodata\",'display':'none'}">
						<%
						String completeUrl = "/data.jsp?type=1&whereClause="+xssUtil.put("(accounttype=0 or accounttype=null or accounttype is null)");
						String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?sqlwhere="+xssUtil.put("(accounttype=0 or accounttype=null or accounttype is null)");
						%>
							<brow:browser viewType="0" name="belongto" browserValue='<%=majorId %>' 
							browserUrl='<%=browserUrl %>'
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl='<%=completeUrl %>' linkUrl="javascript:openhrm($id$)" width="300px"
							browserSpanValue='<%=ResourceComInfo.getResourcename(majorId) %>'></brow:browser>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0"  name="departmentid" browserValue='<%=departmentid %>'
							 getBrowserUrlFn="onShowDepartment"  
						   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
   						   completeUrl="/data.jsp?type=4&rightStr=HrmResourceEdit:Edit" width="165px"
						   _callback="onDepartmentAdd" afterDelCallback="onDepartmentDel"
						   browserSpanValue='<%=DepartmentComInfo.getDepartmentname(departmentid)%>'>
						 </brow:browser>
						 <!-- 
						  <BUTTON type="button" class=Browser id=SelectDepartment onclick="onShowDepartment()"></BUTTON>
						  <SPAN id=departmentspan><%=DepartmentComInfo.getDepartmentname(departmentid)%><%if(departmentid.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN>
						  <input class=inputstyle type=hidden name=departmentid value="<%=departmentid%>">
						  -->
							<input class=inputstyle type=hidden name=costcenterid value="<%=costcenterid%>">
						</wea:item>
						<wea:item attributes="{\"samePair\":\"itemjobtitle\",'display':'none'}"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
						<wea:item attributes="{\"samePair\":\"itemjobtitle\",'display':'none'}">
							<brow:browser viewType="0" name="jobtitle" browserValue='<%=jobtitle%>' 
						   getBrowserUrlFn="onShowJobtitle"
						   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
						   completeUrl="javascript:getCompleteUrl()" width="165px" browserSpanValue='<%=JobtitlesComInfo.getJobTitlesname(jobtitle)%>'>
						 	</brow:browser>
						 	<!-- 
						 	&whereClause=jobdepartmentid=
						 	<BUTTON class=Browser id=SelectJobTitle onclick="onShowJobtitle()" type="button"></BUTTON>
						  <SPAN id=jobtitlespan><%=JobtitlesComInfo.getJobTitlesname(jobtitle)%><%if(jobtitle.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN>
							<input class=inputstyle type=hidden name=jobtitle value="<%=jobtitle%>">
						 	 -->
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="jobcall" browserValue='<%=jobcall%>' 
							browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobcall/JobCallBrowser.jsp?selectedids="
							hasInput="true" isSingle="true" hasBrowser="true" isMustInput='1'
							completeUrl="/data.jsp?type=jobcall" width="300px"
							browserSpanValue='<%=JobCallComInfo.getJobCallname(jobcall)%>'>
							</brow:browser>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></wea:item>
						<wea:item>
							<input class=InputStyle maxlength=3 size=5 name=joblevel value="<%=joblevel%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevel")' style="width: 80px">
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(15708,user.getLanguage())%></wea:item>
						<wea:item>
							<input class=inputstyle type=text name=jobactivitydesc value="<%=jobactivitydesc%>" style="width: 300px">
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
						<wea:item>
						  <%if(status.equals("0")){%><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%><%}%>
							<%if(status.equals("1")){%><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%><%}%>
							<%if(status.equals("2")){%><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%><%}%>
							<%if(status.equals("3")){%><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%><%}%>
							<%if(status.equals("4")){%><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%><%}%>
							<%if(status.equals("5")){%><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%><%}%>
							<%if(status.equals("6")){%><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%><%}%>
							<%if(status.equals("7")){%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%><%}%>
							<%if(status.equals("10")){%><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%><%}%>
							<input class=inputstyle type=hidden name=status value="<%=status%>">
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
		       		<BUTTON class=delbtn accessKey=D onClick="delpic()" type="button" title="<%=SystemEnv.getHtmlLabelName(16075,user.getLanguage())%>"></BUTTON>
		       		<span style="vertical-align: middle;"><%=SystemEnv.getHtmlLabelName(16075,user.getLanguage())%></span>
		       		<input class=inputstyle type=hidden name=oldresourceimage value="<%=photoid%>">
		       	</wea:item>
						<%}else{%>
						<wea:item><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></wea:item>
						<wea:item><input class=inputstyle type=file name=photoid onchange="check_photo(event)" value='<%=photoid%>' style="width: 300px" accept="image/*"></wea:item>
						<wea:item>&nbsp;</wea:item>
						<wea:item>(<%=SystemEnv.getHtmlLabelName(21130,user.getLanguage())%>:400*600)</wea:item>
						<%}%>
						<%if(!photoid.equals("0")&&photoid.length()>0){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(33470,user.getLanguage())%></wea:item>
    				<wea:item><img class="ContactsAvatar" style="right: 0;z-index: 999" border=0 id=resourceimage src="/weaver/weaver.file.FileDownload?fileid=<%=photoid%>"></div></wea:item>
						<%} %>
					</wea:group>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(32938,user.getLanguage())%>' >
					<%
						RemindSettings hrmsettings=(RemindSettings)application.getAttribute("hrmsettings");
					  String mobileShowSet = Util.null2String(hrmsettings.getMobileShowSet());
					  String mobileShowType = Util.null2String(hrmsettings.getMobileShowType());
					%>
					<wea:item><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></wea:item>
					<wea:item>
					  <input class=inputstyle type=text name=mobile value="<%=mobile%>" style="width: 200px">&nbsp;
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
					<wea:item><%=SystemEnv.getHtmlLabelName(661,user.getLanguage())%></wea:item>
					<wea:item>
					  <input class=inputstyle type=text name=telephone value="<%=telephone%>" style="width: 300px">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></wea:item>
					<wea:item><input class=inputstyle type=text name=mobilecall value='<%=mobilecall%>' style="width: 300px"></wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></wea:item>
					<wea:item><input class=inputstyle type=text name=fax value='<%=fax%>' style="width: 300px"></wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></wea:item>
					<wea:item><input class=inputstyle type=text id=email name=email value='<%=email%>' style="width: 300px"></wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0"  name="locationid" browserValue='<%=locationid %>' 
						browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/location/LocationBrowser.jsp?selectedids="
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' width="300px"
						completeUrl="/data.jsp?type=location" linkUrl="/hrm/location/HrmLocationEdit.jsp?id=" 
						browserSpanValue='<%=LocationComInfo.getLocationname(locationid)%>'></brow:browser>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></wea:item>
					<wea:item>
					  <input class=inputstyle type=text name=workroom value="<%=workroom%>" style="width: 300px">
					</wea:item>
					</wea:group>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(32946,user.getLanguage())%>' >
					<wea:item><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></wea:item>
					<wea:item>       
						<%
						 sql = "select lastname from HrmResource where id = "+Util.getIntValue(managerid,-1);
						rs2.executeSql(sql);
						if(rs2.next()){}
					 %>
						<brow:browser viewType="0" name="managerid" browserValue='<%=managerid %>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="300px"
						browserSpanValue='<%=rs2.getString("lastname")%>'></brow:browser>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></wea:item>
					<wea:item>
					<%
					 	sql = "select lastname from HrmResource where id = "+Util.getIntValue(assistantid,-1);
						String assistantName="";
						rs3.executeSql(sql);
						if(rs3.next()){
					  assistantName=rs3.getString("lastname");}%>            
						<brow:browser viewType="0"  name="assistantid" browserValue='<%=assistantid %>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="300px"
						browserSpanValue='<%=assistantName%>'>
						</brow:browser>
					</wea:item>
				</wea:group>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(16169,user.getLanguage()) %>' >
				<%
String datefield[] = new String[5] ;
String numberfield[] = new String[5] ;
String textfield[] = new String[5] ;
String tinyintfield[] = new String[5] ;
for(int k=1 ; k<6;k++) datefield[k-1] = rs.getString("datefield"+k) ;
for(int k=1 ; k<6;k++) numberfield[k-1] = rs.getString("numberfield"+k) ;
for(int k=1 ; k<6;k++) textfield[k-1] = rs.getString("textfield"+k) ;
for(int k=1 ; k<6;k++) tinyintfield[k-1] = rs.getString("tinyintfield"+k) ;

boolean hasFF = true;
rs2.executeProc("Base_FreeField_Select","hr");
if(rs2.getCounts()<=0)
	hasFF = false;
else
	rs2.first();

if(hasFF){
	for(int i=1;i<=5;i++)
	{
		if(rs2.getString(i*2+1).equals("1"))
		{%>
                <wea:item><%=rs2.getString(i*2)%></wea:item>
                <wea:item>
                    <button class=Calendar type="button" id=selectbepartydate onClick="getRSDate(span<%=i%>,datefield<%=(i-1)%>)"></button>
                    <span id=span<%=i%> ><%=datefield[i-1]%></span>
                    <input class=inputstyle type="hidden" name="datefield<%=(i-1)%>" value="<%=datefield[i-1]%>">
                </wea:item>
              <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(rs2.getString(i*2+11).equals("1"))
		{%>
                <wea:item><%=rs2.getString(i*2+10)%></wea:item>
                <wea:item>
                    <input class=InputStyle  name="numberfield<%=(i-1)%>" value="<%=numberfield[i-1]%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("numberfield<%=(i-1)%>")' style="width: 300px">
                </wea:item>
              <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(rs2.getString(i*2+21).equals("1"))
		{%>
                <wea:item><%=rs2.getString(i*2+20)%></wea:item>
                <wea:item>
                    <input class=InputStyle  name="textfield<%=(i-1)%>" value="<%=textfield[i-1]%>" style="width: 300px">
                </wea:item>
              <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(rs2.getString(i*2+31).equals("1"))
		{%>
                <wea:item><%=rs2.getString(i*2+30)%></wea:item>
                <wea:item>
                  <INPUT class=inputstyle type=checkbox  name="tinyintfield<%=(i-1)%>" value="1" <%if(tinyintfield[i-1].equals("1")){%> checked <%}%> >
                </wea:item>
              <%}
	}
}
%>

<%--begin 自定义字段--%>
<%
    CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
    cfm.getCustomFields();
    cfm.getCustomData(Util.getIntValue(id,0));
    while(cfm.next()){
    	if(!cfm.isUse())continue;
        if(cfm.isMand()){
            needinputitems += ",customfield"+cfm.getId();
        }
        String fieldvalue = cfm.getData("field"+cfm.getId());
%>
      <wea:item> <%=SystemEnv.getHtmlLabelNames(cfm.getLable(),user.getLanguage())%> </wea:item>
      <wea:item>
      <%
        if(cfm.getHtmlType().equals("1")){
            if(cfm.getType()==1){
                if(cfm.isMand()){
      %>
        <input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=50 onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')" style="width: 300px">
        <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
      <%
                }else{
      %>
        <input datatype="text" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" value="" style="width: 300px">
      <%
                }
            }else if(cfm.getType()==2){
                if(cfm.isMand()){
      %>
        <input  datatype="int" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10
            onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')" style="width: 300px">
        <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
      <%
                }else{
      %>
      <input  datatype="int" type=text  value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' style="width: 300px">
      <%
                }
            }else if(cfm.getType()==3){
                if(cfm.isMand()){
      %>
        <input datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10
		    onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')" style="width: 300px">
        <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
      <%
                }else{
      %>
        <input datatype="float" type=text value="<%=fieldvalue%>" class=Inputstyle name="customfield<%=cfm.getId()%>" size=10 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)' style="width: 300px">
      <%
                }
            }
        }else if(cfm.getHtmlType().equals("2")){
            if(cfm.isMand()){

      %>
        <textarea class=Inputstyle name="customfield<%=cfm.getId()%>" onChange="checkinput('customfield<%=cfm.getId()%>','customfield<%=cfm.getId()%>span')"
		    rows="4" cols="40" style="width: 300px" class=Inputstyle><%=fieldvalue%></textarea>
        <span id="customfield<%=cfm.getId()%>span"><%if(fieldvalue.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
      <%
            }else{
      %>
        <textarea class=Inputstyle name="customfield<%=cfm.getId()%>" rows="4" cols="40" style="width: 300px"><%=fieldvalue%></textarea>
      <%
            }
        }else if(cfm.getHtmlType().equals("3")){

            String fieldtype = String.valueOf(cfm.getType());
		    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值
		    if("161".equals(fieldtype) || "162".equals(fieldtype)) {
		    	url = url + "?type=" + cfm.getDmrUrl();
		    	if(!"".equals(fieldvalue)) {
			    	Browser browser=(Browser) StaticObj.getServiceByFullname(cfm.getDmrUrl(), Browser.class);
					try{
						String[] fieldvalues = fieldvalue.split(",");
						for(int i = 0;i < fieldvalues.length;i++) {
	                        BrowserBean bb=browser.searchById(fieldvalues[i]);
	                        String desc=Util.null2String(bb.getDescription());
	                        String name=Util.null2String(bb.getName());
	                        if(!"".equals(showname)) {
		                        showname += ",";
	                        }
	                        showname += name;
						}
					}catch (Exception e){}
		    	}
		    }
            String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
            String newdocid = Util.null2String(request.getParameter("docid"));

            if( fieldtype.equals("37") && !newdocid.equals("")) {
                if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                fieldvalue += newdocid ;
            }

            if(fieldtype.equals("2") ||fieldtype.equals("19")){
                showname=fieldvalue; // 日期时间
            }else if(!fieldvalue.equals("")&& !("161".equals(fieldtype) || "162".equals(fieldtype))) {
                String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                sql = "";

                HashMap temRes = new HashMap();

                if(fieldtype.equals("152") || fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("168")||fieldtype.equals("194")) {    // 多人力资源,多客户,多会议，多文档
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                }
                else {
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                }

                RecordSet.executeSql(sql);
                while(RecordSet.next()){
                    showid = Util.null2String(RecordSet.getString(1)) ;
                    String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                    if(!linkurl.equals(""))
                        //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                        temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                    else{
                        //showname += tempshowname ;
                        temRes.put(String.valueOf(showid),tempshowname);
                    }
                }
                StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                String temstkvalue = "";
                while(temstk.hasMoreTokens()){
                    temstkvalue = temstk.nextToken();

                    if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                        showname += temRes.get(temstkvalue);
                    }
                }

            }

	   %>
        <button class=Browser  type="button" onclick="onShowBrowser('<%=cfm.getId()%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=cfm.isMand()?"1":"0"%>')" title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
        <input type=hidden name="customfield<%=cfm.getId()%>" value="<%=fieldvalue%>">
        <span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%>
            <%if(cfm.isMand() && fieldvalue.equals("")) {%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%>
        </span>
       <%
        }else if(cfm.getHtmlType().equals("4")){
       %>
        <input type=checkbox value=1 name="customfield<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> >
       <%
        }else if(cfm.getHtmlType().equals("5")){
            cfm.getSelectItem(cfm.getId());
       %>
       <select class=InputStyle style="width: 300px" name="customfield<%=cfm.getId()%>" class=InputStyle>
       <%
            while(cfm.nextSelect()){
       %>
            <option value="<%=cfm.getSelectValue()%>" <%=cfm.getSelectValue().equals(fieldvalue)?"selected":""%>><%=cfm.getSelectName()%>
       <%
            }
       %>
       </select>
       <%
        }else if(cfm.getHtmlType().equals("6")){
        	String[] resourceFile = HrmResourceFile.getResourceFile(id, scopeId, cfm.getId());
        	int maxsize = 100;
       %>
        <div id="uploadDiv" name="uploadDiv" maxsize="<%=maxsize%>" resourceId="<%=id%>" scopeId="<%=scopeId %>" fieldId="<%=cfm.getId()%>"></div>
        <div>
          <%=resourceFile[1] %>
        	<input class=inputstyle type="hidden" id="customfield<%=cfm.getId()%>" name="customfield<%=cfm.getId()%>" value="<%=resourceFile[0].equals("")?"":"1" %>" onchange='checkinput("customfield<%=cfm.getId()%>","customfield<%=cfm.getId()%>span");'>
        	<SPAN id="customfield<%=cfm.getId()%>span">
      		<%
							  if(cfm.isMand()&&resourceFile[0].equals("")) {
							%>
							    <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
							<%
							  }
							%>
					</SPAN>
        </div>
       <%} %>
         </wea:item>
       <%
    }
       %>
		<%--end 自定义字段--%>
				</wea:group>
				</wea:layout>
<%} %>


  </FORM>
<script type="text/javascript">
function getCompleteUrl(){
	var url= "/data.jsp?type=hrmjobtitles";
			url+="&whereClause= jobdepartmentid="+jQuery("input[name=departmentid]").val();
	return url;		
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

function onDepartmentDel(text,fieldid,params){
	_writeBackData('jobtitle','2',{'id':'','name':''});
	hideEle("itemjobtitle");
}

function onDepartmentAdd(e,datas,name){
		_writeBackData('jobtitle','2',{'id':'','name':''});
	if(datas.id==""){
		hideEle("itemjobtitle");
	}
	else {
		showEle("itemjobtitle");
	} 
}


function onShowDepartment(){
    url=encode("/hrm/company/DepartmentBrowser2.jsp?isedit=1&rightStr=HrmResourceEdit:Edit&selectedids="+resourcebasicinfo.departmentid.value);
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
  
  function dosave(obj){
  	if(!checkMail()) return false;
    saveBtn = obj;
    if(check_form(document.resourcebasicinfo,'<%=needinputitems%>')) {
		try{
		var oldDeptId = "<%=departmentidtmp%>";
		var newDeptId = $GetEle("departmentid").value;
		if(newDeptId != oldDeptId){
			if("true" == "<%=hasLoginid%>"){
				var result = common.ajax("cmd=checkNewDeptUsers&arg="+newDeptId);
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
        			jjQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName+"&workcode="+frmworkcode;
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
        			jjQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName+"&workcode="+frmworkcode;
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
       			jjQuery("#checkHas")[0].src="HrmResourceCheck.jsp?lastname="+frmLastName+"&workcode="+frmworkcode;
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
	  document.resourcebasicinfo.operation.value = "delpic";
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
		if (type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170&& type1!=168&&type1!=161&&type1!=162){
			tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?resourceids="+tmpids);
		}else if (type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
            tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?selectedids="+tmpids)
		}else if (type1==37){
            tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"?documentids="+tmpids)
		}else if (type1==161||type1==162){
      tmpids = jQuery("input[name=customfield"+id+"]").val();
			id1 = window.showModalDialog(url+"&selectedids="+tmpids)
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
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
