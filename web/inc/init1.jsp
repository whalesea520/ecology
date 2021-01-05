<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj" %>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
User user = new User() ;
user = HrmUserVarify.checkUser(request , response) ;
int userid = 0;
int language = 7;
String logintype = "2";
if (user==null)
{
user = new User() ;
user.setUid(0);
user.setLanguage(7);
user.setLogintype("2");
user.setType(1);
user.setSeclevel("0");
}
else
{
 userid = user.getUID();
 logintype = user.getLogintype();
 language = user.getLanguage() ;
}


%>
<script language=javascript>
function check_form(thiswins,items)
{
	thiswin = thiswins
	items = items + ",";
	
	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	
	if(tmpname!="" &&items.indexOf(tmpname+",")!=-1 && tmpvalue == ""){
		 alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
		 return false;
		}

	}
	return true;
}

function isdel(){
   if(!confirm("确定要删除吗？")){
       return false;
   }
       return true;
   } 


function issubmit(){
   if(!confirm("确定要提交吗？")){
       return false;
   }
       return true;
   } 
</script>


<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
</HEAD></HTML>