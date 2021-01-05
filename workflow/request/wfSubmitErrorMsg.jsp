<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.request.WorkflowRequestMessage" %>
<%@ page import="weaver.common.StringUtil" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONException" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null) return;
String message = request.getParameter("message");
String requestid = request.getParameter("requestid");
String messagecontent = Util.null2String(session.getAttribute("errormsg_"+user.getUID()+"_"+requestid));
if("1021".equals(message)){
	String _fnaBudgetControl_AlertInfo = Util.null2String(session.getAttribute(requestid+"_"+1021)).trim();
	if(!"".equals(_fnaBudgetControl_AlertInfo)){
		messagecontent = _fnaBudgetControl_AlertInfo;
		session.setAttribute(requestid+"_"+1021,"");
	}
}
int formid=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"formid"),0);
String bottom = "";
String details = "";
if(StringUtil.isNotNull(messagecontent)){
	try{
	    JSONObject jo = new JSONObject(messagecontent);
		if(jo.has("details")){
 			details = Util.null2String(jo.getString("details"));
		}
		
		if(jo.has("bottomprefix")){
		    String bottomprefix =  Util.null2String(jo.getString("bottomprefix"));
			int msgurlparm = jo.getInt("msgurlparm");
			int msgtype = jo.getInt("msgtype");
			bottom = WorkflowRequestMessage.getBottomWorkflowInfo(bottomprefix,msgtype,user,msgurlparm);
		}
	}catch(JSONException e){
	    details = messagecontent;
	}
}
%>
<html>
	<head>
		<link type="text/css" href="/css/ecology8/worflowmessage_wev8.css" rel="stylesheet"></link>
		<script type="text/javascript">
			//弹出流程设置窗口
			function resetWorkflow(url,title,type){
				if(type == '3'){
					openFullWindowHaveBar(url);
					return;
				}else if(type == '1'||type =='2'){
					url = "/workflow/request/WFReset.jsp?wfid="+url+"&type="+type;
					title =  '<%=SystemEnv.getHtmlLabelName(33488,user.getLanguage()) %>';
				}
				dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = 1020;
				dialog.Height = 580;
				dialog.Drag = true;
				dialog.maxiumnable = false;
				dialog.URL = url;
				dialog.show();
				
			}
			//生成系统提醒流程
			function triggerSystemWorkflow(prefix,url,title,loginuserid,type){
				prefix = prefix.replace(/~0~/g,"<span class='importantInfo'>");
				prefix = prefix.replace(/~1~/g,"</span>");
				prefix = prefix.replace(/~2~/g,"<span class='importantDetailInfo'>");
				var infohtml = jQuery('.message-detail').html();
				if(!infohtml){
					infohtml = "";
				}else{
					infohtml = "<div class='message-detail'>"+infohtml+"</div>";
				}
				var botfix = "<%=SystemEnv.getHtmlLabelName(126558,user.getLanguage())%>";
				if("<%=SystemEnv.getHtmlLabelName(18913,user.getLanguage())%>" == title){
					botfix="<%=SystemEnv.getHtmlLabelName(126556,user.getLanguage())%>";
				}
				var messagedetail = infohtml + '<span>'+prefix + '，<%=SystemEnv.getHtmlLabelName(126554,user.getLanguage())%><a id="wfSErrorResetBtn" style="color:#2b8ae2!important;" href="'+url+'" title="'+title+'" type="'+type+'"> <%=SystemEnv.getHtmlLabelName(126555,user.getLanguage())%> </a>'+botfix+'</span>';
				var ahtml = jQuery('.message-bottom span').html();
				jQuery('<span> <%=SystemEnv.getHtmlLabelName(126555,user.getLanguage())%> <span>').replaceAll('.message-bottom .sendMsgBtn');
				jQuery.ajax({
					type:'post',
					url:'/workflow/request/TriggerRemindWorkflow.jsp?_'+new Date().getTime()+"=1",
					data:{
						remark:messagedetail,
						loginuserid:loginuserid,
						requestid:'<%=requestid%>'
					},
					error:function (XMLHttpRequest, textStatus, errorThrown) {
						jQuery('.message-bottom span').html(ahtml);
					} , 
				    success:function (data, textStatus) {
				    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126317,user.getLanguage())%>");
				    }
				});
			}
			
			jQuery(document).ready(function(){
					jQuery('.message-detail .condition').each(function(){
						var _a = jQuery(this).attr('index');
						if(!jQuery.isEmptyObject(_a)){
							jQuery(this).hover(
								function(){
									jQuery('#condit'+_a).css('display','block');
									jQuery('#condit'+_a).css('left',window.event.clientX);
								},
								function(){
									jQuery('#condit'+_a).css('display','none');
								}
							);
						}
					});
					<%if(formid == 14){%>
						var url = jQuery('#wfSErrorResetBtn').attr('href');
						var title = jQuery('#wfSErrorResetBtn').attr('title');
						var type = jQuery('#wfSErrorResetBtn').attr('type');
						jQuery('#wfSErrorResetBtn').attr('href','#');
						jQuery('#wfSErrorResetBtn').attr('onclick',"resetWorkflow('"+url+"','"+title+"','"+type+"')");
						jQuery('#wfSErrorResetBtn').removeAttr('target');
						jQuery('#wfSErrorResetBtn').removeAttr('title');
						jQuery('.condition').css('color','#123885!important');
						jQuery("#wfSErrorResetBtn").removeAttr('style');
					<%}%>
			});
			
			
			//重新选择操作者
			function rechoseoperator(){
				var frmmain = jQuery("form[name='frmmain']");
				var eh_dialog = null;
				if(window.top.Dialog)
					eh_dialog = new window.top.Dialog();
				else
					eh_dialog = new Dialog();
				eh_dialog.currentWindow = window;
				eh_dialog.Width = 650;
				eh_dialog.Height = 500;
				eh_dialog.Modal = true;
				eh_dialog.maxiumnable = false;
				eh_dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
				eh_dialog.URL = "/workflow/request/requestChooseOperator.jsp";
				eh_dialog.callbackfun = function(paramobj, datas) {
					frmmain.append('<input type="hidden" name="eh_setoperator" value="y" />');
					frmmain.append('<input type="hidden" name="eh_relationship" value="'+datas.relationship+'" />');
					frmmain.append('<input type="hidden" name="eh_operators" value="'+datas.operators+'" />');
					doSubmitBack();		//模拟提交
				};
				eh_dialog.closeHandle = function(paramobj, datas){
					if(frmmain.find("input[name='eh_setoperator']").size() == 0){
						frmmain.append('<input type="hidden" name="eh_setoperator" value="n" />');
						doSubmitBack();		//模拟提交
					}
				};
				eh_dialog.show();
			}
		</script>	
	</head>
	<body>
		<%if(StringUtil.isNotNull(message)){%>
			<div class="message-box">
				<table>
					<tr>
						<td valign="top">
						 	<div class="message-title-icon"></div>
						 </td>
						 <td>
						 	<div class="message-content">
								 <span class="message-title">
						     	 	<%=WorkflowRequestMessage.getNewMessageId(message,user.getLanguage())%>
						     	 </span>
						     	 <%if(StringUtil.isNotNull(details)){%>
					 		     	 <div class="message-detail">
					     	     		 <%=details %>
							     	 </div>
						     	 <%}%>
						     	 <%if(StringUtil.isNotNull(bottom)){%>
							     	 <div class="message-bottom">
							     		 <span><%=bottom %></span>
							     	 </div>
						     	 <%}%>
					     	 </div>
				     	 </td>
			     	 </tr>
			   	 </table>
			</div>
		<%}%>
	</body>
</html>

				