<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<%	
//HrmDateCheck check= new HrmDateCheck();
//check.checkDate();

String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));

String planid = request.getParameter("planid");	
int userid = user.getUID();
  String name = "";  
  String organizer = "";
  String startdate="";
  String enddate = "";
  String content="";
  String aim = "";  
  String address = "";
  String resource = "";   
  
  String sql = "select * from HrmTrainPlan where id = "+planid;
  rs.executeSql(sql);
  while(rs.next()){
     name = Util.null2String(rs.getString("planname"));     
     organizer = Util.null2String(rs.getString("planorganizer"));
     startdate = Util.null2String(rs.getString("planstartdate"));
     enddate = Util.null2String(rs.getString("planenddate"));
     content = Util.toScreenToEdit(rs.getString("plancontent"),user.getLanguage());
     aim = Util.toScreenToEdit(rs.getString("planaim"),user.getLanguage());//Util.null2String(rs.getString("planaim"));
     address = Util.null2String(rs.getString("planaddress"));     
     resource = Util.null2String(rs.getString("planresource"));               
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
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage());
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrain.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="dosave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="TrainOperation.jsp" method=post >
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	  <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	  <wea:item>
	    <input class=inputstyle type=text size=30 name="name" onchange='checkinput("name","nameimage")'>
	  	<SPAN id=nameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage())%></wea:item>
	  <wea:item>                
			<brow:browser viewType="0" name="planid" browserValue='<%=planid %>' 
       browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/train/trainplan/HrmTrainPlanBrowser.jsp?selectedids="
       hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
       completeUrl="/data.jsp?type=HrmTrainPlan" browserSpanValue='<%=name %>'
       _callback="getTrainPlan">
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
      <textarea class=inputstyle cols=50 rows=4 id=content name=content value="<%=content%>"><%=content%></textarea>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </wea:item>
    <wea:item>
      <textarea class=inputstyle cols=50 rows=4 id=aim name=aim value="<%=aim%>"><%=aim%></textarea>            
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1395,user.getLanguage())%></wea:item>
    <wea:item><input class=inputstyle type=text size=30 name="address" value='<%=address%>'>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%></wea:item>
    <wea:item>
    	<brow:browser viewType="0" name="resource" browserValue='<%=resource %>' 
       browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/train/trainresource/HrmTrainResourceBrowser.jsp?selectedids="
       hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
       completeUrl="/data.jsp" browserSpanValue='<%=TrainResourceComInfo.getResourcename(resource)%>'>
      </brow:browser>       
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelNames("6102,15781,97",user.getLanguage())%></wea:item>
    <wea:item>
      <BUTTON class=Calendar type=button id=selecttestdate onclick="getDate(testdatespan,testdate)"></BUTTON>
      <SPAN id=testdatespan ></SPAN>
      <input class=inputstyle type="hidden" id="testdate" name="testdate">
    </wea:item>
	</wea:group>
</wea:layout>
  <input class=inputstyle type="hidden" name=operation>
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
  function getTrainPlan(e, datas, name){
  	var trainplanid = datas.id;
		jQuery.getJSON('/hrm/ajaxData.jsp',{'cmd':'trainplan','trainplanid':trainplanid},function(data){ 
			var ids = data.planorganizer.split(',');
			var names = data.planorganizername.split(',');
			var planorganizername = "";
			for(var i=0;ids!=null&&i<ids.length;i++){
				planorganizername += "<a href='javascript:openhrm("+ids[i]+");' onclick='pointerXY(event);'> "+names[i]+"</a>";
			}
			_writeBackData('organizer',2,{'id':data.planorganizer,'name':planorganizername},{
			hasInput:true,
			replace:true,
			isSingle:false,
			isedit:true
			});
			jQuery("#content").val(data.plancontent);
			jQuery("#aim").val(data.planaim);
			jQuery("#startdate").val(data.planstartdate);
			jQuery("#startdatespan").html(data.planstartdate);
			jQuery("#enddate").val(data.planenddate);
			jQuery("#enddatespan").html(data.planenddate);
	  })
  }
  
function dosave(){
  if(check_form(document.frmMain,'name,planid,organizer')&&checkDateValidity(frmMain.startdate.value,frmMain.enddate.value)){
    document.frmMain.operation.value="add";
    document.frmMain.submit();
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
