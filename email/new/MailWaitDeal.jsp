
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@page import="weaver.email.MailReceiveRemindInfo, java.text.SimpleDateFormat"%>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
	String mailids = Util.null2String(request.getParameter("mailids"), "0");
	String type = Util.null2String(request.getParameter("type"), "0");   //0：添加待办进入页面，1：添加提醒; 2：添加备注
	String remindgroupattr = "";
    String notegroupattr = "";
    String ischeckremind = "";    //是否打开提醒设置
    String ischecknote = "";	  //是否打开备注设置
    int waitdealtimeindex = 2;    //默认待办处理时间明天
    
    
    String waitdeal = Util.null2String(request.getParameter("waitdeal"),"");
    String waitdealtime = Util.null2String(request.getParameter("waitdealtime"),"");
    String waitdealnote = Util.null2String(request.getParameter("waitdealnote"),"");
    String waitdealway = Util.null2String(request.getParameter("waitdealway"),"");
    String wdremindtime = Util.null2String(request.getParameter("wdremindtime"),"");
    
   
    if(mailids.indexOf(",") == -1) {
    	rs.execute(" select waitdeal, waitdealtime, waitdealnote, waitdealway, wdremindtime from MailResource where id = " + mailids);
    	while(rs.next()) {
    		waitdeal = rs.getString("waitdeal");
    		waitdealtime = rs.getString("waitdealtime");
    		waitdealnote = rs.getString("waitdealnote");
    		waitdealway = rs.getString("waitdealway");
    		wdremindtime = rs.getString("wdremindtime");
    	}
    }

    waitdealtimeindex = getWaitDealTimeIndex(waitdealtime);     
    
    List<MailReceiveRemindInfo> mris = new ArrayList<MailReceiveRemindInfo>();
    rs2.execute(" select id, name, content, labelid from MailReceiveRemind where enable = 1 and name not in ('微信提醒', 'Message提醒') ");
    while(rs2.next()) {
    	MailReceiveRemindInfo mri = new MailReceiveRemindInfo();
    	mri.setId(rs2.getInt("id"));
		mri.setName(SystemEnv.getHtmlLabelName(rs2.getInt("labelid"),user.getLanguage()));
		mri.setIschecked(waitdealway);
		mris.add(mri);
	}
    
	notegroupattr = "{samePair:'emaildetail',itemAreaDisplay:'none',groupOperDisplay:'none'}";
	remindgroupattr = "{samePair:'mailremind',itemAreaDisplay:'none',groupOperDisplay:'none'}";
	if("2".equals(type) || !"".equals(waitdealnote)) {
		notegroupattr = "{samePair:'emaildetail'}";
		ischecknote= "checked=true";
	}
	if("1".equals(type) || !"".equals(waitdealway)){
		remindgroupattr = "{samePair:'mailremind'}";
		ischeckremind= "checked=true";
	}
%>

<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />

<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()+"'></script>
<script type="text/javascript">

	var parentWin = parent.getParentWindow(window);
	function saveInfo(){
		var inform = formartSubmit();
		if(!inform.result) {
			window.top.Dialog.alert(inform.detail);
			return;
		}
		 jQuery.post("/email/MailWaitdealOperation.jsp",jQuery("form").serialize(),function(){
			 	parentWin.closeDialog1();
		 		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22619,user.getLanguage())%>");
		 });	
	}
	
	/**
	*   return {result: boolean; detail: string'} //result 是否通过验证； detail 提示信息
	*   Shunping Fu
	**/
	function formartSubmit() {
		var timeType = $("input[name='waitdealtimeType']:checked").val();
		var waitdealtime = getWaitdealtimeByType(timeType);
		jQuery('#waitdealtime').val(waitdealtime);
		
		if(waitdealtime == '' || waitdealtime == null || typeof(waitdealtime) == 'undefined') 
			return {result: false, detail: '<%=SystemEnv.getHtmlLabelName(83127,user.getLanguage())%>！'};
		
		// 设置提醒
		var remindway = '';
		jQuery("#remindtable").each(function(){
          	jQuery(this).find('input').each(function() {
          		if(jQuery(this).is(":checked")){
          			remindway += jQuery(this).attr('value') + ',';
          		}
          	});
		});
		remindway = remindway.substring(0, remindway.length-1);
		jQuery('#waitdealway').val(remindway);
		
		var wdtime = jQuery('#remindDatespan').html() + ' ' + jQuery('#remindTimespan').html();
		if(remindway != '') {
			if(wdtime == ' ' || wdtime == null || typeof(wdtime) == 'undefined' ) {
				return {result: false, detail: '<%=SystemEnv.getHtmlLabelName(83128,user.getLanguage())%>！'}
			}
			if(wdtime.length < 14) {
				return {result: false, detail: '<%=SystemEnv.getHtmlLabelName(83129,user.getLanguage())%>！'}
			}
			jQuery('#wdremindtime').val(wdtime);
			
		}else if(wdtime.length > 3 && wdtime != '' && wdtime != null && typeof(wdtime) != 'undefined'){
			return {result: false, detail: '<%=SystemEnv.getHtmlLabelName(83130,user.getLanguage())%>！'}
		}else if(wdtime.length > 3 && wdtime.length < 14) {
			return {result: false, detail: '<%=SystemEnv.getHtmlLabelName(83129,user.getLanguage())%>！'}
		}
		
		//设置备注备注	
		jQuery('#waitdealnote').val(jQuery('#waitdealnote1').val());
		
		return {result: true};
	}

function getWaitdealtimeByType(type) {
	switch(type) {
		case '1':
		  return getTodate();
		  break;
		case '2':
		  return getTomorrowdate();
		  break;
		case '3':
		  return getAfterTomorrowdate();
		  break;
		case '4':
		  return getWeekStartDate();
		  break;
		case '5':
		  return getMonthEndDate();
		  break;
		case '6':
		  return jQuery('#fromdatespan').html();
		  break;
		default:
		  return getTomorrowdate();
	}
}

//获取今天日期
function getTodate() {
	var now = new Date(); 
	return formatDate(now);

}

//获取明天日期
function getTomorrowdate() {
	var now = new Date(); //当前日期  
	now.setDate(now.getDate()+1);
	return formatDate(now);

}

//获取后天日期
function getAfterTomorrowdate() {
	var now = new Date(); //当前日期  
	now.setDate(now.getDate()+2);
	return formatDate(now);

}

//获取下周一日期
function getWeekStartDate() {  
	 var currentWeek = now.getDay();
 	if ( currentWeek == 0 )
    {
   		currentWeek = 7;
    }
	var weektime = now.getTime() - (currentWeek-8)*24*60*60*1000;
	return formatDate(new Date(weektime));  
} 

//获取下月第一天日期
function getMonthEndDate(){  
	 var date=new Date();
	 var currentMonth=date.getMonth();
	 var nextMonth=++currentMonth;
	 var nextMonthFirstDay=new Date(date.getFullYear(),nextMonth,1);
	 return formatDate(new Date(nextMonthFirstDay));
} 


//获得某月的天数  
function getMonthDays(myMonth){  
	var now = new Date(); //当前日期 
	var monthStartDate = new Date(now.getYear(), now.getMonth(), 1);  
	var monthEndDate = new Date(now.getYear(), now.getMonth()+1 , 1);  
	var days = (monthEndDate - monthStartDate)/(1000 * 60 * 60 * 24);  
	return days;  
}  

//格局化日期：yyyy-MM-dd  
function formatDate(date) {  
	var myyear = date.getFullYear();  
	var mymonth = date.getMonth()+1;  
	var myweekday = date.getDate();  
	  
	if(mymonth < 10){  
		mymonth = "0" + mymonth;  
	}  
	if(myweekday < 10){  
		myweekday = "0" + myweekday;  
	}  
	return (myyear+"-"+mymonth + "-" + myweekday);  
}  


function onShowTime1(spanname,inputname){
	var dads  = document.getElementById("meizzDateLayer2").style;
	setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}
	dads.top  = ((ttyp == "image") ? ttop + thei : ttop + thei + 22)+"px";
	dads.left = tleft+"px";
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
		jQuery('#remindTimespan').bind('DOMNodeInserted',
 		function(e) {
			   showTimeCallback(e);

	});
}

function showTimeCallback(e) {
				var time = jQuery(e.target).html();
			if(time != null && time.length>2) {
			
				time = time.substring(0, 2);
			}
			jQuery(e.target).html(time);

}

function clickDealTime(fromdatespan,fromdate) {
	//var cc = jQuery("#waitdealdate").get(0);jNiceChecked
	jQuery("input[name=waitdealtimeType]:eq(5)").attr("checked",'checked');
	jQuery("#waitdealtimetab").find('span').each(function() {
			onoutbtn(this, 'jNiceChecked');
	});
	jQuery(jQuery("#waitdealdate").parent().find('span')[0]).addClass("jNiceChecked");
	getDate(fromdatespan,fromdate);
}

function hasClass(obj, cls) {
    return obj.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)'));
}
    
function onoutbtn(btn, cls) {
	if (hasClass(btn, cls)) {
          var reg = new RegExp('(\\s|^)' + cls + '(\\s|$)');
          btn.className = btn.className.replace(reg, ' ');
    }
}
jQuery(document).ready(function(){
	  $(":radio").click(function(){
		   if(6==$(this).val()){
		   		$("#dateTd").css("display","");
		   }else{
			   $("#dateTd").css("display","none");
			   }
	  })
});
</script>
</head>


<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveInfo(),_self} " ;    
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(83114,user.getLanguage())%>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="saveInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="/email/MailWaitdealOperation.jsp" name="weaver">
<input type="hidden" name='Operation' value="add">
<input type="hidden" id='waitdealid' name='waitdealid' value='1'>
<input type="hidden" id='waitdealtime' name='waitdealtime' >
<input type="hidden" id='waitdealway' name='waitdealway' >
<input type="hidden" id='waitdealnote' name='waitdealnote' >
<input type="hidden" id='wdremindtime' name='wdremindtime' >
<input type="hidden" name='mailids' value='<%=mailids %>'>
<wea:layout attributes="{'expandAllGroup':'true', cols:3}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(83131,user.getLanguage())%>'>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(26034,user.getLanguage())%>
		</wea:item>
		<wea:item>
		    <table id='waitdealtimetab'>
		    	<tr>
		    		<td>
		    			<INPUT <%if(waitdealtimeindex==1)out.print("checked=true"); %> type=radio class='_wdt' name="waitdealtimeType" value="1"><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%>
		    		</td>
		    		<td>
		    			<INPUT  <%if(waitdealtimeindex==2)out.print("checked=true"); %> type=radio class='_wdt' name="waitdealtimeType" value="2"><%=SystemEnv.getHtmlLabelName(22488,user.getLanguage())%>
		    		</td>
		    		<td>
		    			<INPUT <%if(waitdealtimeindex==3)out.print("checked=true"); %> type=radio class='_wdt' name="waitdealtimeType" value="3"><%=SystemEnv.getHtmlLabelName(22492,user.getLanguage())%>
		    		</td>
		    	</tr>
		    	<tr>
		    		<td>
		    			<INPUT  <%if(waitdealtimeindex==4)out.print("checked=true"); %> type=radio class='_wdt' name="waitdealtimeType" value="4"><%=SystemEnv.getHtmlLabelName(83132,user.getLanguage())%>
		    		</td>
		    		<td>
		    			<INPUT  <%if(waitdealtimeindex==5)out.print("checked=true"); %> type=radio class='_wdt' name="waitdealtimeType" value="5"><%=SystemEnv.getHtmlLabelName(27348,user.getLanguage())%>
		    		</td>
		    		<td>
		    			<INPUT id="waitdealdate" <%if(waitdealtimeindex==6)out.print("checked=true"); %> type=radio class='_wdt' name="waitdealtimeType" value="6"><%=SystemEnv.getHtmlLabelName(83133,user.getLanguage())%>
		    			<span id="dateTd" style="margin-left: 10px;padding-top: <%if(waitdealtimeindex!=6){%>5px;display:none;<%} %>></span>"><BUTTON type="button" class=calendar id=SelectDate onclick="onShowDate(fromdatespan,fromdate)"></BUTTON>
						<SPAN id=fromdatespan ><%if(waitdealtimeindex==6)out.print(waitdealtime); %></SPAN>
						<input type="hidden" name="fromdate" id= "fromdate">
						</span>
					</td>
			</tr>
		    </table>
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("83090,15148",user.getLanguage())%>' attributes="<%=remindgroupattr %>">
		<wea:item><%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%></wea:item>
		<wea:item>
		    <table id="remindtable" >
		    <% for(int i =0; i< mris.size(); i++) { int value = i+1;%>
		    	<%if(i%2==0) {%>
		    		<tr>
		    	<%}%>
		    		<td><INPUT type="checkbox"  id="remind<%=value %>" value="<%=mris.get(i).getId() %>"  <%if(mris.get(i).getIschecked())out.print("checked=true"); %> /><%=mris.get(i).getName() %> </td>
		    	<%if(i%2!=0) {%>
		    		</tr>
		    	<%}%>
		    <% }%>
		    <% if(mris.size()%2!=0) {%>
		    	</tr>
		    <% }%>
		    </table>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(785,user.getLanguage())%></wea:item>
		<wea:item>
		        <span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
				<BUTTON type="button" class="calendar" id="SelectDate" onclick=getDate(remindDatespan,remindDate)></BUTTON>&nbsp;
				<SPAN id=remindDatespan ><%if(!"".equals(wdremindtime))out.print(wdremindtime.substring(0, wdremindtime.indexOf(" "))); %></SPAN>
				<input type="hidden" name="remindDate" id="remindDate">-
				<BUTTON type="button" class=Clock id=SelectDate onclick=onShowTime(remindTimespan,remindTime) ></BUTTON>&nbsp;
				<SPAN id=remindTimespan ><%if(!"".equals(wdremindtime))out.print(wdremindtime.substring(wdremindtime.indexOf(" "))); %></SPAN>
				<input type="hidden" name="remindTime" id="remindTime">
			</span>
	    </wea:item>
	</wea:group>
    
	<wea:group context='<%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%>' attributes="<%=notegroupattr %>">
		<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
		<wea:item>
			<textarea type="textarea" id='waitdealnote1' name="waitdealnote1" wrap="virtual" style="resize: none;line-height:17px; height:77px;width:300px;margin: 5px;" ><%=waitdealnote %></textarea>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
</body>

<%! 
	
	public int getWaitDealTimeIndex(String waitDealTime) {
		 if(waitDealTime == null || "".equals(waitDealTime)  || "0".equals(waitDealTime))
			 return 2;
	
		 SimpleDateFormat dd=new SimpleDateFormat("yyyy-MM-dd"); 
		 Map<Integer, String> timemap = new HashMap<Integer, String>();
		 
		 java.util.Calendar calstart = java.util.Calendar.getInstance();
		 calstart.setTime(new Date());
		 calstart.add(java.util.Calendar.DATE, 0);    
		 timemap.put(1, dd.format(calstart.getTime()));
		 
		 calstart.setTime(new Date());
		 calstart.add(java.util.Calendar.DATE, 1); 
		 timemap.put(2, dd.format(calstart.getTime()));
		 
		 calstart.setTime(new Date());
		 calstart.add(java.util.Calendar.DATE, 2); 
		 timemap.put(3, dd.format(calstart.getTime()));
		 
		 calstart.setTime(new Date());
		 calstart.add(java.util.Calendar.WEDNESDAY, 1); 
		 calstart.set(Calendar.DAY_OF_WEEK, 2);
		 timemap.put(4, dd.format(calstart.getTime()));

		 calstart.setTime(new Date());
		 calstart.add(java.util.Calendar.MONTH, 1); 
		 calstart.set(Calendar.DAY_OF_MONTH, 1);
		 timemap.put(5, dd.format(calstart.getTime()));
		 
		 for(int key : timemap.keySet()){
			 if(waitDealTime.equals(timemap.get(key))) {
				 return key;
			 }
		 }
		 return 6;
	}


%>
