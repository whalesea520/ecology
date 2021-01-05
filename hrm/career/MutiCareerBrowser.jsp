<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CareerInviteComInfo" class="weaver.hrm.career.CareerInviteComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="session" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="EduLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="session" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("1932",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
  var dialog = null;
  try{
  	dialog = parent.parent.getDialog(parent);
  }catch(e){}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1932,user.getLanguage());
String needfav ="1";
String needhelp ="";

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String lastname = Util.null2String(request.getParameter("lastname"));
String firstname = Util.null2String(request.getParameter("firstname"));
String educationlevel = Util.null2String(request.getParameter("educationlevel"));
String sex = Util.null2String(request.getParameter("sex"));
String careerid = Util.null2String(request.getParameter("careerid"));
String jobtitle = Util.null2String(request.getParameter("jobtitle"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = ","+Util.null2String(request.getParameter("resourceids"))+",";
if(Util.null2String(request.getParameter("resourceids")).length()==0){
	check_per = ","+Util.null2String(request.getParameter("selectedids"))+",";
}
String resourceids ="";
String resourcenames ="";
String strtmp = "select id,lastname,firstname from HrmCareerApply";
RecordSet.executeSql(strtmp);
while(RecordSet.next()){
	if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){
		 	resourceids +="," + RecordSet.getString("id");
		 	//resourcenames += ","+RecordSet.getString("firstname")+" "+RecordSet.getString("lastname");
			resourcenames += ","+RecordSet.getString("lastname");
	}
}
if(!lastname.equals("")){
	sqlwhere += " and a.lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
}
//if(!firstname.equals("")){
//	sqlwhere += " and firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
//}
if(!educationlevel.equals("")){
	sqlwhere += " and a.educationlevel='"+educationlevel+"' ";
}
if(!sex.equals("")){
	sqlwhere += " and a.sex = '" + sex +"' ";
}
//if(!careerid.equals("")){
	//sqlwhere += " and careerid = '" + careerid +"' ";
//}
if(!jobtitle.equals("")){
	sqlwhere += " and b.careername = '" + jobtitle +"' ";
}
String sqlstr = "select a.*, b.careername from HrmCareerApply a left join HrmCareerInvite b on a.jobtitle = b.id "
				+" left join HrmJobTitles c on b.careername = c.id where 1=1 " + sqlwhere ;
String sqlstr1 = "select distinct b.careername from HrmCareerApply a left join HrmCareerInvite b on a.jobtitle = b.id "
					+"left join HrmJobTitles c on b.careername = c.id";
%>
<BODY>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MutiCareerBrowser.jsp" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=O id=btnok onclick="javascript:btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btnCancel_Onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON type="button" class=btn accessKey=2 id=btnclear onblur="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
	    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	    <table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=lastname value='<%=lastname%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle id=sex name=sex>
				<option value=""></option>
				<option value=0 <%if(sex.equalsIgnoreCase("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
				<option value=1 <%if(sex.equalsIgnoreCase("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
			  </select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1856,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle size=1 name=jobtitle>
	     	  <option value="">&nbsp;</option>
	     	  <%
				  //while(CareerInviteComInfo.next()){
					  //String curCareerId=CareerInviteComInfo.getCareerInviteid();
					  //String curCareerInviteName=CareerInviteComInfo.getCareerInvitename();
					RecordSet.executeSql(sqlstr1);
					while(RecordSet.next()){
						String jobTitelId = RecordSet.getString("careername");
						String jobTitelName = JobTitlesComInfo.getJobTitlesname(jobTitelId);
	     	  %>
	     	  <option value="<%=jobTitelId%>" <%if(jobtitle.equals(jobTitelId)){%> selected <%}%>>
	     	  <%=Util.toScreen(jobTitelName,user.getLanguage())%></option>
	     	  <%}%>
	        </select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle id=educationlevel name=educationlevel>
				<option value=""></option>
				<%
					while(EduLevelComInfo.next()){
						String educationLevelId = EduLevelComInfo.getEducationLevelid();
						String educationLevelName = EduLevelComInfo.getEducationLevelname();
				%>
				<option value="<%=educationLevelId%>" <% if(educationlevel.equals(educationLevelId)) {%>selected<%}%>>
				<%=Util.toScreen(educationLevelName,user.getLanguage())%></option>
				<%}%>
        </select>
		</wea:item>
	</wea:group>
</wea:layout>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="resourceids" value="">
</FORM>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
	<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>   
  <TH width=5%></TH>     
  <TH width=20%><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>      
	<TH width=15%><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TH>
  <TH width=15%><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></TH>
  <TH width=40%><%=SystemEnv.getHtmlLabelName(1856,user.getLanguage())%></TH>
</TR>
<TR class=Line style="height: 1px"><TH colspan="5" ></TH></TR>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String lastnames = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage());
	String firstnames = Util.toScreen(RecordSet.getString("firstname"),user.getLanguage());
	String educationlevels = RecordSet.getString("educationlevel");
	String sexs =RecordSet.getString("sex");
	//String careerids =RecordSet.getString("careerid");
	String jobtitle1 =RecordSet.getString("careername");
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<TD style="display:none"><%=ids%></TD>
  <%
	 String ischecked = "";
	 if(check_per.indexOf(","+ids+",")!=-1){
	 	ischecked = " checked ";
	 }%>
	<TD><input class=inputstyle type=checkbox name="check_per" value="<%=ids%>" <%=ischecked%>></TD>
	<TD><%=lastnames%></TD>
	<%---------------------性别--------------------%>
	<TD><% if(sexs.equalsIgnoreCase("0")) {%>
            <%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%> 
            <%} if(sexs.equalsIgnoreCase("1")) {%>
            <%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%> 
            <%}%>
	</TD>
	<%---------------------学历--------------------%>
	<TD>
           <%
			while(EduLevelComInfo.next()){
				String educationLevelId = EduLevelComInfo.getEducationLevelid();
				String educationLevelName = EduLevelComInfo.getEducationLevelname();
		   %>
				<% if(educationlevels.equals(educationLevelId)) {%>
				<%=Util.toScreen(educationLevelName,user.getLanguage())%>
				<%}%>
		   <%}%>
	</TD>
	<%---------------------应聘职位--------------------%>
	<TD><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle1),user.getLanguage())%></TD>
</TR>
<%}
%>

</TABLE>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=1  id=btnok value="<%="2-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnok_onclick();">
				<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitClear();">
		    <input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<script type="text/javascript">
var resourceids = "<%=resourceids%>"
var resourcenames = "<%=resourcenames%>"
function btnCancel_Onclick(){
	if(dialog){
		dialog.close();
	}else{ 
	  window.parent.parent.close();
	}
}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){
		var obj = $(this).find("input[name=check_per]");
		if(event.target.tagName=="INPUT"){
			if(obj.attr("checked")== true){
				obj.attr("checked",true);
				resourceids = resourceids + "," + $(this).find("td:first").text();
				resourcenames = resourcenames + "," + $(this).find("td:eq(2)").text();
			}else{
				obj.attr("checked",false);
				resourceids = resourceids.replace(","+$(this).find("td:first").text(),"");
				resourcenames = resourcenames.replace(","+$(this).find("td:eq(2)").text(),"")
			}
		}else{
			if(obj.attr("checked")==true){
				obj.attr("checked",false);
				resourceids = resourceids.replace(","+$(this).find("td:first").text(),"");
				resourcenames = resourcenames.replace(","+$(this).find("td:eq(2)").text(),"")
			}else{
				obj.attr("checked",true);
				resourceids = resourceids + "," + $(this).find("td:first").text();
				resourcenames = resourcenames + "," + $(this).find("td:eq(2)").text();
			}
		}
		event.stopPropagation();
		return true;
		})
})

function btnok_onclick(){
 var returnjson = {id:resourceids,name:resourcenames};
		if(dialog){
			try{
	        dialog.callback(returnjson);
	   		}catch(e){}
	
			try{
			     dialog.close(returnjson);
			 }catch(e){}
		}else{ 
		  window.parent.parent.returnValue  = returnjson;
		  window.parent.parent.close();
		}
}
function submitClear()
{
	var returnjson = {id:"",name:""};
	if(dialog){
			try{
	        dialog.callback(returnjson);
	   		}catch(e){}
	
			try{
			    dialog.close(returnjson);
			 }catch(e){}
	}else{ 
	  window.parent.parent.returnValue  = returnjson;
	  window.parent.parent.close();
	}
}
  
</script>
</BODY></HTML>
