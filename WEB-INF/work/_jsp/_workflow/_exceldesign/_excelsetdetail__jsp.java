/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._workflow._exceldesign;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import weaver.hrm.*;
import weaver.systeminfo.SystemEnv;

public class _excelsetdetail__jsp extends com.caucho.jsp.JavaPage
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
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      
	User user = HrmUserVarify.getUser (request , response) ;
	int d_identy = Util.getIntValue(Util.null2String(request.getParameter("d_identy")));
	int layouttype = Util.getIntValue(request.getParameter("layouttype"), -1);
	int nodetype = Util.getIntValue(request.getParameter("nodetype"),0);
	int languageid = Util.getIntValue(request.getParameter("languageid"),7);
	String detaillimit = Util.null2String(request.getParameter("detaillimit"));
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
	String detailname=SystemEnv.getHtmlLabelName(19325, user.getLanguage())+d_identy;
	
	String dtladd = "1".equals(detaillimit.substring(0,1))?" checked":"";
	String dtledit = "1".equals(detaillimit.substring(1,2))?" checked":"";
	String dtldel = "1".equals(detaillimit.substring(2,3))?" checked":"";
	String dtlhide = "1".equals(detaillimit.substring(3,4))?" checked":"";
	String dtldef = "1".equals(detaillimit.substring(4,5))?" checked":"";
	String dtlned = "1".equals(detaillimit.substring(5,6))?" checked":"";
	String dtlmul = "1".equals(detaillimit.substring(6,7))?" checked":"";
	String dtlprintserial = "1".equals(detaillimit.substring(7,8))?" checked":"";
	String dtlallowscroll = "1".equals(detaillimit.substring(8,9))?" checked":"";
	int dtl_defrow=0;
	if(detaillimit.indexOf("*")>-1){
		String _temp=detaillimit.substring(detaillimit.indexOf("*")+1);
		dtl_defrow = Util.getIntValue(_temp,0);
	}
	if(dtl_defrow<1)	dtl_defrow=1;

      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((d_identy ));
      out.write(_jsp_string2, 0, _jsp_string2.length);
      out.print((formid));
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((isbill));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((d_identy ));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((d_identy ));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((SystemEnv.getHtmlLabelName(176, user.getLanguage())));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((SystemEnv.getHtmlLabelName(261, user.getLanguage())));
      out.write(_jsp_string8, 0, _jsp_string8.length);
      out.print((SystemEnv.getHtmlLabelName(20246,user.getLanguage())));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((SystemEnv.getHtmlLabelName(20247,user.getLanguage())));
      out.write(_jsp_string10, 0, _jsp_string10.length);
      out.print((SystemEnv.getHtmlLabelName(20246,user.getLanguage())));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((SystemEnv.getHtmlLabelName(20247,user.getLanguage())));
      out.write(_jsp_string11, 0, _jsp_string11.length);
      out.print((SystemEnv.getHtmlLabelName(20246,user.getLanguage())));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((SystemEnv.getHtmlLabelName(20247,user.getLanguage())));
      out.write(_jsp_string12, 0, _jsp_string12.length);
      out.print((SystemEnv.getHtmlLabelName(826, user.getLanguage())));
      out.write(_jsp_string13, 0, _jsp_string13.length);
      out.print((SystemEnv.getHtmlLabelName(201, user.getLanguage())));
      out.write(_jsp_string14, 0, _jsp_string14.length);
      com.caucho.jsp.BodyContentImpl _jsp_endTagHack0 = null;
      if (_jsp_ViewTag_0 == null) {
        _jsp_ViewTag_0 = new weaver.template.tag.ViewTag();
        _jsp_ViewTag_0.setPageContext(pageContext);
        _jsp_ViewTag_0.setParent((javax.servlet.jsp.tagext.Tag) null);
        _jsp_ViewTag_0.setType("twoCol");
        _jsp_ViewTag_0.setAttributes("{'cw1':'60%','cw2':'40%'}");
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
          out.write(_jsp_string15, 0, _jsp_string15.length);
          if(layouttype==0){ 
          out.write(_jsp_string16, 0, _jsp_string16.length);
          com.caucho.jsp.BodyContentImpl _jsp_endTagHack3 = null;
          if (_jsp_GroupTag_1 == null) {
            _jsp_GroupTag_1 = new weaver.template.tag.GroupTag();
            _jsp_GroupTag_1.setPageContext(pageContext);
            _jsp_GroupTag_1.setParent((javax.servlet.jsp.tagext.Tag) _jsp_ViewTag_0);
          }

          _jsp_GroupTag_1.setContext(detailname );
          int _jspEval5 = _jsp_GroupTag_1.doStartTag();
          if (_jspEval5 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
            if (_jspEval5 == javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_BUFFERED) {
              out = pageContext.pushBody();
              _jsp_endTagHack3 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_GroupTag_1.setBodyContent(_jsp_endTagHack3);
              _jsp_GroupTag_1.doInitBody();
            }
            do {
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack6 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack6 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack6);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.print((SystemEnv.getHtmlLabelName(19394,languageid)));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack6);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack10 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack10 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack10);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.write(_jsp_string18, 0, _jsp_string18.length);
                out.print((dtladd ));
                out.write(' ');
                out.print((nodetype==3?"disabled":"" ));
                out.write(_jsp_string19, 0, _jsp_string19.length);
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack10);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack14 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack14 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack14);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.print((SystemEnv.getHtmlLabelName(19395,languageid)));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack14);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack18 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack18 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack18);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.write(_jsp_string20, 0, _jsp_string20.length);
                out.print((dtledit ));
                out.write(' ');
                out.print((nodetype==3?"disabled":"" ));
                out.write(_jsp_string21, 0, _jsp_string21.length);
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack18);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack22 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack22 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack22);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.print((SystemEnv.getHtmlLabelName(19396,languageid)));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack22);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack26 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack26 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack26);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.write(_jsp_string22, 0, _jsp_string22.length);
                out.print((dtldel ));
                out.write(' ');
                out.print((nodetype==3?"disabled":"" ));
                out.write(_jsp_string23, 0, _jsp_string23.length);
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack26);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              if(nodetype!=3){	
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack30 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack30 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack30);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.print((SystemEnv.getHtmlLabelName(24801,languageid)));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack30);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack34 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack34 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack34);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.write(_jsp_string24, 0, _jsp_string24.length);
                out.print((dtlned ));
                out.write(' ');
                out.print((dtladd.equals(" checked")?"":"disabled" ));
                out.write(_jsp_string23, 0, _jsp_string23.length);
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack34);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack38 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack38 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack38);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.print((SystemEnv.getHtmlLabelName(24796,languageid)));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack38);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack42 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack42 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack42);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.write(_jsp_string25, 0, _jsp_string25.length);
                out.print((dtldef ));
                out.write(' ');
                out.print((dtladd.equals(" checked")?"":"disabled" ));
                out.write(_jsp_string26, 0, _jsp_string26.length);
                out.print((dtladd.equals(" checked")&&dtldef.equals(" checked")?"":"disabled" ));
                out.write(_jsp_string27, 0, _jsp_string27.length);
                out.print((dtl_defrow));
                out.write(_jsp_string28, 0, _jsp_string28.length);
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack42);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack46 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack46 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack46);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.print((SystemEnv.getHtmlLabelName(31592,languageid)));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack46);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack50 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack50 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack50);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.write(_jsp_string29, 0, _jsp_string29.length);
                out.print((dtlmul ));
                out.write(' ');
                out.print((dtladd.equals(" checked")?"":"disabled" ));
                out.write(_jsp_string23, 0, _jsp_string23.length);
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack50);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              }	 
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack54 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack54 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack54);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.print((SystemEnv.getHtmlLabelName(22363,languageid)));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack54);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack58 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack58 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack58);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.write(_jsp_string30, 0, _jsp_string30.length);
                out.print((dtlhide ));
                out.write(_jsp_string23, 0, _jsp_string23.length);
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack58);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack62 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack62 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack62);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.print((SystemEnv.getHtmlLabelName(81857,languageid)));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack62);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack66 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack66 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack66);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.write(_jsp_string31, 0, _jsp_string31.length);
                out.print((dtlprintserial ));
                out.write(_jsp_string23, 0, _jsp_string23.length);
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack66);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack70 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack70 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack70);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.print((SystemEnv.getHtmlLabelName(83507,languageid)));
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack70);
              out.write(_jsp_string17, 0, _jsp_string17.length);
              com.caucho.jsp.BodyContentImpl _jsp_endTagHack74 = null;
              if (_jsp_ItemTag_2 == null) {
                _jsp_ItemTag_2 = new weaver.template.tag.ItemTag();
                _jsp_ItemTag_2.setPageContext(pageContext);
                _jsp_ItemTag_2.setParent((javax.servlet.jsp.tagext.Tag) _jsp_GroupTag_1);
              }

              _jsp_ItemTag_2.doStartTag();
              out = pageContext.pushBody();
              _jsp_endTagHack74 = (com.caucho.jsp.BodyContentImpl) out;
              _jsp_ItemTag_2.setBodyContent(_jsp_endTagHack74);
              _jsp_ItemTag_2.doInitBody();
              do {
                out.write(_jsp_string32, 0, _jsp_string32.length);
                out.print((dtlallowscroll ));
                out.write(_jsp_string23, 0, _jsp_string23.length);
              } while (_jsp_ItemTag_2.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
              out = pageContext.popBody();
              _jsp_ItemTag_2.doEndTag();
              pageContext.releaseBody(_jsp_endTagHack74);
              out.write(_jsp_string16, 0, _jsp_string16.length);
            } while (_jsp_GroupTag_1.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
            if (_jspEval5 == javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_BUFFERED)
              out = pageContext.popBody();
          }
          _jsp_GroupTag_1.doEndTag();
          if (_jsp_endTagHack3 != null) {
            pageContext.releaseBody(_jsp_endTagHack3);
            _jsp_endTagHack3 = null;
          }
          out.write(_jsp_string15, 0, _jsp_string15.length);
          } 
          out.write(_jsp_string15, 0, _jsp_string15.length);
        } while (_jsp_ViewTag_0.doAfterBody() == javax.servlet.jsp.tagext.IterationTag.EVAL_BODY_AGAIN);
        if (_jspEval2 == javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_BUFFERED)
          out = pageContext.popBody();
      }
      _jsp_ViewTag_0.doEndTag();
      if (_jsp_endTagHack0 != null) {
        pageContext.releaseBody(_jsp_endTagHack0);
        _jsp_endTagHack0 = null;
      }
      out.write(_jsp_string33, 0, _jsp_string33.length);
    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      if (_jsp_ViewTag_0 != null)
        _jsp_ViewTag_0.release();
      if (_jsp_GroupTag_1 != null)
        _jsp_GroupTag_1.release();
      if (_jsp_ItemTag_2 != null)
        _jsp_ItemTag_2.release();
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("workflow/exceldesign/excelSetDetail.jsp"), 4261860737927997051L, false);
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
  private final static char []_jsp_string9;
  private final static char []_jsp_string23;
  private final static char []_jsp_string16;
  private final static char []_jsp_string31;
  private final static char []_jsp_string29;
  private final static char []_jsp_string19;
  private final static char []_jsp_string33;
  private final static char []_jsp_string25;
  private final static char []_jsp_string6;
  private final static char []_jsp_string1;
  private final static char []_jsp_string13;
  private final static char []_jsp_string12;
  private final static char []_jsp_string18;
  private final static char []_jsp_string20;
  private final static char []_jsp_string32;
  private final static char []_jsp_string0;
  private final static char []_jsp_string26;
  private final static char []_jsp_string11;
  private final static char []_jsp_string22;
  private final static char []_jsp_string2;
  private final static char []_jsp_string10;
  private final static char []_jsp_string17;
  private final static char []_jsp_string8;
  private final static char []_jsp_string15;
  private final static char []_jsp_string24;
  private final static char []_jsp_string21;
  private final static char []_jsp_string14;
  private final static char []_jsp_string5;
  private final static char []_jsp_string28;
  private final static char []_jsp_string7;
  private final static char []_jsp_string3;
  private final static char []_jsp_string30;
  private final static char []_jsp_string27;
  static {
    _jsp_string4 = "\" />\r\n	<div class=\"filedTab\">\r\n		<div class=\"tableSearch\" style=\"padding:5px;\">\r\n			<span class=\"searchInputSpan\">\r\n				<input type=\"text\" class=\"searchInput\" name=\"searchVal\" onkeypress=\"if(event.keyCode==13) {searchDetailTable('".toCharArray();
    _jsp_string9 = "255(".toCharArray();
    _jsp_string23 = " />\r\n				".toCharArray();
    _jsp_string16 = "\r\n			".toCharArray();
    _jsp_string31 = "\r\n					<input type=\"checkbox\" id=\"dtlprintserial\" name=\"dtlprintserial\" ".toCharArray();
    _jsp_string29 = "\r\n					<input type=\"checkbox\" id=\"dtlmul\" name=\"dtlmul\" ".toCharArray();
    _jsp_string19 = " onchange=\"onNotEdit(this)\" onclick=\"checkChange()\"/>\r\n				".toCharArray();
    _jsp_string33 = "\r\n	</div>\r\n	<div class=\"moduleBottom\"></div>\r\n</form>\r\n</BODY>\r\n</HTML>\r\n".toCharArray();
    _jsp_string25 = "\r\n					<input type=\"checkbox\" id=\"dtldef\" name=\"dtldef\" ".toCharArray();
    _jsp_string6 = "')\"></img>\r\n				</span>\r\n			</span>\r\n		</div>\r\n		<div class=\"tableBody\" style=\"width:100%;overflow-y:auto;\">\r\n			<table style=\"width:100%;\">\r\n				<colgroup>\r\n					<col width=\"50%\">\r\n					<col width=\"50%\">\r\n				</colgroup>\r\n				<tbody>\r\n					<tr class=\"thead\">\r\n						<td class=\"rightBorder\">".toCharArray();
    _jsp_string1 = "\r\n<HTML>\r\n<HEAD>\r\n<TITLE></TITLE>\r\n<script type=\"text/javascript\">\r\nvar parentWin_Main = parent.getParentWindow(window);		//\u5168\u5c40\u53d8\u91cf-\u660e\u7ec6\u8868\u83b7\u53d6\u4e3b\u8868window\r\njQuery(document).ready(function(){\r\n	if(wfinfo && wfinfo.isactive != \"1\")\r\n		jQuery(\"div[name='somethingdiv']\").hide();\r\n	$(\".tableBody\").css(\"height\",($(window).height()-485)+\"px\");\r\n	loadDetailTable(\"".toCharArray();
    _jsp_string13 = "\" id=\"zd_btn_cancle\" onclick=\"saveEditFieldName()\"  class=\"zd_btn_cancle\" style=\"height: 25px;line-height: 25px;padding-left: 10px;padding-right: 10px;\">\r\n					    	<input type=\"button\" value=\"".toCharArray();
    _jsp_string12 = ")\"></div>\r\n						<div id=\"zDialog_div_bottom\" style=\"margin-top:5px; border-top:1px solid #c9c9c9;padding-top:5px;\">\r\n					    	<input type=\"button\" value=\"".toCharArray();
    _jsp_string18 = "\r\n					<input type=\"checkbox\" id=\"dtladd\" name=\"dtladd\" ".toCharArray();
    _jsp_string20 = "\r\n					<input type=\"checkbox\" id=\"dtledit\" name=\"dtledit\" ".toCharArray();
    _jsp_string32 = "\r\n					<input type=\"checkbox\" id=\"dtlallowscroll\" name=\"dtlallowscroll\" ".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string26 = " onclick=\"changeInputState(this,'dtl_defrow')\"/>\r\n					<input type=\"text\" id=\"dtl_defrow\" name=\"dtl_defrow\" ".toCharArray();
    _jsp_string11 = ")\"></div>\r\n						<div style=\"float:left;margin-top:5px;height:25px;padding-left:10px;\"><img src=\"/images/ecology8/tranditional_wev8.png\" /></div>\r\n						<div style=\"margin-top:5px;height:25px;\"><input type=\"text\" id=\"twlabel\" onblur=\"checkMaxLength(this)\" maxlength=\"255\" alt=\"".toCharArray();
    _jsp_string22 = "\r\n					<input type=\"checkbox\" id=\"dtldel\" name=\"dtldel\" ".toCharArray();
    _jsp_string2 = "\");\r\n	\r\n	var t=setTimeout(bindgound,100);\r\n	function bindgound(){\r\n		clearTimeout(t);\r\n		$(\"div[name=somethingdiv]\").find(\"tr.groupHeadHide\").find(\".hideBlockDiv\").click(function(e){\r\n			var ishow = $(this).attr(\"_status\");\r\n			if(ishow===\"0\"){\r\n				$(\".tableBody\").css(\"height\",($(\".tableBody\").height()-252)+\"px\");\r\n			}else{\r\n				$(\".tableBody\").css(\"height\",($(\".tableBody\").height()+252)+\"px\");\r\n			}\r\n		});\r\n	}\r\n});\r\n\r\n</script>\r\n</HEAD>\r\n<BODY style=\"margin:0px; padding:0px;\">\r\n<form id=\"LayoutForm\" name=\"LayoutForm\" style=\"height:100%;\" action=\"excel_operation.jsp\" target=\"_self\" method=\"post\" enctype=\"multipart/form-data\">\r\n	<input type=\"hidden\" id=\"formid\" name=\"formid\" value=\"".toCharArray();
    _jsp_string10 = ")\"><img style=\"display:none;\" src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\"></div>\r\n						<div style=\"float:left;margin-top:5px;height:25px;padding-left:10px;\"><img src=\"/images/ecology8/en_wev8.png\" /></div>\r\n						<div style=\"margin-top:5px;height:25px;\"><input type=\"text\" id=\"enlabel\"  onblur=\"checkMaxLength(this)\" maxlength=\"255\" alt=\"".toCharArray();
    _jsp_string17 = "\r\n				".toCharArray();
    _jsp_string8 = "</td>\r\n					</tr>\r\n				</tbody>\r\n			</table>\r\n			<div name=\"editfieldDiv\" style=\"display:none;position: relative;height:0px;\">\r\n				<div name=\"editfieldDiv1\" style=\"position: relative;\">\r\n					<div name=\"editfieldCry\" style=\"position:relative;text-align:center;background:#ffffff;padding-bottom:5px;border-top:1px solid #c9c9c9;border-bottom:1px solid #c9c9c9;\">\r\n						<input type=\"hidden\" name=\"fieldid\" />\r\n						<div style=\"float:left;margin-top:5px;height:25px;padding-left:10px;\"><img src=\"/images/ecology8/simplized_wev8.png\" /></div>\r\n						<div style=\"margin-top:5px;height:25px;\"><input type=\"text\" id=\"cnlabel\" onblur=\"checkMaxLength(this)\" maxlength=\"255\" alt=\"".toCharArray();
    _jsp_string15 = "\r\n		".toCharArray();
    _jsp_string24 = "\r\n					<input type=\"checkbox\" id=\"dtlned\" name=\"dtlned\" ".toCharArray();
    _jsp_string21 = " onchange=\"onNotEdit(this)\" />\r\n				".toCharArray();
    _jsp_string14 = "\" id=\"zd_btn_cancle\" onclick=\"cancelEditFieldName()\"  class=\"zd_btn_cancle\" style=\"height: 25px;line-height: 25px;padding-left: 10px;padding-right: 10px;\">  \r\n					  	</div>\r\n					</div>\r\n				</div>\r\n			</div>\r\n		</div>\r\n	</div>\r\n	<div name=\"somethingdiv\" style=\"position:relative;\">\r\n		".toCharArray();
    _jsp_string5 = "');return false;}\"/></input>\r\n				<span>\r\n					<img src=\"/images/ecology8/request/search-input_wev8.png\" onclick=\"searchDetailTable('".toCharArray();
    _jsp_string28 = "\" style=\"width:30px;\">\r\n				".toCharArray();
    _jsp_string7 = "</td>\r\n						<td>".toCharArray();
    _jsp_string3 = "\" />\r\n	<input type=\"hidden\" id=\"isbill\" name=\"isbill\" value=\"".toCharArray();
    _jsp_string30 = "\r\n					<input type=\"checkbox\" id=\"dtlhide\" name=\"dtlhide\" ".toCharArray();
    _jsp_string27 = " onkeypress=\"ItemCount_KeyPress()\" value=\"".toCharArray();
  }
}
