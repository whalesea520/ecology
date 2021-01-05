<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<style>
* {
  font-family: Microsoft YaHei;
  font-size: 14px;
}
table tr td{
	padding-left: 10px;
}
table tr td img{
	width:1020px;
	height:600px;
}
.titletd{
	padding-top: 30px;
}
</style>
  <head>
    <title >微信提醒云桥配置说明</title>
  </head>
  
  <body>
    <table>
    <tr>
    	<td style="text-align:center;font-size: 18px;font-weight: bold;">微信提醒云桥配置说明</td>
    </tr>
    <tr>
    	<td class="titletd">第一步：在浏览器输入云桥的访问地址，如下图：</td>
    </tr>
    <tr>
    	<td><img src="/formmode/images/wechatimg/wechat1_wev8.png"></img></td>
    </tr>
    <tr>
    	<td class="titletd">第二步：在上图输入用户名和密码，登录到云桥系统的主界面，如下图：</td>
    </tr>
    <tr>
    	<td><img src="/formmode/images/wechatimg/wechat2_wev8.png" ></img></td>
    </tr>
    <tr>
    	<td class="titletd">第三步：点击【集成中心】->【泛微OA系统集成】页面，如下图：</td>
    </tr>
    <tr>
    	<td><img src="/formmode/images/wechatimg/wechat3_wev8.png" ></img></td>
    </tr>
    <tr>
    	<td class="titletd">第四步：点击新增，将外部系统录入到云桥系统中，如下图：</td>
    </tr>
    <tr>
    	<td><img src="/formmode/images/wechatimg/wechat4_1_wev8.png" ></img></td>
    </tr>
    <tr>
    	<td><img src="/formmode/images/wechatimg/wechat4_2_wev8.png" ></img></td>
    </tr>
    <tr>
    	<td>配置说明：<br>
    		1、系统名称：在云桥中显示的应用名称，便于辨识;<br>
    		2、系统类型：统一填写：e-cology;<br>
    		3、管理员账号：录入e-cology系统的管理员账号;<br>
			4、管理员密码：录入e-cology系统的管理员密码;<br>
			5、用户唯一性标识类型：可以选择“OA系统用户数据库ID”或者“OA系统用户登录账号”，但必须与录入的人员一致，如下图;<br>
			6、接口密码：自动带出;<br>
			7、系统编码：请选择：UTF-8;<br>
			8、被集成OA系统访问地址：e-cology系统的访问地址;<br>
			9、备注说明：备注信息;
    	</td>
    </tr>
    <tr>
    	<td><img src="/formmode/images/wechatimg/wechat5_wev8.png" ></img></td>
    </tr>
    <tr>
    	<td class="titletd">第五步：点击新建应用的“推送设置”，进入到信息推送设置界面，如下图：</td>
    </tr>
    <tr>
    	<td><img src="/formmode/images/wechatimg/wechat6_1_wev8.png" ></img></td>
    </tr>
    <tr>
    	<td><img src="/formmode/images/wechatimg/wechat6_2_wev8.png" ></img></td>
    </tr>
    <tr>
    	<td class="titletd">第六步：点击“新增”。新增消息推送设置，如下图：</td>
    </tr>
    <tr>
    	<td><img src="/formmode/images/wechatimg/wechat7_wev8.png" ></img></td>
    </tr>
    <tr>
    	<td>配置说明：<br>
    		1、显示名称：自定义您想要显示的名称;<br>
    		2、消息类型：选择建模引擎;<br>
    		3、关联模板：选择您创建的模板（后面会有模板创建说明）;<br>
			4、内容设置：选择您启用的微信提醒;<br>
			5、是否启动：微信提醒开关控制;
    	</td>
    </tr>
    <tr>
    	<td class="titletd">第七步：内容设置：请勾选您希望实现微信提醒的提醒；如果绑定的系统没有配置微信提醒，则这里不会有数据显示,如下图：</td>
    </tr>
    <tr>
    	<td><img src="/formmode/images/wechatimg/wechat8_wev8.png" ></img></td>
    </tr>
    <tr>
    	<td>e-cology系统对应微信提醒的开关，如下图<br><img src="/formmode/images/wechatimg/wechat9_wev8.png" ></img></td>
    </tr>
    <tr>
    	<td class="titletd">第八步：消息推送模板信息配置，如下图：</td>
    </tr>
    <tr>
    	<td><img src="/formmode/images/wechatimg/wechat10_1_wev8.png" style="width: 712px !important"></img></td>
    </tr>
    <tr>
    	<td><img src="/formmode/images/wechatimg/wechat10_2_wev8.png" style="width: 712px !important"></img></td>
    </tr>
    <tr>
    	<td>配置说明：<br>
		1、启用开关：如果您想使用，请开启;<br>
		2、模板名称：自定义易辨识的名称;<br>
		3、推送目标：选择企业号;<br>
		4、企业号：选择云桥相关联的企业号;<br>
		5、应用：选择信息想要推送到哪个应用上;<br>
		6、是否带连接：选择"是";<br>
		7、对应系统：选择第四步新增的系统名称;<br>
		8、连接目标：选择自定义链接;<br>
		9、链接地址：填入"/"符号;<br>
		10、消息格式：可配置“文字”后者“图文”，建议配置图文;<br>
		11、消息标题/消息图片：配置相关提示的预览信息;<br>
		12、消息内容模板：推送到微信端的预览信息配置，支持部分系统参数<br>
    	</td>
    </tr>
    <tr>
    	<td class="titletd" style="font-size: 18px;font-weight: bold;padding-bottom: 30px;">以上配置全部通过后，即可实现微信提醒！</td><br>
    </tr>
    </table>
  </body>
</html>
