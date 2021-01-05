/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._hrm._resource;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.hrm.*;
import weaver.systeminfo.*;
import weaver.general.Util;
import weaver.conn.*;

public class _hrmrelatedcontract__jsp extends com.caucho.jsp.JavaPage
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
    weaver.template.tag.ViewTag _jsp_ViewTag_0 = null;
    weaver.template.tag.GroupTag _jsp_GroupTag_1 = null;
    weaver.template.tag.ItemTag _jsp_ItemTag_2 = null;
    weaver.template.tag.ItemTag _jsp_ItemTag_3 = null;
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.hrm.resource.ResourceComInfo ResourceComInfo;
      ResourceComInfo = (weaver.hrm.resource.ResourceComInfo) pageContext.getAttribute("ResourceComInfo");
      if (ResourceComInfo == null) {
        ResourceComInfo = new weaver.hrm.resource.ResourceComInfo();
        pageContext.setAttribute("ResourceComInfo", ResourceComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.contract.ContractTypeComInfo ContractTypeComInfo;
      ContractTypeComInfo = (weaver.hrm.contract.ContractTypeComInfo) pageContext.getAttribute("ContractTypeComInfo");
      if (ContractTypeComInfo == null) {
        ContractTypeComInfo = new weaver.hrm.contract.ContractTypeComInfo();
        pageContext.setAttribute("ContractTypeComInfo", ContractTypeComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String id = Util.null2String(request.getParameter("id"));
if("".equals(id)) return;

 int hrmid = user.getUID();
 boolean ism = ResourceComInfo.isManager(hrmid,id);

 int departmentid = user.getUserDepartment();
 /*
 boolean iss = ResourceComInfo.isSysInfoView(hrmid,id);
 boolean isf = ResourceComInfo.isFinInfoView(hrmid,id);
 boolean isc = ResourceComInfo.isCapInfoView(hrmid,id);
 boolean iscre = ResourceComInfo.isCreaterOfResource(hrmid,id);
 */
 boolean ishe = (hrmid == Util.getIntValue(id));
 boolean ishr = (HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid));



 if(!(ism || ishe || ishr)) return; //\u5982\u679c\u4e0d\u662f\u4e0a\u7ea7\uff0c\u6216\u672c\u4eba\uff0c\u6216\u4eba\u529b\u8d44\u6e90\u7ba1\u7406\u5458\u5c31\u4e0d\u80fd\u67e5\u770b\u5408\u540c\u4fe1\u606f

String sqlStr = "Select * From HrmContract WHERE ContractMan ="+id;
RecordSet rs = new RecordSet();
rs.executeSql(sqlStr);

      out.write(_jsp_string1, 0, _jsp_string1.length);
      com.caucho.jsp.BodyContentImpl _jsp_endTagHack0 = null;
      if (_jsp_ViewTag_0 == null) {
        _jsp_ViewTag_0 = new weaver.template.tag.ViewTag();
        _jsp_ViewTag_0.setPageContext(pageContext);
        _jsp_ViewTag_0.setParent((javax.servlet.jsp.tagext.Tag) null);
        _jsp_ViewTag_0.setType("table");
        _jsp_ViewTag_0.setNeedImportDefaultJsAndCss("false");
        _jsp_ViewTag_0.setAttributes("{'cols':'4','cws':'16%,16%,16%,52%'}");
      }

      int _jspEval2 = _jsp_ViewTag_0.doStartTag();
      if (_jspEval2 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
        if (_jspEval2 == javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_BUFFERED) {
          out = pageContext.pushBody();
          _jsp_endTagHack0 = (com.caucho.jsp.BodyContentImpl) out;
          _jsp_ViewTag_0.setBodyContent(_jsp_endTagHack0);
          _jsp_ViewTag_0.doInitBody();
        }
        do {
          out.write(_jsp_string1, 0, _jsp_string1.length);
          com.caucho.jsp.BodyContentImpl _jsp_endTagHack3 = null;
          if (_jsp_GroupTag_1 == null) {
            _jsp_GroupTag_1 = new weaver.template.tag.GroupTag();
            _jsp_GroupTag_1.setPageContext(pageContext);
            _jsp_GroupTag_1.setParent((javax.servlet.jsp.tagext.Tag) _jsp_ViewTag_0);
            _jsp_GroupTag_1.setContext("");
            _jsp_GroupTag_1.setAttributes("{'groupDisplay':'none'}");
          }

          int _jspEval5 = _jsp_GroupTag_1.doStartTag();
          if (_jspEval5 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
            if (_jspEval5 == javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_BUFFERED) {
              out = pageContext.pushBody();
              _jsp_endTagHack3 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_GroupTag_1.setBodyContent(_jsp_endTagHack3);
              _jsp_GroupTag_1.doInitBody();
            }
            do {
              out.write(_jsp_string3, 0, _jsp_string3.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack6 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
                _jsp_ItemTag_2.setType("thead");
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack6 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack6);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.print((SystemEnv.getHtmlLabelName(614,user.getLanguage())));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack6);
              out.write(_jsp_string3, 0, _jsp_string3.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack10 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
                _jsp_ItemTag_2.setType("thead");
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack10 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack10);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.print((SystemEnv.getHtmlLabelName(15775,user.getLanguage())));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack10);
              out.write(_jsp_string3, 0, _jsp_string3.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack14 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
                _jsp_ItemTag_2.setType("thead");
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack14 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack14);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.print((SystemEnv.getHtmlLabelName(1970,user.getLanguage())));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack14);
              out.write(_jsp_string3, 0, _jsp_string3.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack18 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
                _jsp_ItemTag_2.setType("thead");
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack18 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack18);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.print((SystemEnv.getHtmlLabelName(15236,user.getLanguage())));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack18);
              out.write(_jsp_string4, 0, _jsp_string4.length);
              while(rs.next()){
			  String contractid = Util.null2String(rs.getString("id"));
				String name  = Util.null2String(rs.getString("contractname"));
				String typeid  = Util.null2String(rs.getString("contracttypeid"));
				String typename = ContractTypeComInfo.getContractTypename(typeid);
				String man  = Util.null2String(rs.getString("contractman"));
				String startdate  = Util.null2String(rs.getString("contractstartdate"));
				String enddate  = Util.null2String(rs.getString("contractenddate"));
			  
              out.write(_jsp_string5, 0, _jsp_string5.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack22 = null;
              if (_jsp_ItemTag_3 == null) {
                _jsp_ItemTag_3 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_3.setPageContext(pageContext);
                _jsp_ItemTag_3.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_3.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack22 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_3.setBodyContent(_jsp_endTagHack22);
              _jsp_ItemTag_3.doInitBody();
              do {
                out.write(_jsp_string6, 0, _jsp_string6.length);
                out.print((contractid));
                out.write(_jsp_string7, 0, _jsp_string7.length);
                out.print((name));
                out.write(_jsp_string8, 0, _jsp_string8.length);
              } while (_jsp_ItemTag_3.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_3.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack22);
              out.write(_jsp_string9, 0, _jsp_string9.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack26 = null;
              if (_jsp_ItemTag_3 == null) {
                _jsp_ItemTag_3 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_3.setPageContext(pageContext);
                _jsp_ItemTag_3.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_3.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack26 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_3.setBodyContent(_jsp_endTagHack26);
              _jsp_ItemTag_3.doInitBody();
              do {
                out.print((typename));
              } while (_jsp_ItemTag_3.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_3.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack26);
              out.write(_jsp_string9, 0, _jsp_string9.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack30 = null;
              if (_jsp_ItemTag_3 == null) {
                _jsp_ItemTag_3 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_3.setPageContext(pageContext);
                _jsp_ItemTag_3.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_3.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack30 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_3.setBodyContent(_jsp_endTagHack30);
              _jsp_ItemTag_3.doInitBody();
              do {
                out.print((startdate));
              } while (_jsp_ItemTag_3.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_3.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack30);
              out.write(_jsp_string9, 0, _jsp_string9.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack34 = null;
              if (_jsp_ItemTag_3 == null) {
                _jsp_ItemTag_3 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_3.setPageContext(pageContext);
                _jsp_ItemTag_3.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_3.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack34 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_3.setBodyContent(_jsp_endTagHack34);
              _jsp_ItemTag_3.doInitBody();
              do {
                out.print((enddate));
              } while (_jsp_ItemTag_3.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_3.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack34);
              out.write(_jsp_string10, 0, _jsp_string10.length);
              }
              out.write(_jsp_string11, 0, _jsp_string11.length);
            } while (_jsp_GroupTag_1.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
            if (_jspEval5 == javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_BUFFERED)
              out = pageContext.popBody();
          }
          _jsp_GroupTag_1.doEndTag();
          if (_jsp_endTagHack3 != null) {
            pageContext.releaseBody(_jsp_endTagHack3);
            _jsp_endTagHack3 = null;
          }
          out.write(_jsp_string1, 0, _jsp_string1.length);
        } while (_jsp_ViewTag_0.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
        if (_jspEval2 == javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_BUFFERED)
          out = pageContext.popBody();
      }
      _jsp_ViewTag_0.doEndTag();
      if (_jsp_endTagHack0 != null) {
        pageContext.releaseBody(_jsp_endTagHack0);
        _jsp_endTagHack0 = null;
      }
    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      if (_jsp_ViewTag_0 != null)
        _jsp_ViewTag_0.release();
      if (_jsp_GroupTag_1 != null)
        _jsp_GroupTag_1.release();
      if (_jsp_ItemTag_2 != null)
        _jsp_ItemTag_2.release();
      if (_jsp_ItemTag_3 != null)
        _jsp_ItemTag_3.release();
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
    manager.addTaglibFunctions(_jsp_functionMap, "wea", "/WEB-INF/weaver.tld");
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("hrm/resource/HrmRelatedContract.jsp"), -5434526458836279122L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("WEB-INF/weaver.tld"), -8967885045122085173L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, new com.caucho.make.ClassDependency(weaver.template.tag.ItemTag.class, -5438589537409048615L));
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, new com.caucho.make.ClassDependency(weaver.template.tag.GroupTag.class, 8392293574246149627L));
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, new com.caucho.make.ClassDependency(weaver.template.tag.ViewTag.class, 2966152141547495543L));
  }

  static {
    try {
    } catch (Exception e) {
      e.printStackTrace();
      throw new RuntimeException(e);
    }
  }

  private final static char []_jsp_string11;
  private final static char []_jsp_string10;
  private final static char []_jsp_string9;
  private final static char []_jsp_string4;
  private final static char []_jsp_string8;
  private final static char []_jsp_string0;
  private final static char []_jsp_string6;
  private final static char []_jsp_string2;
  private final static char []_jsp_string7;
  private final static char []_jsp_string5;
  private final static char []_jsp_string3;
  private final static char []_jsp_string1;
  static {
    _jsp_string11 = "\r\n	".toCharArray();
    _jsp_string10 = "\r\n		  ".toCharArray();
    _jsp_string9 = "\r\n					".toCharArray();
    _jsp_string4 = " \r\n		  ".toCharArray();
    _jsp_string8 = "</a>".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string6 = "<a href=javascript:openFullWindowForXtable(\"/hrm/contract/contract/HrmContractView.jsp?id=".toCharArray();
    _jsp_string2 = "\r\n\r\n\r\n".toCharArray();
    _jsp_string7 = "\") target='_self'>".toCharArray();
    _jsp_string5 = "\r\n		  \r\n					".toCharArray();
    _jsp_string3 = "\r\n		".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}