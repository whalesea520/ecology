<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/mobilemode/init.jsp"%>
<html>
<head>
    <head>
	<title></title>
	<script type="text/javascript" src="/formmode/js/jquery/nicescroll/jquery.nicescroll.min_wev8.js"></script>
    <style type="text/css">
        *{
            font-family: 'Microsoft YaHei', Arial;
            margin: 0;
            padding: 0;
        }
        html,body{
            height: 100%;
            margin: 0px;
            padding: 0px;
			overflow: auto;
			box-sizing: border-box;
        }
        body{
            padding: 10px 10px 20px 10px;
        }
        table{
            FONT-SIZE: 9pt;
        }
        .mainTable{
            width: 100%;
            border-collapse: collapse;
            display: none;
        }
        .mainTable td{
            border-bottom: 1px dotted #ccc;
            padding: 5px 2px;
            vertical-align: top;
            color: #666;
        }
        .mainTable td.label{
            font-weight: bold;
            text-align: right;
            color: #333;
        }
        .mainTable td .content div{
            line-height: 20px;
        }
        .mainTable tr.noborder td{
            border-bottom: none;
        }
        .p_table{
            width: 100%;
            border-collapse: collapse;
        }
        .p_table td{
            padding: 0px;
            padding-bottom: 10px;
            border-bottom: none;
            padding-right: 5px;
        }
        .p_table tr:last-child td{
            padding-bottom: 5px;
        }
        .p_table td.p_required{
            color: #bbb;
            white-space: nowrap;
        }
        .p_table td.p_type{
            color: #bbb;
        }
        .resurnContent{
            line-height: 20px;
            margin-top: -2px;
        }
        .codeContainer{
            width: 99%;
            font-size: 12px;
            color:#666;
            line-height:23px;
            resize: none;
            overflow-x: hidden;
            background-color: #f7f7f7;
            border: solid 1px #e8e8e8;
            border-radius: 5px;
            padding: 5px;
        }
        .e8_data_list strong{
        	color:red;
        }
        .e8_data_list code{
        	color:#0464bb;
        }
        .e8_data_label{
            font-size: 14px;
            color: #000;
            border-bottom: 1px solid #aaa;
        }
        .e8_data_list dd{
            padding: 5px 10px;
            padding-left: 15px;
            border-bottom: 1px dashed #ddd;
        }
        .e8_data_list dd{
            background: url("/mobilemode/images/member-collapsed.gif") no-repeat 0px 15px;
        }
        .e8_data_list dd:hover{
            background: url("/mobilemode/images/member-hover.gif") no-repeat 0px 15px;
        }
        .e8_data_list .item_label{
            font-size: 12px;
            color: #000;
            line-height: 20px;
        }
        .e8_data_list .item_desc{
            color: #aaa;
            font-size: 11px;
        }
        .browserBtn{
	        width: 16px;
		    height: 22px;
		    background-image: url("/wui/theme/ecology8/skins/default/general/browser_wev8.png");
		    background-color: rgba(0,0,0,0);
		    background-position: 0 50%;
		    background-repeat: no-repeat;
		    position: absolute;
		    top:2px;
	    }
	    select{
		    border: 1px solid #ccc;
		    height: 25px;
		    width: 135px;
	    }
	    input{
	    	width: 200px;
		    border: 1px solid #ccc;
		    height: 23px;
		    padding-left: 5px;
		    font: 12px Microsoft YaHei;
	    }
	    .codeContainer .field{
	    	margin-bottom:5px;
	    }
	    .codeContainer .field label{
	    	width:75px;
	    	display:block;
	    	float:left;
	    }
	    div.field:nth-child(3){
	    	position:relative;
	    	margin-left:75px;
	    	display:none;
	    }
	    div.field:nth-child(2) div:nth-child(3){
	    	position:absolute;
	    	left:215px;
	    	top:2px;
	    	color: #017afd;
	    	cursor: pointer;
	    }
    </style>

    <script>
        $(function(){
            //$("html").niceScroll();
            $(".e8_data_list dd").toggle(function(){
            	var $that = $(this);
            	$that.css("background-image", "url('/mobilemode/images/member-expanded.gif')");
            	$(".mainTable", $that).show();
            }, function(){
            	var $that = $(this);
            	$that.css("background-image", "");
            	$(".mainTable", $that).hide();
            });
            $(".e8_data_list .item_detail").bind("click", function(e){
            	e.stopPropagation();
            });
            
        });
    </script>
</head>
<body>
<%if(user.getLanguage() == 7){ %>
<div class="e8_data_label">
    用户类
</div>
<dl class="e8_data_list">
    <dd>
    	<div class="item_header">
    		<div class="item_label">$m.getUser();</div>
        	<div class="item_desc">通过此方法可以获取用户相关信息</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">参数：</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">id</td>
                                <td class="p_required">[可选]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">用户id，如果不传参数，则默认返回当前登录用户，参数ID支持变量。<strong>注意：参数为string类型在传参时需要加双引号</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">返回：</td>
                    <td>
                        <div class="resurnContent">
                            用户相关信息
                        </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">示例：</td>
                    <td>
                        <div>
                <div class="codeContainer">该方法默认返回的是一个用户对象，如需直接返回该对象的某个属性，可以通过".属性"的方式返回，表达式必须以<strong>$m.</strong>开头，<strong>分号 ; </strong>结尾，如下示例所示：
					<div>当前用户的登录ID：</div><div><code>$m.getUser().loginid;</code></div>
					<div>当前用户的登录ID：</div><div><code>$m.getUser("{CURRUSER}").loginid;</code></div>
					<div>指定用户的登录ID：</div><div><code>$m.getUser("{id}").loginid;</code>(括号中的ID可以是url传递变量，也可以是数据集变量{t.id}形式)</div>
					<div>ID为3的用户姓名：</div><div><code>$m.getUser("3").lastname;</code></div>
					<div>ID为3的用户邮箱：</div><div><code>$m.getUser("3").email;</code></div>
					<div>ID为3的用户手机：</div><div><code>$m.getUser("3").mobile;</code></div>
					<div>ID为3的姓：</div><div><code>$m.getUser("3").firstname;</code></div>
					<div>ID为3的名：</div><div><code>$m.getUser("3").lastname;</code></div>
					<div>ID为3的昵称：</div><div><code>$m.getUser("3").aliasname;</code></div>
					<div>ID为3的收货地址：</div><div><code>$m.getUser("3").receiveaddress;</code></div>
                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
    <dd>
        <div class="item_header">
    		<div class="item_label">$m.getAvatar();</div>
        	<div class="item_desc">通过此方法可以获取用户头像</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">参数：</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">ids</td>
                                <td class="p_required">[必须]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">用户id，如果需要获取多个用户的头像，传入用逗号分隔的参数即可，参数支持变量。<strong>注意：参数为string类型在传参时需要加双引号</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">返回：</td>
                    <td>
                        <div class="resurnContent">
                            包含头像信息的html标签
                        </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">示例：</td>
                    <td>
                        <div>
                <div class="codeContainer">
                表达式必须以<strong>$m.</strong>开头，<strong>分号 ; </strong>结尾，如下示例所示：
                <div>当前用户头像：</div><div><code>$m.getAvatar("{CURRUSER}");</code></div>
                <div>指定用户的头像：</div><div><code>$m.getAvatar("{id}");</code>(括号中的ID可以是url传递变量，也可以是数据集变量{t.id}形式)</div>
				<div>ID为3的用户头像：</div><div><code>$m.getAvatar("3");</code></div>
				<div>ID为3，4的用户头像：</div><div><code>$m.getAvatar("3,4");</code></div>
                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
    <dd>
        <div class="item_header">
    		<div class="item_label">$m.getDepartment();</div>
        	<div class="item_desc">通过此方法可以获取用户部门</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">参数：</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">id</td>
                                <td class="p_required">[可选]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">用户id，如果不传参，则默认获取当前用户部门，参数支持变量。<strong>注意：参数为string类型在传参时需要加双引号</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">返回：</td>
                    <td>
                        <div class="resurnContent">
                            用户部门名称
                        </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">示例：</td>
                    <td>
                        <div>
                <div class="codeContainer">
                表达式必须以<strong>$m.</strong>开头，<strong>分号 ; </strong>结尾，如下示例所示：
                <div>当前用户部门：</div><div><code>$m.getDepartment();</code></div>
                <div>当前用户部门：</div><div><code>$m.getDepartment("{CURRUSER}");</code></div>
                <div>指定用户部门：</div><div><code>$m.getDepartment("{id}");</code>(括号中的ID可以是url传递变量，也可以是数据集变量{t.id}形式)</div>
                <div>ID为4的用户部门：</div><div><code>$m.getDepartment("4");</code></div>
                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
    <dd>
        <div class="item_header">
    		<div class="item_label">$m.getManager();</div>
        	<div class="item_desc">通过此方法可以获取用户上级</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">参数：</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">id</td>
                                <td class="p_required">[可选]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">用户id，如果不传参，则默认获取当前用户上级，参数支持变量。<strong>注意：参数为string类型在传参时需要加双引号</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">返回：</td>
                    <td>
                        <div class="resurnContent">
                            用户上级名称
                        </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">示例：</td>
                    <td>
                        <div>
                <div class="codeContainer">
                表达式必须以<strong>$m.</strong>开头，<strong>分号 ; </strong>结尾，如下示例所示：
                <div>当前用户上级：</div><div><code>$m.getManager();</code></div>
                <div>当前用户上级：</div><div><code>$m.getManager("{CURRUSER}");</code></div>
                <div>指定用户上级：</div><div><code>$m.getManager("{id}");</code>(括号中的ID可以是url传递变量，也可以是数据集变量{t.id}形式)</div>
				<div>ID为4的用户上级：</div><div><code>$m.getManager("4");</code></div>
                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
</dl>
<div class="e8_data_label" style="margin-top:15px;">
    浏览框类
</div>
<dl class="e8_data_list">
	<dd>
        <div class="item_header">
    		<div class="item_label">$m.getBrowserText();</div>
        	<div class="item_desc">通过此方法可以获取浏览框的显示文本</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">参数：</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">ids</td>
                                <td class="p_required">[必须]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">浏览框id,多个id以逗号分隔，参数支持变量。<strong>注意：参数为string类型在传参时需要加双引号</strong></td>
                            </tr>
                            <tr>
                                <td class="p_name">typeid</td>
                                <td class="p_required">[必须]</td>
                                <td class="p_type">int</td>
                                <td class="p_explain">字段详细类型(1：人力资源 2：日期 3：会议室联系单 4：部门 5：仓库 6：成本中心 7：客户 8：项目 9：文档 10：入库方式 11：出库方式 12：币种 13：资产种类 14：科目－全部 15：科目－明细 16：请求 17：多人力资源 18：多客户 19：时间 20：计划类型 21：计划种类 22：报销费用类型 23：资产 24：职务 25：资产组 26：车辆 27：应聘人 28：会议 29：奖惩种类 30：学历 31：用工性质 32：培训安排 33：加班类型 34：请假类型 35：业务合同 36：合同性质 37：多文档 38：相关产品 161:自定义单选 162:自定义多选 256:自定义树形单选 257:自定义树形多选)</td>
                            </tr>
                            <tr>
                                <td class="p_name">fielddbtype</td>
                                <td class="p_required">[必须]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">字段数据库类型  <strong>注意：参数为string类型在传参时需要加双引号</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">返回：</td>
                    <td>
                        <div class="resurnContent">浏览框对应ID的显示文本 </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">示例：</td>
                    <td>                    
                        <div>
			                <div class="codeContainer">
				                <div style="position:relative;">
				                	代码生成：
					                <div class="field" style="display:none;">
					                	<label>浏览框值：</label>
					                	<input id="browservalue" type="text" placeholder="请输入浏览框值"/>
					                </div>
					                <div class="field" style="position:relative;">
					                	<label>浏览框类型：</label>
					                	<select id="browsertype" name="browsertype"></select>
					                	
					                </div>
					                <div class="field">
					                	<input id="_browsername" type="hidden" readonly="readonly"/>
					                	<input id="browsername" type="text" readonly="readonly"/>
					    				<button type="button" onclick="openBrowserChoose()" class="browserBtn"></button>
					    			</div>
					    			<div class="field result">
					    				<label>结果：</label>
					    				<code>$m.getBrowserText("请输入要替换的字段值", -1, "");</code>
					    			</div>
				                </div>
			                	表达式必须以<strong>$m.</strong>开头，<strong>分号 ; </strong>结尾，如下示例所示：
				                <div>获取人力资源浏览框值：</div><div><code>$m.getBrowserText("1", 1, "");</code></div>
				                <div>获取人力资源浏览框值(变量方式)：</div><div><code>$m.getBrowserText("{id}", 1, "");</code></div>
				                <div>获取多人力资源浏览框值：</div><div><code>$m.getBrowserText("1,2,3", 1, "");</code></div>
				                <div>获取自定义单选浏览框值：</div><div><code>$m.getBrowserText("1", 161, "browser.test");</code></div>
				                <div>获取自定义树形单选浏览框值：</div><div><code>$m.getBrowserText("1_1", 256, "1");</code></div>
			                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
</dl>
<div class="e8_data_label" style="margin-top:15px;">
    下拉框类
</div>
<dl class="e8_data_list">
	<dd>
        <div class="item_header">
    		<div class="item_label">$m.getSelectText();</div>
        	<div class="item_desc">通过此方法可以获取下拉框的显示文本</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">参数：</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">value</td>
                                <td class="p_required">[必须]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">下拉框的真实值，一般是id。参数支持变量。<strong>注意：参数为string类型在传参时需要加双引号</strong></td>
                            </tr>
                            <tr>
                                <td class="p_name">idOrName</td>
                                <td class="p_required">[必须]</td>
                                <td class="p_type">String</td>
                                <td class="p_explain">可以是 (1)建模表字段id，如19661 或 (2)表名称.字段名称，如tableA.name</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">返回：</td>
                    <td>
                        <div class="resurnContent">下拉框对应value的显示文本 </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">示例：</td>
                    <td>                    
                        <div>
			                <div class="codeContainer">
			                	表达式必须以<strong>$m.</strong>开头，<strong>分号 ; </strong>结尾，如下示例所示：
				                <div>字段id作为参数：</div><div><code>$m.getSelectText("1","19661");</code></div>
				                <div>表名字段名作为参数：</div><div><code>$m.getSelectText("1","uf_cc_test.xb");</code></div>
			                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
</dl>
<div class="e8_data_label" style="margin-top:15px;">
    显示转换类
</div>
<dl class="e8_data_list">
	<dd>
        <div class="item_header">
    		<div class="item_label">$m.convertToStar();</div>
        	<div class="item_desc">通过此方法可以将星级评分插件存储在数据库中的值转换为星级显示</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">参数：</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">value</td>
                                <td class="p_required">[必须]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">星级评分插件存储在数据库中的值。<strong>注意：参数为string类型在传参时需要加双引号</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">返回：</td>
                    <td>
                        <div class="resurnContent">显示星级的html，可直接用于在页面上显示 </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">示例：</td>
                    <td>                    
                        <div>
			                <div class="codeContainer">
			                	表达式必须以<strong>$m.</strong>开头，<strong>分号 ; </strong>结尾，如下示例所示：
				                <div>如在列表插件中使用：</div><div><code>$m.convertToStar("{星级评分插件对应的字段名称}");</code></div>
			                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
</dl>
<%}else if(user.getLanguage() == 8){ %>
<div class="e8_data_label">
    User
</div>
<dl class="e8_data_list">
    <dd>
    	<div class="item_header">
    		<div class="item_label">$m.getUser();</div>
        	<div class="item_desc">Use this method to get information about the user.</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">Parameter:</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">id</td>
                                <td class="p_required">[Optional]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">User id, if no parameter is passed, the current login user is returned by default, parameter ID supports variables.<strong>Note: when parameters are passed string type argument requires double quotes.</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">Return:</td>
                    <td>
                        <div class="resurnContent">
                            User related information
                        </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">Example:</td>
                    <td>
                        <div>
                <div class="codeContainer">This method returns a user object by default. If you want to directly return a property of the object, you can return it by using ".property". The expression must start with <strong>$m.</strong> and end with a <strong>semicolon ; </strong>as shown in the following example:
					<div>Login ID of current user:</div><div><code>$m.getUser().loginid;</code></div>
					<div>Login ID of current user:</div><div><code>$m.getUser("{CURRUSER}").loginid;</code></div>
					<div>Login ID of specified user:</div><div><code>$m.getUser("{id}").loginid;</code>(The ID in parentheses can be a url pass variable, or it can be a data set variable {t.id})</div>
					<div>User name of ID 3:</div><div><code>$m.getUser("3").lastname;</code></div>
					<div>User email of ID 3:</div><div><code>$m.getUser("3").email;</code></div>
					<div>User phone of ID 3:</div><div><code>$m.getUser("3").mobile;</code></div>
					<div>Last name of ID 3:</div><div><code>$m.getUser("3").firstname;</code></div>
					<div>First name of ID 3:</div><div><code>$m.getUser("3").lastname;</code></div>
					<div>Nickname of ID 3:</div><div><code>$m.getUser("3").aliasname;</code></div>
					<div>Receiving address of ID 3:</div><div><code>$m.getUser("3").receiveaddress;</code></div>
                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
    <dd>
        <div class="item_header">
    		<div class="item_label">$m.getAvatar();</div>
        	<div class="item_desc">Use this method to get the user's avatar.</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">Parameter:</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">ids</td>
                                <td class="p_required">[Required]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">User id, if you need to obtain multiple user avatars, pass in comma-separated parameters, and the parameters support variables.<strong>Note: when parameters are passed string type argument requires double quotes.</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">Return:</td>
                    <td>
                        <div class="resurnContent">
                            Html tag with avatar information
                        </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">Example:</td>
                    <td>
                        <div>
                <div class="codeContainer">
				The expression must start with <strong>$m.</strong> and end with a <strong>semicolon ; </strong>as shown in the following example:
                <div>Avatar of current user:</div><div><code>$m.getAvatar("{CURRUSER}");</code></div>
                <div>Avatar of specified user:</div><div><code>$m.getAvatar("{id}");</code>(The ID in parentheses can be a url pass variable, or it can be a data set variable {t.id})</div>
				<div>Avatar of ID 3:</div><div><code>$m.getAvatar("3");</code></div>
				<div>Avatar of ID 3 and ID 4:</div><div><code>$m.getAvatar("3,4");</code></div>
                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
    <dd>
        <div class="item_header">
    		<div class="item_label">$m.getDepartment();</div>
        	<div class="item_desc">Use this method to get the user's department.</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">Parameter:</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">id</td>
                                <td class="p_required">[Optional]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">User id, if no parameter is passed, the department of current  user is returned by default, parameter ID supports variables.<strong>Note: when parameters are passed string type argument requires double quotes.</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">Return:</td>
                    <td>
                        <div class="resurnContent">
                            Department name of user
                        </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">Example:</td>
                    <td>
                        <div>
                <div class="codeContainer">
                The expression must start with <strong>$m.</strong> and end with a <strong>semicolon ; </strong>as shown in the following example:
                <div>Department of current user:</div><div><code>$m.getDepartment();</code></div>
                <div>Department of current user:</div><div><code>$m.getDepartment("{CURRUSER}");</code></div>
                <div>Department of specified user:</div><div><code>$m.getDepartment("{id}");</code>(The ID in parentheses can be a url pass variable, or it can be a data set variable {t.id})</div>
                <div>Department of ID 4:</div><div><code>$m.getDepartment("4");</code></div>
                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
    <dd>
        <div class="item_header">
    		<div class="item_label">$m.getManager();</div>
        	<div class="item_desc">Use this method to get the user's superior.</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">Parameter:</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">id</td>
                                <td class="p_required">[Optional]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">User id, if no parameter is passed, the superior of current  user is returned by default, parameter ID supports variables.<strong>Note: when parameters are passed string type argument requires double quotes.</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">Return:</td>
                    <td>
                        <div class="resurnContent">
							Superior name of user
                        </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">Example:</td>
                    <td>
                        <div>
                <div class="codeContainer">
                The expression must start with <strong>$m.</strong> and end with a <strong>semicolon ; </strong>as shown in the following example:
                <div>Superior of current user:</div><div><code>$m.getManager();</code></div>
                <div>Superior of current user:</div><div><code>$m.getManager("{CURRUSER}");</code></div>
                <div>Superior of specified user:</div><div><code>$m.getManager("{id}");</code>(The ID in parentheses can be a url pass variable, or it can be a data set variable {t.id})</div>
				<div>Superior of ID 4</div><div><code>$m.getManager("4");</code></div>
                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
</dl>
<div class="e8_data_label" style="margin-top:15px;">
    Browser
</div>
<dl class="e8_data_list">
	<dd>
        <div class="item_header">
    		<div class="item_label">$m.getBrowserText();</div>
        	<div class="item_desc">Use this method to get the display text of the browser.</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">Parameter:</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">ids</td>
                                <td class="p_required">[Required]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">Browser id, multiple ids separated by commas, parameters support variables.<strong>Note: when parameters are passed string type argument requires double quotes.</strong></td>
                            </tr>
                            <tr>
                                <td class="p_name">typeid</td>
                                <td class="p_required">[Required]</td>
                                <td class="p_type">int</td>
                                <td class="p_explain">Field details type (1: Human resources 2: Date 3: Meeting room contact sheet 4: Department 5: Warehouse 6: Cost center 7: Customer 8: Project 9: Document 10: Storage method 11: Delivery method 12: Currency 13: Asset Type 14: Account - All 15: Account - Detail 16: Request 17: Multiple Human Resources 18: Multiple Customers 19: Time 20: Plan Type 21: Plan Type 22: Reimbursement Cost Type 23: Asset 24: Job 25: Asset Group 26: Vehicles 27: Candidates 28: Session 29: Rewards and Punishment Category 30: Education 31: Employment Nature 32: Training Arrangement 33: Overtime Type 34: Leave Type 35: Business Contract 36: Contract Nature 37: Multiple Documents 38: Relevant Product 161: Custom Radio 162: Custom Multi-Select 256: Custom Tree Radio 257: Custom Tree Multi-Select)</td>
                            </tr>
                            <tr>
                                <td class="p_name">fielddbtype</td>
                                <td class="p_required">[Required]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">Field database type.<strong>Note: when parameters are passed string type argument requires double quotes.</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">Return:</td>
                    <td>
                        <div class="resurnContent">Display text of corresponding browser.</div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">Example:</td>
                    <td>                    
                        <div>
			                <div class="codeContainer">
				                <div style="position:relative;">
				                	Code generation:
					                <div class="field" style="display:none;">
					                	<label>Browser value:</label>
					                	<input id="browservalue" type="text" placeholder="Please enter the browser value"/>
					                </div>
					                <div class="field" style="position:relative;">
					                	<label>Browser type:</label>
					                	<select id="browsertype" name="browsertype"></select>
					                	
					                </div>
					                <div class="field">
					                	<input id="_browsername" type="hidden" readonly="readonly"/>
					                	<input id="browsername" type="text" readonly="readonly"/>
					    				<button type="button" onclick="openBrowserChoose()" class="browserBtn"></button>
					    			</div>
					    			<div class="field result">
					    				<label>Result:</label>
					    				<code>$m.getBrowserText("Please enter the field value to replace", -1, "");</code>
					    			</div>
				                </div>
			                	The expression must start with <strong>$m.</strong> and end with a <strong>semicolon ; </strong>as shown in the following example:
				                <div>Get HR browser value:</div><div><code>$m.getBrowserText("1", 1, "");</code></div>
				                <div>Get HR browser value(variable mode):</div><div><code>$m.getBrowserText("{id}", 1, "");</code></div>
				                <div>Get multiple HR browser values:</div><div><code>$m.getBrowserText("1,2,3", 1, "");</code></div>
				                <div>Get custom radio browser value:</div><div><code>$m.getBrowserText("1", 161, "browser.test");</code></div>
				                <div>Get custom tree radio browser value:</div><div><code>$m.getBrowserText("1_1", 256, "1");</code></div>
			                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
</dl>
<div class="e8_data_label" style="margin-top:15px;">
    Select
</div>
<dl class="e8_data_list">
	<dd>
        <div class="item_header">
    		<div class="item_label">$m.getSelectText();</div>
        	<div class="item_desc">Use this method to get the display text of drop-down box.</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">Parameter:</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">value</td>
                                <td class="p_required">[Required]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">The actual value of the drop-down box, general is id, parameters support variables.<strong>Note: when parameters are passed string type argument requires double quotes.</strong></td>
                            </tr>
                            <tr>
                                <td class="p_name">idOrName</td>
                                <td class="p_required">[Required]</td>
                                <td class="p_type">String</td>
                                <td class="p_explain">Can be (1) Modeling table field id, such as 19661 or (2) Table-name.Field-name, such as tableA.name</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">Return:</td>
                    <td>
                        <div class="resurnContent">The display text of drop-down box.</div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">Example:</td>
                    <td>                    
                        <div>
			                <div class="codeContainer">
			                	The expression must start with <strong>$m.</strong> and end with a <strong>semicolon ; </strong>as shown in the following example:
				                <div>Field id as a parameter:</div><div><code>$m.getSelectText("1","19661");</code></div>
				                <div>Table field name as a parameter:</div><div><code>$m.getSelectText("1","uf_cc_test.xb");</code></div>
			                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
</dl>
<div class="e8_data_label" style="margin-top:15px;">
    Display conversion
</div>
<dl class="e8_data_list">
	<dd>
        <div class="item_header">
    		<div class="item_label">$m.convertToStar();</div>
        	<div class="item_desc">Use this method to convert the value of the star rating plug-in stored in the database to a star display.</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">Parameter:</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">value</td>
                                <td class="p_required">[Required]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">The value of the star rating plug-in stored in the database.<strong>Note: when parameters are passed string type argument requires double quotes.</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">Return:</td>
                    <td>
                        <div class="resurnContent">Html of display star, can be directly used to display on the page.</div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">Example:</td>
                    <td>                    
                        <div>
			                <div class="codeContainer">
			                	The expression must start with <strong>$m.</strong> and end with a <strong>semicolon ; </strong>as shown in the following example:
				                <div>Use in list plugins:</div><div><code>$m.convertToStar("{Corresponding field name of star rating plug-in}");</code></div>
			                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
</dl>
<%}else if(user.getLanguage() == 9){ %>
<div class="e8_data_label">
    用戶類
</div>
<dl class="e8_data_list">
    <dd>
    	<div class="item_header">
    		<div class="item_label">$m.getUser();</div>
        	<div class="item_desc">通過此方法可以獲取用戶相關信息</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">參數：</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">id</td>
                                <td class="p_required">[可選]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">用戶id，如果不傳參數，則默認返回當前登錄用戶，參數ID支持變量。<strong>註意：參數為string類型在傳參時需要加雙引號</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">返回：</td>
                    <td>
                        <div class="resurnContent">
                            用戶相關信息
                        </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">示例：</td>
                    <td>
                        <div>
                <div class="codeContainer">該方法默認返回的是壹個用戶對象，如需直接返回該對象的某個屬性，可以通過".屬性"的方式返回，表達式必須以<strong>$m.</strong>開頭，<strong>分號 ; </strong>結尾，如下示例所示：
					<div>當前用戶的登錄ID：</div><div><code>$m.getUser().loginid;</code></div>
					<div>當前用戶的登錄ID：</div><div><code>$m.getUser("{CURRUSER}").loginid;</code></div>
					<div>指定用戶的登錄ID：</div><div><code>$m.getUser("{id}").loginid;</code>(括號中的ID可以是url傳遞變量，也可以是數據集變量{t.id}形式)</div>
					<div>ID為3的用戶姓名：</div><div><code>$m.getUser("3").lastname;</code></div>
					<div>ID為3的用戶郵箱：</div><div><code>$m.getUser("3").email;</code></div>
					<div>ID為3的用戶手機：</div><div><code>$m.getUser("3").mobile;</code></div>
					<div>ID為3的姓：</div><div><code>$m.getUser("3").firstname;</code></div>
					<div>ID為3的名：</div><div><code>$m.getUser("3").lastname;</code></div>
					<div>ID為3的昵稱：</div><div><code>$m.getUser("3").aliasname;</code></div>
					<div>ID為3的收貨地址：</div><div><code>$m.getUser("3").receiveaddress;</code></div>
                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
    <dd>
        <div class="item_header">
    		<div class="item_label">$m.getAvatar();</div>
        	<div class="item_desc">通過此方法可以獲取用戶頭像</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">參數：</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">ids</td>
                                <td class="p_required">[必須]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">用戶id，如果需要獲取多個用戶的頭像，傳入用逗號分隔的參數即可，參數支持變量。<strong>註意：參數為string類型在傳參時需要加雙引號</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">返回：</td>
                    <td>
                        <div class="resurnContent">
                            包含頭像信息的html標簽
                        </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">示例：</td>
                    <td>
                        <div>
                <div class="codeContainer">
                表達式必須以<strong>$m.</strong>開頭，<strong>分號 ; </strong>結尾，如下示例所示：
                <div>當前用戶頭像：</div><div><code>$m.getAvatar("{CURRUSER}");</code></div>
                <div>指定用戶的頭像：</div><div><code>$m.getAvatar("{id}");</code>(括號中的ID可以是url傳遞變量，也可以是數據集變量{t.id}形式)</div>
				<div>ID為3的用戶頭像：</div><div><code>$m.getAvatar("3");</code></div>
				<div>ID為3，4的用戶頭像：</div><div><code>$m.getAvatar("3,4");</code></div>
                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
    <dd>
        <div class="item_header">
    		<div class="item_label">$m.getDepartment();</div>
        	<div class="item_desc">通過此方法可以獲取用戶部門</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">參數：</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">id</td>
                                <td class="p_required">[可選]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">用戶id，如果不傳參，則默認獲取當前用戶部門，參數支持變量。<strong>註意：參數為string類型在傳參時需要加雙引號</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">返回：</td>
                    <td>
                        <div class="resurnContent">
                            用戶部門名稱
                        </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">示例：</td>
                    <td>
                        <div>
                <div class="codeContainer">
                表達式必須以<strong>$m.</strong>開頭，<strong>分號 ; </strong>結尾，如下示例所示：
                <div>當前用戶部門：</div><div><code>$m.getDepartment();</code></div>
                <div>當前用戶部門：</div><div><code>$m.getDepartment("{CURRUSER}");</code></div>
                <div>指定用戶部門：</div><div><code>$m.getDepartment("{id}");</code>(括號中的ID可以是url傳遞變量，也可以是數據集變量{t.id}形式)</div>
                <div>ID為4的用戶部門：</div><div><code>$m.getDepartment("4");</code></div>
                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
    <dd>
        <div class="item_header">
    		<div class="item_label">$m.getManager();</div>
        	<div class="item_desc">通過此方法可以獲取用戶上級</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">參數：</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">id</td>
                                <td class="p_required">[可選]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">用戶id，如果不傳參，則默認獲取當前用戶上級，參數支持變量。<strong>註意：參數為string類型在傳參時需要加雙引號</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">返回：</td>
                    <td>
                        <div class="resurnContent">
                            用戶上級名稱
                        </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">示例：</td>
                    <td>
                        <div>
                <div class="codeContainer">
                表達式必須以<strong>$m.</strong>開頭，<strong>分號 ; </strong>結尾，如下示例所示：
                <div>當前用戶上級：</div><div><code>$m.getManager();</code></div>
                <div>當前用戶上級：</div><div><code>$m.getManager("{CURRUSER}");</code></div>
                <div>指定用戶上級：</div><div><code>$m.getManager("{id}");</code>(括號中的ID可以是url傳遞變量，也可以是數據集變量{t.id}形式)</div>
				<div>ID為4的用戶上級：</div><div><code>$m.getManager("4");</code></div>
                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
</dl>
<div class="e8_data_label" style="margin-top:15px;">
    瀏覽框類
</div>
<dl class="e8_data_list">
	<dd>
        <div class="item_header">
    		<div class="item_label">$m.getBrowserText();</div>
        	<div class="item_desc">通過此方法可以獲取瀏覽框的顯示文本</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">參數：</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">ids</td>
                                <td class="p_required">[必須]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">瀏覽框id,多個id以逗號分隔，參數支持變量。<strong>註意：參數為string類型在傳參時需要加雙引號</strong></td>
                            </tr>
                            <tr>
                                <td class="p_name">typeid</td>
                                <td class="p_required">[必須]</td>
                                <td class="p_type">int</td>
                                <td class="p_explain">字段詳細類型(1：人力資源 2：日期 3：會議室聯系單 4：部門 5：倉庫 6：成本中心 7：客戶 8：項目 9：文檔 10：入庫方式 11：出庫方式 12：幣種 13：資產種類 14：科目－全部 15：科目－明細 16：請求 17：多人力資源 18：多客戶 19：時間 20：計劃類型 21：計劃種類 22：報銷費用類型 23：資產 24：職務 25：資產組 26：車輛 27：應聘人 28：會議 29：獎懲種類 30：學歷 31：用工性質 32：培訓安排 33：加班類型 34：請假類型 35：業務合同 36：合同性質 37：多文檔 38：相關產品 161:自定義單選 162:自定義多選 256:自定義樹形單選 257:自定義樹形多選)</td>
                            </tr>
                            <tr>
                                <td class="p_name">fielddbtype</td>
                                <td class="p_required">[必須]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">字段數據庫類型  <strong>註意：參數為string類型在傳參時需要加雙引號</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">返回：</td>
                    <td>
                        <div class="resurnContent">瀏覽框對應ID的顯示文本 </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">示例：</td>
                    <td>                    
                        <div>
			                <div class="codeContainer">
				                <div style="position:relative;">
				                	代碼生成：
					                <div class="field" style="display:none;">
					                	<label>瀏覽框值：</label>
					                	<input id="browservalue" type="text" placeholder="請輸入瀏覽框值"/>
					                </div>
					                <div class="field" style="position:relative;">
					                	<label>瀏覽框類型：</label>
					                	<select id="browsertype" name="browsertype"></select>
					                	
					                </div>
					                <div class="field">
					                	<input id="_browsername" type="hidden" readonly="readonly"/>
					                	<input id="browsername" type="text" readonly="readonly"/>
					    				<button type="button" onclick="openBrowserChoose()" class="browserBtn"></button>
					    			</div>
					    			<div class="field result">
					    				<label>結果：</label>
					    				<code>$m.getBrowserText("請輸入要替換的字段值", -1, "");</code>
					    			</div>
				                </div>
			                	表達式必須以<strong>$m.</strong>開頭，<strong>分號 ; </strong>結尾，如下示例所示：
				                <div>獲取人力資源瀏覽框值：</div><div><code>$m.getBrowserText("1", 1, "");</code></div>
				                <div>獲取人力資源瀏覽框值(變量方式)：</div><div><code>$m.getBrowserText("{id}", 1, "");</code></div>
				                <div>獲取多人力資源瀏覽框值：</div><div><code>$m.getBrowserText("1,2,3", 1, "");</code></div>
				                <div>獲取自定義單選瀏覽框值：</div><div><code>$m.getBrowserText("1", 161, "browser.test");</code></div>
				                <div>獲取自定義樹形單選瀏覽框值：</div><div><code>$m.getBrowserText("1_1", 256, "1");</code></div>
			                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
</dl>
<div class="e8_data_label" style="margin-top:15px;">
    下拉框類
</div>
<dl class="e8_data_list">
	<dd>
        <div class="item_header">
    		<div class="item_label">$m.getSelectText();</div>
        	<div class="item_desc">通過此方法可以獲取下拉框的顯示文本</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">參數：</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">value</td>
                                <td class="p_required">[必須]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">下拉框的真實值，壹般是id。參數支持變量。<strong>註意：參數為string類型在傳參時需要加雙引號</strong></td>
                            </tr>
                            <tr>
                                <td class="p_name">idOrName</td>
                                <td class="p_required">[必須]</td>
                                <td class="p_type">String</td>
                                <td class="p_explain">可以是 (1)建模表字段id，如19661 或 (2)表名稱.字段名稱，如tableA.name</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">返回：</td>
                    <td>
                        <div class="resurnContent">下拉框對應value的顯示文本 </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">示例：</td>
                    <td>                    
                        <div>
			                <div class="codeContainer">
			                	表達式必須以<strong>$m.</strong>開頭，<strong>分號 ; </strong>結尾，如下示例所示：
				                <div>字段id作為參數：</div><div><code>$m.getSelectText("1","19661");</code></div>
				                <div>表名字段名作為參數：</div><div><code>$m.getSelectText("1","uf_cc_test.xb");</code></div>
			                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
</dl>
<div class="e8_data_label" style="margin-top:15px;">
    顯示轉換類
</div>
<dl class="e8_data_list">
	<dd>
        <div class="item_header">
    		<div class="item_label">$m.convertToStar();</div>
        	<div class="item_desc">通過此方法可以將星級評分插件存儲在數據庫中的值轉換為星級顯示</div>
    	</div>
        <div class="item_detail">
            <table class="mainTable">
                <colgroup>
                    <col width="45px"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <td class="label">參數：</td>
                    <td>
                        <table class="p_table">
                            <tr>
                                <td class="p_name">value</td>
                                <td class="p_required">[必須]</td>
                                <td class="p_type">(string)</td>
                                <td class="p_explain">星級評分插件存儲在數據庫中的值。<strong>註意：參數為string類型在傳參時需要加雙引號</strong></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="label">返回：</td>
                    <td>
                        <div class="resurnContent">顯示星級的html，可直接用於在頁面上顯示 </div>
                    </td></tr>
                <tr class="noborder">
                    <td class="label">示例：</td>
                    <td>                    
                        <div>
			                <div class="codeContainer">
			                	表達式必須以<strong>$m.</strong>開頭，<strong>分號 ; </strong>結尾，如下示例所示：
				                <div>如在列表插件中使用：</div><div><code>$m.convertToStar("{星級評分插件對應的字段名稱}");</code></div>
			                </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </dd>
</dl>
<%} %>
<script type="text/javascript">
$(function(){
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getBrowserType");
	$.ajax({
	 	type: "GET",
	 	contentType: "application/json",
	 	url: encodeURI(url),
	 	data: "{}",
	 	success: function(responseText, textStatus) 
	 	{
	 		var result = $.parseJSON(responseText);
	 		var status = result.status;
			if(status == "1"){
				var data = result.data;
				var optionHtml = "<option></option>";
				for(var i = 0; i < data.length; i++){
					var match = data[i]["match"];
					var value = data[i]["value"];
					var text = data[i]["text"];
					optionHtml+= "<option value=\""+value+"\">"+text+"</option>";
				}
				var $fieldObj = $("#browsertype");
				$fieldObj.empty().append(optionHtml);
			}
	 	},
	    error: function(){
	    }
	});
	$("#browsertype").bind("change", function(){
		var browsertype = $(this).val();
		var browsername = $("#_browsername").val();
		if(browsertype == "161" || browsertype == "162" || browsertype == "256" || browsertype == "257"){
			$(".field:eq(2)").show();
		}else{
			$(".field:eq(2)").hide();
		}
		$("#_browsername").val("");
		$("#browsername").val("");
		setResult();
	});
});
function openBrowserChoose(){
	var browsertype = $("#browsertype").val();
	var url = "";
	if(browsertype == "161" || browsertype == "162"){
		url = "/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp";
	}else if(browsertype == "256" || browsertype == "257"){
		url = "/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/TreeBrowser.jsp";
	}
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 550;//定义长度
	dlg.Height = 650;
	dlg.URL = url;
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(128937,user.getLanguage())%>";//请选择;
	dlg.show();
	dlg.callback = function(result){
		var v = result.id;
		if(v == "browser."){
			v = "";
		}
		$("#_browsername").val(v);
		var n = result.name;
		if(n){
			var reStripTags = /<\/?.*?>/g;
			n = n.replace(reStripTags, ''); //只有文字的结果
		}else{
			n = v;
		}
		$("#browsername").val(n);
		setResult();
	};
}
function setResult(){
	var browsertype = $("#browsertype").val();
	var browsername = $("#_browsername").val();
	$(".field.result code").text("$m.getBrowserText(\"<%=SystemEnv.getHtmlLabelName(383250,user.getLanguage())%>\", "+browsertype+", \""+browsername+"\");");//请输入要替换的字段值
}
</script>
</body>
</html>
