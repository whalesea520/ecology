<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/mobilemode/init.jsp"%>
<html>
<head>
    <head>
	<title></title>
	<script type="text/javascript" src="/mobilemode/js/zclip/jquery.zclip.js"></script>
    <style type="text/css">
        *{
            font-family: 'Microsoft YaHei', Arial;
            margin: 0;
            padding: 0;
        }
        html,body{
            height: 100%;
            margin: 0px;
        }
        body{
        	overflow: hidden;
        }
        .title {
		    border-left: 6px solid #017afd;
		    height: 22px;
		    position: relative;
		    margin-top: 10px;
		}
		.title div {
		    height: 22px;
		    line-height: 22px;
		    position: absolute;
		    top: 0px;
		    left: 0;
		    background: #fff;
		    z-index: 1;
		    padding: 0px 13px;
		    font-size: 14px;
		    color: #333;
		}
		.title:after {
		    content: '';
		    height: 1px;
		    background-color: #ececec;
		    position: absolute;
		    left: 0px;
		    right: 0px;
		    top: 50%;
		}
		.content-bar {
		    padding-left: 15px;
		    overflow: hidden;
		}
		.content-bar div.system-var {
		    float: left;
		    margin: 10px 10px 0px 0px;
		    background: #efefef;
		    padding: 5px 10px;
		    border-radius: 5px;
		}
		.content-bar div.system-var.active{
			background: #ddd;
		}
		.content-text{
			margin: 10px 15px;
		    border: 1px dotted #ddd;
		    padding: 5px;
		    line-height: 22px;
		    color: #444;
		    border-radius: 3px;
		}
		#message {
			position: absolute;
		    top: 1px;
		    left: 50%;
		    padding: 5px 10px;
		    text-align: center;
		    font-family: 'Microsoft YaHei';
		    font-size: 13px;
		    z-index: 999;
		    border-radius: 3px;
		    transform: translateX(-50%);
			box-sizing: border-box;
			overflow: hidden;
			background: #000;
			display: none;
		}
		#message.success{
			color: #007AFB;
		}
		#message.error{
			color: #F699B4;	
		}
		#message.fff{
			color: #fff;
		}
		.tip{
			position: absolute;
		    top: 10px;
		    left: 50%;
		    transform: translateX(-50%);
		    color: #aaa;
		    font-size: 12px;
		    background: #fff;
		    z-index: 2;
		    height: 22px;
		    line-height: 22px;
		    padding: 0px 5px;
		}
    </style>

    <script>
        $(function(){
            $(".content-bar div.system-var").zclip({
				path : "/mobilemode/js/zclip/ZeroClipboard.swf",
				copy : function(){
					return $(this).attr("copy-content");
				},
				afterCopy : function(){
					//alert();
					showMsg("<%=SystemEnv.getHtmlLabelName(127484,user.getLanguage())%>", "fff", 1500);
				}
			});
        });
        
        function showMsg(msg, cn, t){
			var $msg = $("#message");
			$msg.html(msg);
			$msg.show();
			
			if(cn){
				$msg[0].className = "";
				$msg.addClass(cn);
			}
			
			if(t){
				setTimeout(function(){
					$msg.hide();
				}, t);
			}
		}
    </script>
</head>
<body>
<div id="message"></div>
<%if(user.getLanguage() == 7){ %>
<div class="tip">点击复制</div>
<div class="title"><div>系统变量</div></div>
<div class="content-bar">
	<div class="system-var" copy-content="{curruser}">{curruser} - 当前用户(ID)</div>
	<div class="system-var" copy-content="{currdept}">{currdept} - 当前部门(ID)</div>
	<div class="system-var" copy-content="{currdeptsub}">{currdeptsub} - 当前分部(ID)</div>
	<div class="system-var" copy-content="{currjobtitle}">{currjobtitle} - 当前岗位(ID)</div>
	
	<div class="system-var" copy-content="{currusername}">{currusername} - 当前用户名称(中文)</div>
	<div class="system-var" copy-content="{currdeptname}">{currdeptname} - 当前部门名称(中文)</div>
	<div class="system-var" copy-content="{currdeptsubname}">{currdeptsubname} - 当前分部名称(中文)</div>
	<div class="system-var" copy-content="{currjobtitlename}">{currjobtitlename} - 当前岗位名称(中文)</div>
	<div class="system-var" copy-content="{currloginid}">{currloginid} - 当前用户登录名(如:sysadmin)</div>
	
	<div class="system-var" copy-content="{uuid}">{uuid} - uuid</div>
	<div class="system-var" copy-content="{currdate}">{currdate} - 当前日期</div>
	<div class="system-var" copy-content="{currtime}">{currtime} - 当前时间</div>
	<div class="system-var" copy-content="{currdatetime}">{currdatetime} - 当前日期时间</div>
	
</div>
<div class="title" style="margin-top: 20px;"><div>页面参数</div></div>
<div class="content-text">
	我们使用下面的链接打开了一个id为3的页面，同时我们在链接中加上了名称为prjid的参数，如下：<br/>
	/mobilemode/appHomepageView.jsp?appHomepageId=3&prjid=15<br/>
	如果我们想在这个id为3的页面上获取参数prjid，我们可以这样写：<br/>
	{参数名称}，即 {prjid}，使用大括号参数名称就可以获取到了。<br/>
	移动建模所有的控件都是支持这种写法的。<br/>
</div>
<div class="title" style="margin-top: 20px;"><div>内置参数</div></div>
<div class="content-text">
	【列表】【时间轴】【表格】默认接收名称为<font color="red">sqlwhere</font>的参数，会将参数值作为查询过滤条件带入数据查询。<br/>
	例如：sqlwhere=type=1<br/>
	<br/>
	【表单】默认接收名称为<font color="red">billid</font>的参数，会将参数值作为数据id<br/>
	例如：我们已知项目的显示布局页面id为3，我们要显示id为15的项目信息，链接如下：<br/>
	/mobilemode/appHomepageView.jsp?appHomepageId=3&billid=15<br/>
</div>
<%}else if(user.getLanguage() == 8){ %>
<div class="tip">Click to copy</div>
<div class="title"><div>System variables</div></div>
<div class="content-bar">
	<div class="system-var" copy-content="{curruser}">{curruser} - Current user(ID)</div>
	<div class="system-var" copy-content="{currdept}">{currdept} - Current department(ID)</div>
	<div class="system-var" copy-content="{currdeptsub}">{currdeptsub} - Current subcompany(ID)</div>
	<div class="system-var" copy-content="{currjobtitle}">{currjobtitle} - Current jobtitle(ID)</div>
	
	<div class="system-var" copy-content="{currusername}">{currusername} - Current user name</div>
	<div class="system-var" copy-content="{currdeptname}">{currdeptname} - Current department name</div>
	<div class="system-var" copy-content="{currdeptsubname}">{currdeptsubname} - Current subcompany name</div>
	<div class="system-var" copy-content="{currjobtitlename}">{currjobtitlename} - Current jobtitle name</div>
	<div class="system-var" copy-content="{currloginid}">{currloginid} - Current user login name(Such as:sysadmin)</div>
	
	<div class="system-var" copy-content="{uuid}">{uuid} - uuid</div>
	<div class="system-var" copy-content="{currdate}">{currdate} - Current date</div>
	<div class="system-var" copy-content="{currtime}">{currtime} - Current time</div>
	<div class="system-var" copy-content="{currdatetime}">{currdatetime} - Current date time</div>
	
</div>
<div class="title" style="margin-top: 20px;"><div>Page variables</div></div>
<div class="content-text">
	We use the link below to open a page with an id of 3, and we add a parameter named prjid to the link as follows:<br/>
	/mobilemode/appHomepageView.jsp?appHomepageId=3&prjid=15<br/>
	If we want to get the parameter prjid on this id 3 page, we can write:<br/>
	{Param Name}, {prjid}, can be obtained using the braces parameter name.<br/>
	All controls for mobile modeling support this type of writing.<br/>
</div>
<div class="title" style="margin-top: 20px;"><div>Built-in parameters</div></div>
<div class="content-text">
	[List] [Time Line] [Table] By default, a parameter named <font color="red">sqlwhere</font> is accepted, and the parameter value is used as a query filter condition to bring the data query.<br/>
	Such as：sqlwhere=type=1<br/>
	<br/>
	[Form] accepts the parameter named <font color="red">billid</font> by default, and takes the parameter value as the data id<br/>
	For example: the display layout page id is 3, to display item information with id 15, the link is as follows:<br/>
	/mobilemode/appHomepageView.jsp?appHomepageId=3&billid=15<br/>
</div>
<%}else if(user.getLanguage() == 9){ %>
<div class="tip">點擊復制</div>
<div class="title"><div>系統變量</div></div>
<div class="content-bar">
	<div class="system-var" copy-content="{curruser}">{curruser} - 當前用戶(ID)</div>
	<div class="system-var" copy-content="{currdept}">{currdept} - 當前部門(ID)</div>
	<div class="system-var" copy-content="{currdeptsub}">{currdeptsub} - 當前分部(ID)</div>
	<div class="system-var" copy-content="{currjobtitle}">{currjobtitle} - 當前崗位(ID)</div>
	
	<div class="system-var" copy-content="{currusername}">{currusername} - 當前用戶名稱(中文)</div>
	<div class="system-var" copy-content="{currdeptname}">{currdeptname} - 當前部門名稱(中文)</div>
	<div class="system-var" copy-content="{currdeptsubname}">{currdeptsubname} - 當前分部名稱(中文)</div>
	<div class="system-var" copy-content="{currjobtitlename}">{currjobtitlename} - 當前崗位名稱(中文)</div>
	<div class="system-var" copy-content="{currloginid}">{currloginid} - 當前用戶登錄名(如:sysadmin)</div>
	
	<div class="system-var" copy-content="{uuid}">{uuid} - uuid</div>
	<div class="system-var" copy-content="{currdate}">{currdate} - 當前日期</div>
	<div class="system-var" copy-content="{currtime}">{currtime} - 當前時間</div>
	<div class="system-var" copy-content="{currdatetime}">{currdatetime} - 當前日期時間</div>
	
</div>
<div class="title" style="margin-top: 20px;"><div>頁面參數</div></div>
<div class="content-text">
	我們使用下面的鏈接打開了壹個id為3的頁面，同時我們在鏈接中加上了名稱為prjid的參數，如下：<br/>
	/mobilemode/appHomepageView.jsp?appHomepageId=3&prjid=15<br/>
	如果我們想在這個id為3的頁面上獲取參數prjid，我們可以這樣寫：<br/>
	{參數名稱}，即 {prjid}，使用大括號參數名稱就可以獲取到了。<br/>
	移動建模所有的控件都是支持這種寫法的。<br/>
</div>
<div class="title" style="margin-top: 20px;"><div>內置參數</div></div>
<div class="content-text">
	【列表】【時間軸】【表格】默認接收名稱為<font color="red">sqlwhere</font>的參數，會將參數值作為查詢過濾條件帶入數據查詢。<br/>
	例如：sqlwhere=type=1<br/>
	<br/>
	【表單】默認接收名稱為<font color="red">billid</font>的參數，會將參數值作為數據id<br/>
	例如：我們已知項目的顯示布局頁面id為3，我們要顯示id為15的項目信息，鏈接如下：<br/>
	/mobilemode/appHomepageView.jsp?appHomepageId=3&billid=15<br/>
</div>
<%} %>
</body>
</html>
