<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsd" class="weaver.conn.RecordSet" scope="page" />
<% if(!HrmUserVarify.checkUserRight("CheckScheme:Performance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18056,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM name=resource id=resource action="CheckSchemeOperation.jsp" method=post>
<input type=hidden name=inserttype value=basic >
   <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="10%"> 
    <COL width="90%"> 
    <TBODY> 
  
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=10%> <COL width=90%> <TBODY> 
          <TR class=title> 
            <TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:1px;"  style="height:1px;"> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(195 ,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=50 size=50 
            name=schemeName  onchange='checkinput("schemeName","nameimage")' >
            <SPAN id=nameimage>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			</SPAN> 
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=50 size=50  maxLength=50 name=memo>
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
         
       
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TD>
            <TD class=Field> 
             <input class=inputstyle type="checkbox" name="status" value="0">
             <!-- 是否起用-->
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
</tr>
</TABLE>
<!--考核对象-->
<table width="100%" class=viewform>
 <COLGROUP> <COL width="10%"> <COL width="70%"> <COL width="10%"><TBODY> 
          <TR class=title> 
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(18057,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:1px;"> 
            <TD class=line1 colSpan=3></TD>
          </TR>
          <tr><td>
          <select class=inputstyle  name=objtype onchange="onChangetype()">
          <option value="0" ><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
          <option value="1" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
          <option value="2"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>
		  <option value="3"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
		</SELECT>
		</td><td colSpan=2><button type="button" class=Browser style="display:none" onClick="onShowResource('hrmName','checkHrmId','showhName')" name=showresource></BUTTON> 
		<button type="button" class=Browser style="display:''" onClick="onShowDepartment('deptName','checkDeptId','showdName')" name=showdepartment></BUTTON> 
		<button type="button" class=Browser style="display:none" onclick="onShowPost('postName','checkPostId','showpName')" name=showPost></BUTTON>
		<button type="button" class=Browser style="display:none" onclick="onShowBranch('branchName','checkBranchId','showbName')" name=showBranch></BUTTON>
		</td></tr>
		<tr>
		<td>
		<span id="showbName"></span>
		<span id="showdName"></span>
		<span id="showpName"></span>
		<span id="showhName"></span>
		</td>
		<td>
		<input type=hidden name="checkDeptId" id="checkDeptId"><input type=hidden name="checkBranchId" id="checkBranchId"><input type=hidden name="checkPostId" id="checkPostId"><input type=hidden name="checkHrmId" id="checkHrmId">
		<span id="branchName"></span>
		<span id="deptName"></span>
		<span id="postName"></span>
		<span id="hrmName"></span>
		
		</td></tr>
          
</table>
<!--查看对象-->
<table width="100%" class=viewform>
 <COLGROUP> <COL width="10%"> <COL width="70%"> <COL width="10%"><TBODY> 
         
          <TR class=title> 
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(18133,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:1px;"> 
            <TD class=line1 colSpan=3></TD>
          </TR>
          <tr><td>
          <select class=inputstyle  name=objtypec onchange="onChangetypec()">
          <option value="0" selected><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%>
          <option value="1" ><%=SystemEnv.getHtmlLabelName(18132,user.getLanguage())%>
          <option value="2"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>
		  <option value="3"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
		</SELECT>
		</td><td colSpan=2>
		<button type="button" class=Browser style="display:none" onClick="onShowResource('hrmNamec','viewHrmId','showhNamec')" name=showresourcec></BUTTON> 
		<button type="button" class=Browser style="display:''" onClick="onShowSup('supNamec','viewSuperiorId','showsNamec','<%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%>')" name=showsuperior></BUTTON> 
		<button type="button" class=Browser style="display:none" onClick="onShowSup('sesupNamec','viewSeSuperiorId','showseNamec','<%=SystemEnv.getHtmlLabelName(18132,user.getLanguage())%>')" name=showsesuperior></BUTTON> 
		<button type="button" class=Browser style="display:none" onclick="onShowPost('postNamec','viewPostId','showpNamec')" name=showPostc></BUTTON>
		</td></tr>
		<tr>
		<td><span id="showsNamec"></span>
		<span id="showseNamec"></span>
		<span id="showpNamec"></span>
		<span id="showhNamec"></span>
		
		</td>
		<td>
		<input type=hidden name="viewSeSuperiorId" id="viewSeSuperiorId">
		<input type=hidden name="viewSuperiorId" id="viewSuperiorId"><input type=hidden name="viewPostId" id="viewPostId"><input type=hidden name="viewHrmId" id="viewHrmId">
		<span id="supNamec"></span>
		<span id="sesupNamec"></span>
		<span id="postNamec"></span>
		<span id="hrmNamec"></span>
		</td></tr>
          
</table>
</FORM>
</td>
<td></td>
</tr>

<tr>
<td height="10" colspan="3"></td>
</tr>
</table>


<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.resource,"schemeName"))
	{	
		document.resource.submit();
		enablemenu();
	}
}
  function onChangetype(){
 
	thisvalue=document.resource.objtype.value;
	if(thisvalue==0){
 		$GetEle("showBranch").style.display='';
		
	}
	else{
		$GetEle("showBranch").style.display='none';
	}
	if(thisvalue==1){
 		$GetEle("showdepartment").style.display='';
		
	}
	else{
		$GetEle("showdepartment").style.display='none';
	}
	if(thisvalue==2){
 		$GetEle("showPost").style.display='';
 		
	}
	else{
		$GetEle("showPost").style.display='none';
	}
	if(thisvalue==3){
 		$GetEle("showresource").style.display='';
		
	}
	else{
		$GetEle("showresource").style.display='none';
		
    }
	
}
function onChangetypec(){
 
	thisvalue=document.resource.objtypec.value;
	if(thisvalue==0){
 		$GetEle("showsuperior").style.display='';
	}
	else{
		$GetEle("showsuperior").style.display='none';
	}
	if(thisvalue==1){
 		$GetEle("showsesuperior").style.display='';
		
	}
	else{
		$GetEle("showsesuperior").style.display='none';
	}
	if(thisvalue==2){
 		$GetEle("showPostc").style.display='';
 		
	}
	else{
		$GetEle("showPostc").style.display='none';
	}
	if(thisvalue==3){
 		$GetEle("showresourcec").style.display='';
		
	}
	else{
		$GetEle("showresourcec").style.display='none';
		
    }
	
}

function onShowResource(spanname,inputename,showname){
    tmpids = $GetEle(inputename).value;
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids);
        if (datas){
	        if(datas.id){
		          resourceids = datas.id;
		          resourcename =datas.name;
		          sHtml = ""
		          resourceidsArr = resourceids.split(",");
		          $GetEle(inputename).value= resourceids.indexOf(",")!=-1?resourceids.substr(1):resourceids;
		          resourcenameAttr = resourcename.split(",");
		          for(var i=0;resourceidsArr&&resourceidsArr.length>i;i++){
			           if(resourceidsArr[i]!=""&&resourceidsArr[i]!=0){
			            sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+resourceidsArr[i]+">"+resourcenameAttr[i]+"</a>&nbsp"
			           }
		          }
		          sHtml = "<button type=\"button\" class=Browser  onClick=onShowResource('"+spanname+"','"+inputename+"','"+showname+"')></BUTTON>"+sHtml;
		          
		          $("#"+spanname).html(sHtml+"<br>");
		         $("#"+showname).html("<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>"+"<br>");
		          
	        }else{
		          $GetEle(spanname).innerHtml ="";
		          $GetEle(inputename).value="";
				  $GetEle(showname).innerHtml ="";
	        }
        }
}


function onShowPost1(spanname,inputename,showname){
	tmpids = $GetEle(inputename).value;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowser.jsp?resourceids="+tmpids)
	
    if (datas){
        if(datas.id){
	          resourceids = datas.id;
	          resourcename =datas.name;
	          sHtml = ""
	          resourceidsArr = resourceids.split(",");
	          $GetEle(inputename).value= resourceids.indexOf(",")!=-1?resourceids.substr(1):resourceids;
	          resourcenameAttr = resourcename.split(",");
	          for(var i=0;resourceidsArr&&resourceidsArr.length>i;i++){
		           if(resourceidsArr[i]!=""&&resourceidsArr[i]!=0){
		            sHtml = sHtml+"<a href=/hrm/jobtitles/HrmJobTitlesEdit.jsp?id="+resourceidsArr[i]+">"+resourcenameAttr[i]+"</a>&nbsp"
		           }
	          }
	          sHtml = "<button type=\"button\" class=Browser  onclick=onShowPost('"+spanname+"','"+inputename+"','"+showname+"')></BUTTON>"+sHtml;
	          
	          $("#"+spanname).html(sHtml+"<br>");
	         $("#"+showname).html("<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>"+"<br>");
	          
        }else{
	          $GetEle(spanname).innerHtml ="";
	          $GetEle(inputename).value="";
			  $GetEle(showname).innerHtml ="";
        }
    }
}


function onShowPost(spanname,inputename,showname){
	tmpids = $GetEle(inputename).value;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiPostBrowser.jsp?resourceids="+tmpids)
    if (datas){
        if(datas.id){
	          resourceids = datas.id;
	          resourcename =datas.name;
	          sHtml = ""
	          resourceidsArr = resourceids.split(",");
	          $GetEle(inputename).value= resourceids.indexOf(",")!=-1?resourceids.substr(1):resourceids;
	          resourcenameAttr = resourcename.split(",");
	          for(var i=0;resourceidsArr&&resourceidsArr.length>i;i++){
		           if(resourceidsArr[i]!=""&&resourceidsArr[i]!=0){
		            sHtml = sHtml+"<a href=/hrm/jobtitles/HrmJobTitlesEdit.jsp?id="+resourceidsArr[i]+">"+resourcenameAttr[i]+"</a>&nbsp"
		           }
	          }
	          sHtml = "<button type=\"button\" class=Browser  onclick=onShowPost('"+spanname+"','"+inputename+"','"+showname+"')></BUTTON>"+sHtml;
	          $("#"+spanname).html(sHtml+"<br>");
	          $("#"+showname).html("<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>"+"<br>");
	          
        }else{
        	   jQuery("#"+spanname).html("");
		 		 jQuery("#"+inputename).attr("value","");
				  jQuery("#"+showname).html("");
        }
    }
}

function onShowDepartment(spanname,inputename,showname){
	tmpids = $GetEle(inputename).value;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser1.jsp?selectedids="+$GetEle(inputename).value+"&selectedDepartmentIds="+tmpids)
	if (datas){
	    if(datas.id){
	          resourceids = datas.id;
	          resourcename =datas.name;
	          sHtml = ""
	          resourceidsArr = resourceids.split(",");
	          $GetEle(inputename).value= resourceids.indexOf(",")!=-1?resourceids.substr(1):resourceids;
	          resourcenameAttr = resourcename.split(",");
	          for(var i=0;resourceidsArr&&resourceidsArr.length>i;i++){
		           if(resourceidsArr[i]!=""&&resourceidsArr[i]!=0){
		            sHtml = sHtml+"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="+resourceidsArr[i]+">"+resourcenameAttr[i]+"</a>&nbsp"
		           }
	          }
	          sHtml = "<button type=\"button\" class=Browser  onclick=onShowDepartment('"+spanname+"','"+inputename+"','"+showname+"')></BUTTON>"+sHtml;
	          
	          $("#"+spanname).html(sHtml+"<br>");
	         $("#"+showname).html("<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>"+"<br>");
	          
	    }else{
	          $GetEle(spanname).innerHtml ="";
	          $GetEle(inputename).value="";
			  $GetEle(showname).innerHtml ="";
	    }
	}
}

function onShowBranch(spanname,inputename,showname){
	tmpids = $GetEle(inputename).value;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+$GetEle(inputename).value+"&selectedDepartmentIds="+tmpids)
	if (datas){
	    if(datas.id){
	          resourceids = datas.id;
	          resourcename =datas.name;
	          sHtml = ""
	          resourceidsArr = resourceids.split(",");
	          $GetEle(inputename).value= resourceids.indexOf(",")!=-1?resourceids.substr(1):resourceids;
	          resourcenameAttr = resourcename.split(",");
	          for(var i=0;resourceidsArr&&resourceidsArr.length>i;i++){
		           if(resourceidsArr[i]!=""&&resourceidsArr[i]!=0){
		            sHtml = sHtml+"<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="+resourceidsArr[i]+">"+resourcenameAttr[i]+"</a>&nbsp"
		           }
	          }
	          sHtml = "<button type=\"button\" class=Browser  onclick=onShowDepartment('"+spanname+"','"+inputename+"','"+showname+"')></BUTTON>"+sHtml;
	          
	          $("#"+spanname).html(sHtml+"<br>");
	         $("#"+showname).html("<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>"+"<br>");
	          
	    }else{
	          $GetEle(spanname).innerHtml ="";
	          $GetEle(inputename).value="";
			  $GetEle(showname).innerHtml ="";
	    }
	}

}

function onShowSup(spanname,inputname,showname,shows){
	if ($GetEle(inputname).value=="0" || $GetEle(inputname).value==""){
		$($GetEle(spanname)).html(" "+"<img src='/images/idelete.gif' style='cursor:hand'  border=0 onClick=onShowSup('"+spanname+"','"+inputname+"','"+showname+"','"+shows+"') ></img>"+"<br>");
		$($GetEle(showname)).html(shows+"<br>");
		$($GetEle(inputname)).val("1");
	}else{
		$($GetEle(spanname)).html("");
		$($GetEle(showname)).html("");
		$($GetEle(inputname)).val("");
	}
}


</script>

</BODY>
</HTML>