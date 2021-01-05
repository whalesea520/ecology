
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="java.net.URLDecoder"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
	String sellchanceid = Util.null2String(request.getParameter("sellchanceid"));
	String sellchancename = URLDecoder.decode(Util.null2String(request.getParameter("sellchancename")),"utf-8");
	String customerid = Util.null2String(request.getParameter("customerid"));
	String lastdate = Util.null2String(request.getParameter("lastdate"));
	String hidetitle = Util.null2String(request.getParameter("hidetitle"));
	
	String userid = user.getUID()+"";
	String condition = "";
	//找到用户能看到的所有客户
	//如果属于总部级的CRM管理员角色，则能查看到所有客户。
	rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid);
	if (rs.next()) {
		condition = "(select id,name from CRM_CustomerInfo where (deleted=0 or deleted is null)) as customerIds";
	} else {
		String leftjointable = CrmShareBase.getTempTable(userid);
		condition = "(select t1.id,t1.name "
			+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
			+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null)) as customerIds";
	}
	String sql = " wp.id,wp.description,wp.begindate,wp.begintime,wp.createrid,wp.docid,wp.requestid,wp.taskid,wp.createdate,wp.createtime,wp.relateddoc,wp.crmid,"+sellchanceid+" as sellchanceid,'"+sellchancename+"' as subject,"+customerid+" as customerid"
			+" from WorkPlan wp where wp.type_n=3 and wp.crmid='"+customerid+"'";
	String statsql = " from WorkPlan wp where wp.type_n=3 and wp.crmid='"+customerid+"'";
	String sqlwhere = "";	
	int _pagesize = 10;
	int _total = 0;//总数
	rs.executeSql("select count(wp.id) "+statsql+sqlwhere);
	if(rs.next()){
		_total = rs.getInt(1);
	}
%>
<style type="text/css">
	
</STYLE>
<div id="rightinfo" style="width: 100%;height: 100%;position: relative;overflow: hidden;">
	<div id="contacttitle" style="width: 100%;height: 30px;position: relative;overflow:hidden;
	background:-webkit-gradient(linear, 0 0, 0 bottom, from(#F2F2F2), to(#F6F6F6)) !important;
    	background:-moz-linear-gradient(#F2F2F2, #D7D7D7) !important;
    	-pie-background:linear-gradient(#F2F2F2, #D7D7D7) !important;background: #F2F2F2 !important;">
		<div style="position: absolute;top: 3px;left:0px;height: 23px;width: 100%;">
			<div style="position: absolute;top: 0px;left: 10px;font-family: '微软雅黑';font-weight: bold;">联系反馈
				<font style="color: #C3C3C3;margin-left: 10px;cursor: pointer;" onclick="openFullWindowHaveBar('/CRM/sellchance/ViewSellChance.jsp?id=<%=sellchanceid %>')"
					title="商机名称：<%=sellchancename%>"><%=Util.getMoreStr(sellchancename,10,"...") %></font>
				<font style="color: #C3C3C3;margin-left: 10px;cursor: pointer;" onclick="openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=customerid %>')" 
					title="客户名称：<%=CustomerInfoComInfo.getCustomerInfoname(customerid)%>"><%=Util.getMoreStr(CustomerInfoComInfo.getCustomerInfoname(customerid),10,"...") %></font>
			</div>
			<div style="position: absolute;top: 0px;right: 10px;height: 100%;z-index: 5;display: none;">
				<div class="btn_operate" onmouseover="hideop(this,'btn_hover','商机卡片')" onmouseout="showop(this,'btn_hover','商机卡片')" 
					onclick="openFullWindowHaveBar('/CRM/sellchance/ViewSellChance.jsp?id=<%=sellchanceid %>')" title="查看商机卡片">商机卡片</div>
				<div class="btn_operate" onmouseover="hideop(this,'btn_hover','客户卡片')" onmouseout="showop(this,'btn_hover','客户卡片')" 
					onclick="openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=customerid %>')" title="查看客户卡片">客户卡片</div>
			</div>
		</div>
	</div>
	<div id="fbmain" style="width: 100%;overflow: hidden;background: #fff;position: absolute;top: 30px;z-index: 100;border-bottom: 1px #DFDFDF solid;">
		<textarea id="ContactInfo" class="blur_text" style="width: 95%;margin-left: 10px;margin-top:5px;height: 70px;overflow: auto;outline:none;"></textarea>
		<div style="width: 100%;overflow: hidden;">
			<div onclick="doFeedback()" class="btn_feedback" title="Ctrl+Enter">提交</div>
			<div onclick="cancelFeedback()" class="btn_feedback" title="取消">取消</div>
			<div id="fbdate" style="float: left;margin-left: 10px;line-height:30px;color: #D1D1D1;font-style: italic;display: none;">联系日期：<%=TimeUtil.getCurrentDateString()%></div>
			<div id="submitload" style="float:left;margin-top: 3px;margin-bottom: 3px;margin-left: 20px;display: none;"><img src='../images/loading2_wev8.gif' align=absMiddle /></div>
			<div id="fbrelatebtn" style="width:65px;line-height:18px;float:right;margin-top: 5px;margin-right:10px;display:none;
				background: url('../images/btn_down_wev8.png') right no-repeat;color: #004080;cursor: pointer;" _status="0">附加信息</div>
		</div>
		<table class="datatable feedrelate" cellpadding="0" cellspacing="0" border="0" align="center" style="display: none">
			<COLGROUP><COL width="20%"><COL width="80%"></COLGROUP>
			<TBODY>
				<tr style="display: none">
					<td class="title">相关客户</td>
					<td class="data">
						<input id="_crmids" name="_crmids" class="add_input" _init="1" _searchwidth="160" _searchtype="crm"/>
						<div class="btn_add"></div>
						<div class="btn_browser browser_crm" onClick="onShowCRM('_crmids')"></div>
						<input type="hidden" id="_crmids_val" value=","/>
					</td>
				</tr>
				<tr>
					<td class="title">相关文档</td>
					<td class="data">
						<input id="_docids" name="_docids" class="add_input" _init="1" _searchwidth="160" _searchtype="doc"/>
						<div class="btn_add"></div>
						<div class="btn_browser browser_doc" onClick="onShowDoc('_docids')"></div>
						<input type="hidden" id="_docids_val" value=","/>
					</td>
				</tr>
				<tr>
					<td class="title">相关流程</td>
					<td class="data">
						<input id="_wfids" name="_wfids" class="add_input" _init="1" _searchwidth="160" _searchtype="wf"/>
						<div class="btn_add"></div>
						<div class="btn_browser browser_wf" onClick="onShowWF('_wfids')"></div>
						<input type="hidden" id="_wfids_val" value=","/>
					</td>
				</tr>
				<tr>
					<td class="title">相关项目</td>
					<td class="data">
						<input id="_projectids" name="_projectids" class="add_input" _init="1" _searchwidth="160" _searchtype="proj"/>
						<div class="btn_add"></div>
						<div class="btn_browser browser_proj" onClick="onShowProj('_projectids')"></div>
						<input type="hidden" id="_projectids_val" value=","/>
					</td>
				</tr>
				<tr>
					<td class="title">相关附件</TD>
					<td class="data">
						<div id="fbUploadDiv" class="upload" mainId="82" subId="357" secId="1108" maxsize="60"></div>
					</td>
				</tr>
			</TBODY>
		</table>  			
  	</div>
	<div id="maininfo" style="width:100%;height: auto;position:absolute;top:70px;left:0px;bottom:0px;border-top:1px #E8E8E8 solid;" class="scroll1" align="center">
  		
  		<table id="feedbacktable" style="width: 100%;margin: 0px auto;text-align: left;margin-bottom: 3px;" cellpadding="0" cellspacing="0" border="0">
				<!-- 
				<jsp:include page="Operation.jsp">
					<jsp:param value="get_chance_contact" name="operation"/>
					<jsp:param value="<%=customerid %>" name="customerid"/>
					<jsp:param value="<%=lastdate %>" name="lastdate"/>
				</jsp:include>
				 -->
				<%if(_total==0){ %>
				<tr>
					<td class="data fbdata1">
						<div class="feedbackshow">
							<div class="feedbackinfo" style="font-style: italic;color:#999999">
								暂无相关反馈信息！
							</div>
						</div>
					</td>
				</tr>
				<%} %>
		</table>
		<div id="listmore2" class="datamore" style="display: none;" onclick="getListContact(this)" _datalist="datalist" _currentpage="0" _pagesize="<%=_pagesize %>" _total="<%=_total %>" _querysql="<%=sql+sqlwhere %>" title="显示更多数据">更多</div>	
	</div>
</div>
<script language=javascript defer>
	
</script>
<script language="javascript">
	var tempval = "";
	var uploader;
	var oldname = "";
	var foucsobj2 = null;
	var keyword = "请重点描述你对商机推进的目标、动作和成效：1、商务关系确定；2、决策人最为关心的内容是否得到支持3、联络人最为关心的内容是否得到支持；4、客户关键需求是否很好满足；5、产品方案亮点和引导的优势需求是否确定；6、对手劣势是否强化；7、还有什么风险及应对方案";
	var begindate = "<%=TimeUtil.getCurrentDateString()%>";
	$(document).ready(function(){

		//表格行背景效果及操作按钮控制绑定
		$("table.datatable").find("tr").bind("click mouseenter",function(){
			$(".btn_add").hide();$(".btn_browser").hide();
			$(this).addClass("tr_over");
			$(this).find(".input_def").addClass("input_over");
			$(this).find("div.content_def").addClass("content_over");
			if($(this).find("input.add_input").css("display")=="none"){
				$(this).find("div.btn_add").show();
				$(this).find("div.btn_browser").show();
			}
		}).bind("mouseleave",function(){
			$(this).removeClass("tr_over");
			$(this).find(".input_def").removeClass("input_over");
			$(this).find("div.content_def").removeClass("content_over");
			if($(this).find("input.add_input").css("display")=="none"){
				$(this).find("div.btn_add").hide();
				$(this).find("div.btn_browser").hide();
			}
		});

		//输入添加按钮事件绑定
		$("div.btn_add").bind("click",function(){
			$(this).hide();
			$(this).nextAll("div.btn_browser").hide();
			$(this).prevAll("div.showcon").hide();
			$(this).prevAll("input.add_input").show().focus();
			$(this).prevAll("div.btn_select").show()
		});

		//联想输入框事件绑定
		$("input.add_input").bind("focus",function(){
			if($(this).attr("_init")==1){
				$(this).FuzzyQuery({
					url:"GetData.jsp",
					record_num:5,
					filed_name:"name",
					searchtype:$(this).attr("_searchtype"),
					divwidth: $(this).attr("_searchwidth"),
					updatename:$(this).attr("id"),
					updatetype:"str",
					currentid:""
				});
				$(this).attr("_init",0);
			}
		}).bind("blur",function(e){
			$(this).val("");
			$(this).hide();
			$(this).nextAll("div.btn_add").show();
			$(this).nextAll("div.btn_browser").show();
			$(this).prevAll("div.showcon").show();
		});					
				

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
				$("table.feedrelate").show();
				$(this).attr("_status",1).css("background", "url('../images/btn_up_wev8.png') right no-repeat");
			}else{
				$("table.feedrelate").hide();
				$(this).attr("_status",0).css("background", "url('../images/btn_down_wev8.png') right no-repeat");
			}
			$("#maininfo").css("top",$("#fbmain").height()+$("#contacttitle").height());
		});

		$("#ContactInfo").val(keyword).attr("title",keyword).bind("focus",function(){
			if(this.value == keyword){
				this.value = "";
				$(this).removeClass("blur_text");
				$("div.btn_feedback").show();
				$("#fbrelatebtn").show();
				//$("#fbdate").show();
				$("#maininfo").css("top",$("#fbmain").height()+$("#contacttitle").height());
			}
		}).bind("blur",function(){
			/**
			if(this.value == ""){
				this.value = keyword;
				$(this).addClass("blur_text");
				$("div.btn_feedback").hide();
				var _status = $("#fbrelatebtn").attr("_status");
				if(_status==1) $("#fbrelatebtn").click();
				$("#fbrelatebtn").hide();
				$("#maininfo").css("top",$("#fbmain").height()+30);
			}
			*/
		});

		$(document).bind("click",function(e){
			var target=$.event.fix(e).target;
			if($(target).attr("id")!="ContactInfo" && !$(target).hasClass("wfb")){
				var obj = $("#ContactInfo")
				if($.trim(obj.val()) == ""){
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
				}
			}
			
		});
		
		bindUploaderDiv($("#fbUploadDiv"),"relateddoc","");

		<%if(_total>0){ %>$("#listmore2").click();<%}%>
		<%if(hidetitle.equals("1")){%>$("#contacttitle").height(0);$("#fbmain").css("top",0);$("#maininfo").css("top",$("#fbmain").height());<%} %>
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
	}
	function exeFeedback(){
		var relateddoc = $("#_docids_val").val();relateddoc = cutval(relateddoc);
		var relatedwf = $("#_wfids_val").val();relatedwf = cutval(relatedwf);
		var relatedcus = $("#_crmids_val").val();relatedcus = cutval(relatedcus);
		var relatedprj = $("#_projectids_val").val();relatedprj = cutval(relatedprj);
		var relatedfile = $("#relateAccDocids_"+$("#fbUploadDiv").attr("_index")).val();
		
		$("#submitload").show();
		$("div.btn_feedback").hide();
		//$("#fbdate").hide();
		$.ajax({
			type: "post",
			url: "Operation.jsp",
			contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			data:{"operation":"addquick","ContactInfo":encodeURI(ContactInfo),"CustomerID":<%=customerid%>,"relateddoc":relateddoc,"relatedwf":relatedwf,"relatedcus":<%=customerid%>,"relatedprj":relatedprj,"begindate":begindate,"relatedfile":relatedfile}, 
			complete: function(data){
				//getContact(begindate);
				var records = $.trim(data.responseText);
		    	$("#feedbacktable").prepend(records);
				$("#submitload").hide();
				$("div.btn_feedback").show();
				//$("#fbdate").show();
				cancelFeedback();
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
		    url: "Operation.jsp",
		    data:{"operation":"get_list_contact","istitle":0,"currentpage":_currentpage,"pagesize":_pagesize,"total":_total,"querysql":filter(encodeURI(_querysql))}, 
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
	function getMore(begindate,lastdate,customerid){
		$("#contactmore").html("<td style='height:25px;'><div style='width:100%;height:25px;background: url(../images/loading2_wev8.gif) center no-repeat;'></div></td>");
		$.ajax({
			type: "post",
		    url: "Operation.jsp",
		    data:{"operation":"get_chance_contact","begindate":begindate,"lastdate":lastdate,"customerid":customerid}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
		    	var records = $.trim(data.responseText);
		    	$("#contactmore").remove();
		    	$("#feedbacktable").append(records);
			}
	    });
	}
	function getContact(date){
		$.ajax({
			type: "post",
		    url: "Operation.jsp",
		    data:{"operation":"get_contactbyday","customerid":<%=customerid%>,"date":date}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
		    	var records = $.trim(data.responseText);
		    	$("#contact"+date).html(records);
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
<%!
	
%>
