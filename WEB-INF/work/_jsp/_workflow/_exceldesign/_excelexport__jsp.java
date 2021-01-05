/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._workflow._exceldesign;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import org.apache.commons.lang.StringUtils;
import java.net.URLEncoder;
import org.bouncycastle.crypto.BufferedBlockCipher;
import org.bouncycastle.crypto.paddings.PaddedBufferedBlockCipher;
import org.bouncycastle.crypto.modes.CBCBlockCipher;
import org.bouncycastle.crypto.engines.AESFastEngine;
import org.bouncycastle.crypto.params.ParametersWithIV;
import org.bouncycastle.util.encoders.Hex;
import org.bouncycastle.crypto.params.KeyParameter;

public class _excelexport__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
  static byte[] keybytes = "WEAVER E-DESIGN.".getBytes();
  static byte[] iv = "weaver e-design.".getBytes();
  
  /**
   * \u4e3a\u5b57\u7b26\u4e32\u52a0\u5bc6
   * 
   * @param content
   * @return
   */
  public String encode(String content) {
  	try {
  		BufferedBlockCipher engine = new PaddedBufferedBlockCipher(
  				new CBCBlockCipher(new AESFastEngine()));
  		engine.init(true, new ParametersWithIV(new KeyParameter(keybytes),
  				iv));
  		byte[] enc = new byte[engine
  				.getOutputSize(content.getBytes().length)];
  		int size1 = engine.processBytes(content.getBytes(), 0, content
  				.getBytes().length, enc, 0);
  		int size2 = engine.doFinal(enc, size1);
  		byte[] encryptedContent = new byte[size1 + size2];
  		System.arraycopy(enc, 0, encryptedContent, 0,
  				encryptedContent.length);
  		return new String(Hex.encode(encryptedContent));
  	} catch (Exception ex) {
  		ex.printStackTrace();
  	}
  	return "";
  }

  
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
    response.setContentType("application/x-download; charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.conn.RecordSet RecordSet;
      RecordSet = (weaver.conn.RecordSet) pageContext.getAttribute("RecordSet");
      if (RecordSet == null) {
        RecordSet = new weaver.conn.RecordSet();
        pageContext.setAttribute("RecordSet", RecordSet);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
	String nodeid = Util.null2String(request.getParameter("nodeid"));
	String nodetypesql = "select  b.workflowname,nb.nodename from workflow_nodebase nb,workflow_flownode fn,workflow_base b where b.id= fn.workflowid and nb.id = fn.nodeid and nb.id="+nodeid;
	RecordSet.executeSql(nodetypesql);
	String filename = "";
	if(RecordSet.first())
		filename = Util.null2String(RecordSet.getString("workflowname"))+"_"+Util.null2String(RecordSet.getString("nodename"))+".wef";
	response.setContentType("application/x-download;charset=UTF-8");
	final String userAgent = request.getHeader("USER-AGENT");
    try {
        String finalFileName = null;
        if(StringUtils.contains(userAgent, "MSIE")){//IE\u6d4f\u89c8\u5668
            finalFileName = URLEncoder.encode(filename,"UTF8");
        }else if(StringUtils.contains(userAgent, "Mozilla")){//google,\u706b\u72d0\u6d4f\u89c8\u5668
            finalFileName = new String(filename.getBytes(), "ISO8859-1");
        }else{
            finalFileName = URLEncoder.encode(filename,"UTF8");//\u5176\u4ed6\u6d4f\u89c8\u5668
        }
       
	 response.setHeader("Content-Disposition", "attachment; filename=\"" + finalFileName + "\"");//\u8fd9\u91cc\u8bbe\u7f6e\u4e00\u4e0b\u8ba9\u6d4f\u89c8\u5668\u5f39\u51fa\u4e0b\u8f7d\u63d0\u793a\u6846\uff0c\u800c\u4e0d\u662f\u76f4\u63a5\u5728\u6d4f\u89c8\u5668\u4e2d\u6253\u5f00
    } catch (Exception e) {
    }
	String jsonObj = Util.null2String(request.getParameter("exportJson"));	
	jsonObj = encode(jsonObj);
	out.clear();
	out.println(jsonObj);

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("workflow/exceldesign/excelExport.jsp"), -2757511939561810050L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n\r\n".toCharArray();
  }
}