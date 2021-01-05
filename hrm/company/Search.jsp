<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.appdetach.AppDetachComInfo"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">  
  var dialog = null;
  try{
 		dialog = parent.parent.parent.getDialog(parent.parent);
  }catch(e){ }
 </script>
</HEAD>

<body>
<%
String show_virtual_org = Util.null2String(request.getParameter("show_virtual_org"));
boolean showvirtual = false;
if(!show_virtual_org.equals("-1")&&CompanyVirtualComInfo.getCompanyNum()>0){
	showvirtual = true;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(124,user.getLanguage());
String needfav ="1";
String needhelp ="";
int uid=user.getUID();
String showId = new AppDetachComInfo().getScopeIds(user, "department");
    String departmentmultiOrder = null;

    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if (cks[i].getName().equals("departmentmultiOrder" + uid)) {
            departmentmultiOrder = cks[i].getValue();
            break;
        }
    }

    String rem="1"+departmentmultiOrder.substring(1);
Cookie ck = new Cookie("departmentmultiOrder"+uid,rem);
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

%>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MultiSelect.jsp" method=post target="frame2">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	loadTopMenu = 0; //1-加载头部操作按钮，0-不加载头部操作按钮，主要用于多部门查询框。
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.btnsub.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btnSearch accessKey=S style="display:none"  id=btnsub onclick="btnsub_onclick();" ><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
        <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T style="display:none" type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>

	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>

	<%
	//把window.close() 改成 window.parent.parent.close(); 就解决啦 组合查询 取消按钮不起作用
	//2012-08-15 ypc 修改
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btnReset accessKey=T style="display:none" id=btncancel onclick="btncancel_onclick();"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>


	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden';
</script>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" onclick="document.SearchForm.btnsub.click();" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="4col">
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=deptname size="40"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(22806,user.getLanguage())%></wea:item>
    <wea:item><input class=inputstyle name=deptcode size="40"></wea:item>
   	<%if(showvirtual){ %>
    <wea:item><%=SystemEnv.getHtmlLabelName(34069,user.getLanguage())%></wea:item>
    <wea:item>
    	<select name=virtualtype>
    		<%
    		if(CompanyComInfo.getCompanyNum()>0){
    			CompanyComInfo.setTofirstRow();
    			while(CompanyComInfo.next()){
    		%>
    		<option value="<%=CompanyComInfo.getCompanyid() %>"><%=CompanyComInfo.getCompanyname() %></option>
    		<%} }%>
    		<%
    		CompanyVirtualComInfo.setTofirstRow();
    		while(CompanyVirtualComInfo.next()){
    		%>
    		<option value="<%=CompanyVirtualComInfo.getCompanyid() %>"><%=CompanyVirtualComInfo.getVirtualType() %></option>
    		<%} %>
    	</select>
    </wea:item>
    <%} %>
	</wea:group>
</wea:layout>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="resourceids" >
<input class=inputstyle type="hidden" name="tabid" >
<input type="hidden" name="showId" id="showId" value='<%=showId%>'>
	<!--########//Search Table End########-->
	</FORM>

<SCRIPT type="text/javascript">
resourceids ="";
resourcenames = "";

function btnclear_onclick(){
 			if(dialog){
	  	var returnjson = {id:"", name:""};
	   	try{
          dialog.callback(returnjson);
     }catch(e){}

try{
     dialog.close(returnjson);
 }catch(e){}
	  }else{
	    window.parent.parent.returnValue = {id:"", name:""};
	    window.parent.parent.close();
		}
}


function btnok_onclick(){
	window.parent.frame2.btnok.click();
return;
	 setResourceStr();
    replaceStr();
    var  returnjson = {id:resourceids,name:resourcenames};
    if(dialog){
try{
          dialog.callback(returnjson);
     }catch(e){}

try{
     dialog.close(returnjson);
 }catch(e){}
	  }else{
	    window.parent.parent.returnValue = returnjson;
	    window.parent.parent.close();
		}
}

function btnsub_onclick(){
	setResourceStr();
		$("input[name=resourceids]").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
    $("input[name=tabid]").val(1);
    document.SearchForm.submit();
}

function btncancel_onclick(){
    if(dialog){
	   	dialog.close();
	  }else{
	    window.parent.parent.close();
		}
}

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
    var re=new RegExp("[ ]*[|]*[|]","g")
    resourcenames=resourcenames.replace(re,"|")
    re=new RegExp("[|][^,]*","g")
    resourcenames=resourcenames.replace(re,"")
}

</script>
</BODY>
</HTML>