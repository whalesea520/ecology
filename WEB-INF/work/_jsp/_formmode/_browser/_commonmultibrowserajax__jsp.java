/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._formmode._browser;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.formmode.browser.FormModeBrowserUtil;
import com.weaver.formmodel.util.StringHelper;
import weaver.servicefiles.DataSourceXML;
import net.sf.json.JSONArray;
import weaver.general.SplitPageUtil;
import java.net.URLDecoder;
import weaver.conn.RecordSet;
import weaver.systeminfo.SystemEnv;
import weaver.hrm.User;
import weaver.general.Util;
import weaver.general.ComparatorUtil;
import java.util.*;
import weaver.formmode.virtualform.VirtualFormHandler;
import weaver.formmode.service.CommonConstant;
import weaver.formmode.customjavacode.CustomJavaCodeRun;
import weaver.formmode.service.BrowserInfoService;
import weaver.hrm.HrmUserVarify;
import weaver.general.SplitPageParaBean;
import net.sf.json.JSONObject;
import weaver.general.StaticObj;
import weaver.interfaces.workflow.browser.Browser;
import weaver.interfaces.workflow.browser.BrowserBean;
import weaver.formmode.tree.CustomTreeData;

public class _commonmultibrowserajax__jsp extends com.caucho.jsp.JavaPage
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
      weaver.conn.RecordSet rsm;
      rsm = (weaver.conn.RecordSet) pageContext.getAttribute("rsm");
      if (rsm == null) {
        rsm = new weaver.conn.RecordSet();
        pageContext.setAttribute("rsm", rsm);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.formmode.search.FormModeTransMethod FormModeTransMethod;
      FormModeTransMethod = (weaver.formmode.search.FormModeTransMethod) pageContext.getAttribute("FormModeTransMethod");
      if (FormModeTransMethod == null) {
        FormModeTransMethod = new weaver.formmode.search.FormModeTransMethod();
        pageContext.setAttribute("FormModeTransMethod", FormModeTransMethod);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.formmode.view.ModeShareManager ModeShareManager;
      ModeShareManager = (weaver.formmode.view.ModeShareManager) pageContext.getAttribute("ModeShareManager");
      if (ModeShareManager == null) {
        ModeShareManager = new weaver.formmode.view.ModeShareManager();
        pageContext.setAttribute("ModeShareManager", ModeShareManager);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.formmode.setup.ModeRightInfo ModeRightInfo;
      ModeRightInfo = (weaver.formmode.setup.ModeRightInfo) pageContext.getAttribute("ModeRightInfo");
      if (ModeRightInfo == null) {
        ModeRightInfo = new weaver.formmode.setup.ModeRightInfo();
        pageContext.setAttribute("ModeRightInfo", ModeRightInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
request.setCharacterEncoding("UTF-8");
User user = HrmUserVarify.getUser(request,response);

String istree = Util.null2String(request.getParameter("istree"));//\u662f\u5426\u6811\u7684\u7ec4\u5408\u67e5\u8be2
String treeid = Util.null2String(request.getParameter("treeid"));
String treenodeid = Util.null2String(request.getParameter("treenodeid"));

String src = Util.null2String(request.getParameter("src"));
String browsertype = Util.null2String(request.getParameter("browsertype"));
String customid=Util.null2String(request.getParameter("customid"));
//\u94fe\u63a5\u5730\u5740\u4e2dsqlwhere
String sqlwhereparam=Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("systemIds")).replace("weaver2017", "+");
int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
if(perpage <1) perpage=10;
String isCustomPageSize = Util.null2String(request.getParameter("isCustomPageSize"));

if("".equals(customid)){
	out.println(SystemEnv.getHtmlLabelName(81939,user.getLanguage()));//browser\u6846id\u4e0d\u80fd\u4e3a\u7a7a\uff01
	return;
}

if(check_per.trim().startsWith(",")){
	check_per = check_per.substring(1);
}

//============================================browser\u6846\u57fa\u7840\u6570\u636e====================================
boolean issimple=true;
String isbill="1";
int viewtype=0;
int opentype = 0;
String formID="0";
String defaultsql="";
String searchconditiontype = "1";
String javafilename = "";
String showfield="";
String fromSql;
String sqlwhere="";
String formmodeid="0";
String tablename="";
String orderby = "t1.id";
String norightlist = "";
String backfields = " t1.id,t1.formmodeid,t1.modedatacreater,t1.modedatacreatertype,t1.modedatacreatedate,t1.modedatacreatetime ";

rs.execute("select a.defaultsql,a.modeid,a.customname,a.customdesc,a.formid,a.searchconditiontype,a.javafilename,a.pagenumber,a.norightlist from mode_custombrowser a  where   a.id="+customid);
if(rs.next()){
	formID=Util.null2String(rs.getString("formid"));
    formmodeid=Util.null2String(rs.getString("modeid"));
	defaultsql = Util.toScreenToEdit(rs.getString("defaultsql"),user.getLanguage()).trim();
	defaultsql = FormModeTransMethod.getDefaultSql(user,defaultsql);  
	
	searchconditiontype = Util.null2String(rs.getString("searchconditiontype"));
	searchconditiontype = searchconditiontype.equals("") ? "1" : searchconditiontype;
	javafilename = Util.null2String(rs.getString("javafilename"));
	if(perpage==10&&isCustomPageSize.equals("")){//\u9996\u6b21\u52a0\u8f7d\u6216\u4e0d\u6539\u53d8\u9875\u6570
		perpage = Util.getIntValue(Util.null2String(rs.getString("pagenumber")),10);
	}
	norightlist = Util.null2String(rs.getString("norightlist"));
	
}

if(istree.equals("1")){//\u6811\u7ec4\u5408\u67e5\u8be2\u4e00\u5f8b\u5f53\u4f5c\u65e0\u6743\u9650\u5217\u8868\u5bf9\u5f85
	norightlist = "1";
	formmodeid = "0";
}

//============================================\u865a\u62df\u8868\u57fa\u7840\u6570\u636e====================================
String vdatasource = "";	//\u865a\u62df\u8868\u5355\u6570\u636e\u6e90
String vprimarykey = "";	//\u865a\u62df\u8868\u5355\u4e3b\u952e\u5217\u540d\u79f0
String vdatasourceDBtype = "";	//\u6570\u636e\u5e93\u7c7b\u578b
boolean isVirtualForm = VirtualFormHandler.isVirtualForm(formID);	//\u662f\u5426\u662f\u865a\u62df\u8868\u5355
Map<String, Object> vFormInfo = new HashMap<String, Object>();
if(isVirtualForm){
	vFormInfo = VirtualFormHandler.getVFormInfo(formID);
	vdatasource = Util.null2String(vFormInfo.get("vdatasource"));	//\u865a\u62df\u8868\u5355\u6570\u636e\u6e90
	vprimarykey = Util.null2String(vFormInfo.get("vprimarykey"));	//\u865a\u62df\u8868\u5355\u4e3b\u952e\u5217\u540d\u79f0
	DataSourceXML dataSourceXML = new DataSourceXML();
	vdatasourceDBtype = dataSourceXML.getDataSourceDBType(vdatasource);
}else{
	vdatasourceDBtype = RecordSet.getDBType();
}

//============================================\u8868\u5355\u540d\u79f0====================================
rs.executeSql("select tablename from workflow_bill where id = " + formID);
if (rs.next()){
	tablename = rs.getString("tablename"); 
}
if(isVirtualForm){
	tablename= VirtualFormHandler.getRealFromName(tablename);
}
//============================================\u81ea\u5b9a\u4e49\u67e5\u8be2\u6761\u4ef6====================================
String sqlwhere_con="";
boolean isoracle = vdatasourceDBtype.equals("oracle") ;
boolean isdb2 = vdatasourceDBtype.equals("db2") ;
String createrid=Util.null2String(request.getParameter("createrid"));
String creatertype=Util.null2String(request.getParameter("creatertype"));
String fromdate=Util.null2String(request.getParameter("fromdate"));
String todate=Util.null2String(request.getParameter("todate"));

String[] checkcons = request.getParameterValues("check_con");
ArrayList ids = new ArrayList();
ArrayList colnames = new ArrayList();
ArrayList opts = new ArrayList();
ArrayList values = new ArrayList();
ArrayList names = new ArrayList();
ArrayList opt1s = new ArrayList();
ArrayList value1s = new ArrayList();
if(checkcons!=null){
	for(int i=0;i<checkcons.length;i++){
		String tmpid = ""+checkcons[i];
		String tmpcolname = ""+Util.null2String(request.getParameter("con"+tmpid+"_colname"));
		String htmltype = ""+Util.null2String(request.getParameter("con"+tmpid+"_htmltype"));
		String type = ""+Util.null2String(request.getParameter("con"+tmpid+"_type"));
		String tmpopt = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt"));
		String tmpvalue = ""+Util.null2String(request.getParameter("con"+tmpid+"_value"));
		String tmpname = ""+Util.null2String(request.getParameter("con"+tmpid+"_name"));
		String tmpopt1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt1"));
		String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_value1"));
		String multiselectValue = ""+Util.null2String(request.getParameter("multiselectValue_con"+tmpid+"_value"));
		if("".equals(tmpvalue)&&"".equals(tmpvalue1))continue;
		
		tmpvalue = tmpvalue.replace("'", "''");
		tmpvalue1 = tmpvalue1.replace("'", "''");
		if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){  //\u6587\u672c\u6846
			if(tmpopt.equals("1"))	sqlwhere_con+=" and (t1."+tmpcolname+" ='"+tmpvalue +"' ";
			else if(tmpopt.equals("2"))	sqlwhere_con+=" and (t1."+tmpcolname+" <>'"+tmpvalue +"' ";
			else if(tmpopt.equals("3")){
			    ArrayList tempvalues=Util.TokenizerString(Util.StringReplace(tmpvalue,"\u3000"," ")," ");
			    sqlwhere_con += " and (";
			    for(int k=0;k<tempvalues.size();k++){
			        if(k==0) sqlwhere_con += "t1."+tmpcolname;
			        else  sqlwhere_con += " or t1."+tmpcolname;
			        tmpvalue=Util.StringReplace(Util.StringReplace((String)tempvalues.get(k),"+","%"),"\uff0b","%");
			        if(!isoracle&&!isdb2){
			            int indx=tmpvalue.indexOf("[");
			            if(indx<0) indx=tmpvalue.indexOf("]");
			            if(indx<0){
			                sqlwhere_con += " like '%"+tmpvalue+"%' ";
			            }else{
			                sqlwhere_con += " like '%"+Util.StringReplace(Util.StringReplace(Util.StringReplace(tmpvalue,"/","//"),"[","/["),"]","/]")+"%' ESCAPE '/' ";
			            }
			        }else{
			            sqlwhere_con += " like '%"+tmpvalue+"%' ";
			        }
			    }
			}else if(tmpopt.equals("4")){
			    ArrayList tempvalues=Util.TokenizerString(Util.StringReplace(tmpvalue,"\u3000"," ")," ");
			    for(int k=0;k<tempvalues.size();k++){
			        if(k==0) sqlwhere_con += "and (t1."+tmpcolname;
			        else  sqlwhere_con += " and t1."+tmpcolname;
			        tmpvalue=Util.StringReplace(Util.StringReplace((String)tempvalues.get(k),"+","%"),"\uff0b","%");
			        if(!isoracle&&!isdb2){
			            int indx=tmpvalue.indexOf("[");
			            if(indx<0) indx=tmpvalue.indexOf("]");
			            if(indx<0){
			                sqlwhere_con += " not like '%"+tmpvalue+"%' ";
			            }else{
			                sqlwhere_con += " not like '%"+Util.StringReplace(Util.StringReplace(Util.StringReplace(tmpvalue,"/","//"),"[","/["),"]","/]")+"%' ESCAPE '/' ";
			            }
			        }else{
			            sqlwhere_con += " not like '%"+tmpvalue+"%' ";
			        }
			    }
			}
		} else if(htmltype.equals("1")&& !type.equals("1")){  //\u6570\u5b57   <!--\u5927\u4e8e,\u5927\u4e8e\u6216\u7b49\u4e8e,\u5c0f\u4e8e,\u5c0f\u4e8e\u6216\u7b49\u4e8e,\u7b49\u4e8e,\u4e0d\u7b49\u4e8e-->
			if(!tmpvalue.equals("")){
				if(type.equals("5")){//\u91d1\u989d\u8f6c\u6362
					if(rs.getDBType().equals("oracle")){
						sqlwhere_con += "and (cast((CASE WHEN (t1."+tmpcolname+"||'') is null THEN '0' WHEN (t1."+tmpcolname+"||'') =' ' THEN '0' ELSE Replace((t1."+tmpcolname+"||''), ',', '') END) as number(30,6))";
					}else{//\u91d1\u989d\u5343\u5206\u4f4d\u662fvarchar\u7c7b\u578b
						sqlwhere_con += "and (cast((CASE isnumeric (t1."+tmpcolname+") WHEN 0 THEN '0' WHEN 1 THEN replace(t1."+tmpcolname+",',','') ELSE '0' END) as decimal(30,6))";
					}
				}else{
					sqlwhere_con += "and (t1."+tmpcolname;
				}
				if(tmpopt.equals("1"))	sqlwhere_con+=" >"+tmpvalue +" ";
				if(tmpopt.equals("2"))	sqlwhere_con+=" >="+tmpvalue +" ";
				if(tmpopt.equals("3"))	sqlwhere_con+=" <"+tmpvalue +" ";
				if(tmpopt.equals("4"))	sqlwhere_con+=" <="+tmpvalue +" ";
				if(tmpopt.equals("5"))	sqlwhere_con+=" ="+tmpvalue +" ";
				if(tmpopt.equals("6"))	sqlwhere_con+=" <>"+tmpvalue +" ";
			}
			if(!tmpvalue1.equals("")){
					if(type.equals("5")){//\u91d1\u989d\u8f6c\u6362
						if(rs.getDBType().equals("oracle")){
							sqlwhere_con += "and cast((CASE WHEN (t1."+tmpcolname+"||'') is null THEN '0' WHEN (t1."+tmpcolname+"||'') =' ' THEN '0' ELSE Replace((t1."+tmpcolname+"||''), ',', '') END) as number(30,6))";
						}else{//\u91d1\u989d\u5343\u5206\u4f4d\u662fvarchar\u7c7b\u578b
							sqlwhere_con += "and cast((CASE isnumeric (t1."+tmpcolname+") WHEN 0 THEN '0' WHEN 1 THEN replace(t1."+tmpcolname+",',','') ELSE '0' END) as decimal(30,6))";
						}
					}else{
						sqlwhere_con += " and t1."+tmpcolname;
					}
					if(tmpopt1.equals("1"))	sqlwhere_con+=" >"+tmpvalue1 +" ";
					if(tmpopt1.equals("2"))	sqlwhere_con+=" >="+tmpvalue1 +" ";
					if(tmpopt1.equals("3"))	sqlwhere_con+=" <"+tmpvalue1 +" ";
					if(tmpopt1.equals("4"))	sqlwhere_con+=" <="+tmpvalue1 +" ";
				    if(tmpopt1.equals("5"))	sqlwhere_con+=" ="+tmpvalue1+" ";
					if(tmpopt1.equals("6"))	sqlwhere_con+=" <>"+tmpvalue1 +" ";
			}
		} else if(htmltype.equals("4")){   //check\u7c7b\u578b = !=
			sqlwhere_con += "and (t1."+tmpcolname;
			if(!tmpvalue.equals("1")) sqlwhere_con+="<>'1' ";
			else sqlwhere_con +="='1' ";
		} else if(htmltype.equals("5")){  //\u9009\u62e9\u6846   = !=
			if(!"".equals(multiselectValue)){
				sqlwhere_con += "and ( ";
				String multiselectSqlwhere_con="";
				String[] multiselectValue_tmpvalueArray  = multiselectValue.split(",");
				for(int n=0;n<multiselectValue_tmpvalueArray.length;n++){
					if("".equals(multiselectValue_tmpvalueArray[n])){
						continue;
					}
					multiselectSqlwhere_con+="t1."+tmpcolname;
					if(tmpopt.equals("1"))	
						multiselectSqlwhere_con+=" ="+multiselectValue_tmpvalueArray[n] +" or ";
					if(tmpopt.equals("2"))	
						multiselectSqlwhere_con+=" <>"+multiselectValue_tmpvalueArray[n] +" or ";
				}
				if(multiselectSqlwhere_con.length()>0){
					multiselectSqlwhere_con = multiselectSqlwhere_con.substring(0,multiselectSqlwhere_con.length()-3);
				}
				sqlwhere_con+=multiselectSqlwhere_con;
			}else{
				sqlwhere_con += "and (t1."+tmpcolname;
				if(tmpopt.equals("1"))	sqlwhere_con+=" ="+tmpvalue +" ";
				if(tmpopt.equals("2"))	sqlwhere_con+=" <>"+tmpvalue +" ";
			}
		}else if(htmltype.equals("8")){  //\u516c\u5171\u9009\u62e9\u9879   = !=
			sqlwhere_con += "and (t1."+tmpcolname;
			if(tmpopt.equals("1"))	sqlwhere_con+=" ="+tmpvalue +" ";
			if(tmpopt.equals("2"))	sqlwhere_con+=" <>"+tmpvalue +" ";
		} else if(htmltype.equals("3") && (type.equals("1")||type.equals("9")||type.equals("4")||type.equals("7")||type.equals("8")||type.equals("16"))){//\u6d4f\u89c8\u6846\u5355\u4eba\u529b\u8d44\u6e90  \u6761\u4ef6\u4e3a\u591a\u4eba\u529b (int  not  in),\u6761\u4ef6\u4e3a\u591a\u6587\u6321,\u6761\u4ef6\u4e3a\u591a\u90e8\u95e8,\u6761\u4ef6\u4e3a\u591a\u5ba2\u6237,\u6761\u4ef6\u4e3a\u591a\u9879\u76ee,\u6761\u4ef6\u4e3a\u591a\u8bf7\u6c42
			sqlwhere_con += "and (t1."+tmpcolname;
			if(tmpopt.equals("1"))	sqlwhere_con+=" in ("+tmpvalue +") ";
			if(tmpopt.equals("2"))	sqlwhere_con+=" not in ("+tmpvalue +") ";
		}else if(htmltype.equals("3") && type.equals("24")){//\u804c\u4f4d\u7684\u5b89\u5168\u7ea7\u522b > >= = < !  and > >= = < !
			if(!tmpvalue.equals("")){
				sqlwhere_con += "and (t1."+tmpcolname;
				if(tmpopt.equals("1"))	sqlwhere_con+=" >"+tmpvalue +" ";
				if(tmpopt.equals("2"))	sqlwhere_con+=" >="+tmpvalue +" ";
				if(tmpopt.equals("3"))	sqlwhere_con+=" <"+tmpvalue +" ";
				if(tmpopt.equals("4"))	sqlwhere_con+=" <="+tmpvalue +" ";
				if(tmpopt.equals("5"))	sqlwhere_con+=" ="+tmpvalue +" ";
				if(tmpopt.equals("6"))	sqlwhere_con+=" <>"+tmpvalue +" ";
			}
			if(!tmpvalue1.equals("")){
				sqlwhere_con += " and t1."+tmpcolname;
				if(tmpopt1.equals("1"))	sqlwhere_con+=" >"+tmpvalue1 +" ";
				if(tmpopt1.equals("2"))	sqlwhere_con+=" >="+tmpvalue1 +" ";
				if(tmpopt1.equals("3"))	sqlwhere_con+=" <"+tmpvalue1 +" ";
				if(tmpopt1.equals("4"))	sqlwhere_con+=" <="+tmpvalue1 +" ";
			    if(tmpopt1.equals("5"))	sqlwhere_con+=" ="+tmpvalue1+" ";
				if(tmpopt1.equals("6"))	sqlwhere_con+=" <>"+tmpvalue1 +" ";
			}
		}//\u804c\u4f4d\u5b89\u5168\u7ea7\u522bend
		else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //\u65e5\u671f > >= = < !  and > >= = < !
			if(!tmpvalue.equals("")){
				sqlwhere_con += "and (t1."+tmpcolname;
				if(tmpopt.equals("1"))	sqlwhere_con+=" >'"+tmpvalue +"' ";
				if(tmpopt.equals("2"))	sqlwhere_con+=" >='"+tmpvalue +"' ";
				if(tmpopt.equals("3"))	sqlwhere_con+=" <'"+tmpvalue +"' ";
				if(tmpopt.equals("4"))	sqlwhere_con+=" <='"+tmpvalue +"' ";
				if(tmpopt.equals("5"))	sqlwhere_con+=" ='"+tmpvalue +"' ";
				if(tmpopt.equals("6"))	sqlwhere_con+=" <>'"+tmpvalue +"' ";
			}
			if(!tmpvalue1.equals("")){
				sqlwhere_con += " and t1."+tmpcolname;
				if(tmpopt1.equals("1"))	sqlwhere_con+=" >'"+tmpvalue1 +"' ";
				if(tmpopt1.equals("2"))	sqlwhere_con+=" >='"+tmpvalue1 +"' ";
				if(tmpopt1.equals("3"))	sqlwhere_con+=" <'"+tmpvalue1 +"' ";
				if(tmpopt1.equals("4"))	sqlwhere_con+=" <='"+tmpvalue1 +"' ";
			    if(tmpopt1.equals("5"))	sqlwhere_con+=" ='"+tmpvalue1+"' ";
				if(tmpopt1.equals("6"))	sqlwhere_con+=" <>'"+tmpvalue1 +"' ";
			}
		} /* else if(htmltype.equals("3") && (type.equals("17")||type.equals("57")||type.equals("135")||type.equals("152")||type.equals("18")||type.equals("160"))){  //\u6d4f\u89c8\u6846  \u591a\u9009\u7b50\u6761\u4ef6\u4e3a\u5355\u9009\u7b50(\u591a\u6587\u6321) \u591a\u9009\u7b50\u6761\u4ef6\u4e3a\u5355\u9009\u7b50\uff08\u591a\u90e8\u95e8\uff09 \u591a\u9009\u7b50\u6761\u4ef6\u4e3a\u5355\u9009\u7b50\uff08\u591a\u9879\u76ee \uff09\u591a\u9009\u7b50\u6761\u4ef6\u4e3a\u5355\u9009\u7b50\uff08\u591a\u9879\u76ee \uff09
			if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
			      sqlwhere_con += "and (','||t1."+tmpcolname+"||','";
			else
			      sqlwhere_con += "and (','+CONVERT(varchar,t1."+tmpcolname+")+',' ";
			if(tmpopt.equals("1"))	sqlwhere_con+=" like '%,"+tmpvalue +",%' ";
			if(tmpopt.equals("2"))	sqlwhere_con+=" not like '%,"+tmpvalue +",%' ";
		}else if(htmltype.equals("3") && (type.equals("141")||type.equals("56")||type.equals("27")||type.equals("118")||type.equals("65")||type.equals("64")||type.equals("137")||type.equals("142"))){//\u6d4f\u89c8\u6846  
	 		if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
	       		sqlwhere_con += "and (','||t1."+tmpcolname+"||','";
			else
				sqlwhere_con += "and (','+CONVERT(varchar,t1."+tmpcolname+")+',' ";
			if(tmpopt.equals("1"))	sqlwhere_con+=" like '%,"+tmpvalue +",%' ";
			if(tmpopt.equals("2"))	sqlwhere_con+=" not like '%,"+tmpvalue +",%' ";
		} else if (htmltype.equals("3")){   //\u5176\u4ed6\u6d4f\u89c8\u6846
			if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
				sqlwhere_con += "and (','||t1."+tmpcolname+"||','";
			else
				sqlwhere_con += "and (','+CONVERT(varchar,t1."+tmpcolname+")+',' ";
			if(tmpopt.equals("1"))	sqlwhere_con+=" like '%,"+tmpvalue +",%' ";
			if(tmpopt.equals("2"))	sqlwhere_con+=" not like '%,"+tmpvalue +",%' ";
		} else if (htmltype.equals("6")){   //\u9644\u4ef6\u4e0a\u4f20\u540c\u591a\u6587\u6321
			if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
				sqlwhere_con += "and (','||t1."+tmpcolname+"||','";
			else
				sqlwhere_con += "and (','+CONVERT(varchar,t1."+tmpcolname+")+',' ";
			if(tmpopt.equals("1"))	sqlwhere_con+=" like '%,"+tmpvalue +",%' ";
			if(tmpopt.equals("2"))	sqlwhere_con+=" not like '%,"+tmpvalue +",%' ";
		} */
		else if (htmltype.equals("3") && "141".equals(type)){
			List<String> tmpvalueArray = null;
			if(FormModeBrowserUtil.isMultiBrowser(htmltype, type)) {
				tmpvalueArray = Util.splitString2List(tmpvalue, "~");
			} else {
				tmpvalueArray = new ArrayList<String>();
				tmpvalueArray.add(tmpvalue);
			}
			sqlwhere_con += " and ( ";
			boolean first  = true;
			for(String _tmpvalue : tmpvalueArray) {
				if(first) {
					first = false;
				} else {
					sqlwhere_con += " and ";
				}
				if(vdatasourceDBtype.equalsIgnoreCase("oracle") || vdatasourceDBtype.equalsIgnoreCase("db2"))
					sqlwhere_con += " t1."+tmpcolname+" ";
				else if(vdatasourceDBtype.equals("mysql"))
					sqlwhere_con += " t1."+tmpcolname+" ";
				else
					sqlwhere_con += " CONVERT(varchar(max),t1."+tmpcolname+") ";
				if(tmpopt.equals("1"))	sqlwhere_con+=" like '%"+_tmpvalue +"%' ";
				if(tmpopt.equals("2"))	sqlwhere_con+=" not like '%"+_tmpvalue +"%' ";
			}
		}
		else if (htmltype.equals("3") || htmltype.equals("6")){   //\u5176\u4ed6\u6d4f\u89c8\u6846
			List<String> tmpvalueArray = null;
			if(FormModeBrowserUtil.isMultiBrowser(htmltype, type)) {
				tmpvalueArray = Util.splitString2List(tmpvalue, ",");
			} else {
				tmpvalueArray = new ArrayList<String>();
				tmpvalueArray.add(tmpvalue);
			}
			sqlwhere_con += " and ( ";
			boolean first  = true;
			for(String _tmpvalue : tmpvalueArray) {
				if(first) {
					first = false;
				} else {
					sqlwhere_con += " and ";
				}
				if(vdatasourceDBtype.equalsIgnoreCase("oracle") || vdatasourceDBtype.equalsIgnoreCase("db2"))
					sqlwhere_con += " ','||t1."+tmpcolname+"||',' ";
				else if(vdatasourceDBtype.equals("mysql"))
					sqlwhere_con += " CONCAT(',',t1."+tmpcolname+",',') ";
				else
					sqlwhere_con += " ','+CONVERT(varchar(max),t1."+tmpcolname+")+',' ";
				if(tmpopt.equals("1"))	sqlwhere_con+=" like '%,"+_tmpvalue +",%' ";
				if(tmpopt.equals("2"))	sqlwhere_con+=" not like '%,"+_tmpvalue +",%' ";
			}
		}
		if (htmltype.equals("1")|| htmltype.equals("2")||(htmltype.equals("3") && (type.equals("1")||type.equals("9")||type.equals("4")||type.equals("7")||type.equals("8")||type.equals("16")))||(htmltype.equals("3") && type.equals("24"))||(htmltype.equals("3") &&( type.equals("2") || type.equals("19")))) {
			if(!tmpvalue.equals("")){
				sqlwhere_con +=") ";
			}
		}else{
			sqlwhere_con +=") ";
		}
	}
}
//============================================\u9700\u8981\u663e\u793a\u7684\u5b57\u6bb5====================================
Map<String,Object> showfieldMap=new LinkedHashMap<String,Object>();
if(isVirtualForm){
	backfields = " t1." + vprimarykey + " ";
} else {
	rs.executeSql("select * from "+tablename+ " where 1=2 ");
	String[] columnName = rs.getColumnName();
	boolean hasFormmodeid = false;
	for(int i = 0; i<columnName.length;i++) {
		if("formmodeid".equalsIgnoreCase(columnName[i])) {
			hasFormmodeid = true;
			break;
		}
	}
	if(!hasFormmodeid){
		backfields = " t1.id ";
	}
}
String pkfield = "";
String sql = "select workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type,mode_custombrowserdspfield.showorder,mode_custombrowserdspfield.istitle,mode_custombrowserdspfield.ispk" +
            " from workflow_billfield,mode_custombrowserdspfield,Mode_CustomBrowser where mode_custombrowserdspfield.customid=Mode_CustomBrowser.id and Mode_CustomBrowser.id="+customid+
            " and mode_custombrowserdspfield.isshow='1' and workflow_billfield.billid="+formID+" and workflow_billfield.viewtype=0 and workflow_billfield.id=mode_custombrowserdspfield.fieldid" +
            " union select mode_custombrowserdspfield.fieldid as id,'1' as name,2 as label,'3' as dbtype, '4' as httype,5 as type ,mode_custombrowserdspfield.showorder,mode_custombrowserdspfield.istitle,mode_custombrowserdspfield.ispk" +
            " from mode_custombrowserdspfield ,Mode_CustomBrowser where mode_custombrowserdspfield.customid=Mode_CustomBrowser.id and Mode_CustomBrowser.id="+customid+
            " and mode_custombrowserdspfield.isshow='1'  and mode_custombrowserdspfield.fieldid<0" +
            " order by istitle desc,showorder asc,id asc";
RecordSet.executeSql(sql);
String showfieldname = "";
while (RecordSet.next()){
	String id=Util.null2String(RecordSet.getString("id"));
	if("-1".equals(id)){
		showfieldMap.put("modedatacreatedate", "modedatacreatetime");
		showfieldname +=",modedatacreatetime";
	}else if("-2".equals(id)){
		showfieldMap.put("modedatacreater", "modedatacreatertype");
		showfieldname +=",modedatacreatertype";
	}else{
		String name=Util.null2String(RecordSet.getString("name"));
		String dbtype=Util.null2String(RecordSet.getString("dbtype"));
		String label = RecordSet.getString("label");
		String htmltype = RecordSet.getString("httype");
		String type = RecordSet.getString("type");
		String istitle = RecordSet.getString("istitle");
		String hreflink = RecordSet.getString("hreflink");
		String ispk = RecordSet.getString("ispk");
		if("1".equals(ispk)){
			pkfield = name;
		}
		showfieldname +=","+name;
		if(dbtype.toLowerCase().equals("text")){
			if(isoracle){
				showfield=showfield+","+"to_char(t1."+name+") as "+name;
			}else{
				showfield=showfield+","+"convert(varchar(4000),t1."+name+") as "+name;
			}
		}else{
			if(backfields.toUpperCase().indexOf(("t1."+name).toUpperCase())==-1){
				showfield=showfield+","+"t1."+name;
			}
		}
		if(isVirtualForm){
		    if(formmodeid.equals("0")){
		    	formmodeid = "virtual";
		    }
		}
		String para3="column:id+"+id+"+"+htmltype+"+"+type+"+"+user.getLanguage()+"+"+isbill+"+"+dbtype+"+"+istitle+"+"+formmodeid+"+"+formID+"+"+viewtype+"+"+opentype+"+"+customid+"+fromsearchlist"+"+"+hreflink;
		showfieldMap.put(name,para3);
	}
}
List<User> lsUser = ModeRightInfo.getAllUserCountList(user);
backfields=backfields+showfield;
if(isVirtualForm){	//\u662f\u865a\u62df\u8868\u5355
	fromSql  = " from "+tablename+" t1 ";
	if(sqlwhere.equals("")){
		sqlwhere = " where 1=1";
	}
}else if(norightlist.equals("1")){
	  fromSql  = " from "+tablename+" t1 " ;
	  if(sqlwhere.equals("")){
			sqlwhere = " where 1=1 ";
	  }
	  if(!(formmodeid.equals("")||formmodeid.equals("0"))){//\u6d4f\u89c8\u6846\u4e2d\u8bbe\u7f6e\u4e86\u6a21\u5757
		  sqlwhere += " and t1.formmodeid="+formmodeid+" ";
	  }
}else{
	String rightsql = "";
	if(formmodeid.equals("")||formmodeid.equals("0")){//\u6d4f\u89c8\u6846\u4e2d\u6ca1\u6709\u8bbe\u7f6e\u6a21\u5757
		String sqlStr1 = "select id,modename from modeinfo where formid="+formID+" order by id";
		RecordSet rs1 = new RecordSet();
		rs1.executeSql(sqlStr1);
		while(rs1.next()){
			String mid = rs1.getString("id");
			ModeShareManager.setModeId(Util.getIntValue(mid,0));
			for(int i=0;i<lsUser.size();i++){
				User tempUser = lsUser.get(i);
				String tempRightStr = ModeShareManager.getShareDetailTableByUser("formmode",tempUser);
				if(rightsql.isEmpty()){
					rightsql += tempRightStr;
				}else {
					rightsql += " union  all "+ tempRightStr;
				}
			}
		}
		if(!rightsql.isEmpty()){
			rightsql = " (SELECT  sourceid,MAX(sharelevel) AS sharelevel from ( "+rightsql+" ) temptable group by temptable.sourceid) ";
		}
	}else{
		ModeShareManager.setModeId(Util.getIntValue(formmodeid,0));
		for(int i=0;i<lsUser.size();i++){
			User tempUser = (User)lsUser.get(i);
			String tempRightStr = ModeShareManager.getShareDetailTableByUser("formmode",tempUser);
			if(rightsql.isEmpty()){
				rightsql += tempRightStr;
			}else {
				rightsql += " union  all "+ tempRightStr;
			}
		}
		if(!rightsql.isEmpty()){
			rightsql = " (SELECT  sourceid,MAX(sharelevel) AS sharelevel from ( "+rightsql+" ) temptable group by temptable.sourceid) ";
		}
	}
	
    fromSql  = " from "+tablename+" t1,"+rightsql+" t2 " ;
	if(sqlwhere.equals("")){
		sqlwhere = " where t1.id = t2.sourceid";
	}else{
		sqlwhere += " and t1.id = t2.sourceid";
	}
}

if(!"".equals(sqlwhereparam)){
	//sqlwhereparam=URLDecoder.decode(sqlwhereparam);
	sqlwhere+=" and "+sqlwhereparam.trim();
}
sqlwhere_con=sqlwhere_con.trim();
if(!"".equals(sqlwhere_con)){
	if(sqlwhere_con.toLowerCase().trim().startsWith("and ")){
		sqlwhere+=" "+sqlwhere_con;
	}else{
		sqlwhere+=" and "+sqlwhere_con;
	}
}

String sqlCondition = "";
if(istree.equals("1")){
	String conditionStr = "select datacondition from mode_customtreedetail where mainid="+treeid;
	rs.executeSql(conditionStr);
	if(rs.next()){
		sqlCondition = rs.getString("datacondition");
		if(!StringHelper.isEmpty(sqlCondition)){
			CustomTreeData customTreeData = new CustomTreeData();
			sqlCondition = customTreeData.replaceParam(sqlCondition);
		}
	}
}else{
	if(searchconditiontype.equals("2")){	//java file
		if(!javafilename.equals("")){
			Map<String, String> sourceCodePackageNameMap = CommonConstant.SOURCECODE_PACKAGENAME_MAP;
			String sourceCodePackageName = sourceCodePackageNameMap.get("3");
			String classFullName = sourceCodePackageName + "." + javafilename;
			
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("user", user);
			
			Object result = CustomJavaCodeRun.run(classFullName, param);
			sqlCondition = Util.null2String(result);
		}
	}else{
		sqlCondition = defaultsql;
	}
}

if(!sqlCondition.equals("")){
	sqlCondition = "(" + sqlCondition + ")";
	sqlwhere = sqlwhere + " and "+sqlCondition;
}

String sqlprimarykey = "t1.id";
String pkfieldname = "";
if(isVirtualForm){	//\u865a\u62df\u8868\u5355
	sqlprimarykey = "t1." + vprimarykey;
	pkfieldname = vprimarykey;
	pkfield = vprimarykey;
	BrowserInfoService browserInfoService=new BrowserInfoService();
	orderby = browserInfoService.getOrderSQL(customid);
	if(StringHelper.isEmpty(orderby)){
		orderby = "t1." + vprimarykey;
	}
} else { //\u5b9e\u9645\u8868\u5355
	BrowserInfoService browserInfoService=new BrowserInfoService();
	orderby = browserInfoService.getOrderSQL(customid);
	if("".equals(pkfield)){
		sqlprimarykey = "id";
	}else{
		sqlprimarykey = "t1."+pkfield;
		pkfieldname = pkfield;
		vprimarykey = pkfield;
	}
	
}

if(src.equalsIgnoreCase("dest")){//\u53f3\u4fa7\u5df2\u9009\u62e9\u5217\u8868\u7684sql\u6761\u4ef6
	if("".equals(check_per)){
		check_per="999999999";
	}else{
		check_per = check_per.replaceAll("&gt;",">");
		check_per = check_per.replaceAll("&lt;","<");
		check_per = check_per.replaceAll("&amp;","&");
	}
	
	String dbtypeStr = rs.getDBType();
	if(isVirtualForm){
		dbtypeStr = rs.getDBType(vdatasource);
		check_per = check_per.replaceAll(",", "','");
	}

	if(dbtypeStr.equals("oracle")){//Oracle\u8fd9\u91cc\u6539\u53d8in\u7684\u5199\u6cd5\uff0c\u5426\u5219Oracle 10g \u7248\u672c\u7684\u6570\u636e\u5e93\u4f1a\u6709bug 
		if(isVirtualForm){
			sqlwhere += " and exists (select 1 from "+tablename+" where t1."+vprimarykey+" in ('"+check_per+"')) ";
		}else{
			if(!"".equals(pkfield)){
				check_per = check_per.replaceAll(",", "','");
				sqlwhere += " and exists (select 1 from "+tablename+" where  t1."+pkfield+" in ('"+check_per+"')) ";
			}else{
				sqlwhere += " and exists (select 1 from "+tablename+" where  t1.id in ("+check_per+")) ";
			}
		}
	}else{
		if(isVirtualForm){
			sqlwhere += " and t1."+vprimarykey+" in ('"+check_per+"')";
		}else{
			if(!"".equals(pkfield)){
				check_per = check_per.replaceAll(",", "','");
				sqlwhere += " and t1."+pkfield+" in ('"+check_per+"')";
			}else{
				sqlwhere += " and t1.id in ("+check_per+")";
			}
		}
	}
}else if(src.equalsIgnoreCase("src")){
	//\u5c4f\u853d\u5df2\u9009\u6570\u636e
	String excludeId=Util.null2String(request.getParameter("excludeId"));
	if(excludeId.length()==0)excludeId=check_per;
	if(excludeId.length()>0){
		if(isVirtualForm){
			sqlwhere += " and t1."+vprimarykey+" not in ("+excludeId+")";
		}else{
			if(!"".equals(pkfield)){
				check_per = check_per.replaceAll(",", "','");
				sqlwhere += " and t1."+pkfield+" not in ('"+excludeId+"')";
			}else{
				sqlwhere += " and t1.id not in ("+excludeId+")";
			}
		}
	}
}
SplitPageParaBean spp = new SplitPageParaBean();

spp.setBackFields(backfields);
spp.setSqlFrom(fromSql);
spp.setSqlWhere(sqlwhere);
spp.setSqlOrderBy(orderby);
spp.setPrimaryKey(sqlprimarykey);
spp.setPoolname(vdatasource);
spp.setDistinct(false);
spp.setSortWay(spp.DESC);
SplitPageUtil spu = new SplitPageUtil();
spu.setSpp(spp);


int totalPage=0;
if("dest".equalsIgnoreCase(src)){
	pagenum=1;
	totalPage=1;
	rs=spu.getAllRs();
}else if("src".equalsIgnoreCase(src)){
	int RecordSetCounts=0;
	RecordSetCounts = spu.getRecordCount();
	totalPage = RecordSetCounts/perpage;
	if(totalPage%perpage>0||totalPage==0){
		totalPage++;
	}
	rs = spu.getCurrentPageRs(pagenum, perpage);
}

JSONArray jsonArr = new JSONArray();
while(rs.next()) {
	JSONObject tmp = new JSONObject();
	String id = "";
	if(!isVirtualForm){
		if(!"".equals(pkfield)){
			id=rs.getStringNoTrim(vprimarykey);
			id = Util.toHtmlForSplitPage(id);
		}else{
			id=rs.getStringNoTrim("id");
		}	
	}else{
		id=rs.getStringNoTrim(vprimarykey);
	}
	Iterator<Map.Entry<String,Object>> it=showfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Map.Entry<String,Object> entity=it.next();
		String fieldName=entity.getKey();
		String paraTwo=Util.null2String(entity.getValue());
		String fieldValue=Util.null2String(rs.getString(fieldName));

		if(!"".equals(pkfield)){
			paraTwo+="+"+pkfield;
		}
		if("modedatacreatedate".equals(fieldName)){
			fieldValue=FormModeTransMethod.getSearchResultCreateTime(fieldValue,rs.getString(paraTwo));
		}else if("modedatacreater".equals(fieldName)){
			fieldValue=FormModeTransMethod.getSearchResultName(fieldValue, rs.getString(paraTwo));
		}else{
			fieldValue = Util.formatMultiLang(fieldValue, user.getLanguage()+"");
			if(id.contains("+")){
				id = id.replace("+", "weaver2017");
			}
			//paraTwo =  paraTwo.replaceFirst("column:id", id);
			paraTwo = id+paraTwo.substring("column:id".length());
			fieldValue=FormModeTransMethod.getBrowserOthers(fieldValue,paraTwo);
		}
		tmp.put(fieldName,fieldValue);
	}
	tmp.put("id",id);
	jsonArr.add(tmp);
}
if("dest".equalsIgnoreCase(src)&&!check_per.contains("+")){
	ComparatorUtil.sortJSONArrayByKeyss(jsonArr,"id",check_per);
}
JSONObject json = new JSONObject();
json.put("currentPage", pagenum);
json.put("totalPage", totalPage);
json.put("mapList",jsonArr.toString());
if(isVirtualForm){
	json.put("showfieldname",showfieldname);
	json.put("pkfieldname",pkfieldname);
}
out.println(json.toString());

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/browser/CommonMultiBrowserAjax.jsp"), 8342609638033824053L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string1;
  private final static char []_jsp_string0;
  private final static char []_jsp_string2;
  static {
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\r\n\r\n".toCharArray();
  }
}
