<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsd" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="companyInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
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
<style>
#tabPane tr td{padding-top:2px}
#monthHtmlTbl td,#seasonHtmlTbl td{cursor:hand;text-align:center;padding:0 2px 0 2px;color:#333;text-decoration:underline}
.cycleTD{font-family:MS Shell Dlg,Arial;background-image:url(/images/tab2.png);cursor:hand;font-weight:bold;text-align:center;color:#666;border-bottom:1px solid #879293;}
.cycleTDCurrent{font-family:MS Shell Dlg,Arial;padding-top:2px;background-image:url(/images/tab.active2.png);cursor:hand;font-weight:bold;text-align:center;color:#666}
.seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
#subTab{border-bottom:1px solid #879293;padding:0}
</style>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18056,user.getLanguage());
String needfav ="1";
String needhelp ="";
String id=request.getParameter("id");
String schemeName="";
String memo="";
String checkDeptId="";
String checkHrmId="";
String checkBranchId="";
String checkPostId="";
String viewSuperiorId="";
String viewHrmId="";
String viewPostId="";
String viewseSuperiorId="";
String status="0";
String cycle=String.valueOf(Util.getIntValue(request.getParameter("cycle"),2));
rs.execute("select * from HrmPerformanceCheckScheme where id="+id);
if (rs.next())
{
    schemeName=Util.toScreen(rs.getString("schemeName"),user.getLanguage());
    memo=Util.toScreen(rs.getString("memo"),user.getLanguage());
    status=rs.getString("status");
    checkDeptId=rs.getString("checkDeptId");
    checkHrmId=rs.getString("checkHrmId");
    checkBranchId=rs.getString("checkBranchId");
    checkPostId=rs.getString("CheckPostId");
    viewSuperiorId=rs.getString("viewSuperiorId");
    viewHrmId=rs.getString("viewHrmId");
    viewPostId=rs.getString("viewPostId");
    viewseSuperiorId=rs.getString("viewseSuperiorId");
    
}
%>

<BODY style="overflow:auto" onload="init('<%=cycle%>','<%=cycle%>','<%=id%>')">
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CheckSchemeList.jsp,_self} " ;
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
<input type=hidden name=edittype value=basic >
<input type=hidden name=id value=<%=id%> >
   <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="10%"> 
    <COL width="90%"> 
    <TBODY> 
  
    <TR> 
      <TD vAlign=top> 
      <!-- 基本信息-->
      <table width="100%" class=viewform>
 			<COLGROUP> <COL width="10%"> <COL width="70%"> <COL width="10%"><TBODY> 
          <TR class=title> 
            <TH colSpan=1><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
            <th style="text-align:right"><span class="spanSwitch" onclick="doSwitchx('showobjj','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
          </TR>
          
          <TR class=spacing style="height:1px;"> 
            <TD class=line1 colSpan=3></TD>
          </TR>
          </TBODY></table>
		<div id="showobjj" style="display:">
          <TABLE width="100%">
          <COLGROUP> <COL width=10%> <COL width=90%> <TBODY> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(195 ,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=50 size=50 
            name=schemeName  value="<%=schemeName%>" onchange='checkinput("schemeName","nameimage")' >
            <SPAN id=nameimage>
			<%if (schemeName.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN> 
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  value="<%=memo%>" maxLength=50 size=50  maxLength=50 name=memo>
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
         
       
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TD>
            <TD class=Field> 
             <input class=inputstyle type="checkbox" name="status" value="0" <%if (status.equals("0")) {%> checked <%}%> >
             <!-- 是否起用-->
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
</tr>
</TABLE>
</div>
<!--考核对象-->
<table width="100%" class=viewform>
 <COLGROUP> <COL width="10%"> <COL width="70%"> <COL width="10%"><TBODY> 
          <TR class=title> 
            <TH colSpan=1><%=SystemEnv.getHtmlLabelName(18057,user.getLanguage())%></TH>
            <th style="text-align:right"><span class="spanSwitch" onclick="doSwitchx('showobj','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
          </TR>
          
          <TR class=spacing style="height:1px;"> 
            <TD class=line1 colSpan=3></TD>
          </TR>
          </TBODY></table>
<div id="showobj" style="display:">

<table width="100%" class=viewform>
 <COLGROUP> <COL width="10%"> <COL width="70%"> <COL width="10%"><TBODY> 
         
          <tr><td>
          <select class=inputstyle  name=objtype onchange="onChangetype()">
          <option value="0" ><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
          <option value="1" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
          <option value="2"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>
		  <option value="3"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
		</SELECT>
		</td><td colSpan=2>
		<button type="button" class=Browser style="display:none" onClick="onShowResource('hrmName','checkHrmId','showhName')" name=showresource></BUTTON> 
		<button type="button" class=Browser style="display:''" onClick="onShowDepartment('deptName','checkDeptId','showdName')" name=showdepartment></BUTTON> 
		<button type="button" class=Browser style="display:none" onclick="onShowPost('postName','checkPostId','showpName')" name=showPost></BUTTON>
		<button type="button" class=Browser style="display:none" onclick="onShowBranch('branchName','CheckBranchId','showbName')" name=showBranch></BUTTON>
		</td></tr>
		<tr>
		<td>
		<span id="showbName"><%if (!checkBranchId.equals("")) {%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><br><%}%></span>
		<span id="showdName"><%if (!checkDeptId.equals("")) {%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><br><%}%></span>
		<span id="showpName"><%if (!checkPostId.equals("")) {%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%><br><%}%></span>
		<span id="showhName"><%if (!checkHrmId.equals("")) {%><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%><br><%}%></span>
		</td>
		<td>
		<input type=hidden name="checkDeptId" id="checkDeptId" value="<%=checkDeptId%>"><input type=hidden name="checkBranchId" id="checkBranchId" value="<%=checkBranchId%>"><input type=hidden name="checkPostId" id="checkPostId" value="<%=checkPostId%>"><input type=hidden name="checkHrmId" id="checkHrmId" value="<%=checkHrmId%>">
		<span id="branchName"><%if (!checkBranchId.equals("")) {
		  String branchName="";
		  ArrayList branchIda=Util.TokenizerString(checkBranchId,",");
		  for (int i=0;i<branchIda.size();i++)
		  {
		  branchName=branchName+"<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="+branchIda.get(i)+">"+SubCompanyComInfo.getSubCompanyname(""+branchIda.get(i))+"</a> ";
		  	 
		  }
		  out.print("<button type=\"button\" class=Browser  onclick=onShowBranch('branchName','CheckBranchId','showbName') name=showBranch1></BUTTON>"+branchName+"<br>");
		}%></span>
		<span id="deptName">
		<%if (!checkDeptId.equals("")) {
		  String deptName="";
		  ArrayList deptIda=Util.TokenizerString(checkDeptId,",");
		  for (int i=0;i<deptIda.size();i++)
		  {
		  deptName=deptName+"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="+deptIda.get(i)+">"+DepartmentComInfo.getDepartmentname(""+deptIda.get(i))+"</a> ";
		  }
		  out.print("<button type=\"button\" class=Browser onClick=onShowDepartment('deptName','checkDeptId','showdName') name=showdepartment1></BUTTON>"+deptName+"<br>");
		}%>
		</span>
		<span id="postName">
		<%if (!checkPostId.equals("")) {
		  String postName="";
		  String postId= "";
		  ArrayList postIda=Util.TokenizerString(checkPostId,",");
		  for (int j=0;j<postIda.size();j++)   
		  {
		  postName = postName+"<a href=/hrm/jobtitles/HrmJobTitlesEdit.jsp?id="+postIda.get(j)+">"+JobTitlesComInfo.getJobTitlesname(""+postIda.get(j))+" "+"</a>&nbsp";
		  //postName=postName+ JobTitlesComInfo.getJobTitlesname(""+postIda.get(j))+" ";
		  postId = postIda.get(j)+"";
		  }
		  out.print("<button type=\"button\" class=Browser  onclick=onShowPost('postName','checkPostId','showpName') name=showPost1></BUTTON>"+postName+"<br>");
		}%>
		</span>
		<span id="hrmName"><%if (!checkHrmId.equals("")) {
		  String hrmName="";
		  ArrayList hrmIda=Util.TokenizerString(checkHrmId,",");
		  for (int k=0;k<hrmIda.size();k++)
		  {
		  hrmName=hrmName + "<a href=/hrm/resource/HrmResource.jsp?id="+hrmIda.get(k)+">"+ResourceComInfo.getResourcename(""+hrmIda.get(k))+"</a>"+" ";
		  }
		  out.print("<button type=\"button\" class=Browser onClick=onShowResource('hrmName','checkHrmId','showhName') name=showresource1></BUTTON>"+hrmName+"<br>");
		}%></span>
		
		</td></tr>
          
</table>
</div>

<!--查看对象-->
<table width="100%" class=viewform>
 <COLGROUP> <COL width="10%"> <COL width="70%"> <COL width="10%"><TBODY> 
         
          <TR class=title> 
            <TH colSpan=1><%=SystemEnv.getHtmlLabelName(18133,user.getLanguage())%></TH>
            <th style="text-align:right"><span class="spanSwitch" onclick="doSwitchx('showobjv','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')"><img src='/images/up.jpg' style='cursor:hand' title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"></span></th>
          </TR>
          
          <TR class=spacing style="height:1px;"> 
            <TD class=line1 colSpan=3></TD>
          </TR>
          </TBODY></table>
<div id="showobjv" style="display:">
<table width="100%" class=viewform>
 <COLGROUP> <COL width="10%"> <COL width="70%"> <COL width="10%"><TBODY> 
          
   
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
		<td><span id="showsNamec"><%if (viewSuperiorId.equals("1")) {%><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%><br><%}%></span>
		<span id="showseNamec"><%if (viewseSuperiorId.equals("1")) {%><%=SystemEnv.getHtmlLabelName(18132,user.getLanguage())%><br><%}%></span>
		<span id="showpNamec"><%if (!viewPostId.equals("")) {%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%><br><%}%></span>
		<span id="showhNamec"><%if (!viewHrmId.equals("")) {%><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%><br><%}%></span>
		
		</td>
		<td>
		<input type=hidden name="viewSeSuperiorId" id="viewSeSuperiorId" value="<%=viewseSuperiorId%>" >
		<input type=hidden name="viewSuperiorId" id="viewSuperiorId" value="<%=viewSuperiorId%>">
		<input type=hidden name="viewPostId" id="viewPostId" value="<%=viewPostId%>">
		<input type=hidden name="viewHrmId" id="viewHrmId" value="<%=viewHrmId%>">
		<span id="supNamec"><%if (viewSuperiorId.equals("1")) {%><img src='/images/idelete.gif' style='cursor:hand' border=0 onClick=onShowSup('supNamec','viewSuperiorId','showsNamec','<%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%>')></img><br><%}%></span>
		<span id="sesupNamec"><%if (viewseSuperiorId.equals("1")) {%><img src='/images/idelete.gif' style='cursor:hand' border=0 onClick=onShowSup('sesupNamec','viewSeSuperiorId','showseNamec','<%=SystemEnv.getHtmlLabelName(18132,user.getLanguage())%>')></img><br><%}%></span>
		<span id="postNamec">
		<%if (!viewPostId.equals("")) {
		  String postName="";
		  ArrayList postIda=Util.TokenizerString(viewPostId,",");
		  for (int j=0;j<postIda.size();j++)
		  {
			  postName = postName+"<a href=/hrm/jobtitles/HrmJobTitlesEdit.jsp?id="+postIda.get(j)+">"+JobTitlesComInfo.getJobTitlesname(""+postIda.get(j))+" "+"</a>&nbsp";
			  //postName=postName+ JobTitlesComInfo.getJobTitlesname(""+postIda.get(j))+" ";
		      //  postName=postName+ JobTitlesComInfo.getJobTitlesname(""+postIda.get(j))+" ";
		  }
		  out.print("<button type=\"button\" class=Browser  onclick=onShowPost('postNamec','viewPostId','showpNamec') name=showPostc1></BUTTON>"+postName+"<br>");
		}%>
		</span>
		<span id="hrmNamec">
		<%if (!viewHrmId.equals("")) {
		  String hrmName="";
		  ArrayList hrmIda=Util.TokenizerString(viewHrmId,",");
		  for (int k=0;k<hrmIda.size();k++)
		  {
		  hrmName=hrmName + "<a href=/hrm/resource/HrmResource.jsp?id="+hrmIda.get(k)+">"+ResourceComInfo.getResourcename(""+hrmIda.get(k))+"</a>"+" ";
		  }
		  out.print("<button type=\"button\" class=Browser onClick=onShowResource('hrmNamec','viewHrmId','showhNamec') name=showresourcec1></BUTTON>"+hrmName+"<br>");
		}%>
		</span>
		</td></tr>    
</table>
</div>
<input type="hidden" name="changed" value="0">
</FORM>

      <table  border=0  style="width:100%;height:300" cellspacing=0 cellpadding=0 id="tabPane">
      <colgroup>
		<col width="79"></col>
		<col width="79"></col>
		<col width="79"></col>
		<col width="79"></col>
		<col width="*"></col>
		</colgroup>
      <TBODY>
	  <tr align=left height="20">
	  <td class="cycleTDCurrent" name="oTDtype_2"  id="oTDtype_2" background="/images/tab.active2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(2,2,<%=id%>)" ><b><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></b></td>
	  <td class="cycleTD" name="oTDtype_1"  id="oTDtype_1" background="/images/tab2.png" width=79px align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1,1,<%=id%>)" ><b><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></b></td>
	  <td class="cycleTD" name="oTDtype_3" id="oTDtype_3"  background="/images/tab2.png"  width=79px align=center onmouseover="style.cursor='hand'" onclick="resetbanner(3,3,<%=id%>)"><b><%=SystemEnv.getHtmlLabelName(18059,user.getLanguage())%></b></td>
	  <td class="cycleTD" name="oTDtype_0"  id="oTDtype_0" background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(0,0,<%=id%>)" ><b><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></b></td>
      <td style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</td>
	  </tr>
	 <tr>
	<td colspan="5" style="padding:0;">
	<iframe src="CheckSchemeContent.jsp?cycle=<%=cycle%>&id=<%=id%>" ID="iframeAlert" name="iframeAlert" frameborder="0" style="width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0" scrolling="auto"></iframe>
	</td></tr>
	</TBODY>
	</table>

</td>
<td></td>
</tr>
<td height="10" colspan="3"></td>
</tr>
</table>


<SCRIPT language="javascript">

function resetbanner(objid,typeid,id){
  	 document.iframeAlert.document.resource.bton1.click();
    if ($("input[name=changed]").val()=="1")
    {return;}
  	for(i=0;i<=3;i++){
  	    
  		$GetEle("oTDtype_"+i).background="/images/tab2.png";
  		$GetEle("oTDtype_"+i).className="cycleTD";
  	}
  	$GetEle("oTDtype_"+objid).background="/images/tab.active2.png";
  	$GetEle("oTDtype_"+objid).className="cycleTDCurrent";
    var o = window.frames[1].document;
    o.location="CheckSchemeContent.jsp?cycle="+typeid+"&id="+id;
  
  }
function init(objid,typeid,id){	
  	for(i=0;i<=3;i++){
  	    
  		$GetEle("oTDtype_"+i).background="/images/tab2.png";
  		$GetEle("oTDtype_"+i).className="cycleTD";
  	}
  	$GetEle("oTDtype_"+objid).background="/images/tab.active2.png";
  	$GetEle("oTDtype_"+objid).className="cycleTDCurrent";
    var o = window.frames[1].document;
    o.location="CheckSchemeContent.jsp?cycle="+typeid+"&id="+id;
  
  }
function OnSubmit(){
    if(check_form(document.resource,"schemeName"))
	{  window.frames[1].document.resource.changed.value="2";
	   window.frames[1].document.resource.bton.click();
	    
	    if ($("input[name=changed]").val()=="1")
       {return;}
		document.resource.submit();
		enablemenu();
		
	}
}
  function onChangetype(){
 
	thisvalue=document.resource.objtype.value;
	if(thisvalue==0){
 		$GetEle("showBranch").style.display='';
		
	}else{
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

 function onShowPost1(spanid,inputid,showname){
    var currentids=jQuery("#"+inputid).val();
	var results=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?jobtitles="+currentids);
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	   		var idArrs = wuiUtil.getJsonValueByIndex(results,0)+",";
	   		var nameArrs = wuiUtil.getJsonValueByIndex(results,1).substring(1)+",";
	   		idArrs = idArrs.substring(1,idArrs.length);
	   		var names =nameArrs.split(","); 
	   		var ids = idArrs.split(","); 
	   		sHtml = ""
	   		for(var i = 0;i<names.length;i++){
	   			if(names[i]!=""&&ids[i]!=0){
	   				sHtml = sHtml+"<a href=/hrm/jobtitles/HrmJobTitlesEdit.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp"
	   			}
	   		}
	   	  sHtml = "<button type=\"button\" class=Browser  onclick=onShowPost('"+spanid+"','"+inputid+"','"+showname+"')></BUTTON>"+sHtml;
	      jQuery("#"+spanid).html(sHtml+"<br>");
	      jQuery("#"+inputid).attr("value",wuiUtil.getJsonValueByIndex(results,0));
	      jQuery("#"+showname).html("<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>"+"<br>");
	   }else{
	      jQuery("#"+spanid).html("");
		  jQuery("#"+inputid).attr("value","");
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
	         $("#"+showname).html("<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>"+"<br>");
	          
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
	         $("#"+showname).html("<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>"+"<br>");
	          
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
</script>

</BODY>
</HTML>