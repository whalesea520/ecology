
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ page import="weaver.general.Util"%>
<%@ page import = "java.lang.reflect.Constructor" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.homepage.HomepageMore"%>
<%@ page import="weaver.page.element.ElementBaseCominfo"%>
<%@page import="weaver.page.HPTypeEnum"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String eid = Util.null2String(request.getParameter("eid"));
	String ebaseid = Util.null2String(request.getParameter("ebaseid"));
	String tabid = Util.null2String(request.getParameter("tabid"));
	//添加协同参数传递
	String hpid=Util.null2String(request.getParameter("hpid"));
    String reqid=Util.null2String(request.getParameter("requestid"));
    String pagetype=Util.null2String(request.getParameter("pagetype"));
    String fieldids=Util.null2String(request.getParameter("fieldids"));
    String fieldvalues=Util.null2String(request.getParameter("fieldvalues"));

	ElementBaseCominfo ebc = new ElementBaseCominfo();
	HomepageMore hm = new HomepageMore();
	String tranMethod = Util.null2String(ebc.getMoreMethod(ebaseid));
	String redirectUrl = "";
	Class tempClass=null;
	Method tempMethod=null;
	Constructor ct  =null;
	 tempClass = Class.forName("weaver.page.element.compatible.PageMore");		

	if(!ebaseid.equals("29")){
		if(!tranMethod.equals("")){
		
			 tempMethod = tempClass.getMethod(tranMethod, new Class[] {String.class });
			 ct = tempClass.getConstructor(null);
			redirectUrl =(String)tempMethod.invoke(ct.newInstance(null), new Object[] {eid});
		}
		if(!tabid.equals("")){
			redirectUrl=redirectUrl+"&tabid="+tabid;
			
		}
		
		if(!tabid.equals("")){
			redirectUrl=redirectUrl+"&tabid="+tabid;
		}else{
			User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
			if(user!=null){
			
				rs.executeQuery("select currenttab from hpcurrenttab where eid=? and userid=? and usertype=?",eid,user.getUID(),user.getType());

				if(rs.next()){
					tabid =rs.getString("currenttab");
				}
			}else{
				if(ebaseid.equals("7")||ebaseid.equals("1")||ebaseid.equals("news")){
					//rs.execute("select tabId,tabTitle,sqlWhere from hpNewsTabInfo where eid="+eid+" order by tabId");
					rs.executeQuery("select tabId,tabTitle,sqlWhere from hpNewsTabInfo where eid=? order by tabId",eid);
					
				}else{
					//rs.execute("select tabId,tabTitle from hpsetting_wfcenter where eid="+eid+" order by tabId");
					rs.executeQuery("select tabId,tabTitle from hpsetting_wfcenter where eid=? order by tabId",eid);
				}
				if(rs.next()){
					tabid = rs.getString("tabId");
				}
			}
			if(!tabid.equals("")){
				redirectUrl=redirectUrl+"&tabid="+tabid;
			}
		}
	}else{
		if(!tranMethod.equals("")){
			if(tabid.equals("")){
				User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ; ;
				if(user!=null){
					rs.executeQuery("select currenttab from hpcurrenttab where eid=? and userid=? and usertype=?",eid,user.getUID(),user.getType());
					if(rs.next()){
						tabid =rs.getString("currenttab");
					}
				}else{
					
					//rs.execute("select tabId,tabTitle,sqlWhere from hpNewsTabInfo where eid="+eid+" order by tabId");	
					rs.executeQuery("select tabId,tabTitle,sqlWhere from hpNewsTabInfo where eid=? order by tabId",eid);
					
					if(rs.next()){
						tabid = rs.getString("tabId");
					}
				}
			}
			 tempMethod = tempClass.getMethod(tranMethod, new Class[] {String.class,String.class });
			 ct = tempClass.getConstructor(null);
			redirectUrl =(String)tempMethod.invoke(ct.newInstance(null), new Object[] {eid,tabid});
		}
		
	}
    //流程协同
	if(ebaseid.equals("8") && Util.getIntValue(hpid)<0){
	   redirectUrl=redirectUrl+"&requestid="+reqid+"&hpid="+hpid;
	   if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
		   redirectUrl += "&pagetype="+pagetype+"&fieldids="+fieldids+"&fieldvalues="+ URLEncoder.encode(fieldvalues, "utf-8");
	   }
	}
	
    response.sendRedirect(redirectUrl);
%>