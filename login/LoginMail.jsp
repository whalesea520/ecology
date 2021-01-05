<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.workflow.request.RequestUtil"%>
<%@page import="java.net.URLEncoder"%>

<<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"></jsp:useBean>

<%
String gopage=Util.null2String(request.getParameter("gopage"));
String loginPage = "login/Login.jsp";

if(GCONST.getMailReminderSet()){
	loginPage = GCONST.getMailLoginPage();  //跳转到配置的邮件登录页面
}

if(!"".equals(gopage))   //流程的相关页面不为空
{
	String tempurl = gopage;
	Map params = new HashMap();
	tempurl = tempurl.replaceAll("\\?","&");
	RequestUtil.parseParameters(params, tempurl, "utf-8");
	int requestid = -1;
	if(params.containsKey("requestid")){
		String [] reqids = (String [])params.get("requestid");
		if(reqids != null && reqids.length > 0){
			requestid = Util.getIntValue(reqids[0],-1);
		}
	}
	
	
	User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;  //获取用户登录信息
	if(user!=null){    //已登录
		loginPage += "?gopage=" + gopage;
		int userid = user.getUID();
		String logintype = user.getLogintype();
		int usertype = 0;
		if("2".equals(logintype)){
			usertype = 1;
		}
		String accounttype = user.getAccount_type();
		String allUserids = "";
		String belongtoshow = "";			
		if(usertype == 0){
			if("1".equals(accounttype)){   //次账号
				String sql = "select belongto from hrmresource where id = " + userid;
				rs.executeSql(sql);
				if(rs.next()){
					int belongto = Util.getIntValue(Util.null2String(rs.getString("belongto")),-1);
					if(belongto > 0){
						User mainuser = User.getUser(belongto,usertype);
						allUserids = mainuser.getBelongtoids();
						if(!"".equals(allUserids)){
							allUserids += "," + belongto;
						}else{
							allUserids = belongto + "";
						}
						
						//多账号数据统一在主账号显示
						rs.executeSql("select * from HrmUserSetting where resourceId = " + belongto);
						if(rs.next()){
							belongtoshow =  Util.null2String(rs.getString("belongtoshow"));
						}
					}
				}
			}else{  //主账号
				allUserids = user.getBelongtoids();
				if(!"".equals(allUserids)){
					allUserids += "," + userid;
				}else{
					allUserids = userid + "";
				}
				
				//多账号数据统一在主账号显示
				rs.executeSql("select * from HrmUserSetting where resourceId = " + userid);
				if(rs.next()){
					belongtoshow =  Util.null2String(rs.getString("belongtoshow"));
				}
			}
		}
		
		boolean canView = false;   //当前用户是否是流程的操作者，如果是操作者的话，那就可以查看流程
		if(requestid > 0 && "1".equals(logintype)){  //请求的id正确解析，当前登录用户类型是用户，而非客户
			String sql = "select requestid from workflow_currentoperator where requestid = " + requestid + " and userid = " + userid;
			rs.executeSql(sql);
			if(rs.next()){
				canView = true;
			}
		}
		
		if(!canView && "1".equals(belongtoshow)){   //说明当前用户不能查看流程
			if(!"".equals(allUserids)){
				String sql = "select requestid,userid,usertype from workflow_currentoperator where requestid = " + requestid + " and userid in (" + allUserids + ")";
				rs.executeSql(sql);
				if(rs.next()){
					int f_weaver_belongto_userid = Util.getIntValue(Util.null2String(rs.getString("userid")),0);
					int f_weaver_belongto_usertype = Util.getIntValue(Util.null2String(rs.getString("usertype")),0);
					if(f_weaver_belongto_userid > 0){
						gopage += "&f_weaver_belongto_userid=" + f_weaver_belongto_userid + "&f_weaver_belongto_usertype=" + f_weaver_belongto_usertype;						
					}
				}
			}
		}
		if(!gopage.startsWith("/"))
		{
			gopage = "/" + gopage;   //使用绝对路径
		}
		response.sendRedirect(gopage);
	    return;
	}
}

if(!loginPage.startsWith("/"))
{
	loginPage = "/" + loginPage;   //使用绝对路径
}

//当没有登录时，登录后，也从本页面跳转到流程页面，处理多账号统一主账号显示的问题
String gotopage2 = "/login/LoginMail.jsp?gopage=" + gopage;
gotopage2 = URLEncoder.encode(gotopage2,"utf-8");
loginPage = loginPage + "?gopage=" + gotopage2;
response.sendRedirect(loginPage);
%>