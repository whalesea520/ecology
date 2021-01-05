
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<!DOCTYPE html>
<%
    if (!HrmUserVarify.checkUserRight("Customer:Settings", user)) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
%>
<%@ include file="/workflow/request/CommonUtils.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
<%
    RCMenu += "{" + $label(86, user.getLanguage()) + ",javascript:doSave(),_top} ";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>

<%
    RecordSet.executeSql("select * from CRM_CardRegSettings where id=1");

    boolean bl = RecordSet.first();
    String isopen = "";
    String url = "";
    String loginid = "";
    String password = "";
    if (bl) {
        isopen = Util.null2String(RecordSet.getString("isopen"));
        url = Util.null2String(RecordSet.getString("url"));
        loginid = Util.null2String(RecordSet.getString("loginid"));
        password = Util.null2String(RecordSet.getString("password"));
    }
%>
<%
	String title_url="";
	title_url+= "<ul style='padding-left:15px;'>";
	if(user.getLanguage()==8){
		title_url+= "<li>"+"apply for the interface address from the official website(http://www.ccint.com/personal-camcard)."+"</li>";
	}else if(user.getLanguage()==9){
		title_url+= "<li>"+"填寫在名片全能王官方網站（http://www.ccint.com/personal-camcard）申請的接口地址"+"</li>";
	}else{
		title_url+= "<li>"+"填写在名片全能王官方网站（http://www.ccint.com/personal-camcard）申请的接口地址"+"</li>";
	}
	title_url+= "</ul>";

	String title_loginid="";
	title_loginid+= "<ul style='padding-left:15px;'>";
	if(user.getLanguage()==8){
		title_loginid+= "<li>"+"apply for the account number on the official website(http://www.ccint.com/personal-camcard)."+"</li>";
	}else if(user.getLanguage()==9){
		title_loginid+= "<li>"+"填寫在名片全能王官方網站（http://www.ccint.com/personal-camcard）申請的帳號"+"</li>";
	}else{
		title_loginid+= "<li>"+"填写在名片全能王官方网站（http://www.ccint.com/personal-camcard）申请的账号"+"</li>";
	}
	title_loginid+= "</ul>";
	
	String title_password="";
	title_password+= "<ul style='padding-left:15px;'>";
	if(user.getLanguage()==8){
		title_password+= "<li>"+"apply for the password from the official website(http://www.ccint.com/personal-camcard)."+"</li>";
	}else if(user.getLanguage()==9){
		title_password+= "<li>"+"填寫在名片全能王官方網站（http://www.ccint.com/personal-camcard）申請的密碼"+"</li>";
	}else{
		title_password+= "<li>"+"填写在名片全能王官方网站（http://www.ccint.com/personal-camcard）申请的密码"+"</li>";
	}
	title_password+= "</ul>";
%>
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/proj/js/common_wev8.js"></script>
		<script language=javascript src="/js/checkData_wev8.js"></script>
	</head>
	<body>
		<wea:layout attributes="{layoutTableId:topTitle}">
			<wea:group context="" attributes="{groupDisplay:none}">
				<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
					<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
						<input class="e8_btn_top middle" onclick="doSave()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
					</span>
					<span title="SystemEnv.getHtmlLabelName(23036,user.getLanguage())" class="cornerMenu"></span>
				</wea:item>
			</wea:group>
		</wea:layout>
		
		<form id="weaver" name="frmmain"
			action="/CRM/Maint/CRMCardRegSettingsOperation.jsp?method=settings"
			method="post">
			<wea:layout type="twoCol" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=$label(31811, user.getLanguage())%>'
					attributes="{'class':'e8_title e8_title_1'}">

					<!-- 是否开启 -->
					<wea:item>
                        <%=SystemEnv.getHtmlLabelName(32165,user.getLanguage())%>
                    </wea:item>
					<wea:item>
						<script>
                           $(function(){
                            checkImgStatus()
                           });
                           function checkImgStatus(){
                              if($("#isopen").is(":checked")){
                                showEle("noImg");
                                $("#signbtn").show();
                                if($("#iscache").is(":checked")){
                                	showEle("cachedayNoImg");
                                }
                              }else{
                                hideEle("noImg");
                                $("#signbtn").hide();
                                if($("#iscache").is(":checked")){
                                	hideEle("cachedayNoImg");
                                }
                              }
                           }
                        </script>
						<input type="checkbox" id="isopen" name="isopen" onclick="checkImgStatus()"  <%if(null != isopen&&isopen.equals("1")){%> checked <%}%> value="1" tzCheckbox="true">
					</wea:item>
					<!-- 接口 -->
					<wea:item attributes="{'samePair':'noImg'}">
                        <%=SystemEnv.getHtmlLabelName(130838,user.getLanguage())%>
                    </wea:item>
					<wea:item attributes="{'samePair':'noImg'}">
						<input class=InputStyle id="url" name="url" value="<%=url%>" onchange='checkinput("url","urlimage")' onblur='checkinput("url","urlimage")'>
						<SPAN ID=urlimage></SPAN>
						<span class="help" title="<%=title_url %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
					</wea:item>
                    <!-- 账号 -->
					<wea:item attributes="{'samePair':'noImg'}">
                        <%=SystemEnv.getHtmlLabelName(83594,user.getLanguage())%>
                    </wea:item>
					<wea:item attributes="{'samePair':'noImg'}">
						<input class=InputStyle id="loginid" name="loginid" value="<%=loginid%>" onchange='checkinput("loginid","loginidimage")' onblur='checkinput("loginid","loginidimage")'>
						<SPAN ID=loginidimage></SPAN>
						<span class="help" title="<%=title_loginid %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
					</wea:item>
					<!-- 密码 -->
					<wea:item attributes="{'samePair':'noImg'}">
                        <%=SystemEnv.getHtmlLabelName(83865,user.getLanguage())%>
                    </wea:item>
					<wea:item attributes="{'samePair':'noImg'}">
						<input class=InputStyle id="password" name="password" value="<%=password%>" onchange='checkinput("password","passwordimage")' onblur='checkinput("password","passwordimage")'>
						<SPAN ID=passwordimage></SPAN>
						<span class="help" title="<%=title_password %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
					</wea:item>
				</wea:group>
			</wea:layout>
		</form>
		</div>
		<script>
			function doSave(){
				//是否启用，启用时则才调用，否则不调用验证
				if($('#isopen').is(':checked')) {
					var url = $("#url").val();
					var loginid = $("#loginid").val();
					var password = $("#password").val();
					if(""==url||""==loginid||""==password){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
						return;
					}
					//验证接口
					var status = validateInterface(url,loginid,password);
					if("0"==status){
                        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(382423,user.getLanguage())%>");
					    return;
					}
				}
				$('#weaver').submit();
			}

			function validateInterface(url,loginid,password) {
			    var status="0";
                $.ajax({
                    url: '/CRM/Maint/CRMCardRegSettingsOperation.jsp?method=validate',
                    type: 'POST',
                    data: {url:url,loginid:loginid,password:password},
                    dataType:"json",
                    async:false,//同步
                    success:function(data){
                        status = data.status;
                    },
                    complete : function(XMLHttpRequest,status){ //请求完成后最终执行参数
                        if(status=='timeout'){//超时,status还有success,error等值的情况
                            ajaxTimeoutTest.abort();
                            status = "0";
                        }
                    }
                })
				return status;
            }

			//初始化
			$(function(){
				checkinput("url","urlimage");
				checkinput("loginid","loginidimage");
				checkinput("password","passwordimage");
				$(".help").wTooltip({html:true});
			});
			
			
		</script>
	</body>
</html>
