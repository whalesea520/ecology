
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/meeting/uploader.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo"
	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight"
	class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
	<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="MeetingSetInfo"	class="weaver.meeting.Maint.MeetingSetInfo" scope="page" />
<%
	boolean canedit = false;
	String id = Util.null2String(request.getParameter("id"));
	String method = Util.null2String(request.getParameter("method"));
	String from = Util.null2String(request.getParameter("from"));
	String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	int detachable = Util.getIntValue(String.valueOf(session
			.getAttribute("meetingdetachable")), 0);
	int subcompanyid = -1;
	 
			
	RecordSet
			.executeSql("select id, name,subcompanyid,hrmids,roomdesc,equipment,status,dsporder,images from MeetingRoom where id = "
					+ id);

	String hrmids = "";

	String roomname = "";
	String status = "1";
	String roomdesc = "";
	String dsporder = "0";
	String equipment = "";
	String images="";
	if (RecordSet.next()) {
		hrmids = Util.null2String(RecordSet.getString("hrmids"));
		subcompanyid = RecordSet.getInt("subcompanyid");
		roomname = Util.null2String(RecordSet.getString("name"));
		status = Util.null2String(RecordSet.getString("status"));
		status = (status == null || status.equals("")) ? "1"
				: status;
		roomdesc = Util
				.null2String(RecordSet.getString("roomdesc"));
		dsporder = Util.getPointValue3(RecordSet
				.getString("dsporder"), 1, "0");
		equipment = Util.null2String(RecordSet
				.getString("equipment"));
		images = Util.null2String(RecordSet
				.getString("images"));
	}
		 
	int reloadTb = Util.getIntValue(request.getParameter("reloadTb"));
	//分权模式下参数传过来的选中的分部
	int subid = subcompanyid;
	if (subid < 0) {
		subid = user.getUserSubCompany1();
	}
	ArrayList subcompanylist = SubCompanyComInfo.getRightSubCompany(
			user.getUID(), "MeetingRoomAdd:Add");
	int operatelevel = CheckSubCompanyRight
			.ChkComRightByUserRightCompanyId(user.getUID(),
					"MeetingRoomAdd:Add", subid);
	boolean onlyRead=false;
	if (detachable == 1) {
		if (subid != 0 && operatelevel < 0) {
			subid=0;
		} else {
            if(operatelevel==0){//只读
            	onlyRead=true;
			}
			subcompanyid = subid;
			canedit=true;
		}
	}else{
		subcompanyid = subid;
		if (HrmUserVarify.checkUserRight("MeetingRoomAdd:Add", user)) {
			canedit = true;
		}
	}
	
	if (!canedit) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String mainId = "";
	String subId = "";
	String secId = "";
	if(!MeetingSetInfo.getMtngAttchCtgry().equals("")){//如果设置了目录，则取值
		String[] categoryArr = Util.TokenizerString2(MeetingSetInfo.getMtngAttchCtgry(),",");
		mainId = categoryArr[0];
		subId = categoryArr[1];
		secId = categoryArr[2];
	}
	String maxsize="";
	if(!secId.equals(""))
	{
		rs.executeSql("select maxUploadFileSize from DocSecCategory where id="+secId);
		rs.next();
	    maxsize = Util.null2String(rs.getString(1));
	}
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<LINK href="/js/ecology8/meeting/meetingbase_wev8.css" type=text/css rel=STYLESHEET>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css"
			type="text/css" />
		<link rel="stylesheet"
			href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css"
			type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<style>
			.delimg{float:right;z-index:2;left:88px;bottom:68px;width:20px;height:20px;position:absolute;cursor: pointer;}
			.imgdiv{float:left;margin:5px;width:100px;height:80px;position:relative}
			.imgcontent{position:absolute;width:100px;height:80px;z-index:1;cursor: pointer;}
			.img{width:100px;max-height:80px}
			.imgshow{display:none}
		</style>
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(780, user
				.getLanguage());
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY style="overflow: hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		if(!onlyRead){//非只读
			if ("edit".equals(method) || "".equals(method)) {
				RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
						+ ",javascript:save(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javascript:delRoom("+id +"),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			} else {
				RCMenu += "{" + SystemEnv.getHtmlLabelName(611, user.getLanguage())
						+ ",javascript:add(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(32136, user.getLanguage())+",javascript:delRoomPrm(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			}
		}
			RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage())
					+ ",javascript:closePrtDlgARfsh(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan"
					style="text-align: right; width: 400px !important">
					<%
					if(!onlyRead){//非只读
						if ("edit".equals(method) || "".equals(method)) {	
					%>
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="save()" />
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="delRoom(<%=id %>)" />
					<%
						} else {
					%>
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="add()" />
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(32136, user
							.getLanguage())%>" 
						class="e8_btn_top middle" onclick="delRoomPrm()" />
					<%
						}
					}
					%>
					<span
						title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"  class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv">
			<span style="width:10px"></span>
			<span id="hoverBtnSpan" class="hoverBtnSpan"> <span
				id="edit" onclick="location='/meeting/Maint/MeetingRoomEdit.jsp?dialog=1&id=<%=id %>&method=edit&from=<%=from %>'"
				class=" <%=("edit".equals(method) || "".equals(method)) ? "selectedTitle"
				: ""%>"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></span>
				<span id="shangeShare" onclick="location='/meeting/Maint/MeetingRoomEdit.jsp?dialog=1&id=<%=id %>&method=shangeShare&from=<%=from %>'"
				class=" <%=("shangeShare".equals(method)) ? "selectedTitle"
		: ""%>"><%=SystemEnv.getHtmlLabelName(19910, user.getLanguage())%></span>
			</span>
		</div>
		<%
			if ("edit".equals(method) || "".equals(method)) {
		%>
		
		<div class="zDialog_div_content" id="editDiv" name="editDiv">
			<FORM id=weaverA name=weaverA action="MeetingRoomOperation.jsp"
				method=post>
				<input type="hidden" value="false" name="hasChanged"
					id="hasChanged">
				<input type="hidden" value="<%=id%>" name="mid"
					id="mid">
				<input class=inputstyle type="hidden" name="method" id="method"
					value="<%=method%>">
				<input type="hidden" value="" name="forwd" id="forwd" />
				<input type="hidden" value="<%=dialog%>" name="dialog"
					id="dialog">
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
						<!-- 会议室名称 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(780, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item>
						<wea:item>
							<input class="InputStyle" id="roomname" name="roomname" style="width: 250px" onblur="onblurCheckName()" onchange='checkinput("roomname","nameimage")' value="<%=roomname%>">
							<SPAN id=nameimage>
							<%if("".equals(roomname)) {%>
							<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
							<%} %>
							</SPAN><SPAN id=checknameinfo style='color: red;'>&nbsp;</SPAN>
						</wea:item>
						<!-- 所属机构 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(17868, user.getLanguage())%></wea:item>
						<wea:item>
							<%
							String subcompanyspan = "";
							if (subcompanyid > -1) {
								subcompanyspan = SubCompanyComInfo.getSubCompanyname("" + subcompanyid);
							} 
							%>
							<%
							if (detachable == 1) {
							%>
								
								<brow:browser viewType="0" name="subCompanyId" browserValue='<%=(subcompanyid > 0?(""+subcompanyid):"")%>'
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser4.jsp?rightStr=MeetingRoomAdd:Add" 
								hasInput="false"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="250px"
								completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
								browserSpanValue='<%=subcompanyspan %>'></brow:browser>
								
							<%
							} else {
							%>
								<brow:browser viewType="0" name="subCompanyId" browserValue='<%=(subcompanyid > 0?(""+subcompanyid):"")%>' 
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids=" 
								hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="250px"
								completeUrl="/data.jsp?type=164&show_virtual_org=-1" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
								browserSpanValue='<%=subcompanyspan %>'></brow:browser>
							<%
								}
							%>
						</wea:item>
						<!-- 负责人员 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(2156, user.getLanguage())%></wea:item>
						<wea:item>
							<%
								String hrmidspan = "";
								if (!hrmids.equals("")) {
									ArrayList hrms = Util.TokenizerString(hrmids,",");
									for(int i=0;i<hrms.size();i++){
										hrmidspan+= ResourceComInfo.getResourcename(""+hrms.get(i)) + ",";
									}
								}
							%>
							<brow:browser viewType="0" name="hrmids" browserValue='<%=hrmids%>' 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="250px"
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue='<%=hrmidspan%>'></brow:browser>
						</wea:item>
						<!-- 状态 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(25005, user.getLanguage())%></wea:item>
						<wea:item>
							<select class="InputStyle" style="width:80px;" size="1" name="status"id="status" onchange="setChange()">
								<option value="1" <%if("1".equals(status)){%> selected<%} %>><%=SystemEnv.getHtmlLabelName(225, user.getLanguage())%></option>
								<option value="2" <%if("2".equals(status)){%> selected<%} %>><%=SystemEnv.getHtmlLabelName(22151, user.getLanguage())%></option>
							</select>
						</wea:item>
						<!-- 会议室描述 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(780, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(433, user.getLanguage())%></wea:item>
						<wea:item>
							<input class="InputStyle" name="roomdesc" id="roomdesc" style="width:250px" value="<%=roomdesc%>" size="30" onchange="setChange()">
						</wea:item>
						<!-- 显示顺序 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(15513, user.getLanguage())%></wea:item>
						<wea:item>
							<input class="InputStyle" type="text" size=10
								maxlength=6 id='dsporder' name="dsporder"
								value="<%=dsporder%>"
								onKeyPress="ItemNum_KeyPress(this.name)"
								onchange="setChange()"
								onblur="checknumber('dsporder');checkDigit('dsporder',4,1)"
								style="text-align: right;width:80px;" />
						</wea:item>
						<!-- 会议室设备 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(780, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(1326, user.getLanguage())%></wea:item>
						<wea:item>
							<span style="height:23;display:inline-block;float:none;" ><input id="temp_device" class="InputStyle" style="width:250px;vertical-align:text-bottom;" placeholder="<%=SystemEnv.getHtmlLabelName(128634, user.getLanguage())%>"  value="<%=SystemEnv.getHtmlLabelName(128634, user.getLanguage())%>" onfocus="javascript:if(this.value=='<%=SystemEnv.getHtmlLabelName(128634, user.getLanguage())%>')this.value='';"  onblur="if(this.value==''){this.value='<%=SystemEnv.getHtmlLabelName(128634, user.getLanguage())%>'}"><a class="add_btn" href="javascript:void(0);" style="" title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(780, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(1326, user.getLanguage())%>" onclick="addDevice('temp_device','show_device','equipments',1000,'<%=SystemEnv.getHtmlLabelName(1326, user.getLanguage())%>')">&nbsp;+&nbsp;</a></span><br>
							<span>
								<span id="show_device">
								<%
								if(!"".equals(equipment.trim())){
									String[] equipments=equipment.split(",");
									for(int i=0;i<equipments.length;i++){
									%>	
										<span class="mp_showNameClass" name="equipments" val="<%=equipments[i] %>">&nbsp;<%=equipments[i] %><span class="mp_delClass" onclick="delsp(this,1);">&nbsp;x&nbsp;</span></span>
									<%
									}
								}
							 	%>
								</span>
							</span>
							<input type="hidden" id="equipment" name="equipment" value="<%=equipment%>"/>
						</wea:item>
												<!-- 会议室照片 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(780, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(15707, user.getLanguage())%></wea:item>
					 <wea:item>
				<TABLE class=viewForm width="100%">
         			<COLGROUP>
         			<COL width="60px">
					<COL width="">
			        <TBODY>
			          <TR>
			             <td class=field colspan=2 id="divImages" name="divImages">
			             
			             <%if(!"".equals(secId)){ %>
						    <div id="uploadDiv" mainId="-1" subId="-1" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
						<%}else{%>   
							<input type="hidden" value="<%=images%>" name="images" id="images">
							<font color=red>(<%=SystemEnv.getHtmlLabelName(20476,user.getLanguage())%>)</font>
						<%}%>
						<div id="preview" style="width:100%;height:auto"></div>
			    		</td>
			          </TR>
				     </TBODY>
				 </TABLE>
                    </wea:item>
					</wea:group>
				</wea:layout>
			</FORM>
		</div>
		<%
			} else {
		%>
		<div class="zDialog_div_content" id="shareDiv" name="shareDiv">
			<%
					String orderby = " id ";
					String tableString = "";
					int perpage = 10;
					String sqlwhere = " mid = " + id;
					String otherParaobj = "column:departmentid+column:subcompanyid+column:userid+column:roleid+column:rolelevel+"+user.getLanguage()+"+column:jobtitleid+column:joblevel+column:joblevelvalue";
					String otherParalvl = "column:deptlevel+column:deptlevelMax+column:sublevel+column:sublevelMax+column:seclevel+column:seclevelMax+column:roleseclevel+column:roleseclevelMax";
					//System.out.println("[" + sqlwhere + "]");
					String backfields = " id,mid,permissiontype,departmentid,deptlevel,subcompanyid,sublevel,seclevel,userid,seclevelMax,deptlevelMax,sublevelMax,roleid,rolelevel,roleseclevel,roleseclevelMax,jobtitleid,joblevel,joblevelvalue ";
					String fromSql = " MeetingRoom_share ";
					tableString = " <table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""
							+ perpage
							+ "\" >"
							+ " <checkboxpopedom  id=\"checkbox\" popedompara=\"1\" showmethod=\"weaver.meeting.Maint.MeetingTransMethod.getCheckbox\"  />"
							+ "       <sql backfields=\""
							+ backfields
							+ "\" sqlform=\""
							+ fromSql
							+ "\"  sqlwhere=\""
							+ Util.toHtmlForSplitPage(sqlwhere)
							+ "\"  sqlorderby=\""
							+ orderby
							+ "\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"
							+ "       <head>"
							+ "           <col width=\"30%\"  text=\""
							+ SystemEnv.getHtmlLabelName(21956, user.getLanguage())
							+ "\" column=\"permissiontype\" orderkey=\"permissiontype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingPermissiontype\" />"
							+ "           <col width=\"40%\"  text=\""
							+ SystemEnv.getHtmlLabelName(106, user.getLanguage())
							+ "\" column=\"permissiontype\" orderkey=\"permissiontype\" otherpara=\""
							+ otherParaobj
							+ "\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingPermissionObj\" />"
							+ "           <col width=\"20%\"  text=\""
							+ SystemEnv.getHtmlLabelName(683, user.getLanguage())
							+ "\" column=\"permissiontype\" orderkey=\"permissiontype\" otherpara=\""
							+ otherParalvl
							+ "\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingPermissionlevel\" />"
							+ "       </head>" ;
			if(!onlyRead){
				tableString+="	   <operates>"+
							 "		<popedom column=\"id\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.checkRoomPrmOperate\"></popedom> "+
							 "		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
							 "		</operates>";
			}
				tableString+=" </table>";

					//System.out.println(tableString);
			%>
			<input type="hidden" value="<%=id%>" name="mid"
					id="mid">
				<TABLE width="100%" cellspacing=0>
					<tr>
						<td valign="top">
							<wea:SplitPageTag tableString='<%=tableString%>' mode="run" />
						</td>
					</tr>
				</TABLE>
		</div>
		<%
			}
		%>
		<%
		if ("1".equals(dialog)) {
		%>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2col">
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button"
							value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
							id="zd_btn_cancle" class="zd_btn_cancle" onclick="closePrtDlgARfsh()">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<%
		}
		%>
		
	</body>
</html>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<!-- 图片浏览处理库 -->
<script type="text/javascript" src="/js/meeting/drageasy.js"></script>
<script type="text/javascript" src="/js/meeting/bootstrap.js"></script>
<script type="text/javascript" src="/social/im/js/IMUtil_wev8.js"></script>
<script type="text/javascript" src="/js/meeting/imcarousel.js"></script>
<script type="text/javascript">
var diag_vote;
var dlg;
if(window.top.Dialog){
	dlg = window.top.Dialog;
} else {
    dlg = Dialog;
}
//if(<%=dialog%>==1){
	//var bodyheight = document.body.offsetHeight;
	//$(".zDialog_div_content").css("height",bodyheight);
	//var dialog = parent.getDialog(window);
	//var parentWin = parent.getParentWindow(window);
	function btn_cancle(){
		window.parent.closeDialog();
	}
//}

//if("<%=isclose%>"==1){
	//var dialog = parent.getDialog(window);
	//var parentWin = parent.getParentWindow(window);
	//parentWin.location="/meeting/Maint/MeetingRoom_left.jsp?subCompanyId=<%=subcompanyid%>";
	//parentWin.closeDialog();	
//}

<%if(reloadTb == 1){%>
    try{
	var parentWin1 = parent.parent.getParentWindow(window.parent);
	parentWin1.tableReload();
	}catch(e){}
<%}%>

function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	jQuery("#hoverBtnSpan").hoverBtn();
};

function setChange(){
	jQuery("hasChanged").value="true";
}
function onblurCheckName() {
		var roomname = $("#roomname").val();
		if(roomname==null ||roomname=="" || roomname == "NULL" || roomname == "Null" || roomname == "null"){
			$("#checknameinfo").hide();
			return;
		}	
		$.post("/meeting/Maint/MeetingRoomCheck.jsp",{roomname:encodeURIComponent($("#roomname").val()),id:<%=id%>},function(datas){ 							 
			if (datas.indexOf("exist") > 0){
				$("#checknameinfo").show();						 	
				$("#checknameinfo").text(" <%=SystemEnv.getHtmlLabelName(780, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%> [ "+roomname+" ] <%=SystemEnv.getHtmlLabelName(24943, user.getLanguage())%>");
			} else { 
				$("#checknameinfo").hide();
			}
		});
		
}



function closeDialog(){
	diag_vote.close();
}

function delRoom(id){
	var ids = id+",";
	dlg.confirm("<%=SystemEnv.getHtmlLabelName(33601, user.getLanguage())%>", function (){
		doDeleteRoom(ids);	
	}, function () {}, 320, 90,false);
}

function doDeleteRoom(ids){
	$.post("/meeting/Maint/MeetingRoomCheck.jsp",{checkType:"delete",ids:ids},function(datas){
		var dataObj=null;
		if(datas != ''){
			dataObj=eval("("+datas+")");
		}
		if(wuiUtil.getJsonValueByIndex(dataObj, 0) == "0"){
			$.post("/meeting/Maint/MeetingRoomOperation.jsp",{method:"delete",ids:ids,subid:"<%=subid%>"},function(datas){
				//parentWin.location="/meeting/Maint/MeetingRoom_left.jsp?subCompanyId=<%=subcompanyid%>";
				//parentWin.closeDialog();
				window.parent.closeWinAFrsh();
			});
		} else {
		
			dlg.alert(wuiUtil.getJsonValueByIndex(dataObj, 1)) ;
		}
	});
}

function doSave(){
	//拼接设备
	var aa=$("span[name='equipments']");
	var eq="";
	for(var key=0;key<aa.size();key++){
		eq+=eq==""?$(aa[key]).attr("val"):","+$(aa[key]).attr("val");
	}
	$('#equipment').val(eq);
	if(!check_form(weaverA,'roomname,subCompanyId')){
			return;
	}
	var roomname = $("#roomname").val();
	if(roomname==null ||roomname=="" || roomname == "NULL" || roomname == "Null" || roomname == "null"){
		$("#checknameinfo").hide();
		return;
	}
	$.post("/meeting/Maint/MeetingRoomCheck.jsp",{roomname:encodeURIComponent($("#roomname").val()),id:<%=id%>},function(datas){ 							 
		if (datas.indexOf("exist") > 0){
		    if(window.top.Dialog){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(780, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%> [ "+roomname+" ] <%=SystemEnv.getHtmlLabelName(24943, user.getLanguage())%>!") ;
			} else {
				Dialog.alert("<%=SystemEnv.getHtmlLabelName(780, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%> [ "+roomname+" ] <%=SystemEnv.getHtmlLabelName(24943, user.getLanguage())%>!") ;
			}
			
		} else { 
			$('#weaverA').submit();
			
		}
	});
}
function save(){
	$('#forwd').val("add");
	doSave();
}


function add(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 500;
	diag_vote.Height = 400;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(19910, user.getLanguage())%>";
	diag_vote.URL = "/meeting/Maint/MeetingRoomPrmsnAddTab.jsp?dialog=1&mid=<%=id %>";
	diag_vote.show();
}

function onDel(id){
    
	delRoomPrm(id);
}

function delRoomPrm(id){
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
		dlg.alert('<%=SystemEnv.getHtmlLabelNames("18214,82752",user.getLanguage())%>!') ;
	} else {
		dlg.confirm("<%=SystemEnv.getHtmlLabelName(83432,user.getLanguage())%>", function (){
		doDeleteRoomPrm(ids);
		}, function () {}, 300, 90, true, null, null, null, null, null);
	}
}

function doDeleteRoomPrm(ids){
	$.post("/meeting/Maint/MeetingRoomOperation.jsp",{method:"prmDelete",ids:ids,mid:"<%=id%>"},function(datas){
		location='/meeting/Maint/MeetingRoomEdit.jsp?dialog=1&id=<%=id %>&method=shangeShare';
	});
}

//关闭会议室编辑页面并刷新列表
function closePrtDlgARfsh(){
	window.parent.closeWinAFrsh();
}
//关闭弹出窗并刷新本页面
function closeDlgARfsh(){
	diag_vote.close();
	//window.location='/meeting/Maint/MeetingRoomEdit.jsp?dialog=1&id=<%=id %>&method=shangeShare';
}
jQuery(document).ready(function(){
	resizeDialog();
});
if(jQuery("#uploadDiv").length>0){
	   bindUploaderDiv(jQuery("#uploadDiv"),"images"); 
	}
	     
	function showPreview(imgid){
	var ids=imgid.split(",");
	var imghtml="";
		for(var k=0;k<ids.length;k++){
			if(ids[k].length>0){
				imghtml+="<div id=imgid_"+ids[k]+" class='imgdiv'>"+
					"<div class='delimg' onclick=delImage("+ids[k]+")><div class='imgshow'><img style='width:20px;height:20px' src='/images/ecology9/meeting/x_wev8.png'></div></div>"+
					"<div class='imgcontent' onclick=showImg('"+imgid+"',"+k+")><img src='/weaver/weaver.file.FileDownload?fileid="+ids[k]+"' class='img' /></div></div>";
			}
		}
	$("#preview").html(imghtml);
	bindFun();
	}

	function delImage(imgid){
		var newval="";
		var imgval=$("input[name='images']").val();
		var ids=imgval.split(",");
		for(var k=0;k<ids.length;k++){
			if(ids[k].length>0&&ids[k]!=imgid){
				newval+=ids[k]+",";
			}
		}
		$("input[name='images']").val(newval);
		$("#imgid_"+imgid).hide();
	}

	function showImg(images,index){
		var imgPool=[];
		var imgids = images.split(",");
		for(var i=0;i<imgids.length;i++){
			if(imgids[i]!=""){
				imgPool.push("/weaver/weaver.file.FileDownload?fileid=" + imgids[i]);
			}
		}
		IMCarousel.showImgScanner4Pool(true, imgPool, index, null, window.top);
	}

	$(document).ready(function() {
		var imgval=$("input[name='images']").val("<%=images%>");
		showPreview("<%=images%>");
	});


	function bindFun(){
		$(".delimg").hover(function(){
	  		$(this).find(".imgshow").show();
	  	},
	  	function(){
	  		$(this).find(".imgshow").hide();
	  	});
	}
</script>
