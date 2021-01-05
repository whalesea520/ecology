
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.sms.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
if(!HrmUserVarify.checkUserRight("Sms:Set", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}

//预览测试内容
String conent=SystemEnv.getHtmlLabelName(345,user.getLanguage());

int userid=user.getUID();   //Util.getIntValue(request.getParameter("userid"),0);
String username=user.getUsername();
String dept=DepartmentComInfo.getDepartmentname(user.getUserDepartment()+"");
String subcomp=SubCompanyComInfo.getSubCompanyname(user.getUserSubCompany1()+"");
//管理员没有部门和分部处理
dept="".equals(dept)?SystemEnv.getHtmlLabelName(124,user.getLanguage()):dept;
subcomp="".equals(subcomp)?SystemEnv.getHtmlLabelName(141,user.getLanguage()):subcomp;

String operate=Util.null2String(request.getParameter("operate"));
if("save".equals(operate)){
	String signPostion = Util.null2String(request.getParameter("signPostion"));
	String isname = Util.null2String(request.getParameter("username"));
	String isid = Util.null2String(request.getParameter("userid"));
	String isdept = Util.null2String(request.getParameter("dept"));
	String issubcomp = Util.null2String(request.getParameter("subcomp"));
	
	String longSms = Util.null2String(request.getParameter("longSms"));
	String splitLength = Util.null2String(request.getParameter("splitLength"));
	String sign = Util.null2String(request.getParameter("sign"));
	String signPos = Util.null2String(request.getParameter("signPos"));
	String showReply = Util.null2String(request.getParameter("showReply"));
	SmsSetBean set=new SmsSetBean();
	set.setLongSms("1".equals(longSms)?"1":"0");
	set.setSplitLength(Integer.parseInt(splitLength));
	set.setUsername("1".equals(isname)?"1":"0");
	set.setUserid("1".equals(isid)?"1":"0");
	set.setDept("1".equals(isdept)?"1":"0");
	set.setSubcomp("1".equals(issubcomp)?"1":"0");
	set.setSignPostion(signPostion);
	set.setSign(sign);
	set.setSignPos(signPos);
	set.setShowReply("1".equals(showReply)?"1":"0");
	SmsCache.saveSmsSet(set);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.insSysLogInfo(user,0,"短信基础设置","短信应用设置-基础设置","316","2",0,Util.getIpAddr(request)); 
}
//获取短信配置
SmsSetBean wc=SmsCache.getSmsSet();

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32776,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
 
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<form name="frmmain" method="post" action="SmsSetup.jsp">
<input type="hidden" name="operate" value="save">
<input type="hidden" name="username" id="isusername" value="<%=wc.getUsername() %>">
<input type="hidden" name="userid" id="isuserid" value="<%=wc.getUserid() %>">
<input type="hidden" name="dept" id="isdept" value="<%=wc.getDept() %>">
<input type="hidden" name="subcomp" id="issubcomp" value="<%=wc.getSubcomp() %>">
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<wea:layout type="2Col">
			 	<!-- 发送设置 -->
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(18905,user.getLanguage()) %>' attributes="{'itemAreaDisplay':'inline-block'}" >
				      <wea:item><%=SystemEnv.getHtmlLabelName(33077,user.getLanguage()) %></wea:item>
				      <wea:item>
				      	  <input  tzCheckbox="true" type="checkbox"  id="longSms" name="longSms" <%="1".equals(wc.getLongSms())?"checked":"" %> onclick="changeSplit()"> 
				      	  &nbsp;&nbsp;&nbsp;<span style="color:grey"><%=SystemEnv.getHtmlLabelName(32952,user.getLanguage()) %></span>
				      </wea:item>
				      
				      <wea:item attributes="{'samePair':'splitLengthtd'}"><%=SystemEnv.getHtmlLabelName(32953,user.getLanguage()) %></wea:item>
				      <wea:item attributes="{'samePair':'splitLengthtd'}">
				          <input type="text" style="width:50px;" class="InputStyle" id="splitLength" onchange="checkNum()" onkeypress="ItemPlusCount_KeyPress()" name="splitLength" value="<%=wc.getSplitLength()%>">
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(26168,user.getLanguage()) %></wea:item>
				      <wea:item>
				      	  <select id="signPos" name="signPos">
					  		<option value="0" <%="0".equals(wc.getSignPos())?"selected":"" %>><%=SystemEnv.getHtmlLabelName(33203,user.getLanguage()) %></option>
					  		<option value="1" <%="1".equals(wc.getSignPos())?"selected":"" %>><%=SystemEnv.getHtmlLabelName(33204,user.getLanguage()) %></option>
					  	  </select>
					  	  &nbsp;
				          <input type="text" style="width:180px;" class="InputStyle" id="sign" name="sign" value="<%=wc.getSign()%>">
				      </wea:item>
			     </wea:group>
			     
			     <!-- 回复设置 -->
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(117,user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage()) %>' attributes="{'itemAreaDisplay':'inline-block'}" >
				      <wea:item><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())+SystemEnv.getHtmlLabelName(18539,user.getLanguage()) %></wea:item> 
				      <wea:item>
				      	  <input  tzCheckbox="true" type="checkbox"  id="showReply" name="showReply" <%="1".equals(wc.getShowReply())?"checked":"" %>> 
				      </wea:item>
			     </wea:group>
			     
			 	 <!-- 署名设置 -->
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(32782,user.getLanguage()) %>' attributes="{'itemAreaDisplay':'inline-block'}" >
				      <wea:item><%=SystemEnv.getHtmlLabelName(32778,user.getLanguage()) %></wea:item>
				      <wea:item>
				          <select id="signPostion" name="signPostion" onchange="preview()">
					  		<option value="0" <%="0".equals(wc.getSignPostion())?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32780,user.getLanguage()) %></option>
					  		<option value="1" <%="1".equals(wc.getSignPostion())?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32781,user.getLanguage()) %></option>
					  	  </select>
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(32779,user.getLanguage()) %></wea:item>
				      <wea:item>
				          <input type="checkbox" id="username" value="1" <%="1".equals(wc.getUsername())?"checked":"" %> onclick="preview()"><%=SystemEnv.getHtmlLabelName(16975,user.getLanguage())+SystemEnv.getHtmlLabelName(413,user.getLanguage()) %>&nbsp;&nbsp;
		              	  <input type="checkbox" id="userid" value="1" <%="1".equals(wc.getUserid())?"checked":"" %> onclick="preview()"><%=SystemEnv.getHtmlLabelName(16975,user.getLanguage()) %>ID&nbsp;&nbsp;
		              	  <input type="checkbox" id="dept" value="1" <%="1".equals(wc.getDept())?"checked":"" %> onclick="preview()"><%=SystemEnv.getHtmlLabelName(16975,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage()) %>&nbsp;&nbsp;
		              	  <input type="checkbox" id="subcomp" value="1" <%="1".equals(wc.getSubcomp())?"checked":"" %> onclick="preview()"><%=SystemEnv.getHtmlLabelName(16975,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage()) %>&nbsp;&nbsp;
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(221,user.getLanguage()) %></wea:item>
				      <wea:item>
				          <SPAN id="signview"></SPAN>
				      </wea:item>
			     </wea:group>
			     
			</wea:layout>	
		</td>
		</tr>
		</TABLE>
	</td>
</tr>
</table>
</form>

</body>
<script src="/wechat/js/wechat_wev8.js" type="text/javascript"></script>
<script language="javascript">
 
 
$(document).ready(function() {
       	preview();
	    changeSplit();
});

var conent="<%=conent%>";
function preview(){
    var sign= ($("#username").attr("checked")?"-<%=username%>":"")+($('#userid').attr("checked")?"(<%=userid%>)":"")
    		+($('#dept').attr("checked")?"-<%=dept%>":"")+($('#subcomp').attr("checked")?"-<%=subcomp%>":"");
    
	if($('#signPostion').val()==1){
		$('#signview').html(conent+(sign==""?"":sign.indexOf("-")==0?sign:"-"+sign));
	}else{
		$('#signview').html((sign==""?"":(sign.indexOf("-")==0?sign.substring(1,sign.length)+"-":sign+"-"))+conent);
	}
} 


function changeSplit(){
	if($("#longSms").attr("checked")){//支持长短信,隐藏分割字符
		hideEle('splitLengthtd');
	}else{
		showEle('splitLengthtd');
	}
}

function doSubmit()
{
	$('#isusername').val($("#username").attr("checked")?"1":"0");
	$('#isuserid').val($("#userid").attr("checked")?"1":"0");
	$('#isdept').val($("#dept").attr("checked")?"1":"0");
	$('#issubcomp').val($("#subcomp").attr("checked")?"1":"0");
	
	$('#longSms').val($("#longSms").attr("checked")?"1":"0");
	$('#showReply').val($("#showReply").attr("checked")?"1":"0");
	
	if($('#longSms').val()==0){
		if($('#splitLength').val()==""||$('#splitLength').val()<60){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32953,user.getLanguage())+SystemEnv.getHtmlLabelName(451,user.getLanguage()) %>60");
			return;
		}else if($('#splitLength').val()>999){
			$('#splitLength').val(999);
		}
	}
	if($('#sign').val().length>10){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26168,user.getLanguage())+SystemEnv.getHtmlLabelName(20246,user.getLanguage()) %>10");
		return;
	}
	
	document.forms[0].submit();
}

function checkNum(){
	var val=$('#splitLength').val();
	var arr = val.split("");//全部分割
	var ret="";
	for (var i = 0; i < arr.length; i++) {
		if(isNaN(arr[i])||(i==0&&arr[i]==0)) continue;
		ret+=arr[i];
	}
	$('#splitLength').val(ret);
} 
</script>

</html>
