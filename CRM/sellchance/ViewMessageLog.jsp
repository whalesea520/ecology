
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CustomerStatusCount" class="weaver.crm.CustomerStatusCount" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CommonTransUtil" class="weaver.task.CommonTransUtil" scope="page" />
<jsp:useBean id="CustomerService" class="weaver.crm.customer.CustomerService" scope="page" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
String hidetitle = Util.null2String(request.getParameter("hidetitle"));
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%

	String from=Util.null2String(request.getParameter("from"));	
	String crmIds = Util.null2String(request.getParameter("crmIds"));
	String sellchanceid = Util.null2String(request.getParameter("sellchanceid"));
	
	String types=Util.null2String(request.getParameter("types"),"CS");
	String isfromtab = Util.null2o(request.getParameter("isfromtab"));
	CustomerStatusCount.setExchangeInfo(sellchanceid,types,user.getUID());
	String userid = user.getUID()+"";
	
	
	boolean isattention = false;
	boolean isCustomerSelf=false;
	boolean canedit = false;
	
	
	String sql ="";
	String sqlwhere = "";	
	int _pagesize = 10;
	int _total = 0;//总数
	String userType = user.getLogintype();
	char flag0=2;
	// System.err.println("crmIds "+crmIds);
	if(!crmIds.equals("")){
		rs.execute("SELECT * FROM Exchange_Info where "+
				" sortid in (select id from CRM_SellChance where customerid in ("+crmIds+")) AND type_n='CS' order by id desc ");
		_total=rs.getCounts();
	}
	if(!sellchanceid.equals("")){
		rs.executeProc("ExchangeInfo_SelectBID",sellchanceid+flag0+types);
		_total=rs.getCounts();
	}
	// System.err.println ("_total "+_total);
	String orderway = Util.null2String(request.getParameter("orderway"),"0");
	String datatype = Util.null2String(request.getParameter("datatype"),"1");
%>
<style type="text/css">
	
</STYLE>
<LINK href="/CRM/css/Contact_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/CRM/css/Base_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/CRM/css/Base1_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript" src="/cowork/js/kkpager/kkpager_wev8.js"></script>
<link rel="stylesheet" href="/cowork/js/kkpager/kkpager_wev8.css" type="text/css"/>

<script type="text/javascript" src="/CRM/js/customerUtil_wev8.js"></script>
<style>
TABLE.ListStyle{width:96%}
TABLE.ListStyle tbody tr td {
	padding:0px;
}
TABLE.ListStyle tr.selected td {
	background-color:#fff !important;
}
TABLE.ListStyle TR.HeaderForXtalbe{
	display:none;
}
.paddingLeft18{padding-left:0px !important}
</style>
<body style="background-color:#f9f9f9">

<%if(isfromtab.equals("false")){%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(15153,user.getLanguage()) %>"/>
</jsp:include>
<%} %>

<div id="rightinfo" style="height: 100%;position: relative;overflow: hidden;padding-left:5px;padding-top:5px;">
	<div id="fbmain" style="width: 100%;overflow: hidden;background: #fff;top:0px;z-index: 100;border-bottom:1px solid #dadada;display:<%=from.equals("default")?"none":""%>">
		<table style="width: 100%;height: auto;margin-top:5px;margin-bottom:5px;overflow: hidden;" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td width="*" valign="top" align="center" style="padding-left:10px;padding-right:10px;">
				<textarea id="ContactInfo" _init="0" onpropertychange="resizeTextarea(this)"  oninput="resizeTextarea(this)" class="textareaNormal" style="width:100%;margin-top:0px;height:20px;overflow: auto;">请填写联系记录</textarea>
			</td>
		</tr>
		<tr>
			<td width="*" valign="top" align="center">
				<div id="operationdiv" style="overflow: hidden;padding-left:8px;overflow: hidden;height: 0px;">
				
					<wea:layout type="1col">
							<wea:group context="" attributes="{'groupDisplay':'none'}">
								<wea:item>
									<div style="margin-left: 0px;float: left;">
										<button type="button" onclick="doFeedback()" id="btnSubmit" class="submitButton">提交</button>
									</div>
									<div id="fbdate" style="float: left;margin-left: 10px;line-height:30px;color: #D1D1D1;font-style: italic;display: none;">联系日期：<%=TimeUtil.getCurrentDateString()%></div>
									<div id="submitload" style="float:left;margin-top: 6px;margin-bottom: 0px;margin-left: 20px;display: none;"><img src='/CRM/images/loading2_wev8.gif' align=absMiddle /></div>
									<div onclick="showExtend(this)" id="fbrelatebtn" _status="0" style="background:url('/cowork/images/blue/down_wev8.png') no-repeat right center;padding-right:8px;cursor: pointer;vertical-align: middle;">附加信息</div>
								</wea:item>
							</wea:group>
					</wea:layout>
					
					<wea:layout type="2col" attributes="{'layoutTableId':'extendtable'}">
							<wea:group context="" attributes="{'groupDisplay':'none'}">
								<wea:item>相关文档</wea:item>
								<wea:item>
									<brow:browser viewType="0" name="_docids" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' width="40%" browserSpanValue=""> </brow:browser>
								</wea:item>
							</wea:group>	
					</wea:layout>					
				
				</div>
			</td>
		</tr>
		</table>
				
  	</div>
	<div id="maininfo" style="height: auto;padding-right:5px;" class="scroll1">
	
		  <div style="padding:5px;padding-left:0px;padding-bottom:0px;display:<%=from.equals("default")?"none":""%>">
		  		<div style="float:left;">
		  			<select name="datatype" id="datatype" onchange="loadData()">
		  				<option value="1" <%=datatype.equals("1")?"selected":""%>>近一月</option>
		  				<option value="2" <%=datatype.equals("2")?"selected":""%>>近三月</option>
		  				<option value="3" <%=datatype.equals("3")?"selected":""%>>近半年</option>
		  				<option value="4" <%=datatype.equals("4")?"selected":""%>>近一年</option>
		  				<option value="0" <%=datatype.equals("0")?"selected":""%>>全部</option>
		  			</select>
		  		</div>
		  		<div style="float:right;" class="orderway" _val="<%=orderway%>">
		  			<div id="sequence"  _val="1" title="顺序" onclick="changOrderway(this)" style="width:26px;height:26px;background:url('/CRM/images/icon_sequence<%=orderway.equals("1")?"_h":""%>_wev8.png');float:right;margin-left:5px;cursor:pointer;"></div>
		  			<div id="reverse"   _val="0" title="倒序" onclick="changOrderway(this)" style="width:26px;height:26px;background:url('/CRM/images/icon_reverse<%=orderway.equals("0")?"_h":""%>_wev8.png');float:right;cursor:pointer;"></div>
		  			<div style="clear:both;"></div>
		  		</div>
		  		<div style="clear:both;"></div>
		  </div>
	
		  <%
		  
		  
		    String keyword = Util.null2String(request.getParameter("keyword"));
		  	String manager = Util.null2String(request.getParameter("manager"));
		  	String datetype = Util.null2String(request.getParameter("datetype"));
		  	String fromdate = Util.null2String(request.getParameter("fromdate")); 
		  	String enddate = Util.null2String(request.getParameter("enddate")); 
		  	
		    String tableString = "";
			int perpage=5;                                 
			String backfields = " id,creater,createdate,createtime,remark,docids,sortid ,type_n";
			String sqlFrom  = " Exchange_Info " ;
			String sqlWhere = "type_n='CS' ";
			String orderby = "";
			
			//获取我的客户默认联系记录
			if(from.equals("default")){
				sqlFrom  = " (select "+backfields+" from Exchange_Info where type_n = 'CS') t1";
			}
			if(!"".equals(crmIds)){
				sqlWhere+=" and t1.sortid in (select id from CRM_SellChance where customerid in ("+crmIds+"))";
			}
			if(!"".equals(sellchanceid)){
				sqlWhere+=" and sortid = "+sellchanceid;
			}
			String datestr="";
			String currentdate=TimeUtil.getCurrentDateString();
			if(datatype.equals("1"))
				datestr=TimeUtil.dateAdd(currentdate,-30);
			else if(datatype.equals("2"))
				datestr=TimeUtil.dateAdd(currentdate,-90);
			else if(datatype.equals("3"))
				datestr=TimeUtil.dateAdd(currentdate,-180);
			else if(datatype.equals("4"))
				datestr=TimeUtil.dateAdd(currentdate,-365);
			
			
			if(!"".equals(datestr))
				sqlWhere+=" and createdate>='"+datestr+"'";
			
			if(!"".equals(keyword)){
				sqlWhere+=" and remark like '%"+keyword+"%'";
			}
			if(!"".equals(manager)){
				sqlWhere+=" and creater = '"+manager+"'";
			}
			if(!"".equals(datetype) && !"6".equals(datetype)){
				sqlWhere += " and createdate >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
				sqlWhere += " and createdate <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
			}
			if(!"".equals(fromdate)){
				sqlWhere+=" and createdate >= '"+fromdate+"'";
			}
			if(!"".equals(enddate)){
				sqlWhere+=" and createdate <= '"+enddate+"'";
			}
			
 			SplitPageParaBean sppb = new SplitPageParaBean();
 			SplitPageUtil spu = new SplitPageUtil();
 			
 			sppb.setBackFields(backfields);
 			sppb.setSqlFrom(sqlFrom);
 			sppb.setSqlWhere(sqlWhere);
 			sppb.setPrimaryKey("id");
 			sppb.setSqlOrderBy("id");
 			sppb.setSortWay(orderway.equals("0")?sppb.DESC:sppb.ASC);
 			spu.setSpp(sppb);
 			int pagesize=5;
 			int pageindex = Util.getIntValue(request.getParameter("pageindex"),1);
 			int recordCount = spu.getRecordCount();
 			rs = spu.getCurrentPageRsNew(pageindex,pagesize);
 			// System.err.println("select "+backfields+" from "+sqlFrom+" where "+sqlWhere);
 			int totalpage = recordCount / pagesize;
 			if(recordCount - totalpage * pagesize > 0) totalpage = totalpage + 1;
 			
 			String htmlStr=""; 			  
			 			  
 	    	while(rs.next()){
 	    		
 	    		String creater=rs.getString("creater");
 	 	    	String createdate=rs.getString("createdate");
 	 	    	String createtime=rs.getString("createtime");
 	 	    	String remark=rs.getString("remark");
 	 	    	String docids=rs.getString("docids");
 	    		
 	    		htmlStr+="<div class='feedbackshow'>"+
 				    "<div class='feedbackinfo' >"+
 					   (Util.getIntValue(creater)>0?
 							("<a href='/hrm/resource/HrmResource.jsp?id='"+creater+"' target='_blank'>"+ResourceComInfo.getResourcename(creater)+"</a>")
 							:
 							("<A href='/CRM/data/ViewCustomer.jsp?CustomerID='"+creater.substring(1)+"'>"+CustomerInfoComInfo.getCustomerInfoname(creater.substring(1))+"</a>")
 					    )+" "+createdate+" "+createtime+
 				   "</div>"+
 				   "<div class='feedbackrelate'>"+
 				   "<div>"+remark+"</div>"+
 				   ((!docids.equals("")&&!docids.equals("0"))?("<div class='relatetitle'>相关文档："+CommonTransUtil.getDocName(docids)+"</div>"):"")+
 				   "</div>"+
 				  "</div>";			  
 	    	}
			out.println(htmlStr);
			
			if(rs.getCounts()>0){
		  %>
		  	<div id="discusspage" class="kkpager" style="text-align:right;margin-top:8px;"></div>
		  <%}else{%>
		  	<div class="norecord">没有可以显示的数据</div>
		  <%}%>
</div>
<%if(isfromtab.equals("false")){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<%} %>

<form id="mainForm">

	<input type="hidden" name="from" id="from" value="<%=from%>"/>
	
	<input type="hidden" name="manager" id="manager" value="<%=manager%>"/>
	<input type="hidden" name="fromdate" id="fromdate" value="<%=fromdate%>"/>
	<input type="hidden" name="enddate" id="enddate" value="<%=enddate%>"/>
	
</form>

<style>
TABLE.ListStyle tbody tr td {
	padding:0px;
}
TABLE.ListStyle TR.HeaderForXtalbe{
	display:none;
}
/*
TABLE.ListStyle{width:96%}
.feedbackshow{width:100%}
.feedbackrelate{border:0px;}
*/
.fieldName{padding-left:0px !important;}
.paddingLeft18{padding-left:5px !important;}
</style>

<script language="javascript">
	jQuery(function(){
		if("<%=isfromtab%>" == "false"){
			jQuery("#objName").css("font-size","16px");
		}
	});
	
	jQuery(function(){
		if(parent.crmExchange_1){
			parent.crmExchange_1.innerHTML = '';
		}
	});
	
	function changOrderway(obj){
		var orderway=$(obj).attr("_val");
		$(".orderway").attr("_val",orderway);
		loadData();
	}
	
	function loadData(){
		window.location.href=getUrl();
	}
	
	function getUrl(){
		var datatype=$("#datatype").val();
		var orderway=$(".orderway").attr("_val");
		
		var params=$("#mainForm").serialize();
		
		var url="/CRM/sellchance/ViewMessageLog.jsp?sellchanceid=<%=sellchanceid%>&crmIds=<%=crmIds%>&isfromtab=true&keyword=<%=keyword%>";
		url=url+"&orderway="+orderway+"&datatype="+datatype+"&"+params;
		return url;
	}
	
	function initMainHeight(){
		if("<%=from%>"=="default")
			$("#maininfo").height($(window).height()-$("#fbmain").height()-10);
		else	
			$("#maininfo").height($(window).height()-$("#fbmain").height()-30);
	}
	
	//初始化remark
	function initTextarea(){
		$("#ContactInfo").bind("focus",function(){
		   activeTextarea(this);
		});
		
		$(document.body).bind("click",function(event){
			if($(event.target).parents("#fbmain").length==1) return;
			clearTextarea($("#ContactInfo"));
		});
	}
	
	function activeTextarea(obj){
	   var init=$(obj).attr("_init");
	   if(init=="0"){
		   $(obj).val("").height(40).removeClass("textareaNormal");
		   $("#operationdiv").animate({height:30},200,null,function(){
		   		initMainHeight();
		   });
		   $(obj).attr("_init","1");
	   }
	}
	
	function clearTextarea(obj){
	   	if($(obj).val()==""){
	   	  $(obj).val("请填写联系记录").height(20).addClass("textareaNormal");
	   	  $("#operationdiv").animate({height:0},200,null,function(){
	   	  		initMainHeight();
	   	  });
		  $(obj).attr("_init","0");
	   }
	}
	
	function resizeTextarea(obj){ 
	
		var minHeight = 40;
		var maxHeight = 100; 
		var t =obj; 
		h = t.scrollHeight-6; 
		var styleHeight=t.style.height;
		
		if(h>=minHeight&&h<=maxHeight){
		
			if(h>$(t).height()){
				$(t).height(h).css("height",h+"px"); 
			}else if(h!=40){
				$(t).height(h-8);
			}
		}	
		initMainHeight();
	} 
	
	
	var tempval = "";
	var uploader;
	var oldname = "";
	var foucsobj2 = null;
	var keyword = "填写客户联系信息";
	var begindate = "<%=TimeUtil.getCurrentDateString()%>";
	$(document).ready(function(){

		var pageUrl=getUrl();
		initPageInfo(<%=totalpage%>,<%=pageindex%>,pageUrl);

		initMainHeight();
		initTextarea();

		//反馈信息内容样式
		$("#contactmore").live("mouseover",function(){
			$(this).children("td").css("background","url('../images/more_bg_hover_wev8.png') center repeat-x");
		}).live("mouseout",function(){
			$(this).children("td").css("background","url('../images/more_bg_wev8.png') center repeat-x");
		});
		//反馈附加信息按钮事件绑定
		$("#fbrelatebtn").bind("click",function(){
			var _status = $(this).attr("_status");
			if(_status==0){
				//$("#extendtable").show();
				$("#operationdiv").animate({height:62},200,null,function(){
					initMainHeight();
				});
				$(this).attr("_status",1).css("background", "url('../images/btn_up_wev8.png') right no-repeat");
			}else{
				//$("#extendtable").hide();
				$("#operationdiv").animate({height:30},200,null,function(){
					initMainHeight();
				});
				$(this).attr("_status",0).css("background", "url('../images/btn_down_wev8.png') right no-repeat");
			}
			$("#maininfo").height($(window).height()-$("#fbmain").height());
		});
		
		//bindUploaderDiv($("#fbUploadDiv"),"relateddoc","");
	});

	document.onkeydown=keyListener;
	function keyListener(e){
	    e = e ? e : event;   
	    if(e.keyCode == 13){
	    	//var target=$.event.fix(e).target;
	    	//ctrl+enter 直接提交反馈
			if(event.ctrlKey){
				doFeedback();
			}
	    	 
	    }    
	}
	var ContactInfo;
	function doFeedback(){
		ContactInfo = $.trim($("#ContactInfo").val());
		if(ContactInfo==""){
			alert("请填写联系信息!");
			return;
		}
		if(ContactInfo==keyword){
			$("#ContactInfo").focus();
			return;
		}
		/*
		try{
			var oUploader=window[$("#fbUploadDiv").attr("oUploaderIndex")];
			if(oUploader.getStats().files_queued==0){ //如果没有选择附件则直接提交
				exeFeedback();  //提交
			}else{ 
 				oUploader.startUpload();
			}
		}catch(e) {
			exeFeedback();
	  	}
	  	*/
	  	exeFeedback();
	}
	function exeFeedback(){
		
		var relateddoc = $("#_docids").val();
		$("#submitload").show();
		$("div.btn_feedback").hide();
		//$("#fbdate").hide();
		$.ajax({
			type: "post",
			url: "/discuss/ExchangeOperation.jsp",
			contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			data:{"method1":"add","ExchangeInfo":ContactInfo,"sortid":"<%=sellchanceid%>","docids":relateddoc,"types":"CS"}, 
			complete: function(data){
				//getContact(begindate);
				//var records = $.trim(data.responseText);
				$("#noinfo").remove();
		    	//$("#feedbacktable").prepend(records);
				$("#submitload").hide();
				$("div.btn_feedback").show();
				//$("#fbdate").show();
				//cancelFeedback();
				$("#ContactInfo").val("");
				//_table. reLoad();
				loadData();
			}
		});
		
	}
	function cutval(val){
		if(val==",") val = "";
		if(val!="") val = val.substring(1,val.length-1);
		return val;
	}
	function cancelFeedback(){
		var obj = $("#ContactInfo")
		obj.val(keyword);
		obj.addClass("blur_text");
		$("div.btn_feedback").hide();
		var _status = $("#fbrelatebtn").attr("_status");
		if(_status==1) $("#fbrelatebtn").click();
		$("#fbrelatebtn").hide();
			//begindate = "<%=TimeUtil.getCurrentDateString()%>";
			//$("#fbdate").hide().html("联系日期："+begindate);
		$("#maininfo").css("top",$("#fbmain").height()+$("#contacttitle").height());

		$("#_docids_val").val(",");$("#_wfids_val").val(",");$("#_projectids_val").val(",");
		$("table.feedrelate").find("div.txtlink").remove();

		$("input[name=relateddoc]").val("");
	}
	function writeFB(_begindate){
		//$("#fbdate").html("联系日期："+_begindate);
		begindate = _begindate;
		$("#ContactInfo").focus();
	}
	//读取列表更多记录
	function getListContact(obj){
		var _datalist = $(obj).attr("_datalist");
		var _currentpage = parseInt($(obj).attr("_currentpage"))+1;
		var _pagesize = $(obj).attr("_pagesize");
		var _total = $(obj).attr("_total");
		var _querysql = $(obj).attr("_querysql");
		$(obj).html("<img src='../images/loading3_wev8.gif' align='absMiddle'/>");
		$.ajax({
			type: "post",
		    url: "/CRM/data/ViewMessageOperation.jsp",
		    data:{"operation":"get_list_contact","istitle":0,"showtype":3,"currentpage":_currentpage,"pagesize":_pagesize,"total":_total,"sellchanceid":"<%=sellchanceid%>"}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
		    	var records = $.trim(data.responseText);
		    	$("#feedbacktable").append(records);
		    	if(_currentpage*_pagesize>=_total){
		    		$(obj).hide();
			    }else{
			    	$(obj).attr("_currentpage",_currentpage).html("更多").show();
				}
			}
	    });
	}

	//显示删除按钮
	function showdel(obj){
		$(obj).find("div.btn_del").show();
		$(obj).find("div.btn_wh").hide();
	}
	//隐藏删除按钮
	function hidedel(obj){
		$(obj).find("div.btn_del").hide();
		$(obj).find("div.btn_wh").show();
	}
	//回车事件方法
	function keyListener2(e){
	    e = e ? e : event;   
	    if(e.keyCode == 13){    
	    	$(foucsobj2).blur();   
	    }    
	}
	//删除选择性内容
	function delItem(fieldname,fieldvalue){
		$("#"+fieldname).prevAll("div.txtlink"+fieldvalue).remove();
		var vals = $("#"+fieldname+"_val").val();
		var _index = vals.indexOf(","+fieldvalue+",")
		if(_index>-1 && $.trim(fieldvalue)!=""){
			vals = vals.substring(0,_index+1)+vals.substring(_index+(fieldvalue+"").length+2);
			$("#"+fieldname+"_val").val(vals);
			if(!startWith(fieldname,"_")){
				exeUpdate(fieldname,vals,'str',fieldvalue);
			}
		}
	}
	//选择内容后执行更新
	function selectUpdate(fieldname,id,name,type){
		var addtxt = "";
		var addids = "";
		var addvalue = "";
		var ids = id.split(",");
		var names = name.split(",");
		var vals = $("#"+fieldname+"_val").val();
		for(var i=0;i<ids.length;i++){
			if(vals.indexOf(","+ids[i]+",")<0 && $.trim(ids[i])!=""){
				addids += ids[i] + ",";
				addvalue += ids[i] + ",";
				addtxt += transName(fieldname,ids[i],names[i]);
			}
		}
		$("#"+fieldname+"_val").val(vals+addids);
		addids = vals+addids;
		$("#"+fieldname).before(addtxt);
	}
	function showFeedback(){
		$("#content").focus();
	}
	
	function showop(obj,classname,txt){
		$(obj).removeClass(classname).html(txt);
	}
	function hideop(obj,classname,txt){
		$(obj).addClass(classname).html(txt);
	}
	
	function onShowHrm(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'add');
	    }
	}
	function onShowHrms(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'add');
	    }
	}
	function onShowDoc(fieldname) {
	    var datas = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}
	function onShowWF(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}
	function onShowCRM(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}
	function onShowProj(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}
	function transName(fieldname,id,name){
		var delname = fieldname;
		if(startWith(fieldname,"_")) fieldname = fieldname.substring(1);
		var restr = "";
		if(fieldname=="principalid"){
			restr += "<div class='txtlink showcon txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
		}else{
			restr += "<div class='txtlink txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
		}
		restr += "<div style='float: left;'>";
			
		if(fieldname=="principalid" || fieldname=="partnerid" || fieldname=="sharerid"){
			restr += "<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>";
		}else if(fieldname=="docids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+id+"') >"+name+"</a>";
		}else if(fieldname=="wfids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid="+id+"') >"+name+"</a>";
		}else if(fieldname=="crmids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+id+"') >"+name+"</a>";
		}else if(fieldname=="projectids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/proj/process/ViewTask.jsp?taskrecordid="+id+"') >"+name+"</a>";
		}else if(fieldname=="taskids"){
			restr += "<a href=javaScript:refreshDetail("+id+") >"+name+"</a>";
		}else if(fieldname=="tag"){
			restr += name;
		}
		
		restr +="</div>"
			+ "<div class='btn_del' onclick=\"delItem('"+delname+"','"+id+"')\"></div>"
			+ "<div class='btn_wh'></div>"
			+ "</div>";
		return restr;
	}
</script>
</body>
