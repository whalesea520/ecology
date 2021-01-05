<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
 <%@ page import="weaver.rdeploy.doc.PrivateSeccategoryManager" %>
<%
	int folderid = Util.getIntValue(request.getParameter("folderid"),-1);
	int fileid = Util.getIntValue(request.getParameter("fileid"),-1);
	String sharername = Util.null2String(request.getParameter("sharername"));
	sharername = sharername.replaceAll("'","''");
	PrivateSeccategoryManager seccategoryManager = new PrivateSeccategoryManager();
	List<Map<String,String>> shareObjs = seccategoryManager.getShareObjects(user,fileid,folderid,sharername);
	
%>


<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		var topWi = window;
		var curWi = window;
		while(topWi != topWi.parent){
			curWi = topWi;
			topWi = topWi.parent;
		}
		parentWin = topWi.getParentWindow(curWi);
		dialog = topWi.getDialog(curWi);
	}catch(e){}
</script>
<script>

function onClose(){
	if(dialog){
		dialog.close();
	}else{
    	window.parent.close();
    }
}

function dataBack(data){
	if(dialog){
		try{
		dialog.callback(data);
		}catch(e){}
		try{
		dialog.close(data);
		}catch(e){}
	}else{
	    window.parent.returnValue = data;
	    window.parent.close();
	}
}

function onSearch(){
	document.SearchForm.submit();
}

function checkAll(thi){
	var $obj;
	if(thi.checked){
		$obj = jQuery("#userList .jNiceCheckbox").not(jQuery("#userList .jNiceCheckbox.jNiceChecked"));
	}else{
		$obj = jQuery("#userList .jNiceCheckbox.jNiceChecked"); 
	}
	$obj.each(function(){
		jQuery(this).toggleClass("jNiceChecked");
	});
}

window.ajaxSend = false;
function cancelShare(){
	if(window.ajaxSend){
		return;
	}
	if(jQuery("#userList .jNiceCheckbox.jNiceChecked").length == 0){
		window.top.Dialog.alert("请选择要删除的对象!");
		return;
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(129242,user.getLanguage())%>",function(){
		var ids = "";
		jQuery("#userList .jNiceCheckbox.jNiceChecked").each(function(){
			ids += "," + jQuery(this).siblings(".jNiceHidden").val();
		});
		window.ajaxSend = true;
		ids = ids.substring(1);
		jQuery.ajax({
			url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
			data : {
				type : "cancelShareObj",
				shareids : ids
			},
			type : "post",
			dataType : "json",
			success : function(data){
				if(data && data.flag == 1){
					jQuery("#userList .jNiceCheckbox.jNiceChecked").closest("li").remove();
					try{
						dialog.sendCancel2Msg(data.mesList);
					}catch(e){}
					hasObj();
				}else{
					window.top.Dialog.alert("删除失败!");
				}
			},
			complete : function(){
				window.ajaxSend = false;
			}
		})
	});
}


function hasObj(){
	if(jQuery("#userList li").length == 0){
		parent.removeChildView({
			folderid : "<%=folderid%>",
			fileid : "<%=fileid%>"
		});
		onClose();
	}
}

jQuery(function(){
	jQuery("#userList li .jNiceCheckbox").unbind("click");
	jQuery("#userList li").click(function(e){
		jQuery(this).find(".jNiceCheckbox").toggleClass("jNiceChecked");
	});
});
</script>
<style>
	#sharername{
		background:url(/rdeploy/assets/img/cproj/searchbtn.png) right center no-repeat;
		padding-right:22px;
	}
	li{
		list-style:none;
	}
</style>
</HEAD>
<BODY style="overflow:hidden;">
<div class="zDialog_div_content">
	<table cellpadding="0" cellspacing="0" style="width:100%;border-bottom:1px solid #CCCCCC">
		<tr>
			<td style="padding:8px">
				<img src="/rdeploy/assets/img/cproj/doc/icon.png" width="40px"
								height="40px" style="float:left;"/>
				<span style="float:left;font-size:14px;margin-left:8px">分享对象<span>
				<div style="clear:both"></div>
			</td>
			<td class="rightSearchSpan" style="text-align:right;vertical-align:bottom;padding:8px">
				<div style="float:right">
					<input style="float:left;margin-top:3px" type="button" onClick="cancelShare()" class="e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
					<form name="SearchForm" id="SearchForm" method="post" action="shareObj.jsp" style="float:left">
						<input type="hidden" name="fileid" value="<%=fileid %>"/>
						<input type="hidden" name="folderid" value="<%=folderid %>"/>
						<input style="float:left;margin-top:3px;margin-left:8px" type="text" class="InputStyle" name="sharername" id="sharername" value='<%=sharername %>'/>
					</form>
					<span style="float:left" title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
				</div>
			</td>
		</tr>
	</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<DIV align=right style="display:none">
<%
systemAdminMenu = "";
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=2 onclick="clearCategory()" id=btnclear><U></U><%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<div>
		<div style="background-color:#f8f8f8;height:40px;line-height:40px;border-bottom:2px solid #B7E0FE;padding-left:10px">
			<input style="width:74px" type="checkbox" class="checkAll" onClick="checkAll(this)"/>分享对象
		</div>
		<div style="height:370px;overflow:auto">
			<ul id="userList" >
				<%for(Map<String,String> shareObj : shareObjs){ %>
					<li style="padding-left:10px;border-bottom:1px solid #F2F2F2">
						<div style="float:left;padding:5px 0;margin-top:15px"><input type="checkbox" value="<%=shareObj.get("id")%>"/></div>
						<div style="float:left;;padding:5px">
							<img src="<%=shareObj.get("icon")%>" style="float:left;width:35px;height:35px;border-radius:50%;margin-top:10px"/>
							<div style="float:left;margin-left:10px">
								<p><%=shareObj.get("sharername") %></p>
								<p style="color:#B3BED8"><%="user".equals(shareObj.get("type")) ? (shareObj.get("department") + "/" + shareObj.get("company")) : (shareObj.get("number") + "人") %></p>
								<p style="color:#B3BED8">分享时间：<%=shareObj.get("sharetime") %></p>
							</div>
						</div>
						<div style="clear:both"></div>
					</li>
				<%} %>
			</ul>
		</div>
	</div>
 </div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
	    		<input type="button" accessKey="T"  id="btncancel" value="<%="T-"+SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</BODY></HTML>
