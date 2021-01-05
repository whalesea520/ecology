<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="net.sf.json.JSONObject"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String showTop = Util.null2String(request.getParameter("showTop"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());

if (!HrmUserVarify.checkUserRight("message:manager", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

%>


<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />

<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>

<%
	String isdeletefile = weaver.file.Prop.getPropValue("EMessage4Config", "isdeletefile");
	rs.execute("select * from Social_Pc_ClientSettings where fromtype = '1'");
	JSONObject settings = new JSONObject();
	while(rs.next()){
		settings.put(rs.getString("keytitle"), rs.getString("keyvalue"));
	}
	
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveInfo(),_self} " ;    
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="saveInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="菜单" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="SocialManagerOperation.jsp?method=basesetting&fromtype=1" name="weaver" onkeydown="if(event.keyCode==13)return false;">
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context="基础设置">
		<wea:item><%=SystemEnv.getHtmlLabelNames("126803",user.getLanguage())%></wea:item>
		<wea:item>
				<input name="maxGroupMems" id="maxGroupMems" 
					value="<%=settings.optString("maxGroupMems", "500") %>" 
					valueCache="<%=settings.optString("maxGroupMems", "500") %>" 
					defaultMax="500" maxlength="3" style="width :80px" 
					onchange="checkint('maxGroupMems');checkinput('maxGroupMems', 'maxGroupMems_span');validateValue(this);"  
					class="InputStyle">
				<span id="maxGroupMems_span"></span>
				<span>(<%=SystemEnv.getHtmlLabelNames("83523",user.getLanguage())%>500)</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("129980",user.getLanguage())%></wea:item>
		<wea:item>
				<input name="emWaterMark" id="emWaterMark" 
					value="<%if(settings.optString("emWaterMark", "").equals("null")){ }else{%><%=settings.optString("emWaterMark", "") %><%}%>" 
					 style="width :150px" 
					class="InputStyle">
				<span id="emWaterMark_span"></span>
				<span>(<%=SystemEnv.getHtmlLabelNames("129981",user.getLanguage())%>)</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("130118",user.getLanguage())%></wea:item>
		<wea:item>
				<input name="maxWithdrawTime" id="maxWithdrawTime" 
					value="<%=settings.optString("maxWithdrawTime", "0") %>" 
					valueCache="<%=settings.optString("maxWithdrawTime", "0") %>" 
					defaultMax="500" maxlength="3" style="width :80px" 
					onchange="checkint('maxWithdrawTime');checkinput('maxWithdrawTime', 'maxWithdrawTime_span');validateValue(this);"  
					class="InputStyle">
				<img title="0表示没有时间限制" src="/email/images/help_mail_wev8.png" align="absMiddle" />
				<span id="maxWithdrawTime_span"></span>
				<span>(<%=SystemEnv.getHtmlLabelNames("15049",user.getLanguage())%>)</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("131526",user.getLanguage())%></wea:item>
		<wea:item>
				<span><input name="multiAccountMsg" type="radio" value="1" <%if(settings.optString("multiAccountMsg").equals("1"))out.println("checked");%>/><%=SystemEnv.getHtmlLabelNames("131527",user.getLanguage())%></span>
				<span><input name="multiAccountMsg" type="radio" value="0" <%if(!settings.optString("multiAccountMsg").equals("1"))out.println("checked");%> /><%=SystemEnv.getHtmlLabelNames("131528",user.getLanguage())%></span>
		</wea:item>
	</wea:group>
	<wea:group context="附件设置">
		<wea:item><%=SystemEnv.getHtmlLabelNames("84817",user.getLanguage())%></wea:item>
		<wea:item>
				<input name="maxAccUploadSize" id="maxAccUploadSize" 
					value="<%=settings.optString("maxAccUploadSize", "300") %>" 
					valueCache="<%=settings.optString("maxAccUploadSize", "300") %>"
					defaultMax="2048" maxlength="4" style="width :80px" 
					onchange="checkint('maxAccUploadSize');checkinput('maxAccUploadSize', 'maxAccUploadSize_span');validateValue(this);"  
					class="InputStyle">M
				<span id="maxAccUploadSize_span"></span>
				<span>(<%=SystemEnv.getHtmlLabelNames("83523",user.getLanguage())%>2048)</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("130610",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="isFileToDocs" id="isFileToDocs" value="<%=settings.optString("isFileToDocs", "0")%>" class="inputstyle" 
				<%if(settings.optString("isFileToDocs").equals("1"))out.println("checked=checked");%> " onchange="changeValue(this)"/>
				<input type="hidden" name="isFileToDocs" value="value="<%=settings.optString("isFileToDocs", "0")%>"">
		</wea:item>		
		<wea:item attributes="{'samePair':'showfileTodocDiv'}"><%=SystemEnv.getHtmlLabelNames("130611",user.getLanguage())%> (<%=SystemEnv.getHtmlLabelNames("156",user.getLanguage())%>)</wea:item>
		<wea:item attributes="{'samePair':'showfileTodocDiv'}">
			<brow:browser viewType="0" name="categoryid" browserValue='<%=""+settings.optString("categoryid", "-1")%>' idKey="id" nameKey="path"
					browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
					completeUrl="/data.jsp?type=categoryBrowser&onlySec=true" linkUrl="#" width="80%"
				   browserSpanValue='<%=SecCategoryComInfo.getAllParentName(""+settings.optString("categoryid", "-1"),true)%>'></brow:browser>
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelNames("131358",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="isImgToDocs" id="isImgToDocs" value="<%=settings.optString("isImgToDocs", "0")%>" class="inputstyle" 
				<%if(settings.optString("isImgToDocs").equals("1"))out.println("checked=checked");%> " onchange="changeValue(this)"/>
				<input type="hidden" name="isImgToDocs" value="value="<%=settings.optString("isImgToDocs", "0")%>"">
		</wea:item>		
		<wea:item attributes="{'samePair':'showImgTodocDiv'}"><%=SystemEnv.getHtmlLabelNames("130611",user.getLanguage())%> (<%=SystemEnv.getHtmlLabelNames("74",user.getLanguage())%>)</wea:item>
		<wea:item attributes="{'samePair':'showImgTodocDiv'}">
			<brow:browser viewType="0" name="imgcategoryid" browserValue='<%=""+settings.optString("imgcategoryid", "-1")%>' idKey="id" nameKey="path"
					browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
					completeUrl="/data.jsp?type=categoryBrowser&onlySec=true" linkUrl="#" width="80%"
				   browserSpanValue='<%=SecCategoryComInfo.getAllParentName(""+settings.optString("imgcategoryid", "-1"),true)%>'></brow:browser>
		</wea:item>
		  <%if(isdeletefile.equals("1")){%>
			<wea:item>定时删除e-message附件</wea:item>
			<wea:item>
				<input type="checkbox" tzCheckbox="true" name="isOpenDeleteFileTask" id="isOpenDeleteFileTask" value="<%=settings.optString("isOpenDeleteFileTask", "0")%>" class="inputstyle" 
					<%if(settings.optString("isOpenDeleteFileTask").equals("1"))out.println("checked=checked");%> " onchange="changeValue(this)"/>
					<input type="hidden" name="isOpenDeleteFileTask" value="value="<%=settings.optString("isOpenDeleteFileTask", "0")%>"">
			</wea:item>	
			<wea:item attributes="{'samePair':'showTaskTimeDiv'}">时间周期</wea:item>
				<wea:item attributes="{'samePair':'showTaskTimeDiv'}">
					<input name="taskTime" id="taskTime" 
						value="<%=settings.optString("taskTime", "60") %>" 
						valueCache="<%=settings.optString("taskTime", "60") %>" 
						defaultMax="500" maxlength="3" style="width :80px" 
						onchange="checkint('taskTime');checkinput('taskTime', 'taskTime_span');validateValue(this);"  
						class="InputStyle">
					<span id="taskTime_span">天</span>
					<img title="删除该时间之前的e-message文件" src="/email/images/help_mail_wev8.png" align="absMiddle" />
					<span>(<%=SystemEnv.getHtmlLabelNames("83523",user.getLanguage())%>60天)</span>
				</wea:item>
			<%}%>		
	</wea:group>
	
	<wea:group context="管理操作">
	   <wea:item>删除emessage默认头像（显示错误）</wea:item>
	     <wea:item>
	     <input type="button" id="deleteButton" value="执行" class="e8_btn_submit" onclick="deleteIcon();"/>
	     <span id="deleteIcon_span"></span>
	     <img title="emessage默认头像显示错误，点击删除，之后再重新登陆emessage生成" src="/email/images/help_mail_wev8.png" align="absMiddle" onClick = "openUrl();"/>
	     </wea:item>
	</wea:group>
</wea:layout>
</form>
</body>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>  
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
	jQuery(function(){		
	<% if(!settings.optString("isFileToDocs").equals("1")){ %>hideEle("showfileTodocDiv");<%}%>
	<% if(!settings.optString("isImgToDocs").equals("1")){ %>hideEle("showImgTodocDiv");<%}%>
	<% if(!settings.optString("isOpenDeleteFileTask").equals("1")){ %>hideEle("showTaskTimeDiv");<%}%>
	});
	function changeValue(obj){
		var $chk = jQuery(obj);
		var _name = $chk.attr("name");		
		var categoryid = jQuery("input[name='categoryid']").val();
		var imgcategoryid = jQuery("input[name='imgcategoryid']").val();
		if($chk.val()=='1'){
			$chk.val('0');
			jQuery("input[name='"+_name+"']").val('0');
			if(_name == "isFileToDocs"){
				 hideEle("showfileTodocDiv");
				 if(categoryid ==undefined||categoryid ==""){
					 jQuery('#categoryidspanimg').html('');
				}				 
			}			
			if(_name == "isImgToDocs"){
				 hideEle("showImgTodocDiv");
				 if(imgcategoryid ==undefined||imgcategoryid ==""){
					 jQuery('#imgcategoryidspanimg').html('');
				 }					 
			}
			if(_name=="isOpenDeleteFileTask"){
				hideEle("showTaskTimeDiv");
			}	
			
		}else{
			jQuery(obj).val('1');
			jQuery("input[name='"+_name+"']").val('1');
			if(_name == "isFileToDocs"){
				showEle('showfileTodocDiv','true');
				if(categoryid ==undefined||categoryid ==""){
			    	 jQuery('#categoryidspanimg').html('<img align="absmiddle" src="/images/BacoError_wev8.gif">');
				}
				if( categoryid !=undefined && categoryid !=""){
					jQuery('#categoryid').parent().find('#'+categoryid).click();
				}			
			}
			if(_name == "isImgToDocs"){
				showEle('showImgTodocDiv','true');
				if(imgcategoryid ==undefined||imgcategoryid ==""){
				 	jQuery('#imgcategoryidspanimg').html('<img align="absmiddle" src="/images/BacoError_wev8.gif">');
				}
				if(imgcategoryid !=undefined && imgcategoryid !=""){
					jQuery('#imgcategoryid').parent().find('#'+imgcategoryid).click();
				}				
			}
			if(_name == "isOpenDeleteFileTask"){
				showEle('showTaskTimeDiv','true');
			}			
		}
	}
	function saveInfo(){
		if(jQuery("img[src='/images/BacoError_wev8.gif']").length !=0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
			return;
		}
		var value = $('#emWaterMark').attr("value");
		if(value==''||value==undefined){
			$('#emWaterMark').attr('value','null');
		}
		document.weaver.submit();
	}
	
	function validateValue(obj) {
		var maxMemCount = $(obj).val();
		var defaultMax = $(obj).attr("defaultMax");
		var valueCache = $(obj).attr("valueCache");
		if(maxMemCount == '' || parseInt($(obj).val()) > defaultMax){
			$(obj).val(!!valueCache?valueCache:defaultMax);
			jQuery("img[src='/images/BacoError_wev8.gif']").remove();
		}
	}
	
	function refreshCurPage(){
		window.location.href=window.location.href;
	}
	
	function deleteIcon(){
	    var _do = $("#deleteButton").attr("do");
	    if(_do!==undefined&&_do==="running"){
	       window.top.Dialog.alert("删除操作还在进行，请稍等",function(){
	           return;
	       });
	    }else{
	    window.top.Dialog.alert("删除操作需要执行几分钟，请稍后");
        $("#deleteButton").attr("do","running");
	    jQuery.post('/social/im/SocialIMOperation.jsp?operation=deleteEmessageWrongIcon', function(ok){
            if(jQuery.trim(ok)==='1'){
                window.top.Dialog.close();
                window.top.Dialog.alert("默认头像缓存删除成功,重新登录emessage将生成新默认头像");
                $("#deleteButton").removeAttr("do");
            }else{
                window.top.Dialog.close();
                window.top.Dialog.alert("默认头像缓存删除失败,请按照文档操作",function(){
                    openUrl();
                    $("#deleteButton").removeAttr("do");
                });
            }
        });
        }
	}
	
	function openUrl(){
	    window.open("http://im.cobiz.cn/html/emessagefile/message4.x%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98%E8%A7%A3%E5%86%B3%E6%96%B9%E6%A1%88.htm#_Toc502157651","_blank");
	}
</script>

