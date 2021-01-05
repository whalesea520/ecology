
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.wechat.bean.*,weaver.wechat.cache.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<HTML><HEAD>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
if(!HrmUserVarify.checkUserRight("Wechat:Set", user))
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
	String oaUrl = Util.null2String(request.getParameter("oaUrl"));
	String mobileUrl = Util.null2String(request.getParameter("mobileUrl"));
	WechatSetBean set=new WechatSetBean();
	set.setOaUrl(oaUrl);
	set.setMobileUrl(mobileUrl);
	set.setUsername("1".equals(isname)?"1":"0");
	set.setUserid("1".equals(isid)?"1":"0");
	set.setDept("1".equals(isdept)?"1":"0");
	set.setSubcomp("1".equals(issubcomp)?"1":"0");
	set.setSignPostion(signPostion);
	WechatSetCache.saveWechatSet(set);
	//保存默认提醒
	String reminderid = Util.null2String(request.getParameter("reminderid"));
	String prefix = Util.null2String(request.getParameter("prefix"));
	String prefixConnector = Util.null2String(request.getParameter("prefixConnector"));
	String suffix = Util.null2String(request.getParameter("suffix"));
	String suffixConnector = Util.null2String(request.getParameter("suffixConnector"));
	ReminderBean rb=new ReminderBean();
	if(!"".equals(reminderid)&&!"0".equals(reminderid)){//更新
		rs.executeSql("update wechat_reminder_set set prefix='"+prefix+"', suffix='"+suffix+"',prefixConnector='"+prefixConnector+"',suffixConnector='"+suffixConnector+"' where id="+reminderid);
	}else{//新增
		rs.executeSql("insert into wechat_reminder_set(prefix,suffix,prefixConnector,suffixConnector,type,def) values('"+prefix+"','"+suffix+"','"+prefixConnector+"','"+suffixConnector+"','ALL','1')");
	} 
	//保存默认提醒平台
	String defaultReminder = request.getParameter("defaultReminder");
	rs.executeSql("update wechat_platform set defaultReminder=0");
	rs.executeSql("update wechat_platform set defaultReminder=1 where id='"+defaultReminder+"'");
	
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.insSysLogInfo(user,0,"微信应用设置","微信应用设置","317","2",0,Util.getIpAddr(request));
}
//获取微信配置
WechatSetBean wc=WechatSetCache.getWechatSet();
//获取微信默认提醒
ReminderBean rb=ReminderCache.getDefaultReminder(); 
//获取默认提醒平台
WeChatBean wcb=PlatFormCache.getJustDefalutWeChatBean();
//是否启用特殊模块提醒
boolean showSpecial=false;
rs.execute("select 1 from wechat_reminder_type");
if(rs.next()){
	showSpecial=true;
}
//获取特殊提醒配置
String perpage=PageIdConst.getPageSize(PageIdConst.Wechat_ReminderList,user.getUID());

String sqlwhere=" where t1.type=t2.type and t2.modekey=t3.modekey and def='0'  ";
String backFields = " t1.*,t2.typename,t3.modename ";
String sqlFrom = " wechat_reminder_set t1,wechat_reminder_type t2,wechat_reminder_mode t3 ";

String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"wechatSetupTable\" tabletype=\"checkbox\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                            
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15148,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"typename\" />"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19049,user.getLanguage())+"\" column=\"modename\"/>"+
					  "<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(32784,user.getLanguage())+"\"  column=\"prefix\"/>"+
					  "<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(32785,user.getLanguage())+"\"  column=\"suffix\"/>"+
			  "</head>";
tableString +=  "<operates>"+
                "		<operate href=\"javascript:editReminder();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:delReminder();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"</operates>";
tableString += "</table>";

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

<form name="frmmain" method="post" action="wechatSetup.jsp">
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
			 	<!-- 署名设置 -->
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(32642,user.getLanguage())+SystemEnv.getHtmlLabelName(32782,user.getLanguage()) %>' attributes="{'groupOperDisplay':''}" >
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
			     <!-- 集成设置 -->
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(32783,user.getLanguage()) %>' attributes="{'itemAreaDisplay':'inline-block'}" >
				      <wea:item><%=SystemEnv.getHtmlLabelName(21870,user.getLanguage()) %></wea:item>
				      <wea:item>
				          <input type="text" id="oaUrl" name="oaUrl" value="<%=wc.getOaUrl()%>" style="width:40%!important" class="InputStyle">
              			  <SPAN id=oaUrlimage style="color:red">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(32907,user.getLanguage()) %></SPAN>
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(32777,user.getLanguage()) %></wea:item>
				      <wea:item>
				          <input type="text" id="mobileUrl" name="mobileUrl" value="<%=wc.getMobileUrl()%>" style="width:40%" class="InputStyle">
              			  <SPAN id=mobileUrlimage style="color:red">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(32908,user.getLanguage()) %></SPAN>
				      </wea:item>
			     </wea:group>
			     <!-- 提醒设置 -->
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(21946,user.getLanguage()) %>' attributes="{'itemAreaDisplay':'inline-block'}" >
				      <wea:item><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())+SystemEnv.getHtmlLabelName(15148,user.getLanguage())+SystemEnv.getHtmlLabelName(32689,user.getLanguage()) %></wea:item>
				      <wea:item>
							<brow:browser viewType="0" temptitle='<%=SystemEnv.getHtmlLabelName(149,user.getLanguage())+SystemEnv.getHtmlLabelName(15148,user.getLanguage())+SystemEnv.getHtmlLabelName(32689,user.getLanguage()) %>' name="defaultReminder" browserValue='<%=wcb.getId()%>'
								browserOnClick="" browserUrl="/wechat/bowser/mode/platformBrowserTab.jsp?id="  width="40%"
								hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  
								completeUrl="/data.jsp?type=wechatPlatform" linkUrl="/wechat/platformEdit.jsp?id=" 
								browserSpanValue='<%=wcb.getName() %>'></brow:browser>
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(32784,user.getLanguage()) %></wea:item>
				      <wea:item>
				          <input type="hidden" id="reminderid" name="reminderid" value="<%=rb.getId()%>">
			              <input type="text" id="prefix" name="prefix" value="<%=rb.getPrefix()%>" style="width:40%!important" class="InputStyle" onchange="reminderView()">&nbsp;&nbsp;
			              <input type="hidden" id="prefixConnector" name="prefixConnector" value="">
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(32785,user.getLanguage()) %></wea:item>
				      <wea:item>
				          <input type="text" id="suffix" name="suffix" value="<%=rb.getSuffix()%>" style="width:40%!important" class="InputStyle" onchange="reminderView()">&nbsp;&nbsp;
              			  <input type="hidden" id="suffixConnector" name="suffixConnector" value="">
				      </wea:item>
				      <wea:item><%=SystemEnv.getHtmlLabelName(221,user.getLanguage()) %></wea:item>
				      <wea:item>
				          <SPAN id="reminderView"></SPAN>
				      </wea:item>
			     </wea:group>
			     
			     <%if(showSpecial){ %>
		          	<wea:group context='<%=SystemEnv.getHtmlLabelName(32787,user.getLanguage())%>' attributes="{'itemAreaDisplay':'inline-block'}">
				      <wea:item type="groupHead">
				         <input Class="addbtn" type="button" onclick="doAdd()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
						 <input Class="delbtn" type="button" onclick="doDel()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
				      </wea:item>
				      <wea:item attributes="{'isTableList':'true'}">
				      		<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Wechat_ReminderList%>"/>
				          <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>
				      </wea:item>
	     			</wea:group>
				      <%} %>
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

var diag_vote;
function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	_table.reLoad();
	diag_vote.close();
}

function refreshTable(){
	_table.reLoad();
}

$(document).ready(function() {
       	preview();
	    reminderView();
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

function reminderView(){
	var view=conent;
	if($("#prefix").val()!=''){
		view=$("#prefix").val()+$("#prefixConnector").val()+conent;
	}
	if($("#suffix").val()!=''){
		view+=$("#suffixConnector").val()+$("#suffix").val();
	}
	$('#reminderView').html(view);
}


function doSubmit()
{
	$('#isusername').val($("#username").attr("checked")?"1":"0");
	$('#isuserid').val($("#userid").attr("checked")?"1":"0");
	$('#isdept').val($("#dept").attr("checked")?"1":"0");
	$('#issubcomp').val($("#subcomp").attr("checked")?"1":"0");
	document.forms[0].submit();
}

function doAdd(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 550;
	diag_vote.Height = 300;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(1421,user.getLanguage())+SystemEnv.getHtmlLabelName(32787,user.getLanguage())%>";
	diag_vote.URL = "/wechat/reminderSetTab.jsp";
	diag_vote.show();
}

function editReminder(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 550;
	diag_vote.Height = 300;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(32787,user.getLanguage())%>";
	diag_vote.URL = "/wechat/reminderSetTab.jsp?id="+id;
	diag_vote.show();
}

function delReminder(id){
	 window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
	    $.post("wechatSetupOperate.jsp", 
		{"operate":"del", "IDS": id},
	   	function(data){
			var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
			 if(data=="true"){
			 	 _table.reLoad();
			 }else{
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
			 }
   		});
    });
}

function doDel(){
	var deleteids = _xtable_CheckedCheckboxId();
	if(deleteids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}else{
	    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		    $.post("wechatSetupOperate.jsp", 
			{"operate":"del", "IDS": deleteids.substr(0,deleteids.length-1)},
		   	function(data){
				var data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
				 if(data=="true"){
				 	 _table.reLoad();
				 }else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22620,user.getLanguage())%>");
				 }
	   		});
	    });
    }
}

</script>

</html>
