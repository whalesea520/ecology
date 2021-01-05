
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo"
	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight"
	class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
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
		hrmids = RecordSet.getString("hrmids");
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
	String mainId = "";
	String subId = "";
	String secId = "";
	if(!MeetingSetInfo.getMtngAttchCtgry().equals("")){//如果设置了目录，则取值
		String[] categoryArr = Util.TokenizerString2(MeetingSetInfo.getMtngAttchCtgry(),",");
		mainId = categoryArr[0];
		subId = categoryArr[1];
		secId = categoryArr[2];
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
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<BODY style="overflow: hidden;">
		
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="meeting"/>
   <jsp:param name="navName" value="<%=roomname %>"/>
</jsp:include>		
		
		<div class="zDialog_div_content" id="editDiv" name="editDiv">
			<FORM id=weaverA name=weaverA action="MeetingRoomOperation.jsp"
				method=post>
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
						<!-- 会议室名称 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(780, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item>
						<wea:item><%=roomname%></wea:item>
						
						<!-- 所属机构 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(17868, user.getLanguage())%></wea:item>
						<wea:item>
							<%
							String subcompanyspan = "";
							if (subcompanyid > -1) {
								subcompanyspan = SubCompanyComInfo.getSubCompanyname("" + subcompanyid);
							} 
							%>
							<a target="_blank" href="/hrm/company/HrmSubCompanyDsp.jsp?id=<%=subcompanyid %>"><%=subcompanyspan %></a>
							 
						</wea:item>
						<!-- 负责人员 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(2156, user.getLanguage())%></wea:item>
						<wea:item>
							<%
								if(!"".equals(hrmids.trim())){
									String[] tmphrmids=hrmids.split(",");
									for(int i=0;i<tmphrmids.length;i++){
										String hrmidspan = ResourceComInfo.getResourcename(tmphrmids[i]);
									%>	
										<a href="javascript:openhrm(<%=tmphrmids[i] %>)"><%=hrmidspan %></a>
									<%
									}
								}
							%>
						</wea:item>
						<!-- 状态 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(25005, user.getLanguage())%></wea:item>
						<wea:item>
							<%if("1".equals(status)){
								out.print(SystemEnv.getHtmlLabelName(225, user.getLanguage()));
							}else{
								out.print(SystemEnv.getHtmlLabelName(22151, user.getLanguage()));
							}%>
						</wea:item>
						<!-- 会议室描述 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(780, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(433, user.getLanguage())%></wea:item>
						<wea:item>
							<%=roomdesc%>
						</wea:item>
						<!-- 显示顺序 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(15513, user.getLanguage())%></wea:item>
						<wea:item><%=dsporder%></wea:item>
						
						<!-- 会议室设备 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(780, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(1326, user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<span id="show_device">
								<%
								if(!"".equals(equipment.trim())){
									String[] equipments=equipment.split(",");
									for(int i=0;i<equipments.length;i++){
									%>	
										<span name="equipments" val="<%=equipments[i] %>">&nbsp;<%=equipments[i] %></span>
									<%
									}
								}
							 	%>
								</span>
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(780, user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(15707, user.getLanguage())%></wea:item>
					 <wea:item>
				<TABLE class=viewForm width="100%">
         			<COLGROUP>
         			<COL width="60px">
					<COL width="">
			        <TBODY>
			          <TR>
			             <td class=field colspan=2 id="divImages" name="divImages">
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
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 	
	</body>
</html>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript">
var diag_vote;
var dlg;
if(window.top.Dialog){
	dlg = window.top.Dialog;
} else {
    dlg = Dialog;
}

//关闭会议室编辑页面并刷新列表
function closePrtDlgARfsh(){
	dlg.close();
	 
}
//关闭弹出窗并刷新本页面
function closeDlgARfsh(){
	close();
}
jQuery(document).ready(function(){
	resizeDialog();
	var imgval=$("input[name='images']").val("<%=images%>");
	showPreview("<%=images%>");
});

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
	
</script>
