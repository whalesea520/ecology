/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._crm._sellchance;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.net.URLEncoder;
import java.net.URLDecoder;
import weaver.hrm.resource.ResourceComInfo;
import weaver.crm.customer.CustomerService;
import java.text.SimpleDateFormat;
import java.util.*;
import weaver.hrm.*;
import weaver.systeminfo.*;
import weaver.general.StaticObj;
import weaver.general.Util;
import weaver.hrm.settings.RemindSettings;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.*;
import weaver.general.*;

public class _sellchancelistnew__jsp extends com.caucho.jsp.JavaPage
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
    weaver.common.util.taglib.SplitPageTag _jsp_SplitPageTag_0 = null;
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	Log logger= LogFactory.getLog(this.getClass());
	String isIE = (String)session.getAttribute("browser_isie");

      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet RecordSet;
      RecordSet = (weaver.conn.RecordSet) pageContext.getAttribute("RecordSet");
      if (RecordSet == null) {
        RecordSet = new weaver.conn.RecordSet();
        pageContext.setAttribute("RecordSet", RecordSet);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.general.CoworkTransMethod CoworkTransMethod;
      CoworkTransMethod = (weaver.general.CoworkTransMethod) pageContext.getAttribute("CoworkTransMethod");
      if (CoworkTransMethod == null) {
        CoworkTransMethod = new weaver.general.CoworkTransMethod();
        pageContext.setAttribute("CoworkTransMethod", CoworkTransMethod);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.crm.CrmShareBase CrmShareBase;
      CrmShareBase = (weaver.crm.CrmShareBase) pageContext.getAttribute("CrmShareBase");
      if (CrmShareBase == null) {
        CrmShareBase = new weaver.crm.CrmShareBase();
        pageContext.setAttribute("CrmShareBase", CrmShareBase);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.hrm.resource.ResourceComInfo ResourceComInfo;
      ResourceComInfo = (weaver.hrm.resource.ResourceComInfo) pageContext.getAttribute("ResourceComInfo");
      if (ResourceComInfo == null) {
        ResourceComInfo = new weaver.hrm.resource.ResourceComInfo();
        pageContext.setAttribute("ResourceComInfo", ResourceComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.crm.customer.CustomerService CustomerService;
      CustomerService = (weaver.crm.customer.CustomerService) pageContext.getAttribute("CustomerService");
      if (CustomerService == null) {
        CustomerService = new weaver.crm.customer.CustomerService();
        pageContext.setAttribute("CustomerService", CustomerService);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.hrm.company.DepartmentComInfo DepartmentComInfo;
      DepartmentComInfo = (weaver.hrm.company.DepartmentComInfo) pageContext.getAttribute("DepartmentComInfo");
      if (DepartmentComInfo == null) {
        DepartmentComInfo = new weaver.hrm.company.DepartmentComInfo();
        pageContext.setAttribute("DepartmentComInfo", DepartmentComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.hrm.company.SubCompanyComInfo SubCompanyComInfo;
      SubCompanyComInfo = (weaver.hrm.company.SubCompanyComInfo) pageContext.getAttribute("SubCompanyComInfo");
      if (SubCompanyComInfo == null) {
        SubCompanyComInfo = new weaver.hrm.company.SubCompanyComInfo();
        pageContext.setAttribute("SubCompanyComInfo", SubCompanyComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string3, 0, _jsp_string3.length);
      
int userid=user.getUID();
String labelid=Util.null2String(request.getParameter("labelid"),"my");       //\u6807\u7b7eid my\u6211\u7684\u5546\u673a\uff0call\u5168\u90e8\u5546\u673a\uff0cattention\u5173\u6ce8\u5546\u673a\uff0cexpire\u5230\u671f\u5546\u673a
String creater=Util.null2String(request.getParameter("creater"));    //\u88ab\u67e5\u770b\u4ebaid
String includeSubCompany=Util.null2String(request.getParameter("includeSubCompany"));
String subCompanyId=Util.null2String(request.getParameter("subCompanyId"));
String includeSubDepartment=Util.null2String(request.getParameter("includeSubDepartment"));
String departmentId=Util.null2String(request.getParameter("departmentId"));
String preyield=Util.null2String(request.getParameter("preyield"));
String preyield_1=Util.null2String(request.getParameter("preyield_1"));
String predate=Util.null2String(request.getParameter("predate"));
String fromdate=Util.null2String(request.getParameter("fromdate"));
String enddate=Util.null2String(request.getParameter("enddate"));
String productId=Util.null2String(request.getParameter("productId"));
String creater_str = Util.null2String(request.getParameter("creater_str"));
String containsSub = Util.null2String(request.getParameter("containsSub"),"0"); //0\u4e3a\u5305\u542b\u4e0b\u7ea7\uff0c1\u4e3a\u4e0d\u5305\u542b\u4e0b\u7ea7
String sellstatusid_str = Util.null2String(request.getParameter("sellstatusid_str"));
String predate_str = Util.null2String(request.getParameter("predate_str"));
String probability_str = Util.null2String(request.getParameter("probability_str"));
String contactTime_str = Util.null2String(request.getParameter("contactTime_str"));
String preyield_str = Util.null2String(request.getParameter("preyield_str"));
String probability=Util.null2String(request.getParameter("probability"));
String probability_1=Util.null2String(request.getParameter("probability_1"));
String subject=Util.null2String(request.getParameter("name"));

RecordSet.execute("select creater from CRM_SellChance");
while(RecordSet.next()){
    String createrId = RecordSet.getString("creater");
    String deptId = ResourceComInfo.getDepartmentID(createrId);
    String scId = ResourceComInfo.getSubCompanyID(createrId);
    String sql = "update CRM_SellChance set departmentId = '"+deptId+"',subCompanyId = '"+scId+"' where creater = '"+createrId+"'";
    RecordSet.execute(sql);
}
if(!creater_str.equals("")){
	userid = Util.getIntValue(creater_str);
}
String leftjointable = CrmShareBase.getTempTable(""+userid);
String  backfields  =  "t1.id,t1.subject,t1.creater,t1.predate,t1.preyield,t1.probability,"+
	"	t1.sellstatusid,t1.createdate,t1.createtime,t1.endtatusid,t1.CustomerID ,case when t3.sellchanceid is not null then 1 else 0 end as important";
String  sqlFrom=" CRM_SellChance  t1 left join "+leftjointable+" t2 on t1.customerid = t2.relateditemid"+
				" left join (select sellchanceid from CRM_SellchanceAtt where resourceid="+userid+") t3 on t1.id=t3.sellchanceid left join CRM_CustomerInfo cc on cc.id=t1.customerid";
String  sqlWhere=" t1.customerid = t2.relateditemid and cc.deleted=0 ";
if(!"".equals(subject)){
	sqlWhere+=" and t1.subject like '%"+subject+"%'";
}
if(labelid.equals("my")){  //\u6211\u7684\u5546\u673a
	if("".equals(creater))
	creater = user.getUID()+"";
}else if(labelid.equals("attention")){
	sqlWhere+=" and t3.sellchanceid is not null";
}else if(labelid.equals("expire")){
	String date=TimeUtil.getCurrentDateString();//currentdate
	String date1= TimeUtil.dateAdd(date,-30);//currentdate-30
	sqlWhere +=" and t1.predate >= '"+date1+"' and t1.predate <= '"+date+"'";
}else if(!labelid.equals("all")){
	sqlFrom+=" left join (select sellchanceid from CRM_Sellchance_label where labelid="+labelid+") t4 on t1.id=t4.sellchanceid";
	sqlWhere+=" and t1.id=t4.sellchanceid ";
}
if(creater_str.equals("")){
	creater_str = creater;
}
if(!"".equals(sellstatusid_str)){
	sqlWhere+=" and t1.sellstatusid = '"+sellstatusid_str+"'";
}
if(!"".equals(predate_str)){
	int year = Util.getIntValue(predate_str.split("-")[0]);
	int month = Util.getIntValue(predate_str.split("-")[1]);
	sqlWhere += " and t1.predate >= '"+TimeUtil.getYearMonthFirstDay(year ,month)+"'";
	sqlWhere += " and t1.predate <= '"+TimeUtil.getYearMonthEndDay(year ,month)+"'";
}
if(!"".equals(preyield_str)){
	switch(Util.getIntValue(preyield_str)){
		case 0:
			preyield_1 = "50000";
			break;
		case 1:
			preyield = "50000";
			preyield_1 = "100000";
			break;
		case 2:
			preyield = "100000";
			preyield_1 = "200000";
			break;
		case 3:
			preyield = "200000";
			preyield_1 = "500000";
			break;
		case 4:
			preyield = "500000";
			preyield_1 = "1000000";
			break;
		case 5:
			preyield = "1000000";
			break;
	}
}
if(!preyield.equals("")){
	sqlWhere+=" and t1.preyield>="+preyield;
}
if(!preyield_1.equals("")){
	sqlWhere+=" and t1.preyield<="+preyield_1;
}
if(!"".equals(probability_str)){
	switch(Util.getIntValue(probability_str)){
		case 0:
			sqlWhere += " and 100 * probability <= 30";
			break;
		case 1:
			sqlWhere += " and 100 * probability >= 30 and 100 * probability <= 50";
			break;
		case 2:
			sqlWhere += " and 100 * probability >= 50 and 100 * probability <= 70";
			break;
		case 3:
			sqlWhere += " and 100 * probability >= 70 and 100 * probability <= 90";
			break;
		case 4:
			sqlWhere += " and 100 * probability >= 90";
			break;
	}
}
if(!probability.equals("")){
	sqlWhere+=" and t1.probability>="+probability;
}
if(!probability_1.equals("")){
	sqlWhere+=" and t1.probability<="+probability_1;
}
rs.execute("select fieldhtmltype ,type,fieldname , candel,groupid from CRM_CustomerDefinField where usetable = 'CRM_SellChance' and issearch= 1 and isopen=1");
String fieldName = "";
String fieldValue = "";
String htmlType = "";
String type= "";
while(rs.next()){
	fieldName = rs.getString("fieldName");
	fieldValue = Util.null2String(Util.null2String(request.getParameter(fieldName)));
	htmlType = rs.getString("fieldhtmltype");
	type = rs.getString("type");
	if(fieldName.equals("") || fieldValue.equals("")){
		continue;
	}
	if(fieldName.equals("predate")){
		if(!"".equals(predate) && !"6".equals(predate)){
			sqlWhere += " and t1.predate >= '"+TimeUtil.getDateByOption(predate+"","0")+"'";
			sqlWhere += " and t1.predate <= '"+TimeUtil.getDateByOption(predate+"","")+"'";
		}
		if("6".equals(predate) && !fromdate.equals("")){
			sqlWhere+=" and t1.predate>='"+fromdate+"'";
		}
		if("6".equals(predate) && !enddate.equals("")){
			sqlWhere+=" and t1.predate<='"+enddate+"'";
		}
	}else if(htmlType.equals("1") && (type.equals("2") || type.equals("3"))){//\u5355\u884c\u6587\u672c\u4e3a\u6570\u503c\u7c7b\u578b
		sqlWhere +=  " and t1."+fieldName+" = "+fieldValue;
	}else if((htmlType.equals("5") || htmlType.equals("3"))&&!type.equals("162")){//\u4e0b\u62c9\u6846 \u548c \u6d4f\u89c8\u6846
		sqlWhere += " and t1."+fieldName+" = "+fieldValue;
	}else{
		sqlWhere += " and t1."+fieldName+" like '%"+fieldValue+"%'";
	}
}

if(!creater_str.equals("")){
	if(containsSub.equals("0")){ //\u4ec5\u672c\u4eba
		sqlWhere+=" and t1.creater="+creater_str;
	}else if(containsSub.equals("1")){ //\u5305\u542b\u4e0b\u5c5e
		String subResourceid=CustomerService.getSubResourceid(creater_str); //\u6240\u6709\u4e0b\u5c5e
		if(!subResourceid.equals("")){
			sqlWhere+=" and (t1.creater="+creater_str+" or t1.creater in("+subResourceid+"))";
		}
	}
}

if(!productId.equals("")){
	sqlWhere+=" and t1.id in (select sellchanceid from CRM_ProductTable where productid ="+productId+")";
}

if(!"".equals(contactTime_str)){
	String UncontactTime = "";
	String contactTime = "";
	String date_str = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
	switch(Util.getIntValue(contactTime_str)){
		case 0:
			UncontactTime = TimeUtil.dateAdd(date_str,-3);
			break;
		case 1:
			UncontactTime = TimeUtil.dateAdd(date_str,-7);
			break;
		case 2:
			UncontactTime = TimeUtil.dateAdd(date_str,-14);
			break;
		case 3:
			UncontactTime = TimeUtil.dateAdd(date_str,-30);
			break;
		case 4:
			UncontactTime = TimeUtil.dateAdd(date_str,-90);
			break;
		case 5:
			UncontactTime = TimeUtil.dateAdd(date_str,-180);
			break;
		case 6:
			UncontactTime = TimeUtil.dateAdd(date_str,-365);
			break;
		case 7:
			contactTime = date_str;
			break;
		case 8:
			contactTime = TimeUtil.dateAdd(date_str,-7);
			break;
		case 9:
			contactTime = TimeUtil.dateAdd(date_str,-30);
			break;
		case 10:
			contactTime = TimeUtil.dateAdd(date_str,-90);
			break;
	}
	if(RecordSet.getDBType().equals("oracle")){
		if(!UncontactTime.equals("")&&11!=Util.getIntValue(contactTime_str)){
			sqlWhere += " and EXISTS(select createDate from workplan tt where id=(select id from (select id,sellchanceid,createdate from workplan order by createdate desc) where sellchanceid = t1.id and rownum<=1 and to_date(tt.createDate,'yyyy-MM-dd') <= to_date('"+UncontactTime+"','yyyy-MM-dd')))";
		}else if(11==Util.getIntValue(contactTime_str)){//\u65e0\u8054\u7cfb\u8bb0\u5f55
			sqlWhere += " and not EXISTS(select createDate from workplan where sellchanceid = t1.id )";
		}
		if(!contactTime.equals("")){
			sqlWhere += " and EXISTS(select createDate from workplan tt where sellchanceid = t1.id and to_date(tt.createDate,'yyyy-MM-dd') >= to_date('"+contactTime+"','yyyy-MM-dd'))";
		}
	}else{
		if(!UncontactTime.equals("")&&11!=Util.getIntValue(contactTime_str)){
			sqlWhere += " and EXISTS(select tt.createDate from (select top 1 createDate from workplan where sellchanceid = t1.id  order by createDate desc)as tt where tt.createDate <= '"+UncontactTime+"')";
		}else if(11==Util.getIntValue(contactTime_str)){//\u65e0\u8054\u7cfb\u8bb0\u5f55
			sqlWhere += " and not EXISTS(select createDate from workplan where sellchanceid = t1.id )";
		}
		if(!contactTime.equals("")){
			sqlWhere += " and EXISTS(select tt.createDate from (select top 1 createDate from workplan where sellchanceid = t1.id  order by createDate desc)as tt where tt.createDate >= '"+contactTime+"')";
		}
	}
}
if(!subCompanyId.equals("")&&!subCompanyId.equals("0")){//\u5ba2\u6237\u7ecf\u7406\u5206\u90e8ID
	 if(includeSubCompany.equals("2")){
		String subCompanyIds = "";
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubCompanyLists(subCompanyId,list);
		for(int i=0;i<list.size();i++){
			subCompanyIds += ","+(String)list.get(i);
		}
		if(list.size()>0)subCompanyIds = subCompanyIds.substring(1);
		subCompanyIds = "("+subCompanyIds+")";
		sqlWhere+=" and t1.subCompanyId in "+subCompanyIds;
	}else if(includeSubCompany.equals("3")){
		String subCompanyIds = subCompanyId;
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubCompanyLists(subCompanyId,list);
		for(int i=0;i<list.size();i++){
			subCompanyIds += ","+(String)list.get(i);
		}
		subCompanyIds = "("+subCompanyIds+")";

		sqlWhere+=" and t1.subCompanyId in "+subCompanyIds;
	}else{
		sqlWhere+=" and t1.subCompanyId="+subCompanyId;
	}
}
if(!departmentId.equals("")){//\u5ba2\u6237\u7ecf\u7406\u90e8\u95e8ID
	if(includeSubDepartment.equals("2")){
		String departmentIds = "";
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubDepartmentLists(departmentId,list);
		for(int i=0;i<list.size();i++){
			departmentIds += ","+(String)list.get(i);
		}
		if(list.size()>0)departmentIds = departmentIds.substring(1);
		departmentIds = "("+departmentIds+")";
		sqlWhere+=" and t1.departmentId in "+departmentIds;
	}else if(includeSubDepartment.equals("3")){
		String departmentIds = departmentId;
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubDepartmentLists(departmentId,list);
		for(int i=0;i<list.size();i++){
			departmentIds += ","+(String)list.get(i);
		}
		departmentIds = "("+departmentIds+")";
		sqlWhere+=" and t1.departmentId in "+departmentIds;		
	}else{
		sqlWhere+=" and t1.departmentId="+departmentId;
	}
}
RecordSet.execute("select distinct t1.CustomerID from "+sqlFrom+" where "+sqlWhere);
StringBuffer crmIdBuffer = new StringBuffer();
while(RecordSet.next()){
	crmIdBuffer.append(RecordSet.getString("CustomerID")+",");
}
String crmIds = crmIdBuffer.toString();
if(!crmIds.equals("")){
	crmIds = crmIds.substring(0,crmIds.length()-1);
}
	String tableString = "";
	String orderby = "t1.id";
	tableString = " <table pageId=\""+PageIdConst.CRM_SellChanceList+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_SellChanceList,user.getUID(),PageIdConst.CRM)+"\"  tabletype=\"checkbox\">"+
				  " <sql backfields=\""+backfields+"\" sqlform=\""+sqlFrom+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"/>"+
				  " <checkboxpopedom showmethod=\"weaver.crm.sellchance.SellChangeRoprtTransMethod.getSellCheckInfo\" popedompara=\"column:endtatusid+column:customerid+"+user.getUID()+"\"  />"+
				  " <head>"+
	              " <col name='subject' width=\"70%\"  text=\""+SystemEnv.getHtmlLabelName(82534,user.getLanguage())+"\" column=\"subject\" orderkey=\"subject\" otherpara=\"column:id\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getSellChanceName\"/>"+
	              " <col name='creater' width='20%' text='"+SystemEnv.getHtmlLabelNames("1278",user.getLanguage())+"' column='creater' transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename' href='/hrm/resource/HrmResource.jsp' linkkey='id' orderkey='t1.creater' target='_blank'/>"+
	              " <col name='important' width='10%' text='\u5173\u6ce8' column='important' transmethod='weaver.crm.report.CRMContractTransMethod.getImportant' otherpara='column:id' target='_blank'/>"+
	              "	</head>"+
	 			  " </table>";
out.println("<script>viewDefault('"+crmIds+"')</script>");

      out.write(_jsp_string2, 0, _jsp_string2.length);
      if (_jsp_SplitPageTag_0 == null) {
        _jsp_SplitPageTag_0 = new weaver.common.util.taglib.SplitPageTag();
        _jsp_SplitPageTag_0.setPageContext(pageContext);
        _jsp_SplitPageTag_0.setParent((javax.servlet.jsp.tagext.Tag) null);
        _jsp_SplitPageTag_0.setMode("run");
        _jsp_SplitPageTag_0.setIsShowTopInfo("true");
      }

      _jsp_SplitPageTag_0.setTableString(tableString);
      _jsp_SplitPageTag_0.doStartTag();
      int _jsp_end_3 = _jsp_SplitPageTag_0.doEndTag();
      if (_jsp_end_3 == javax.servlet.jsp.tagext.Tag.SKIP_PAGE)
        return;
      out.write(_jsp_string2, 0, _jsp_string2.length);
    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      if (_jsp_SplitPageTag_0 != null)
        _jsp_SplitPageTag_0.release();
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("CRM/sellchance/SellChanceListNew.jsp"), -189062350343295590L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("page/maint/common/initNoCache.jsp"), 3270256153856711871L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("WEB-INF/weaver.tld"), -8967885045122085173L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, new com.caucho.make.ClassDependency(weaver.common.util.taglib.SplitPageTag.class, -2275629372954534634L));
  }

  static {
    try {
    } catch (Exception e) {
      e.printStackTrace();
      throw new RuntimeException(e);
    }
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  private final static char []_jsp_string2;
  private final static char []_jsp_string3;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\r\n".toCharArray();
    _jsp_string3 = "\r\n\r\n".toCharArray();
  }
}
