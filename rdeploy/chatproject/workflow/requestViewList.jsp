<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowRequestInfo" %>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowBaseInfo" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="session"/>
<jsp:useBean id="workflowServiceImpl" class="weaver.mobile.webservices.workflow.WorkflowServiceImpl" scope="session"/>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
int pageNo = 1;
int pageSize = 10;
String viewtype = Util.null2String(request.getParameter("viewtype"));
String [] sqlConditions = null;
if(!"0".equals(viewtype)){
	sqlConditions = new String[]{" t1.workflowid in (select wb.id from workflow_base wb,workflow_type wt where wb.workflowtype=wt.id and wt.id=  "+viewtype+") "};
}else{
	sqlConditions = new String[]{};
}
int userid = user.getUID();
int recordCount = workflowServiceImpl.getToDoWorkflowRequestCount(userid, true, sqlConditions);
WorkflowRequestInfo[] wriarrays = workflowServiceImpl.getToDoWorkflowRequestList(true,pageNo,pageSize,recordCount,userid,sqlConditions,0);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
  	<link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/wf/requestshow.css">
  	<script type="text/javascript">
  	jQuery(document).ready(function(){
	  	//运行瀑布流主函数
  		//设置滚动加载
  		window.onscroll = function(){
  			//校验数据请求
  			if(getCheck()){
  			//------
  				getAjaxData();
  				//--
  				ajaxRefresh();
  			}
  		}
	  	
	  	jQuery(".viewtypenum",window.parent.document).html("（<%=recordCount%>）");
	  	jQuery("html").mousedown(function (e){ 
       		parent.$(".hiddensearch").animate({
				height: 0
				}, 200,null,function() {
					parent.jQuery(".hiddensearch").hide();
			}); 
       		parent.jQuery(".opensright").hide();
       		parent.jQuery(".selectstatus").hide();
			parent.jQuery(".sbPerfectBar").hide();
		});
	  	ajaxRefresh();
  	});
  	
  	function ajaxRefresh(){
  		setTimeout(function(){
	  		getAjaxDataAgain();
	  	},200)
  	}
  	/**
  	* 瀑布流主函数
  	* @param  contentbox	[Str] 外层元素的ID
  	* @param  box 	[Str] 每一个box的类名
  	*/
  	function waterfall(contentbox,box){
  		//1.获得外层以及每一个box
  		var contentbox = document.getElementById(contentbox);
  		var boxs  = getClass(contentbox,box);
  		//2.获得屏幕可显示的列数
  		var boxW = boxs[0].offsetWidth;
  		var colsNum = Math.floor(document.documentElement.clientWidth/boxW);
  		contentbox.style.width = boxW*colsNum+'px';//为外层赋值宽度
  		//3.循环出所有的box并按照瀑布流排列
  		var everyH = [];//定义一个数组存储每一列的高度
  		for (var i = 0; i < boxs.length; i++) {
  			if(i<colsNum){
  				everyH[i] = boxs[i].offsetHeight;
  			}else{
  				var minH = Math.min.apply(null,everyH);//获得最小的列的高度
  				var minIndex = getIndex(minH,everyH); //获得最小列的索引
  				getStyle(boxs[i],minH,boxs[minIndex].offsetLeft,i);
  				everyH[minIndex] += boxs[i].offsetHeight;//更新最小列的高度
  			}
  		}
  	}
  	/**
  	* 获取类元素
  	* @param  warp		[Obj] 外层
  	* @param  className	[Str] 类名
  	*/
  	function getClass(contentbox,className){
  		var obj = contentbox.getElementsByTagName('*');
  		var arr = [];
  		for(var i=0;i<obj.length;i++){
  			if(obj[i].className == className){
  				arr.push(obj[i]);
  			}
  		}
  		return arr;
  	}
  	/**
  	* 获取最小列的索引
  	* @param  minH	 [Num] 最小高度
  	* @param  everyH [Arr] 所有列高度的数组
  	*/
  	function getIndex(minH,everyH){
  		for(index in everyH){
  			if (everyH[index] == minH ) return index;
  		}
  	}
  	/**
  	* 数据请求检验
  	*/
  	function getCheck(){
  		var documentH = document.documentElement.clientHeight;
  		var scrollH = document.documentElement.scrollTop || document.body.scrollTop;
  		return documentH+scrollH>=getLastH() ?true:false;
  	}
  	/**
  	* 获得最后一个box所在列的高度
  	*/
  	function getLastH(){
  		var contentbox = document.getElementById('contentbox');
  		var boxs = getClass(contentbox,'box');
  		return boxs[boxs.length-1].offsetTop+boxs[boxs.length-1].offsetHeight;
  	}
  	/**
  	* 设置加载样式
  	* @param  box 	[obj] 设置的Box
  	* @param  top 	[Num] box的top值
  	* @param  left 	[Num] box的left值
  	* @param  index [Num] box的第几个
  	*/
  	var getStartNum = 0;//设置请求加载的条数的位置
  	function getStyle(box,top,left,index){
  	    if (getStartNum>=index) return;
  	    $(box).css({
  	    	'position':'absolute',
  	        'top':top,
  	        "left":left,
  	        "opacity":"0"
  	    });
  	    $(box).stop().animate({
  	        "opacity":"1"
  	    },999);
  	    getStartNum = index;//更新请求数据的条数位置
  	}
  	
  	var recordCountnew = 0;
  	function getAjaxData(obj){
  		$.ajax({
			type: "post",
		    url: "/rdeploy/chatproject/workflow/requestLiatAjax.jsp?_" + new Date().getTime() + "=1&",
		    data: {"actionkey":"requestview",
		    		"pageNo":(obj == "1")?0:jQuery("#pageNo").val(),
		    		"viewtype":jQuery("#viewtype").val()
		    	  },
		    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		    complete: function(){
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    } , 
		    success:function (data, textStatus) {
		    	var _data;
				if(!jQuery.isArray(data) && jQuery.trim(data) != "")
					_data = JSON.parse(data);
                else
                	_data=eval(data);
		    	/////////////
		    	var contentbox = jQuery("#contentbox");
		    	if(obj == "1"){
			    	contentbox.html("");
		    	}
		    	var html = "";
		    	for(var j=0;j<_data.length;j++){
  					//创建box、line
  					html += "<div class=\"box\"> "+
  							" <div style=\"height: 84px;\"> "+
							" <div class=\"pic\"> "+
							" <img src=\""+_data[j].createrurl+"\" style=\"width:45px;height:45px;border-radius:30px;margin-top:29px;\"> "+
							" </div> "+
							" <div class=\"info\"> "+
							" <div class=\"title\"> "+ 
							//_data[j].requestname +
							" <a href=\"javaScript:openFullWindowHaveBarForWFList('/workflow/request/ViewRequest.jsp?requestid="+_data[j].requestid+"&amp;isovertime=0',"+_data[j].requestid+");doReadIt("+_data[j].requestid+",'',this);\">"+_data[j].requestname+"</a> "+
							" <span id='wflist_"+_data[j].requestid+"span'></span>"+
							" </div> "+
							" <div class=\"createrinfo\"> "+
							" <a href=\"javaScript:openhrm("+_data[j].createrid+");\" onclick=\"pointerXY(event);\">"+_data[j].creatername+"</a> "+
							" &nbsp;&nbsp;"+_data[j].creatertime+" "+
							" </div> "+
							" </div> "+
							" <div class=\"showtype\">"+_data[j].wftypename+"</div> "+
							" </div> "+
							" <div class=\"showrequestline1\"> </div>	"+
							" </div> ";
  					recordCountnew = _data[j].recordCount;
		    	//alert(html);
  				}
				contentbox.append(html);
  				///waterfall('contentbox','box');
  				try {
  					if(obj == "1"){
  						jQuery(".viewtypenum",window.parent.document).html("（"+recordCountnew+"）");
  					}
		    		var index = parseInt(jQuery("#pageNo").val());
		    		//ismodify = parseInt(jQuery("input[name=ismodify_"+id+"]").val());
		    	} catch (e) {}
  				//jQuery("#pageNo").val(index+1);
		    	/////////////
		    	
  				isload = false;
		    } 
    	});
  	}
  	//function reLoad(){
  	//	alert(122);
  	//}
  	var isload = false;
  	_table = {
        "reLoad":function () {
        	
        	if (!!isload) {
        		return;
        	} else {
        		isload = true;
        	}
        	getAjaxData("1");
    		//--
    	  	jQuery("html").mousedown(function (e){ 
           		parent.$(".hiddensearch").animate({
    				height: 0
    				}, 200,null,function() {
    					parent.jQuery(".hiddensearch").hide();
    			}); 
           		parent.jQuery(".opensright").hide();
           		parent.jQuery(".selectstatus").hide();
    			parent.jQuery(".sbPerfectBar").hide();
    		});
    	  	setTimeout(function(){
    	  		getAjaxDataAgain("1");
    	  	},200)
  		}
  	};
  	
  	function getAjaxDataAgain(obj){
  		$.ajax({
			type: "post",
		    url: "/rdeploy/chatproject/workflow/requestLiatAjax.jsp?_" + new Date().getTime() + "=1&",
		    data: {"actionkey":"requestview",
		    		"actionkeyagain":"again",
		    		"pageNo":(obj == "1")?0:jQuery("#pageNo").val(),
		    		"viewtype":jQuery("#viewtype").val()
		    	  },
		    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		    complete: function(){
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    } , 
		    success:function (data, textStatus) {
		    	var _data;
				if(!jQuery.isArray(data) && jQuery.trim(data) != "")
					_data = JSON.parse(data);
                else
                	_data=eval(data);
		    	/////////////
		    	for(var j=0;j<_data.length;j++){
  					//创建box、line
  					var returnStr = "";
  					var requestid = _data[j].requestid;
  					var viewtype = _data[j].viewtype;
  					var isprocessed = _data[j].isprocessed;
  					var agenttype = _data[j].agenttype;
  					//alert(viewtype);
  					if (viewtype == "0") {
						// 新流程,粗体链接加图片
						if (isprocessed == "true") {
							returnStr = "<img src='/images/ecology8/statusicon/BDOut_wev8.png' title='<%=SystemEnv.getHtmlLabelName(19081, user.getLanguage())%>'/>";
						} else if ("1" == agenttype) {
							returnStr = "<img src='/images/ecology8/statusicon/BDNew_wev8.png' title='<%=SystemEnv.getHtmlLabelName(19154, user.getLanguage())%>'/>";
						} else {
							returnStr = "<img src='/images/ecology8/statusicon/BDNew_wev8.png' title='<%=SystemEnv.getHtmlLabelName(19154, user.getLanguage())%>'/>";
						}
					} else if (viewtype == "-1") {
						// 旧流程,有新的提交信息未查看,普通链接加图片
						if (isprocessed == "true") {
							returnStr = "<img src='/images/ecology8/statusicon/BDOut_wev8.png' title='<%=SystemEnv.getHtmlLabelName(19081, user.getLanguage())%>'/>";
						} else {
							returnStr = "<img src='/images/ecology8/statusicon/BDNew2_wev8.png' title='<%=SystemEnv.getHtmlLabelName(20288, user.getLanguage())%>'/>";
						}
					} else {
						// 旧流程,普通链接
						if (isprocessed == "true") {
							returnStr = "<img src='/images/ecology8/statusicon/BDOut_wev8.png' title='<%=SystemEnv.getHtmlLabelName(19081, user.getLanguage())%>'/>";
						} else {
							returnStr = "";
						}
					}
  					//alert(returnStr);
  					jQuery("#wflist_"+requestid+"span").html(returnStr);
  				}
		    	var index = parseInt(jQuery("#pageNo").val());
		    	jQuery("#pageNo").val(index+1);
		    }
    	});
  	}
  	
  	</script>
  </head>
  <body>
  	<div class="contentbox" id="contentbox">
  		<!-- item block 循环开始 -->
  		<% //RecordSet.executeSql(viewsql);
  		for(int i = 0;i<wriarrays.length;i++){
  		WorkflowBaseInfo wbi = wriarrays[i].getWorkflowBaseInfo();
  		String conodeid = wriarrays[i].getCurrentNodeId();
  		String isremark = wriarrays[i].getIsremark()+"";
  		String requestname = "";
  		String nodetitle = "";
  		String requestnamenew = wriarrays[i].getRequestName();
  		if ("0".equals(isremark)) {
  			rs.executeSql("select t1.requestname,t2.nodetitle from workflow_requestbase t1,workflow_flownode t2 where t1.requestid ="+wriarrays[i].getRequestId()+
					" and t1.workflowid = t2.workflowid and t2.workflowid="+ wbi.getWorkflowId() + 
					" and t2.nodeid=" + conodeid);
			//System.out.println("select nodetitle from workflow_flownode where workflowid="
			//		+ wbi.getWorkflowId() + " and nodeid=" + conodeid);
			if (rs.next()) {
				requestname = Util.null2String(rs.getString("requestname"));
				nodetitle = Util.null2String(rs.getString("nodetitle"));
			}
		}
  		if (!"".equals(requestname) && !"null".equalsIgnoreCase(requestname)) {
			int index = requestnamenew.indexOf(requestname);
			if(index > -1){
				requestnamenew = requestnamenew.substring(requestname.length());
				if(!"".equals(requestnamenew) && !"null".equalsIgnoreCase(requestnamenew)){
					requestnamenew = "<B>" + requestnamenew + "</B>";
				}
			}
		}
		
		if (!"".equals(nodetitle) && !"null".equalsIgnoreCase(nodetitle)) {
			nodetitle = "（" + nodetitle + "）";
		}
		requestnamenew = nodetitle + requestname + requestnamenew;
  		%>
		<div class="box">
			<div style="height: 84px;">
				<div class="pic">
					<img src="<%=resourceComInfo.getMessagerUrls(wriarrays[i].getCreatorId())%>" style="width:45px;height:45px;border-radius:30px;margin-top:29px;">
				</div>
				<div class="info">
					<div class="title">
						<a href="javaScript:openFullWindowHaveBarForWFList('/workflow/request/ViewRequest.jsp?requestid=<%=wriarrays[i].getRequestId()%>&amp;isovertime=0',<%=wriarrays[i].getRequestId()%>);doReadIt(<%=wriarrays[i].getRequestId()%>,'',this);"><%=requestnamenew %></a>
						<span id='wflist_<%=wriarrays[i].getRequestId()%>span'></span>
					</div>
					<div class="createrinfo">
						<a href="javaScript:openhrm(<%=wriarrays[i].getCreatorId()%>);" onclick="pointerXY(event);"><%=resourceComInfo.getResourcename(wriarrays[i].getCreatorId())%></a>
						&nbsp;&nbsp;<%=wriarrays[i].getCreateTime()%>
					</div>
				</div>
				<div class="showtype"><%=wbi.getWorkflowTypeName()%></div>
			</div>
			<div class="showrequestline1"> </div>
		</div>
  		<% }%>
  	</div>
  	<input type="hidden" name="pageNo" id="pageNo" value="<%=pageNo%>">
  	<input type="hidden" name="viewtype" id="viewtype" value="<%=viewtype%>">
  </body>
</html>
