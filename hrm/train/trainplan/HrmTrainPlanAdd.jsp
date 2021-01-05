<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<%
   
//if(!HrmUserVarify.checkUserRight("HrmTrainPlanAdd:Add", user)){
    		//response.sendRedirect("/notice/noright.jsp");
    		//return;
	//}
	
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
int userid = user.getUID();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
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
String msg = Util.null2String(request.getParameter("msg"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6103,user.getLanguage());
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
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainplan/HrmTrainPlan.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=frmMain action="TrainPlanOperation.jsp" method=post >
<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type=hidden name=rowindex>
<%if(msg.equals("1")){%>
<font color=red size=2>
<%=SystemEnv.getHtmlLabelName(16163,user.getLanguage())%>
<%}%>
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
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
  	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
    <wea:item><INPUT class=inputstyle type=text size=30 name="name" onchange="checkinput('name','nameimage')">
    	<SPAN id=nameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN> 
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></wea:item>
    <wea:item>
	  <brow:browser viewType="0" name="layoutid"
       browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/train/trainlayout/TrainLayoutBrowser.jsp?selectedids="
       hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
       _callback="getTrainLayout" completeUrl="/data.jsp?type=HrmTrainLayout">
     </brow:browser>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(16141,user.getLanguage())%> </wea:item>
    <wea:item>
    	<brow:browser viewType="0"  name="organizer"
	      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
	      hasInput="true" isSingle="false" hasBrowser="true" isMustInput='2'
	      completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="120px"
	      browserSpanValue='<%=ResourceComInfo.getResourcename(""+user.getUID()) %>'>
	    </brow:browser>
	  </wea:item>	   
	  <wea:item><%=SystemEnv.getHtmlLabelName(15761,user.getLanguage())%></wea:item>
    <wea:item>
	   	<brow:browser viewType="0" name="actor"
	      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectids="
	      hasInput="true" isSingle="false" hasBrowser="true" isMustInput='2'
	      completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
	      browserSpanValue="">
	    </brow:browser>
	  </wea:item>	 
    <wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
    <wea:item>
      <BUTTON class=Calendar type="button" id=selectstartdate onclick="getDate(startdatespan,startdate)"></BUTTON> 
      <SPAN id=startdatespan ></SPAN> 
      <input class=inputstyle type="hidden" id="startdate" name="startdate" >
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>          
    <wea:item>
      <BUTTON class=Calendar type="button" id=selectenddate onclick="getDate(enddatespan,enddate)"></BUTTON> 
      <SPAN id=enddatespan ></SPAN> 
      <input class=inputstyle type="hidden" id="enddate" name="enddate" >
    </wea:item>            
    <wea:item><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
    <wea:item>
      <textarea class=inputstyle cols=50 rows=4 id=content name=content ></textarea>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%></wea:item>
    <wea:item>
      <textarea class=inputstyle cols=50 rows=4 id=aim name=aim ></textarea>            
    </wea:item>
	</wea:group>
</wea:layout> 
</form>
   <%if("1".equals(isDialog)){ %>
   </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout>
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
<script language=javascript>
function dosave(){
	if(check_form(document.frmMain,'name,layoutid,actor,organizer')&&checkDateValidity(frmMain.startdate.value,frmMain.enddate.value)){
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
  function onShowMultiDoc(spanname, inputname) {
      try {
      data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp");
      } catch(e) {
          return;
      }
      if (data != null) {
          if (data.id != ""){
        	  ids = data.id.split(",");
  			names =data.name.split(",");
              content="";
              for(i=0;i<ids.length;i++){
            	  if(ids[i]!="")
                  content+="<A href='/docs/docs/DocDsp.jsp?id="+ids[i]+"'>"+names[i]+"</A>&nbsp";
              }
              spanname.innerHTML = content;
              inputname.value = data.id.substring(1);
          }else {
              spanname.innerHTML = "";
              inputname.value = "";
          }
      }
  }
 function getTime(spanname,inputname){
      id = window.showModalDialog("/systeminfo/Clock.jsp",spanname.innerHTML,"dialogHeight:320px;dialogwidth:275px");
      if(spanname.id.indexOf("endtime")>-1){
         starttime=document.all("starttime_"+inputname.id.substring(inputname.id.indexOf("_")+1)).value;
         if(starttime!=null&&starttime!=""){
             if(id<starttime){
                 alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
                 return;
             }

         }
      }
      if(spanname.id.indexOf("starttime")>-1){
         endtime=document.all("endtime_"+inputname.id.substring(inputname.id.indexOf("_")+1)).value;
         if(endtime!=null&&endtime!=""){
             if(id>endtime){
                 alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>");
                 return;
             }

         }
      }
      spanname.innerHTML=id;
      inputname.value=id;
  }
  
  function getTrainLayout(e, datas, name){
  	var trainlayoutid = datas.id;
		jQuery.getJSON('/hrm/ajaxData.jsp',{'cmd':'trainlayout','trainlayoutid':trainlayoutid},function(data){ 
			jQuery("#content").val(data.layoutcontent);
			jQuery("#aim").val(data.layoutaim);
			jQuery("#startdate").val(data.layoutstartdate);
			jQuery("#startdatespan").html(data.layoutstartdate);
			jQuery("#enddate").val(data.layoutenddate);
			jQuery("#enddatespan").html(data.layoutenddate);
	  })
  }
 </script>

</BODY>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
