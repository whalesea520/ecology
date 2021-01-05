<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
String resourceid=Util.null2String(request.getParameter("resourceid"));
%>
<HTML><HEAD>
<script type="text/javascript">
var dialog = null;
var dWidth = 800;
var dHeight = 500;


function setUser(uid){
     __displayloaddingblock();
	jQuery("#personcontent").attr("src","HrmResourceAbsense1.jsp?resourceid="+uid+"&bywhat="+jQuery("#personcontent").contents().find("#bywhat").val()+"&currentdate="+jQuery("#personcontent").contents().find("#currentdate").val());
}

function _callBack(event,id1,name,_callbackParams){
	if (id1){
		if(id1.id!="") {
			var id = wuiUtil.getJsonValueByIndex(id1,0);
			setUid(id);
			showPersonTree(id);
		}
	}
}
function showPersonTree(id){
	jQuery("#persontree").attr("src","SubordinateTree.jsp?id="+id);
}
var hasException = false;
var curId = "<%=user.getUID()%>";
function setUid(uid){
	var isShow = "true";
	var message = "";
	<%if(!HrmUserVarify.checkUserRight("HrmResource:Absense", user)){
	%>
    jQuery.post("/js/hrm/getdata.jsp",{"cmd":"checkBeforeShowMobileSignData",arg:curId,id:uid},function(data){
    	var tmpData = eval(jQuery.trim(data));
		if(tmpData && tmpData.length > 0){
			for(var i=0;i<tmpData.length;i++){
				isShow = tmpData[i].isShow;
				message = tmpData[i].absensemessage;
				break;
			}
		}
		if(isShow === "true" || message === ""){
			setUser(uid);
		} else {
			window.top.Dialog.alert(message);
		}
    });
	<%}else{
%>
		if(isShow === "true" || message === ""){
			setUser(uid);
		} else {
			window.top.Dialog.alert(message);
		}
<%		
	}
	%>
}

function __displayloaddingblock() {
    try {
        var pTop= document.body.offsetHeight/2+document.body.scrollTop - 50;
        var pLeft= document.body.offsetWidth/2 - (50);
        jQuery("#submitloaddingdiv").css({"top":pTop, "left":pLeft, "display":"inline-block;"});
        jQuery("#submitloaddingdiv").show();
        jQuery("#submitloaddingdiv_out").show();
    } catch (e) {}
}

function openDialog(){
	dialog = new window.top.Dialog();
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmWorkflowAdd";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>";
	dialog.Width = 700;
	dialog.Height = 513;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
jQuery(document).ready(function(){
	
     __displayloaddingblock();
	jQuery("#persontree").width((jQuery("body").width()*0.2-30));
	jQuery("#frametable").height(jQuery(window).height());
	jQuery("#persontree").height(jQuery(window).height());
	window.onresize = function(){
		jQuery("body").width(jQuery("html").width());
		jQuery("#frametable").width(jQuery("html").width());
		jQuery("#persontree").width((jQuery("html").width()*0.2));
	};
});

function bindInnerRightMenu(e, target) {
	var rightmenuiframe; 
	try {
		rightmenuiframe = target.contentWindow.document.getElementById("rightMenuIframe").contentWindow;
	} catch (e) {}
	if (!!!rightmenuiframe) {
		setTimeout(function () {
			bindInnerRightMenu(e, target);
		}, 100);
		return ;
	}
	var e8_head=$("div.e8_boxhead",window.parent.document);
	if(e8_head.length==0){
		var e8_head=$("div#rightBox",window.parent.document);
	}
	jQuery(".cornerMenu").unbind("click");
	jQuery(".cornerMenu").click(function(e){
		bindCornerMenuEvent(e8_head, target.contentWindow, e);
		return false;
	});
}

function showMySubordinateTree(){
	window.location.href = "HrmResourceAbsense.jsp?resourceid=<%=resourceid%>";
}
</script>
</head>
<BODY style="width:100%;height:100%; ">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="openDialog();" style="margin-right: 10px;" value="<%=SystemEnv.getHtmlLabelNames("82,15880,30045",user.getLanguage())%>">
		</td>
	</tr>
</table>
<table id="frametable" style="height: 100%;" height="100%" width="100%">
	<tr style="height: 100%;" height="100%" id="contentTr">
	<td valign="top" width="85%"  height="100%" style="height: 100%;" >
		<div id="submitloaddingdiv_out" style="display:none;background:#000;width:100%;height:100%;top:0px;left:0px; bottom:0px;right:0px;position:absolute;top:0px;left:0px;z-index:9999;filter:alpha(opacity=20);-moz-opacity:0.2;opacity:0.2;">
		</div>
		<span id="submitloaddingdiv" style="display:none;height:48px;border:1px solid #9cc5db;background:#ebf8ff;color:#4c7c9f;line-height:48px;width:240px;position:absolute;z-index:9999;font-size:12px;">
			<img src="/images/ecology8/workflow/multres/cg_lodding_wev8.gif" height="27px" width="57px" style="vertical-align:middle;"/><span style="margin-left:22px;"><%=SystemEnv.getHtmlLabelName(20204, user.getLanguage()) %></span>
		</span>
		<div id="contentdiv" style="height:100%;">
			<IFRAME name="personcontent" id="personcontent" src="HrmResourceAbsense1.jsp?resourceid=<%=resourceid %>" frameborder='0' style="width:100%;height:100%;" scrolling="no"  ></IFRAME>
		</div>
</td>
<td id="tdTree" width="15%" valign="top"  height="100%" style="height: 100%;" >
			<table height="100%" style="height:100%;width:100%;display: table-cell;border:1px solid #BDBDBD;" cellspacing="0" cellpadding="0">
				<tr id="fTr">
					<td style="vertical-align:top;height:60px;width:100%;position:relative;display:table-cell;border:none;font-size:12px;">
						<span style="padding-left:10px;height:30px;line-height:30px;float:left;display:-moz-inline-box;display:inline-block;vertical-align:middle;position:relative;">
							<p style="font-weight:bold;"><%=SystemEnv.getHtmlLabelName(32997,user.getLanguage())%></p>
						</span>
						<span style="padding:5px;height:30px;line-height:30px;float:right;display:-moz-inline-box;display:inline-block;vertical-align:middle;position:relative;">
						</span>
						<p style="background-color:#d0d0d0;padding:5px;height:26px;width:96%;font-size:12px;">
							<div style="padding:2px;position:relative;">
								<brow:browser viewType="0" name="currentUser" browserValue='<%=resourceid%>' temptitle='<%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%>'
									browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"%>'
									hasInput="true" isSingle="true" hasBrowser="true" isMustInput='1' width="85%" _callback="_callBack" _callbackParams=""
									completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
									browserSpanValue='<%=ResourceComInfo.getLastname(resourceid)%>'>
								</brow:browser>
							</div>
							<div style="float:right;height:24px;line-height:28px;color:#fff;cursor: pointer;width:10px;padding-right:12px;position:relative;" title="<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>" onclick="showMySubordinateTree()">
								<img border="0" src="/appres/hrm/image/mobile/signin/img004.png">
							</div>
						</p>
					</td>
				</tr>
				<tr style="background-color:#fff;">
					<td valign="top">
						<div id="treediv" style="padding-top:5px;padding-bottom:5px;height:100%;">
							<IFRAME name="persontree" id="persontree" src="SubordinateTree.jsp?id=<%=resourceid%>&slg=i" frameborder='0' style="width:100%;height:100%;" scrolling="no" ></IFRAME>
						</div>
					</td>
				</tr>
			</table>	
</td>
	</tr>
</table>
</body>
</html>
