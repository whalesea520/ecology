<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.*"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.hrm.settings.ChgPasswdReminder"%>
<%@ page import="weaver.hrm.settings.RemindSettings"%>
<jsp:useBean id="HrmOutInterface" class="weaver.hrm.outinterface.HrmOutInterface" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
out.clear();
String isopen = Util.null2String(BaseBean.getPropValue("HrmOutInterfaceIP", "isopen"));//调用接口的iP地址范围
if(isopen.equals("1")){
	String configip = BaseBean.getPropValue("HrmOutInterfaceIP", "ipaddress");//调用接口的iP地址范围
	String clientip = Util.getIpAddr(request);
	if(!Arrays.asList(configip.split(",")).contains(clientip)){//简单处理下，防止非法调用
		out.println(SystemEnv.getHtmlLabelName(129241, 7));
		return;
	}
}

//校验key是否有效
String checkkey = Util.null2String(request.getParameter("checkkey"));
ChgPasswdReminder reminder=new ChgPasswdReminder();
RemindSettings settings=reminder.getRemindSettings();
String checkkeyset = Util.null2String(settings.getCheckkey());
if(!checkkey.equals(checkkeyset)){
	out.println("check key error!");
	return;
}

String cmd = Util.null2String(request.getParameter("cmd"));
String crmid = Util.null2String(request.getParameter("crmid"));
String tmpcustomid = Util.null2String(request.getParameter("tmpcustomid"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String customname = Util.null2String(request.getParameter("customname"));//客户名称
String customstatus = Util.null2String(request.getParameter("customstatus"));//客户状态
String customtype = Util.null2String(request.getParameter("customtype"));//客户类型
String custommanager = Util.null2String(request.getParameter("custommanager"));//客户经理
String subcompanyname = Util.null2String(request.getParameter("subcompanyname"));//多维组织的分部名称
String departmentname = Util.null2String(request.getParameter("departmentname"));//多维组织的部门名称
String lastname = Util.null2String(request.getParameter("lastname"));//姓名
String loginid = Util.null2String(request.getParameter("loginid"));//账号
String password = Util.null2String(request.getParameter("password"));//密码
String seclevel = Util.null2String(request.getParameter("seclevel"));//安全级别
if(seclevel.length()==0)seclevel="-1";
String mobile = Util.null2String(request.getParameter("mobile"));//手机号码
String email = Util.null2String(request.getParameter("email"));//邮箱
String isoutmanager = Util.null2String(request.getParameter("isoutmanager"));//是否为外部负责人
String wxname = Util.null2String(request.getParameter("wxname"));//微信昵称
String wxopenid = Util.null2String(request.getParameter("wxopenid"));//用户微信openid
String wxuuid = Util.null2String(request.getParameter("wxuuid"));//用户微信uuid
String country = Util.null2String(request.getParameter("country"));//所属国家
String province = Util.null2String(request.getParameter("province"));//所属省份
String city = Util.null2String(request.getParameter("city"));//所属城市
String customfrom = Util.null2String(request.getParameter("customfrom"));//信息来源
String fromtype = Util.null2String(request.getParameter("fromtype"));//客户来源
Map<String,String> params = new HashMap<String,String>();
Map<String,String> result = new HashMap<String,String>();
if(cmd.equals("createResourceTmp")||cmd.equals("createResource")){
	//如果客户id没有传入说明该客户为新建，发现名字已存在就客户名称、分部后加入后缀
	if(crmid.length()==0){
		String sql = "select count(1) from CRM_CustomerInfo where name like'" + customname + "%'";//判断客户是否已存在
		rs.executeSql(sql);
		if(rs.next()){
			if(rs.getInt(1)>0){
				customname=customname+"_"+(rs.getInt(1)+1);
			}
		}
		
		int supsubcomid = HrmOutInterface.getSubCompanyId(SystemEnv.getHtmlLabelName(125931, 7)+">"+SystemEnv.getHtmlLabelName(125178, 7)); 
		sql = "select count(1) from hrmsubcompanyvirtual where supsubcomid="+supsubcomid+" and subcompanyname like '" + subcompanyname + "%'";
		rs.executeSql(sql);
		if(rs.next()){
			if(rs.getInt(1)>0){
				subcompanyname=subcompanyname+"_"+(rs.getInt(1)+1);
			}
		}
	}
}

//在分部前自动加上前缀
if(subcompanyname.length()>0)subcompanyname=SystemEnv.getHtmlLabelName(125931, 7)+">"+SystemEnv.getHtmlLabelName(125178, 7)+">"+subcompanyname;
if(cmd.equals("createResourceTmp")){//创建外部人员、客户卡片、虚拟分部、虚拟部门
	params.put("customname",customname);//customname 客户名称
	params.put("custommanager",custommanager);//customstatus 客户状态 默认值2（基础客户）
	params.put("customstatus",customstatus);//customtype 客户类型 默认值1（客户）
	params.put("customtype",customtype); //custommanager 客户经理
	params.put("subcompanyname",subcompanyname); //subcompanyname 多维组织的分部名称
	params.put("departmentname",departmentname); //departmentname 多维组织的部门名称
	params.put("lastname",lastname);//lastname 姓名 
	params.put("loginid",loginid); //loginid 账号
	params.put("password",password);//password 密码 
	params.put("seclevel",seclevel); //seclevel 安全级别
	params.put("mobile",mobile); //mobile 手机号码
	params.put("email",email); //email 邮箱
	params.put("isoutmanager",isoutmanager);//isoutmanager 是否外部负责人0:不是1：是
	params.put("wxname",wxname); //wxname 微信昵称
	params.put("wxopenid",wxopenid);//wxopenid 用户微信openid 
	params.put("wxuuid",wxuuid); //wxuuid 用户微信uuid
	params.put("country",country); //country 所属国家
	params.put("province",province); //province 所属省份
	params.put("city",city); //city 所属城市
	params.put("customfrom",customfrom);//customfrom 信息来源
	params.put("fromtype",fromtype);//客户来源（获得方式） 8 为试用申请
	
	result = HrmOutInterface.createResourceTmp(params);
	JSONObject jsonObj = new JSONObject();
	jsonObj.put("resourceid",result.get("resourceid"));
	jsonObj.put("tmpcustomid",result.get("tmpcustomid"));
	jsonObj.put("errorinfo",result.get("errorinfo"));
	out.print(jsonObj.toString());
	return;
}

if(cmd.equals("createResource")){//创建外部人员、客户卡片、虚拟分部、虚拟部门
	params.put("crmid",crmid);//crmid 客户id
	params.put("customname",customname);//customname 客户名称
	params.put("custommanager",custommanager);//customstatus 客户状态 默认值2（基础客户）
	params.put("customstatus",customstatus);//customtype 客户类型 默认值1（客户）
	params.put("customtype",customtype); //custommanager 客户经理
	params.put("subcompanyname",subcompanyname); //subcompanyname 多维组织的分部名称
	params.put("departmentname",departmentname); //departmentname 多维组织的部门名称
	params.put("lastname",lastname);//lastname 姓名 
	params.put("loginid",loginid); //loginid 账号
	params.put("password",password);//password 密码 
	params.put("seclevel",seclevel); //seclevel 安全级别
	params.put("mobile",mobile); //mobile 手机号码
	params.put("email",email); //email 邮箱
	params.put("isoutmanager",isoutmanager);//isoutmanager 是否外部负责人0:不是1：是
	params.put("wxname",wxname); //wxname 微信昵称
	params.put("wxopenid",wxopenid);//wxopenid 用户微信openid 
	params.put("wxuuid",wxuuid); //wxuuid 用户微信uuid
	params.put("country",country); //country 所属国家
	params.put("province",province); //province 所属省份
	params.put("city",city); //city 所属城市
	params.put("customfrom",customfrom);//customfrom 信息来源
	
	result = HrmOutInterface.createResource(params);
	JSONObject jsonObj = new JSONObject();
	jsonObj.put("resourceid",result.get("resourceid"));
	jsonObj.put("customid",result.get("customid"));
	jsonObj.put("errorinfo",result.get("errorinfo"));
	out.print(jsonObj.toString());
}else if(cmd.equals("updateResourceById")){//根据id修改人员信息
	int id = Util.getIntValue(request.getParameter("id"));//用户id
	params.put("id",""+id);
	params.put("crmid",crmid);//crmid 客户id
	params.put("tmpcustomid",tmpcustomid);//tmpcustomid 正式环境临时客户id
	params.put("customname",customname);//customname 客户名称
	params.put("custommanager",custommanager);//customstatus 客户状态 默认值2（基础客户）
	params.put("customstatus",customstatus);//customtype 客户类型 默认值1（客户）
	params.put("customtype",customtype); //custommanager 客户经理
	params.put("subcompanyname",subcompanyname); //subcompanyname 多维组织的分部名称
	params.put("departmentname",departmentname); //departmentname 多维组织的部门名称
	params.put("lastname",lastname);//lastname 姓名 
	params.put("loginid",loginid); //loginid 账号
	params.put("password",password);//password 密码 
	params.put("seclevel",seclevel); //seclevel 安全级别
	params.put("mobile",mobile); //mobile 手机号码
	params.put("email",email); //email 邮箱
	params.put("isoutmanager",isoutmanager);//isoutmanager 是否外部负责人0:不是1：是
	params.put("wxname",wxname); //wxname 微信昵称
	params.put("wxopenid",wxopenid);//wxopenid 用户微信openid 
	params.put("wxuuid",wxuuid); //wxuuid 用户微信uuid
	params.put("country",country); //country 所属国家
	params.put("province",province); //province 所属省份
	params.put("city",city); //city 所属城市
	params.put("customfrom",customfrom);//customfrom 信息来源
	result = HrmOutInterface.updateResourceById(params);
	JSONObject jsonObj = new JSONObject();
	jsonObj.put("resourceid",result.get("resourceid"));
	jsonObj.put("customid",result.get("customid"));
	jsonObj.put("errorinfo",result.get("errorinfo"));
	out.print(jsonObj.toString());
}else if(cmd.equals("updateResourceByLoginId")){//根据loginid修改人员信息
	params.put("crmid",crmid);//crmid 客户id
	params.put("tmpcustomid",tmpcustomid);//tmpcustomid 正式环境临时客户id
	params.put("customname",customname);//customname 客户名称
	params.put("custommanager",custommanager);//customstatus 客户状态 默认值2（基础客户）
	params.put("customstatus",customstatus);//customtype 客户类型 默认值1（客户）
	params.put("customtype",customtype); //custommanager 客户经理
	params.put("subcompanyname",subcompanyname); //subcompanyname 多维组织的分部名称
	params.put("departmentname",departmentname); //departmentname 多维组织的部门名称
	params.put("lastname",lastname);//lastname 姓名 
	params.put("loginid",loginid); //loginid 账号
	params.put("password",password);//password 密码 
	params.put("seclevel",seclevel); //seclevel 安全级别
	params.put("mobile",mobile); //mobile 手机号码
	params.put("email",email); //email 邮箱
	params.put("isoutmanager",isoutmanager);//isoutmanager 是否外部负责人0:不是1：是
	params.put("wxname",wxname); //wxname 微信昵称
	params.put("wxopenid",wxopenid);//wxopenid 用户微信openid 
	params.put("wxuuid",wxuuid); //wxuuid 用户微信uuid
	params.put("country",country); //country 所属国家
	params.put("province",province); //province 所属省份
	params.put("city",city); //city 所属城市
	params.put("customfrom",customfrom);//customfrom 信息来源
	
	result = HrmOutInterface.updateResourceByLoginId(params);
	JSONObject jsonObj = new JSONObject();
	jsonObj.put("resourceid",result.get("resourceid"));
	jsonObj.put("customid",result.get("customid"));
	jsonObj.put("errorinfo",result.get("errorinfo"));
	out.print(jsonObj.toString());
}else if(cmd.equals("getOutResourceInfoById")){//根据id获得人员信息
	String result1 = HrmOutInterface.getOutResourceInfoById(resourceid);
	out.print(result1);
}
%>