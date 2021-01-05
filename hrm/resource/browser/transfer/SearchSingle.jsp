<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
</HEAD>
<body>
<%
int uid=user.getUID();
//组合查询不接收条件
String sqlwhere ="";// Util.null2String(request.getParameter("sqlwhere"));
String status ="";// Util.null2String(request.getParameter("status"));
String check_per = Util.null2String(request.getParameter("resourceids"));

String resourceids = "" ;
String resourcenames ="";
if(!check_per.equals("")){
	try{
	String strtmp = "select id,lastname from HrmResource where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while(RecordSet.next()){
		ht.put(RecordSet.getString("id"),RecordSet.getString("lastname"));
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("lastname");
		}
		*/
	}

	StringTokenizer st = new StringTokenizer(check_per,",");

	while(st.hasMoreTokens()){
		String s = st.nextToken();
		resourceids +=","+s;
		resourcenames += ","+ht.get(s).toString();
	}
	}catch(Exception e){
		
	}
}
%>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="Select.jsp" method=post target="frame2">
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
	<BUTTON class=btnSearch accessKey=S style="display:none"  id=btnsub ><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<BUTTON class=btnReset accessKey=T style="display:none" type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=O style="display:none" id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON class=btnReset accessKey=T style="display:none" id=btncancel><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>
<table width=100%  class=ViewForm  valign=top>
<TR class= Spacing><TD class=Line1 colspan=4></TD>
</TR>
<tr>
<TD height="15" colspan=4 > &nbsp;</TD>
</tr>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=lastname ></TD>

<TD width=15%><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
		  <TD width=35% class=field>
			<select class=inputstyle id=status name=status >
			  <option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
			  <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
			  <option value=1 ><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
			  <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
			  <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
			  <option value=4 ><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></option>
              <option value=5 ><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></option>
			  <option value=6 ><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></option>
			  <option value=7 ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>

			</select>
		  </TD>
</tr>
<TR><TD class=Line colSpan=4></TD>
</TR>

<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <BUTTON class=Browser id=SelectSubcompany onclick="onShowSubcompany()"></BUTTON>
        <SPAN id=subcompanyspan></SPAN>
        <INPUT id=subcompanyid type=hidden name=subcompanyid >
      </TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <BUTTON class=Browser id=SelectDepartment onclick="onShowDepartment()"></BUTTON>
        <SPAN id=departmentspan></SPAN>
        <input class=inputstyle type=hidden name=departmentid>
      </TD>
</tr>
<TR><TD class=Line colSpan=4></TD>    
<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
<TD width=35% class=field>
        <input class=inputstyle name=jobtitle maxlength=60 >
      </td>
<td width="15%"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
		<TD width=35% class=field>
        <BUTTON class=Browser id=SelectRole onclick="onShowRole()"></BUTTON>
        <SPAN id=rolespan></SPAN>
        <input class=inputstyle type=hidden name=roleid>
      </TD>

</tr>
<TR><TD class=Line colSpan=4></TD> 
<tr colSpan=4>&nbsp;<tr>
	<tr colSpan=4>&nbsp;<tr>
	<tr colSpan=4>&nbsp;<tr>

    <TR><TD class=Line colSpan=4></TD></TR>

	<TR class=Spacing><TD class=Line1 colspan=4></TD></TR>
</table>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
  <input class=inputstyle type="hidden" name="resourceids" >
  <input class=inputstyle type="hidden" name="tabid" >
	<!--########//Search Table End########-->
	</FORM>
<SCRIPT LANGUAGE=VBS>
resourceids =""
resourcenames = ""

Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub


Sub btnok_onclick()
	 setResourceStr()
     replaceStr()
     window.parent.returnvalue = Array(resourceids,resourcenames)
    window.parent.close
End Sub

Sub btnsub_onclick()
	setResourceStr() 
    document.all("resourceids").value = Mid(resourceids,2) 
    document.all("tabid").value=2   
    document.SearchForm.submit
End Sub

Sub btncancel_onclick()
     window.close()
End Sub

sub onShowDepartment()
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?rightStr=HrmResourceAdd:Add&selectedids="&document.SearchForm.departmentid.value)
	if (Not IsEmpty(id)) then
		if id(0)<> 0 then
			departmentspan.innerHtml = id(1)
			document.SearchForm.departmentid.value=id(0)
            subcompanyspan.innerHtml=""
            document.SearchForm.subcompanyid.value=""
            else
            departmentspan.innerHtml=""
            document.SearchForm.departmentid.value=""
		end if
	end if
end sub

sub onShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=HrmResourceAdd:Add&selectedids="&document.SearchForm.subcompanyid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	subcompanyspan.innerHtml = id(1)
	document.SearchForm.subcompanyid.value=id(0)
    departmentspan.innerHtml=""
    document.SearchForm.departmentid.value=""
    else
    subcompanyspan.innerHtml=""
    document.SearchForm.subcompanyid.value=""
	end if
	end if
end sub

sub onShowRole()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		rolespan.innerHtml = id(1)
		document.SearchForm.roleid.value=id(0)
		else
		rolespan.innerHtml = ""
		document.SearchForm.roleid.value=""
		end if
	end if
end sub
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
    var re=new RegExp("[ ]*[|][^|]*[|]","g")
    resourcenames=resourcenames.replace(re,"|")
    re=new RegExp("[|][^,]*","g")
    resourcenames=resourcenames.replace(re,"")
}    

</script>
</BODY>
</HTML>