/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._workflow._workflow;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.systeminfo.*;
import weaver.general.Util;
import weaver.hrm.*;
import java.util.*;

public class _choosedisplaypropiform__jsp extends com.caucho.jsp.JavaPage
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
      weaver.conn.RecordSet RecordSet;
      RecordSet = (weaver.conn.RecordSet) pageContext.getAttribute("RecordSet");
      if (RecordSet == null) {
        RecordSet = new weaver.conn.RecordSet();
        pageContext.setAttribute("RecordSet", RecordSet);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.workflow.workflow.WorkflowComInfo WorkflowComInfo;
      WorkflowComInfo = (weaver.workflow.workflow.WorkflowComInfo) pageContext.getAttribute("WorkflowComInfo");
      if (WorkflowComInfo == null) {
        WorkflowComInfo = new weaver.workflow.workflow.WorkflowComInfo();
        pageContext.setAttribute("WorkflowComInfo", WorkflowComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.docs.category.MainCategoryComInfo mainCategoryComInfo;
      mainCategoryComInfo = (weaver.docs.category.MainCategoryComInfo) pageContext.getAttribute("mainCategoryComInfo");
      if (mainCategoryComInfo == null) {
        mainCategoryComInfo = new weaver.docs.category.MainCategoryComInfo();
        pageContext.setAttribute("mainCategoryComInfo", mainCategoryComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.docs.category.SubCategoryComInfo subCategoryComInfo;
      subCategoryComInfo = (weaver.docs.category.SubCategoryComInfo) pageContext.getAttribute("subCategoryComInfo");
      if (subCategoryComInfo == null) {
        subCategoryComInfo = new weaver.docs.category.SubCategoryComInfo();
        pageContext.setAttribute("subCategoryComInfo", subCategoryComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.docs.category.SecCategoryComInfo secCategoryComInfo;
      secCategoryComInfo = (weaver.docs.category.SecCategoryComInfo) pageContext.getAttribute("secCategoryComInfo");
      if (secCategoryComInfo == null) {
        secCategoryComInfo = new weaver.docs.category.SecCategoryComInfo();
        pageContext.setAttribute("secCategoryComInfo", secCategoryComInfo);
      }
      out.write(_jsp_string3, 0, _jsp_string3.length);
      
        int fieldId = Util.getIntValue(request.getParameter("fieldId"),-1);
		int workflowId = Util.getIntValue(request.getParameter("wfid"),-1);
		User user = HrmUserVarify.getUser (request , response) ;
		String isIE = (String)session.getAttribute("browser_isie");
		if (isIE == null || "".equals(isIE)) {
			isIE = "true";
			session.setAttribute("browser_isie", "true");
		}
        String formID = WorkflowComInfo.getFormId(""+workflowId);
        String isbill = WorkflowComInfo.getIsBill(""+workflowId);
		if(!"1".equals(isbill)){
			RecordSet.executeSql("select formid,isbill from workflow_base where id="+workflowId);
			if(RecordSet.next()){
				formID = Util.null2String(RecordSet.getString("formid"));
				isbill = Util.null2String(RecordSet.getString("isbill"));
			}
		}
		
        Map docPropIdMap=new HashMap();
		String tempSelectItemId=null;
		String tempDocPropId=null;
		RecordSet.executeSql("SELECT id,selectItemId FROM Workflow_DocProp where workflowId="+workflowId);
		while(RecordSet.next()){
			tempSelectItemId=Util.null2String(RecordSet.getString("selectItemId"));
			tempDocPropId=Util.null2String(RecordSet.getString("id"));
			if(!(tempSelectItemId.trim().equals(""))){
				docPropIdMap.put(tempSelectItemId,tempDocPropId);
			}
		}
	
      out.write(_jsp_string4, 0, _jsp_string4.length);
      com.caucho.jsp.BodyContentImpl _jsp_endTagHack0 = null;
      if (_jsp_ViewTag_0 == null) {
        _jsp_ViewTag_0 = new weaver.template.tag.ViewTag();
        _jsp_ViewTag_0.setPageContext(pageContext);
        _jsp_ViewTag_0.setParent((javax.servlet.jsp.tagext.Tag) null);
        _jsp_ViewTag_0.setType("table");
        _jsp_ViewTag_0.setNeedImportDefaultJsAndCss("false");
        _jsp_ViewTag_0.setAttributes("{'cols':'3','cws':'20%,50%,30%'}");
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
          out.write(_jsp_string5, 0, _jsp_string5.length);
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
              out.write(_jsp_string6, 0, _jsp_string6.length);
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
                out.print((SystemEnv.getHtmlLabelNames("1025",user.getLanguage())));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack6);
              out.write(_jsp_string6, 0, _jsp_string6.length);
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
                out.print((SystemEnv.getHtmlLabelNames("19360",user.getLanguage())));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack10);
              out.write(_jsp_string6, 0, _jsp_string6.length);
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
                out.print((SystemEnv.getHtmlLabelNames("33197,30747",user.getLanguage())));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack14);
              out.write(_jsp_string6, 0, _jsp_string6.length);
              	
				RecordSet.executeSql("select ID,isAccordToSubCom, selectValue, selectName, docPath, docCategory from workflow_SelectItem where fieldid = " + fieldId + " and isBill = "+isbill+" and (cancel is null or cancel<>'1') order by listOrder asc ");
				 int i=0;
				 while(RecordSet.next()){
				 	String docCategory = Util.null2String(RecordSet.getString("docCategory"));
				 	String selectValue = RecordSet.getString("selectValue");
				 	String isAccordToSubCom = Util.null2String(RecordSet.getString("isAccordToSubCom"));
				 	String docPath = "";
				 	String innerMainCategory = "";
		            String innerSubCategory = "";            
		            String innerSecCategory = "";
				 	if(!docCategory.equals("")){
				 		List nameList = Util.TokenizerString(docCategory, ",");
            			try{
			            	innerMainCategory = (String)nameList.get(0);
			            	innerSubCategory = (String)nameList.get(1);            	
			                innerSecCategory = (String)nameList.get(2);
			                docPath = secCategoryComInfo.getAllParentName(innerSecCategory,true);
			                //docPath = "/" + mainCategoryComInfo.getMainCategoryname(innerMainCategory) + "/" + subCategoryComInfo.getSubCategoryname(innerSubCategory) + "/" + secCategoryComInfo.getSecCategoryname(innerSecCategory);
            			}catch(Exception e){
            				docPath = secCategoryComInfo.getAllParentName(docCategory,true);
            			}
				 	}
				 	int docPropId=Util.getIntValue((String)docPropIdMap.get(selectValue),-1);
				 	
			
              out.write(_jsp_string7, 0, _jsp_string7.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack18 = null;
              if (_jsp_ItemTag_3 == null) {
                _jsp_ItemTag_3 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_3.setPageContext(pageContext);
                _jsp_ItemTag_3.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_3.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack18 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_3.setBodyContent(_jsp_endTagHack18);
              _jsp_ItemTag_3.doInitBody();
              do {
                out.write(_jsp_string8, 0, _jsp_string8.length);
                out.print((Util.null2String(RecordSet.getString("selectName"))));
                out.write(_jsp_string7, 0, _jsp_string7.length);
              } while (_jsp_ItemTag_3.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_3.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack18);
              out.write(_jsp_string7, 0, _jsp_string7.length);
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
                out.write(_jsp_string8, 0, _jsp_string8.length);
                if("1".equals(isAccordToSubCom)){
                out.write(_jsp_string9, 0, _jsp_string9.length);
                out.print((workflowId));
                out.write(',');
                out.print((formID));
                out.write(',');
                out.print((isbill));
                out.write(',');
                out.print((fieldId));
                out.write(',');
                out.print((selectValue));
                out.write(_jsp_string10, 0, _jsp_string10.length);
                out.print((SystemEnv.getHtmlLabelName(22878,user.getLanguage())));
                out.write(_jsp_string11, 0, _jsp_string11.length);
                }else{ 
                out.write(_jsp_string12, 0, _jsp_string12.length);
                out.print(( docPath ));
                out.write(_jsp_string8, 0, _jsp_string8.length);
                } 
                out.write(_jsp_string7, 0, _jsp_string7.length);
              } while (_jsp_ItemTag_3.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_3.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack22);
              out.write(_jsp_string7, 0, _jsp_string7.length);
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
                out.write(_jsp_string8, 0, _jsp_string8.length);
                if(!"1".equals(isAccordToSubCom) && !"".equals(docPath) && null != docPath && !"".equals(docCategory) && null != docCategory){ 
                out.write(_jsp_string13, 0, _jsp_string13.length);
                out.print((docPropId));
                out.write(',');
                out.print((RecordSet.getString("id") ));
                out.write(',');
                out.print((RecordSet.getString("selectValue") ));
                out.write(',');
                out.print((innerSecCategory ));
                out.write(_jsp_string14, 0, _jsp_string14.length);
                out.print((docCategory ));
                out.write(_jsp_string15, 0, _jsp_string15.length);
                out.print((i ));
                out.write(_jsp_string16, 0, _jsp_string16.length);
                out.print((SystemEnv.getHtmlLabelNames("33197,30747",user.getLanguage())));
                out.write(_jsp_string17, 0, _jsp_string17.length);
                } 
                out.write(_jsp_string18, 0, _jsp_string18.length);
              } while (_jsp_ItemTag_3.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_3.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack26);
              out.write(_jsp_string6, 0, _jsp_string6.length);
              	 
					i++;	
				 }                    
		    
              out.write(_jsp_string5, 0, _jsp_string5.length);
            } while (_jsp_GroupTag_1.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
            if (_jspEval5 == javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_BUFFERED)
              out = pageContext.popBody();
          }
          _jsp_GroupTag_1.doEndTag();
          if (_jsp_endTagHack3 != null) {
            pageContext.releaseBody(_jsp_endTagHack3);
            _jsp_endTagHack3 = null;
          }
          out.write(_jsp_string4, 0, _jsp_string4.length);
        } while (_jsp_ViewTag_0.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
        if (_jspEval2 == javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_BUFFERED)
          out = pageContext.popBody();
      }
      _jsp_ViewTag_0.doEndTag();
      if (_jsp_endTagHack0 != null) {
        pageContext.releaseBody(_jsp_endTagHack0);
        _jsp_endTagHack0 = null;
      }
      out.write(_jsp_string19, 0, _jsp_string19.length);
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
    manager.addTaglibFunctions(_jsp_functionMap, "brow", "/browserTag");
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("workflow/workflow/chooseDisplayPropIForm.jsp"), -8366601191391803350L, false);
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

  private final static char []_jsp_string4;
  private final static char []_jsp_string11;
  private final static char []_jsp_string6;
  private final static char []_jsp_string10;
  private final static char []_jsp_string7;
  private final static char []_jsp_string12;
  private final static char []_jsp_string18;
  private final static char []_jsp_string19;
  private final static char []_jsp_string15;
  private final static char []_jsp_string13;
  private final static char []_jsp_string3;
  private final static char []_jsp_string16;
  private final static char []_jsp_string8;
  private final static char []_jsp_string14;
  private final static char []_jsp_string5;
  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  private final static char []_jsp_string9;
  private final static char []_jsp_string17;
  private final static char []_jsp_string2;
  static {
    _jsp_string4 = "\r\n	".toCharArray();
    _jsp_string11 = "</A>\r\n						".toCharArray();
    _jsp_string6 = "\r\n			".toCharArray();
    _jsp_string10 = ")\">".toCharArray();
    _jsp_string7 = "\r\n					".toCharArray();
    _jsp_string12 = "\r\n							".toCharArray();
    _jsp_string18 = "\r\n						\r\n					".toCharArray();
    _jsp_string19 = "\r\n	\r\n".toCharArray();
    _jsp_string15 = "',".toCharArray();
    _jsp_string13 = "\r\n							<a href=\"javascript:setPropMulti(".toCharArray();
    _jsp_string3 = "\r\n\r\n    ".toCharArray();
    _jsp_string16 = ");\">".toCharArray();
    _jsp_string8 = "\r\n						".toCharArray();
    _jsp_string14 = ",'".toCharArray();
    _jsp_string5 = "\r\n		".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string9 = "\r\n							<A HREF=\"#\"  onClick=\"onShowSubcompanyShowAttr(".toCharArray();
    _jsp_string17 = "</a>\r\n						".toCharArray();
    _jsp_string2 = "\r\n\r\n".toCharArray();
  }
}
