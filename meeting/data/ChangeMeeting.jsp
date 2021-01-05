<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="weaver.splitepage.transform.SptmForMeeting"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.meeting.defined.MeetingFieldManager"%>
<%@page import="weaver.meeting.util.html.HtmlUtil"%> 
<%@page import="org.json.JSONObject"%> 
<%@ page import="weaver.file.FileUpload" %>
<%@page import="java.net.URLEncoder" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" /> 
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<jsp:useBean id="MeetingFieldGroupComInfo" class="weaver.meeting.defined.MeetingFieldGroupComInfo" scope="page"/>
<%
FileUpload fu = new FileUpload(request);
String userid = ""+user.getUID();

char flag=Util.getSeparator() ;
String ProcPara = "";

String meetingid = Util.null2String(fu.getParameter("meetingid"));

RecordSet.executeProc("Meeting_SelectByID",meetingid);
RecordSet.next();
String meetingtype=RecordSet.getString("meetingtype");
String meetingname=RecordSet.getString("name");
String address=RecordSet.getString("address");
String begindate=RecordSet.getString("begindate");
String begintime=RecordSet.getString("begintime");
String enddate=RecordSet.getString("enddate");
String endtime=RecordSet.getString("endtime");

String caller=RecordSet.getString("caller");
String contacter=RecordSet.getString("contacter");
String creater=RecordSet.getString("creater");
String isdecision=RecordSet.getString("isdecision");
String meetingstatus=RecordSet.getString("meetingstatus");

//页面需要判断条件字段
int repeatType = Util.getIntValue(RecordSet.getString("repeatType"),0);

String allUser=MeetingShareUtil.getAllUser(user);
String f_weaver_belongto_userid=user.getUID()+"";
int userPrm=1;
if(MeetingShareUtil.containUser(allUser,caller)){
	userPrm = meetingSetInfo.getCallerPrm();
	if(userPrm != 3) userPrm = 3;
	if(!userid.equals(caller)){
		f_weaver_belongto_userid=caller;
	}
}else{
	if( MeetingShareUtil.containUser(allUser,contacter)){
		userPrm = meetingSetInfo.getContacterPrm();
	   	if(userPrm==3){
		   if(!userid.equals(contacter)){
			   f_weaver_belongto_userid=contacter;
		   }
   		}
	}
	
	if( MeetingShareUtil.containUser(allUser,creater)&&userPrm<3){
		if(userPrm < meetingSetInfo.getCreaterPrm()){
			userPrm = meetingSetInfo.getCreaterPrm();
		}
		if(userPrm==3){
			if(!userid.equals(creater)){
				f_weaver_belongto_userid=creater;
			}
		}
	}
}

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
boolean isnotstart=false;//会议未开始
//当前时间小于会议开始时间 即会议未开始
if((begindate+":"+begintime).compareTo(CurrentDate+":"+CurrentTime)>0&&!isdecision.equals("2") ) isnotstart=true;
boolean canedit=false;
if(("2".equals(meetingstatus) && isnotstart) && userPrm == 3 && repeatType == 0)
{
	canedit=true;
}

if(!canedit){
	response.sendRedirect("/notice/noright.jsp") ;
}
 
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language=javascript src="/js/weaverTable_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>

<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/meeting/meetingswfupload_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+Util.forHtml(meetingname);
String needfav ="1";
String needhelp ="";

int topicrows=0;
int servicerows=0;
String needcheck="";
%>
<BODY style="overflow-y:hidden">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

 
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:btn_cancle(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 400px !important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>" class="e8_btn_top middle" onclick="doSubmit(this)"/>
			<span
				title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"  class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv">
	<span style="width:10px"></span>
	<span id="hoverBtnSpan" class="hoverBtnSpan">
	</span>
</div>

<div class="zDialog_div_content" style="overflow:auto;">
<FORM id=weaver name=weaver action="/meeting/data/MeetingOperation.jsp" method=post>
<input class=inputstyle type="hidden" name="method" value="changeMeeting">
<input class=inputstyle type="hidden" name="meetingid" value="<%=meetingid%>">
<input class=inputstyle type="hidden" id="oldmembers" name="oldmembers" value="">
<input class=inputstyle type="hidden" name="topicrows" value="0">
<input class=inputstyle type="hidden" name="servicerows" value="0">
<INPUT type="hidden" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>">
<% if(repeatType == 0) {%>
<input  type="hidden" name="repeatType" id="repeatType" value="0">
<%} %>
<div id="nomalDiv">
<wea:layout type="2col">
<%
String editFileId=",5,6,17,18,19,20,21,22,29,30,31,32,33,";
//遍历分组
MeetingFieldManager hfm = new MeetingFieldManager(1);
rs.executeSql("select * from "+hfm.getBase_datatable()+" where id = " + meetingid);
rs.next();
List<String> groupList=hfm.getLsGroup();
List<String> fieldList=null;
for(String groupid:groupList){
	fieldList= hfm.getUseField(groupid);
	if(fieldList!=null&&fieldList.size()>0){	
%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldGroupComInfo.getLabel(groupid)), user.getLanguage()) %>' attributes="{'groupDisplay':''}">
	<%for(String fieldid:fieldList){
		if(repeatType > 0) {//周期会议
			if("0".equals(MeetingFieldComInfo.getIsrepeat(fieldid))) continue;
		}else{//非周期会议
			if("1".equals(MeetingFieldComInfo.getIsrepeat(fieldid))) continue;
		}
		if("0".equals(MeetingFieldComInfo.getIsused(fieldid))) continue;//没有启用,隐藏处理
		
		String fieldname = MeetingFieldComInfo.getFieldname(fieldid);
		String fielddbtype = MeetingFieldComInfo.getFielddbtype(fieldid);
		int fieldlabel = Util.getIntValue(MeetingFieldComInfo.getLabel(fieldid));
		int fieldhtmltype = Integer.parseInt(MeetingFieldComInfo.getFieldhtmltype(fieldid));
		int type = Integer.parseInt(MeetingFieldComInfo.getFieldType(fieldid));
		boolean issystem ="1".equals(MeetingFieldComInfo.getIssystem(fieldid))||"0".equals(MeetingFieldComInfo.getIssystem(fieldid));
		boolean ismand="1".equals(MeetingFieldComInfo.getIsmand(fieldid));
		String weekStr="";
		JSONObject cfg= hfm.getFieldConf(fieldid);
		String fieldValue = rs.getString(fieldname);
		
		String extendHtml="";	
		if("address".equalsIgnoreCase(fieldname)){//会议地点
			cfg.put("getBrowserUrlFn","CheckOnShowAddress"); 
			cfg.put("width","60%");
			extendHtml="<div class=\"FieldDiv\" id=\"selectRoomdivb\" name=\"selectRoomdivb\" style=\"margin-left:10px;margin-top: 3px;float:left;\">"+
							"<A href=\"javascript:showRoomsWithDate();\" style=\"color:blue;\">"+SystemEnv.getHtmlLabelName(2193,user.getLanguage())+"</A>"+
						"</div>";
			cfg.put("callback","addressCallBack");
		}else if("remindTypeNew".equalsIgnoreCase(fieldname)){//默认提醒方式
			cfg.put("callback","onRemindType");
		}
		
		//特殊处理字段,需要合并处理
		if("remindHoursBeforeStart".equalsIgnoreCase(fieldname)||"remindTimesBeforeStart".equalsIgnoreCase(fieldname)
				||"remindHoursBeforeEnd".equalsIgnoreCase(fieldname)||"remindTimesBeforeEnd".equalsIgnoreCase(fieldname)
				|"repeatweeks".equalsIgnoreCase(fieldname)||"rptWeekDays".equalsIgnoreCase(fieldname)
				||"repeatmonths".equalsIgnoreCase(fieldname)||"repeatmonthdays".equalsIgnoreCase(fieldname))
			continue;

		//提醒时间特殊处理			
		if("remindBeforeStart".equals(fieldname)){
	%>	
		<wea:item attributes="{'samePair':'remindtimetr'}">
		<%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>
		</wea:item> 
		<wea:item attributes="{'samePair':'remindtimetr'}">
			<div style="float:left;">
				<%=HtmlUtil.getHtmlElementString(fieldValue,cfg,user)%>
				&nbsp;&nbsp;<span><%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%></span>
				<%=HtmlUtil.getHtmlElementString(rs.getString("remindHoursBeforeStart"),hfm.getFieldConf("25"),user)%>
				<span><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></span>
				<%=HtmlUtil.getHtmlElementString(rs.getString("remindTimesBeforeStart"),hfm.getFieldConf("26"),user)%>
				<span><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></span>
			</div>
		</wea:item>	
	<%		
		}else if("remindBeforeEnd".equals(fieldname)){
	%>	
		<wea:item attributes="{'samePair':'remindtimetr'}">
		<%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>
		</wea:item> 
		<wea:item attributes="{'samePair':'remindtimetr'}">
			<div style="float:left;">
				<%=HtmlUtil.getHtmlElementString(fieldValue,cfg,user)%>
				&nbsp;&nbsp;<span><%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%></span>
				<%=HtmlUtil.getHtmlElementString(rs.getString("remindHoursBeforeEnd"),hfm.getFieldConf("27"),user)%>
				<span><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></span>
				<%=HtmlUtil.getHtmlElementString(rs.getString("remindTimesBeforeEnd"),hfm.getFieldConf("28"),user)%>
				<span><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></span>
			</div>
		</wea:item>	
	<%		
		}else if("remindImmediately".equalsIgnoreCase(fieldname)){
	%>	
		<wea:item attributes="{'samePair':'remindtimetr'}">
		<%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>
		</wea:item> 
		<wea:item attributes="{'samePair':'remindtimetr'}">
			<%=HtmlUtil.getHtmlElementString(fieldValue,cfg,user)%>
		</wea:item>	
	<%		 
		}else{
			//不可编辑字段,值做相应转化
			if(editFileId.indexOf(","+fieldid+",")>-1){
				if(!"address".equalsIgnoreCase(fieldname)&&!"customizeAddress".equalsIgnoreCase(fieldname)
						&&!"repeatdays".equalsIgnoreCase(fieldname)&&!"repeatweeks".equalsIgnoreCase(fieldname)&&!"rptWeekDays".equalsIgnoreCase(fieldname)
						&&!"repeatmonths".equalsIgnoreCase(fieldname)&&!"repeatmonthdays".equalsIgnoreCase(fieldname)){
					if(ismand){
						if(fieldhtmltype==6){
							needcheck+="".equals(needcheck)?"field"+fieldid:",field"+fieldid;
						}else{
							needcheck+="".equals(needcheck)?fieldname:","+fieldname;
						}
					}
				}
			}else{
				//转成html显示
				if(fieldhtmltype==4){//check框,变成disabled
					cfg.put("disabled","disabled");
					fieldValue=HtmlUtil.getHtmlElementString(fieldValue,cfg,user);
				}else if(fieldhtmltype==6){
					cfg.put("canDelAcc",false);//是否有删除按钮
					cfg.put("canupload",false);//是否可以上传
					cfg.put("candownload",true);//是否有下载按钮
					fieldValue=HtmlUtil.getHtmlElementString(fieldValue,cfg,user);
				}else if(fieldhtmltype==3){
					fieldValue=hfm.getHtmlBrowserFieldvalue(user,Integer.parseInt(fieldid),fieldhtmltype,type,fieldValue,fielddbtype,meetingid);
				}else{
					fieldValue=hfm.getFieldvalue(user, Integer.parseInt(fieldid), fieldhtmltype, type, fieldValue, 0,fielddbtype);
				}
			}
		%>		
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>
		</wea:item> 
		<wea:item>
			<%=editFileId.indexOf(","+fieldid+",")>-1?HtmlUtil.getHtmlElementString(fieldValue,cfg,user):fieldValue%>
			<%=extendHtml%>
		</wea:item>	
	<%	}
	}%>
</wea:group>
<%}
}%>	
	
</wea:layout>	
</div>
	 
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					 class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>

<script language="JavaScript" src="/js/addRowBg_wev8.js" >   </script>  
<script language=javascript>
 

function opendoc(showid,versionid,docImagefileid)
{
	openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&from=accessory&wpflag=workplan&meetingid=<%=meetingid%>");
}
function opendoc1(showid)
{
	openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isOpenFirstAss=1&wpflag=workplan&meetingid=<%=meetingid%>");
}


function doSubmit(obj){
	var thisvalue=jQuery("#repeatType").val();
	var begindate=thisvalue!=0?$('#repeatbegindate').val():$('#begindate').val();
	var enddate=thisvalue!=0?$('#repeatenddate').val():$('#enddate').val();
	var needcheck='<%=needcheck%>'

	if(check_form(document.weaver,needcheck)&&checkDateValidity(begindate,$('#begintime').val(),enddate,$('#endtime').val(),"<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>")){
			if(checkAddress()){
		        //当选择重复会议时，不做会议室和人员冲突校验
		        if(thisvalue != 0){
		        	submitact();
					return;
		        }
		        window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(128674,user.getLanguage())%>", function (){			
			        //会议室冲突校验
			        if(<%=meetingSetInfo.getRoomConflictChk()%> == 1 ){
						forbiddenPage();
			        	$.post("/meeting/data/AjaxMeetingOperation.jsp?method=chkRoom",{
			        		address:$GetEle("address").value,
			        		begindate:begindate,begintime:$('#begintime').val(),
	  						enddate:enddate,endtime:$('#endtime').val(),meetingid:'<%=meetingid%>'},
			        	function(datas){
							if(datas != 0){
								<%if(meetingSetInfo.getRoomConflict() == 1){ %>
									releasePage();
					            	window.top.Dialog.confirm(datas.trim()+"</br><%=SystemEnv.getHtmlLabelName(19095,user.getLanguage())%>", function (){
					                	submitChkMbr();
					            	});
					            <%} else if(meetingSetInfo.getRoomConflict() == 2) {%>
									releasePage();
					            	Dialog.alert(datas.trim()+"</br><%=SystemEnv.getHtmlLabelName(32875,user.getLanguage())%>。");
					            <%}%>
							} else {
								submitChkMbr();
							}
						});
			        	
			        } else {
			        	submitChkMbr();
			        }
		        });
			}
	}
}
//人员冲突校验
function submitChkMbr(){
	 if(<%=meetingSetInfo.getMemberConflictChk()%> == 1){
		forbiddenPage();
  		$.post("/meeting/data/AjaxMeetingOperation.jsp?method=chkMember",
  			{hrmids:$("#hrmmembers").val(),crmids:$("#crmmembers").val(),
  			begindate:$('#begindate').val(),begintime:$('#begintime').val(),
  			enddate:$('#enddate').val(),endtime:$('#endtime').val(),meetingid:'<%=meetingid%>'},
  			function(datas){
				var dataObj=null;
				if(datas != ''){
					dataObj=eval("("+datas+")");
				}
				if(wuiUtil.getJsonValueByIndex(dataObj, 0) == "0"){
					submitact();
				} else {
					<%if(meetingSetInfo.getMemberConflict() == 1){ %>
						releasePage();
			            window.top.Dialog.confirm(wuiUtil.getJsonValueByIndex(dataObj, 1)+"<%=SystemEnv.getHtmlLabelName(32873,user.getLanguage())%>?", function (){
			                submitact();
			            },null, null, 120);
		            <%} else if(meetingSetInfo.getMemberConflict() == 2) {%>
						releasePage();
		            	Dialog.alert(wuiUtil.getJsonValueByIndex(dataObj, 1)+"<%=SystemEnv.getHtmlLabelName(32874,user.getLanguage())%>" ,null ,400 ,150);
		            	return;
		            <%}%>
				} 
			});
       } else {
       		submitact();
       }
}

function submitact(){
	forbiddenPage();
	enableAllmenu();
	document.weaver.method.value = "changeMeeting";
	doUpload();
}

function doUpload(){
	//附件上传
    StartUploadAll();
    checkuploadcomplet();
}

function doSaveAfterAccUpload(){
	document.weaver.submit();
}
//提交时校验会议室是否为空
function checkAddress()
{	
	if($("#customizeAddress").length>0){
		if($("#address").val()==''&&$("#customizeAddress").val()==''){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(20393, user.getLanguage())%>");
			return false;
		}
	}else{
		if($("#address").val()==''){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(20393, user.getLanguage())%>");
			return false;
		}
	}
	return true;
}

//检测开始时间和结束时间的前后
function checkDateValidity(begindate,begintime,enddate,endtime,errormsg){
	var isValid = true;
	if(compareDate(begindate,begintime,enddate,endtime) == 1){
		Dialog.alert(errormsg);
		isValid = false;
	}
	return isValid;
}

/*Check Date */
function compareDate(date1,time1,date2,time2){

	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0] + " " +time1;
	date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0] + " " +time2;

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}

function ItemCount_KeyPress_Plus()
{
	if(!(window.event.keyCode >= 48 && window.event.keyCode <= 57))
	{
		window.event.keyCode = 0;
	}
}
</script>

</body>
<script language="javascript">

//会议选择框,判断是否存在自定义会议地点
function CheckOnShowAddress(){
	 if($('#customizeAddress').length>0&&$('#customizeAddress').val()!=""){
	 	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82885, user.getLanguage())%>",function(){
	 		onShowAddress();	
	 	});
	 }else{
	 	onShowAddress();	
	 }
}
//打开会议室选择框
function onShowAddress(){
	var url = "/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MutilMeetingRoomBrowser.jsp";
	showBrwDlg(url, "frommeeting=1&selectedids="+$('#address').val(), 500,480,"addressspan","address","addressChgCbk");
	$("#src_box_middle").css("height","400px");
}
//会议室回写处理
function addressChgCbk(datas){
	if(datas){
		if (datas!=""){
             var ids = datas.id;
             var names = datas.name;
             arrid=ids.split(",");
             arrname=names.split(",");
             var html="";
             for(var i=0;i<arrid.length;i++){
               html += "<a href='/meeting/Maint/MeetingRoom_list.jsp?id="+arrid[i]+"' target='_new' >"+arrname[i]+"</A>";
             }
             html = html.substr(0,html.length-1);
             $("#addressspan").html(html);
			 weaver.address.value = ids;
			 $("#customizeAddressspan").html("");
		}else{
			 $("#addressspan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			 weaver.address.value="";
			 $("#customizeAddressspan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
		}
		
		 _writeBackData("address",2,{id:jQuery("#address").val(),name:jQuery("#addressspan").html()},{
			hasInput:true,
			replace:true,
			//isSingle:true,
			isedit:true
		});
	}
	addressCallBack();
}
//会议室选择和填写后方法处理
function addressCallBack(){
	if($("#address").val()!=''){
		if($('#customizeAddress').length>0){
			$('#customizeAddress').val("")
		}
	}
	checkaddress();
}
//填写自定义会议室时,检测是否选择了会议地点 
function omd(){
	  var address = $("#address").val();
	  if(address!=''){
	  	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82885, user.getLanguage())%>",function(){
	  		$("#address").val("");
	  		$("#addressspan").html("");
	  		$("#addressspanimg").html("<img src='/images/BacoError_wev8.gif' align='absmiddle'>");
	  		checkaddress();
	  		$('#customizeAddress').focus();
	  	});
	  }
       
}

//改变会议地点和自定义会议地点的必填标识
function checkaddress(){
	var address = $("#address").val();
	var customizeAddress=$('#customizeAddress').length>0?$('#customizeAddress').val():'';
	if(address!=''||customizeAddress!=''){
		$("#addressspanimg").html("");
		if($('#customizeAddress').length>0){
			$("#customizeAddressspan").html("");
		}
	}else{
		$("#addressspanimg").html("<img src='/images/BacoError_wev8.gif' align='absmiddle'>");
		if($('#customizeAddress').length>0){
			$("#customizeAddressspan").html("<img src='/images/BacoError_wev8.gif' align='absmiddle'>");
		}
	}
}
 

function forbiddenPage(){  
    window.parent.forbiddenPage();
}  

function releasePage(){  
    window.parent.releasePage();
}

function btn_cancle(){
	window.parent.closeDialog();
}

jQuery(document).ready(function(){
	onRemindType();
	if(jQuery("#repeatType").val() != "0"){
		changeRepeatType();
	}
	resizeDialog(document);
	checkaddress();
});
//显示和隐藏 提醒时间控制
function onRemindType(){
	if($('#remindTypeNew').val()==''){
		hideEle("remindtimetr", true);
	}else{
		showEle("remindtimetr", true);
	}
}
//查看会议室使用情况,传递开始日期
function showRoomsWithDate(){
	var begindate=$('#begindate').val();
	if(window.top.Dialog){
		var diag = new window.top.Dialog();
	} else {
		diag = new Dialog();
	}
	diag.currentWindow = window;
	diag.Width = 1100;
	diag.Height = 550;
	diag.Modal = true;
	diag.maxiumnable = true;
	diag.Title = "<%=SystemEnv.getHtmlLabelName(15881,user.getLanguage())%>";
	diag.URL = "/meeting/report/MeetingRoomPlan.jsp?currentdate="+begindate;
	diag.show();
}
function showDetailCustomTreeBrowser(type){
	var eve=window.event;
	var eventSource = eve.srcElement||eve.target;
	var fieldid=eventSource.id.substr(0,eventSource.id.length-11);
	showCustomTreeBrowser(fieldid,type);
	
}
 
jQuery(document).ready(function(){
	if($("input[name='hrmmembers']").length>0){
		$("#oldmembers").val($("input[name='hrmmembers']").val());
	}
});
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</html>