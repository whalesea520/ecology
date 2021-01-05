<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo,weaver.hrm.resource.ResourceComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<%!
/**
*Added by Charoes Huang ,May 31,2004
*Get the Resource Link Name String;
*/
 private String getMutiResourceLink(String ids) throws Exception {
	  String names = "";
	  String temp = "";
	  ResourceComInfo comInfo = new ResourceComInfo();
	  ArrayList a_ids = Util.TokenizerString(ids,",");
	  for(int i=0;i<a_ids.size();i++){
			temp = (String)a_ids.get(i);
			names += "<a href=javascript:openFullWindowForXtable(\"/hrm/resource/HrmResource.jsp?id="+temp+"\")> "+comInfo.getResourcename(temp)+"</a> ";
	  }
	  return names;
 }

%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));

Calendar todaycal = Calendar.getInstance ();
  String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
                 
String id = request.getParameter("id");	

boolean canView = false;
canView = TrainPlanComInfo.isViewer(id,""+user.getUID());
/*
if(HrmUserVarify.checkUserRight("HrmTrainPlanEdit:Edit", user)){
   canView = true;
}
*/

boolean isPlanOperator = TrainPlanComInfo.isPlanOperator(id,user.getUID());

boolean isOperator = TrainPlanComInfo.isOperator(id,user.getUID());

boolean canEdit = TrainPlanComInfo.canEdit(id);


if(!canView&& !isOperator && !isPlanOperator && !canEdit ){
  response.sendRedirect("/notice/noright.jsp");
  return;
}

boolean isend = TrainPlanComInfo.isEnd(id);

int userid = user.getUID();
TrainLayoutComInfo tl = new TrainLayoutComInfo();

  String name = "";
  String layoutid = "";
  String organizer = "";
  String startdate="";
  String enddate = "";
  String content="";
  String aim = "";  
  String address = "";
  String resource = ""; 
  String actor = ""; 
  String budget = "";
  String budgettype = ""; 
  String openrange = "";
  String docs="";
  String docsShowname="";
  String sql = "select * from HrmTrainPlan where id = "+id;
  rs.executeSql(sql);
  if(rs.next()){
     name = Util.null2String(rs.getString("planname"));
     layoutid = Util.null2String(rs.getString("layoutid"));
     organizer = Util.null2String(rs.getString("planorganizer"));
     startdate = Util.null2String(rs.getString("planstartdate"));
     enddate = Util.null2String(rs.getString("planenddate"));
     content = Util.toScreenToEdit(rs.getString("plancontent"),user.getLanguage());
     aim = Util.toScreenToEdit(rs.getString("planaim"),user.getLanguage());
     address = Util.null2String(rs.getString("planaddress"));     
     resource = Util.null2String(rs.getString("planresource"));          
     actor = Util.null2String(rs.getString("planactor"));     
     budget = Util.null2String(rs.getString("planbudget"));     
     budgettype = Util.null2String(rs.getString("planbudgettype"));     
     openrange = Util.null2String(rs.getString("openrange"));
     docs=Util.null2String(rs.getString("traindocs"));
     ArrayList arr_docids=Util.TokenizerString(docs,",");
     Iterator iter=arr_docids.iterator();
     StringBuffer sb=new StringBuffer();
     while(iter.hasNext()){
     String docid=(String)iter.next();
     sb.append("<A href=javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="+docid+"')>"+DocComInfo.getDocname(docid)+"</A>&nbsp") ;
     }
docsShowname=sb.toString();
  }  
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
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6103,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
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
if((isOperator || isPlanOperator || canView) &&canEdit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:dodelete(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainplan/HrmTrainPlanEdit.jsp?id="+id+",_self} " ;
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
<FORM id=weaver name=frmMain action="TrainPlanOperation.jsp" method=post >
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	  <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	  <wea:item>
	  	<input class=inputstyle type=text size=30 name="name" value="<%=name%>" onchange="checkinput('name','nameimage')">
	  	<SPAN id=nameimage></SPAN> 
	  </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></wea:item>
    <wea:item>
    	<brow:browser viewType="0" name="layoutid" browserValue='<%=layoutid%>'
	       browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/train/trainlayout/TrainLayoutBrowser.jsp"
	       hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
	       browserSpanValue='<%=TrainLayoutComInfo.getLayoutname(layoutid)%>'
	       _callback="getTrainLayout" completeUrl="/data.jsp?type=HrmTrainLayout">
     	</brow:browser>          
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(16141,user.getLanguage())%> </wea:item>
    <wea:item>
      <brow:browser viewType="0" name="organizer" browserValue='<%=organizer%>'
	      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
	      hasInput="true" isSingle="false" hasBrowser="true" isMustInput='2'
	      completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="120px"
	      browserSpanValue='<%=ResourceComInfo.getLastnameAllStatus(organizer)%>'>
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
      <textarea class=inputstyle cols=50 rows=4 name=aim value="<%=aim%>"><%=aim%></textarea>            
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(1395,user.getLanguage())%></wea:item>
    <wea:item><input class=inputstyle type=text size=30 name="address" value='<%=address%>'>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%></wea:item>
    <wea:item>
    	<brow:browser viewType="0" name="resource" browserValue='<%=resource%>'
	      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/train/trainresource/HrmTrainResourceBrowser.jsp"
	      hasInput="true" isSingle="false" hasBrowser="true" isMustInput='1'
	      completeUrl="/data.jsp?type=HrmTrainResource" browserSpanValue='<%=TrainResourceComInfo.getResourcename(resource)%>'>
	    </brow:browser>       
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(18876,user.getLanguage())%></wea:item>
    <wea:item>
      <brow:browser viewType="0" name="docs" browserValue='<%=docs%>'
	      browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp"
	      hasInput="true" isSingle="false" hasBrowser="true" isMustInput='1'
	      completeUrl="/data.jsp?type=9" browserSpanValue='<%=docsShowname%>' width="250px">
	    </brow:browser>  
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15761,user.getLanguage())%> </wea:item>
    <wea:item>
    	<brow:browser viewType="0" name="actor" browserValue='<%=actor%>'
	      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectids="
	      hasInput="true" isSingle="false" hasBrowser="true" isMustInput='2'
	      completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
	      browserSpanValue='<%=getMutiResourceLink(actor)%>'>
	    </brow:browser>
	  </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></wea:item>
    <wea:item>
      <input class=inputstyle type=text size=30 name="budget" value="<%=budget%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("budget")'>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15371,user.getLanguage())%></wea:item>
    <wea:item>
    	<brow:browser viewType="0" name="budgettype" browserValue='<%=budgettype%>'
	      browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype=1"
	      hasInput="true" isSingle="false" hasBrowser="true" isMustInput='1'
	      completeUrl="/data.jsp?type=FnaBudgetfeeType" 
	      browserSpanValue='<%=BudgetfeeTypeComInfo.getBudgetfeeTypename(budgettype)%>'>
	    </brow:browser>
    </wea:item>         
	</wea:group>
</wea:layout>      
 <input class=inputstyle type="hidden" name=operation>
 <input class=inputstyle type=hidden name=id value="<%=id%>">
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
<script language="JavaScript" src="/js/addRowBg_wev8.js" >   
</script>  
<script language=javascript>
function dosave(){
  if(check_form(document.frmMain,'name,layoutid,actor,organizer')&&checkDateValidity(frmMain.startdate.value,frmMain.enddate.value)){  
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
function doinfo(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>")){
      document.frmMain.operation.value="info";
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
                  content+="<A href=javascript:openFullWindowForXtable('/docs/docs/DocDsp.jsp?id="+ids[i]+"')>"+names[i]+"</A>&nbsp";
              }
              spanname.innerHTML = content;
              inputname.value = jsid[0].substring(1);
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
  
  function onShowResource(inputname,spanname){
	var result = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+$G(inputname).value)
	if (result) {
	if (result.id!="") {
	    resourceids = result.id;
		resourcename = result.name;
		sHtml = "";
		resourceids = resourceids.substr(1);
		resourcename = resourcename.substr(1);
		$G(inputname).value= resourceids;
		
		resourceids=resourceids.split(",");
		resourcenames=resourcename.split(",");
		for(var i=0;i<resourceids.length;i++){
		    sHtml = sHtml+"<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="+resourceids[i]+"')>"+resourcenames[i]+"</a>&nbsp;";
		}
		$G(spanname).innerHTML = sHtml;
	}else{	
    	$G(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
    	$G(inputname).value="";
	}
  }
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
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
</HTML>
