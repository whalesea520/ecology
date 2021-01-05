<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.request.RequestBrowser" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="crmComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(24270, user.getLanguage());
String needfav = "1";
String needhelp = "";

String requestname = Util.null2String(request.getParameter("requestname"));
    //System.out.println("requestname = " + requestname);
String creater = Util.null2String(request.getParameter("creater"));
String createdatestart = Util.null2String(request.getParameter("createdatestart"));
String createdateend = Util.null2String(request.getParameter("createdateend"));
String isrequest = Util.null2String(request.getParameter("isrequest"));
String requestmark = Util.null2String(request.getParameter("requestmark"));
String prjids=Util.null2String(request.getParameter("prjids"));
String crmids=Util.null2String(request.getParameter("crmids"));
String workflowid=Util.null2String(request.getParameter("workflowid"));
String formid=Util.null2String(request.getParameter("formid"));
int isbill=Util.getIntValue(request.getParameter("isbill"),1);
String department =Util.null2String(request.getParameter("department"));
String status = Util.null2String(request.getParameter("status"));
String ismode = Util.null2String(request.getParameter("ismode"));
String createdateselect = Util.null2String(request.getParameter("createdateselect"));
String sqlwhere = "";
if (isrequest.equals("")) isrequest = "1";


String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;
String userid = ""+user.getUID() ;
String userID = String.valueOf(user.getUID());
String usertype="0";
if(user.getLogintype().equals("2")) usertype="1";
String belongtoshow = "";				
		RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
		if(RecordSet.next()){
			belongtoshow = RecordSet.getString("belongtoshow");
		}
		String userIDAll = String.valueOf(user.getUID());	
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid + "");
if(!"".equals(Belongtoids) && "1".equals(belongtoshow)){
userIDAll = userID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}


int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!requestname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.requestnamenew like '%" + Util.fromScreen2(requestname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and t1.requestnamenew like '%" + Util.fromScreen2(requestname,user.getLanguage()) +"%' ";
}

if(!creater.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.creater =" + creater +" " ;
	}
	else
		sqlwhere += " and t1.creater =" + creater +" " ;
}

if(!createdatestart.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.createdate >='" + createdatestart +"' " ;
	}
	else
		sqlwhere += " and t1.createdate >='" + createdatestart +"' " ;
}

if(!createdateend.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.createdate <='" + createdateend +"' " ;
	}
	else
		sqlwhere += " and t1.createdate <='" + createdateend +"' " ;
}


if(status.equals("1")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.currentnodetype <> 3 " ;
	}
	else
		sqlwhere += " and t1.currentnodetype <> 3 " ;
}

if(status.equals("2")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.currentnodetype = 3 " ;
	}
	else
		sqlwhere += " and t1.currentnodetype = 3 " ;
}

if(!formid.equals("")&&!formid.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.workflowid in (select id from workflow_base where isbill='"+isbill+"' and formid=" + formid +")";
	}
	else{
		sqlwhere += " and t1.workflowid in (select id from workflow_base where isbill='"+isbill+"' and formid=" + formid +")";
	}
}

if(!workflowid.equals("")&&!workflowid.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.workflowid in (" + WorkflowVersion.getAllVersionStringByWFIDs(workflowid)+ ")";
	}
	else
		sqlwhere += " and t1.workflowid in (" + WorkflowVersion.getAllVersionStringByWFIDs(workflowid) + ")";
}

if(!department.equals("")&&!department.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.creater in (select id from hrmresource where departmentid in ("+department+"))";
	}
	else
		sqlwhere += " and t1.creater in (select id from hrmresource where departmentid in ("+department+"))";
}

if(!prjids.equals("")&&!prjids.equals("0")){
	if(ishead==0){
		ishead = 1;
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " where (concat(concat(',' , To_char(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";
		}else{
			sqlwhere += " where (',' + CONVERT(varchar,t1.prjids) + ',' LIKE '%,"+prjids+",%') ";
		}
	}else{
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " and (concat(concat(',' , To_char(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";
		}else{
			sqlwhere += " and (',' + CONVERT(varchar,t1.prjids) + ',' LIKE '%,"+prjids+",%') ";
		}
	}
}

if(!crmids.equals("")&&!crmids.equals("0")){
	if(ishead==0){
		ishead = 1;
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " where (concat(concat(',' , To_char(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";
		}else{
			sqlwhere += " where (',' + CONVERT(varchar,t1.crmids) + ',' LIKE '%,"+crmids+",%') ";
		}
	}else{
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " and (concat(concat(',' , To_char(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";
		}else{
			sqlwhere += " and (',' + CONVERT(varchar,t1.crmids) + ',' LIKE '%,"+crmids+",%') ";
		}
	}
}

if(!requestmark.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.requestmark like '%" + requestmark +"%' " ;
	}
	else
		sqlwhere += " and t1.requestmark like '%" + requestmark +"%' " ;
}

if (sqlwhere.equals("")){
    sqlwhere = " where t1.requestid <> 0 and t2.requestid = t1.requestid and t2.userid in (" +userIDAll + ") and t2.usertype="+usertype+" and exists(select 1 from workflow_base where id=t1.workflowid and (isvalid='1' or isvalid='3'))" ;
}else{
    sqlwhere += " and t2.requestid = t1.requestid and t2.userid in (" +userIDAll + ") and t2.usertype="+usertype+" and exists(select 1 from workflow_base where id=t1.workflowid and (isvalid='1' or isvalid='3')) " ;
}

%>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/browser/WorkFlowBrowser_wev8.js"></script>
<script type="text/javascript">
<!--2012-08-09 ypc 修改 把javascript后面直接通过Form的name提交表单数据改为调用js函数提交-->

var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}



function btn_cancle(){
	parentWin.closeDialog();
}

function SearchForm(){
	document.getElementById("SearchForm").submit();
}
function ResetForm(){
	document.getElementById("SearchForm").reset();
	//由于以下部分是标签的内容不是标签的value 用reset() 是无法清除的 所以要通过一下方式去清除
	//2012-08-16 ypc 修改
	document.getElementById("createdatestartspan").innerHTML="";
	document.getElementById("createdateendspan").innerHTML="";
	document.getElementById("createrspan").innerHTML="";
    document.getElementById("departmentspan").innerHTML="";
    document.getElementById("prjidsspan").innerHTML="";
    document.getElementById("crmidsspan").innerHTML="";
	//document.SearchForm.reset();
}
function onShowFlowID(inputname,spanname) {
	var url = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= <%=xssUtil.put(" where isbill='"+isbill+"' and formid="+formid )%>";
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = url;
	dialog.callbackfun = function (paramobj, id) {
		if (id) {
			var rid = wuiUtil.getJsonValueByIndex(id, 0);
			var rname = wuiUtil.getJsonValueByIndex(id, 1);
			if (rid != "") {
				$G(spanname).innerHTML = rname;
				$G(inputname).value = rid;
			} else {
				$G(spanname).innerHTML = "";
				$G(inputname).value = "";
			}
		}
	} ;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%>";
	dialog.Width = 550 ;
	dialog.Height = 550 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
}

function onShowManagerID(inputname,spanname) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = url;
	dialog.callbackfun = function (paramobj, id) {
		if (id) {
			var rid = wuiUtil.getJsonValueByIndex(id, 0);
			var rname = wuiUtil.getJsonValueByIndex(id, 1);
			if (rid != "") {
				$G(spanname).innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id=" + rid + "'>" + rname + "</A>";
				$G(inputname).value = rid;
			} else {
				$G(spanname).innerHTML = "";
				$G(inputname).value = "";
			}
		}
	} ;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18009,user.getLanguage())%>";
	dialog.Width = 550 ;
	dialog.Height = 550 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
}

function onShowCrmids() {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
	if (id) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			$G("crmidsspan").innerHTML = rname;
			$G("crmids").value = rid;
		} else {
			$G("crmidsspan").innerHTML = "";
			$G("crmids").value = "";
		}
	}
}

function onShowPrjids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = url;
	dialog.callbackfun = function (paramobj, id) {
		if (id) {
			var rid = wuiUtil.getJsonValueByIndex(id, 0);
			var rname = wuiUtil.getJsonValueByIndex(id, 1);
			if (rid != "") {
				$G("prjidsspan").innerHTML = rname;
				$G("prjids").value = rid;
			} else {
				$G("prjidsspan").innerHTML = "";
				$G("prjids").value = "";
			}
		}
	} ;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18009,user.getLanguage())%>";
	dialog.Width = 550 ;
	dialog.Height = 550 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
}

function onShowDepartment() {
	//出现空值导致脚本错误

	//把SearchForm.deparament.value 改成 document.getElementById().deparament.value 才能得到值

	//2012-08-10 ypc 修改
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + document.getElementById("SearchForm").department.value;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = url;
	dialog.callbackfun = function (paramobj, id) {
		if (id) {
			var rid = wuiUtil.getJsonValueByIndex(id, 0);
			var rname = wuiUtil.getJsonValueByIndex(id, 1);
			if (rid != "") {
				$G("departmentspan").innerHTML = rname.substr(1);
				$G("department").value = rid.substr(1);
			} else {
				$G("departmentspan").innerHTML = "";
				$G("department").value = "";
			}
		}
	} ;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18009,user.getLanguage())%>";
	dialog.Width = 550 ;
	dialog.Height = 550 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
}

</script>
 <script language="javascript">
function submitData() {
    if(_xtable_CheckedRadioId()=="") {
		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>');
	} else {
	    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(24274,user.getLanguage())%>",function(){ 
           var win = parentWin.dialogArguments;
	       if(win != null){
	           parentWin.doImport(_xtable_CheckedRadioId());            
	       }else{
	           try{
	            	top.opener.window.doImport(_xtable_CheckedRadioId());
	           }catch(e){
	            	parentWin.doImport(_xtable_CheckedRadioId());
	            }
	        }
	        parentWin.closeDialog();
        });
      // if(confirm("<%=SystemEnv.getHtmlLabelName(24274,user.getLanguage())%>")){
	  //     var win = parentWin.dialogArguments;
	  //     if(win != null){
	  //         parentWin.doImport(_xtable_CheckedRadioId());            
	  //     }else{
	  //         try{
	  //          	top.opener.window.doImport(_xtable_CheckedRadioId());
	  //         }catch(e){
	  //          	parentWin.doImport(_xtable_CheckedRadioId());
	  //          }
	  //      }
	  //       parentWin.closeDialog();
      //   }
    }
}


</script>
</HEAD>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//2012-08-09 ypc 修改 把javascript后面直接通过Form的name提交表单数据改为调用js函数提交
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:ResetForm(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top"  onclick="javascript:SearchForm(),_self"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM name="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="RequestImport.jsp" method="post">
<input name=formid type=hidden value="<%=formid%>">
<input name=isbill type=hidden value="<%=isbill%>">
<input name=ismode type=hidden value="<%=ismode%>">

<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(24270, user.getLanguage()) %>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></wea:item>
		<wea:item><input name=requestname class=Inputstyle value='<%=requestname%>'></wea:item>
		<wea:item><%if(!user.getLogintype().equals("2")){%><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><%}%></wea:item>
		<wea:item><%if(!user.getLogintype().equals("2")){%>
			   <span><brow:browser viewType="0" name="creater"
						browserValue='<%=creater%>'
						completeUrl="/data.jsp?type=1"
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids=#id#"
						hasInput="true" isSingle="false" hasBrowser="true"
						isMustInput='1' linkUrl="#"
						browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage())%>'>
				</brow:browser></span>
		<!-- 
		    <button type="button"  class=Browser id=SelectManagerID onClick="onShowManagerID('creater', 'createrspan')"></BUTTON><%}%>
	  		显示 创建人 浏览按钮的值 2012-08-16 ypc 
	  		<span id=createrspan><%=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage())%></span>
            <INPUT class=Inputstyle id=creater type=hidden name=creater value="<%=creater%>">
         -->
		</wea:item>

		 <wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
		 <wea:item>
		     <!-- 
		 	  <span style='float:left;display:inline-block;'>
                   <select name="createdateselect" id="createdateselect" onchange="changeDate(this,'createdate');" class="inputstyle" size=1>
	               		<option value="0" <% if(createdateselect.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %></option>
	                    <option value="1" <% if(createdateselect.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage()) %></option>
	                    <option value="2" <% if(createdateselect.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage()) %></option>
	                    <option value="3" <% if(createdateselect.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage()) %></option>
	                    <option value="4" <% if(createdateselect.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage()) %></option>
	                    <option value="5" <% if(createdateselect.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage()) %></option>
	                    <option value="6" <% if(createdateselect.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32530, user.getLanguage()) %></option>
	               </select>
             </span>
			 <span style='float:left;margin-left: 10px;padding-top: 5px;'>
                  <span id="createdate" style="display:<%if(!createdateselect.equals("6")) {%>none<%} %>">
						<button type="button" class="calendar" id="SelectDate" onclick="getTheDate(createdatestart,createdatestartspan)"></button>&nbsp;
						<span id="createdatestartspan"><%=createdatestart %></span>
						-&nbsp;&nbsp;
						<button type="button" class="calendar" id="SelectDate1" onclick="getTheDate(createdateend,createdateendspan)"></button>&nbsp;
						<span id="createdateendspan"><%=createdateend %></span>
				   </span>
				   <input type="hidden" id=createdatestart name="createdatestart" value="<%=createdatestart %>">
				   <input type="hidden" id=createdateend name="createdateend" value="<%=createdateend %>">
			</span>
		 	 -->
		 	  
		 	  <input type="hidden" id=createdatestart name="createdatestart" value="<%=createdatestart%>">
	  		  <input type="hidden" id=createdateend name="createdateend" value="<%=createdateend%>">
		 	  <button type=button  class=Calendar id=selectbirthday onclick="getTheDate(createdatestart,createdatestartspan)"></BUTTON>
	  		   <!-- 显示起始时间的标签 2012-08-16 ypc  -->
	  		  <SPAN id=createdatestartspan ><%=createdatestart%></SPAN>
	  		  - &nbsp;
	  		  <button type=button  class=Calendar id=selectbirthday1 onclick="getTheDate(createdateend,createdateendspan)"></BUTTON>
	  		  <!--  显示结束时间的标签 2012-08-16 ypc -->
	  		  <SPAN id=createdateendspan ><%=createdateend%></SPAN>
	  		  
  		  </wea:item>
		 <wea:item><%=SystemEnv.getHtmlLabelName(19502,user.getLanguage())%></wea:item>
		 <wea:item><input name=requestmark class=Inputstyle value='<%=requestmark%>'></wea:item>

		 <wea:item><%=SystemEnv.getHtmlLabelName(19225,user.getLanguage())%></wea:item>
		 <wea:item>
		 	<%
				String departments[] = Util.TokenizerString2(department,",");
				String departmentnames = "";
				for(int i=0;i<departments.length;i++){
					if(!departments[i].equals("")&&!departments[i].equals("0")){
						departmentnames += (!departmentnames.equals("")?",":"") + DepartmentComInfo.getDepartmentname(departments[i]);
					}
				}
			%>
		    <span><brow:browser viewType="0" name="department"
						browserValue='<%=department%>'
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
						hasInput='true' isSingle="false" hasBrowser="true"
						completeUrl="/data.jsp?type=4"
						isMustInput='1' linkUrl="#"
						browserSpanValue='<%=departmentnames%>'>
		    </brow:browser></span>
		    <!-- 
	 		<button type=button  class=Browser onClick="onShowDepartment()"></button>
			<span id="departmentspan">
			 </span>
			 <input class=inputstyle id=department type=hidden name=department value="<%=department%>">
			  -->
		 </wea:item>
		 <wea:item><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></wea:item>
		 <wea:item>
		    <span><brow:browser viewType="0" name="prjids"
						browserValue='<%=prjids%>'
						browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp?resourceids="
						hasInput='true' isSingle="false" hasBrowser="true"
						isMustInput='1' linkUrl="#"
						completeUrl="/data.jsp?type=8"
						browserSpanValue='<%=ProjectInfoComInfo.getProjectInfoname(prjids)%>'>
			</brow:browser></span>
		    <!-- 
		 	<button type=button  class=Browser onClick="onShowPrjids()"></button>
			 显示相关项目 2012-08-16 ypc
			<span id=prjidsspan><%=ProjectInfoComInfo.getProjectInfoname(prjids)%></span>
			<input name=prjids type=hidden value="<%=prjids%>">
			 -->
		 </wea:item>

		 <wea:item><%=SystemEnv.getHtmlLabelName(26361,user.getLanguage())%></wea:item>
		 <wea:item>
		 	<% String wfbytypeBrowserURL = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp";%>
		    	<brow:browser viewType="0" name="workflowid" browserValue='<%=workflowid%>' browserOnClick="" 
		    	browserUrl='<%=wfbytypeBrowserURL %>' hasInput="true" isSingle="true" 
		    	hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=workflowBrowser" 
		    	width="80%" browserSpanValue='<%=WorkflowComInfo.getWorkflowname(workflowid)%>'> </brow:browser>
		 	
		 	
		 </wea:item>
		 <wea:item><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></wea:item>
		 <wea:item>
		    <span><brow:browser viewType="0" name="crmids"
				browserValue='<%=crmids%>'
				browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?resourceids="
				hasInput='true' isSingle="false" hasBrowser="true"
				completeUrl="/data.jsp?type=7"
				isMustInput='1' linkUrl="#"
				browserSpanValue='<%=crmComInfo.getCustomerInfoname(crmids)%>'>
			</brow:browser></span>
		    <!-- 
		 	<button type=button  class=Browser onClick="onShowCrmids()"></button>
		     显示相关客户 2012-08-16 ypc
			<span id=crmidsspan><%=crmComInfo.getCustomerInfoname(crmids)%></span>
			<input name=crmids type=hidden value="<%=crmids%>">
			 -->
		 </wea:item>
		 
		 <wea:item><%=SystemEnv.getHtmlLabelName(19061,user.getLanguage())%></wea:item>
		 <wea:item>
	 
		 	<select id=status name=status style="width: 100px;">
				<option value=""></option>
				<option value="1" <%if(status.equals("1")) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(17999,user.getLanguage())%></option>
				<option value="2" <%if(status.equals("2")) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(18800,user.getLanguage())%></option>
			</select>

		 </wea:item>

 	</wea:group>
</wea:layout>  

<%
String backfields = " t1.requestid,t1.requestname,t1.creater,t1.createdate,t1.createtime,t1.requestnamenew ";
String fromSql  = " workflow_requestbase t1, workFlow_CurrentOperator t2 ";
String tableString = "";
int perpage=10;
//System.out.println("select "+backfields+" from "+fromSql+sqlwhere+" order by t1.createdate,t1.createtime");
tableString =   " <table instanceid=\"sendDocListTable\" tabletype=\"radio\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_REQUEST_REQUESTIMPORT,user.getUID())+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"t1.createdate,t1.createtime\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestnamenew\" orderkey=\"t1.requestnamenew\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfOnlyViewLink\" otherpara=\"column:requestid\" />"+
                "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate,createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />"+
                "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />"+
                "       </head>"+
                " </table>";
%>
<TABLE width="100%">
    <tr>
        <td valign="top">
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>
  <input type="hidden" name="sqlwhere" value="<%=xssUtil.put(sqlwhere)%>">
  <input type="hidden" name="isrequest" value="<%=isrequest%>">
  <input type="hidden" name="pageId"  _showCol="false" id="pageId" value="<%= PageIdConst.WF_REQUEST_REQUESTIMPORT %>"/>


<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">

</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
			    <input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_OK"  class="zd_btn_submit" onclick="submitData()">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<SCRIPT language="javascript" src="/js/ecology8/request/wFCommonAdvancedSearch_wev8.js"></script>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

</BODY></HTML>



<!-- 
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
      window.parent.Close
   End If
End Sub

sub onShowFlowID(inputname,spanname)
   id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill='<%=isbill%>' and formid=<%=formid%>")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			spanname.innerHtml = id(1)
			inputname.value=id(0)
		else
				spanname.innerHtml = ""
				inputname.value=""
		end if
	end if
end sub

sub onShowManagerID(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub

sub onShowCrmids()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		crmidsspan.innerHtml = id(1)
		SearchForm.crmids.value=id(0)
		else
		crmidsspan.innerHtml = ""
		SearchForm.crmids.value=""
		end if
	end if
end sub

sub onShowPrjids()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		prjidsspan.innerHtml = id(1)
		SearchForm.prjids.value=id(0)
		else
		prjidsspan.innerHtml = ""
		SearchForm.prjids.value=""
		end if
	end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="&SearchForm.department.value)
    if Not isempty(id) then
	if id(0)<> "" then
	departmentspan.innerHtml = Mid(id(1),2)
	SearchForm.department.value=Mid(id(0),2)
	else
	departmentspan.innerHtml = ""
	SearchForm.department.value=""
	end if
	end if
end sub
</SCRIPT>
 -->

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
