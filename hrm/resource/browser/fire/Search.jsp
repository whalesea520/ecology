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
    String resourcemulti = "";

    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if (cks[i].getName().equals("resourcemulti" + uid)) {
            resourcemulti = cks[i].getValue();
            break;
        }
    }

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
	<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="MultiSelect.jsp" method=post target="frame2">
	<input type="hidden" name="isinit" value="1"/>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.btnsub.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	//td19321
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
	<BUTTON class=btnSearch accessKey=S style="display:none" type="button" onclick="btnsub_onclick()"  id="btnsub" ><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<!--td19321
	<BUTTON class=btnReset accessKey=T style="display:none" type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	-->
	<BUTTON class=btnReset accessKey=T style="display:none" id=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON class=btnReset accessKey=T style="display:none" id=btncancel onclick="btncancel_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>
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
              <option value="" selected ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
              <option value=0 ><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
			  <option value=1 ><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
              <option value=2 ><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
			  <option value=3 ><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></option>
        </select>
      </TD>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=4></TD>
</TR>

<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <INPUT id=subcompanyid type=hidden name=subcompanyid class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp" 
        	_callBack="$('#departmentidSpan').html('');$('#departmentid').val('');"
        >
      </TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
      <TD width=35% class=field>
      
        <input class=wuiBrowser type=hidden name=departmentid id=departmentid _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
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
	      
        <input class=wuiBrowser type=hidden name=roleid _url="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp">
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