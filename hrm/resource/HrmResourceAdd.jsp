<%
//固定页面头部增加以下代码
weaver.system.CusFormSettingComInfo CusFormSettingComInfo = new weaver.system.CusFormSettingComInfo();
weaver.system.CusFormSetting CusFormSetting= CusFormSettingComInfo.getCusFormSetting("hrm","HrmResourceBase");
if(CusFormSetting!=null){
	if(CusFormSetting.getStatus()==1){
		//原页面
	}else if(CusFormSetting.getStatus()==2){
		//自定义布局页面
		request.getRequestDispatcher("/hrm/resource/HrmResourceAddNew.jsp").forward(request, response);
		return;
	}else if(CusFormSetting.getStatus()==3){
		//自定义页面
		String page_url = CusFormSetting.getPage_url();
		request.getRequestDispatcher(page_url).forward(request, response);
		return;
	}
}

%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.docs.docs.CustomFieldManager" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="HrmResourceFile" class="weaver.hrm.tools.HrmResourceFile" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
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

function onBelongToChange(obj){
	if(obj.value=="0"){
		hideEle("belongtodata");
	}
	else {
		showEle("belongtodata");
	} 
}

jQuery(document).ready(function(){
  //绑定附件上传
  if(jQuery("div[name=uploadDiv]").length>0)
  	jQuery("div[name=uploadDiv]").each(function(){
      bindUploaderDiv($(this),"relatedacc"); 
    });

  //绑定照片上传
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
%>
<input class=inputstyle type=hidden name=id value="<%=id%>">
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
<wea:item><INPUT class=InputStyle maxLength=30 size=30 style="width: 165px" name="workcode" onchange="this.value=trim(this.value)"></wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
<wea:item>
	<wea:required id="lastnamespan" required="true">
  <INPUT class=InputStyle maxLength=30 size=30 style="width: 165px" name="lastname" onchange='checkinput("lastname","lastnamespan");this.value=trim(this.value)'>
	</wea:required>
</wea:item>
<%if(flagaccount){%>
<wea:item><%=SystemEnv.getHtmlLabelName(17745,user.getLanguage())%></wea:item>
<wea:item>
  <select class=InputStyle id=accounttype name=accounttype onchange="onBelongToChange(this)">
    <option value="0"><%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%></option>
    <option value="1"><%=SystemEnv.getHtmlLabelName(17747,user.getLanguage())%></option>
  </select>
</wea:item>
<wea:item attributes="{\"samePair\":\"belongtodata\",'display':'none'}"><%=SystemEnv.getHtmlLabelName(17746,user.getLanguage())%></wea:item>
<wea:item attributes="{\"samePair\":\"belongtodata\",'display':'none'}">
<%
String completeUrl = "/data.jsp?type=1&whereClause="+xssUtil.put("(accounttype=0 or accounttype=null or accounttype is null)");
%>
<brow:browser viewType="0"  name="belongto" browserValue="" 
							getBrowserUrlFn="onBelongto"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							completeUrl='<%=completeUrl %>' linkUrl="javascript:openhrm($id$)" width="165px"
							browserSpanValue=""></brow:browser>
</wea:item>
<%}%>
<wea:item><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></wea:item>
<wea:item>
  <select class=InputStyle id=sex name=sex>
    <option value=0 selected><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
    <option value=1><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
  </select>
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
<wea:item>
	<brow:browser viewType="0"  name="departmentid" browserValue='<%=departmentid %>'
	 getBrowserUrlFn="onShowDepartment"  
   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
   completeUrl="/data.jsp?type=4&rightStr=HrmResourceAdd:Add" width="165px"
   _callback="onDepartmentAdd" afterDelCallback="onDepartmentDel"
   browserSpanValue='<%=DepartmentComInfo.getDepartmentname(departmentid)%>'>
 </brow:browser>
 <!-- 
   <BUTTON class=Browser type="button" id=SelectDepartment onclick="onShowDepartment()"></BUTTON>
  <SPAN id=departmentspan>
    <%=DepartmentComInfo.getDepartmentname(departmentid)%>
  </SPAN>
  <INPUT class=inputstyle id=departmentid type=hidden name=departmentid value=<%=departmentid%>>
  -->
  <INPUT class=inputstyle id=costcenterid type=hidden name=costcenterid value='1'>
</wea:item>
<wea:item attributes="{\"samePair\":\"itemjobtitle\",'display':'none'}"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
<wea:item attributes="{\"samePair\":\"itemjobtitle\",'display':'none'}">
	<brow:browser viewType="0"  name="jobtitle" browserValue="" 
   getBrowserUrlFn="onShowJobtitle"
   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
   completeUrl="javascript:getCompleteUrl()" width="165px" browserSpanValue="">
 	</brow:browser>
  <!-- 
  <BUTTON class=Browser type="button" id=SelectJobTitle onclick="onShowJobtitle()"></BUTTON>
  <SPAN id=jobtitlespan>
   <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
  </SPAN>
  <INPUT class=inputstyle id=jobtitle type=hidden name=jobtitle>
   -->
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></wea:item>
<wea:item>
	<brow:browser viewType="0"  name="jobcall" browserValue="" 
   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
   browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobcall/JobCallBrowser.jsp?selectedids="
   completeUrl="/data.jsp?type=jobcall" width="165px" browserSpanValue="">
 	</brow:browser>
 	<!-- 
 	<INPUT id=jobcall type=hidden name=jobcall class=wuiBrowser 
  _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobcall/JobCallBrowser.jsp">
  <SPAN id=jobcallspan>
 	-->
  </SPAN>
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></wea:item>
<wea:item>
  <input class=InputStyle maxlength=3 size=5  style="width: 165px" name=joblevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevel")'>
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(15708,user.getLanguage())%></wea:item>
<wea:item>
 <INPUT class=InputStyle maxLength=90 size=30  style="width: 165px" name=jobactivitydesc>
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
<wea:item>
	<select class=inputstyle name=status value="0">
	  <option value="0"><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
	  <option value="1"><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
	  <option value="2"><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
	</select>
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></wea:item>
<wea:item>
  <input class=inputstyle type="file" onchange="check_photo(event)" name="photoid" accept="image/*">
</wea:item>
</wea:group>
<wea:group context='<%=SystemEnv.getHtmlLabelName(32938,user.getLanguage())%>' attributes="{'groupOperDisplay':none}">
	<wea:item><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></wea:item>
	<wea:item>
	<%
		RemindSettings hrmsettings=(RemindSettings)application.getAttribute("hrmsettings");
	  String mobileShowSet = Util.null2String(hrmsettings.getMobileShowSet());
	  String mobileShowType = Util.null2String(hrmsettings.getMobileShowType());
	  String mobileShowTypeDefault = Util.null2String(hrmsettings.getMobileShowTypeDefault());
	%>
	 <input class=inputstyle type=text name=mobile value="" style="width: 165px">
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
	<wea:item><%=SystemEnv.getHtmlLabelName(661,user.getLanguage())%></wea:item>
	<wea:item>
	  <INPUT class=InputStyle maxLength=25  style="width: 165px" size=30 name=telephone>
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></wea:item>
	<wea:item>
	  <INPUT class=InputStyle maxLength=15 size=30  style="width: 165px" name=mobilecall>
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></wea:item>
	<wea:item>
	  <INPUT class=InputStyle maxLength=15 size=30  style="width: 165px" name=fax>
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></wea:item>
	<wea:item><input class=inputstyle type=text id=email name=email value="" style="width: 165px"></wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></wea:item>
	<wea:item>
	<brow:browser viewType="0" name="locationid" browserValue="" 
	  browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/location/LocationBrowser.jsp?selectedids="
	  hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
	  completeUrl="/data.jsp?type=location" width="165px"
	  browserSpanValue="">
	</brow:browser>
	<!-- 
	  <INPUT class=wuiBrowser id=locationid type=hidden name=locationid _required=yes
	  _url="/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp">
	 -->
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></wea:item>
	<wea:item>
	  <input class=InputStyle maxlength=30  style="width: 165px" size=30 name=workroom>
	</wea:item>
</wea:group>
<wea:group context='<%=SystemEnv.getHtmlLabelName(32946,user.getLanguage())%>' attributes="{'groupOperDisplay':none}">
	<wea:item><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></wea:item>
	<wea:item>
	<brow:browser viewType="0"  name="managerid" browserValue="" 
	  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
	  hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
	  completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="165px"
	  browserSpanValue="">
	</brow:browser>
	<!--
		<INPUT class=wuiBrowser id=managerid type=hidden name=managerid _required=yes
		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
		_displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'target='_blank'>#b{name}</A>">
		-->
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></wea:item>
	<wea:item>
	<brow:browser viewType="0" name="assistantid" browserValue="" 
	  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
	  hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	  completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="165px"
	  browserSpanValue="">
	</brow:browser>
	<!-- 
	  <INPUT class=wuiBrowser id=assistantid type=hidden name=assistantid
	  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
	  _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'target='_blank'>#b{name}</A>">
	<SPAN id=assistantidspan></SPAN>
	 -->
	</wea:item>
</wea:group>
<wea:group context='<%=SystemEnv.getHtmlLabelName(16169,user.getLanguage()) %>' attributes="{'groupOperDisplay':none}">
<%
boolean hasFF = true;
rs.executeProc("Base_FreeField_Select","hr");
if(rs.getCounts()<=0)
    hasFF = false;
else
    rs.first();
if(hasFF){
    for(int i=1;i<=5;i++)
    {
        if(rs.getString(i*2+1).equals("1"))
        {%>
         <wea:item><%=rs.getString(i*2)%></wea:item>
         <wea:item><input class=wuiDate type="hidden" name="datefield<%=(i-1)%>" value=""></wea:item>
       <%}
    }
    for(int i=1;i<=5;i++)
    {
        if(rs.getString(i*2+11).equals("1"))
        {%>
         <wea:item><%=rs.getString(i*2+10)%></wea:item>
         <wea:item>
             <input class=InputStyle  name="numberfield<%=(i-1)%>" value="" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("numberfield<%=(i-1)%>")'>
         </wea:item>
       <%}
    }
    for(int i=1;i<=5;i++)
    {
        if(rs.getString(i*2+21).equals("1"))
        {%> 
        <wea:item><%=rs.getString(i*2+20)%></wea:item>
        <wea:item><input class=InputStyle  name="textfield<%=(i-1)%>" value=""></wea:item>
       <%}
    }
    for(int i=1;i<=5;i++)
    {
        if(rs.getString(i*2+31).equals("1"))
        {%>
         <wea:item><%=rs.getString(i*2+30)%></wea:item>
         <wea:item><INPUT class=inputstyle type=checkbox  name="tinyintfield<%=(i-1)%>" value="1"></wea:item>
        <%}
    }
}
%>

<%--begin 自定义字段--%>
<%
    CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
    cfm.getCustomFields();
    cfm.getCustomData(Util.getIntValue(""+id,0));
    while(cfm.next()){
    	if(!cfm.isUse())continue;
        if(cfm.isMand()){
            needinputitems += ",customfield"+cfm.getId();
        }
        String fieldvalue = cfm.getData("field"+cfm.getId());
%>
      <wea:item><%=SystemEnv.getHtmlLabelName(Util.getIntValue(cfm.getLable()),user.getLanguage()) %></wea:item>
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
        	int maxsize = 100;
       %>
        <div id="uploadDiv" name="uploadDiv" maxsize="<%=maxsize%>" resourceId="<%=id%>" scopeId="<%=scopeId %>" fieldId="<%=cfm.getId()%>"></div>
        <div>
          <input class=inputstyle type="hidden" id="customfield<%=cfm.getId()%>" name="customfield<%=cfm.getId()%>" value="" onchange='checkinput("customfield<%=cfm.getId()%>","customfield<%=cfm.getId()%>span");'>
        	<SPAN id="customfield<%=cfm.getId()%>span">
      		<%
							  if(cfm.isMand()) {
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
</FORM>
<script language=vbs>
sub onShowManagerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	manageridspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.managerid.value=id(0)
	else
	manageridspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.managerid.value=""
	end if
	end if
end sub

sub onShowAssistantID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	assistantidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.assistantid.value=id(0)
	else
	assistantidspan.innerHtml = ""
	resource.assistantid.value=""
	end if
	end if
end sub

sub onShowLocationID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	locationidspan.innerHtml = id(1)
	resource.locationid.value=id(0)
	else
	locationidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.locationid.value=""
	end if
	end if
end sub

sub onShowJobcall()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobcall/JobCallBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobcallspan.innerHtml = id(1)
	resource.jobcall.value=id(0)
	else
	jobcallspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.jobcall.value=""
	end if
	end if
end sub

sub onShowJobType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtype/JobtypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtypespan.innerHtml = id(1)
	resource.jobtype.value=id(0)
	else
	jobtypespan.innerHtml = ""
	resource.jobtype.value=""
	end if
	end if
end sub

</script>
<SCRIPT LANGUAGE="JavaScript">
<!--
	
//-->
</SCRIPT>
<script language="JavaScript">
function onShowDepartment(){
//2004-6-16 Edit by Evan :传sql参数给部门浏览页面
    url=encode("/hrm/company/DepartmentBrowser2.jsp?isedit=1&rightStr=HrmResourceAdd:Add&sqlwhere=<%=xssUtil.put(getDepartmentSql(user))%>&selectedids="+jQuery("input[name=departmentid]").val());
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


function getCompleteUrl(){
	var url= "/data.jsp?type=hrmjobtitles";
			url+="&whereClause= jobdepartmentid="+jQuery("input[name=departmentid]").val();
  return url;	
}

function onShowJobtitle(){
	var url=encode("/hrm/jobtitles/JobTitlesBrowser.jsp?sqlwhere= where jobdepartmentid="+jQuery("input[name=departmentid]").val()+"&fromPage=add");
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
	<%if(departmentid.length()>0){%>
	showEle("itemjobtitle");
	<%}%>
})

function chkMail(){
	if(!document.forms[0].enddate ||document.resource.email.value == ''){
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
				   var idT = id1.id;
				   var nameT = id1.name;
			    if (linkurl == ""){
						jQuery("#customfield"+id+"span").html(nameT);
					}else{
						jQuery("#customfield"+id+"span").html("<a href="+linkurl+id1.id+">"+nameT+"</a>");
					}
					jQuery("input[name=customfield"+id+"]").val(idT);
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
