<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String mailUserName="",mailAddress="",mailUserType="";
%>
<HTML>
<HEAD>
<LINK REL="stylesheet" type="text/css" HREF="/css/Weaver_wev8.css">
<script type="text/javascript">
//rightMenu.style.visibility='hidden'
</script>
</HEAD>

<BODY>
<FORM NAME="SearchForm" style="margin:0" action="MailContacterBrowserMultiSelect.jsp" method="post" target="frame2">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.btnsub.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<BUTTON class=btnSearch accessKey=S style="display:none" id=btnsub ><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<BUTTON class=btnReset accessKey=T style="display:none" type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=O style="display:none" id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<BUTTON class=btnReset accessKey=T style="display:none" id=btncancel><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<table width="100%" class="ViewForm" valign="top">
<tr style="height:1px"><td class="line" colspan="5"></td></tr>
<tbody>
<tr>
<TD height="15" colspan=4 > &nbsp;</TD>
</tr>
<tr>
	<td width=15%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
	<td width=35% class="field"><input type="text" name="mailUserName" value="<%=mailUserName%>" class="inputstyle"/></td>
	<td></td>	
	<td width=15%><%=SystemEnv.getHtmlLabelName(19805,user.getLanguage())%></td>
	<td width=35% class="field"><input type="text" name="mailAddress" value="<%=mailAddress%>" class="inputstyle"/></td>
</tr>
<tr style="height:1px"><td class="line" colspan="5"></td></tr>
<tr>
	<td width=15%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
	<td width=35% class="field">
	<select name="mailUserType">
		<option></option>
		<option value="2" <%if(mailUserType.equals("2")){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
		<option value="3" <%if(mailUserType.equals("3")){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(17129,user.getLanguage())%></option>
		<option value="1" <%if(mailUserType.equals("1")){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(19078,user.getLanguage())%></option>
	</select>
	</td>
	<td></td>
	<td></td>
	<td></td>
</tr>
<tr style="height:1px"><td class="line" colspan="5"></td></tr>
</tbody>
</table>
<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
<input type="hidden" name="resourceids" >
<input type="hidden" name="tabid" value="1">
</form>


  

 
<SCRIPT LANGUAGE=VBS>
resourceids =""
resourcenames = ""

Sub btnclear_onclick()
     window.parent.returnvalue = ""
     window.parent.close
End Sub


Sub btnok_onclick()
	 setResourceStr()
     replaceStr()
     window.parent.returnvalue = resourcenames
    window.parent.close
End Sub

Sub btnsub_onclick()
	setResourceStr() 
    document.all("resourceids").value = Mid(resourceids,2) 
    document.all("tabid").value=1   
    document.SearchForm.submit
End Sub

Sub btncancel_onclick()
     window.close()
End Sub
</SCRIPT>





<script language="javascript">

function setResourceStr(){
	
	var resourceids1 =""
        var resourcenames1 = ""
     try{   
	for(var i=0;i<parent.frame2.resourceArray.length;i++){
		resourceids1 += ","+parent.frame2.resourceArray[i].split("~")[0] ;
		
		resourcenames1 += ","+parent.frame2.resourceArray[i].split("~")[1] ;
	}
	resourceids=resourceids1
	resourcenames=resourcenames1
     }catch(err){}
}

function replaceStr(){
    if(resourcenames.indexOf("@")<0)
    resourcenames="";
    re=new RegExp("[,]+[^,]*[<]","g")
    resourcenames=resourcenames.replace(re,",")
    re=new RegExp("[>]","g")
    resourcenames=resourcenames.replace(re,"")
    re=new RegExp(",[^,@]*,","g")
    resourcenames=resourcenames.replace(re,",")
}

</script>
</BODY>
</HTML>