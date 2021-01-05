/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._workflow._request;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.workflow.request.WorkflowRequestMessage;
import weaver.common.StringUtil;
import weaver.general.Util;
import org.json.JSONObject;
import org.json.JSONException;
import weaver.systeminfo.SystemEnv;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;

public class _wfsubmiterrormsg__jsp extends com.caucho.jsp.JavaPage
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
      
User user = HrmUserVarify.getUser (request , response) ;
if(user == null) return;
String message = request.getParameter("message");
String requestid = request.getParameter("requestid");
String messagecontent = Util.null2String(session.getAttribute("errormsg_"+user.getUID()+"_"+requestid));
if("1021".equals(message)){
	String _fnaBudgetControl_AlertInfo = Util.null2String(session.getAttribute(requestid+"_"+1021)).trim();
	if(!"".equals(_fnaBudgetControl_AlertInfo)){
		messagecontent = _fnaBudgetControl_AlertInfo;
		session.setAttribute(requestid+"_"+1021,"");
	}
}
int formid=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"formid"),0);
String bottom = "";
String details = "";
if(StringUtil.isNotNull(messagecontent)){
	try{
	    JSONObject jo = new JSONObject(messagecontent);
		if(jo.has("details")){
 			details = Util.null2String(jo.getString("details"));
		}
		
		if(jo.has("bottomprefix")){
		    String bottomprefix =  Util.null2String(jo.getString("bottomprefix"));
			int msgurlparm = jo.getInt("msgurlparm");
			int msgtype = jo.getInt("msgtype");
			bottom = WorkflowRequestMessage.getBottomWorkflowInfo(bottomprefix,msgtype,user,msgurlparm);
		}
	}catch(JSONException e){
	    details = messagecontent;
	}
}

      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((SystemEnv.getHtmlLabelName(33488,user.getLanguage()) ));
      out.write(_jsp_string2, 0, _jsp_string2.length);
      out.print((SystemEnv.getHtmlLabelName(126558,user.getLanguage())));
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((SystemEnv.getHtmlLabelName(18913,user.getLanguage())));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((SystemEnv.getHtmlLabelName(126556,user.getLanguage())));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((SystemEnv.getHtmlLabelName(126554,user.getLanguage())));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((SystemEnv.getHtmlLabelName(126555,user.getLanguage())));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((SystemEnv.getHtmlLabelName(126555,user.getLanguage())));
      out.write(_jsp_string8, 0, _jsp_string8.length);
      out.print((requestid));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((SystemEnv.getHtmlLabelName(126317,user.getLanguage())));
      out.write(_jsp_string10, 0, _jsp_string10.length);
      if(formid == 14){
      out.write(_jsp_string11, 0, _jsp_string11.length);
      }
      out.write(_jsp_string12, 0, _jsp_string12.length);
      out.print((SystemEnv.getHtmlLabelName(18214,user.getLanguage())));
      out.write(_jsp_string13, 0, _jsp_string13.length);
      if(StringUtil.isNotNull(message)){
      out.write(_jsp_string14, 0, _jsp_string14.length);
      out.print((WorkflowRequestMessage.getNewMessageId(message,user.getLanguage())));
      out.write(_jsp_string15, 0, _jsp_string15.length);
      if(StringUtil.isNotNull(details)){
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((details ));
      out.write(_jsp_string17, 0, _jsp_string17.length);
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(StringUtil.isNotNull(bottom)){
      out.write(_jsp_string19, 0, _jsp_string19.length);
      out.print((bottom ));
      out.write(_jsp_string20, 0, _jsp_string20.length);
      }
      out.write(_jsp_string21, 0, _jsp_string21.length);
      }
      out.write(_jsp_string22, 0, _jsp_string22.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("workflow/request/wfSubmitErrorMsg.jsp"), 540777983581847299L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string19;
  private final static char []_jsp_string12;
  private final static char []_jsp_string4;
  private final static char []_jsp_string22;
  private final static char []_jsp_string11;
  private final static char []_jsp_string15;
  private final static char []_jsp_string3;
  private final static char []_jsp_string9;
  private final static char []_jsp_string13;
  private final static char []_jsp_string16;
  private final static char []_jsp_string6;
  private final static char []_jsp_string21;
  private final static char []_jsp_string20;
  private final static char []_jsp_string17;
  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  private final static char []_jsp_string18;
  private final static char []_jsp_string7;
  private final static char []_jsp_string2;
  private final static char []_jsp_string8;
  private final static char []_jsp_string14;
  private final static char []_jsp_string5;
  private final static char []_jsp_string10;
  static {
    _jsp_string19 = "\r\n							     	 <div class=\"message-bottom\">\r\n							     		 <span>".toCharArray();
    _jsp_string12 = "\r\n			});\r\n			\r\n			\r\n			//\u91cd\u65b0\u9009\u62e9\u64cd\u4f5c\u8005\r\n			function rechoseoperator(){\r\n				var frmmain = jQuery(\"form[name='frmmain']\");\r\n				var eh_dialog = null;\r\n				if(window.top.Dialog)\r\n					eh_dialog = new window.top.Dialog();\r\n				else\r\n					eh_dialog = new Dialog();\r\n				eh_dialog.currentWindow = window;\r\n				eh_dialog.Width = 650;\r\n				eh_dialog.Height = 500;\r\n				eh_dialog.Modal = true;\r\n				eh_dialog.maxiumnable = false;\r\n				eh_dialog.Title = \"".toCharArray();
    _jsp_string4 = "\" == title){\r\n					botfix=\"".toCharArray();
    _jsp_string22 = "\r\n	</body>\r\n</html>\r\n\r\n				".toCharArray();
    _jsp_string11 = "\r\n						var url = jQuery('#wfSErrorResetBtn').attr('href');\r\n						var title = jQuery('#wfSErrorResetBtn').attr('title');\r\n						var type = jQuery('#wfSErrorResetBtn').attr('type');\r\n						jQuery('#wfSErrorResetBtn').attr('href','#');\r\n						jQuery('#wfSErrorResetBtn').attr('onclick',\"resetWorkflow('\"+url+\"','\"+title+\"','\"+type+\"')\");\r\n						jQuery('#wfSErrorResetBtn').removeAttr('target');\r\n						jQuery('#wfSErrorResetBtn').removeAttr('title');\r\n						jQuery('.condition').css('color','#123885!important');\r\n						jQuery(\"#wfSErrorResetBtn\").removeAttr('style');\r\n					".toCharArray();
    _jsp_string15 = "\r\n						     	 </span>\r\n						     	 ".toCharArray();
    _jsp_string3 = "\";\r\n				if(\"".toCharArray();
    _jsp_string9 = "'\r\n					},\r\n					error:function (XMLHttpRequest, textStatus, errorThrown) {\r\n						jQuery('.message-bottom span').html(ahtml);\r\n					} , \r\n				    success:function (data, textStatus) {\r\n				    	window.top.Dialog.alert(\"".toCharArray();
    _jsp_string13 = "\";\r\n				eh_dialog.URL = \"/workflow/request/requestChooseOperator.jsp\";\r\n				eh_dialog.callbackfun = function(paramobj, datas) {\r\n					frmmain.append('<input type=\"hidden\" name=\"eh_setoperator\" value=\"y\" />');\r\n					frmmain.append('<input type=\"hidden\" name=\"eh_relationship\" value=\"'+datas.relationship+'\" />');\r\n					frmmain.append('<input type=\"hidden\" name=\"eh_operators\" value=\"'+datas.operators+'\" />');\r\n					doSubmitBack();		//\u6a21\u62df\u63d0\u4ea4\r\n				};\r\n				eh_dialog.closeHandle = function(paramobj, datas){\r\n					if(frmmain.find(\"input[name='eh_setoperator']\").size() == 0){\r\n						frmmain.append('<input type=\"hidden\" name=\"eh_setoperator\" value=\"n\" />');\r\n						doSubmitBack();		//\u6a21\u62df\u63d0\u4ea4\r\n					}\r\n				};\r\n				eh_dialog.show();\r\n			}\r\n		</script>	\r\n	</head>\r\n	<body>\r\n		".toCharArray();
    _jsp_string16 = "\r\n					 		     	 <div class=\"message-detail\">\r\n					     	     		 ".toCharArray();
    _jsp_string6 = "<a id=\"wfSErrorResetBtn\" style=\"color:#2b8ae2!important;\" href=\"'+url+'\" title=\"'+title+'\" type=\"'+type+'\"> ".toCharArray();
    _jsp_string21 = "\r\n					     	 </div>\r\n				     	 </td>\r\n			     	 </tr>\r\n			   	 </table>\r\n			</div>\r\n		".toCharArray();
    _jsp_string20 = "</span>\r\n							     	 </div>\r\n						     	 ".toCharArray();
    _jsp_string17 = "\r\n							     	 </div>\r\n						     	 ".toCharArray();
    _jsp_string0 = "<!DOCTYPE html>\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n<html>\r\n	<head>\r\n		<link type=\"text/css\" href=\"/css/ecology8/worflowmessage_wev8.css\" rel=\"stylesheet\"></link>\r\n		<script type=\"text/javascript\">\r\n			//\u5f39\u51fa\u6d41\u7a0b\u8bbe\u7f6e\u7a97\u53e3\r\n			function resetWorkflow(url,title,type){\r\n				if(type == '3'){\r\n					openFullWindowHaveBar(url);\r\n					return;\r\n				}else if(type == '1'||type =='2'){\r\n					url = \"/workflow/request/WFReset.jsp?wfid=\"+url+\"&type=\"+type;\r\n					title =  '".toCharArray();
    _jsp_string18 = "\r\n						     	 ".toCharArray();
    _jsp_string7 = " </a>'+botfix+'</span>';\r\n				var ahtml = jQuery('.message-bottom span').html();\r\n				jQuery('<span> ".toCharArray();
    _jsp_string2 = "';\r\n				}\r\n				dialog = new window.top.Dialog();\r\n				dialog.currentWindow = window;\r\n				dialog.Title = title;\r\n				dialog.Width = 1020;\r\n				dialog.Height = 580;\r\n				dialog.Drag = true;\r\n				dialog.maxiumnable = false;\r\n				dialog.URL = url;\r\n				dialog.show();\r\n				\r\n			}\r\n			//\u751f\u6210\u7cfb\u7edf\u63d0\u9192\u6d41\u7a0b\r\n			function triggerSystemWorkflow(prefix,url,title,loginuserid,type){\r\n				prefix = prefix.replace(/~0~/g,\"<span class='importantInfo'>\");\r\n				prefix = prefix.replace(/~1~/g,\"</span>\");\r\n				prefix = prefix.replace(/~2~/g,\"<span class='importantDetailInfo'>\");\r\n				var infohtml = jQuery('.message-detail').html();\r\n				if(!infohtml){\r\n					infohtml = \"\";\r\n				}else{\r\n					infohtml = \"<div class='message-detail'>\"+infohtml+\"</div>\";\r\n				}\r\n				var botfix = \"".toCharArray();
    _jsp_string8 = " <span>').replaceAll('.message-bottom .sendMsgBtn');\r\n				jQuery.ajax({\r\n					type:'post',\r\n					url:'/workflow/request/TriggerRemindWorkflow.jsp?_'+new Date().getTime()+\"=1\",\r\n					data:{\r\n						remark:messagedetail,\r\n						loginuserid:loginuserid,\r\n						requestid:'".toCharArray();
    _jsp_string14 = "\r\n			<div class=\"message-box\">\r\n				<table>\r\n					<tr>\r\n						<td valign=\"top\">\r\n						 	<div class=\"message-title-icon\"></div>\r\n						 </td>\r\n						 <td>\r\n						 	<div class=\"message-content\">\r\n								 <span class=\"message-title\">\r\n						     	 	".toCharArray();
    _jsp_string5 = "\";\r\n				}\r\n				var messagedetail = infohtml + '<span>'+prefix + '\uff0c".toCharArray();
    _jsp_string10 = "\");\r\n				    }\r\n				});\r\n			}\r\n			\r\n			jQuery(document).ready(function(){\r\n					jQuery('.message-detail .condition').each(function(){\r\n						var _a = jQuery(this).attr('index');\r\n						if(!jQuery.isEmptyObject(_a)){\r\n							jQuery(this).hover(\r\n								function(){\r\n									jQuery('#condit'+_a).css('display','block');\r\n									jQuery('#condit'+_a).css('left',window.event.clientX);\r\n								},\r\n								function(){\r\n									jQuery('#condit'+_a).css('display','none');\r\n								}\r\n							);\r\n						}\r\n					});\r\n					".toCharArray();
  }
}
