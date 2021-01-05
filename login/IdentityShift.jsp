<%@ page import="weaver.general.Util,
                 weaver.login.Account" %>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="verifylogin" class="weaver.login.VerifyLogin" scope="page"/>
<%
    //hubo 清除小窗口登录标识
	String fromPDA = Util.null2String((String)session.getAttribute("loginPAD"));   //从PDA登录
    if (request.getSession(true).getAttribute("layoutStyle") != null) request.getSession(true).setAttribute("layoutStyle", null);
    String shiftid = Util.null2String(request.getParameter("shiftid"));
    boolean ismutilangua = false;
    if(multilanguage == null) {
    	multilanguage = (String)staticobj.getObject("multilanguage") ;
    }else if(multilanguage.equals("y")){
    	ismutilangua = true;
    }
   // System.out.println("shiftid"+shiftid);
//xiaofeng 有效的登入者在退出时清除登陆标记
    List accounts = (List) session.getAttribute("accounts");
  //  System.out.println("size"+accounts.size());
    if (accounts == null || accounts.size() < 2) {
		if (fromPDA.equals("1")) response.sendRedirect("/login/LoginPDA.jsp");
		else response.sendRedirect("/login/Login.jsp");
    } else {
        Iterator iter = accounts.iterator();
        boolean invalid = true;
        while (iter.hasNext()) {
            Account a = (Account) iter.next();
            if (shiftid.equals("" + a.getId()) ) {
                invalid = false;
                break;
            }
        }
        if (invalid)
		{
			if (fromPDA.equals("1")) response.sendRedirect("/login/LoginPDA.jsp");
		    else response.sendRedirect("/login/Login.jsp");
		}
    }
    logmessages = (Map) application.getAttribute("logmessages");
    if (logmessages != null)
        logmessages.remove(user.getLoginid());
    request.getSession(true).removeValue("moniter");
    request.getSession(true).removeValue("WeaverMailSet");
    request.getSession(true).invalidate();
	weaver.hrm.HrmUserVarify.invalidateCookie(request,response);
    String usercheck = verifylogin.shiftIdentity(request, response, Integer.parseInt(shiftid),""+user.getLanguage(),ismutilangua);
    logmessages = (Map) application.getAttribute("logmessages");
    if (logmessages == null) {
        logmessages = new HashMap();
        logmessages.put("" + shiftid, "");
        application.setAttribute("logmessages", logmessages);
    }
    request.getSession(true).setAttribute("logmessage", usercheck);
    request.getSession(true).setAttribute("fromlogin", "yes");
    request.getSession(true).setAttribute("browser_isie",isIE);
    if (fromPDA.equals("1")) response.sendRedirect("/mainPDA.jsp");
	else {
		int userCompanyid=1;
		rs.executeSql("select subcompanyid1 from hrmresource where id="+Util.getIntValue(shiftid));
		if(rs.next()) userCompanyid=Util.getIntValue(rs.getString(1));
		
		UserTemplate  ut=new UserTemplate();
		
		ut.getTemplateByUID(Util.getIntValue(shiftid),userCompanyid);
		int templateId=ut.getTemplateId();
		int extendTempletid=ut.getExtendtempletid();
		int extendtempletvalueid=ut.getExtendtempletvalueid();
		
		
		
		if(extendTempletid!=0){
			if(extendTempletid==3){
				response.sendRedirect("/wui/main.jsp") ;
				return;
			}
			rsExtend.executeSql("select id,extendname,extendurl from extendHomepage  where id="+extendTempletid);
			if(rsExtend.next()){
				int id=Util.getIntValue(rsExtend.getString("id"));	
				String extendurl=Util.null2String(rsExtend.getString("extendurl"));	
				rs.executeSql("select * from extendHpWebCustom where templateid="+templateId);
				String defaultshow ="";
				if(rs.next()){
					defaultshow = Util.null2String(rs.getString("defaultshow"));
				}
				String param = "";
				if(!defaultshow.equals("")){
					param ="&"+defaultshow.substring(defaultshow.indexOf("?")+1);
				}
				
				response.sendRedirect(extendurl+"/index.jsp?templateId="+templateId+param) ;
				return;				  
			}
		} else {
			response.sendRedirect("/wui/main.jsp") ;
			return;
		}
	}
%>