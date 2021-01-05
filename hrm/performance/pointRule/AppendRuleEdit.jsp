<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
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
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(15610,user.getLanguage());
String needfav ="1";
String needhelp ="";
String id=request.getParameter("id");
String ruleName="";
String memo="";
String formula="";
String conditions="";
String formulasum="";
String conditionsum="";
String deptId="";
String hrmId="";
String postId="";
String formulaDeptId="";
String formulaHrmId="";
String formulaPostId="";
String status="0";
rs.execute("select * from HrmPerformanceAppendRule where id="+id);
if (rs.next())
{
    ruleName=Util.toScreen(rs.getString("ruleName"),user.getLanguage());
    memo=Util.toScreen(rs.getString("memo"),user.getLanguage());
    status=rs.getString("status");
    conditions=rs.getString("conditions");
    formula=rs.getString("formula");
    formulasum=rs.getString("formulasum");
    conditionsum=rs.getString("conditionsum");
    deptId=rs.getString("deptId");
    postId=rs.getString("postId");
    hrmId=rs.getString("hrmId");
    formulaDeptId=rs.getString("formulaDeptId");
    formulaPostId=rs.getString("formulaPostId");
    formulaHrmId=rs.getString("formulaHrmId");
}
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
<input type=hidden name=edittype value=detail >
<input type=hidden name=id value=<%=id%> >
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
            name=ruleName value=<%=ruleName%> onchange='checkinput("ruleName","nameimage")' >
            <SPAN id=nameimage>
			<%if (ruleName.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN> 
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18075,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle value="<%=memo%>" maxLength=50 size=50  maxLength=50 name=memo>
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18125,user.getLanguage())%></TD>
            <TD class=Field> 
              <button type="button" class=Browser style="display:''" onClick="onShowFormula()" name=showdformula></BUTTON> 
              <span id="formulas"><%=formulasum%></span>
              <input type="hidden" name="formula" id="formula" value="<%=formula%>">
              <input type="hidden" name="formulasum" id="formulasum" value="<%=formulasum%>">
              <SPAN id=fimage>
			  <%if (formula.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN> 
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TD>
            <TD class=Field> 
                  <button type="button" class=Browser style="display:''" onClick="onShowCon()" name=showcon></BUTTON> 
              <span id="cons"><%=conditionsum%></span>
              <input type="hidden" name="conditions" id="conditions" value="<%=conditions%>">
               <input type="hidden" name="conditionsum" id="conditionsum" value="<%=conditionsum%>">
              <SPAN id=cimage>
			  <%if (conditions.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN> 
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TD>
            <TD class=Field> 
             <input class=inputstyle type="checkbox" name="status" value="0" <%if (status.equals("0")) {%>checked<%}%>>
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
		</td><td colSpan=2><button type="button" class=Browser style="display:none" onClick="onShowResource('hrmName','hrmId','showhName')" name=showresource></BUTTON> 
		<!--计算过于复杂，暂时取消-->
		<!-- BUTTON class=Browser style="display:''" onClick="onShowDepartment('deptName','deptId','showdName')" name=showdepartment></BUTTON--> 
		<button type="button" class=Browser style="display:''" onclick="onShowPost('postName','postId','showpName')" name=showPost></BUTTON>
		</td></tr>
		<tr>
		<td>
		<!-- span id="showdName"><%if (!deptId.equals("")) {%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><br><%}%></span-->
		<span id="showpName"><%if (!postId.equals("")) {%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%><br><%}%></span>
		<span id="showhName"><%if (!hrmId.equals("")) {%><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%><br><%}%></span>
		</td>
		<td>
		<input type=hidden name="deptId" id="deptId" value="<%=deptId%>" ><input type=hidden name="postId" id="postId" value="<%=postId%>"><input type=hidden name="hrmId" id="hrmId" value="<%=hrmId%>">
		<span id="deptName">
		<%if (!deptId.equals("")) {
		  String deptName="";
		  ArrayList deptIda=Util.TokenizerString(deptId,",");
		  for (int i=0;i<deptIda.size();i++)
		  {
		  deptName=deptName+ DepartmentComInfo.getDepartmentname(""+deptIda.get(i))+" ";
		  }
		  out.print(deptName+"<br>");
		}%>
		
		</span>
		<span id="postName">
		<%if (!postId.equals("")) {
		  String postName="";
		  ArrayList postIda=Util.TokenizerString(postId,",");
		  for (int j=0;j<postIda.size();j++)
		  {
		  postName=postName+"<a href=/hrm/jobtitles/HrmJobTitlesEdit.jsp?id="+postIda.get(j)+">"+JobTitlesComInfo.getJobTitlesname(""+postIda.get(j))+"</a> ";
		  }
		  out.print(postName+"<br>");
		}%></span>
		<span id="hrmName">
		<%if (!hrmId.equals("")) {
		  String hrmName="";
		  ArrayList hrmIda=Util.TokenizerString(hrmId,",");
		  for (int k=0;k<hrmIda.size();k++)
		  {
		  hrmName=hrmName + "<a href=/hrm/resource/HrmResource.jsp?id="+hrmIda.get(k)+">"+ResourceComInfo.getResourcename(""+hrmIda.get(k))+"</a>"+" ";
		  }
		  out.print(hrmName+"<br>");
		}%></span>
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
		</td><td colSpan=2><button type="button" class=Browser style="display:none" onClick="onShowResource('hrmNamec','formulaHrmId','showhNamec')" name=showresourcec></BUTTON> 
		<!--计算过于复杂，暂时取消-->
		<!-- BUTTON class=Browser style="display:''" onClick="onShowDepartment('deptNamec','formulaDeptId','showdNamec')" name=showdepartmentc></BUTTON--> 
		<button type="button" class=Browser style="display:''" onclick="onShowPost('postNamec','formulaPostId','showpNamec')" name=showPostc></BUTTON>
		</td></tr>
		<tr>
		<td><!-- span id="showdNamec"><%if (!formulaDeptId.equals("")) {%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><br><%}%></span-->
		<span id="showpNamec"><%if (!formulaPostId.equals("")) {%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%><br><%}%></span>
		<span id="showhNamec"><%if (!formulaHrmId.equals("")) {%><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%><br><%}%></span>
		</td>
		<td>
		<input type=hidden name="formulaDeptId" id="formulaDeptId" value="<%=formulaDeptId%>"><input type=hidden name="formulaPostId" id="formulaPostId" value="<%=formulaPostId%>"><input type=hidden name="formulaHrmId" id="formulaHrmId" value="<%=formulaHrmId%>">
			<span id="deptNamec">
		<%if (!formulaDeptId.equals("")) {
		  String fDeptName="";
		  ArrayList fdeptIda=Util.TokenizerString(formulaDeptId,",");
		  for (int a=0;a<fdeptIda.size();a++)
		  {
		  fDeptName=fDeptName+ DepartmentComInfo.getDepartmentname(""+fdeptIda.get(a))+" ";
		  }
		  out.print(fDeptName+"<br>");
		}%>
		
		</span>
		<span id="postNamec">
		<%if (!formulaPostId.equals("")) {
		  String fpostName="";
		  ArrayList fpostIda=Util.TokenizerString(formulaPostId,",");
		  for (int b=0;b<fpostIda.size();b++)
		  {
		  fpostName=fpostName+"<a href=/hrm/jobtitles/HrmJobTitlesEdit.jsp?id="+fpostIda.get(b)+">"+JobTitlesComInfo.getJobTitlesname(""+fpostIda.get(b))+"</a> ";
		  }
		  out.print(fpostName+"<br>");
		}%></span>
		<span id="hrmNamec">
		<%if (!formulaHrmId.equals("")) {
		  String fhrmName="";
		  ArrayList fhrmIda=Util.TokenizerString(formulaHrmId,",");
		  for (int c=0;c<fhrmIda.size();c++)
		  {
		  fhrmName=fhrmName + "<a href=/hrm/resource/HrmResource.jsp?id="+fhrmIda.get(c)+">"+ResourceComInfo.getResourcename(""+fhrmIda.get(c))+"</a>"+" ";
		  }
		  out.print(fhrmName+"<br>");
		}%></span>
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