/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._workflow._workflow;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import java.util.*;
import weaver.systeminfo.SystemEnv;
import weaver.hrm.*;

public class _editoperatorgroupmatrixscript__jsp extends com.caucho.jsp.JavaPage
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
      
	User user = HrmUserVarify.getUser (request , response); 
	String wfid = Util.null2String(request.getParameter("wfid"));
	String formid = Util.null2String(request.getParameter("formid"));
	String isbill = Util.null2String(request.getParameter("isbill"));

      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((SystemEnv.getHtmlLabelName(129434, user.getLanguage())));
      out.write(_jsp_string2, 0, _jsp_string2.length);
      out.print((wfid));
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((formid));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((isbill));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((SystemEnv.getHtmlLabelName(129434, user.getLanguage())));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((wfid));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((formid));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((isbill));
      out.write(_jsp_string8, 0, _jsp_string8.length);
      out.print((SystemEnv.getHtmlLabelName(129418, user.getLanguage())));
      out.write(_jsp_string9, 0, _jsp_string9.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("workflow/workflow/editOperatorGroupMatrixScript.jsp"), 2726947455579469305L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string8;
  private final static char []_jsp_string7;
  private final static char []_jsp_string6;
  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  private final static char []_jsp_string3;
  private final static char []_jsp_string5;
  private final static char []_jsp_string2;
  private final static char []_jsp_string4;
  private final static char []_jsp_string9;
  static {
    _jsp_string8 = "&matrixvalue='+jQuery(ele).closest('tr').find('input[name^=group_][name$=_id]').val());\r\n	editDialog.Title = '".toCharArray();
    _jsp_string7 = "&formid=".toCharArray();
    _jsp_string6 = "');\r\n		return '';\r\n	}\r\n}\r\n\r\nfunction onShowEditMatrixDialog(ele) {\r\n	var editDialog = new top.Dialog();\r\n	editDialog.Width = 600;\r\n	editDialog.Height = 600;\r\n	editDialog.URL = '/systeminfo/BrowserMain.jsp?url=/workflow/workflow/editOperatorGroupMatrix.jsp'+escape('?isdialog=1&wfid=".toCharArray();
    _jsp_string0 = "\r\n \r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n<script language=javascript src=\"/js/ecology8/request/e8.browser_wev8.js\"></script>\r\n<script type=\"text/javascript\">\r\n//matrix start\r\nfunction selectAllMatrixRow(checked) {\r\n	changeCheckboxStatus('#matrixTable tr.data td input:checkbox', checked);\r\n}\r\n\r\nfunction changeSelectAllMatrixRowStatus(checked) {\r\n	changeCheckboxStatus('#matrixTable tr.header td input:checkbox', checked);\r\n}\r\n\r\nfunction checkMatrix() {\r\n	var indexinsert =0;\r\n	//var matrix = jQuery('#matrix').val();\r\n	//var vf = jQuery('#vf').val();\r\n	var matrix = jQuery('#matrixTmp').val();\r\n	var vf = jQuery('#matrixTmpfield').val();\r\n	// alert(\"-2-matrix--\"+cf);\r\n	 // alert(\"-2-vf--\"+cf);\r\n	if (vf == null || matrix == '' || vf == '') {\r\n		return false;\r\n	}\r\n	var ret = true;\r\n	var matrixTableRows = jQuery('#matrixTable tr.data');\r\n	/*matrixTableRows.each(function() {\r\n		var cf = jQuery('[id^=matrixCfield]').val();\r\n		var wf = jQuery('[id^=matrixRulefield]').val();\r\n		if (cf == '' || wf == '') {\r\n			ret = false;\r\n		}\r\n		if (cf == 0 || wf == null) {\r\n			ret = false;\r\n		}\r\n	});*/\r\n	var existsMatrixTableRows = false;\r\n	for(indexinsert=0;indexinsert<(matrixTableRows.length+10);indexinsert++){\r\n		//alert(\"-43--indexinsert-\"+indexinsert);\r\n	//alert(\"-44--matrixTableRows.length-\"+matrixTableRows.length);\r\n		// alert(\"-EEEEE--indexinsert->>\"+indexinsert\"---asadas---->>>\"+jQuery('#matrixCfield_'+indexinsert));\r\n		\r\n	  var cf = jQuery('#matrixCfield_'+indexinsert).val();\r\n	  var wf = jQuery('#matrixRulefield_'+indexinsert).val();\r\n	 if(typeof(cf) == \"undefined\" || typeof(wf) == \"undefined\") {\r\n		   	  continue;\r\n		   }\r\n		   existsMatrixTableRows = true;\r\n	 	if (cf == '' || wf == '') {\r\n			ret = false;\r\n		}\r\n		if (cf == 0 || wf == null || cf == null || wf == 0) {\r\n			//alert(\"-56--cf-\"+cf);\r\n		   //alert(\"-56--wf-\"+wf);\r\n			ret = false;\r\n		}\r\n	}\r\n	if(!existsMatrixTableRows){\r\n		ret = false;\r\n	}\r\n	  \r\n	return ret;\r\n}\r\n\r\nfunction getMatrixBrowserUrl(fieldtype) {\r\n	var matrix = jQuery('#matrix').val();\r\n	if (matrix) {\r\n		return '/systeminfo/BrowserMain.jsp?url=/matrixmanage/pages/matrixfieldbrowser.jsp?matrixid=' + matrix + '&fieldtype=' + fieldtype;\r\n	} else {\r\n		Dialog.alert('".toCharArray();
    _jsp_string3 = "\",\r\n	   getBrowserUrlFn: \"getFieldUrl\"\r\n	});\r\n	changeSelectAllMatrixRowStatus(false);\r\n}\r\n\r\n\r\n\r\nfunction removeMatrixRow() {\r\n	jQuery('#matrixTable tr.data input:checked').closest('tr.data').each(function() {\r\n		jQuery(this).next('.Spacing').remove();\r\n		jQuery(this).remove();\r\n	});\r\n	changeSelectAllMatrixRowStatus(false);\r\n}\r\n\r\n/*function getMatrixValue() {\r\n	var matrixTableRows = jQuery('#matrixTable tr.data');\r\n	//\u53bb\u9664\u91cd\u590d\u503c\r\n\r\n	var matrixTableValueObj = {};\r\n	matrixTableRows.each(function() {\r\n		var cf = jQuery(this).find('input[name=\"cf\"]').val();\r\n		var wf = jQuery(this).find('input[name=\"wf\"]').val();\r\n		matrixTableValueObj[cf] = wf;\r\n	});\r\n	var matrix = jQuery('#matrix').val();\r\n	var vf = jQuery('#vf').val();\r\n	var matrixTableValue = matrix + ',' + vf;\r\n	for (var p in matrixTableValueObj) {\r\n		matrixTableValue += ',' + p + ':' + matrixTableValueObj[p];\r\n	}\r\n	return matrixTableValue;\r\n}*/\r\n\r\n\r\nfunction getMatrixValue() {\r\n	var matrixTableRows = jQuery('#matrixTable tr.data');\r\n	var indexinsert =0;\r\n	//\u53bb\u9664\u91cd\u590d\u503c\r\n\r\n	var matrixTableValueObj = {};\r\n	/*matrixTableRows.each(function() {\r\n		//var cf = jQuery(this).find('input[name=\"cf\"]').val();\r\n		//var wf = jQuery(this).find('input[name=\"wf\"]').val();\r\n		var cf = jQuery('#matrixCfield').val();\r\n		var wf = jQuery('#matrixRulefield').val();\r\n		matrixTableValueObj[cf] = wf;\r\n	});*/\r\n	for(indexinsert=0;indexinsert<(matrixTableRows.length+10);indexinsert++){\r\n		// alert(\"-EEEEE--indexinsert->>\"+indexinsert\"-------->>>\"+jQuery('#matrixCfield_'+indexinsert));\r\n		\r\n	  var cf = jQuery('#matrixCfield_'+indexinsert).val();\r\n	  var wf = jQuery('#matrixRulefield_'+indexinsert).val();\r\n		    if(typeof(cf) == \"undefined\" || typeof(wf) == \"undefined\") {\r\n		   	  continue;\r\n		   }\r\n	  matrixTableValueObj[cf] = wf;\r\n	}\r\n\r\n	var matrix = jQuery('#matrix').val();\r\n	//var vf = jQuery('#vf').val();\r\n	var vf = 	 jQuery('#matrixTmpfield').val();\r\n	var matrixTableValue = matrix + ',' + vf;\r\n	for (var p in matrixTableValueObj) {\r\n		matrixTableValue += ',' + p + ':' + matrixTableValueObj[p];\r\n	}\r\n	return matrixTableValue;\r\n}\r\n\r\nfunction getFieldUrl() {\r\n	return \"/systeminfo/BrowserMain.jsp?url=/workflow/ruleDesign/showFieldBrowser.jsp?formid=".toCharArray();
    _jsp_string5 = "\";\r\n}\r\n\r\nfunction getMatrixDisplayName() {\r\n	var matrixDisplayName = jQuery(\"#matrixTmp\").find(\"option:selected\").text()	;\r\n	var vfDisplayName = jQuery(\"#matrixTmpfield\").find(\"option:selected\").text();\r\n	return getEditMatrixDialogLink(matrixDisplayName+'('+vfDisplayName+')');\r\n}\r\n\r\nfunction getEditMatrixDialogLink(matrixDisplayName) {\r\n	return '<a href=\"javascript:void(0);\" onclick=\"onShowEditMatrixDialog(this);\">'+matrixDisplayName+'</a>';\r\n}\r\n\r\nfunction matrixChanged() {\r\n	_writeBackData('vf', 1, {id:'',name:''});\r\n	jQuery('#matrixTable tr.data #cf').val('');\r\n	jQuery('#matrixTable tr.data #cfspan').html('');\r\n}\r\n\r\nfunction getMatrixDataUrl(fieldtype) {\r\n	var matrix = jQuery('#matrix').val();\r\n	if (matrix) {\r\n		return '/data.jsp?type=matrixfield&matrixid=' + matrix + '&fieldtype=' + fieldtype;\r\n	} else {\r\n		Dialog.alert('".toCharArray();
    _jsp_string2 = "');\r\n		return '';\r\n	}\r\n}\r\n\r\nfunction addMatrixRow() {\r\n	var lastRow = jQuery('<tr class=\"data\"><td style=\"padding-left: 30px !important;\"><input type=\"checkbox\" /></td><td><div class=\"cf\"><span></span></div></td><td><div class=\"wf\"><span></span></div></td><td></td></tr>');\r\n	var lineRow = jQuery('<tr class=\"Spacing\" style=\"height:1px!important;display:;\"><td class=\"paddingLeft0\" colspan=\"4\"><div class=\"intervalDivClass\"></div></td></tr>');\r\n	var matrixTable = jQuery('#matrixTable');\r\n	matrixTable.append(lastRow);\r\n	matrixTable.append(lineRow);\r\n	lastRow.jNice();\r\n	lastRow.find('div.cf span').e8Browser({\r\n	   name: 'cf',\r\n	   viewType:\"0\",\r\n	   hasInput:true,\r\n	   isSingle:true,\r\n	   hasBrowser:true, \r\n	   isMustInput:1,\r\n	   completeUrl:\"javascript:getMatrixDataUrl(0);\",\r\n	   getBrowserUrlFn: \"getMatrixBrowserUrl\",\r\n	   getBrowserUrlFnParams: \"0\"\r\n	});\r\n	lastRow.find('div.wf span').e8Browser({\r\n	   name: 'wf',\r\n	   viewType:\"0\",\r\n	   hasInput:true,\r\n	   isSingle:true,\r\n	   hasBrowser:true, \r\n	   isMustInput:1,\r\n	   completeUrl:\"/data.jsp?type=fieldBrowser&wfid=".toCharArray();
    _jsp_string4 = "&isbill=".toCharArray();
    _jsp_string9 = "';\r\n	editDialog.checkDataChange = false;\r\n	editDialog.callback = function(data) {\r\n		editDialog.close();\r\n		var retValue = data;\r\n		if (retValue != null) {\r\n			if (wuiUtil.getJsonValueByIndex(retValue, 0) != \"\") {\r\n				jQuery(ele).closest('tr	').find('input[name^=group_][name$=_id]').val(wuiUtil.getJsonValueByIndex(retValue, 0));\r\n				jQuery(ele).text(wuiUtil.getJsonValueByIndex(retValue, 1));\r\n			} \r\n		}\r\n	};\r\n	editDialog.show();\r\n}\r\n//matrix end\r\n</script>".toCharArray();
  }
}