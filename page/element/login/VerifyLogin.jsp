<%@ page import="weaver.general.Util,,weaver.general.StaticObj,weaver.hrm.settings.RemindSettings"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyLogin"
	scope="page" />
<jsp:useBean id="dactylogramCompare"
	class="weaver.login.dactylogramCompare" scope="page" />
<jsp:useBean id="VerifyLogin" class="weaver.login.VerifyLogin"
	scope="page" />


<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%
	String loginfile = Util.null2String(request.getParameter("loginfile"));
	String logintype = Util.null2String(request.getParameter("logintype"));
	String loginid = Util.null2String(request.getParameter("loginid"));
	String userpassword = Util.null2String(request.getParameter("userpassword"));
	String message = Util.null2String(request.getParameter("message"));
	//xiaofeng
	String languid = "7";
	boolean ismutilangua = false;
	StaticObj staticobj = null;
	staticobj = StaticObj.getInstance();
	String multilanguage = (String) staticobj.getObject("multilanguage");
	if (multilanguage == null)
	{
		VerifyLogin.checkLicenseInfo();
		multilanguage = (String) staticobj.getObject("multilanguage");
	}
	if (multilanguage.equals("y"))
	{
		ismutilangua = true;
	}
	String serial = Util.null2String(request.getParameter("serial"));
	String username = Util.null2String(request.getParameter("username"));
	String rnd = Util.null2String(request.getParameter("rnd"));
	String loginPDA = Util.null2String(request.getParameter("loginPDA"));
	String validatecode = Util.null2String(request.getParameter("validatecode"));
	Cookie[] ck = request.getCookies();
	int ckLength = 0;
	try
	{
		ckLength = ck.length;
	}
	catch (NullPointerException ex)
	{
		message = "noAllowIe=yes";
	}

	String dactylogram = Util.null2String(request.getParameter("dactylogram"));//指纹特征
	boolean compareFlag = false;
	if (!dactylogram.equals(""))
	{
		compareFlag = dactylogramCompare.executeCompare(dactylogram);
		if (compareFlag)
		{
			loginid = dactylogramCompare.getLoginId();
			userpassword = dactylogramCompare.getPassword();
			logintype = "1";
		}
		else
		{
			message = "message=nomatch";
		}
	}

	if (loginid.equals("") || userpassword.equals(""))
	{
		message = SystemEnv.getErrorMsgName(18, 7);
	}
	else
	{
		RemindSettings settings = (RemindSettings) application.getAttribute("hrmsettings");
		String needusb = settings.getNeedusb();
		String usercheck;
		if (compareFlag)
		{
			usercheck = verifylogin.getUserCheckByDactylogram(request, response, loginid, userpassword, logintype, loginfile, validatecode,
					message, languid, ismutilangua);
		}
		else
		{
			if (needusb != null && needusb.equals("1"))
			{
				usercheck = verifylogin.getUserCheck(request, response, loginid, userpassword, serial, username, rnd, logintype, loginfile,
						validatecode, message, languid, ismutilangua);
			}
			else
			{
				usercheck = verifylogin.getElementUserCheck(request, response, loginid, userpassword, logintype, loginfile, validatecode, message,
						languid, ismutilangua);
			}
		}
		if (usercheck.equals("15") || usercheck.equals("16") || usercheck.equals("57") || usercheck.equals("17") || usercheck.equals("45")
				 || usercheck.equals("47") || usercheck.equals("52") || usercheck.equals("55")||usercheck.equals("19"))
		{
			message = SystemEnv.getErrorMsgName(Util.getIntValue(usercheck), 7);
		}
		else if (usercheck.equals("46"))
		{
			message = "message=46";
		}
		else if (usercheck.equals("101"))
		{
			message = SystemEnv.getHtmlLabelName(20289, 7);
		}
		else
		{
			User user = HrmUserVarify.getUser(request, response);
			if (user == null)
			{
				message = SystemEnv.getHtmlLabelName(81686, 7);
			}
		}
	}
	out.println(message);
%>




