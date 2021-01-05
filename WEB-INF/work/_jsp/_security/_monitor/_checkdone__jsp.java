/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._security._monitor;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import java.util.*;
import java.io.*;
import java.util.regex.*;
import java.util.concurrent.*;
import weaver.hrm.*;
import weaver.filter.SecurityCheckList;
import weaver.security.classLoader.ReflectMethodCall;

public class _checkdone__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
  	public List getFiles(String filepath){
  		List files = new Vector();
  		//System.out.println(TimeUtil.getCurrentTimeString()+":\u5f00\u59cb\u5f97\u5230\u9879\u76ee "+project+" \u6587\u4ef6\u5217\u8868...");
  		listFiles(files,filepath);
  		//System.out.println(TimeUtil.getCurrentTimeString()+":\u9879\u76ee "+project+" \u6587\u4ef6\u5217\u8868\u83b7\u53d6\u5b8c\u6210..."+files.size());
  		return files;
  	}
  
  	public void listFiles(List files,String dirName){
  		try{
  			File dirFile = new File(dirName);
  			 if(!dirFile.exists() || (!dirFile.isDirectory())){
  			 }else{
  				 File[] tmpfiles = dirFile.listFiles();
  				 for(int i=0;i<tmpfiles.length;i++){
  					 File f = tmpfiles[i];
  					 if(f.isFile()){
  
  						 if(f.getName().toLowerCase().endsWith(".jsp")){
  							files.add(f.getAbsolutePath().replaceAll("\\\\", "/"));
  						 }
  					 }else if(f.isDirectory()){
  						 listFiles(files,f.getAbsolutePath().replaceAll("\\\\", "/"));
  					 }
  				 }
  			 }
  		}catch(Exception e){}
  	}
  
  	public String checkCode(String code,int line){
  		if(code==null)return null;
  		Pattern p = null;
  		Matcher m = null;
  		p = Pattern.compile("GC\\(|connect\\(\\)",Pattern.CASE_INSENSITIVE);
  		m = p.matcher(code);
  		if(m.find()){
  			//new weaver.filter.XssUtil().writeLog(code+"======"+m.group(),true);
  			//\u627e\u5230\uff0c\u6709\u95ee\u9898\uff0c\u63a5\u4e0b\u6765\u68c0\u67e5\u662f\u5426\u662f\u4f8b\u5916
  				return "0";
  		}
  		return null;
  	}
  
  	public List checkFiles(List files){
  		String readline = "";
  		List resultList = new Vector();
  		int i=0;
  		weaver.filter.XssUtil xss = new weaver.filter.XssUtil();
  		for(int j=0;j<files.size();j++){
  			String file = ""+files.get(i);
  			i++;
  			//xss.writeLog(file,true);
  			if(i%50==0){
  				try{
  					xss.writeLog("\u5df2\u5b8c\u6210\uff1a"+(i*1.0/files.size()*100)+"%...",true);
  				}catch(Exception e){}
  				//System.out.println("\u5df2\u5b8c\u6210\uff1a"+(i*1.0/files.size()*100)+"%...");
  			}
  			
  			File f = new File(file);
  			if(!f.exists())continue;
  			if(f.getName().indexOf("MonitorMem.jsp")!=-1 
  				||f.getName().indexOf("MailAccountCheckInfoOperation.jsp")!=-1
  				||f.getName().indexOf("HrmSalaryOperation.jsp")!=-1
  				||f.getName().indexOf("HrmDataCollect.jsp")!=-1
  				||f.getName().indexOf("testsapcon.jsp")!=-1
  				||f.getName().indexOf("wmForWeb.jsp")!=-1
  				||f.getName().indexOf("messager.jsp")!=-1
  				||f.getName().indexOf("locationaddress.jsp")!=-1
  				||f.getName().indexOf("MailOperationGet.jsp")!=-1
  				||f.getName().indexOf("SocialIMClient.jsp")!=-1
  			)continue;
  			BufferedReader is = null;
  			boolean isComment = false;
  			try {
  				is = new BufferedReader(new InputStreamReader(new FileInputStream(f),"GBK"));
  				int lineno=0;
  				//System.out.println("\u6b63\u5728\u68c0\u67e5\u7b2c"+i+"\u4e2a\u6587\u4ef6\uff0c\u603b\u5171"+files.size()+"\u4e2a\u6587\u4ef6...");
  				long spaceCount = 0;
  				long totalCount = 0;
  				boolean inKeyword = false;
  				while ((readline = is.readLine()) != null)   {
  					//readline = readline.trim() ;
  					lineno++;
  					if(readline!=null){
  						//if(readline.indexOf("//")!=-1)continue;
  						//totalCount+=readline.length();
  						/*for(int c=0;c<readline.length();c++){
  							if(readline.charAt(c)==32){
  								spaceCount++;
  							}else if(readline.charAt(c)==9){
  								spaceCount+=4;
  							}
  						}*/
  						String res = checkCode(readline,lineno);
  						if(res==null){//\u6b63\u5e38
  						}else if(res.equals("0")){//\u975e\u4f8b\u5916
  							//resultList.add(f.getPath());
  							inKeyword = true;
  							break;
  						}
  					}
  				}
  				if(inKeyword){
  					resultList.add(f.getPath());
  				}
  			} catch (Exception e) {
  				// TODO Auto-generated catch block
  				e.printStackTrace();
  			} finally{
  				try{
  					is.close();
  				}catch(Exception e){}
  			}
  		}
  		return resultList;
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
    response.setContentType("text/html; charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.filter.XssUtil xssUtil;
      xssUtil = (weaver.filter.XssUtil) pageContext.getAttribute("xssUtil");
      if (xssUtil == null) {
        xssUtil = new weaver.filter.XssUtil();
        pageContext.setAttribute("xssUtil", xssUtil);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	

      out.write(_jsp_string2, 0, _jsp_string2.length);
      
	User user = HrmUserVarify.getUser (request , response) ;
	
	if(user==null){
		out.println("\u65e0\u6743\u9650\uff0c\u8bf7\u7528sysadmin\u767b\u5f55\u540e\u8bbf\u95ee\uff01");
		return;
	}

	if(!"sysadmin".equals(user.getLoginid())){
		out.println("\u65e0\u6743\u9650\uff0c\u8bf7\u7528sysadmin\u767b\u5f55\u540e\u8bbf\u95ee\uff01");
		return;
	}
	String operation = xssUtil.null2String(request.getParameter("operation"));
	boolean isCheckSecurity = operation.equals("checkSecurityList");
	
	SecurityCheckList scl = new SecurityCheckList();
	ReflectMethodCall rmc = new ReflectMethodCall();
	Boolean testServer = (Boolean)rmc.call("weaver.security.core.SecurityCheckList","testNetwork",
		            		new Class[]{},null);
	if(testServer==null)testServer=new Boolean(false);
	Boolean isMakeRandCode = new Boolean(false);
	if(isCheckSecurity){
		try{
			//scl.getNeedFixList().clear();
			((List)rmc.call("weaver.security.core.SecurityCheckList","getNeedFixList",new Class[]{},null)).clear();
		}catch(Exception e){}
		try{
			isMakeRandCode = (Boolean)rmc.call("weaver.security.core.SecurityCheckList","isMakeRandCode",new Class[]{},null);
			if(isMakeRandCode==null)isMakeRandCode=new Boolean(false);
		}catch(Exception e){}
	}
	Boolean isFixed = new Boolean(false);
	if("fixSecurityList".equals(operation)){
		//isFixed = scl.fixSecurityList();
		isFixed = ((Boolean)rmc.call("weaver.security.core.SecurityCheckList","fixSecurityList",new Class[]{},null));
		if(isFixed==null){
			isFixed = new Boolean(false);
		}
	}

      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((new Boolean(true).compareTo(isFixed)==0?"":"display:none;"));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      
			if("fixSecurityList".equals(operation)){
				if(isFixed.compareTo(new Boolean(true))==0){
					out.println("<div>\u5bfc\u51fa\u4fee\u590d\u5305\u6210\u529f\uff01<br/>\u8bf7\u6309\u7167\u4ee5\u4e0b\u6b65\u9aa4\u64cd\u4f5c\u4fee\u590d\uff1a</div>");
					out.println("<ul>");
					out.println("<li>");
					out.println("1\u3001\u8bf7\u5c06"+rmc.call("weaver.security.core.SecurityCheckList","getNewFilePath",new Class[]{},null)+"web.xml\u6587\u4ef6\u66ff\u6362\u5230"+request.getRealPath("/")+"WEB-INF"+File.separatorChar+"\u76ee\u5f55\u4e0b\uff08\u5982\u679c\u6587\u4ef6\u4e0d\u5b58\u5728\u5c31\u5ffd\u7565\u6b64\u6b65\u9aa4\uff09");
					out.println("</li>");
					out.println("<li>");
					out.println("2\u3001\u8bf7\u5c06"+rmc.call("weaver.security.core.SecurityCheckList","getNewFilePath",new Class[]{},null)+"resin.conf\u6587\u4ef6\u66ff\u6362\u5230"+System.getProperties().getProperty("resin.home")+File.separatorChar+"conf"+File.separatorChar+"\u76ee\u5f55\u4e0b\uff08\u5982\u679c\u6587\u4ef6\u4e0d\u5b58\u5728\u5c31\u5ffd\u7565\u6b64\u6b65\u9aa4\uff09");
					out.println("</li>");
					out.println("<li>");
					out.println("3\u3001\u8bf7\u91cd\u542fOA\u670d\u52a1");
					out.println("</li>");
					out.println("<li>");
					out.println("4\u3001\u5982\u679c\u670d\u52a1\u65e0\u6cd5\u6b63\u5e38\u542f\u52a8\uff0c\u8bf7\u5c06\u81ea\u52a8\u5907\u4efd\u7684\u6587\u4ef6\u8fd8\u539f\u5230\u5bf9\u5e94\u7684\u76ee\u5f55\u4e0b\uff0c\u518d\u6b21\u91cd\u542fOA\u670d\u52a1\u5373\u53ef\u3002");
					out.println("</li>");
					out.println("<li>");
					out.println("4.1\u3001\u81ea\u52a8\u5907\u4efd\u6587\u4ef6\u8def\u5f84\u5982\u4e0b<br/>resin.conf\u7684\u5907\u4efd\u6587\u4ef6\uff1a"+System.getProperties().getProperty("resin.home")+File.separatorChar+"conf"+File.separatorChar+"resin.conf."+xssUtil.getCurrentDateString().replaceAll("-","")+"<br/>web.xml\u7684\u5907\u4efd\u6587\u4ef6\uff1a"+request.getRealPath("/")+"WEB-INF"+File.separatorChar+"web.xml."+xssUtil.getCurrentDateString().replaceAll("-",""));
					out.println("</li>");
					out.println("</ul>");
				}else{
					out.println("\u5bfc\u51fa\u4fee\u590d\u5305\u5931\u8d25\uff01");
				}
			}
		
      out.write(_jsp_string5, 0, _jsp_string5.length);
      if(!"checkExceptionFile".equals(operation)&&!"showExceptionFile".equals(operation)){
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print(((!"checkExceptionFile".equals(operation)&&!"showExceptionFile".equals(operation))?"current":""));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((("checkExceptionFile".equals(operation)||"showExceptionFile".equals(operation))?"current":""));
      out.write(_jsp_string8, 0, _jsp_string8.length);
      if(!"checkExceptionFile".equals(operation)&&!"showExceptionFile".equals(operation)){
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((isCheckSecurity?"":"visibility:hidden;"));
      out.write(_jsp_string10, 0, _jsp_string10.length);
      }else{
      out.write(_jsp_string11, 0, _jsp_string11.length);
      }
      out.write(_jsp_string12, 0, _jsp_string12.length);
      }
      out.write(_jsp_string13, 0, _jsp_string13.length);
       int no = 1;
      out.write(_jsp_string13, 0, _jsp_string13.length);
      if(!"checkExceptionFile".equals(operation)&&!"showExceptionFile".equals(operation)){
      out.write(_jsp_string14, 0, _jsp_string14.length);
      out.print((no++));
      out.write(_jsp_string15, 0, _jsp_string15.length);
      out.print((isCheckSecurity?(scl.isConfigFirewall()?"<font style='color:#52be7f;font-weight:bold;'>\u6b63\u5e38</font>":"<font style='color:#e84c4c;font-weight:bold;'>\u5f02\u5e38</font>"):""));
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((no++));
      out.write(_jsp_string17, 0, _jsp_string17.length);
      out.print((isCheckSecurity?(scl.isEnableAccessLog()?"<font style='color:#52be7f;font-weight:bold;'>\u6b63\u5e38</font>":"<font style='color:#e84c4c;font-weight:bold;'>\u5f02\u5e38</font>"):""));
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((no++));
      out.write(_jsp_string18, 0, _jsp_string18.length);
      out.print((isCheckSecurity?(isMakeRandCode.compareTo(new Boolean(true))==0?"<font style='color:#52be7f;font-weight:bold;'>\u6b63\u5e38</font>":"<font style='color:#e84c4c;font-weight:bold;'>\u5f02\u5e38</font>"):""));
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((no++));
      out.write(_jsp_string19, 0, _jsp_string19.length);
      out.print((isCheckSecurity?(scl.checkSocketTimeout()?"<font style='color:#52be7f;font-weight:bold;'>\u6b63\u5e38</font>":"<font style='color:#e84c4c;font-weight:bold;'>\u5f02\u5e38</font>"):""));
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((no++));
      out.write(_jsp_string20, 0, _jsp_string20.length);
      out.print((isCheckSecurity?(scl.is404PageConfig()?"<font style='color:#52be7f;font-weight:bold;'>\u6b63\u5e38</font>":"<font style='color:#e84c4c;font-weight:bold;'>\u5f02\u5e38</font>"):""));
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((no++));
      out.write(_jsp_string21, 0, _jsp_string21.length);
      out.print((isCheckSecurity?(scl.is500PageConfig()?"<font style='color:#52be7f;font-weight:bold;'>\u6b63\u5e38</font>":"<font style='color:#e84c4c;font-weight:bold;'>\u5f02\u5e38</font>"):""));
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((no++));
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((isCheckSecurity?(scl.isDisabledHttpMethod()?"<font style='color:#52be7f;font-weight:bold;'>\u6b63\u5e38</font>":"<font style='color:#e84c4c;font-weight:bold;'>\u5f02\u5e38</font>"):""));
      out.write(_jsp_string23, 0, _jsp_string23.length);
      }else{
      out.write(_jsp_string24, 0, _jsp_string24.length);
      out.print((""+rmc.call("weaver.security.core.SecurityCore",xssUtil.getSecurityCore(),"uuid",
      		            		new Class[]{},null)));
      out.write(_jsp_string25, 0, _jsp_string25.length);
      out.print((xssUtil.getCompanyname()));
      out.write(_jsp_string26, 0, _jsp_string26.length);
      out.print((new Boolean(true).compareTo(testServer)==0?"<font style='color:green;'>\u53ef\u4ee5\u8054\u901a\u5916\u7f51</font>":"<font style='color:red;'>\u4e0d\u53ef\u4ee5\u8054\u901a\u5916\u7f51</font>"));
      out.write(_jsp_string27, 0, _jsp_string27.length);
      out.print(((xssUtil.enableFirewall() && xssUtil.isLoginCheck())?"#52be7f":"e84c4c"));
      out.write(_jsp_string28, 0, _jsp_string28.length);
      out.print(((xssUtil.enableFirewall() && xssUtil.isLoginCheck())?"\u5f00\u542f":"\u672a\u5f00\u542f"));
      out.write(_jsp_string29, 0, _jsp_string29.length);
      out.print(((xssUtil.enableFirewall() && !xssUtil.getIsSkipRule())?"#52be7f":"e84c4c"));
      out.write(_jsp_string30, 0, _jsp_string30.length);
      out.print((xssUtil.enableFirewall() && !xssUtil.getIsSkipRule()?"\u5f00\u542f":"\u672a\u5f00\u542f"));
      out.write(_jsp_string31, 0, _jsp_string31.length);
      out.print(((xssUtil.enableFirewall() && xssUtil.getMustXss())?"#52be7f":"e84c4c"));
      out.write(_jsp_string28, 0, _jsp_string28.length);
      out.print((xssUtil.enableFirewall() && xssUtil.getMustXss()?"\u5f00\u542f":"\u672a\u5f00\u542f"));
      out.write(_jsp_string32, 0, _jsp_string32.length);
      /*
						if("checkExceptionFile".equals(operation)){
							List exceptionFiles = checkFiles(getFiles(request.getRealPath("/")));
							for(int i=0;i<exceptionFiles.size();i++){
								out.println("<div style='padding-top:10px;'>"+exceptionFiles.get(i)+"</div>");
							}
						}*/
					
      out.write(_jsp_string33, 0, _jsp_string33.length);
      }
      out.write(_jsp_string34, 0, _jsp_string34.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("security/monitor/checkdone.jsp"), -3486576543272772536L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string13;
  private final static char []_jsp_string23;
  private final static char []_jsp_string22;
  private final static char []_jsp_string17;
  private final static char []_jsp_string6;
  private final static char []_jsp_string33;
  private final static char []_jsp_string29;
  private final static char []_jsp_string30;
  private final static char []_jsp_string14;
  private final static char []_jsp_string32;
  private final static char []_jsp_string18;
  private final static char []_jsp_string3;
  private final static char []_jsp_string21;
  private final static char []_jsp_string10;
  private final static char []_jsp_string31;
  private final static char []_jsp_string9;
  private final static char []_jsp_string27;
  private final static char []_jsp_string0;
  private final static char []_jsp_string15;
  private final static char []_jsp_string8;
  private final static char []_jsp_string7;
  private final static char []_jsp_string2;
  private final static char []_jsp_string5;
  private final static char []_jsp_string28;
  private final static char []_jsp_string16;
  private final static char []_jsp_string26;
  private final static char []_jsp_string12;
  private final static char []_jsp_string34;
  private final static char []_jsp_string1;
  private final static char []_jsp_string25;
  private final static char []_jsp_string4;
  private final static char []_jsp_string20;
  private final static char []_jsp_string24;
  private final static char []_jsp_string19;
  private final static char []_jsp_string11;
  static {
    _jsp_string13 = "\r\n	".toCharArray();
    _jsp_string23 = "</td>\r\n					</tr>\r\n				</tbody>\r\n			</table>\r\n		</div>\r\n	".toCharArray();
    _jsp_string22 = "</td>\r\n						<td>\u662f\u5426\u7981\u7528\u4e86\u4e0d\u4f7f\u7528\u7684http method</td>\r\n						<td>\u68c0\u67e5web.xml\u4e2d\u662f\u5426\u6b63\u786e\u914d\u7f6e\u4e86web-resource-collection\u548chttp-method</td>\r\n						<td>\r\n							\u5728web.xml\u7684&lt;web-app>\u4e0b\u65b9\u6dfb\u52a0\u5982\u4e0b\u4ee3\u7801\u5373\u53ef<br/>\r\n							<code><i><font color=\"red\">\r\n						  &lt;security-constraint><br/>     \r\n							 &lt;web-resource-collection><br/>       \r\n							 &lt;url-pattern>/*&lt;/url-pattern><br/>       \r\n							 &lt;http-method>PUT&lt;/http-method> <br/> \r\n							 &lt;http-method>DELETE&lt;/http-method><br/> \r\n							 &lt;http-method>OPTIONS&lt;/http-method> <br/> \r\n							 &lt;http-method>TRACE&lt;/http-method><br/>\r\n							 &lt;http-method>SEARCH&lt;/http-method>  <br/> \r\n							 &lt;http-method>PROPFIND&lt;/http-method> <br/> \r\n							 &lt;http-method>PROPPATCH&lt;/http-method>  <br/>\r\n							 &lt;http-method>PATCH&lt;/http-method> <br/> \r\n							 &lt;http-method>MKCOL&lt;/http-method>  <br/>\r\n							 &lt;http-method>COPY&lt;/http-method> <br/>\r\n							 &lt;http-method>MOVE&lt;/http-method> <br/> \r\n							 &lt;http-method>LOCK&lt;/http-method><br/>\r\n							 &lt;http-method>UNLOCK&lt;/http-method><br/>\r\n							 &lt;/web-resource-collection>     <br/>\r\n							 &lt;auth-constraint>    <br/> \r\n							 &lt;/auth-constraint> <br/>  \r\n						 &lt;/security-constraint><br/>\r\n						   </font></i></code>\r\n						   <br/>\r\n						   <b>\u4fee\u6539\u5b8c\u6210\u540e\u8bf7\u91cd\u542fOA\u670d\u52a1\u3002</b>\r\n						</td>\r\n						<td style=\"text-align:center;\">".toCharArray();
    _jsp_string17 = "</td>\r\n						<td>\u662f\u5426\u5f00\u542f\u4e86access\u8bbf\u95ee\u65e5\u5fd7</td>\r\n						<td>\u8bfb\u53d6resin.conf\u6587\u4ef6\uff0c\u68c0\u67e5\u662f\u5426\u914d\u7f6e\u4e86access log</td>\r\n						<td>\r\n							resin2\uff1a<br/>\r\n				  \u641c\u7d22ecology\u5173\u952e\u5b57\uff0c\u5728&lt;app-dir>\u4e0b\u9762\u6dfb\u52a0\u8bbf\u95ee\u65e5\u5fd7\uff0c\u5982\u4e0b\uff1a<br/>\r\n				 \r\n				   &lt;app-dir>F:\\workspace\\ecology7\\&lt;/app-dir><br/>\r\n					<code><i><font color=\"red\">\r\n						&lt;access-log id='log/access.log'><br/>\r\n						  <!--rotate log daily--><br/>\r\n						  &lt;rollover-period>1D&lt;/rollover-period><br/>\r\n						&lt;/access-log><br/>\r\n				  </font></i></code>\r\n				  resin3:<br/>\r\n				  \u641c\u7d22&lt;host-default>\u5173\u952e\u5b57\uff0c\u5728\u8be5\u8282\u70b9\u4e0b\u6dfb\u52a0\u8bbf\u95ee\u65e5\u5fd7\uff0c\u5982\u4e0b\uff1a<br/>\r\n				 \r\n				   &lt;host-default><br/>\r\n					<code><font color=\"red\">\r\n					  &lt;access-log path=\"logs/access.log\" \r\n					   archive-format=\"access-%Y%m%d.log.gz\" \r\n							format='%h %l %u %t \"%r\" %s %b \"%{Referer}i\" \"%{User-Agent}i\"'\r\n							rollover-period=\"1D\"><br/>\r\n						 &lt;exclude>\\.gif$&lt;/exclude><br/>\r\n					   &lt;exclude>\\.jpg$&lt;/exclude><br/>\r\n					   &lt;exclude>\\.png$&lt;/exclude><br/>\r\n					   &lt;exclude>\\.js$&lt;/exclude><br/>\r\n					   &lt;exclude>\\.css$&lt;/exclude><br/>\r\n					   &lt;exclude>\\.html$&lt;/exclude><br/>\r\n					   &lt;exclude>\\.htm$&lt;/exclude><br/>\r\n					   &lt;exclude>\\.swf$&lt;/exclude><br/>\r\n					   &lt;exclude>\\.cur$&lt;/exclude><br/>\r\n					&lt;/access-log>\r\n					</font></code>\r\n					<br/>\r\n						   <b>\u4fee\u6539\u5b8c\u6210\u540e\u8bf7\u91cd\u542fOA\u670d\u52a1\u3002</b>\r\n						</td>\r\n						<td style=\"text-align:center;\">".toCharArray();
    _jsp_string6 = "\r\n		<div style=\"background-color:#f0f3f4;height:54px;width:100%;border-bottom:#dcdcdc;line-height:54px;\">\r\n			<div style=\"margin-left:20px;float:left;\">\r\n				<!--<span id=\"securityBtn\" onclick=\"javascript:location.href='/security/monitor/checkdone.jsp'\" style=\"line-height:40px;\" class=\"normal ".toCharArray();
    _jsp_string33 = "&nbsp;\r\n				</span>\r\n			</div>-->\r\n		</div>\r\n	".toCharArray();
    _jsp_string29 = "</span>\r\n			</div>\r\n			<div style=\"border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:40px;line-height:40px;\">\r\n				<span style=\"display:inline-block;color:#384049;font-weight:bold;\">\u6570\u636e\u5e93\u4fdd\u62a4\uff1a</span>\r\n				<span style=\"display:inline-block;text-overflow:ellipsis;word-wrap:nowrap;color:".toCharArray();
    _jsp_string30 = ";margin-left:12px;\">".toCharArray();
    _jsp_string14 = "\r\n		<div style=\"max-height:600px;overflow:auto;\">\r\n			<table class=\"listTable\">\r\n				<colgroup>\r\n					<col width=\"60px\"/>\r\n					<col width=\"20%\"/>\r\n					<col width=\"30%\"/>\r\n					<col width=\"40%\"/>\r\n					<col width=\"5%\"/>\r\n				</colgroup>\r\n				<thead>\r\n					<th>\u5e8f\u53f7</th>\r\n					<th>\u68c0\u67e5\u9879</th>\r\n					<th>\u8bf4\u660e</th>\r\n					<th>\u4fee\u590d\u65b9\u5f0f</th>\r\n					<th>\u72b6\u6001</th>\r\n				</thead>\r\n				<tbody>\r\n					<tr>\r\n						<td style=\"text-align:center;\">".toCharArray();
    _jsp_string32 = "</span>\r\n			</div>\r\n			<!--<div style=\"border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:40px;line-height:40px;\">\r\n			<span style=\"display:inline-block;color:#384049;font-weight:bold;\">\u7591\u4f3c\u5f02\u5e38\u6587\u4ef6\u5217\u8868\uff1a</span>\r\n			</div>\r\n			<div style=\"margin-left:auto;margin-right:auto;max-width:800px;margin-bottom:30px;margin-top:16px;\">\r\n				\r\n				<span style=\"display:inline-block;color:e84c4c;margin-left:13px;\">\r\n					".toCharArray();
    _jsp_string18 = "</td>\r\n						<td>\u662f\u5426\u914d\u7f6e\u4e86\u751f\u6210\u9a8c\u8bc1\u7801\u7684servlet\uff0c\u5982\u679c\u6ca1\u914d\u7f6e\uff0c\u5219\u9700\u8981\u914d\u7f6e</td>\r\n						<td>\u8bfb\u53d6web.xml\u6587\u4ef6\uff0c\u68c0\u67e5web.xml\u4e2d\u662f\u5426\u914d\u7f6e\u4e86MakeRandCodeServlet</td>\r\n						<td>\r\n						\u5982\u679c\u6ca1\u6709\u914d\u7f6e\uff0c\u5219\u5728&lt;/web-app>\u4e0a\u65b9\u6dfb\u52a0\u4ee5\u4e0b\u4ee3\u7801\uff1a<br/>\r\n						<code><i><font color=\"red\">\r\n							 &lt;servlet><br/>\r\n								&lt;servlet-name>MakeRandCodeServlet&lt;/servlet-name><br/>\r\n								&lt;servlet-class>weaver.security.access.MakeRandCode&lt;/servlet-class><br/>\r\n							  &lt;/servlet><br/>\r\n							  &lt;servlet-mapping><br/>\r\n								&lt;servlet-name>MakeRandCodeServlet&lt;/servlet-name><br/>\r\n								&lt;url-pattern>/weaver/weaver.security.access.MakeRandCode&lt;/url-pattern><br/>\r\n							  &lt;/servlet-mapping><br/>\r\n						  </font></i></code>\r\n						  <br/>\r\n						   <b>\u4fee\u6539\u5b8c\u6210\u540e\u8bf7\u91cd\u542fOA\u670d\u52a1\u3002</b>\r\n						  </td>\r\n						<td style=\"text-align:center;\">".toCharArray();
    _jsp_string3 = "\r\n<div id=\"shadow\" style=\"".toCharArray();
    _jsp_string21 = "</td>\r\n						<td>\u662f\u5426\u914d\u7f6e\u4e86500\u9519\u8bef\u9875\u9762</td>\r\n						<td>\u68c0\u67e5\u5e94\u7528\u7cfb\u7edf\u662f\u5426\u6b63\u786e\u914d\u7f6e\u4e86500\u9519\u8bef\u9875\u9762</td>\r\n						<td>\r\n							\u5728web.xml\u7684&lt;/web-app>\u4e0a\u9762\u6dfb\u52a0\u5982\u4e0b\u4ee3\u7801\u5373\u53ef<br/>\r\n							<code><i><font color=\"red\">\r\n						  &lt;error-page><br/>\r\n							&lt;error-code>500&lt;/error-code><br/>\r\n							&lt;location>/security/error500.jsp&lt;/location><br/>\r\n						   &lt;/error-page><br/>\r\n						   </font></i></code>\r\n						   <br/>\r\n						   <b>\u4fee\u6539\u5b8c\u6210\u540e\u8bf7\u91cd\u542fOA\u670d\u52a1\u3002</b>\r\n						</td>\r\n						<td style=\"text-align:center;\">".toCharArray();
    _jsp_string10 = "cursor:pointer;margin-left:18px;display:inline-block;height:30px;line-height:30px;width:78px;color:white;background-color:#2c91e6;text-align:center;\">\u4fee\u590d</span>\r\n					<span name=\"checkSecurityListBtn\" id=\"checkSecurityListBtn\" onclick=\"checkSecurityList(this)\" style=\"cursor:pointer;display:inline-block;height:30px;line-height:30px;width:78px;color:white;background-color:#52be7f;text-align:center;margin-top:10px;\">\u68c0\u6d4b</span>\r\n				".toCharArray();
    _jsp_string31 = "</span>\r\n			</div>\r\n			<div style=\"border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:40px;line-height:40px;\">\r\n				<span style=\"display:inline-block;color:#384049;font-weight:bold;\">\u9875\u9762\u4fdd\u62a4\uff1a</span>\r\n				<span style=\"display:inline-block;color:".toCharArray();
    _jsp_string9 = "\r\n						<span name=\"fixBtn\" id=\"fixBtn\" onclick=\"fixDone(this)\" style=\"".toCharArray();
    _jsp_string27 = "</span>\r\n	</div>\r\n			<div style=\"border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:40px;line-height:40px;\">\r\n				<span style=\"display:inline-block;color:#384049;font-weight:bold;\">\u767b\u5f55\u4fdd\u62a4\uff1a</span>\r\n				<span style=\"display:inline-block;color:".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n".toCharArray();
    _jsp_string15 = "</td>\r\n						<td>\u662f\u5426\u6b63\u786e\u914d\u7f6e\u4e86\u5b89\u5168\u9632\u706b\u5899</td>\r\n						<td>\u68c0\u67e5WEB-INF/web.xml\u4e2d\u662f\u5426\u914d\u7f6e\u4e86SecurityFilter</td>\r\n						<td>\r\n							\u4fee\u6539WEB-INF/web.xml\u6587\u4ef6\uff0c\u6dfb\u52a0\u5982\u4e0b\u4ee3\u7801<br/>\r\n							<code><i><font color=\"red\">\r\n							&lt;filter><br/>\r\n								&lt;filter-name>SecurityFilter&lt;/filter-name><br/>\r\n								&lt;filter-class>weaver.filter.SecurityFilter&lt;/filter-class><br/>\r\n							&lt;/filter><br/>\r\n\r\n							&lt;filter-mapping><br/>\r\n								&lt;filter-name>SecurityFilter&lt;/filter-name><br/>\r\n								&lt;url-pattern>/*&lt;/url-pattern><br/>\r\n							&lt;/filter-mapping><br/>\r\n						   </font></i></code>\r\n						   <br/>\r\n						   <b>\u4fee\u6539\u5b8c\u6210\u540e\u8bf7\u91cd\u542fOA\u670d\u52a1\u3002</b>\r\n						</td>\r\n						<td style=\"text-align:center;\">".toCharArray();
    _jsp_string8 = "\">\r\n					<span>\u68c0\u67e5\u7cfb\u7edf\u5f02\u5e38\u6587\u4ef6</span>\r\n				</span>-->\r\n			</div>\r\n			<div style=\"float:right;margin-right:20px;\">\r\n				".toCharArray();
    _jsp_string7 = "\">\r\n					<span>\u68c0\u67e5\u7cfb\u7edf\u5b89\u5168\u914d\u7f6e\u9879</span>\r\n				</span>\r\n				<span id=\"fileBtn\" onclick=\"javascript:location.href='/security/monitor/checkdone.jsp?operation=showExceptionFile'\" style=\"margin-left:60px;\" class=\"normal ".toCharArray();
    _jsp_string2 = "\r\n<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\r\n<html>\r\n<head>\r\n<title>\u5b89\u5168\u4f53\u68c0</title>\r\n\r\n<style type=\"text/css\">\r\n	*{\r\n		font-family: \u5fae\u8f6f\u96c5\u9ed1; \r\n		mso-hansi-font-family: \u5fae\u8f6f\u96c5\u9ed1\r\n	}\r\n	.normal{\r\n		font-size:14px;\r\n		font-weight:bold;\r\n		color:#81878d;\r\n		display:inline-block;\r\n		padding-right:2px;\r\n		padding-left:2px;\r\n		text-align:center;\r\n		height:40px;\r\n		cursor:pointer;\r\n	}\r\n\r\n	.current{\r\n		color:#197be0;\r\n		border-bottom:2px solid #2887d7;\r\n	}\r\n\r\n	.listTable{\r\n		width:100%;\r\n		border:1px solid #dcdcdc;\r\n		border-collapse:collapse;\r\n	}\r\n	.listTable th{\r\n		height:40px;\r\n	}\r\n	.listTable th, .listTable td{\r\n		border:1px solid #dcdcdc;\r\n		font-size:12px;\r\n		color:#384049;\r\n	}\r\n	.listTable td{\r\n		padding-left:10px;\r\n	}\r\n</style>\r\n<script type=\"text/javascript\">\r\n	function checkDone(obj){\r\n		//obj.disabled = true;\r\n		document.getElementById(\"msg\").innerHTML=\"\u6b63\u5728\u6267\u884c\u5f02\u5e38\u6587\u4ef6\u68c0\u67e5...\";\r\n		document.getElementById(\"shadow\").style.display = \"block\";\r\n		//document.getElementById(\"checkSecurityListBtn\").disabled=true;\r\n		//document.getElementById(\"fixBtn\").disabled=true;\r\n		location.href=\"checkdone.jsp?operation=checkExceptionFile\";\r\n	}\r\n\r\n	function checkSecurityList(obj){\r\n		//obj.disabled = true;\r\n		document.getElementById(\"msg\").innerHTML=\"\u6b63\u5728\u6267\u884c\u5b89\u5168\u9879\u68c0\u67e5...\";\r\n		document.getElementById(\"shadow\").style.display = \"block\";\r\n		//document.getElementById(\"checkBtn\").disabled=true;\r\n		//document.getElementById(\"fixBtn\").disabled=true;\r\n		setTimeout(function(){\r\n			location.href=\"checkdone.jsp?operation=checkSecurityList\";\r\n		},1000);\r\n	}\r\n	\r\n	function fixDone(obj){\r\n		//obj.disabled = true;\r\n		document.getElementById(\"msg\").innerHTML=\"\u6b63\u5728\u6267\u884c\u5b89\u5168\u9879\u4fee\u590d...\";\r\n		document.getElementById(\"shadow\").style.display = \"block\";\r\n		//document.getElementById(\"checkBtn\").disabled=true;\r\n		//document.getElementById(\"checkSecurityListBtn\").disabled=true;\r\n		setTimeout(function(){\r\n			location.href=\"checkdone.jsp?operation=fixSecurityList\";\r\n		},1000);\r\n	}\r\n\r\n</script>\r\n</head>\r\n\r\n<body style=\"margin:0;\">\r\n\r\n".toCharArray();
    _jsp_string5 = "\r\n	</div>\r\n</div>\r\n<div style=\"margin-left:auto;margin-right:auto;width:80%;border:1px solid #dcdcdc;\">\r\n	".toCharArray();
    _jsp_string28 = ";margin-left:28px;\">".toCharArray();
    _jsp_string16 = "</td>\r\n					</tr>\r\n					<tr>\r\n						<td style=\"text-align:center;\">".toCharArray();
    _jsp_string26 = "</span>\r\n			</div>\r\n			<div style=\"border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:40px;line-height:40px;\">\r\n		<span style=\"display:inline-block;color:#384049;font-weight:bold;\">\u670d\u52a1\u5668\u5916\u7f51\uff1a</span>\r\n		<span style=\"display:inline-block;color:#384049;margin-left:14px;text-overflow:ellipsis;word-wrap:nowrap;\">".toCharArray();
    _jsp_string12 = "\r\n			</div>\r\n		   </div>\r\n		".toCharArray();
    _jsp_string34 = "\r\n	\r\n</div>\r\n</body>\r\n</html>\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string25 = "</span>\r\n			</div>\r\n			<div style=\"border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:40px;line-height:40px;\">\r\n				<span style=\"display:inline-block;color:#384049;font-weight:bold;\">\u516c\u53f8\u540d\u79f0\uff1a</span>\r\n				<span style=\"display:inline-block;color:#384049;margin-left:28px;text-overflow:ellipsis;word-wrap:nowrap;\">".toCharArray();
    _jsp_string4 = "background-color:#eaeaea;filter:alpha(opacity=70); -moz-opacity:0.7; opacity:0.7;position:absolute;width:100%;height:100%;text-align:center;line-height:100%;\">\r\n	<div id=\"msg\" style=\"margin-top:40px;width:180px;line-height:30px;height:30px;color:#0B84E0;font-size:14px;margin-right:auto;margin-left:auto;\"></div>\r\n</div>\r\n<div style=\"width:100%;height:74px;\">\r\n	<div style=\"width:100%;\">&nbsp;</div>\r\n	<div style=\"text-align:left;left:30px;color:red;position:absolute;\">\r\n		".toCharArray();
    _jsp_string20 = "</td>\r\n						<td>\u662f\u5426\u914d\u7f6e\u4e86404\u9519\u8bef\u9875\u9762</td>\r\n						<td>\u68c0\u67e5\u5e94\u7528\u7cfb\u7edf\u662f\u5426\u6b63\u786e\u914d\u7f6e\u4e86404\u9519\u8bef\u9875\u9762</td>\r\n						<td>\r\n							\u5728web.xml\u7684&lt;/web-app>\u4e0a\u9762\u6dfb\u52a0\u5982\u4e0b\u4ee3\u7801\u5373\u53ef<br/>\r\n							<code><i><font color=\"red\">\r\n						  &lt;error-page><br/>\r\n							&lt;error-code>404&lt;/error-code><br/>\r\n							&lt;location>/security/error404.jsp&lt;/location><br/>\r\n						   &lt;/error-page><br/>\r\n						   </font></i></code>\r\n						   <br/>\r\n						   <b>\u4fee\u6539\u5b8c\u6210\u540e\u8bf7\u91cd\u542fOA\u670d\u52a1\u3002</b>\r\n						</td>\r\n						<td style=\"text-align:center;\">".toCharArray();
    _jsp_string24 = "\r\n		<div style=\"max-height:600px;overflow:auto;margin-top:36px;\">\r\n			<div style=\"border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:40px;line-height:40px;\">\r\n				<span style=\"display:inline-block;color:#384049;font-weight:bold;\">\u7cfb\u7edf\u6807\u8bc6\uff1a</span>\r\n				<span style=\"display:inline-block;color:#384049;margin-left:28px;text-overflow:ellipsis;word-wrap:nowrap;\">".toCharArray();
    _jsp_string19 = "</td>\r\n						<td>socket\u8d85\u65f6\u65f6\u95f4\u662f\u5426\u4e0d\u5927\u4e8e10s</td>\r\n						<td>\u68c0\u6d4bsocket\u8fde\u63a5\u8d85\u65f6\u65f6\u95f4\uff0c\u7f13\u89e3http\u7f13\u6162\u653b\u51fb\u95ee\u9898</td>\r\n						<td>\u68c0\u67e5&lt;socket-timeout>\u548c&lt;keepalive-timeout>\u4e24\u4e2a\u8282\u70b9\u7684\u65f6\u95f4\uff0c\u4fee\u6539\u4e3a10s\u5373\u53ef<br/>\r\n						<code><i><font color=\"red\">\r\n							&lt;socket-timeout>10s&lt;/socket-timeout><br/>\r\n							&lt;keepalive-timeout>10s&lt;/keepalive-timeout>\r\n							</font></i></code>\r\n							<br/>\r\n						   <b>\u4fee\u6539\u5b8c\u6210\u540e\u8bf7\u91cd\u542fOA\u670d\u52a1\u3002</b>\r\n						</td>\r\n						<td style=\"text-align:center;\">".toCharArray();
    _jsp_string11 = "\r\n					<!--<span name=\"fixBtn\" id=\"fixBtn\" onclick=\"fixDone(this)\" style=\"visibility:hidden;cursor:default;margin-left:18px;display:inline-block;height:30px;line-height:30px;width:78px;color:white;background-color:#2c91e6;text-align:center;\">\u4fee\u590d</span>\r\n					<span name=\"checkBtn\" id=\"checkBtn\" onclick=\"checkDone(this)\" style=\"cursor:pointer;display:inline-block;height:30px;line-height:30px;width:78px;color:white;background-color:#52be7f;text-align:center;\">\u68c0\u6d4b</span>\r\n					-->\r\n				".toCharArray();
  }
}
