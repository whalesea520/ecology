
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.social.SocialUtil" %>
<%@ page import="net.sf.json.*" %>
<%
	String msgobjname=Util.null2String(request.getParameter("msgobjname"),"");
	String content=Util.null2String(request.getParameter("content"),"");
	String contentHtml=Util.null2String(request.getParameter("contentHtml"),"");
	String extra=Util.null2String(request.getParameter("extra"),"");
	String favid=Util.null2String(request.getParameter("favid"),"");
	JSONObject extraObj = null;
	if(!extra.equals("")){
		try{
			extraObj = JSONObject.fromObject(extra);
		}catch(Exception e){
			logger.error("来自socialIMFavouriteOp.jsp[extra转换jsonobject失败]:"+e.toString());
		}
	}
	if("FW:richTextMsg".equals(msgobjname)){    //图文
		String url = extraObj.optString("url");
		String imageurl = extraObj.optString("imageurl");
		String image = extraObj.optString("image");
		image = image.replaceAll("\r", "").replaceAll("\n", "").replaceAll("\\s", "+");
		if("".equals(imageurl)){
			imageurl = "data:image/jpg;base64,"+image;
		}
		%>
        <!-- 打开分享 -->
		<div class="textImgMsgItem" title="<%=SystemEnv.getHtmlLabelName(126860, user.getLanguage())%>" style="display: block;" onclick="window.open('<%=url %>', '_blank');">
			<div class="content">
				<div class="imgcot"><img src="<%=imageurl %>" style="max-width:45px;max-height:45px;"></div>
				<div class="textcot ellipsis" style="padding: 9px;cursor: pointer;"><%=content %></div>
			</div>
		</div>
		<%
	}else if("RC:LBSMsg".equals(msgobjname)){   //位置
		String latitude = extraObj.optString("latitude");
		String longitude = extraObj.optString("longitude");
		String poi = extraObj.optString("poi");
		contentHtml = contentHtml.replaceAll("\r", "").replaceAll("\n", "").replaceAll("\\s", "+");
		%>
		<div>
			<div class="locationdiv" onclick="top.ChatUtil.showIMLocation('<%=latitude %>','<%=longitude %>','<%=poi %>')">	
				<img class="locationimg" src="data:image/jpg;base64,<%=contentHtml %>">	
				<div class="locationpoi"><%=poi %></div>
			</div>
		</div>
		<%
	}else if("RC:VcMsg".equals(msgobjname)){    //语音
		contentHtml = contentHtml.replaceAll("\r", "").replaceAll("\n", "").replaceAll("\\s", "+");
		%>
		<div class="chatVoice" onclick="top.ChatUtil.playVoice(this, '<%=contentHtml %>', true, <%=extraObj.optString("duration") %>)">
			<img src="/social/images/chat_voice_l_wev8.png">
		</div>
		<div class="chatVoiceTime"><%=extraObj.optString("duration") %>''</div>
		<%
	}else if("RC:TxtMsg_ding".equals(msgobjname)){  //必达【盯办】
		content = content.replaceAll("\r", "").replaceAll("\n", "<br>");
		%>
		<div style="cursor:pointer;" onclick=""><%=content %></div>
		<%
	}else if("FW:PersonCardMsg".equals(msgobjname)){    //名片
		String userid = favid;
		%>
		<div class="chatCardInfo">
			<div class="left" onclick="viewHrmCard(<%=userid %>)">
				<img src="<%=SocialUtil.getUserHeadImage(userid) %>" class="head35 userimage">
			</div>
			<div class="left" style="margin-left:10px;">
				<div class="hrmName" style="line-height: 19px;cursor:pointer;" onclick="viewHrmCard(<%=userid %>)"><%=SocialUtil.getUserName(userid) %></div>
				<div class="clear"></div>
				<div style="color:#999;line-height: 12px;"><%=SocialUtil.getUserJobTitle(userid) %></div>
			</div>
			<div class="clear"></div>
		</div>
		<%
	}else {
		out.print(content);
	}
	
%>	

<script>

</script>