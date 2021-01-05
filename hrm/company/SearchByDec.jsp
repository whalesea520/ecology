<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
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
String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=Util.fromScreen(request.getParameter("f_weaver_belongto_usertype"),user.getLanguage());
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(124,user.getLanguage());
String needfav ="1";
String needhelp ="";
int uid=user.getUID();
    String departmentmultiDecOrder = "";

    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if (cks[i].getName().equals("departmentmultiDecOrder" + uid)) {
            departmentmultiDecOrder = Util.null2String(cks[i].getValue());
            break;
        }
    }
    if(departmentmultiDecOrder.length()>0){
    String rem="1"+departmentmultiDecOrder.substring(1);
Cookie ck = new Cookie("departmentmultiDecOrder"+uid,rem);
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);}

%>
	<FORM NAME="SearchForm" STYLE="margin-bottom:0" action="MultiSelect.jsp" method="post" target="frame2">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.btnsearch.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btnSearch accessKey=S style="display:none"  id=btnsearch onclick="btnsearch_onclick();"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
        <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T style="display:none" type=reset ><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>

	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self}";
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<!-- 2012-08-15 ypc 修改 添加了btnok_onclick() 事件 -->
	<BUTTON class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>

	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self}";
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btnReset accessKey=T style="display:none" id="btncancel"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>


	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<!-- 2012-08-15 ypc 修改 添加了btnclear_onclick() 事件 -->
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" onclick="document.SearchForm.btnsearch.click();" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=deptname size="40"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(22806,user.getLanguage())%></wea:item>
    <wea:item><input class=inputstyle name=deptcode size="40"></wea:item>
	</wea:group>
</wea:layout>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="resourceids" >
  	<input type="hidden" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>"/>
	<input type="hidden" name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype %>"/>
<input class=inputstyle type="hidden" name="tabid" >
	<!--########//Search Table End########-->
	</FORM>
<!--
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
    document.all("tabid").value=1
    document.SearchForm.submit
End Sub

Sub btncancel_onclick()
     window.close()
End Sub
</SCRIPT>  -->

<script language="javascript">
//2012-08-15 ypc  添加此函数
var resourceids ="";
var resourcenames = "";
function btnsub_onclick1(){
	setResourceStr();
    $G("resourceids").value = resourceids.substr(1);
    $("input[name=tabid]").val(1); //把这个val(2) 改为val(1) 就可以解决掉 搜索之后搜索按钮不见了的问题 2012-08-15 ypc 修改
    document.SearchForm.submit();
}

//2012-08-15 ypc  添加此函数
function btnsearch_onclick(){
	setResourceStr();
	$("input[name=resourceids]").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
	$("input[name=tabid]").val(1); 
	$("#SearchForm").submit();
}

//2012-08-15 ypc 添加 原因是：本页面的 确定右键菜单的 事件处理是用vbs编写的 在Google和火狐是不能解析的 所以改为js
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

function btncancel_onclick(){
    if(dialog){
	   	dialog.close();
	  }else{
	    window.parent.parent.close();
		}
}
//2012-08-15 ypc 添加 原因是：本页面的 确定右键菜单的 事件处理是用vbs编写的 在Google和火狐是不能解析的 所以改为js end
function btnok_onclick(){
	window.parent.frame2.btnok.click();
return;
	setResourceStr();
    replaceStr();
   if(dialog){
	  	var returnjson = {id:resourceids,name:resourcenames};
try{
          dialog.callback(returnjson);
     }catch(e){}

try{
     dialog.close(returnjson);
 }catch(e){}
	  }else{
	    window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
	    window.parent.parent.close();
		}
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

function onShowSubcompany(){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+jQuery("#subcompanyid").val());
	if(results){
		if (results.id!="" ){
			subcompanyspan.innerHTML =results.name;
			$G("subcompanyid").value=results.id;
		    $G("departmentspan").innerHTML="";
		    $G("departmentid").value="";
		}
		else{
			subcompanyspan.innerHTML ="";
			$G("subcompanyid").value="";
		}
	}
}
function onShowDepartment(){
    var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+jQuery("#departmentid").val());
	if (results){
		if (results.id!="") {
				departmentspan.innerHTML =results.name;
				document.SearchForm.departmentid.value=results.id;
				subcompanyspan.innerHTML="";
				document.SearchForm.subcompanyid.value="";
			}
            else{
				departmentspan.innerHTML="";
				document.SearchForm.departmentid.value="";
			}
	}
}

function onShowRole(){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if(results){
	     if (results.id!= "" ){
			rolespan.innerHTML=results.name;
			document.SearchForm.roleid.value=results.id;
		}
		else{
			rolespan.innerHTML=results.name;
			document.SearchForm.roleid.value="";
		}
	}
}
</script>
</BODY>
</HTML>
