/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._mobile._plugin._1;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.*;
import java.util.*;
import weaver.hrm.*;
import weaver.file.FileUpload;
import weaver.systeminfo.*;
import weaver.mobile.webservices.workflow.*;

public class _createlist__jsp extends com.caucho.jsp.JavaPage
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
      weaver.mobile.webservices.workflow.WorkflowServiceImpl wsi;
      wsi = (weaver.mobile.webservices.workflow.WorkflowServiceImpl) pageContext.getAttribute("wsi");
      if (wsi == null) {
        wsi = new weaver.mobile.webservices.workflow.WorkflowServiceImpl();
        pageContext.setAttribute("wsi", wsi);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
FileUpload fu = new FileUpload(request);

String module = Util.null2String((String)fu.getParameter("module"));
String scope = Util.null2String((String)fu.getParameter("scope"));
String title = Util.null2String((String)fu.getParameter("title"));
String clienttype = Util.null2String((String)fu.getParameter("clienttype"));
String clientlevel = Util.null2String((String)fu.getParameter("clientlevel"));

//\u73b0\u5df2\u5c06\u63d0\u4ea4\u8bf7\u6c42\u65b9\u5f0f\u4fee\u6539\u4e3apost\uff0c\u6545\u4e0d\u9700\u8981\u89e3\u7801\u3002
String keyword = Util.null2String((String)fu.getParameter("keyword"));

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String logintype = user.getLogintype();     //\u5f53\u524d\u7528\u6237\u7c7b\u578b  1: \u7c7b\u522b\u7528\u6237  2:\u5916\u90e8\u7528\u6237
int usertype = 0;
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;

char flag=Util.getSeparator() ;

String[] conditions = new String[2];
conditions[0] = keyword;
conditions[1] = weaver.mobile.plugin.ecology.RequestOperation.AVAILABLE_WORKFLOW;

//20151201 \u591a\u8d26\u53f7\u5bf9\u5e94 Start
//WorkflowExtInfo[] wbis = wsi.getCreateWorkflowList(0, 99999999, 0, user.getUID(), 0, conditions);
String belongtoshow = user.getBelongtoshowByUserId(user.getUID());
WorkflowExtInfo[] wbis;
if("1".equals(belongtoshow)){
  wbis = wsi.getCreateWorkflowList(0, 99999999, 0, user.getUID(), 0, conditions,true);
}else{
  wbis = wsi.getCreateWorkflowList(0, 99999999, 0, user.getUID(), 0, conditions);
}

//20151201 \u591a\u8d26\u53f7\u5bf9\u5e94 End

      out.write(_jsp_string2, 0, _jsp_string2.length);
      if (clienttype.equals("Webclient")) {
      out.write(_jsp_string3, 0, _jsp_string3.length);
      } else {
      out.write(_jsp_string4, 0, _jsp_string4.length);
      }
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((module));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((scope));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((keyword));
      out.write(_jsp_string8, 0, _jsp_string8.length);
       
		String wtid = "";
		for(int i=0;wbis!=null&&i<wbis.length;i++) { 
			
			
      out.write(_jsp_string9, 0, _jsp_string9.length);
      
			if(!wbis[i].getWorkflowTypeId().equals(wtid)) {
			
      out.write(_jsp_string10, 0, _jsp_string10.length);
      out.print((wbis[i].getWorkflowTypeName() ));
      out.write(_jsp_string11, 0, _jsp_string11.length);
      
				wtid = wbis[i].getWorkflowTypeId();
			}
			
      out.write(_jsp_string12, 0, _jsp_string12.length);
      out.print((wbis[i].getWorkflowId()));
      out.write(_jsp_string13, 0, _jsp_string13.length);
      out.print((wbis[i].getF_weaver_belongto_userid()));
      out.write(_jsp_string14, 0, _jsp_string14.length);
      out.print((wbis[i].getF_weaver_belongto_usertype()));
      out.write(_jsp_string15, 0, _jsp_string15.length);
      out.print((wbis[i].getWorkflowId()));
      out.write(_jsp_string13, 0, _jsp_string13.length);
      out.print((wbis[i].getF_weaver_belongto_userid()));
      out.write(_jsp_string14, 0, _jsp_string14.length);
      out.print((wbis[i].getF_weaver_belongto_usertype()));
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((wbis[i].getWorkflowName() ));
      out.write(_jsp_string17, 0, _jsp_string17.length);
       if (wbis[i].getUserList() != null && wbis[i].getUserList().size() > 1){
                        int userCnt = 0;
                        StringBuffer userIds = new StringBuffer();
                        
                        while(userCnt < wbis[i].getUserList().size()){
                            if(userCnt > 0) userIds.append(",");
                            userIds.append(wbis[i].getUserList().get(userCnt).getUID());
                            userCnt++;
                        }
                    
      out.write(_jsp_string18, 0, _jsp_string18.length);
      out.print((wbis[i].getWorkflowId()));
      out.write(_jsp_string13, 0, _jsp_string13.length);
      out.print((userIds));
      out.write(_jsp_string14, 0, _jsp_string14.length);
      out.print((usertype));
      out.write(_jsp_string19, 0, _jsp_string19.length);
      }
      out.write(_jsp_string20, 0, _jsp_string20.length);
      
		}
		
      out.write(_jsp_string21, 0, _jsp_string21.length);
      out.print((module));
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((scope));
      out.write(_jsp_string23, 0, _jsp_string23.length);
      out.print((clienttype));
      out.write(_jsp_string24, 0, _jsp_string24.length);
      out.print((clientlevel));
      out.write(_jsp_string25, 0, _jsp_string25.length);
      out.print((module));
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((scope));
      out.write(_jsp_string23, 0, _jsp_string23.length);
      out.print((clienttype));
      out.write(_jsp_string24, 0, _jsp_string24.length);
      out.print((clientlevel));
      out.write(_jsp_string26, 0, _jsp_string26.length);
      out.print((user.getUID()));
      out.write(_jsp_string27, 0, _jsp_string27.length);
      out.print((module));
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((scope));
      out.write(_jsp_string23, 0, _jsp_string23.length);
      out.print((clienttype));
      out.write(_jsp_string24, 0, _jsp_string24.length);
      out.print((clientlevel));
      out.write(_jsp_string28, 0, _jsp_string28.length);
      out.print((module));
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((scope));
      out.write(_jsp_string29, 0, _jsp_string29.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("mobile/plugin/1/createlist.jsp"), -1525144076880526604L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string22;
  private final static char []_jsp_string8;
  private final static char []_jsp_string17;
  private final static char []_jsp_string9;
  private final static char []_jsp_string19;
  private final static char []_jsp_string21;
  private final static char []_jsp_string18;
  private final static char []_jsp_string29;
  private final static char []_jsp_string26;
  private final static char []_jsp_string11;
  private final static char []_jsp_string20;
  private final static char []_jsp_string7;
  private final static char []_jsp_string25;
  private final static char []_jsp_string5;
  private final static char []_jsp_string3;
  private final static char []_jsp_string10;
  private final static char []_jsp_string15;
  private final static char []_jsp_string27;
  private final static char []_jsp_string4;
  private final static char []_jsp_string23;
  private final static char []_jsp_string13;
  private final static char []_jsp_string12;
  private final static char []_jsp_string6;
  private final static char []_jsp_string28;
  private final static char []_jsp_string14;
  private final static char []_jsp_string0;
  private final static char []_jsp_string2;
  private final static char []_jsp_string24;
  private final static char []_jsp_string1;
  private final static char []_jsp_string16;
  static {
    _jsp_string22 = "&scope=".toCharArray();
    _jsp_string8 = "\"></td>\r\n				<td>&nbsp;</td>\r\n			</tr>\r\n		</table>\r\n	</div>\r\n\r\n	<div class=\"list\" id=\"list\">\r\n		".toCharArray();
    _jsp_string17 = "\r\n					</TD>\r\n					\r\n                    ".toCharArray();
    _jsp_string9 = "\r\n			".toCharArray();
    _jsp_string19 = "')\">\r\n                            <img class=\"pluralPostImg\" src=\"/mobile/plugin/images/changeAccount.png\">\r\n                        </a>\r\n                    </TD>\r\n                    ".toCharArray();
    _jsp_string21 = "\r\n	</div>\r\n        <div id=\"light\" class=\"white_content\">\r\n            <div id=\"light-top\">\r\n                \u9009\u62e9\u521b\u5efa\u8eab\u4efd\r\n            </div>\r\n            <div id=\"light-detail\">\r\n            </div>\r\n            \r\n            <div id=\"userSelectButton\">\r\n                <div id=\"cancelButton\">\u53d6\u6d88</div>\r\n                <div id=\"selectButton\">\u786e\u5b9a</div>\r\n            </div>\r\n        </div>\r\n        \r\n        <div id=\"fade\" class=\"black_overlay\">\r\n        </div>\r\n	</form>\r\n</div>\r\n\r\n<script type=\"text/javascript\">\r\nvar touchmoveflag = false;\r\n$(document).ready(function() {\r\n\r\n	$.ajaxSetup({ cache: false });\r\n\r\n	$('#keyword').keypress(function(e) {\r\n        if(e.which == 13) {\r\n            jQuery(this).blur();\r\n			$(\"#clform\").submit();\r\n        }\r\n    });\r\n    $(document).bind(\"touchmove\",function(){\r\n        touchmoveflag = true;\r\n    })\r\n    $(\".itemLeft\").add(\".itemRt\").bind(\"touchstart\",function(){\r\n        touchmoveflag = false;\r\n    });\r\n});\r\n\r\nfunction searchClick() {\r\n	$(\"#clform\").submit();\r\n}\r\n\r\nfunction goCreate(wid,belongUserId,belongUserType) {\r\n    if(touchmoveflag){\r\n        return false;\r\n    }\r\n	if(belongUserId != 'null' && belongUserId > 0){\r\n       location = \"/mobile/plugin/1/view.jsp?workflowid=\"+wid+\"&method=create&module=".toCharArray();
    _jsp_string18 = "\r\n                    <TD class=\"itemIcon\">\r\n                        <a href=\"javascript:(0);\" ontouchend =\"goChangeAccount(".toCharArray();
    _jsp_string29 = "\";\r\n}\r\n\r\n</script>\r\n\r\n</body>\r\n</html>".toCharArray();
    _jsp_string26 = "\";\r\n	}\r\n}\r\n\r\nfunction ajaxinit(){\r\n	var ajax=false;\r\n	try {\r\n	    ajax = new ActiveXObject(\"Msxml2.XMLHTTP\");\r\n	} catch (e) {\r\n	    try {\r\n	        ajax = new ActiveXObject(\"Microsoft.XMLHTTP\");\r\n	    } catch (E) {\r\n	        ajax = false;\r\n	    }\r\n	}\r\n	if (!ajax && typeof XMLHttpRequest!='undefined') {\r\n	    ajax = new XMLHttpRequest();\r\n	}\r\n	return ajax;\r\n}\r\nfunction goChangeAccount(wid,userIds,belongUserType){\r\n    var userId = '".toCharArray();
    _jsp_string11 = "\r\n					</TD>\r\n					<TD class=\"itemnavpoint\">\r\n						\r\n					</TD>\r\n				 </TR>\r\n			</TABLE>\r\n			</div>\r\n			".toCharArray();
    _jsp_string20 = "\r\n				 </TR>\r\n			</TABLE>\r\n			</div>\r\n			\r\n			<div class=\"blankLines\"></div>\r\n		".toCharArray();
    _jsp_string7 = "\">\r\n	\r\n	<div class=\"search\">\r\n		<div style=\"height:5px\"></div>\r\n		<table style=\"width:100%;height: 28px;\">\r\n			<tr>\r\n				<td>&nbsp;</td>\r\n				<td class=\"searchImg\" onclick=\"searchClick()\"><img src=\"/images/icon-search.png\"></td>\r\n				<td class=\"searchText\"><input type=\"text\" id=\"keyword\" name=\"keyword\" class=\"prompt\" style=\"border: none;width: 100%;height: 26px;\" value=\"".toCharArray();
    _jsp_string25 = "&f_weaver_belongto_userid=\" + belongUserId + \"&f_weaver_belongto_usertype=\" + belongUserType;\r\n	}else{\r\n       location = \"/mobile/plugin/1/view.jsp?workflowid=\"+wid+\"&method=create&module=".toCharArray();
    _jsp_string5 = "\">\r\n		<table style=\"width:100%;height:40px;font-size:13px;\">\r\n			<tr>\r\n				<td width=\"10%\" align=\"left\" valign=\"middle\" style=\"padding-left:5px;\">\r\n					<a href=\"javascript:goBack();\">\r\n						<div style=\"width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;\">\r\n						\u8fd4\u56de\r\n						</div>\r\n					</a>\r\n				</td>\r\n				<td align=\"center\" valign=\"middle\">\r\n					<div id=\"view_title\">\u9009\u62e9\u6d41\u7a0b</div>\r\n				</td>\r\n				<td width=\"10%\" align=\"right\" valign=\"middle\" style=\"padding-right:5px;\">\r\n				</td>\r\n			</tr>\r\n		</table>\r\n	</div>\r\n\r\n	<form id=\"clform\" action=\"/mobile/plugin/1/createlist.jsp\" method=\"post\">\r\n	\r\n	<input type=\"hidden\" name=\"module\" value=\"".toCharArray();
    _jsp_string3 = "display:block;".toCharArray();
    _jsp_string10 = "\r\n			<div class=\"listitem\">\r\n			<table width=\"100%\" height=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" style=\"table-layout:fixed;\">\r\n				<tr>\r\n					<TD class=\"itemNo\">\r\n						<img src=\"/mobile/plugin/1/images/itemnavimg_wev8.png\" width=\"10px\" height=\"10px\" style=\"margin-top:8px;\"> \r\n					</TD>\r\n					<TD class=\"itemcontent\" >\r\n						".toCharArray();
    _jsp_string15 = "')\">\r\n					\r\n					</TD>\r\n					<TD class=\"itemRt\" ontouchend=\"goCreate(".toCharArray();
    _jsp_string27 = "';\r\n    jQuery.ajax({\r\n         type: \"get\",\r\n         url: \"/mobile/plugin/1/changeAccountAjax.jsp\",\r\n         data: \"userIds=\"+userIds,\r\n         contentType : \"application/x-www-form-urlencoded; charset=UTF-8\",\r\n         cache: false,\r\n         async:false,\r\n         dataType: 'json',\r\n         success: function(data){\r\n            if(data.length > 0){\r\n                jQuery(\"body\").css({overflow:\"hidden\"}); \r\n                var tempbelongtype = \"\";\r\n                jQuery(\"#light-detail\").html(\"\");\r\n                for(var i = 0; i < data.length; i++){\r\n                    var item = data[i];\r\n                    var strHtml = \"\";\r\n                    var belongFlag = false;\r\n                    var belongtype = \"\";\r\n                    if(userId != item.id){\r\n                        belongFlag = true;\r\n                        belongtype = \"1\";\r\n                    }else{\r\n                        belongtype = \"0\";\r\n                    }\r\n                    if(!belongFlag){\r\n                        tempbelongtype = belongtype;\r\n                        continue;\r\n                    }else if(tempbelongtype != belongtype){\r\n                        strHtml += '<div class=\"subAccount\">\u6b21\u8d26\u53f7';\r\n                        strHtml += '</div>';\r\n                        jQuery(\"#light-detail\").append(jQuery(strHtml));\r\n                    }\r\n                    strHtml = \"\";\r\n                    strHtml += '<div _userid=\"' + item.id + '\" _wid=\"' + wid + '\" _belongUserType=\"' + belongUserType + '\" class=\"detailUser\" ontouchend=\"changeselected(this)\">';\r\n                    strHtml += item.departmentmark + ' / ' + item.jobtitlename;\r\n                    strHtml += '</div>';\r\n                    jQuery(\"#light-detail\").append(jQuery(strHtml));\r\n                    \r\n                    tempbelongtype = belongtype;\r\n                }\r\n                jQuery('#fade').show();\r\n                jQuery('#light').css(\"left\",parseInt(jQuery(\"body\").width()-jQuery('#light').width())/2 + \"px\");\r\n                jQuery('#light').css(\"top\",parseInt(jQuery(\"body\").height()-jQuery('#light').height())/2 + \"px\");\r\n	            jQuery('#light').show();\r\n            }\r\n         },\r\n         error:function(){\r\n            alert(\"error\");\r\n         }\r\n     });\r\n}\r\n\r\n//\u7981\u6b62\u6587\u5b57\u9009\u4e2d\r\ndocument.getElementById(\"light\").onselectstart = document.getElementById(\"light\").ondrag = function(){\r\n    return false;\r\n}\r\ndocument.getElementById(\"fade\").onselectstart = document.getElementById(\"fade\").ondrag = function(){\r\n    return false;\r\n}\r\nfunction changeselected(obj){\r\nif(touchmoveFlag){\r\n    return false;\r\n}\r\n    jQuery(obj).addClass(\"selectedUser\");\r\n    jQuery(\".selectedUser\").not(jQuery(obj)).each(function(){\r\n        jQuery(this).removeClass(\"selectedUser\");\r\n    });\r\n}\r\nvar touchmoveFlag = false;\r\njQuery(document).bind(\"touchmove\",function(){\r\n    touchmoveFlag = true;\r\n});\r\njQuery(document).bind(\"touchstart\",function(){\r\n    touchmoveFlag = false;\r\n});\r\njQuery(\"#selectButton\").bind(\"touchstart\",function(event){\r\n    jQuery(this).addClass(\"Button_hover\");\r\n    if(jQuery(\"#light-detail\").find(\".selectedUser\").length <= 0){\r\n        touchmoveFlag = true;\r\n        jQuery(this).removeClass(\"Button_hover\");\r\n        jQuery(this).blur();\r\n        event.stopPropagation();\r\n        alert(\"\u8bf7\u9009\u62e9\u5c97\u4f4d\");\r\n        return false;\r\n    }\r\n    jQuery(\"body\").css({overflow:\"auto\"}); \r\n    $selectedUser = jQuery(\"#light-detail\").find(\".selectedUser\")\r\n    var wid = $selectedUser.attr(\"_wid\");\r\n    var belongUserId = $selectedUser.attr(\"_userid\");\r\n    var belongUserType = $selectedUser.attr(\"_belongUserType\");\r\n    location = \"/mobile/plugin/1/view.jsp?workflowid=\"+wid+\"&method=create&module=".toCharArray();
    _jsp_string4 = "display:none;".toCharArray();
    _jsp_string23 = "&clienttype=".toCharArray();
    _jsp_string13 = ",'".toCharArray();
    _jsp_string12 = "\r\n			<div class=\"item\">\r\n			<table width=\"100%\" height=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" style=\"table-layout:fixed;\">\r\n				<tr>\r\n					<TD class=\"itemLeft\" ontouchend=\"goCreate(".toCharArray();
    _jsp_string6 = "\">\r\n	<input type=\"hidden\" name=\"scope\" value=\"".toCharArray();
    _jsp_string28 = "&f_weaver_belongto_userid=\" + belongUserId + \"&f_weaver_belongto_usertype=\" + belongUserType;\r\n    jQuery('#light').hide();\r\n    jQuery('#fade').hide();\r\n    jQuery(\"body\").css({overflow:\"auto\"}); \r\n    jQuery(this).removeClass(\"Button_hover\");\r\n});\r\nfunction selectButtonTouchend(obj){\r\n\r\n\r\n}\r\njQuery(\"#cancelButton\").bind(\"touchend\",function(){\r\nif(touchmoveFlag){\r\n    return false;\r\n}\r\n    jQuery(this).addClass(\"Button_hover\");\r\n    jQuery('#light').hide();\r\n    jQuery('#fade').hide();\r\n    jQuery(\"body\").css({overflow:\"auto\"}); \r\n    jQuery(\"#light-detail\").find(\".selectedUser\").each(function (){\r\n        $(this).removeClass(\"selectedUser\");\r\n    });\r\n    jQuery(this).removeClass(\"Button_hover\");\r\n});\r\n\r\n\r\n\r\nfunction goBack() {\r\n	location = \"/list.do?module=".toCharArray();
    _jsp_string14 = "','".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\r\n<!DOCTYPE html>\r\n<html>\r\n<head>\r\n	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />\r\n	<meta name=\"author\" content=\"Weaver E-Mobile Dev Group\" />\r\n	<meta name=\"description\" content=\"Weaver E-mobile\" />\r\n	<meta name=\"keywords\" content=\"weaver,e-mobile\" />\r\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0\" /> \r\n	<title></title>\r\n	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>\r\n	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery-ui_wev8.js'></script>\r\n	<link rel=\"stylesheet\" href=\"/mobile/plugin/css/cupertino/jquery-ui_wev8.css\" type=\"text/css\">\r\n	<link rel=\"stylesheet\" href=\"/mobile/plugin/css/mobile_wev8.css\" type=\"text/css\">\r\n	<style type=\"text/css\">\r\n	.search {\r\n		width: 100%;\r\n		height: 42px;\r\n		text-align: center;\r\n		position: relative;\r\n		background: #7F94AF;\r\n		background: -moz-linear-gradient(0, #A4B0C0, #7F94AF);\r\n		background: -webkit-gradient(linear, 0 0, 0 100%, from(#A4B0C0), to(#7F94AF) );\r\n		border-bottom: 1px solid #5D6875;\r\n	}\r\n	.searchImg {\r\n		width: 25px;\r\n		padding: 2px;\r\n		margin-left: auto;\r\n		margin-right: auto;\r\n		border-top: 1px solid #687D97;\r\n		border-right: 0;\r\n		border-bottom: 1px solid #687D97;\r\n		border-left: 1px solid #687D97;\r\n		background: #fff;\r\n		-moz-border-radius: 5px 0 0 5px;\r\n		-webkit-border-radius: 5px 0 0 5px;\r\n		border-radius: 5px 0 0 5px;\r\n		-webkit-box-shadow: inset 0px 1px 0px 0px #BCBFC3;\r\n		-moz-box-shadow: inset 0px 1px 0px 0px #BCBFC3;\r\n		box-shadow: inset 0px 1px 0px 0px #BCBFC3;\r\n	}\r\n	.searchText {\r\n		width: 100%;\r\n		margin-left: auto;\r\n		margin-right: auto;\r\n		border-top: 1px solid #687D97;\r\n		border-right: 1px solid #687D97;\r\n		border-bottom: 1px solid #687D97;\r\n		border-left: 0;\r\n		background: #fff;\r\n		overflow:hidden;\r\n		-moz-border-radius: 0 5px 5px 0;\r\n		-webkit-border-radius: 0 5px 5px 0;\r\n		border-radius: 0 5px 5px 0;\r\n		-webkit-box-shadow: inset 0px 1px 0px 0px #BCBFC3;\r\n		-moz-box-shadow: inset 0px 1px 0px 0px #BCBFC3;\r\n		box-shadow: inset 0px 1px 0px 0px #BCBFC3;\r\n	}\r\n	.prompt {\r\n		color: #777878;\r\n	}\r\n	.list {\r\n		width: 100%;\r\n		background: url(/images/bg_w_75_wev8.png);\r\n	}\r\n	.listitem {\r\n		width:100%;\r\n		height:46px;\r\n		background-color:#EFF2F6;\r\n		border-bottom:1px solid #D8DDE4;\r\n	}\r\n	.itemnavpoint {\r\n		height:100%;width:26px;text-align:center;\r\n	}\r\n	.itemnavpoint img {\r\n		width:10px;\r\n		heigth:14px;\r\n	}\r\n	.itemNo {\r\n		height:100%;width:30px;text-align:center;\r\n		font-size: 16px;\r\n		color: #444;\r\n		font-weight: bold;\r\n	}\r\n	.itemcontent {\r\n		width:*;\r\n		height:100%;\r\n		font-size: 16px;\r\n		color: #444;\r\n		font-weight: bold;\r\n		word-break:keep-all;\r\n		text-overflow:ellipsis;\r\n		white-space:nowrap;\r\n		overflow:hidden;\r\n	}\r\n	.item {\r\n		width:100%;\r\n		height:46px;\r\n		background-color:#fff;\r\n		border-bottom:1px solid #c6c6c6;\r\n	}\r\n	\r\n	.itemLeft {\r\n		height:100%;width:45px;text-align:right;color:#c6c6c6;\r\n	}\r\n	.itemRt {\r\n		width:*;height:100%;font-size: 14px;color: #123885;word-break:keep-all;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;\r\n	}\r\n    .itemIcon {\r\n        width:45px;height:100%;font-size: 14px;color: #123885;word-break:keep-all;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;\r\n    }\r\n    .pluralPostImg{\r\n        height:30px;\r\n        margin-top:5px;\r\n        margin-left:5px;\r\n    }\r\n    \r\n    .black_overlay{ \r\n        display: none; \r\n        position: fixed; \r\n        top: 0%; \r\n        left: 0%; \r\n        width: 100%; \r\n        height: 100%; \r\n        background-color: black; \r\n        z-index:1001; \r\n        -moz-opacity: 0.3; \r\n        opacity:.30; \r\n        filter: alpha(opacity=88); \r\n    } \r\n    .white_content { \r\n        display: none; \r\n        position: fixed; \r\n        top: 100px; \r\n        width: 280px;\r\n        height: auto; \r\n        border: 1px solid #ccc; \r\n        background-color: white; \r\n        z-index:1002; \r\n        overflow: none; \r\n    } \r\n    #light{\r\n        -webkit-touch-callout:none;\r\n		-webkit-user-select:none;\r\n		-khtml-user-select:none;\r\n		-moz-user-select:none;\r\n		-ms-user-select:none;\r\n		user-select:none;\r\n    }\r\n    #light-top{\r\n        color:rgb(0,170,255);\r\n        height:46px;\r\n        line-height:46px;\r\n        padding-left:15px;\r\n        border-bottom:2px solid rgb(12,177,253);\r\n        font-size:14px;\r\n        font-family:\"Microsoft YaHei\";\r\n    }\r\n    #light-detail div{\r\n        height:46px;\r\n        line-height:46px;\r\n        font-size:14px;\r\n        font-family:\"Microsoft YaHei\";\r\n    }\r\n    .mainAccount,.subAccount{\r\n        color:rgb(153,153,153);\r\n        padding-left:15px;\r\n        border-bottom:1px solid rgb(241,241,241);\r\n        background-color:rgb(247,247,247);\r\n    }\r\n    .detailUser{\r\n        color:rgb(51,51,51);\r\n        padding-left:25px;\r\n        border-bottom:1px solid rgb(241,241,241);\r\n        background-color:#fff;\r\n        cursor:pointer;\r\n        padding-right:25px;\r\n        text-overflow:ellipsis;\r\n        white-space:nowrap;\r\n        overflow:hidden;\r\n    }\r\n    .selectedUser{\r\n        color:rgb(0,153,255);\r\n        background-image:url('/mobile/plugin/images/selectedUserIcon.png');\r\n        backfround-color:#fff;\r\n		background-repeat:no-repeat;\r\n		background-position:center right;\r\n    }\r\n    .Button_hover{\r\n        background-color:#aaa !important;\r\n        color:#fff !important;\r\n    }\r\n    #selectButton,#cancelButton{\r\n        height:46px;\r\n        color:rgb(51,51,51);\r\n        line-height:46px;\r\n        font-size:14px;\r\n        width:139px;\r\n        font-family:\"Microsoft YaHei\";\r\n        cursor:pointer;\r\n        float:left;\r\n        text-align:center;\r\n        background-color:#fff;\r\n    }\r\n    #selectButton{\r\n        border-left:1px solid rgb(241,241,241);\r\n    }\r\n	</style>\r\n</head>\r\n<body>\r\n\r\n<div id=\"view_page\">\r\n\r\n	<div id=\"view_header\" style=\"".toCharArray();
    _jsp_string24 = "&clientlevel=".toCharArray();
    _jsp_string1 = "\r\n\r\n".toCharArray();
    _jsp_string16 = "')\">\r\n						".toCharArray();
  }
}
