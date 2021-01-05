
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.email.MailReceiveRemindInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
	String rid = Util.null2String(request.getParameter("rid"), "0");
    
    String name = "";
    String enable = "";
    String content = "";
   
    rs.execute(" select name, enable, content from MailReceiveRemind where id = " + rid);
    while(rs.next()) {
    		enable = rs.getString("enable");
    		name = rs.getString("name");
    		content = rs.getString("content");
    }
    
    List<MailReceiveRemindInfo> mris = new ArrayList<MailReceiveRemindInfo>();
    rs2.execute(" select id, name, content from MailReceiveRemind ");
    while(rs2.next()) {
    	MailReceiveRemindInfo mri = new MailReceiveRemindInfo();
    	mri.setId(rs2.getInt("id"));
		mri.setName(rs2.getString("name"));
		mri.setContent(rs2.getString("content"));
		mris.add(mri);
	}
%>


<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">

	var parentWin = parent.getParentWindow(window);
	function saveInfo(){
		 jQuery.post("/email/maint/MailMaintOperation.jsp",jQuery("form").serialize(),function(){
			 	parentWin.closeDialog();
		 	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22619,user.getLanguage())%>");
		 });	
	}
	
	function insertTemplate(value){
		jQuery("#content").insertContent(value);
	}
	
	$(function() {  
    (function($) {  
        $.fn.extend({  
                    insertContent : function(myValue, t) {  
                        var $t = $(this)[0];  
                        if (document.selection) { // ie  
                            this.focus();  
                            var sel = document.selection.createRange();  
                            sel.text = myValue;  
                            this.focus();  
                            sel.moveStart('character', -l);  
                            var wee = sel.text.length;  
                            if (arguments.length == 2) {  
                                var l = $t.value.length;  
                                sel.moveEnd("character", wee + t);  
                                t <= 0 ? sel.moveStart("character", wee - 2 * t  
                                        - myValue.length) : sel.moveStart(  
                                        "character", wee - t - myValue.length);  
                                sel.select();  
                            }  
                        } else if ($t.selectionStart  
                                || $t.selectionStart == '0') {  
                            var startPos = $t.selectionStart;  
                            var endPos = $t.selectionEnd;  
                            var scrollTop = $t.scrollTop;  
                            $t.value = $t.value.substring(0, startPos)  
                                    + myValue  
                                    + $t.value.substring(endPos,  
                                            $t.value.length);  
                            this.focus();  
                            $t.selectionStart = startPos + myValue.length;  
                            $t.selectionEnd = startPos + myValue.length;  
                            $t.scrollTop = scrollTop;  
                            if (arguments.length == 2) {  
                                $t.setSelectionRange(startPos - t,  
                                        $t.selectionEnd + t);  
                                this.focus();  
                            }  
                        } else {  
                            this.value += myValue;  
                            this.focus();  
                        }  
                    }  
                })  
    	})(jQuery);  
	});

</script>
</head>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveInfo(),_self} " ;    
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="邮件待办设置"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="saveInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="菜单" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="/email/maint/MailMaintOperation.jsp" name="weaver">
<input type="hidden" name='method' value="remindSetting">
<input type="hidden" name='rid' value='<%=rid %>'>
				<wea:layout attributes="{'expandAllGroup':'true', cols:3}">
					<wea:group context="待办邮件提醒" attributes="">
						<wea:item>提醒方式</wea:item>
						<wea:item>
								<SELECT  class=InputStyle name="name" id="name"  style="width: 120px;" disabled="disabled">
									<%for(MailReceiveRemindInfo mri : mris) {%>
										<option value="<%=mri.getId() %>" <%if((mri.getId()+"").equals(rid))out.print("selected='selected'"); %>><%=mri.getName() %></option>
									<%} %>
								</SELECT>
						</wea:item>
						<wea:item>状态</wea:item>
						<wea:item>
								<input type="checkbox" tzCheckbox="true" name="enable" id="enable" value="1" class="inputstyle" <%if("1".equals(enable))out.println("checked=checked");%> />
						</wea:item>
						<wea:item>提醒内容</wea:item>
						<wea:item>
							<div style="float:left">
								<textarea type="textarea" id='content' name="content" wrap="virtual" style="resize: none;line-height:17px; height:107px;width:350px" ><%=content %></textarea>
							</div>
							<div style="float:left;margin-left:10px;margin-top:5px;">
									<button style="padding-left: 8px !important; padding-right: 8px !important;" onclick="insertTemplate('#[title]')" type=button  class="e8_btn">邮件标题:#[title]</button><br> 
									<button style="padding-left: 8px !important; padding-right: 8px !important;" onclick="insertTemplate('#[sneder]')" type=button  class="e8_btn">发件人:#[sneder]</button><br> 
									<button style="padding-left: 8px !important; padding-right: 8px !important;" onclick="insertTemplate('#[time]')" type=button  class="e8_btn">发件时间:#[time]</button><br> 
				 			</div> 
				 			<div style="clear:both"></div>
					    </wea:item>
					</wea:group>
				</wea:layout>
</form>
</body>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>  
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>

