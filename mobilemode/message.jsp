<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
User user = MobileUserInit.getUser(request,response);
if(user == null){
	out.println("服务器端重置了登录信息，请重新登录");
	return;
}
int languageid = user.getLanguage(); 
Map<String, String> errMap = new HashMap<String, String>();
errMap.put("1388", StringHelper.null2String(SystemEnv.getHtmlLabelName(383749, languageid)));//数据id为空。无法显示相应的数据
errMap.put("1389", StringHelper.null2String(SystemEnv.getHtmlLabelName(383753, languageid)));//没有权限访问

//布局不存在提示信息分类提示
String errorCode = Util.null2String(request.getParameter("errorCode"));
if("1387".equals(errorCode)){
	String tipName = StringHelper.null2String(SystemEnv.getHtmlLabelName(383756, languageid));//布局不存在
	int uitype = Util.getIntValue(request.getParameter("uitype"), -1);//布局类型：0新建   1显示   2编辑
	int isDefault = Util.getIntValue(request.getParameter("isdefault"), 0);//是否默认布局
	int layoutid = Util.getIntValue(request.getParameter("layoutid"), 0);//布局ID
	int appid = Util.getIntValue(request.getParameter("appid"), -1);
	int modelid = Util.getIntValue(request.getParameter("modelid"), -1);
	String uitypeName = (uitype == 0 ? SystemEnv.getHtmlLabelName(83981, languageid) : (uitype == 1 ? SystemEnv.getHtmlLabelName(127791, languageid) : (uitype == 2 ? SystemEnv.getHtmlLabelName(126036, languageid) : "")));//新建  显示  编辑
	if(isDefault == 1){
		tipName = SystemEnv.getHtmlLabelName(149, languageid) +" "+ uitypeName +" "+ SystemEnv.getHtmlLabelName(383761, languageid);//默认 ... 布局不存在，请联系管理员在移动引擎中添加对应的布局。
	}else{
		if(layoutid > 0){
			RecordSet rs = new RecordSet();
			rs.executeSql("select layoutname from modehtmllayout where id="+layoutid);
			String modehtmlInfo = "（"+SystemEnv.getHtmlLabelName(383762, languageid)+":"+layoutid+"）";//布局id
			String layoutname = "";
			if(rs.next()){
				layoutname = rs.getString("layoutname");
				modehtmlInfo = "（"+SystemEnv.getHtmlLabelName(383239, languageid)+":"+layoutname+","+SystemEnv.getHtmlLabelName(383762, languageid)+":"+layoutid+"）";//名称  布局id
			}
			rs.executeSql("select count(*) from AppHomepage a join AppHomepage_Model b on a.id=b.apphomepageid where b.layoutid="+layoutid);
			if(rs.next() && rs.getInt(1) == 0){
				tipName = SystemEnv.getHtmlLabelName(383763, languageid)+" "+uitypeName+SystemEnv.getHtmlLabelName(19407, languageid)+" "+modehtmlInfo+SystemEnv.getHtmlLabelName(383765, languageid);//非默认 布局  未添加到移动引擎,请联系管理员在移动引擎中添加对应布局。
				if(!"".equals(layoutname)){
					String pagename = "";
					int oldlayoutid = 0;
					String sql = "select pagename,layoutid from AppHomepage a join AppHomepage_Model b on a.id=b.apphomepageid where b.uitype="
							+uitype+" and b.layoutid <> "+layoutid+" and a.appid="+appid + " and b.modelid="+modelid + " and a.pagename like '%"+layoutname+"%'";
					rs.executeSql(sql);
					if(rs.next()){
						pagename = rs.getString("pagename");
						oldlayoutid = rs.getInt("layoutid");
						tipName += "<br><br><div style=\"text-align: left;\">"+SystemEnv.getHtmlLabelName(383766, languageid)+"<br>"+SystemEnv.getHtmlLabelName(383239, languageid)+"："+pagename+"<br>"+SystemEnv.getHtmlLabelName(383762, languageid)+"："+oldlayoutid+"</div>";//提示:当前应用移动引擎中存在如下名称相同但布局id不同的的自定义页面
						tipName += "<br><div style=\"color:#feb580;text-align: left;\">"+SystemEnv.getHtmlLabelName(383767, languageid)+"</div>";//解决方法:请尝试先删除移动建模中已存在的名称相同的布局，删除后重新添加布局即可。
					}
				}
			}
		}
	}
	
	errMap.put("1387", tipName);
}


String errorMsg = Util.null2String(errMap.get(errorCode));

if(errorMsg.equals("")){
	errorMsg = SystemEnv.getHtmlLabelName(382011, languageid);//未知错误
}
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<title></title>
	<style type="text/css">
		html,body{
			height: 100%;
			background-color: #FFFFFF;
			text-align: center;
			margin: 0px;
			padding: 0px;
		}
		body{
			text-align:center;
		}
		#tip{
			font-family: 'Microsoft YaHei', Arial;
			font-size: 18px;
			background: url("/mobilemode/images/tip_wev8.png") no-repeat;
			padding-left: 35px;
			padding-right: 35px;
			line-height: 35px;
			color: #bbb;
			background-size: 30px;
			background-position: left center;
			margin: 0px auto;
			display:inline-block;
			margin-top: 20px;
			margin-right: 5%;
			margin-left: 5%;
		}
	</style>
</head>
<body>
	<div id="tip">
		<%=errorMsg %>
	</div>
	<div style="font-size: 12px;color: #cdcdcd;">
		(<%=SystemEnv.getHtmlLabelName(383768, languageid) %>：<%=errorCode %>)<!-- 错误代码 -->
	</div>
</body>
</html>