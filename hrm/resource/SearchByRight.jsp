<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField"%> 
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
</HEAD>
<body>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1867,user.getLanguage());
String needfav ="1";
String needhelp ="";
int tabid=0;
//组合查询不接收条件
String sqlwhere ="";// Util.null2String(request.getParameter("sqlwhere"));
String status ="";// Util.null2String(request.getParameter("status"));
String fromHrmStatusChange = Util.null2String(request.getParameter("fromHrmStatusChange"));
String rightStr = Util.null2String(request.getParameter("rightStr"));
String resourceids = Util.null2String(request.getParameter("resourceids"));

%>
	<FORM id=SearchForm NAME=SearchForm STYLE="margin-bottom:0" action="MultiSelectByRight.jsp" method=post target="frame2">
	<input type="hidden" name="isinit" value="1"/>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnsearch_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:document.SearchForm.btncancel.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
	<BUTTON class=btnSearch accessKey=S style="display:none" id="btnsearch" onclick="btnsearch_onclick();"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<BUTTON class=btnReset accessKey=T style="display:none" id=reset type="button" onclick="reset_onclick();"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<!-- 2012-08-15 ypc 修改 添加了btnok_onclick() 事件 -->
	<BUTTON class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON class=btnReset accessKey=T style="display:none" id=btncancel onclick="btncancel_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<!-- 2012-08-15 ypc 修改 添加了btnok_onclick() 事件 -->
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="btnsearch_onclick();" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="4col">
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=lastname ></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
    <wea:item>
      <select class=inputstyle id=status name=status >
				<%if(fromHrmStatusChange.equals("HrmResourceTry")){ %>
      	  <option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	  		<option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
      	<%}else if(fromHrmStatusChange.equals("HrmResourceHire")) {%>
         	<option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option> 
	  		<option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
			  <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
			  <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
        <%}else if(fromHrmStatusChange.equals("HrmResourceExtend")) {%>
      	  <option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	  		<option value=1><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
          <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
          <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
          <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
      	<%}else if(fromHrmStatusChange.equals("HrmResourceDismiss")) {%>
      		<option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
			  <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
			  <option value=1 ><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
			  <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
			  <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
			  <option value=7 ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
   	  	<%}else if(fromHrmStatusChange.equals("HrmResourceRetire")) {%>
   	  		<option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	  		<option value=1><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
   	  	<%}else if(fromHrmStatusChange.equals("HrmResourceFire")) {%>
   	  	  <option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
          <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
	  		<option value=1 ><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
          <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
	  		<option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
   	  	<%}else if(fromHrmStatusChange.equals("HrmResourceRehire")) {%>
   	  	  <option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
			  <option value=4 ><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></option>
			  <option value=5 ><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></option>
			  <option value=6 ><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></option>
			  <option value=7 ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
      	<%}else{ %>
        <option value=9 ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
        <option value="8" selected><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
        <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
        <option value=1 ><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
        <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
        <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
        <option value=4 ><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></option>
        <option value=5 ><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></option>
        <option value=6 ><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></option>
        <option value=7 ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
        <%} %>
      </select>
    </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
    <wea:item>
       <brow:browser viewType="0" name="subcompanyid"
        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
        hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
        completeUrl="/data.jsp?type=164" _callback="jsSubcompanyCallback">
      </brow:browser>
    </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
    <wea:item>
      <brow:browser viewType="0" name="departmentid" browserValue="" 
        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
        hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
        completeUrl="/data.jsp?type=4" _callback="jsDepartmentCallback" >
      </brow:browser>
    </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
		<wea:item>
				<input class=inputstyle id=jobtitle name=jobtitle maxlength=60 >
     </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></wea:item>
		<wea:item>
      <brow:browser viewType="0" name="roleid" browserValue="" 
        browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/roles/HrmRolesBrowser.jsp?selectedids="
        hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
        completeUrl="/data.jsp?type=65" browserSpanValue="">
      </brow:browser>
    </wea:item>
	</wea:group>
</wea:layout>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="resourceids" >
  <input class=inputstyle type="hidden" name="isNoAccount" id="isNoAccount">
<input class=inputstyle type="hidden" name="tabid" >
<input type="hidden" name="fromHrmStatusChange" id="fromHrmStatusChange" value='<%=fromHrmStatusChange%>'>
		<input type="hidden" name="rightStr" id="rightStr" value='<%=rightStr%>'>
	<!--########//Search Table End########-->
	</FORM>
<script language="javascript">
	var dialog = null;
	try{
		dialog = parent.parent.parent.getDialog(parent.parent);
	}catch(ex1){}
	
function reset_onclick(){
	_writeBackData('subcompanyid','1',{'id':'','name':''});
	_writeBackData('departmentid','1',{'id':'','name':''});
	_writeBackData('roleid','1',{'id':'','name':''});
	//清除select框
	jQuery("#status").selectbox("detach");
	jQuery("#status").val("");
	jQuery("#status").selectbox();
	document.SearchForm.status.value=""
	document.SearchForm.jobtitle.value=""
	document.SearchForm.lastname.value=""
	jQuery("input[name=subcompanyid]").val("");
	jQuery("input[name=departmentid]").val("");
	jQuery("input[name=roleid]").val("");
}
//2012-08-15 ypc  添加此函数
function btnsearch_onclick(){
	$("input[name=resourceids]").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
  $("input[name=tabid]").val(2); //把这个val(2) 改为val(1) 就可以解决掉 搜索之后搜索按钮不见了的问题 2012-08-15 ypc 修改
  //是否显示无账号人员
  if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked")){
    jQuery("#isNoAccount").val("1");
  }else{
    jQuery("#isNoAccount").val("0");
  }  
	$("#SearchForm").submit();
}

function btnok_onclick(){
	window.parent.frame2.btnok.click();
}

function jsSubcompanyCallback(e,datas, name){
	if (datas && datas.id!=""){
		_writeBackData('departmentid','1',{'id':'','name':''});
	}
}
function jsDepartmentCallback(e,datas, name){
	if(datas && datas.id!="") {
		_writeBackData('subcompanyid','1',{'id':'','name':''});
	}   
}

function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
		try{
    	dialog.callback(returnjson);
    }catch(e){}

		try{
	  	dialog.close(returnjson);
	 	}catch(e){}
	}else{
		window.parent.parent.returnValue = returnjson;
    window.parent.parent.close();
	}
}
	
function btncancel_onclick(){
	if(dialog){
	  	dialog.close();
	}else{
	   window.parent.parent.close();
	}
}

</script>
</BODY>
</HTML>