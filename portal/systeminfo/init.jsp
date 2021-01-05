<%@ page import="weaver.portal.login.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%
User user = UserVarify.getUser (request , response) ;
if(user == null)  return ;
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
</script>