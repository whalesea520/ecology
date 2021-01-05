<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.mobile.ding.MobileDing"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.mobile.ding.DingReply"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="MobileDingService" class="weaver.mobile.ding.MobileDingService" scope="page" />
<%
String userid=""+user.getUID();
FileUpload fu = new FileUpload(request);

String datatype=Util.null2String(fu.getParameter("datatype"));
String content=Util.null2String(fu.getParameter("content"));
String pageno=Util.null2String(fu.getParameter("pageno"));
String pagesize=Util.null2String(fu.getParameter("pagesize"));
Map<String, Object> result = MobileDingService.getMobileDingList(userid,datatype,content,Integer.parseInt(pageno),Integer.parseInt(pagesize));
List<MobileDing> bingList= (List<MobileDing>)result.get("dataList");
boolean isHasNext = (Boolean)result.get("isHasNext");
//session.setAttribute("isHasNext", isHasNext);
if(bingList.size()>0){ 
for(int i=0;i<bingList.size();i++){
	MobileDing ding=bingList.get(i);
	String dingid=ding.getId();
	String senderid=ding.getSendid();
	String tempcontent=ding.getContent();
	tempcontent=tempcontent.replaceAll("\r\n","<br>").replaceAll("\r","<br>").replaceAll("\n","<br>");
	String createtime=ding.getOperateDate();
	List<DingReply> replyList=ding.getDingReplys();
	//if(datatype.equals("send")&&!senderid.equals(userid)) continue;
	//if(datatype.equals("receive")&&senderid.equals(userid)) continue;
	boolean isConfirm=MobileDingService.getDingIsConfirm(dingid,userid);
	boolean isReceiver=MobileDingService.getIsReceiver(dingid,userid);
	boolean isSender=senderid.equals(userid);
	boolean isNeedConfirm=false;
	if(!isSender){
		if(!isConfirm) isNeedConfirm=true;
	}else{
		if(isReceiver&&(datatype.equals("all")||datatype.equals("receive"))){
			if(!isConfirm) isNeedConfirm=true;
		}
	}
	boolean isOk=isConfirm&&(datatype.equals("all")||datatype.equals("receive"));
	int unConfirmTotal=MobileDingService.getDingUnConfirmCount(dingid);
%>
	<div id="bing_<%=dingid%>" onclick="viewDing(this)" class="bitem" _dingid="<%=dingid%>" _isHasNext="<%=isHasNext %>" _isNeedConfirm="<%=isNeedConfirm?"1":"0"%>" style="position:relative;">
  		<%if(isNeedConfirm){%>
  			<div class="bnew"></div>
  		<%}%>
  		<div class="btitle"><%=tempcontent%></div>
  		<div class="btime"><%=SocialUtil.getUserName(senderid)+" "+createtime%></div>
  		<div class="m-t-5">
  		
  			<div class="bcomment" style="display:<%=!isNeedConfirm?"":"none"%>"><%=replyList.size()==0?SystemEnv.getHtmlLabelName(127012, user.getLanguage()):replyList.size()%></div><!-- 点击到详细页回复 -->
  			<%if(isOk){%>
        		<div class="bok"></div>
  			<%}
  			if(isNeedConfirm){%>
  				<div class="btn2 right" onclick="doConfirm(this)" style="width:68px;margin-right:5px;"><%=SystemEnv.getHtmlLabelName(127013, user.getLanguage())%></div><!-- 确认收到 -->
  			<%}else if(isSender&&!isOk){%>
  				<div class="confirmstatus"><%=unConfirmTotal==0?SystemEnv.getHtmlLabelName(127009, user.getLanguage()):unConfirmTotal+SystemEnv.getHtmlLabelName(127008, user.getLanguage())%></div><!-- 全部确认   人未确认  -->
  			<%}%>
  			<div class="clear"></div>

  		</div>
  	</div>
<%}
}else{%>
	<div class="nodata1">
		<div style="margin-top:200px;">
			<img src="/rdeploy/address/img/noinfos_wev8.png">
		</div>
		<div style="color:#E4E4E4;margin-top:20px;font-size:16px;"><%=SystemEnv.getHtmlLabelName(84304, user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(126359, user.getLanguage())%></div><!-- 暂无必达 -->
	</div>
<%}%>
