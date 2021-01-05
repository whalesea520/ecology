/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._docs._docs;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.*;
import weaver.docs.category.CategoryUtil;
import weaver.hrm.*;
import java.util.*;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import weaver.docs.docs.reply.DocReplyUtil;

public class _mutidocbrowserajax__jsp extends com.caucho.jsp.JavaPage
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
      weaver.docs.category.MainCategoryComInfo MainCategoryComInfo;
      MainCategoryComInfo = (weaver.docs.category.MainCategoryComInfo) pageContext.getAttribute("MainCategoryComInfo");
      if (MainCategoryComInfo == null) {
        MainCategoryComInfo = new weaver.docs.category.MainCategoryComInfo();
        pageContext.setAttribute("MainCategoryComInfo", MainCategoryComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.resource.ResourceComInfo ResourceComInfo;
      ResourceComInfo = (weaver.hrm.resource.ResourceComInfo) pageContext.getAttribute("ResourceComInfo");
      if (ResourceComInfo == null) {
        ResourceComInfo = new weaver.hrm.resource.ResourceComInfo();
        pageContext.setAttribute("ResourceComInfo", ResourceComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.docs.search.DocSearchManage DocSearchManage;
      DocSearchManage = (weaver.docs.search.DocSearchManage) pageContext.getAttribute("DocSearchManage");
      if (DocSearchManage == null) {
        DocSearchManage = new weaver.docs.search.DocSearchManage();
        pageContext.setAttribute("DocSearchManage", DocSearchManage);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.docs.search.DocSearchComInfo DocSearchComInfo;
      synchronized (pageContext.getSession()) {
        DocSearchComInfo = (weaver.docs.search.DocSearchComInfo) pageContext.getSession().getAttribute("DocSearchComInfo");
        if (DocSearchComInfo == null) {
          DocSearchComInfo = new weaver.docs.search.DocSearchComInfo();
          pageContext.getSession().setAttribute("DocSearchComInfo", DocSearchComInfo);
        }
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.crm.Maint.CustomerInfoComInfo CustomerInfoComInfo;
      CustomerInfoComInfo = (weaver.crm.Maint.CustomerInfoComInfo) pageContext.getAttribute("CustomerInfoComInfo");
      if (CustomerInfoComInfo == null) {
        CustomerInfoComInfo = new weaver.crm.Maint.CustomerInfoComInfo();
        pageContext.setAttribute("CustomerInfoComInfo", CustomerInfoComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.docs.docs.DocComInfo DocComInfo;
      DocComInfo = (weaver.docs.docs.DocComInfo) pageContext.getAttribute("DocComInfo");
      if (DocComInfo == null) {
        DocComInfo = new weaver.docs.docs.DocComInfo();
        pageContext.setAttribute("DocComInfo", DocComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.docs.docs.DocManager dm;
      dm = (weaver.docs.docs.DocManager) pageContext.getAttribute("dm");
      if (dm == null) {
        dm = new weaver.docs.docs.DocManager();
        pageContext.setAttribute("dm", dm);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
    String isWord = Util.null2String(request.getParameter("isWord"));
	User user = HrmUserVarify.getUser(request, response);
	String src = Util.null2String(request.getParameter("src"));
	String documentids = Util.null2String(request
			.getParameter("systemIds"));
	if (documentids.trim().startsWith(",")) {
		documentids = documentids.substring(1);
	}
	if (src.equalsIgnoreCase("dest")) {
		JSONArray jsonArr = new JSONArray();
		JSONArray jsonArr_tmp = new JSONArray();
		JSONObject json = new JSONObject();
		if (!documentids.equals("")) {
			String sql = "select * from docdetail where id in ("
					+ documentids + ")";
			rs.executeSql(sql);
			while (rs.next()) {
				JSONObject tmp = new JSONObject();
				String usertype = rs.getString("usertype");
				tmp.put("id", rs.getString("id"));
				String docsubjecttemp=rs.getString("docsubject");
				if(docsubjecttemp!=null){
					docsubjecttemp=docsubjecttemp.replaceAll(",","\uff0c");
				}
				tmp.put("subject", docsubjecttemp);
				//tmp.put("mainid",MainCategoryComInfo.getMainCategoryname(rs.getString("maincategory")));
				String createrid = rs.getString("ownerid");
				tmp.put("owner", (usertype.equals("1") ? Util.toScreen(
						ResourceComInfo.getResourcename(createrid),
						user.getLanguage()) : Util.toScreen(
						CustomerInfoComInfo
								.getCustomerInfoname(createrid), user
								.getLanguage())));
				tmp.put("modifydate",rs.getString("doclastmoddate")+" "+rs.getString("doclastmodtime"));
				jsonArr_tmp.add(tmp);
			}
			String[] documentidArr = Util.TokenizerString2(documentids,
					",");
			for (int i = 0; i < documentidArr.length; i++) {
				for (int j = 0; j < jsonArr_tmp.size(); j++) {
					JSONObject tmp = (JSONObject) jsonArr_tmp.get(j);
					if (tmp.get("id").equals(documentidArr[i])) {
						jsonArr.add(tmp);
					}
				}
			}

		}
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList", jsonArr.toString());
		out.println(json.toString());
		return;
	}
	Enumeration em = request.getParameterNames();
	boolean isinit = true;
	while (em.hasMoreElements()) {
		String paramName = (String) em.nextElement();
		if (!paramName.equals("") && !paramName.equals("splitflag"))
			isinit = false;
		break;
	}
	int date2during = Util.getIntValue(request
			.getParameter("date2during"), 0);
	int olddate2during = 0;
	BaseBean baseBean = new BaseBean();
	String date2durings = "";
	try {
		date2durings = Util.null2String(baseBean.getPropValue(
				"docdateduring", "date2during"));
	} catch (Exception e) {
	}
	String[] date2duringTokens = Util.TokenizerString2(date2durings,
			",");
	if (date2duringTokens.length > 0) {
		olddate2during = Util.getIntValue(date2duringTokens[0], 0);
	}
	if (olddate2during < 0 || olddate2during > 36) {
		olddate2during = 0;
	}
	if (isinit) {
		date2during = olddate2during;
	}

	int isgoveproj = Util.getIntValue(IsGovProj.getPath(), 0);//0:\u975e\u653f\u52a1\u7cfb\u7edf\uff0c1\uff1a\u653f\u52a1\u7cfb\u7edf
	String islink = Util.null2String(request.getParameter("islink"));
	String searchid = Util
			.null2String(request.getParameter("searchid"));
	//String searchmainid = Util.null2String(request.getParameter("searchmainid"));
	String searchsubject = Util.null2String(request
			.getParameter("searchsubject"));
	String searchcreater = Util.null2String(request
			.getParameter("searchcreater"));
	String searchdatefrom = Util.null2String(request
			.getParameter("searchdatefrom"));
	String searchdateto = Util.null2String(request
			.getParameter("searchdateto"));
	String sqlwhere1 = Util.null2String(request
			.getParameter("sqlwhere"));
	String crmId = Util.null2String(request.getParameter("txtCrmId"));
	String sqlwhere = "";

	String secCategory = Util.null2String(request
			.getParameter("secCategory"));
	String path = Util.null2String(request.getParameter("path"));
	if (!secCategory.equals(""))
		path = "/"
				+ CategoryUtil.getCategoryPath(Util
						.getIntValue(secCategory));

	sqlwhere = " where 1=1 ";

	if (!islink.equals("1")) {
		DocSearchComInfo.resetSearchInfo();

		if (!searchid.equals(""))
			DocSearchComInfo.setDocid(searchid);
		//if(!searchmainid.equals("")) DocSearchComInfo.setMaincategory(searchmainid) ;
		if (!secCategory.equals(""))
			DocSearchComInfo.setSeccategory(secCategory);
		if (!searchsubject.equals(""))
			DocSearchComInfo.setDocsubject(searchsubject);
		if (!searchdatefrom.equals(""))
			DocSearchComInfo.setDoclastmoddateFrom(searchdatefrom);
		if (!searchdateto.equals(""))
			DocSearchComInfo.setDoclastmoddateTo(searchdateto);
		if (!searchcreater.equals("")) {
			DocSearchComInfo.setOwnerid(searchcreater);
			DocSearchComInfo.setUsertype("1");
		}
		if (!crmId.equals("")) {
			DocSearchComInfo.setDoccreaterid(crmId);
			DocSearchComInfo.setUsertype("2");
		}
		DocSearchComInfo.setOrderby("4");
	}

	String docstatus[] = new String[] { "1", "2", "5", "7" };
	for (int i = 0; i < docstatus.length; i++) {
		DocSearchComInfo.addDocstatus(docstatus[i]);
	}

	String tempsqlwhere = DocSearchComInfo.FormatSQLSearch(user
			.getLanguage());
	String orderclause = DocSearchComInfo.FormatSQLOrder();
	String orderclause2 = DocSearchComInfo.FormatSQLOrder2();

	if (!tempsqlwhere.equals(""))
		sqlwhere += " and " + tempsqlwhere;

	/* added by wdl 2007-03-16 \u6d93\u5d86\u6a09\u7ec0\u54c4\u5dfb\u9359\u832c\u5897\u93c8?*/
	sqlwhere += " and (ishistory is null or ishistory = 0) ";
	/* added end */
	if(DocReplyUtil.isUseNewReply()) {
	    sqlwhere += " and  (isreply!=1 or isreply is null) ";
	}
	if("1".equals(isWord)){
		sqlwhere += " and doctype='2' and (docstatus !='3' and ((doccreaterid !="+user.getUID()+" and docstatus !='0') or doccreaterid ="+user.getUID()+")) and exists(select 1 from DocImageFile where docid=t1.id  and (isextfile <> '1' or isextfile is null) and docfileType='3') ";
	}else if("2".equals(isWord)){
		sqlwhere += " and ((doctype='2' and (docstatus !='3' and ((doccreaterid !="+user.getUID()+" and docstatus !='0') or doccreaterid ="+user.getUID()+")) and exists(select 1 from DocImageFile where docid=t1.id  and (isextfile <> '1' or isextfile is null) and docfileType='3') ) ";
		sqlwhere += "      or (doctype='12' and (docstatus !='3' and ((doccreaterid !="+user.getUID()+" and docstatus !='0') or doccreaterid ="+user.getUID()+")) )) ";
	}	
	sqlwhere += dm.getDateDuringSql(date2during);

	//int perpage = 30 ;
	int perpage = Util
			.getIntValue(request.getParameter("pageSize"), 10);
	int pagenum = Util.getIntValue(request.getParameter("currentPage"),
			1);
	if (documentids.equals("")) {
		documentids = Util.null2String(request
				.getParameter("excludeId"));
	}
	if (!documentids.equals("")) {
		//sqlwhere += " and t1.id not in (" + documentids + ")";
	}
	//DocSearchManage.getSelectResultCount(sqlwhere, user);
	//int RecordSetCounts = DocSearchManage.getRecordersize();
	//int totalPage = RecordSetCounts / perpage;
	//if (totalPage % perpage > 0 || totalPage == 0) {
	//	totalPage++;
	//}

	//if(!check_per.equals(""))  
	//		check_per = "," + check_per + "," ;
	String docid = null;
	String mainid = null;
	String subject = null;
	String createrid = null;
	String usertype = null;

	int i = 0;
	DocSearchManage.setPagenum(pagenum);
	DocSearchManage.setPerpage(perpage);
	DocSearchManage.getSpu().setRecordCount(perpage);
	DocSearchManage.getSelectResult(sqlwhere, orderclause,
			orderclause2, user,false);
	JSONArray jsonArr = new JSONArray();
	JSONObject json = new JSONObject();
	while (DocSearchManage.next()) {
		docid = "" + DocSearchManage.getID();
		mainid = "" + DocSearchManage.getMainCategory();
		subject = DocSearchManage.getDocSubject();
		if(subject!=null){
			subject=subject.replaceAll(",","\uff0c");
		}
		createrid = "" + DocSearchManage.getOwnerId();
		String modifydate = DocSearchManage.getDocLastModDate();
		String modifytime = DocSearchManage.getDocLastModTime();
		usertype = Util.null2String(DocSearchManage.getUsertype());
		JSONObject tmp = new JSONObject();
		tmp.put("id", docid);
		tmp.put("subject", subject);
		//tmp.put("mainid",MainCategoryComInfo.getMainCategoryname(mainid));
		tmp.put("owner", (usertype.equals("1") ? Util.toScreen(
				ResourceComInfo.getResourcename(createrid), user
						.getLanguage()) : Util.toScreen(
				CustomerInfoComInfo.getCustomerInfoname(createrid),
				user.getLanguage())));
		tmp.put("modifydate",modifydate+" "+modifytime);
		jsonArr.add(tmp);
	}
	//json.put("currentPage", pagenum);
	//json.put("totalPage", totalPage);
	json.put("mapList", jsonArr.toString());
	out.println(json.toString());

      out.write(_jsp_string1, 0, _jsp_string1.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("docs/docs/MutiDocBrowserAjax.jsp"), 8290126016503599128L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  private final static char []_jsp_string2;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string2 = "\r\n\r\n".toCharArray();
  }
}