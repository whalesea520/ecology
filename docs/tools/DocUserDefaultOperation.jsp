<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<%
String action="";
int id=0;
int userid=0;
String hascreater="";
String hascreatedate="";
String hascreatetime="";
String hasdocid="";
String hascategory="";
String hasreplycount="";
String hasaccessorycount="";
String hasoperate = "";
int numperpage=0;
String selectedcategory="";
String useUnselected="";
String commonuse = "";
String[] value;
for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
	value=request.getParameterValues((String) En.nextElement());
	for(int i=0;i<value.length;i++){
	value[i]=Util.null2String(value[i]);
	if(value[i].indexOf("M")!=-1||value[i].indexOf("S")!=-1){
		if (selectedcategory.equals("")){
			selectedcategory+=value[i];
			}
		else{
			selectedcategory+="|"+value[i];
			}
	}
	}
}

id=Util.getIntValue(request.getParameter("id"),0);
userid=user.getUID();
hascreater=Util.null2String(request.getParameter("hascreater"));
hascreatedate=Util.null2String(request.getParameter("hascreatedate"));
hascreatetime=Util.null2String(request.getParameter("hascreatetime"));
hasdocid=Util.null2String(request.getParameter("hasdocid"));
hascategory=Util.null2String(request.getParameter("hascategory"));
hasreplycount=Util.null2String(request.getParameter("hasreplycount"));
hasaccessorycount=Util.null2String(request.getParameter("hasaccessorycount"));
hasoperate=Util.null2String(request.getParameter("hasoperate"));
numperpage=Util.getIntValue(request.getParameter("numperpage"),10);
useUnselected = Util.null2String(request.getParameter("useUnselected"));
commonuse = Util.null2String(request.getParameter("commonuse"));

if(id==0){
	action="insert";}
else{
	action="update";}

if (hascreater.equals("")){
	hascreater="0";}
else{
	hascreater="1";}

if (hascreatedate.equals("")){
	hascreatedate="0";}
else{
	hascreatedate="1";}

if (hascreatetime.equals("")){
	hascreatetime="0";}
else{
	hascreatetime="1";}

if (hasdocid.equals("")){
	hasdocid="0";}
else{
	hasdocid="1";}

if (hascategory.equals("")){
	hascategory="0";}
else{
	hascategory="1";}

if (hasreplycount.equals("")){
	hasreplycount="0";}
else{
	hasreplycount="1";}

if (hasaccessorycount.equals("")){
	hasaccessorycount="0";}
else{
	hasaccessorycount="1";}
if (hasoperate.equals(""))
{
	hasoperate="0";
}
else
{
	hasoperate="1";
}

if (numperpage==0){
	numperpage=10;}

if(commonuse.equals("")){
	commonuse = "-1";
}
UserDefaultManager.setId(id);
UserDefaultManager.setUserid(userid);
UserDefaultManager.setHascreater(hascreater);
UserDefaultManager.setHascreatedate(hascreatedate);
UserDefaultManager.setHascreatetime(hascreatetime);
UserDefaultManager.setHasdocid(hasdocid);
UserDefaultManager.setHascategory(hascategory);
UserDefaultManager.setHasreplycount(hasreplycount);
UserDefaultManager.setHasaccessorycount(hasaccessorycount);
UserDefaultManager.setHasoperate(hasoperate);
UserDefaultManager.setNumperpage(numperpage);
UserDefaultManager.setSelectedcategory(selectedcategory);
UserDefaultManager.setAction(action);
UserDefaultManager.setUseunselected(useUnselected);
UserDefaultManager.setCommonuse(commonuse);
UserDefaultManager.updateUserDefault();
response.sendRedirect("/docs/tools/DocUserDefault.jsp?saved=true");
%>
