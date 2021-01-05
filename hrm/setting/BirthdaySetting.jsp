
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
								 weaver.general.GCONST,
                 weaver.hrm.settings.ChgPasswdReminder,
                 weaver.hrm.settings.RemindSettings,java.io.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="HrmResourceFile" class="weaver.hrm.tools.HrmResourceFile" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/hrm/resource/uploader.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<%
if(!HrmUserVarify.checkUserRight("OtherSettings:Edit",user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String dir = "";
%>
<script type="text/javascript">
jQuery(document).ready(function(){
	if(!jQuery("#birthvalidadmin").attr("checked")){
		hideEle("tr_admin");
		hideGroup("tr_admin");
	}
	if(!jQuery("#birthvalid").attr("checked")){
		hideEle("personal_set");
		hideEle("personal_set_field");
		hideEle("trAlarmTypeCss");
		
		hideEle("trDialogCongratulation");
		hideEle("trWFCongratulation");
		hideGroup("window_set");
	}else{
		hideEle("trDialogCongratulation");
		hideEle("trWFCongratulation");
		if(jQuery("#birthremindmode").val()==0){
			showEle("trAlarmTypeCss");


			showEle("trDialogCongratulation");
		}else{
			showEle("trWFCongratulation");
		}
		if(jQuery("#birthremindmode").val()=="1"){
			hideEle("personal_set_field");
		}
	}
	imagePreview();
	reflashAdminTable();
	
	var obj = jQuery("div[name=uploadDiv]");
	bindUploaderDiv(obj,"birthdaySetting"); 
});

function onBtnSearchClick(){
	//jQuery("#searchfrm").submit();
}

function reflashAdminTable(){
	jQuery.ajax({
        type:"post",
        dataType: 'text',
        url: "BirthdayAdminTable.jsp?date="+new Date(),
        success: function(data){
					jQuery("#admintable").html(data);
					jQuery("body").jNice();
       },
			 error: function(err){
		 	  console.log(err);
			 }
	});
}

function onAlarmTypeChange(obj)
{
	hideEle("trAlarmTypeCss");
	hideEle("trDialogCongratulation");
	hideEle("trWFCongratulation");
	if(jQuery(obj).val()==0){
		showEle("trDialogCongratulation");
		showEle("trAlarmTypeCss");
		showEle("window_set_item");
		showEle("personal_set_field");
		showGroup("window_set");
	}else{
		showEle("trWFCongratulation");
		hideGroup("window_set");
		hideEle("window_set_item");
		hideEle("personal_set_field");
		
	}
}

function personalisAlarm(obj)
{
	hideEle("personal_set");
	hideEle("personal_set_field");
	hideEle("trAlarmTypeCss");
	hideEle("trDialogCongratulation");
	hideEle("trWFCongratulation");
	hideGroup("window_set");
	hideEle("window_set_item");
	if(jQuery(obj).attr("checked")){
		showEle("personal_set");
		showEle("personal_set_field");
		showEle("trAlarmTypeCss");
		if(jQuery("#birthremindmode").val() == 0){
			showGroup("window_set");
			showEle("window_set_item");
			showEle("trDialogCongratulation");
		}
		if(jQuery("#birthremindmode").val()=="1"){
			hideEle("personal_set_field");
			showEle("trWFCongratulation");
		}
	}
}

function adminisAlarm(obj)
{
	hideEle("tr_admin");
	hideGroup("tr_admin");
	if(jQuery(obj).attr("checked")){
		showEle("tr_admin");
		showGroup("tr_admin");
	}
}
var upfilesnum=0;
function onSave()
{
	if(jQuery("#birthdialogstyle").attr("checked")==false){
  	jQuery("#birthdialogstyle").val("");
  }
  
	if(jQuery("#birthvalid").attr("checked")&&jQuery("#birthremindmode").val()==0){
		var oUploader=window[jQuery("div[name=uploadDiv]").attr("oUploaderIndex")];
	 	if(oUploader.getStats().files_queued>0){
	 		upfilesnum=oUploader.getStats().files_queued;
	 		oUploader.startUpload();
	 	}
		if(upfilesnum==0) doSaveAfterAccUpload();
	}else{
		doSaveAfterAccUpload();
	}
}

function doSaveAfterAccUpload(){
	jQuery("#searchfrm").submit();
}

var dialog = null;
function closeDialog(){
	if(dialog)dialog.close();
}

function jsAddAdminLine(obj)
{
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;

	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("1421,17869",user.getLanguage())%>";
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=BirthdayAdminSetting";

	dialog.Width = 600;
	dialog.Height = 355;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function jsChkAll(obj) {
	jQuery("#admintable").find("input[name='chkId']").each(function(){
		changeCheckboxStatus(this,obj.checked);
	});
}

function doDel(){
	var ids = "";
	jQuery("#TabBirthShare").find("input[name='chkId']").each(function(){
		if(this.checked){
			if(ids!="")ids+=",";
			ids+=this.value;
		}
	});
	
	if(!ids){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
	var idArr = ids.split(",");
	var ajaxNum = 0;
	for(var i=0;i<idArr.length;i++){
		ajaxNum++;
		jQuery.ajax({
			url:"BirthdayAdminSettingOperation.jsp?isdialog=1&method=delete&id="+idArr[i],
			type:"post",
			async:true,
			complete:function(xhr,status){
				ajaxNum--;
				if(ajaxNum==0){
					reflashAdminTable();
				}
			}
		});
	}
});
}

//图片预览
this.imagePreview = function(){	
	xOffset = 10;
	yOffset = 30;
$("a.preview").hover(function(e){
	this.t = this.title;
	this.title = "";	
	var c = (this.t != "") ? "<br/>" + this.t : "";
	$("body").append("<p id='preview'><img src='"+ this.href +"' alt='Image preview' />"+ c +"</p>");								 
	$("#preview")
		.css("top",(e.pageY - xOffset) + "px")
		.css("left",(e.pageX + yOffset) + "px")
		.fadeIn("fast");						
  },
function(){
	this.title = this.t;	
	$("#preview").remove();
  });	
$("a.preview").mousemove(function(e){
	$("#preview")
		.css("top",(e.pageY - xOffset) + "px")
		.css("left",(e.pageX + yOffset) + "px");
});			
}

function filedel(inputname,spanname,fileid){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83877, user.getLanguage())%>",function(){
		jQuery("#file"+fileid).remove();
		//删除附件
		jQuery.ajax({
		type:'post',
		url:'/hrm/resource/uploaderOperate.jsp',
		data:{"cmd":"delete","fileId":fileid},
		dataType:'text',
		success:function(msg){
			//window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20461, user.getLanguage())%>");
			doSaveAfterAccUpload();
		},
		error:function(){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20462, user.getLanguage())%>");
		}
		});
	})
}
</script>
<style type="text/css">
pre{
	display:block;
	font:100% "Courier New", Courier, monospace;
	padding:10px;
	border:1px solid #bae2f0;
	background:#e3f4f9;	
	margin:.5em 0;
	overflow:auto;
	width:800px;
}

img{border:none;}

#preview{
	position:absolute;
	border:1px solid #ccc;
	background:#333;
	padding:5px;
	display:none;
	color:#fff;
	}
</style>
</head>
<body>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17534,user.getLanguage());
String needfav ="1";
String needhelp ="";

ChgPasswdReminder reminder=new ChgPasswdReminder();
RemindSettings settings=reminder.getRemindSettings();
String birthvalid=settings.getBirthvalid();
String birthremindperiod=settings.getBirthremindperiod();
String birthremindmode=Util.null2String(settings.getBirthremindmode());
String congratulation=Util.null2String(settings.getCongratulation());
congratulation = Util.HTMLtoTxt(congratulation);
congratulation = Util.toHtmlMode(congratulation);
String congratulation1=Util.null2String(settings.getCongratulation1());
congratulation1 = Util.HTMLtoTxt(congratulation1);
String birthdialogstyle = Util.null2String(settings.getBirthdialogstyle());//弹窗样式
rs.executeSql("select count(*)  num from HrmResourcefile " 
		+ " where resourceid='0' and scopeId ='-99' and fieldid='-99' ");
String num = "0";
while(rs.next()){
	num = rs.getString("num");
}
if(num.equals("0")){
	birthdialogstyle="0";
}
if(birthdialogstyle.length()==0)birthdialogstyle="0";
String birthshowfield = settings.getBirthshowfield();//显示字段
String brithalarmscope = settings.getBrithalarmscope();//提醒范围
if(brithalarmscope.length()==0)brithalarmscope="3";
String birthvalidadmin = settings.getBirthvalidadmin();//是否提醒（管理员）
String brithalarmadminscope = settings.getBrithalarmadminscope();//提醒泛微（管理员）
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("OtherSettings:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<FORM name="searchfrm" id="searchfrm" method=post action="HrmSettingOperation.jsp" enctype="multipart/form-data">
	<input name="cmd" type="hidden" value="birthSave">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("OtherSettings:Edit", user)){ %>
				<input type=button class="e8_btn_top" onclick="onSave();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
		</tr>
	</table>
	<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("1507,26928",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("32164,26928",user.getLanguage())%></wea:item>
		<wea:item><input type="checkbox" id="birthvalidadmin" tzCheckbox="true" name="birthvalidadmin" <%=birthvalidadmin.equals("1")?"checked":"" %> value="1" onclick="adminisAlarm(this)" ></wea:item>
		<wea:item attributes="{'samePair':'tr_admin'}"><%=SystemEnv.getHtmlLabelName(15792,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'tr_admin'}"><input type="text" name="birthremindperiod" value='<%=birthremindperiod%>' onBlur="checknumber1('birthremindperiod')" onKeyPress="ItemCount_KeyPress()" style="width: 100px"></wea:item>
	</wea:group>	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(17869,user.getLanguage())%>' attributes="{'samePair':'tr_admin','groupOperDisplay':'none'}">
		<wea:item type="groupHead">
		<%if(HrmUserVarify.checkUserRight("OtherSettings:Edit", user)){ %>
			<input name="btnOnSave" class=addbtn type="button" title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onclick="jsAddAdminLine(this)">
			<input name="btnOnDel" class=delbtn type="button" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" onclick="doDel()">
		<%} %>
		</wea:item>
		<wea:item attributes="{'isTableList':'true','colspan':'full'}"><div id="admintable"></div></wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("362,15148",user.getLanguage())%>' attributes="{'groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelNames("32164,26928",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" id="birthvalid" name="birthvalid" tzCheckbox="true" <%=birthvalid.equals("1")?"checked":"" %> value="1" onclick="personalisAlarm(this)"><label>
		</wea:item>
		<wea:item attributes="{'samePair':'personal_set'}"><%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'personal_set'}">
			<select id="birthremindmode" name="birthremindmode" onchange="onAlarmTypeChange(this)">
				<option value="1" <%=birthremindmode.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18051,user.getLanguage())%></option>
				<option value="0" <%=birthremindmode.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%></option>
			</select>
		</wea:item>
		<wea:item attributes="{'samePair':'personal_set_field'}"><%=SystemEnv.getHtmlLabelName(19495, user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'personal_set_field'}">
			<input name="birthshowfield" type="checkbox" value="1" checked disabled="disabled"><label><%=SystemEnv.getHtmlLabelName(25034,user.getLanguage())%></label>
			<input name="birthshowfield" type="checkbox" value="2" <%=birthshowfield.indexOf("2")!=-1?"checked":"" %>><label><%=SystemEnv.getHtmlLabelName(27511,user.getLanguage())%></label>
			<input name="birthshowfield" type="checkbox" value="3" <%=birthshowfield.indexOf("3")!=-1?"checked":"" %>><label><%=SystemEnv.getHtmlLabelName(26505,user.getLanguage())%></label>
		</wea:item>
		<wea:item attributes="{'samePair':'trDialogCongratulation'}"><%=SystemEnv.getHtmlLabelName(18352,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'trDialogCongratulation'}">
			<textarea id="congratulation" name="congratulation" style="width: 500px;height: 80px"><%=congratulation %></textarea>
		</wea:item>
		<wea:item attributes="{'samePair':'trWFCongratulation'}"><%=SystemEnv.getHtmlLabelName(18352,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'trWFCongratulation'}">
			<textarea id="congratulation1" name="congratulation1" style="width: 500px;height: 80px"><%=congratulation1 %></textarea>
		</wea:item>
		<wea:item attributes="{'samePair':'personal_set'}"><%=SystemEnv.getHtmlLabelNames("26928,19467",user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'personal_set'}">
			<select name="brithalarmscope">
				<option value="1" <%=brithalarmscope.equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(15763,user.getLanguage())%></option>
				<option value="2" <%=brithalarmscope.equals("2")?"selected":""%>><%=SystemEnv.getHtmlLabelName(21837,user.getLanguage())%></option>
				<option value="4" <%=brithalarmscope.equals("4")?"selected":""%>><%=SystemEnv.getHtmlLabelName(30792,user.getLanguage())%></option>
				<option value="3" <%=brithalarmscope.equals("3")?"selected":""%>><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
			</select>
		</wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("18717,1014",user.getLanguage())%>' attributes="{'samePair':'window_set'}">
		<wea:item attributes="{'samePair':'window_set_item'}"><%=SystemEnv.getHtmlLabelNames("1014",user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'window_set_item'}">
		<input name="birthdialogstyle" type="radio" value="0" style="vertical-align: top;" <%=birthdialogstyle.equals("0")?"checked":"" %>>(<%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%>)
		<a href="/images_face/ecologyFace_1/BirthdayFace/1/BirthdayBg_3_wev8.jpg" onclick="return false;" class="preview" title="style one">
		<img style="width: 100px;height: 80px" src="/images_face/ecologyFace_1/BirthdayFace/1/BirthdayBg_3_wev8.jpg" alt="style one" title="perview"></a>
			
		<%
		rs.executeSql("select docid,docname from HrmResourcefile " 
				+ " where resourceid='0' and scopeId ='-99' and fieldid='-99' order by id");
		int idx = 0;
while(rs.next()){
	idx++;
	String url ="/weaver/weaver.file.FileDownload?fileid="+Util.null2String(rs.getString("docid"));
	%>
			<input name="birthdialogstyle" type="radio" value="<%=idx %>" style="vertical-align: top;" <%=birthdialogstyle.equals(""+idx)?"checked":"" %>>
			<a href="<%=url %>" onclick="return false;" class="preview" title="style one">
			<img style="width: 100px;height: 80px" src="<%=url %>" alt="style one" title="perview"></a>

<%}	%>
		</wea:item>
		<wea:item attributes="{'samePair':'window_set_item'}"><%=SystemEnv.getHtmlLabelName(22923,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'window_set_item'}">
			<div id="uploadDiv" name="uploadDiv" resourceId="0" scopeId="-99" fieldId="-99" maxsize="10"></div>
			<%
     	String[] resourceFile = HrmResourceFile.getResourceFile("0", -99, -99);
			%>
			<div style="padding-top: 5px"><%=resourceFile[1] %></div>
		</wea:item>
	</wea:group>
	</wea:layout>
	</FORM>
	<table><tr><td style="height: 200px"></td></tr></table>
</div>
</body>
<script type="text/javascript">
	if('<%=birthremindmode%>' =='1'){
		hideGroup("window_set");
		hideEle("window_set_item");
		hideEle("trDialogCongratulation");
		hideEle("trWFCongratulation");
		hideEle("personal_set_field");
	}
</script>
</html>

