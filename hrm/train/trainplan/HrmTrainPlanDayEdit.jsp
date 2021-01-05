<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
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
String id = Util.null2String(request.getParameter("id"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<!--checkbox组件-->
<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<!-- 下拉框美化组件-->
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>

<!-- 泛微可编辑表格组件-->
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script type="text/javascript">
var dialog = parent.parent.getDialog(parent);
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
<input class=inputstyle type="hidden" name=id value="<%=id %>">
<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type=hidden name=rowindex>
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
<div id="trainPlan" class="groupmain" style="width:100%"></div>
<input name="rowindex" type="hidden" value="">
<script>
var items=[
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>",itemhtml:"<input type='hidden' name='date' class='wuiDate'><span class='mustinput'></span>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%>",itemhtml:"<BUTTON class=Calendar type=button onclick='onTrainPlanTime(starttimespan_#rowIndex#,starttime_#rowIndex#)'></BUTTON><SPAN id=starttimespan_#rowIndex# name=starttimespan_#rowIndex# class='weadate'><img src='/images/BacoError_wev8.gif' align=absmiddle></SPAN><input class=inputstyle type=hidden id='starttime_#rowIndex#' name='starttime' onchange=checkinput('starttime_#rowIndex#','starttimespan_#rowIndex#')>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%>",itemhtml:"<BUTTON class=Calendar type=button onclick='onTrainPlanTime(endtimespan_#rowIndex#,endtime_#rowIndex#)'></BUTTON><SPAN id=endtimespan_#rowIndex# name=endtimespan_#rowIndex# class='weadate'><img src='/images/BacoError_wev8.gif' align=absmiddle></SPAN><input class=inputstyle type=hidden id='endtime_#rowIndex#' name='endtime' onchange=checkinput('endtime_#rowIndex#','endtimespan_#rowIndex#')>"},
{width:"16%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='daycontent'>"},
{width:"63%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='dayaim'>"}];
<%
int rowindex = 0;
String planStartDate = "";
String planEndDate = ""; 
StringBuffer planDate = new StringBuffer();
String sql = "select planid,plandate,plandaycontent,plandayaim,starttime,endtime from HrmTrainPlanDay where planid = "+id+" order by plandate,starttime ";
rs.executeSql(sql);
StringBuffer ajaxData = new StringBuffer();
ajaxData.append("[");
while(rs.next()){
	String date = Util.null2String(rs.getString("plandate"));
	String starttime = Util.null2String(rs.getString("starttime"));
	String endtime = Util.null2String(rs.getString("endtime"));
	String daycontent = Util.null2String(rs.getString("plandaycontent"));
	String dayaim = Util.null2String(rs.getString("plandayaim"));
	rowindex++;
	ajaxData.append("[{name:\"date\",value:\""+date+"\",iseditable:true,type:\"input\"},");
	ajaxData.append("{name:\"starttime\",value:\""+starttime+"\",iseditable:true,type:\"date\"},");
	ajaxData.append("{name:\"endtime\",value:\""+endtime+"\",iseditable:true,type:\"date\"},");
	ajaxData.append("{name:\"daycontent\",value:\""+daycontent+"\",iseditable:true,type:\"input\"},");
	if(rs.getCounts()==rowindex){
		ajaxData.append("{name:\"dayaim\",value:\""+dayaim+"\",iseditable:true,type:\"input\"}]");
	}else{
		ajaxData.append("{name:\"dayaim\",value:\""+dayaim+"\",iseditable:true,type:\"input\"}],");
	}
}
ajaxData.append("]");
RecordSet.executeQuery("SELECT PLANSTARTDATE, PLANENDDATE FROM Hrmtrainplan WHERE ID=?", id);
if(RecordSet.next()) {
	planStartDate = Util.null2String(RecordSet.getString("PLANSTARTDATE"));
	planDate.append("[{name:\"planStartDate\",value:\""+planStartDate+"\"},");
	planEndDate = Util.null2String(RecordSet.getString("PLANENDDATE"));
	planDate.append("{name:\"planEndDate\",value:\""+planEndDate+"\"}]");
}
%>
var planDate = eval(<%=planDate%>); 
var planStartDate = planDate[0]["value"];
var planEndDate = planDate[1]["value"];
var ajaxdata=<%=ajaxData%>;
var rowindex=<%=rowindex%>;
var option= {
							openindex:true,
              navcolor:"#003399",
              basictitle:"<%=SystemEnv.getHtmlLabelName(16150,user.getLanguage())%>",
              toolbarshow:true,
              colItems:items,
              usesimpledata: true,
              initdatas: ajaxdata,
              addrowCallBack:function(obj,tr,entry) {
								rowindex=obj.count;
              },
              copyrowsCallBack:function(obj,tr,entry) {
								rowindex=obj.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_node" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           $("#trainPlan").append(group.getContainer());
       </script>
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
	var flag = true;
	var canSubmit = true;
	jQuery("input[name^=date]").each(function(){
		if(this.value==""){
			canSubmit = false;
			return false;
		} else if(compareDate(this.value, planStartDate)==-1 || compareDate(this.value, planEndDate)==1) {
			flag = false;
			return false;
		}
	});
	jQuery("input[name^=starttime]").each(function(){
		if(this.value==""){
			canSubmit = false;
			return false;
		}
	});
	jQuery("input[name^=endtime]").each(function(){
		if(this.value==""){
			canSubmit = false;
			return false;
		}
	});
	if(!flag) {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82571,user.getLanguage())%>");
		return;
	}
	if(!canSubmit){
		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>');
		return;
	}
  document.frmMain.rowindex.value=rowindex;
  document.frmMain.operation.value="plandaysave";
  document.frmMain.submit();
}

function checkDateValidity(startDate,endDate){
      var isValid = true;
      if(compareDate(startDate,endDate)==1){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
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
  
 function getTime(spanname,inputname){
      id = window.showModalDialog("/systeminfo/Clock.jsp",spanname.innerHTML,"dialogHeight:320px;dialogwidth:275px");
      if(spanname.id.indexOf("endtime")>-1){
         starttime=document.all("starttime_"+inputname.id.substring(inputname.id.indexOf("_")+1)).value;
         if(starttime!=null&&starttime!=""){
             if(id<starttime){
                 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
                 return;
             }

         }
      }
      if(spanname.id.indexOf("starttime")>-1){
         endtime=document.all("endtime_"+inputname.id.substring(inputname.id.indexOf("_")+1)).value;
         if(endtime!=null&&endtime!=""){
             if(id>endtime){
                 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>");
                 return;
             }

         }
      }
      spanname.innerHTML=id;
      inputname.value=id;
  }
 
 </script>
</BODY>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
