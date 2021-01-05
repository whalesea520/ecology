
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
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

	//String mid = Util.null2String(request.getParameter("mid"));
	//String from = Util.null2String(request.getParameter("from"));
	String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	int detachable = Util.getIntValue(String.valueOf(session
			.getAttribute("meetingdetachable")), 0);
	int subcompanyid = -1;
	//分权模式下参数传过来的选中的分部
	int subid = Util.getIntValue(request.getParameter("subCompanyId"));
	if (subid < 0) {
		subid = user.getUserSubCompany1();
	}
	ArrayList subcompanylist = SubCompanyComInfo.getRightSubCompany(
			user.getUID(), "MeetingRoomAdd:Add");
	int operatelevel = CheckSubCompanyRight
			.ChkComRightByUserRightCompanyId(user.getUID(),
					"MeetingRoomAdd:Add", subid);
	if (detachable == 1) {
		if (subid != 0 && operatelevel < 1) {
			subid=0;
		}
		subcompanyid = subid;
	} else {
		subcompanyid = subid;
	}
	if (HrmUserVarify.checkUserRight("MeetingRoomAdd:Add", user)) {
		canedit = true;
	}
	if (!canedit) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String images = Util.null2String(request.getParameter("image"));
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
		<!-- 图片浏览处理库 -->
		<script type="text/javascript" src="/js/meeting/drageasy.js"></script>
		<script type="text/javascript" src="/js/meeting/bootstrap.js"></script>
		<script type="text/javascript" src="/social/im/js/IMUtil_wev8.js"></script>
		<script type="text/javascript" src="/js/meeting/imcarousel.js"></script>
		
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
			
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
					+ ",javascript:saveData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			
			RCMenu += "{" + SystemEnv.getHtmlLabelName(32159, user.getLanguage())
					+ ",javascript:submitData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			
			RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage())
					+ ",javascript:btn_cancle(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
			   <td>
				</td>
				<td class="rightSearchSpan" style="text-align:right; ">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="saveData()">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159, user.getLanguage())%>"
						 class="e8_btn_top middle"
						onclick="submitData()">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv" >
			<span id="hoverBtnSpan" class="hoverBtnSpan">
					<span></span>
			</span>
		</div>
		<div class="advancedSearchDiv" id="advancedSearchDiv">
		</div>
		<%
		if ("1".equals(dialog)) {
		%>
		<div class="zDialog_div_content">
			<%
				}
			%>
			<FORM id=weaverA name=weaverA action="MeetingRoomOperation.jsp"
				method="post">
				<input type="hidden" value="false" name="hasChanged"
					id="hasChanged" />
				<input class="InputStyle" type="hidden" name="method" id="method"
					value="add" />
				<input type="hidden" value="<%=dialog%>" name="dialog"
					id="dialog" />
				<input type="hidden" value="" name="forwd" id="forwd" />
				<INPUT class="InputStyle" id=subid type=hidden name=subid
					value="<%=subid%>" />
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
						<!-- 会议室名称 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(780, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item>
						<wea:item>
							<input class="InputStyle" id="roomname" name="roomname"
								style="width: 250px" onblur="onblurCheckName()"
								onchange='checkinput("roomname","nameimage")' value=""><SPAN id=nameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN><SPAN id=checknameinfo style='color: red;'>&nbsp;</SPAN>
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
							<brow:browser viewType="0" name="hrmids" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="250px"
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue=""></brow:browser>
						</wea:item>
						<!-- 状态 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(25005, user.getLanguage())%></wea:item>
						<wea:item>
							<select class="InputStyle" size="1" name="status" style="width:80px;"
								id="status">
								<option value="1" selected><%=SystemEnv.getHtmlLabelName(225, user.getLanguage())%></option>
								<option value="2"><%=SystemEnv.getHtmlLabelName(22151, user.getLanguage())%></option>
							</select>
						</wea:item>
						<!-- 会议室描述 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(780, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(433, user.getLanguage())%></wea:item>
						<wea:item>
							<input class="InputStyle" name="roomdesc" id="roomdesc" size="100" style="width: 250px" value="">
						</wea:item>
						<!-- 显示顺序 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(15513, user.getLanguage())%></wea:item>
						<wea:item>
							<input class="InputStyle" type="text" size="10"
								maxlength=6 id='dsporder' name="dsporder" value="1"
								onKeyPress="ItemNum_KeyPress(this.name)"
								onchange="setChange()"
								onblur="checknumber('dsporder');checkDigit('dsporder',4,1)"
								style="text-align: right;width:80px;" />
						</wea:item>
						<!-- 会议室设备 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(780, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(1326, user.getLanguage())%></wea:item>
						<wea:item>
							<span  style="height:23;display:inline-block;float:none;"><input id="temp_device" class="InputStyle" style="width:250px;vertical-align: text-bottom;" placeholder="<%=SystemEnv.getHtmlLabelName(128634, user.getLanguage())%>"  value="<%=SystemEnv.getHtmlLabelName(128634, user.getLanguage())%>" onfocus="javascript:if(this.value=='<%=SystemEnv.getHtmlLabelName(128634, user.getLanguage())%>')this.value='';"  onblur="if(this.value==''){this.value='<%=SystemEnv.getHtmlLabelName(128634, user.getLanguage())%>'}"><a class="add_btn" href="javascript:void(0);" style="" title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(780, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(1326, user.getLanguage())%>" onclick="addDevice('temp_device','show_device','equipments',1000,'<%=SystemEnv.getHtmlLabelName(1326, user.getLanguage())%>')">&nbsp;+&nbsp;</a></span><br>
							<span>
								<span id="show_device">
								</span>
							</span>
							<input type="hidden" id="equipment" name="equipment"/>
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
			<%
				if ("1".equals(dialog)) {
			%>
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
							id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<%
		}
		%>
	</body>
</html>

<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript">

if(jQuery("#uploadDiv").length>0){
  	bindUploaderDiv(jQuery("#uploadDiv"),"images"); 
  }
  
if("<%=dialog%>"=="1"){
	var bodyheight = document.body.offsetHeight;
	var bottomheight = $(".zDialog_div_bottom").css("height");
	if(bottomheight.indexOf("px")>0){
		bottomheight = bottomheight.substring(0,bottomheight.indexOf("px"));
	}
	if(isNaN(bottomheight)){
		bottomheight = 0;
	}
	$(".zDialog_div_content").css("height",bodyheight-bottomheight);
	var dialog = parent.parent.getDialog(window.parent);
	var parentWin = parent.parent.getParentWindow(window.parent);
	function btn_cancle(){
		//parentWin.closeDialog();
		dialog.closeByHand();
	}
}

if("<%=isclose%>"=="1"){
	var dialog = parent.parent.getDialog(window.parent);
	var parentWin = parent.parent.getParentWindow(window.parent);
	parentWin.location="/meeting/Maint/MeetingRoom_left.jsp?subCompanyId=<%=subid%>";
	parentWin.closeDlgARfsh();
	
}
function setChange(){
	jQuery("hasChanged").value="true";
}
function onblurCheckName() {
	var roomname = $("#roomname").val();
	if(roomname==null ||roomname=="" || roomname == "NULL" || roomname == "Null" || roomname == "null"){
		$("#checknameinfo").hide();
		return;
	}	
	$.post("/meeting/Maint/MeetingRoomCheck.jsp",{roomname:encodeURIComponent($("#roomname").val())},function(datas){ 							 
		if (datas.indexOf("exist") > 0){
			$("#checknameinfo").show();						 	
			$("#checknameinfo").text(" <%=SystemEnv.getHtmlLabelName(780, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%> [ "+roomname+" ] <%=SystemEnv.getHtmlLabelName(24943, user.getLanguage())%>");
		} else { 
			$("#checknameinfo").hide();
		}
	});
		
}
var issubmit=false;
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
	if(!issubmit){
	issubmit=true;
	$.post("/meeting/Maint/MeetingRoomCheck.jsp",{roomname:encodeURIComponent($("#roomname").val())},function(datas){ 							 
		if (datas.indexOf("exist") > 0){
		    if(window.top.Dialog){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(780, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%> [ "+roomname+" ] <%=SystemEnv.getHtmlLabelName(24943, user.getLanguage())%>!") ;
			} else {
				Dialog.alert("<%=SystemEnv.getHtmlLabelName(780, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%> [ "+roomname+" ] <%=SystemEnv.getHtmlLabelName(24943, user.getLanguage())%>!") ;
			}
			issubmit=false;
			
		} else { 
			$('#weaverA').submit();
			
		}
	});
	}
}
function submitData(){
	$('#forwd').val("edit");
	doSave();
}
function saveData(){
	$('#forwd').val("add");
	doSave();
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
	function bindFun(){
		$(".delimg").hover(function(){
	  		$(this).find(".imgshow").show();
	  	},
	  	function(){
	  		$(this).find(".imgshow").hide();
	  	});
	}
</script>
