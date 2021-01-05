
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
boolean canedit = false;
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("meetingdetachable")),0);
int subcompanyid=-1;
String SelectSubCompany = "";
//分权模式下参数传过来的选中的分部
int subid=Util.getIntValue(request.getParameter("subCompanyId"));
SelectSubCompany=Util.null2String(request.getParameter("SelectSubCompany"));
if("".equals(SelectSubCompany) && subid > 0){
	SelectSubCompany = ""+subid;
}
if(subid<0){
        subid=user.getUserSubCompany1();
}
if(subid>0){
	subcompanyid=subid;
}
ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"MeetingRoomAdd:Add");
int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"MeetingRoomAdd:Add",subid);

if(detachable==1){
	
	if(subid!=0 && operatelevel<1){
		canedit=false;
	}else{
		canedit=true;
	}
	subcompanyid = subid;
	//SelectSubCompany = ""+subid;
}else{
	if(HrmUserVarify.checkUserRight("MeetingRoomAdd:Add",user)) {
	canedit=true;
   }
}

String subcompanyspan = "";
	if(!SelectSubCompany.equals("")){
ArrayList SelectSubCompanys = Util.TokenizerString(SelectSubCompany,",");
SelectSubCompany = "";
for(int i=0;i<SelectSubCompanys.size();i++){
	//subcompanyspan += "<a href=\'javascript:void(0)\' onclick=\'openFullWindowForXtable(\"/hrm/company/HrmSubCompanyDsp.jsp?id="+SelectSubCompanys.get(i) +"\")\'>"+SubCompanyComInfo.getSubCompanyname(""+SelectSubCompanys.get(i))+"</a>&nbsp;";
	SelectSubCompany +=","+SelectSubCompanys.get(i);
	subcompanyspan += SubCompanyComInfo.getSubCompanyname(""+SelectSubCompanys.get(i))+",";
 }
 if(subcompanyspan.length() > 1) {
	 SelectSubCompany = SelectSubCompany.substring(1);
 	 subcompanyspan = subcompanyspan.substring(0, subcompanyspan.length() - 1);
 }
}

String SelectSubCompanySql=SelectSubCompany;

//顶部选择
String status=Util.null2String(request.getParameter("statuss"));
if("".equals(status)){
	status = "1";
}
//查询条件
String roomname=Util.null2String(request.getParameter("roomnames"));

String hrmid=Util.null2String(request.getParameter("hrmids"));
String roomdesc=Util.null2String(request.getParameter("roomdescs"));
String equipment=Util.null2String(request.getParameter("equipments"));

String sqlwhere = "";
if(!"".equals(roomname)) sqlwhere += "and name like '%" +  roomname + "%' ";
if(!"".equals(SelectSubCompanySql) && !"-1".equals(SelectSubCompanySql)) sqlwhere += "and subcompanyid in (" +  SelectSubCompanySql + ") ";
if(!"".equals(hrmid)){
	String sqllike="";
	if(hrmid.startsWith(",")){
		hrmid=hrmid.substring(1);
	}
	if(hrmid.endsWith(",")){
		hrmid=hrmid.substring(0,hrmid.length()-1);
	}
	String[] arr=hrmid.split(",");
	for(int i=0;i<arr.length;i++){
		if(!"".equals(sqllike)){
			sqllike+=" or ";
		}
		sqllike+="hrmids='"+arr[i]+"' or hrmids like '%"+arr[i]+",%' or hrmids like '%,"+arr[i]+"' or hrmids like '%,"+arr[i]+",%'";
		
	}
	if(!"".equals(sqllike)){
		sqlwhere += "and ("+sqllike+") ";
	}
} 
if(!"".equals(status)&&!"0".equals(status)){
	if("1".equals(status)){
		sqlwhere += "and (status = '" +  status + "' or status is null or status = '') ";
	} else {
		sqlwhere += "and status = '" +  status + "' ";
	}
	
}
if(!"".equals(roomdesc)) sqlwhere += "and roomdesc like '%" +  roomdesc + "%' ";
if(!"".equals(equipment)) sqlwhere += "and equipment like '%" +  equipment + "%' ";
%>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(780,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY >
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%


RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:add(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!"2".equals(status)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+",javascript:lockRoom(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(!"1".equals(status)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+",javascript:reOpenRoom(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:delRoom(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
		
			
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" class="e8_btn_top middle" onclick="add()"/>
			<%if(!"2".equals(status)) {%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(22151,user.getLanguage()) %>" class="e8_btn_top middle" onclick="lockRoom()"/>
			<%}
			if(!"1".equals(status)) {%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(22152,user.getLanguage()) %>" class="e8_btn_top middle" onclick="reOpenRoom()"/>
			<%} %>
			
		
			<input type="text" class="searchInput" id="t_roomname" name="t_roomname" value=""  />
			
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span class="toggleLeft" id="toggleLeft" onclick="toggleLeft()" title="<%=SystemEnv.getHtmlLabelName(18890,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(19652,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(17871,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(26505,user.getLanguage()) %></span>
		<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span id="ALL" val="0" onclick="clickTab(this)" class="tabClass <%=("0".equals(status) || "".equals(status))?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>
			<span id="normal" val="1" onclick="clickTab(this)" class="tabClass <%=("1".equals(status))?"selectedTitle":"" %>"><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></span>
			<span id="locked" val="2" onclick="clickTab(this)" class="tabClass <%=("2".equals(status))?"selectedTitle":"" %>"><%=SystemEnv.getHtmlLabelName(22205,user.getLanguage())%></span>
	</span>
</div>

<div class="advancedSearchDiv" id="advancedSearchDiv">

<FORM id=weaverA name=weaverA action="MeetingRoom_left.jsp" method=post  >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>' >
			<!-- 会议室名称 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item>
				<input type='text' class=inputstyle id="roomnames" name="roomnames"  style="width:60%" value="<%if(!roomname.equals("")){%><%=Util.forHtml(roomname)%><%}%>">
			</wea:item>
			<!-- 所属机构 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
            <wea:item>
               
 
                	<brow:browser viewType="0" name="SelectSubCompany" browserValue='<%=SelectSubCompany%>' 
					browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?show_virtual_org=-1&selectedids=" 
					hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="200px"
					completeUrl="/data.jsp?type=164&show_virtual_org=-1" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
					browserSpanValue='<%=subcompanyspan %>'></brow:browser>
	

            </wea:item>

             <!-- 负责人员 -->
            <wea:item><%=SystemEnv.getHtmlLabelName(2156,user.getLanguage())%></wea:item>
            <wea:item>
            	<%
            	   String hrmidspan = "";
            	   if(!hrmid.equals("")){
			  	ArrayList hrmids = Util.TokenizerString(hrmid,",");
			  	for(int i=0;i<hrmids.size();i++){
            
			  	//hrmidspan +="<a href=\'javascript:openhrm("+ hrmids.get(i)+")\' onclick=\'pointerXY(event)\'>"+ResourceComInfo.getResourcename(""+hrmids.get(i))+"</a>&nbsp";
			  	hrmidspan +=ResourceComInfo.getResourcename(""+hrmids.get(i))+",";
                  }
                  if(hrmidspan.length() > 1) {
                  	hrmidspan = hrmidspan.substring(0, hrmidspan.length() - 1);
                  }
                  }%>
                  <brow:browser viewType="0" name="hrmids" browserValue='<%=hrmid%>' 
			  	browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
			  	hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="200px"
			  	completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
			  	browserSpanValue='<%= hrmidspan %>'></brow:browser>
			  	<!-- 
                  <button class="Browser" onclick="onShowHrmResource('hrmidspan','hrmids', 1, 0 )" type="button"></button>
			  	<input class=inputstyle type="hidden" id="hrmids" name="hrmids" value="<%=hrmid%>"/>
			  	<span id="hrmidspan" name="hrmidspan"><%= hrmidspan %></span>
			  	 -->
		    </wea:item>
		  
			<!-- 状态 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(25005,user.getLanguage())%></wea:item>
			<wea:item>
				<SPAN id=hrmidspan></SPAN>
				<select class=inputstyle size="1" name="statuss" id="statuss" style="width:100px;">
					<option value="0" <%=("0".equals(status) || "".equals(status))?"selected":"" %>></option>
					<option value="1" <%=("1".equals(status))?"selected":"" %>><%=SystemEnv.getHtmlLabelName(225, user.getLanguage())%></option>
					<option value="2" <%=("2".equals(status))?"selected":"" %>><%=SystemEnv.getHtmlLabelName(22205, user.getLanguage())%></option>
				</select>
			</wea:item>
       
			<!-- 会议室描述 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
			<wea:item>
				<input type='text' class=inputstyle name="roomdescs" id="roomdescs"  style="width:60%" value="<%if(!roomdesc.equals("")){%><%=Util.forHtml(roomdesc)%><%}%>">
				<INPUT class=inputstyle id=subCompanyId type=hidden name=subCompanyId value="<%=subcompanyid%>">
				<INPUT class=inputstyle id=subid type=hidden name=subid value="<%=subid%>">
			</wea:item>
			<!-- 会议室设备 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1326,user.getLanguage())%></wea:item>
			<wea:item>
				<input type='text' class=inputstyle name="equipments"  style="width:60%" value="<%=equipment %>">
			</wea:item>
		</wea:group>
		<wea:group context="">
	    	<wea:item type="toolbar">
				<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtionAVS();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	    	</wea:item>
	    </wea:group>
	</wea:layout>

</FORM>
</div>

	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.MT_MeetingRoom%>"/>
<%String orderby =" dsporder, name ";
String tableString = "";
int perpage=10;
                        
String backfields = " id,name,hrmids,roomdesc,subcompanyid, equipment , status, dsporder ";
String fromSql  = " MeetingRoom ";
tableString =   " <table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.MT_MeetingRoom,user.getUID())+"\" >"+
		        " <checkboxpopedom  id=\"checkbox\" popedompara=\"column:subcompanyid+"+user.getUID()+"+"+detachable+"\" showmethod=\"weaver.meeting.Maint.MeetingTransMethod.getRoomCheckbox\"  />"+
   				"       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\"  sqlwhere=\""+(sqlwhere.length() > 3?Util.toHtmlForSplitPage(sqlwhere.substring(3)):"")+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(780,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" otherpara=\"column:id+onEdit\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getClickMethod\"/>"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(2156, user.getLanguage())+"\" column=\"hrmids\" orderkey=\"hrmids\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingMultResource\" />"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(780,user.getLanguage())+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"roomdesc\" orderkey=\"roomdesc\"  />"+
                "           <col width=\"14%\"  text=\""+SystemEnv.getHtmlLabelName(17868, user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingSubCompany\" />"+
                "			<col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(780,user.getLanguage())+SystemEnv.getHtmlLabelName(1326,user.getLanguage())+"\" column=\"equipment\" orderkey=\"equipment\" />"+
                "			<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(25005,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getRoomStatus\" />"+
                "			<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dsporder\" orderkey=\"dsporder\" />"+
                "       </head>";
 
tableString +=  "		<operates>"+
                "		<popedom column=\"id\" otherpara=\"column:status+column:subcompanyid+"+user.getUID()+"+"+detachable+"\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.checkRoomOperate\"></popedom> "+
                "		<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		<operate href=\"javascript:onLock();\" text=\""+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
				"		<operate href=\"javascript:onReOpen();\" text=\""+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+"\" target=\"_self\" index=\"3\"/>"+
				"		<operate href=\"javascript:onShare();\" text=\""+SystemEnv.getHtmlLabelName(19910,user.getLanguage())+"\" target=\"_self\" index=\"4\"/>"+
				"		</operates>";
                 
tableString +=  " </table>";
%>

            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />

</body>
</html>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript">
var diag_vote;

function tableReload(){
	_table. reLoad();
}

function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	doSearchsubmit();
}

function clickTab(obj){
	jQuery("#statuss").val(jQuery(obj).attr("val"));
	jQuery("#statuss").trigger("change");
	doSearchsubmit();
}

function doSearchsubmit(){
	$('#weaverA').submit();
}

//删除
function onDel(id){
    
	delRoom(id);
}

function delRoom(id){
	var ids = "";
	if(id==null ||id=="" || id == "NULL" || id == "Null" || id == "null"){
		$("input[name='chkInTableTag']").each(function(){
			if($(this).attr("checked"))			
				ids = ids +$(this).attr("checkboxId")+",";
		});
	} else {
		ids = id+",";
	}
	if(ids=="") { 
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(32855, user.getLanguage())%>!") ;
	} else {
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32856, user.getLanguage())%>？", function (){
					doDeleteRoom(ids);	
			});
	}
}

function doDeleteRoom(ids){
	$.post("/meeting/Maint/MeetingRoomCheck.jsp",{checkType:"delete",ids:ids},function(datas){
		var dataObj=null;
		if(datas != ''){
			dataObj=eval("("+datas+")");
		}
		if(wuiUtil.getJsonValueByIndex(dataObj, 0) == "0"){
			$.post("/meeting/Maint/MeetingRoomOperation.jsp",{method:"delete",ids:ids,subid:"<%=subid%>"},function(datas){
				doSearchsubmit();
			});
		} else {
		
			Dialog.alert(wuiUtil.getJsonValueByIndex(dataObj, 1)) ;
		}
	});
}

function onEdit(id){
   	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	};
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.checkDataChange = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(780,user.getLanguage())%>";
	diag_vote.URL = "/meeting/Maint/MeetingRoomEditTab.jsp?dialog=1&id="+id+"&method=edit";
	diag_vote.show();
}

//封存
function onLock(id){
	lockRoom(id);
}

function lockRoom(id){
	var ids = "";
	if(id==null ||id=="" || id == "NULL" || id == "Null" || id == "null"){
		$("input[name='chkInTableTag']").each(function(){
			if($(this).attr("checked"))			
				ids = ids +$(this).attr("checkboxId")+",";
		});
	}else {
		ids = id+",";
	}
	if(ids=="") { 
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(32855, user.getLanguage())%>!") ;
	} else {
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32857, user.getLanguage())%>？", function (){
					doLockRoom(ids);	
			});
	}
}

function doLockRoom(ids){
	$.post("/meeting/Maint/MeetingRoomOperation.jsp",{method:"lock",ids:ids,subid:"<%=subid%>"},function(datas){
		doSearchsubmit();
	});
}

//解封
function onReOpen(id){
	reOpenRoom(id);
}

function reOpenRoom(id){
	var ids = "";
	if(id==null ||id=="" || id == "NULL" || id == "Null" || id == "null"){
		$("input[name='chkInTableTag']").each(function(){
			if($(this).attr("checked"))			
				ids = ids +$(this).attr("checkboxId")+",";
		});
	} else {
		ids = id+",";
	}
	if(ids=="") { 
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(32855, user.getLanguage())%>!") ;
	} else {
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32858, user.getLanguage())%>？", function (){
			doReOpenRoom(ids);	
		});
	}
}

function doReOpenRoom(ids){
	$.post("/meeting/Maint/MeetingRoomOperation.jsp",{method:"reOpen",ids:ids,subid:"<%=subid%>"},function(datas){
		doSearchsubmit();
	});
}

function onShare(id){
    if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.checkDataChange = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(780,user.getLanguage())%>";
	diag_vote.URL = "/meeting/Maint/MeetingRoomEditTab.jsp?dialog=1&id="+id+"&subCompanyId=<%=subid%>&method=shangeShare";
	diag_vote.show();
}

function add(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 400;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(780,user.getLanguage())%>";
	diag_vote.URL = "/meeting/Maint/MeetingRoomAddTab.jsp?dialog=1&subCompanyId="+<%=subid%>;
	diag_vote.show();
}


function resetCondtion(){
	jQuery("#roomnames").val("");
	<%if(detachable==1){%>
	jQuery("#subCompanyId").val("");
	jQuery("#SelectSubCompany").val("");
	jQuery("#subcompanyspan").html("");
	<%}%>
	jQuery("#hrmids").val("");
	jQuery("#hrmidspan").html("");
	jQuery("#statuss").val("0");
	jQuery("#statuss").trigger("change");
	jQuery("#roomdescs").val("");
	jQuery("#equipments").val("");
	$("#statuss").selectbox('detach');
	$("#statuss").selectbox('attach');
	
}

function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}

function tabSelectChg(){
		jQuery(".hoverBtnSpan").find("SPAN").each(function(){
			jQuery(this).removeClass("selectedTitle");
		});
    	jQuery(".hoverBtnSpan SPAN[val='<%=status%>']").addClass("selectedTitle");
}

//$(".searchImg").bind("click",function(){
//     onBtnSearchClick();
//});

function onBtnSearchClick(){
	var name=$("input[name='t_roomname']",parent.document).val();
	$("input[name='roomnames']").val(name);
	doSearchsubmit();
}

function toggleLeft(){
	var f = window.parent.document.getElementById("oTd1").style.display;

	if (f != null) {
		if (f==''){
			window.parent.document.getElementById("oTd1").style.display='none'; 
		}else{ 
			window.parent.document.getElementById("oTd1").style.display=''; 
		}
	}
}

jQuery(document).ready(function(){
	jQuery("li.current",parent.document).removeClass("current");
	if(jQuery("#statuss").val()=="0"){
		jQuery("#ALLli",parent.document).addClass("current");
	}else if(jQuery("#statuss").val()=="1"){
		jQuery("#normalli",parent.document).addClass("current");
	}else if(jQuery("#statuss").val()=="2"){
		jQuery("#lockedli",parent.document).addClass("current");
	}
});
</script>
