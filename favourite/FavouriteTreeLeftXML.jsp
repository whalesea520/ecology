<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.Util,,weaver.hrm.*" %>
<%@ page import="weaver.common.util.xtree.TreeNode" %>

<jsp:useBean id="FavouriteInfo" class="weaver.favourite.FavouriteInfo" scope="page" />

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
%>


<%

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

TreeNode defaultnode=new TreeNode();
String titleName=SystemEnv.getHtmlLabelName(18030 ,user.getLanguage());//"我的收藏"
defaultnode.setTitle(titleName);
defaultnode.setNodeId("field_-1");
defaultnode.setTarget("_self"); 
defaultnode.setIcon("/images/folder.fav_wev8.png");
defaultnode.setHref("javascript:setTreeDocField('-1')");
envelope.addTreeNode(defaultnode);

FavouriteInfo.setUserid(""+user.getUID());
FavouriteInfo.getTreeFavouriteFieldTreeList(envelope,user);

//envelope.marshal(out);
weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>