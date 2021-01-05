/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._workflow._request._ext;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import weaver.hrm.common.*;
import weaver.conn.*;
import weaver.systeminfo.*;
import weaver.hrm.attendance.domain.*;
import weaver.hrm.User;
import weaver.hrm.schedule.HrmAnnualManagement;
import weaver.hrm.schedule.HrmPaidSickManagement;
import weaver.hrm.attendance.manager.WorkflowBaseManager;

public class _hrmcustomleave__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;
  
  public void
  _jspService(javax.servlet.http.HttpServletRequest request,
              javax.servlet.http.HttpServletResponse response)
    throws java.io.IOException, javax.servlet.ServletException
  {
    javax.servlet.http.HttpSession session = request.getSession(true);
    com.caucho.server.webapp.WebApp _jsp_application = _caucho_getApplication();
    javax.servlet.ServletContext application = _jsp_application;
    com.caucho.jsp.PageContextImpl pageContext = _jsp_application.getJspApplicationContext().allocatePageContext(this, _jsp_application, request, response, null, session, 8192, true, false);
    javax.servlet.jsp.PageContext _jsp_parentContext = pageContext;
    javax.servlet.jsp.JspWriter out = pageContext.getOut();
    final javax.el.ELContext _jsp_env = pageContext.getELContext();
    javax.servlet.ServletConfig config = getServletConfig();
    javax.servlet.Servlet page = this;
    response.setContentType("text/html; charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.common.StringUtil strUtil;
      strUtil = (weaver.common.StringUtil) pageContext.getAttribute("strUtil");
      if (strUtil == null) {
        strUtil = new weaver.common.StringUtil();
        pageContext.setAttribute("strUtil", strUtil);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.common.DateUtil dateUtil;
      dateUtil = (weaver.common.DateUtil) pageContext.getAttribute("dateUtil");
      if (dateUtil == null) {
        dateUtil = new weaver.common.DateUtil();
        pageContext.setAttribute("dateUtil", dateUtil);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.attendance.manager.HrmAttProcSetManager attProcSetManager;
      attProcSetManager = (weaver.hrm.attendance.manager.HrmAttProcSetManager) pageContext.getAttribute("attProcSetManager");
      if (attProcSetManager == null) {
        attProcSetManager = new weaver.hrm.attendance.manager.HrmAttProcSetManager();
        pageContext.setAttribute("attProcSetManager", attProcSetManager);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.attendance.manager.HrmAttVacationManager attVacationManager;
      attVacationManager = (weaver.hrm.attendance.manager.HrmAttVacationManager) pageContext.getAttribute("attVacationManager");
      if (attVacationManager == null) {
        attVacationManager = new weaver.hrm.attendance.manager.HrmAttVacationManager();
        pageContext.setAttribute("attVacationManager", attVacationManager);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager paidLeaveTimeManager;
      paidLeaveTimeManager = (weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager) pageContext.getAttribute("paidLeaveTimeManager");
      if (paidLeaveTimeManager == null) {
        paidLeaveTimeManager = new weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager();
        pageContext.setAttribute("paidLeaveTimeManager", paidLeaveTimeManager);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.attendance.manager.HrmLeaveTypeColorManager colorManager;
      colorManager = (weaver.hrm.attendance.manager.HrmLeaveTypeColorManager) pageContext.getAttribute("colorManager");
      if (colorManager == null) {
        colorManager = new weaver.hrm.attendance.manager.HrmLeaveTypeColorManager();
        pageContext.setAttribute("colorManager", colorManager);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
	User user = (User)request.getSession(true).getAttribute("weaver_user@bean");
	int nodetype = strUtil.parseToInt(request.getParameter("nodetype"), 0);
	int workflowid = strUtil.parseToInt(request.getParameter("workflowid"), 0);
	int formid = strUtil.parseToInt(request.getParameter("formid"));
	int userid = strUtil.parseToInt(request.getParameter("userid"));
	String creater = strUtil.vString(request.getParameter("creater"), String.valueOf(userid));
	WorkflowBaseManager workflowBaseManager = new WorkflowBaseManager();
	if(formid == -1) {
		WorkflowBase bean = workflowBaseManager.get(workflowid);
		formid = bean == null ? -1 : bean.getFormid();
	}
	String[] fieldList = attProcSetManager.getFieldList(workflowid, formid);
	if(fieldList == null || fieldList.length == 0 || strUtil.isNull(fieldList[0])) return;
	String currentdate = strUtil.vString(request.getParameter("currentdate"), dateUtil.getCurrentDate());
	String f_weaver_belongto_userid = strUtil.vString(request.getParameter("f_weaver_belongto_userid"));
	String f_weaver_belongto_usertype = strUtil.vString(request.getParameter("f_weaver_belongto_usertype"));
	String userannualinfo = HrmAnnualManagement.getUserAannualInfo(creater,currentdate);
	String thisyearannual = Util.TokenizerString2(userannualinfo,"#")[0];
	String lastyearannual = Util.TokenizerString2(userannualinfo,"#")[1];
	String allannual = Util.TokenizerString2(userannualinfo,"#")[2];
	String userpslinfo = HrmPaidSickManagement.getUserPaidSickInfo(creater, currentdate);
	String thisyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[0], 0);
	String lastyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[1], 0);
	String allpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[2], 0);
	String paidLeaveDays = String.valueOf(paidLeaveTimeManager.getCurrentPaidLeaveDaysByUser(creater));
	String allannualValue = allannual;
	String allpsldaysValue = allpsldays;
	String paidLeaveDaysValue = paidLeaveDays;
	float[] freezeDays = attVacationManager.getFreezeDays(creater);
	if(freezeDays[0] > 0) allannual += " - "+freezeDays[0];
	if(freezeDays[1] > 0) allpsldays += " - "+freezeDays[1];
	if(freezeDays[2] > 0) paidLeaveDays += " - "+freezeDays[2];
	
	float realAllannualValue = strUtil.parseToFloat(allannualValue, 0);
	float realAllpsldaysValue = strUtil.parseToFloat(allpsldaysValue, 0);
	float realPaidLeaveDaysValue = strUtil.parseToFloat(paidLeaveDaysValue, 0);
	if(attProcSetManager.isFreezeNode(workflowid, nodetype)) {
		realAllannualValue = (float)strUtil.round(realAllannualValue - freezeDays[0]);
		realAllpsldaysValue = (float)strUtil.round(realAllpsldaysValue - freezeDays[1]);
		realPaidLeaveDaysValue = (float)strUtil.round(realPaidLeaveDaysValue - freezeDays[2]);
	}
	String strleaveTypes = colorManager.getPaidleaveStr();  

      out.write(_jsp_string2, 0, _jsp_string2.length);
      out.print((formid));
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((fieldList[0]));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((fieldList[2]));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((fieldList[3]));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((fieldList[4]));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((fieldList[5]));
      out.write(_jsp_string8, 0, _jsp_string8.length);
      out.print((fieldList[6]));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((fieldList[7]));
      out.write(_jsp_string10, 0, _jsp_string10.length);
      out.print((fieldList[8]));
      out.write(_jsp_string11, 0, _jsp_string11.length);
      out.print((f_weaver_belongto_userid));
      out.write(_jsp_string12, 0, _jsp_string12.length);
      out.print((f_weaver_belongto_usertype));
      out.write(_jsp_string13, 0, _jsp_string13.length);
      out.print((allannualValue));
      out.write(_jsp_string14, 0, _jsp_string14.length);
      out.print((allpsldaysValue));
      out.write(_jsp_string15, 0, _jsp_string15.length);
      out.print((paidLeaveDaysValue));
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((realAllannualValue));
      out.write(_jsp_string17, 0, _jsp_string17.length);
      out.print((realAllpsldaysValue));
      out.write(_jsp_string18, 0, _jsp_string18.length);
      out.print((realPaidLeaveDaysValue));
      out.write(_jsp_string19, 0, _jsp_string19.length);
      out.print((strleaveTypes));
      out.write(_jsp_string20, 0, _jsp_string20.length);
      out.print((nodetype));
      out.write(_jsp_string21, 0, _jsp_string21.length);
      out.print((workflowid));
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((SystemEnv.getHtmlLabelName(125565, user.getLanguage())));
      out.write(_jsp_string23, 0, _jsp_string23.length);
      out.print((SystemEnv.getHtmlLabelName(125565, user.getLanguage())));
      out.write(_jsp_string24, 0, _jsp_string24.length);
      out.print((nodetype));
      out.write(_jsp_string21, 0, _jsp_string21.length);
      out.print((workflowid));
      out.write(_jsp_string25, 0, _jsp_string25.length);
      out.print((currentdate));
      out.write(_jsp_string26, 0, _jsp_string26.length);
      out.print((SystemEnv.getHtmlLabelName(125566, user.getLanguage())));
      out.write(_jsp_string27, 0, _jsp_string27.length);
      out.print((SystemEnv.getHtmlLabelName(125566, user.getLanguage())));
      out.write(_jsp_string28, 0, _jsp_string28.length);
      out.print((SystemEnv.getHtmlLabelName(125567, user.getLanguage())));
      out.write(_jsp_string29, 0, _jsp_string29.length);
      out.print((SystemEnv.getHtmlLabelName(125567, user.getLanguage())));
      out.write(_jsp_string30, 0, _jsp_string30.length);
      out.print((HrmAttVacation.L6));
      out.write(_jsp_string31, 0, _jsp_string31.length);
      out.print((HrmAttVacation.L12));
      out.write(_jsp_string32, 0, _jsp_string32.length);
      out.print((HrmAttVacation.L13));
      out.write(_jsp_string33, 0, _jsp_string33.length);
      if(nodetype!=3){
      out.write(_jsp_string34, 0, _jsp_string34.length);
      out.print((HrmAttVacation.L6));
      out.write(_jsp_string35, 0, _jsp_string35.length);
      out.print((SystemEnv.getHtmlLabelName(21720,user.getLanguage())));
      out.write(_jsp_string36, 0, _jsp_string36.length);
      out.print((SystemEnv.getHtmlLabelName(21721,user.getLanguage())));
      out.write(_jsp_string37, 0, _jsp_string37.length);
      out.print((HrmAttVacation.L12));
      out.write(_jsp_string38, 0, _jsp_string38.length);
      out.print((SystemEnv.getHtmlLabelName(131655,user.getLanguage())));
      out.write(_jsp_string39, 0, _jsp_string39.length);
      out.print((SystemEnv.getHtmlLabelName(131656,user.getLanguage())));
      out.write(_jsp_string37, 0, _jsp_string37.length);
      out.print((HrmAttVacation.L13));
      out.write(_jsp_string40, 0, _jsp_string40.length);
      out.print((SystemEnv.getHtmlLabelName(84604,user.getLanguage())));
      out.write(_jsp_string41, 0, _jsp_string41.length);
      out.print((SystemEnv.getHtmlLabelName(131655,user.getLanguage())));
      out.write(_jsp_string42, 0, _jsp_string42.length);
      out.print((SystemEnv.getHtmlLabelName(131656,user.getLanguage())));
      out.write(_jsp_string43, 0, _jsp_string43.length);
      }
      out.write(_jsp_string44, 0, _jsp_string44.length);
      out.print((SystemEnv.getHtmlLabelName(15273,user.getLanguage())));
      out.write(_jsp_string45, 0, _jsp_string45.length);
      out.print((SystemEnv.getHtmlLabelName(15273,user.getLanguage())));
      out.write(_jsp_string46, 0, _jsp_string46.length);
    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      _jsp_application.getJspApplicationContext().freePageContext(pageContext);
    }
  }

  private java.util.ArrayList _caucho_depends = new java.util.ArrayList();

  public java.util.ArrayList _caucho_getDependList()
  {
    return _caucho_depends;
  }

  public void _caucho_addDepend(com.caucho.vfs.PersistentDependency depend)
  {
    super._caucho_addDepend(depend);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  public boolean _caucho_isModified()
  {
    if (_caucho_isDead)
      return true;
    if (com.caucho.server.util.CauchoSystem.getVersionId() != 1886798272571451039L)
      return true;
    for (int i = _caucho_depends.size() - 1; i >= 0; i--) {
      com.caucho.vfs.Dependency depend;
      depend = (com.caucho.vfs.Dependency) _caucho_depends.get(i);
      if (depend.isModified())
        return true;
    }
    return false;
  }

  public long _caucho_lastModified()
  {
    return 0;
  }

  public java.util.HashMap<String,java.lang.reflect.Method> _caucho_getFunctionMap()
  {
    return _jsp_functionMap;
  }

  public void init(ServletConfig config)
    throws ServletException
  {
    com.caucho.server.webapp.WebApp webApp
      = (com.caucho.server.webapp.WebApp) config.getServletContext();
    super.init(config);
    com.caucho.jsp.TaglibManager manager = webApp.getJspApplicationContext().getTaglibManager();
    com.caucho.jsp.PageContextImpl pageContext = new com.caucho.jsp.PageContextImpl(webApp, this);
  }

  public void destroy()
  {
      _caucho_isDead = true;
      super.destroy();
  }

  public void init(com.caucho.vfs.Path appDir)
    throws javax.servlet.ServletException
  {
    com.caucho.vfs.Path resinHome = com.caucho.server.util.CauchoSystem.getResinHome();
    com.caucho.vfs.MergePath mergePath = new com.caucho.vfs.MergePath();
    mergePath.addMergePath(appDir);
    mergePath.addMergePath(resinHome);
    com.caucho.loader.DynamicClassLoader loader;
    loader = (com.caucho.loader.DynamicClassLoader) getClass().getClassLoader();
    String resourcePath = loader.getResourcePathSpecificFirst();
    mergePath.addClassPath(resourcePath);
    com.caucho.vfs.Depend depend;
    depend = new com.caucho.vfs.Depend(appDir.lookup("workflow/request/ext/HrmCustomLeave.jsp"), -610879508382496168L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string7;
  private final static char []_jsp_string39;
  private final static char []_jsp_string31;
  private final static char []_jsp_string4;
  private final static char []_jsp_string35;
  private final static char []_jsp_string12;
  private final static char []_jsp_string5;
  private final static char []_jsp_string18;
  private final static char []_jsp_string46;
  private final static char []_jsp_string2;
  private final static char []_jsp_string20;
  private final static char []_jsp_string21;
  private final static char []_jsp_string44;
  private final static char []_jsp_string30;
  private final static char []_jsp_string29;
  private final static char []_jsp_string19;
  private final static char []_jsp_string0;
  private final static char []_jsp_string37;
  private final static char []_jsp_string33;
  private final static char []_jsp_string16;
  private final static char []_jsp_string11;
  private final static char []_jsp_string3;
  private final static char []_jsp_string42;
  private final static char []_jsp_string43;
  private final static char []_jsp_string22;
  private final static char []_jsp_string40;
  private final static char []_jsp_string32;
  private final static char []_jsp_string13;
  private final static char []_jsp_string24;
  private final static char []_jsp_string10;
  private final static char []_jsp_string25;
  private final static char []_jsp_string27;
  private final static char []_jsp_string15;
  private final static char []_jsp_string26;
  private final static char []_jsp_string45;
  private final static char []_jsp_string38;
  private final static char []_jsp_string1;
  private final static char []_jsp_string8;
  private final static char []_jsp_string9;
  private final static char []_jsp_string34;
  private final static char []_jsp_string6;
  private final static char []_jsp_string28;
  private final static char []_jsp_string14;
  private final static char []_jsp_string17;
  private final static char []_jsp_string41;
  private final static char []_jsp_string23;
  private final static char []_jsp_string36;
  static {
    _jsp_string7 = "\";\r\n	var _field_toDate = \"".toCharArray();
    _jsp_string39 = "\");\r\n		        return false;\r\n			}\r\n			if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realAllpsldaysValue)){\r\n				window.top.Dialog.alert(\"".toCharArray();
    _jsp_string31 = "') {\r\n			getAnnualInfo(resourceId);\r\n		} else if(newLeaveType == '".toCharArray();
    _jsp_string4 = "\";\r\n	var _field_newLeaveType = \"".toCharArray();
    _jsp_string35 = "') {\r\n			if(allannualValue <= 0){\r\n				window.top.Dialog.alert(\"".toCharArray();
    _jsp_string12 = "\";\r\n	var f_weaver_belongto_usertype = \"".toCharArray();
    _jsp_string5 = "\";\r\n	var _field_fromDate = \"".toCharArray();
    _jsp_string18 = "\";\r\n	var realPaidLeaveDaysValue=\"".toCharArray();
    _jsp_string46 = "\");\r\n	  		return false;  \r\n	 	}\r\n 	}\r\n 	return true;\r\n}\r\n</script>\r\n".toCharArray();
    _jsp_string2 = "\r\n<script language=\"javascript\">\r\n	var formid = \"".toCharArray();
    _jsp_string20 = "\";\r\n\r\n	var ua = navigator.userAgent.toLowerCase();\r\n	var s;\r\n	s = ua.match(/msie ([\\d.]+)/);\r\n	\r\n	if(s && parseInt(s[1]) <= 8){\r\n		window.onload = function(){\r\n			if(_field_vacationInfo != \"\") {\r\n				try{\r\n					$GetEle(_field_vacationInfo).style.display = \"none\";\r\n					showVacationInfo();\r\n					\r\n				}catch(e){}\r\n			}\r\n			if(_field_leaveDays != \"\") {\r\n				try{\r\n					$GetEle(_field_leaveDays).style.display = \"none\";\r\n					jQuery(\"#\"+_field_leaveDays+\"span\").html(jQuery(\"input[name='\"+_field_leaveDays+\"']\").val());\r\n				}catch(e){}\r\n			}\r\n		}\r\n	}else{\r\n		jQuery(document).ready(function(){\r\n			if(_field_vacationInfo != \"\") {\r\n				try{\r\n					$GetEle(_field_vacationInfo).style.display = \"none\";\r\n					showVacationInfo();\r\n					\r\n				}catch(e){}\r\n			}\r\n			if(_field_leaveDays != \"\") {\r\n				try{\r\n					$GetEle(_field_leaveDays).style.display = \"none\";\r\n					jQuery(\"#\"+_field_leaveDays+\"span\").html(jQuery(\"input[name='\"+_field_leaveDays+\"']\").val());\r\n				}catch(e){}\r\n			}\r\n		});\r\n	}\r\n	\r\n	\r\n	function onShowTimeCallBack(id) {\r\n		var fieldid = id.split(\"_\")[0];\r\n		var rowindex = id.split(\"_\")[1];\r\n		wfbrowvaluechange_fna(null, fieldid, rowindex);\r\n	}\r\n	\r\n	function wfbrowvaluechange_fna(obj, fieldid, rowindex) {\r\n		fieldid = \"field\"+fieldid;\r\n		if(fieldid == _field_vacationInfo){ showVacationInfo();\r\n		}else if(fieldid == _field_fromDate || fieldid == _field_fromTime || fieldid == _field_toDate || fieldid == _field_toTime){setLeaveDays();\r\n			if(fieldid == _field_fromDate) {\r\n				initInfo();\r\n			}\r\n	    }else if(fieldid == _field_resourceId){\r\n			setLeaveDays();\r\n			initInfo();\r\n		}\r\n	}\r\n\r\n	function ajaxInit(){\r\n		var ajax=false;\r\n		try {\r\n			ajax = new ActiveXObject(\"Msxml2.XMLHTTP\");\r\n		} catch (e) {\r\n			try {\r\n				ajax = new ActiveXObject(\"Microsoft.XMLHTTP\");\r\n			} catch (E) {\r\n				ajax = false;\r\n			}\r\n		}\r\n		if (!ajax && typeof XMLHttpRequest!='undefined') {\r\n			ajax = new XMLHttpRequest();\r\n		}\r\n		return ajax;\r\n	}\r\n\r\n	function setLeaveDays(){\r\n		if(_field_leaveDays == \"\") return;\r\n		\r\n		var resourceId = jQuery(\"input[name='\"+_field_resourceId+\"']\").val();\r\n		var fromDate = jQuery(\"input[name='\"+_field_fromDate+\"']\").val();\r\n		var fromTime = jQuery(\"input[name='\"+_field_fromTime+\"']\").val();\r\n		var toDate = jQuery(\"input[name='\"+_field_toDate+\"']\").val();\r\n		var toTime = jQuery(\"input[name='\"+_field_toTime+\"']\").val();\r\n		var leaveDaysObj = jQuery(\"input[name='\"+_field_leaveDays+\"']\");\r\n		var leaveDyasType = leaveDaysObj.attr(\"type\");\r\n		var newLeaveType = jQuery(\"#\"+_field_newLeaveType).val();\r\n		\r\n		//\u964d\u4f4e\u8c03\u7528\u7684\u9891\u6b21\r\n		if(resourceId != '' && fromDate!='' && toDate!='' && fromTime!='' && toTime!=''){\r\n			var ajax=ajaxInit();\r\n			ajax.open(\"POST\", \"/workflow/request/BillBoHaiLeaveXMLHTTP.jsp\", true);\r\n			ajax.setRequestHeader(\"Content-Type\",\"application/x-www-form-urlencoded\");\r\n			ajax.send(\"operation=getLeaveDays&f_weaver_belongto_userid=\"+f_weaver_belongto_userid+\"&f_weaver_belongto_usertype=\"+f_weaver_belongto_usertype+\"&fromDate=\"+fromDate+\"&fromTime=\"+fromTime+\"&toDate=\"+toDate+\"&toTime=\"+toTime+\"&resourceId=\"+resourceId+\"&newLeaveType=\"+newLeaveType);\r\n			ajax.onreadystatechange = function() {\r\n				if (ajax.readyState == 4 && ajax.status == 200) {\r\n					try {\r\n						var result = trim(ajax.responseText);\r\n						leaveDaysObj.val(result);\r\n						//if(leaveDyasType == 'hidden') \r\n						jQuery(\"#\"+_field_leaveDays+\"span\").html(result);\r\n					} catch(e) {\r\n						leaveDaysObj.val(\"0.0\");\r\n						//if(leaveDyasType == 'hidden') \r\n						jQuery(\"#\"+_field_leaveDays+\"span\").html('0.0');\r\n					}\r\n				}\r\n			}\r\n		}\r\n		showVacationInfo();\r\n	}\r\nfunction initInfo(){\r\n		\r\n		var resourceId = jQuery(\"input[name='\"+_field_resourceId+\"']\").val();\r\n		var fromDate = jQuery(\"input[name='\"+_field_fromDate+\"']\").val();\r\n		if(typeof(resourceId) != \"undefined\" && resourceId != \"\" && typeof(fromDate) != \"undefined\" && fromDate != \"\") {\r\n			var ajax=ajaxInit();\r\n			ajax.open(\"POST\", \"/workflow/request/BillBoHaiLeaveXMLHTTP.jsp\", true);\r\n			ajax.setRequestHeader(\"Content-Type\",\"application/x-www-form-urlencoded\");\r\n			ajax.send(\"operation=initInfo&nodetype=".toCharArray();
    _jsp_string21 = "&workflowid=".toCharArray();
    _jsp_string44 = "\r\n		\r\n		return true;\r\n	};\r\n	\r\nfunction DateCheck(){\r\n	var fromDate = jQuery(\"input[name='\"+_field_fromDate+\"']\").val();\r\n	var fromTime = jQuery(\"input[name='\"+_field_fromTime+\"']\").val();\r\n	var toDate = jQuery(\"input[name='\"+_field_toDate+\"']\").val();\r\n	var toTime = jQuery(\"input[name='\"+_field_toTime+\"']\").val();\r\n	var begin = new Date(fromDate.replace(/\\-/g, \"\\/\"));\r\n	var end = new Date(toDate.replace(/\\-/g, \"\\/\"));\r\n 	if(fromTime != \"\" && toTime != \"\"){\r\n	 	begin = new Date(fromDate.replace(/\\-/g, \"\\/\")+\" \"+fromTime+\":00\");  \r\n	 	end = new Date(toDate.replace(/\\-/g, \"\\/\")+\" \"+toTime+\":00\");\r\n	 	if(fromDate!=\"\"&&toDate!=\"\"&&begin >end)  \r\n	 	{  \r\n	 		window.top.Dialog.alert(\"".toCharArray();
    _jsp_string30 = "\");\r\n					return;\r\n				}\r\n			}\r\n	    }\r\n	}\r\n}\r\n	function showVacationInfo(){\r\n	\r\n		if(_field_vacationInfo == \"\") return;\r\n		\r\n		var newLeaveType = jQuery(\"#\"+_field_newLeaveType).val();\r\n		var vacationInfoObj = jQuery(\"input[name='\"+_field_vacationInfo+\"']\");\r\n		var vacationInfoType = vacationInfoObj.attr(\"type\");\r\n		var resourceId = jQuery(\"input[name='\"+_field_resourceId+\"']\").val();\r\n	\r\n		var result = \"\";\r\n		if(newLeaveType == '".toCharArray();
    _jsp_string29 = "\");\r\n						return;\r\n					} else {\r\n						$GetEle(_field_vacationInfo).style.display = \"none\";\r\n		                jQuery(\"#\"+_field_vacationInfo+\"span\").html(TXInfo);\r\n						jQuery(\"#\"+_field_vacationInfo).val(TXInfo);\r\n					}\r\n				}catch(e){\r\n					//alert(\"".toCharArray();
    _jsp_string19 = "\";\r\n	var strleaveTypes=\"".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n<!-- Added by wcd 2015-06-25[\u81ea\u5b9a\u4e49\u8bf7\u5047\u5355] -->\r\n".toCharArray();
    _jsp_string37 = "\");\r\n				return false;\r\n			}\r\n		} else if(newLeaveType == '".toCharArray();
    _jsp_string33 = "') {\r\n		    getTXInfo(resourceId);\r\n		}else{\r\n		    //$GetEle(_field_vacationInfo).innerText = result;\r\n			\r\n			if(newLeaveType != '' && strleaveTypes.indexOf(\",\"+newLeaveType+\",\") > -1){\r\n		    	getPSInfo(resourceId);\r\n			}else{\r\n		    jQuery(\"#\"+_field_vacationInfo+\"span\").html(result);\r\n			jQuery(\"#\"+_field_vacationInfo).val(result);\r\n			}\r\n		}\r\n		\r\n	    confirmLeaveDays();\r\n	}\r\n	\r\n	function confirmLeaveDays(){\r\n		if(_field_leaveDays == \"\") return;\r\n		\r\n		var resourceId = jQuery(\"input[name='\"+_field_resourceId+\"']\").val();\r\n		var fromDate = jQuery(\"input[name='\"+_field_fromDate+\"']\").val();\r\n		var fromTime = jQuery(\"input[name='\"+_field_fromTime+\"']\").val();\r\n		var toDate = jQuery(\"input[name='\"+_field_toDate+\"']\").val();\r\n		var toTime = jQuery(\"input[name='\"+_field_toTime+\"']\").val();\r\n		var leaveDaysObj = jQuery(\"input[name='\"+_field_leaveDays+\"']\");\r\n		var leaveDyasType = leaveDaysObj.attr(\"type\");\r\n		var newLeaveType = jQuery(\"#\"+_field_newLeaveType).val();\r\n		//\u964d\u4f4e\u8c03\u7528\u7684\u9891\u6b21,confirm\u7684\u65f6\u5019\u589e\u52a0\u5bf9\u4e8e\u8bf7\u5047\u7c7b\u578b\u7684\u5224\u65ad\r\n		if(resourceId != '' && fromDate!='' && toDate!='' && fromTime!='' && toTime!='' && newLeaveType!=''){\r\n			var ajax=ajaxInit();\r\n			ajax.open(\"POST\", \"/workflow/request/BillBoHaiLeaveXMLHTTP.jsp\", true);\r\n			ajax.setRequestHeader(\"Content-Type\",\"application/x-www-form-urlencoded\");\r\n			ajax.send(\"operation=getLeaveDays&f_weaver_belongto_userid=\"+f_weaver_belongto_userid+\"&f_weaver_belongto_usertype=\"+f_weaver_belongto_usertype+\"&fromDate=\"+fromDate+\"&fromTime=\"+fromTime+\"&toDate=\"+toDate+\"&toTime=\"+toTime+\"&resourceId=\"+resourceId+\"&newLeaveType=\"+newLeaveType);\r\n			ajax.onreadystatechange = function() {\r\n				if (ajax.readyState == 4 && ajax.status == 200) {\r\n					try {\r\n						var result = trim(ajax.responseText);\r\n						leaveDaysObj.val(result);\r\n						jQuery(\"#\"+_field_leaveDays+\"span\").html(result);\r\n					} catch(e) {\r\n						leaveDaysObj.val(\"0.0\");\r\n						jQuery(\"#\"+_field_leaveDays+\"span\").html('0.0');\r\n					}\r\n				}\r\n			}\r\n		}\r\n	}\r\n	\r\n	initInfo();\r\n	checkCustomize = function() {\r\n		".toCharArray();
    _jsp_string16 = "\";\r\n	var realAllannualValue=\"".toCharArray();
    _jsp_string11 = "\";\r\n	var f_weaver_belongto_userid = \"".toCharArray();
    _jsp_string3 = "\";\r\n	var _field_resourceId = \"".toCharArray();
    _jsp_string42 = "\");\r\n			        return false;\r\n				}\r\n				if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realAllpsldaysValue)){\r\n					window.top.Dialog.alert(\"".toCharArray();
    _jsp_string43 = "\");\r\n					return false;\r\n				}\r\n			}\r\n		}\r\n		".toCharArray();
    _jsp_string22 = "&resourceId=\"+resourceId+\"&currentDate=\"+fromDate+\"&leavetype=\"+jQuery(\"#\"+_field_newLeaveType).val());\r\n		\r\n			ajax.onreadystatechange = function() {\r\n				if (ajax.readyState == 4 && ajax.status == 200) {\r\n					try {\r\n						 var result = trim(ajax.responseText);\r\n						 allannualValue=result.split(\"#\")[0];\r\n						 allpsldaysValue=result.split(\"#\")[1];\r\n						 paidLeaveDaysValue=result.split(\"#\")[2];\r\n						 realAllannualValue=result.split(\"#\")[3];\r\n						 realAllpsldaysValue=result.split(\"#\")[4];\r\n						 realPaidLeaveDaysValue=result.split(\"#\")[5];\r\n					} catch(e) {\r\n						\r\n					}\r\n				}\r\n			}\r\n		}\r\n	}	\r\n	\r\n	\r\nfunction getAnnualInfo(resourceId) {\r\n	var fromDate = jQuery(\"input[name='\"+_field_fromDate+\"']\").val() ;\r\n	if(typeof(resourceId) != \"undefined\" && resourceId != \"\") {//\u5f52\u6863\u540e\u67e5\u770b\u9875\u9762\u4e2d\uff0c\u9875\u9762\u4e0a\u4e0d\u5b58\u5728name\u7684\u5143\u7d20\r\n	    var ajax=ajaxInit();\r\n	    ajax.open(\"POST\", \"/workflow/request/BillBoHaiLeaveXMLHTTP.jsp\", true);\r\n	    ajax.setRequestHeader(\"Content-Type\",\"application/x-www-form-urlencoded\");\r\n	    ajax.send(\"operation=getAnnualInfo&resourceId=\"+resourceId+\"&currentDate=\"+fromDate);\r\n	    ajax.onreadystatechange = function() {\r\n	    	if (ajax.readyState == 4 && ajax.status == 200) {\r\n	    		try{\r\n	    			var annualInfo=trim(ajax.responseText).split(\"#\")[1];\r\n					if(annualInfo == \"\") {\r\n						//alert(\"".toCharArray();
    _jsp_string40 = "') {\r\n			if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realPaidLeaveDaysValue)){\r\n				window.top.Dialog.alert(\"".toCharArray();
    _jsp_string32 = "') {\r\n		    getPSInfo(resourceId);\r\n		} else if(newLeaveType == '".toCharArray();
    _jsp_string13 = "\";\r\n\r\n	var allannualValue=\"".toCharArray();
    _jsp_string24 = "\");\r\n					return;\r\n				}\r\n			}\r\n	    }\r\n	}\r\n}\r\nfunction getPSInfo(resourceId) {\r\n	if(typeof(resourceId) != \"undefined\" && resourceId != \"\") {//\u5f52\u6863\u540e\u67e5\u770b\u9875\u9762\u4e2d\uff0c\u9875\u9762\u4e0a\u4e0d\u5b58\u5728name\u7684\u5143\u7d20\r\n	    var ajax=ajaxInit();\r\n	    ajax.open(\"POST\", \"/workflow/request/BillBoHaiLeaveXMLHTTP.jsp\", true);\r\n	    ajax.setRequestHeader(\"Content-Type\",\"application/x-www-form-urlencoded\");\r\n		ajax.send(\"operation=getPSInfo&resourceId=\"+resourceId+\"&nodetype=".toCharArray();
    _jsp_string10 = "\";\r\n	var _field_vacationInfo = \"".toCharArray();
    _jsp_string25 = "&currentDate=".toCharArray();
    _jsp_string27 = "\");\r\n						return;\r\n					} else {\r\n					 	allpsldaysValue=PSallpsldaysValue;\r\n					 	realAllpsldaysValue=PSrealAllpsldaysValue;\r\n						$GetEle(_field_vacationInfo).style.display = \"none\";\r\n		                jQuery(\"#\"+_field_vacationInfo+\"span\").html(PSInfo);\r\n						jQuery(\"#\"+_field_vacationInfo).val(PSInfo);\r\n					}\r\n				}catch(e){\r\n					//alert(\"".toCharArray();
    _jsp_string15 = "\";\r\n	var paidLeaveDaysValue=\"".toCharArray();
    _jsp_string26 = "&leavetype=\"+jQuery(\"#\"+_field_newLeaveType).val());\r\n\r\n	    ajax.onreadystatechange = function() {\r\n	    	if (ajax.readyState == 4 && ajax.status == 200) {\r\n	    		try{\r\n	    			var PSallpsldaysValue=trim(ajax.responseText).split(\"#\")[1];\r\n	    			var PSrealAllpsldaysValue=trim(ajax.responseText).split(\"#\")[2];\r\n	    			var PSInfo=trim(ajax.responseText).split(\"#\")[3];\r\n					if(PSInfo == \"\") {\r\n						//alert(\"".toCharArray();
    _jsp_string45 = "\");\r\n	  		return false;  \r\n	 	}\r\n 	}else{\r\n 		if(fromDate!=\"\"&&toDate!=\"\"&&begin >end)  \r\n	 	{  \r\n	 		window.top.Dialog.alert(\"".toCharArray();
    _jsp_string38 = "') {\r\n			if(allpsldaysValue <= 0){\r\n				window.top.Dialog.alert(\"".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string8 = "\";\r\n	var _field_toTime = \"".toCharArray();
    _jsp_string9 = "\";\r\n	var _field_leaveDays = \"".toCharArray();
    _jsp_string34 = "\r\n		var newLeaveType = jQuery(\"#\"+_field_newLeaveType).val();\r\n		if(!DateCheck()){\r\n			return false;\r\n		}\r\n		\r\n		if(newLeaveType == '".toCharArray();
    _jsp_string6 = "\";\r\n	var _field_fromTime = \"".toCharArray();
    _jsp_string28 = "\");\r\n					return;\r\n				}\r\n			}\r\n	    }\r\n	}\r\n}\r\nfunction getTXInfo(resourceId) {\r\n	//alert(resourceId + \"===getPSInfo\");\r\n	if(typeof(resourceId) != \"undefined\" && resourceId != \"\") {//\u5f52\u6863\u540e\u67e5\u770b\u9875\u9762\u4e2d\uff0c\u9875\u9762\u4e0a\u4e0d\u5b58\u5728name\u7684\u5143\u7d20\r\n	    var ajax=ajaxInit();\r\n	    ajax.open(\"POST\", \"/workflow/request/BillBoHaiLeaveXMLHTTP.jsp\", true);\r\n	    ajax.setRequestHeader(\"Content-Type\",\"application/x-www-form-urlencoded\");\r\n		var fromDate = jQuery(\"input[name='\"+_field_fromDate+\"']\").val();\r\n	    ajax.send(\"operation=getTXInfo&resourceId=\"+resourceId+\"&currentDate=\"+fromDate);\r\n	    ajax.onreadystatechange = function() {\r\n	    	if (ajax.readyState == 4 && ajax.status == 200) {\r\n	    		try{\r\n	    			var TXInfo=trim(ajax.responseText).split(\"#\")[1];\r\n					if(TXInfo == \"\") {\r\n						//alert(\"".toCharArray();
    _jsp_string14 = "\";\r\n	var allpsldaysValue=\"".toCharArray();
    _jsp_string17 = "\";\r\n	var realAllpsldaysValue=\"".toCharArray();
    _jsp_string41 = "\");\r\n				return false;\r\n			}\r\n		} else{\r\n			if(newLeaveType != '' && strleaveTypes.indexOf(\",\"+newLeaveType+\",\") > -1){\r\n				if(allpsldaysValue <= 0){\r\n					window.top.Dialog.alert(\"".toCharArray();
    _jsp_string23 = "\");\r\n						return;\r\n					} else {\r\n						$GetEle(_field_vacationInfo).style.display = \"none\";\r\n		                jQuery(\"#\"+_field_vacationInfo+\"span\").html(annualInfo);\r\n						jQuery(\"#\"+_field_vacationInfo).val(annualInfo);\r\n					}\r\n				}catch(e){\r\n					//alert(\"".toCharArray();
    _jsp_string36 = "\");\r\n		        return false;\r\n			}\r\n			if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realAllannualValue)){\r\n				window.top.Dialog.alert(\"".toCharArray();
  }
}
