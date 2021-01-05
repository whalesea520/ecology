<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsd" class="weaver.conn.RecordSet" scope="page" />
<% if(!HrmUserVarify.checkUserRight("PointRule:Performance",user)) {
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
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(15610,user.getLanguage());
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

<FORM name=resource id=resource action="RuleOperation.jsp" method=post>
<input type=hidden name=inserttype value=detail >
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
          <TR class=spacing style="height:1px;"> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(195 ,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=50 size=50 
            name=ruleName  onchange='checkinput("ruleName","nameimage")' >
            <SPAN id=nameimage>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			</SPAN> 
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18075,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=50 size=50  maxLength=50 name=memo>
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18125,user.getLanguage())%></TD>
            <TD class=Field> 
              <button type="button" class=Browser style="display:''" onClick="onShowFormula()" name=showdformula></BUTTON> 
              <span id="formulas"></span>
              <input type="hidden" name="formula" id="formula">
              <input type="hidden" name="formulasum" id="formulasum">
              <SPAN id=fimage>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			</SPAN> 
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TD>
            <TD class=Field> 
                  <button type="button" class=Browser style="display:''" onClick="onShowCon()" name=showcon></BUTTON> 
              <span id="cons"></span>
              <input type="hidden" name="conditions" id="conditions">
               <input type="hidden" name="conditionsum" id="conditionsum">
              <SPAN id=cimage>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			</SPAN> 
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
<!--适用对象-->
<table width="100%" class=viewform>
 <COLGROUP> <COL width="10%"> <COL width="70%"> <COL width="10%"><TBODY> 
          <TR class=title> 
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(18126,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:1px;"> 
            <TD class=line1 colSpan=3></TD>
          </TR>
          <tr><td>
          <select class=inputstyle  name=objtype onchange="onChangetype()">
          <!-- option value="1" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option-->
          <option value="2"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
		  <option value="3"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
		</SELECT>
		</td><td colSpan=2>
		<button type="button" class=Browser style="display:none" onClick="onShowResource('hrmName','hrmId','showhName')" name=showresource></BUTTON> 
		<!--计算过于复杂，暂时取消-->
		<!-- BUTTON class=Browser style="display:''" onClick="onShowDepartment('deptName','deptId','showdName')" name=showdepartment></BUTTON-->
		 
		<button type="button" class=Browser style="display:''" onclick="onShowPost('postName','postId','showpName')" name=showPost></BUTTON>
		</td></tr>
		<tr>
		<td><span id="showdName"></span>
		<span id="showpName"></span>
		<span id="showhName"></span>
		</td>
		<td>
		<input type=hidden name="deptId" id="deptId"><input type=hidden name="postId" id="postId"><input type=hidden name="hrmId" id="hrmId">
		<span id="deptName"></span>
		<span id="postName"></span>
		<span id="hrmName"></span>
		</td></tr>
          
</table>
<!--条件对象-->
<table width="100%" class=viewform>
 <COLGROUP> <COL width="10%"> <COL width="70%"> <COL width="10%"><TBODY> 
           <TR class=spacing style="height:1px;"> 
            <TD class=line1 colSpan=3></TD>
          </TR>
          <TR class=title> 
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(18127,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:1px;"> 
            <TD class=line1 colSpan=3></TD>
          </TR>
          <tr><td>
          <select class=inputstyle  name=objtypec onchange="onChangetypec()">
          <!-- option value="1" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option-->
          <option value="2"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
		  <option value="3"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
		</SELECT>
		</td><td colSpan=2>
		<button type="button" class=Browser style="display:none" onClick="onShowResource('hrmNamec','formulaHrmId','showhNamec')" name=showresourcec></BUTTON> 
		<!--计算过于复杂，暂时取消-->
		<!-- BUTTON class=Browser style="display:''" onClick="onShowDepartment('deptNamec','formulaDeptId','showdNamec')" name=showdepartmentc></BUTTON--> 
		<button type="button" class=Browser style="display:''" onclick="onShowPost('postNamec','formulaPostId','showpNamec')" name=showPostc></BUTTON>
		</td></tr>
		<tr>
		<td><span id="showdNamec"></span>
		<span id="showpNamec"></span>
		<span id="showhNamec"></span>
		</td>
		<td>
		<input type=hidden name="formulaDeptId" id="formulaDeptId"><input type=hidden name="formulaPostId" id="formulaPostId"><input type=hidden name="formulaHrmId" id="formulaHrmId">
		<span id="deptNamec"></span>
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
    if(check_form(document.resource,"ruleName,conditions,formula"))
	{	
		document.resource.submit();
	}
}
  function onChangetype(){
 
	thisvalue=document.resource.objtype.value;
	/**
	if(thisvalue==1){
 		$GetEle("showdepartment").style.display='';
		
	}
	else{
		$GetEle("showdepartment").style.display='none';
	}
	*/
	if(thisvalue==2){
 		$($GetEle("showPost")).show();
 		
	}
	else{
		$($GetEle("showPost")).hide();
	}
	if(thisvalue==3){
 		$($GetEle("showresource")).show();
		
	}
	else{
		$($GetEle("showresource")).hide();
		
    }
	
}
function onChangetypec(){
 
	thisvalue=document.resource.objtypec.value;
	
	/**
	if(thisvalue==1){
 		$GetEle("showdepartmentc").style.display='';
		
	}
	else{
		$GetEle("showdepartmentc").style.display='none';
	}
	*/
	if(thisvalue==2){
 		$($GetEle("showPostc")).show();
	}
	else{
		$($GetEle("showPostc")).hide();
	}
	if(thisvalue==3){
		$($GetEle("showresourcec")).show();
	}
	else{
		$($GetEle("showresourcec")).hide();
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

</script>
<SCRIPT type="text/javascript">

	

function onShowFormula(){

  datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/pointRule/formula.jsp");
  if (datas){
        if(datas.id!=""){ 
           $("#formulas").html(datas.name);
		   $("#formulasum").val(datas.name);
           $("#formula").val(datas.id);
           $("#fimage").html("");
        }else{
        	 $("#formulas").html("");
  		   	$("#formulasum").val("");
             $("#formula").val("");
             $("#fimage").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
        }
  }
}
function onShowCon(){

 datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/pointRule/conditions.jsp")
   
  if (datas){
        if(datas.id){
           $($GetEle("cons")).html(datas.name);
           $($GetEle("conditions")).val(datas.id);
		   $($GetEle("conditionsum")).val(datas.name);
           $($GetEle("cimage")).html("");
        } else{
        	$($GetEle("cons")).html(datas.name);
            $($GetEle("conditions")).val(datas.id);
 		    $($GetEle("conditionsum")).val(datas.name);
            $($GetEle("cimage")).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
        }
  }
}
</SCRIPT>

</BODY>
</HTML>