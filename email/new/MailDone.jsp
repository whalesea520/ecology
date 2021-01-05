
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.email.MailErrorMessageInfo"%> 
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" scope="page" />
<%
	String isSent = Util.null2String(request.getAttribute("isSent"));
	MailErrorMessageInfo errorMessInfo = request.getAttribute("errorMess") == null ? new MailErrorMessageInfo() : (MailErrorMessageInfo)request.getAttribute("errorMess");
	int mailaccid = Util.getIntValue(request.getAttribute("mailaccid")+"");
	if(!"".equals(Util.null2String(request.getParameter("isSent"))))
		isSent = Util.null2String(request.getParameter("isSent"));
	String isSaveToSentFolder = Util.null2String(request.getParameter("isSaveToSentFolder"));
	mss.selectMailSetting(user.getUID());
	int userLayout = Util.getIntValue(Util.null2String(mss.getLayout()),0);
	
%>

<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js"></script>
<div class="h-100">&nbsp;</div>

<div class="   w-500 " style="margin-left:auto;margin-right:auto; ">
	<div style="border: 1px #DADADA solid;height:275px;width:480px;">
		<div class="m-l-30" style="margin-top:60px;">
			<div class="left colorccc m-l-30 p-l-15 font12 p-r-30 p-l-15 relative hand" onclick="backsjx()">
				<img src="/email/images/send_back_wev8.png" align="absmiddle"/>
				<a href="javascript:void(0)" style="color:#ccc"><%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(19816,user.getLanguage()) %></a>
			</div>
			<div class="left colorccc font12 p-r-30 p-l-15 relative hand" onclick="seejfyj()">
				<img src="/email/images/send_outbox_wev8.png" align="absmiddle"/>
				<a href="javascript:void(0)" style="color:#ccc"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(30922,user.getLanguage()) %></a>
			</div>
			<div class="left colorccc font12 p-r-30 p-l-15 relative hand" onclick="writemsg()">
				<img src="/email/images/send_add_wev8.png" align="absmiddle"/>
				<a href="javascript:void(0)" style="color:#ccc"><%=SystemEnv.getHtmlLabelName(124903,user.getLanguage()) %></a>
			</div>
			<div class="clear"></div>
		</div>
		<%if(errorMessInfo != null){%>
		<div class="relative">
				<div class="errormsg font13 " id="errormsg" style="display:none" >
					<div style='text-align:left; margin-top: 15px; margin-bottom: 10px; margin-left:10px; margin-right: 10px'   id='errorsolution'>
						<%=errorMessInfo.getSolution()%>
					</div>
					<hr/>
					<div style='text-align:left; margin-top: 10px; margin-bottom: 15px; margin-left:10px; margin-right: 10px' id='errordetail' >
						<%=errorMessInfo.getErrorString()%>
					</div>
				</div>
		   </div>
		<%}%>
		<%if(isSent.equals("timingdate")) { %>
		
		<div style="margin-left:100px;margin-top:35px;">
			<div class="success"></div>
			<div class="successDesc">
				<div class="text-left font24 ">
					<%=SystemEnv.getHtmlLabelName(32402,user.getLanguage()) %>
				</div>
			</div>
			<div class="successDesc">
				<%=SystemEnv.getHtmlLabelName(32403,user.getLanguage())%>
			</div>
		</div>
		
		<%}else if(isSent.equals("true")) { %>
		
		<div style="margin-left:100px;margin-top:35px;">
			<div class="success"></div>
			<div class="successDesc">
				<div class="text-left font24 ">
					<%=SystemEnv.getHtmlLabelName(124904,user.getLanguage()) %>
				</div>
			</div>
			<div class="clear"></div>
		</div>
		<%} else if(isSent.equals("false1")) { %>
		<div style="margin-left:100px;margin-top:35px;">
				<div>
					<div class="fail"></div>
					<div class="failureDesc" style="color:#909090">
						<div class="text-left font24 ">
							<%=SystemEnv.getHtmlLabelName(2045,user.getLanguage()) %>
						</div>
					</div>
					<div class="clear"></div>
				</div>
				<div style="margin-left:50px;font-size:13px;">
					<div style="color:#909090"><%=SystemEnv.getHtmlLabelName(83106,user.getLanguage()) %></div>
					<div class="errorDesc">
						<%if(errorMessInfo != null){%>
							<%=errorMessInfo.getErrorHint()%>
						<% }%>
					</div>
					<div class="errorDesc">
						<a href="javascript:showsendmsg()" style="color:#909090"><%=SystemEnv.getHtmlLabelName(83107,user.getLanguage()) %></a>
					</div>
				</div>
		</div>
		<%}%>
	</div>
</div>


<script type="text/javascript">


				function backsjx(){
						//返回收件箱
						try{
							//location.href='/email/new/MailInBox.jsp?folderid=0&receivemail=false'
							if("<%=userLayout%>"=="3"){
								window.parent.gosjx("1","/email/new/MailInboxList.jsp?folderid=0&receivemail=false","<%=SystemEnv.getHtmlLabelName(19816,user.getLanguage()) %>","<%=SystemEnv.getHtmlLabelName(33212,user.getLanguage()) %>");
							}else{
								window.parent.gosjx("1","/email/new/MailInboxListMain.jsp?folderid=0&receivemail=false","<%=SystemEnv.getHtmlLabelName(19816,user.getLanguage()) %>","<%=SystemEnv.getHtmlLabelName(33212,user.getLanguage()) %>");
							}
						}catch(e){
								//表示用户从--联系人菜单进入，点击用户超链接发送邮件后，点击返回收件箱
								window.location.href='/email/new/MailInBox.jsp?folderid=0&receivemail=false';
						}
				}
				function seejfyj(){
						//查看已发邮件
						try{
								//location.href='/email/new/MailInBox.jsp?folderid=-1'
								if("<%=userLayout%>"=="3"){
									window.parent.gosjx("1","/email/new/MailInboxList.jsp?folderid=-1","<%=SystemEnv.getHtmlLabelName(19558,user.getLanguage()) %>","<%=SystemEnv.getHtmlLabelName(33212,user.getLanguage()) %>");
								}else{
									window.parent.gosjx("1","/email/new/MailInboxListMain.jsp?folderid=-1","<%=SystemEnv.getHtmlLabelName(19558,user.getLanguage()) %>","<%=SystemEnv.getHtmlLabelName(33212,user.getLanguage()) %>");
								}
						}catch(e){
								//表示用户从--联系人菜单进入，点击用户超链接发送邮件后，点击查看已发邮件
								window.location.href='/email/new/MailInBox.jsp?folderid=-1';
						}
				}
				function writemsg(){
						//继续写信
						try{
								window.parent.addTab("1","/email/new/MailAdd.jsp","<%=SystemEnv.getHtmlLabelName(30912,user.getLanguage()) %>");
						}catch(e){
								//表示用户从--联系人菜单进入，点击用户超链接发送邮件后，点击继续写信
								window.location.href='/email/new/MailAdd.jsp';
						}
				}
				function showsendmsg(){
					var dialog = new window.top.Dialog();
					dialog.currentWindow = window;
					var url = "/email/new/MailErrorWin.jsp?mailaccid=<%=mailaccid%>&solution=<%=errorMessInfo.getSolution()%>&errorString=<%=errorMessInfo.getErrorString()%>";
					dialog.Title = "<%=SystemEnv.getHtmlLabelName(25700,user.getLanguage()) %>";
					dialog.Width = 360;
					dialog.Height = 410;
					dialog.Drag = true;
					dialog.URL = encodeURI(url);
					dialog.show();
				
				}
				
				
</script>

<style>
	a:link {text-decoration:underline;}
	.send{
		width: 14px;
		height: 16px;
		top: 1px;
		left:0px;
		position: absolute;
		background-position: -64px 0;
		background-image: url(/email/images/sent_wev8.png)
	}
	
	.out{
		width: 14px;
		height: 16px;
		top: 1px;
		left:0px;
		position: absolute;
		background-position: -32px 0;
		background-image: url(/email/images/sent_wev8.png)
	}
	.in{
		width: 14px;
		height: 16px;
		top: 1px;
		left:0px;
		position: absolute;
		background-position: 0px 0;
		background-image: url(/email/images/sent_wev8.png)
	}
	
	.success{
		width: 50px;
		height: 31px;
		float:left;
		background: url(/email/images/sent_success_wev8.png) no-repeat center center;
	}
	.fail{
		width: 50px;
		height: 31px;
		float:left;
		background: url(/email/images/send_fail_wev8.png) no-repeat center center;
	}
	.failureDesc{
		color:#0D9900;
		height:35px;
		float:left;
	}
	.successDesc{
		color:#0D9900;
		height: 42px;
		float:left;
	}
	.errorDesc{
		color:red;
		margin-top:3px;
	}
	.relative{
		text-align: left;
		
	}
	.errormsg{
		width:400px;
		height:200px;
		overflow:scroll;
	}
</style>