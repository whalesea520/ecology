
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page import="weaver.WorkPlan.WorkPlanShareUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%	

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(33506, user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	rs.executeSql(" select remindtime from workplan_disremindtime where userid ="+user.getUID()+" and usertype = "+ user.getLogintype());
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String newRemindtime = df.format(new Date());
	if(rs.next()){
		String remindtime = rs.getString("remindtime");
		rs.executeSql(" update workplan_disremindtime set remindtime = '"+newRemindtime+"' where userid ="+user.getUID()+" and usertype = "+ user.getLogintype());
	} else {
		rs.executeSql("insert into workplan_disremindtime values("+user.getUID()+","+user.getLogintype()+",'"+newRemindtime+"')");
	}
	
	int timeSag = Util.getIntValue(request.getParameter("timeSag"),1);
	String enddate = Util.null2String(request.getParameter("enddate"));
	String startdate = Util.null2String(request.getParameter("startdate"));
    int currentpage = Util.getIntValue(request.getParameter("currentpage"),1);
    String currUserId = String.valueOf(user.getUID());  //用户ID
	String currUserType = user.getLogintype();  //用户类型
    
	
	//获取日程共享数据
	String shareSql=WorkPlanShareUtil.getShareSql(user);
	
	
    String sqlstr = "select e.*,w.name as sort_name, w.type_n as sort_type from Exchange_Info e, workplan w, ("+shareSql+") ws where e.sortid = w.id and w.id = ws.workID"
			+ " AND e.type_n = 'WP' " ;
    //System.out.println(sqlstr);
    if(timeSag > 0&&timeSag<6){
			String doclastmoddatefrom = TimeUtil.getDateByOption(""+timeSag,"0");
			String doclastmoddateto = TimeUtil.getDateByOption(""+timeSag,"1");
			if(!doclastmoddatefrom.equals("")){
				sqlstr += " and e.createDate >= '" + doclastmoddatefrom + "'";
			}
			
			if(!doclastmoddateto.equals("")){
				sqlstr += " and e.createDate <= '" + doclastmoddateto + "'";
			}
			
		}else{
			if(timeSag==6){//指定时间
				if((!"".equals(startdate) && null != startdate))
				{
					sqlstr += " AND e.createDate >= '" + startdate+ "'";								    
				   // sqlWhere += "' OR workPlan.endDate IS NULL)";
				}
				if((!"".equals(enddate) && null != enddate))
				{
					sqlstr += " AND e.createDate <= '" + enddate + "'";
				}
			}
			
		}

		
%>

<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
  </HEAD>
  <BODY >
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<% 

	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right; width:400px!important">
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
			</td>
		</tr>
	</table>
	<div id="tabDiv" >
			<span id="hoverBtnSpan" class="hoverBtnSpan">
				<span id="ALL" val="0" onclick="clickTab(this)" class="tabClass <%=(timeSag == 0 || timeSag < 0)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>
				<span id="TODAY" val="1" onclick="clickTab(this)" class="tabClass <%=(timeSag == 1)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></span>
				<span id="WEEK" val="2" onclick="clickTab(this)" class="tabClass <%=(timeSag == 2)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></span>
				<span id="MOUTH" val="3" onclick="clickTab(this)" class="tabClass <%=(timeSag == 3)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></span>
				<span id="YEAR" val="5" onclick="clickTab(this)" class="tabClass <%=(timeSag == 5)?"selectedTitle":"" %>" ><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></span>
				
		 </span>
	</div>
				
	<div class="advancedSearchDiv" id="advancedSearchDiv">		
		<FORM id=weaverA name=weaverA action="WorkPlanDiscuss.jsp" method=post  >
			<input type="hidden" name="currentpage" id="currentpage" value="<%=currentpage %>">
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(32905, user.getLanguage())%>' >
				    <wea:item><%=SystemEnv.getHtmlLabelName(23066,user.getLanguage())%></wea:item> 
				    <wea:item>
                          <span>
                          	<select name="timeSag" id="timeSag" onchange="changeDate(this,'datespan');" style="width:100px;">
                          		<option value="0" <%=timeSag==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
                          		<option value="1" <%=timeSag==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
                          		<option value="2" <%=timeSag==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
                          		<option value="3" <%=timeSag==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
                          		<option value="4" <%=timeSag==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
                          		<option value="5" <%=timeSag==5?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
                          		<option value="6" <%=timeSag==6?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
                          	</select>
                          </span>
                          <span id="datespan"  style="<%=timeSag==6?"":"display:none;" %>">
                        	<button type="button" class=calendar id=SelectDate onClick="getDate(startdatespan,startdate)"></button>&nbsp;
                            <span id=startdatespan><%=startdate %></span>
                          	-&nbsp;&nbsp;
                          	<button type="button" class=calendar id=SelectDate2 onClick="getDate(enddatespan,enddate)"></button>&nbsp;
                           <span id="enddatespan" ><%=enddate %></span>
							<input type="hidden" name="startdate" value="<%=startdate %>">
                          	<input type="hidden" name="enddate" value="<%=enddate %>"> 
						 </span>
                    </wea:item>
				</wea:group>
				<wea:group context="">
					<wea:item type="toolbar">
				        <input type="button" onclick="search();" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</FORM>
		</div>
		<TABLE cellspacing=1 style="width:100%;">
			 <COLGROUP>
		    	<COL width="10px">
		    	<COL width="">
		    	<COL width="10px">
		    <TBODY>
			    <TR>
				<td></td>
			     <td>
					<jsp:include page="/meeting/data/MeetingDiscussRd.jsp" flush="true">
				         <jsp:param name="sortid" value="" />
				         <jsp:param name="types" value="WP" />
				         <jsp:param name="currentpage" value="<%=currentpage%>" />
				         <jsp:param name="from" value="list" />
				         <jsp:param name="sqlstr" value="<%=sqlstr%>" />
				     </jsp:include>
				 </td>
		         <td></td>
			    </TR>
			</tbody>
  </table>
    </BODY>
</HTML>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">
jQuery(document).ready(function(){
	jQuery("li.current",parent.document).removeClass("current");
	if(jQuery("#timeSag").val()=="0"){
		jQuery("#ALLli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="1"){
		jQuery("#TODAYli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="2"){
		jQuery("#WEEKli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="3"){
		jQuery("#MOUTHli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="4"){
		jQuery("#SEASONli",parent.document).addClass("current");
	}else if(jQuery("#timeSag").val()=="5"){
		jQuery("#YEARli",parent.document).addClass("current");
	} else {
		jQuery("#ALLli",parent.document).addClass("current");
	}
});
function resetCondtion(){

	//清空下拉框
	jQuery('#advancedSearchDiv').find("select").val("1");
	jQuery('#advancedSearchDiv').find("select").trigger("change");
	jQuery('#advancedSearchDiv').find("select").selectbox('detach');
	jQuery('#advancedSearchDiv').find("select").selectbox('attach');
	//清空日期
	jQuery('#advancedSearchDiv').find(".calendar").siblings("span").html("");
	jQuery('#advancedSearchDiv').find(".calendar").siblings("input[type='hidden']").val("");
	
	
	
}

function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	jQuery("#hoverBtnSpan").hoverBtn();
}

function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("input[name='names']").val(name);
	doSearchsubmit();
}

function clickTab(obj){
	jQuery("#timeSag").val(jQuery(obj).attr("val"));
	doSearchsubmit();
}

function search(){
	doSearchsubmit();
}

function doSearchsubmit(){
	$('#weaverA').submit();
}

function onSearch(obj) {
    obj.disabled = true ;
    doSearchsubmit();
}
var diag_vote;
function closeDialog(){
	diag_vote.close();
	search();
}


function closeWinARfrsh(){
	diag_vote.close();
	search();
}
function view(id, workPlanTypeID,tabType){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	if(tabType!="2"){
		tabType="1"
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.checkDataChange = false;
	diag_vote.isIframe=false;
	diag_vote.CancelEvent=closeDialog;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>";
	if(workPlanTypeID == 6){
		diag_vote.URL = "/hrm/performance/targetPlan/PlanView.jsp?from=2&id=" + id ;
	} else {
		diag_vote.URL = "/workplan/data/WorkPlanDetail.jsp?from=1&tabType="+tabType+"&workid=" + id ;
	}
	diag_vote.show();
	
}

function dataRfsh(){
	doSearchsubmit();
}

//分页
function toPage(pageNum){
  $("#currentpage").val(pageNum);
  doSearchsubmit();
}


//转到
function toGoPage(totalpage,topage){
 	var topagenum=jQuery("#"+topage);
 	var topage =topagenum.val();
 	if(topage <0 || topage!=parseInt(topage) ) {
          Dialog.alert("<%=SystemEnv.getHtmlLabelName(25167,user.getLanguage())%>!");  //请输入整数
          topagenum.val(""); //置空
          topagenum.focus();
 	      return ;
 	 }
 	if(topage>totalpage) topage=totalpage; //大于最大页数
 	if(topage==0) topage=1;                //小于最小页数 
 	toPage(topage);
}

function pmouseoverN(obj, flag) {
    if (obj == undefined) {
        return;
    }
    if (flag == true) {
    	if (jQuery(obj).attr("class") == "weaverTableNextPage") {
    		jQuery(obj).attr("class", "weaverTableNextSltPage");
    	} else {
    		jQuery(obj).attr("class", "weaverTablePrevSltPage");
    	}
    } else {
        if (obj.className == "weaverTableNextSltPage") {
        	jQuery(obj).attr("class", "weaverTableNextPage");
        } else {
        	jQuery(obj).attr("class", "weaverTablePrevPage");
        }
    }
}

function editDiscussNew(disid, sortid){
	showDialog("/meeting/data/MeetingOthTab.jsp?toflag=discuss&types=WP&sortid="+sortid+"&operation=edit&discussid="+disid,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(15153, user.getLanguage())%>",600,400);
}

function deleteDiscuss(discussid){
	 jQuery.post("/discuss/ExchangeOperation.jsp?method1=delete&types=WP",{discussid:discussid},function(data){
      	toPage(<%=currentpage%>);
   });
}

jQuery(document).ready(function(){
	jQuery(".thtd").live('mouseenter', function() {
      		jQuery(this).addClass("Selected");
      		jQuery(this).children(".hoverDiv").show();
	  }).live('mouseleave', function() {
	      jQuery(this).removeClass("Selected");
	      jQuery(this).children(".hoverDiv").hide();
	  });
     
	 jQuery(".operHoverSpan").live('mouseenter', function() {
         jQuery(this).addClass("operHoverSpan_hover");
	  }).live('mouseleave', function() {
	      jQuery(this).removeClass("operHoverSpan_hover");
	  });
	  jQuery(".operHover_hand").live("click",function(){
	  	jQuery(this).find("a").click();
	  });
});

function showDialog(url, title, w,h){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = w;
	diag_vote.Height = h;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}
</SCRIPT>
