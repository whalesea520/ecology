<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%> 
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="MobileInit.jsp"%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>
<script type='text/javascript' src='/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js'></script>
</HEAD>

<body>
<%
int uid=user.getUID();
    String resourcemulti = "";

    Cookie[] cks = request.getCookies();

    String rem = "";
	if(resourcemulti.length()>0){
		rem="2"+resourcemulti.substring(1);
	}else{
		rem="2"+resourcemulti;
	}
Cookie ck = new Cookie("resourcemulti"+uid,rem);
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);
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
	<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="/mobile/plugin/browser/MutiResourceSelect.jsp" method=post target="frame2">
	<input type="hidden" name="isinit" value="1"/>
<table width=100%  class=ViewForm  align="top">
<TR class= Spacing style="height:1px;"><TD class=Line1 colspan=4></TD>
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
          <option value="" selected><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
          <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
          <option value=1 ><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
          <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
          <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
          <option value=4 ><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></option>
          <option value=6 ><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></option>
          <option value=7 ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
        </select>
      </TD>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=4></TD>
</TR>

<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <INPUT id=subcompanyid type=hidden name=subcompanyid class="wuiBrowser" _url="HrmOrgTreeBrowser.jsp?browserType=subcompanySingle" 
        	_callBack="$('#departmentidSpan').html('');$('#departmentid').val('');"
        >
      </TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
      <TD width=35% class=field>
      
        <input class=wuiBrowser type=hidden name=departmentid id=departmentid _url="HrmOrgTreeBrowser.jsp?browserType=departmentSingle"
        	_callBack="$('#subcompanyidSpan').html('');$('#subcompanyid').val('');">
      </TD>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=4></TD>    
<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
<TD width=35% class=field>
        <input class=inputstyle name=jobtitle maxlength=60 >
      </td>
<td width="15%"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
		<TD width=35% class=field>
	      
        <input class=wuiBrowser type=hidden name=roleid _url="HrmRolesBrowser.jsp">
      </TD>

</tr>
<TR style="height:1px;"><TD class=Line colSpan=4></TD>  
    
</table>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="resourceids" >
<input class=inputstyle type="hidden" name="tabid"  >
	<!--########//Search Table End########-->
	</FORM>
<script language="javascript">
    jQuery(document).ready(function(){
       jQuery(".wuiBrowser").modalDialog();
    });

	var resourceids =""
	var resourcenames = ""
function reset_onclick(){
	subcompanyspan.innerHtml=""
	departmentspan.innerHtml=""
	rolespan.innerHtml=""
	document.SearchForm.status.value=""
	document.SearchForm.jobtitle.value=""
	document.SearchForm.lastname.value=""
	document.SearchForm.subcompanyid.value=""
	document.SearchForm.departmentid.value=""
	document.SearchForm.roleid.value=""
	document.all("subcompanyid").value=""
	document.all("departmentid").value=""
	document.all("roleid").value=""
}
function btnclear_onclick(){
	window.parent.parent.returnValue = {id:"",name:""};
	window.parent.parent.close();
}

function btnok_onclick(){
	setResourceStr();
	replaceStr();
	window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
	window.parent.parent.close();
	}
function btncancel_onclick(){
     window.close();
}

var resourceids="";
function btnsub_onclick(){
	setResourceStr() ;
	$("input[name=resourceids]").val(resourceids);
    $("input[name=tabid]").val(2);
    var url="/mobile/plugin/browser/MutiResourceSelect.jsp?"+$("#SearchForm").serialize();  
    $("#SearchForm").attr("action",url);
	$("#SearchForm").submit();
}

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