
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.outter.OutterDisplayHelper"%>
<%@ include file="/page/element/viewCommon.jsp"%>
<%@ include file="common.jsp" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@page import="java.util.ArrayList"%>

<HTML>
<body>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<%


String disouttyName = "";
String disouttyimag = "";
String displaytype ="";
String displayLayout = "";
/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 start*/
//int dislength =0;
/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 end*/
int pageNum=10;
disouttyName=Util.null2String(valueList.get(nameList.indexOf("displayName")));
disouttyimag=Util.null2String(valueList.get(nameList.indexOf("displayimag")));
displaytype=Util.null2String(valueList.get(nameList.indexOf("displaytype")));
displayLayout=Util.null2String(valueList.get(nameList.indexOf("displaylayout")));
/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 start*/
//dislength=Util.getIntValue(Util.null2String(valueList.get(nameList.indexOf("displayNamelen"))),0);
/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 end*/

//pageNum=Util.getIntValue(hpec.getPerpage(eid),0);
//System.out.println("disouttyName=="+disouttyName);
//System.out.println("disouttyimag=="+disouttyimag);
//System.out.println("displaytype=="+displaytype);
//System.out.println("displayLayout=="+displayLayout);
//System.out.println("dislength=="+dislength);

//disouttyName="0";
//disouttyimag="1";
//displaytype="2";
//displayLayout="3";
//dislength=2;
//pageNum=2;

String sql="";
RecordSet rs=new RecordSet();
sql="select perpage,linkmode,showfield,sharelevel from hpElementSettingDetail where eid="+eid+" and userid="+userid+" and usertype="+usertype;	
rs.executeSql(sql);

if(rs.next()){
pageNum=Util.getIntValue(rs.getString("perpage"),10);
}else{
	sql="select perpage,linkmode,showfield,sharelevel from hpElementSettingDetail where eid="+eid;	
    rs.executeSql(sql);
	if(rs.next()){
       pageNum=Util.getIntValue(rs.getString("perpage"),10);
    }
}
//得到有权限查看的集成登录
OutterDisplayHelper ohp=new OutterDisplayHelper();
String sqlright=ohp.getShareOutterSql(user);
sql="select * from outter_sys a where EXISTS (select 1 from ("+sqlright+") b where a.sysid=b.sysid )";
//sql="select * from outter_sys where sysid in ("+sqlright+")";

//System.out.println("sql=="+sql);
//System.out.println("pageNum=="+pageNum);
rs.executeSql(sql);
//System.out.println("count=="+rs.getCounts());

int i=0;
 

%>

<TABLE width="100%" cellpadding="0" cellspacing="0" >
<colgroup>
<%if(displayLayout.equals("1")){%>
<col width="100%">
<%}
else if(displayLayout.equals("2")){%>
<col width="50%">
<col width="50%">
<%}else if(displayLayout.equals("3")){%>
<col width="33%">
<col width="33%">
<col width="33%">
<%}%>

<%
String defaultimag="/page/element/outterSys/resource/image/outterdefaultimag.png";
if(displayLayout.equals("1")){
while(rs.next()){
if(i<pageNum){
String urllinkimagid=Util.null2String(rs.getString("urllinkimagid"));
String sysid=Util.null2String(rs.getString("sysid"));
String name=Util.null2String(rs.getString("name"));
String imagewidth=Util.null2String(rs.getString("imagewidth"));
String imageheight=Util.null2String(rs.getString("imageheight"));
if(imagewidth.equals("")||imagewidth.equals("0")){
	imagewidth="32";
}
if(imageheight.equals("")||imageheight.equals("0")){
	imageheight="32";
}
String disname=name;

String link="/interface/Entrance.jsp?id="+sysid;
String imagelink="";
if(urllinkimagid.equals("")||urllinkimagid.equals("0")){
imagelink=defaultimag;
}else{
imagelink="/weaver/weaver.file.FileDownload?fileid="+urllinkimagid;
}

out.println("<tr>");

if(displaytype.equals("1")){
	out.println("<td align=left>");
}else{
	out.println("<td align=center>");

}

if(disouttyName.equals("1")){
/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 start*/	
/*if(dislength>0&&name.length()>dislength){
name=name.substring(0,dislength);
}else{
int temp=dislength-name.length();

name=ohp.stringFill(name,name.length()+temp/2,' ',true);
name=ohp.stringFill(name,name.length()+temp/2,' ',false);
}*/
/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 end*/
if(disouttyimag.equals("1")){
String discontent="";
if(displaytype.equals("1")){  //
discontent=ohp.getleftToRightimageHtml(name,link,imagelink,disname,imagewidth,imageheight);
}else{
discontent=ohp.getUpToDownimageHtml(name,link,imagelink,disname,imagewidth,imageheight);
}
%>
<%=discontent%>
<%
}
else{
%>
<%=ohp.getNameHtml(name,link,disname)%>
<%
}

}else{  //no name



if(disouttyimag.equals("1")){

%>
<%=ohp.getimageHtml(name,link,imagelink,imagewidth,imageheight)%>
<%
}

} 
//=============

 
%>
</td>
</tr>
<%

}else{
break;
}
i++;

}
}

else if(displayLayout.equals("2")){


while(rs.next()){
int num1=i/2;
int num2=i%2;

if(num2==0){

out.println("<tr>");
}
if(i<pageNum){
String urllinkimagid=Util.null2String(rs.getString("urllinkimagid"));
String sysid=Util.null2String(rs.getString("sysid"));
String name=Util.null2String(rs.getString("name"));
String imagewidth=Util.null2String(rs.getString("imagewidth"));
String imageheight=Util.null2String(rs.getString("imageheight"));
if(imagewidth.equals("")||imagewidth.equals("0")){
	imagewidth="32";
}
if(imageheight.equals("")||imageheight.equals("0")){
	imageheight="32";
}
String disname=name;
String link="/interface/Entrance.jsp?id="+sysid;
String imagelink="";
if(urllinkimagid.equals("")||urllinkimagid.equals("0")){
imagelink=defaultimag;
}else{
imagelink="/weaver/weaver.file.FileDownload?fileid="+urllinkimagid;
}
if(displaytype.equals("1")){
	out.println("<td align=left>");
}else{
	out.println("<td align=center>");

}

if(disouttyName.equals("1")){
/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 start*/	
/*if(dislength>0&&name.length()>dislength){
name=name.substring(0,dislength);
}else{
int temp=dislength-name.length();

name=ohp.stringFill(name,name.length()+temp/2,' ',true);
name=ohp.stringFill(name,name.length()+temp/2,' ',false);
}*/
/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 end*/
if(disouttyimag.equals("1")){
String discontent="";
if(displaytype.equals("1")){  //
discontent=ohp.getleftToRightimageHtml(name,link,imagelink,disname,imagewidth,imageheight);
}else{
discontent=ohp.getUpToDownimageHtml(name,link,imagelink,disname,imagewidth,imageheight);
}
%>
<%=discontent%>
<%
}
else{
%>
<%=ohp.getNameHtml(name,link,disname)%>
<%
}

}else{  //no name



if(disouttyimag.equals("1")){

%>
<%=ohp.getimageHtml(name,link,imagelink,imagewidth,imageheight)%>
<%
}

} 
//=============


out.println("</td>");


}else{
break;
}

if(num2==1){
out.println("</tr>");

}
i++;

}
}

else if(displayLayout.equals("3")){


while(rs.next()){
int num1=i/3;
int num2=i%3;
if(num2==0){%>
<tr>
<% 
}
if(i<pageNum){
String urllinkimagid=Util.null2String(rs.getString("urllinkimagid"));
String sysid=Util.null2String(rs.getString("sysid"));
String name=Util.null2String(rs.getString("name"));
String imagewidth=Util.null2String(rs.getString("imagewidth"));
String imageheight=Util.null2String(rs.getString("imageheight"));
if(imagewidth.equals("")||imagewidth.equals("0")){
	imagewidth="32";
}
if(imageheight.equals("")||imageheight.equals("0")){
	imageheight="32";
}
String disname=name;
String link="/interface/Entrance.jsp?id="+sysid;
String imagelink="";
if(urllinkimagid.equals("")||urllinkimagid.equals("0")){
imagelink=defaultimag;
}else{
imagelink="/weaver/weaver.file.FileDownload?fileid="+urllinkimagid;
}


if(displaytype.equals("1")){
	out.println("<td align=left>");
}else{
	out.println("<td align=center>");

}

if(disouttyName.equals("1")){
/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 start*/	
//System.out.println("=dislength=="+dislength);
/*if(dislength>0&&name.length()>dislength){
name=name.substring(0,dislength);
}else{
int temp=dislength-name.length();
name=ohp.stringFill(name,name.length()+temp/2,' ',true);
name=ohp.stringFill(name,name.length()+temp/2,' ',false);
}*/
/*QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 end*/

if(disouttyimag.equals("1")){
String discontent="";
if(displaytype.equals("1")){  //
discontent=ohp.getleftToRightimageHtml(name,link,imagelink,disname,imagewidth,imageheight);
}else{
discontent=ohp.getUpToDownimageHtml(name,link,imagelink,disname,imagewidth,imageheight);
}
%>
<%=discontent%>
<%
}
else{
%>
<%=ohp.getNameHtml(name,link,disname)%>
<%
}

}else{  //no name



if(disouttyimag.equals("1")){

%>
<%=ohp.getimageHtml(name,link,imagelink,imagewidth,imageheight)%>
<%
}

} 
//=============

 
%>
</td>

<%

}else{
break;
}

if(num2==2){%>
</tr>
<%
}
i++;
}
}
out.println("</TABLE>");


%>
</body>
</html>

