/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._docs._docs;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.*;
import weaver.general.Util;
import weaver.hrm.*;

public class _docimgsutil__jsp extends com.caucho.jsp.JavaPage
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
    response.setContentType("text/xml;charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.docs.docs.DocImageManager imgManger;
      imgManger = (weaver.docs.docs.DocImageManager) pageContext.getAttribute("imgManger");
      if (imgManger == null) {
        imgManger = new weaver.docs.docs.DocImageManager();
        pageContext.setAttribute("imgManger", imgManger);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.docs.DocDetailLog docDetailLog;
      docDetailLog = (weaver.docs.DocDetailLog) pageContext.getAttribute("docDetailLog");
      if (docDetailLog == null) {
        docDetailLog = new weaver.docs.DocDetailLog();
        pageContext.setAttribute("docDetailLog", docDetailLog);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	
	int docid = Util.getIntValue(request.getParameter("docid"),-1);
	String delImgIds = Util.null2String(request.getParameter("delImgIds"));
    String  method=Util.null2String(request.getParameter("method"));
	String  delcurrentversion=Util.null2String(request.getParameter("delcurrentversion"));
	//int userLanguage = user.getLanguage();

	if(method.equals("delPics")){  
		String[] arrayImgsId=Util.TokenizerString2(delImgIds,",");
		if(arrayImgsId!=null) {
			for(int i=0;i<arrayImgsId.length;i++){
				int tempImgId=Util.getIntValue(arrayImgsId[i],-1);
				
				if(tempImgId==-1) continue;

				
                String sql = "delete from docimagefile where imagefileid=" + tempImgId + " and docid = " + docid;

				//System.out.println(sql);

                rs.executeSql(sql);

                imgManger.resetParameter();
                imgManger.setImagefileid(tempImgId);
                imgManger.setDocid(docid);
                imgManger.DeleteSingleDocImageInfo();
                
                rs.executeSql("update docdetail set accessorycount = (select count(0) from DocImageFile where isextfile = '1' and docid = " +docid + " and docfiletype <> '1' ) where id = " + docid);
				
			}			
		}
		return;
	}  else if(method.equals("delImgsOnly")){
		String tempFlag=delImgIds.substring(delImgIds.length()-1);
		if(tempFlag.equals(",")) delImgIds=delImgIds.substring(0,delImgIds.length()-1);
		//System.out.println("delImgIds:"+delImgIds);
		
        ArrayList delImageids=Util.TokenizerString(delImgIds,",");
        for (int i = 0; i < delImageids.size(); i++) {
        	if (Util.getIntValue((String)delImageids.get(i), 0) == 0) continue;
        	if("1".equals(delcurrentversion)){
        	imgManger.resetParameter();
        	imgManger.setDocid(docid);
        	imgManger.setImagefileid(Util.getIntValue((String)delImageids.get(i), 0));
        	imgManger.DeleteSingleDocImageInfo();
        	}else{
        		rs.executeSql("select imagefileid from DocImageFile where id = (select id from DocImageFile where docid="+docid +" and imagefileid="+Util.getIntValue((String)delImageids.get(i), 0)+" and isextfile=1) ");
        		while(rs.next()){
        			imgManger.resetParameter();
		        	imgManger.setDocid(docid);
		        	imgManger.setImagefileid(Util.getIntValue(rs.getString("imagefileid"), 0));
		        	imgManger.DeleteSingleDocImageInfo();
        		}
        	}
        }
		
		String sql ="select count(distinct id) from docimagefile where isextfile = '1' and docid="+docid;
		rs.executeSql(sql);
		int countImg=0;
		while(rs.next()){
			countImg=rs.getInt(1);	
		}	
		Calendar today = Calendar.getInstance();
		String formatdate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
				+ Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
				+ Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
		String formattime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":"
				+ Util.add0(today.get(Calendar.MINUTE), 2) + ":"
				+ Util.add0(today.get(Calendar.SECOND), 2);
		sql = "update  docdetail set accessorycount="+countImg+",doclastmoddate='"+formatdate+"',doclastmodtime='"+formattime+"',doclastmoduserid='"+user.getUID()+"',docLastModUserType='"+user.getLogintype()+"' where id="+docid;
		//System.out.println(sql);
		rs.executeSql(sql); 
		
		String docsubject = "";
		String creatertype = "";
		int doccreater = 0;
		String selSql = "select docsubject,creatertype, doccreater from DocDetailLog where docid="+ docid + " order by id desc";
		//System.out.println("selSql : "+selSql);
		rs.executeSql(selSql); 
		if (rs.next()) {
			docsubject = rs.getString(1);
			creatertype = rs.getString(2);
			doccreater = Util.getIntValue(rs.getString(3));
		}
		String clientip = request.getRemoteAddr();
		String usertype = user.getLogintype();
		int userid = user.getUID();
		docDetailLog.resetParameter();
		docDetailLog.setDocId(docid);
		docDetailLog.setDocSubject(docsubject);
		docDetailLog.setOperateType("2");
		docDetailLog.setOperateUserid(userid);
		docDetailLog.setUsertype(usertype);
		docDetailLog.setClientAddress(clientip);
		docDetailLog.setDocCreater(doccreater);
		docDetailLog.setCreatertype(creatertype);
		docDetailLog.setDocLogInfo();
		return;
	}

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("docs/docs/DocImgsUtil.jsp"), -2693016387327338471L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}
