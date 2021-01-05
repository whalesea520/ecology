<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<jsp:useBean id="TrainComInfo" class="weaver.hrm.train.TrainComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<%	
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String id = request.getParameter("id");	
int userid = user.getUID();
  String name = ""; 
  String planid = ""; 
  String organizer = "";
  String startdate="";
  String enddate = "";
  String content="";
  String aim = "";  
  String address = "";
  String resource = ""; 
  String testdate = "";  
  //begin TD24253   Add yangdacheng 20111215
  String mintraindate = "";
  String maxtraindate = "";

  String sql1="select min(traindate)AS mintraindate, max(traindate)AS maxtraindate from  HrmTrainDay  where trainid ="+id;
  rs.execute(sql1);
  while(rs.next()){
	  mintraindate=Util.null2String(rs.getString("mintraindate"));  
	  maxtraindate=Util.null2String(rs.getString("maxtraindate"));  

  }
  //end TD24253
  
  String sql = "select * from HrmTrain where id = "+id;
  rs.executeSql(sql);
  while(rs.next()){
     name = Util.null2String(rs.getString("name"));     
     planid = Util.null2String(rs.getString("planid"));
     organizer = Util.null2String(rs.getString("organizer"));
     startdate = Util.null2String(rs.getString("startdate"));
     enddate = Util.null2String(rs.getString("enddate"));
     content = Util.toScreenToEdit(rs.getString("content"),user.getLanguage());
     aim = Util.toScreenToEdit(rs.getString("aim"),user.getLanguage());
     address = Util.null2String(rs.getString("address"));     
     resource = Util.null2String(rs.getString("resource_n"));
     testdate = Util.null2String(rs.getString("testdate"));               
  }
  boolean isOperator = TrainComInfo.isOperator(id,""+userid);
  boolean isActor = TrainComInfo.isActor(id,""+userid);
  boolean isFinish = TrainComInfo.isFinish(id);
  boolean canView = false;
  if(HrmUserVarify.checkUserRight("HrmTrainEdit:Edit", user)){
   canView = true;
  }
  if(TrainPlanComInfo.isViewer(planid,""+userid)){
    canView = true;
  }
  boolean isActorManager = TrainComInfo.isActorManager(id,""+userid);
  if(!canView&& !isOperator &&!isActor&&!isActorManager){
  response.sendRedirect("/notice/noright.jsp");
  return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(isOperator&&!isFinish){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//if(isOperator&&!isFinish){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:dodelete(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrainEdit.jsp?id="+id+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//if(isOperator){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(16151,user.getLanguage())+",javascript:addtrainday(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(isOperator&&!isFinish){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="dosave();">
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="TrainOperation.jsp" method=post >
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
   <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
   <wea:item>
    <INPUT class=inputstyle type=text size=30 name="name" value="<%=name%>" onchange='checkinput("name","nameimage")'>
   	<SPAN id=nameimage></SPAN>
   </wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage())%></wea:item>
   <wea:item>
 		<brow:browser viewType="0" name="planid" browserValue='<%=planid %>' 
     browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/train/trainplan/HrmTrainPlanBrowser.jsp?selectedids="
     hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
     completeUrl="/data.jsp?type=HrmTrainPlan" browserSpanValue='<%=TrainPlanComInfo.getTrainPlanname(planid)%>'>
    </brow:browser>                     
   </wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(16141,user.getLanguage())%> </wea:item>
   <wea:item>
 	  <brow:browser viewType="0" name="organizer" browserValue='<%=organizer %>' 
     browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
     hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
     completeUrl="/data.jsp" browserSpanValue='<%=ResourceComInfo.getMulResourcename(organizer)%>'>
    </brow:browser> 
	 </wea:item>	   
   <wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
   <wea:item>
     <BUTTON class=Calendar type=button id=selectstartdate onclick="getDate(startdatespan,startdate)"></BUTTON> 
     <SPAN id=startdatespan ><%=startdate%></SPAN> 
     <input class=inputstyle type="hidden" id="startdate" name="startdate" value="<%=startdate%>">            
   </wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
   <wea:item>
     <BUTTON class=Calendar type=button id=selectenddate onclick="getDate(enddatespan,enddate)"></BUTTON> 
     <SPAN id=enddatespan ><%=enddate%></SPAN> 
     <input class=inputstyle type="hidden" id="enddate" name="enddate" value="<%=enddate%>">            
   </wea:item>            
   <wea:item><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
   <wea:item>
     <textarea class=inputstyle cols=50 rows=4 name=content value="<%=content%>"><%=content%></textarea>
   </wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </wea:item>
   <wea:item>
     <textarea class=inputstyle  cols=50 rows=4 name=aim value="<%=aim%>"><%=aim%></textarea>            
   </wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(1395,user.getLanguage())%></wea:item>
   <wea:item><INPUT class=inputstyle type=text size=30 name="address" value='<%=address%>'>
   </wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%></wea:item>
   <wea:item>
     <brow:browser viewType="0" name="resource" browserValue='<%=resource %>' 
      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/train/trainresource/HrmTrainResourceBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
      completeUrl="/data.jsp?type=HrmTrainResource" browserSpanValue='<%=TrainResourceComInfo.getResourcename(resource)%>'>
     </brow:browser>        
   </wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelNames("6102,15781,97",user.getLanguage())%></wea:item>          
   <wea:item>
     <BUTTON class=Calendar type=button id=selecttestdate onclick="getDate(testdatespan,testdate)"></BUTTON> 
     <SPAN id=testdatespan ><%=testdate%></SPAN> 
     <input class=inputstyle type="hidden" id="testdate" name="testdate" value="<%=testdate%>">            
   </wea:item>            
	</wea:group>
</wea:layout>
<input class=inputstyle type="hidden" name=operation> 
<input class=inputstyle type="hidden" name=id value=<%=id%>> 
</form>
<%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>

 <script language=vbs>
sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else	
    	spanname.innerHtml = ""
    	inputname.value="0"
	end if
	end if
end sub

sub onShowTrainResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/train/trainresource/HrmTrainResourceBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	resourcespan.innerHtml = id(1)
	frmMain.resource.value=id(0)
	else
	resourcespan.innerHtml = ""
	frmMain.resource.value=""
	end if
	end if
end sub

</script>
<script language=javascript>
function dosave(){
	if(check_form(document.frmMain,'name,planid,organizer')&&checkDateValidity(frmMain.startdate.value,frmMain.enddate.value)&&checkDateValidity2(frmMain.startdate.value,frmMain.enddate.value)){
    document.frmMain.operation.value="edit";
    document.frmMain.submit();
    }
  }  
function dodelete(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){      
    document.frmMain.operation.value="delete";
    document.frmMain.submit();
   } 
  }  
function addactor(){      
    location="HrmTrainActorAdd.jsp?trainid=<%=id%>";
  }  
function dotest(){      
    location="HrmTrainTest.jsp?trainid=<%=id%>";
  }     
function doassess(){      
    location="HrmTrainAssess.jsp?trainid=<%=id%>";
  }  
function dofinish(){      
    location="HrmTrainFinish.jsp?id=<%=id%>";
  }  
function addtrainday(){      
    location="HrmTrainDayAdd.jsp?trainid=<%=id%>";
  }
function rankclick(targetId,event)
{
	event = $.event.fix(event);
  	var objSrcElement = event.target;
    if (jQuery("#targetId")==null) {
           objSrcElement.src = "/images/project_rank1_wev8.gif";

	} else {
         var targetElement = $GetEle(targetId);

          if (targetElement.style.display == "none")
		{

             objSrcElement.src = "/images/project_rank1_wev8.gif";
             targetElement.style.display = "";
		}
            else
		{
             objSrcElement.src = "/images/project_rank2_wev8.gif";
             targetElement.style.display = "none";
		}
	}

}


function checkDateValidity(startDate,endDate){
      var isValid = true;
      if(compareDate(startDate,endDate)==1){
        alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
        isValid = false;
      }

      return isValid;
}
function checkDateValidity2(startDate,endDate){
    var isValid = true;
    var startdate =frmMain.startdate.value;
    var enddate =frmMain.enddate.value;
    var mintraindate ="<%=mintraindate%>";
    var maxtraindate ="<%=maxtraindate%>";
    if(compareDate(startdate,mintraindate)==1 || compareDate(maxtraindate,enddate)==1){
        alert("<%=SystemEnv.getHtmlLabelName(27609,user.getLanguage())%>"+mintraindate+"<%=SystemEnv.getHtmlLabelName(27610,user.getLanguage())%>"+maxtraindate);
        isValid = false;
    }
    return isValid;
}
 /**
 *Author: Charoes Huang
 *compare two date string ,the date format is: yyyy-mm-dd hh:mm
 *return 0 if date1==date2
 *       1 if date1>date2
 *       -1 if date1<date2
*/
function compareDate(date1,date2){
	//format the date format to "mm-dd-yyyy hh:mm"
	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0];
	date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0];

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}
 </script>

</BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
