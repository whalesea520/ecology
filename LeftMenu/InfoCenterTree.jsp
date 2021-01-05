<%@ page language="java" contentType="text/xml ; charset=UTF-8" %><%@ page import="java.util.*,java.lang.reflect.Method" %><%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*" %><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/><%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragrma","no-cache");
	response.setDateHeader("Expires",0);
	User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
String s="<?xml version=\"1.0\" encoding=\"UTF-8\"?><tree>";
LeftMenuConfigHandler leftMenuConfigHandler = new LeftMenuConfigHandler();
HashMap leftMenuConfigMapping = leftMenuConfigHandler.getLeftMenuConfig(user.getUID());
ArrayList visibleSubLevelLeftMenus = (ArrayList)leftMenuConfigMapping.get(new Integer(111));

if(visibleSubLevelLeftMenus!=null){
	for(int j=0;j<visibleSubLevelLeftMenus.size();j++){
		LeftMenuConfig subConfig = (LeftMenuConfig)visibleSubLevelLeftMenus.get(j);
		LeftMenuInfo subInfo = subConfig.getLeftMenuInfo();
		int subLevelId = subInfo.getId();
		int subLabelId = subInfo.getLabelId();
		String subName = subInfo.getName(user.getLanguage());
		String iconUrl = subInfo.getIconUrl();
		String linkAddress = subInfo.getLinkAddress();
		if(linkAddress.indexOf("<")!=-1){
			linkAddress = Util.replaceRange(linkAddress,"<",">",String.valueOf(user.getUID()),false);
		}
		if(subLevelId==118){	//新闻公告
			s += "<tree text=\""+subName+"\" action=\""+linkAddress+"\" icon=\""+iconUrl+"\" src=\"/LeftMenu/InfoCenterTreeTypes.jsp\" />";
		}else if(subLevelId==119){	//网上调查
			s += "<tree text=\""+subName+"\" action=\""+linkAddress+"\" icon=\""+iconUrl+"\" src=\"/LeftMenu/InfoCenterTreeVoting.jsp\" />";
		}else if(subLevelId==115){ //提醒信息(for xwj)
            s += "<tree text=\""+subName+"\" action=\""+linkAddress+"\" icon=\""+iconUrl+"\" src=\"/LeftMenu/InfoCenterTreeRemind.jsp\" />";
		}else{
			s += "<tree text=\""+subName+"\" action=\""+linkAddress+"\" icon=\""+iconUrl+"\" />";
		}
	}
}
out.print(s+"</tree>");
%>