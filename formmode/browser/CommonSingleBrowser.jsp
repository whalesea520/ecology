<%@page import="weaver.formmode.browser.FormModeBrowserUtil"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.servicefiles.DataSourceXML"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="weaver.formmode.service.CommonConstant"%>
<%@page import="weaver.formmode.customjavacode.CustomJavaCodeRun"%>
<%@page import="weaver.formmode.service.BrowserInfoService"%>
<%@page import="weaver.interfaces.workflow.browser.BrowserBean"%>
<%@page import="weaver.formmode.data.FieldInfo"%>
<%@page import="weaver.formmode.tree.CustomTreeData"%>
<%@ page import="java.math.BigDecimal" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsm" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="selectRs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="FormModeTransMethod" class="weaver.formmode.search.FormModeTransMethod" scope="page"/>
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.formmode.excel.ModeCacheManager"%>
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="FormModeBrowserSqlwhere" class="weaver.formmode.browser.FormModeBrowserSqlwhere" scope="page"/>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
//============================================重要参数====================================
String istree = Util.null2String(request.getParameter("istree"));//是否树的组合查询
String treeid = Util.null2String(request.getParameter("treeid"));
String treenodeid = Util.null2String(request.getParameter("treenodeid"));

String customid=Util.null2String(request.getParameter("customid"));
String browsertype=Util.null2String(request.getParameter("browsertype"));

//先加载下缓存
ModeCacheManager.getInstance().loadCacheNow("", "", customid);

//============================================一般参数====================================
String nodetype=Util.null2String(request.getParameter("nodetype"));
int isdeleted=Util.getIntValue(request.getParameter("isdeleted"));
String requestlevel=Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());
int viewtype=Util.getIntValue(request.getParameter("viewtype"),0);
//链接地址中sqlwhere
String sqlwhereparam=Util.null2String(request.getParameter("sqlwhere"));

String tempquerystring = Util.null2String(request.getQueryString());
tempquerystring = tempquerystring.replace("sqlcondition", "SQLCONDITION");//手动搜索清除sqlcondition
String[] tempquerystrings = tempquerystring.split("&");
for(int i=0;i<tempquerystrings.length;i++){
	String tmpqs = tempquerystrings[i];
	if(StringHelper.isEmpty(tmpqs)){
		continue;
	}
}

//是否为预览
boolean isview="1".equals(Util.null2String(request.getParameter("isview")));

//============================================常数====================================
String imagefilename = "/images/hdDOC_wev8.gif";
String needfav ="1";
String needhelp ="";

//============================================browser框基础数据====================================
boolean issimple = true;
int isresearch=1;
String isbill="1";
String formID="0";
String customname=SystemEnv.getHtmlLabelName(21002,user.getLanguage());//自定义单选
String workflowname="";
String titlename ="";
String defaultsql="";
int opentype = 0;
int perpage=10;
String sql="";
String sqlwhere="";

String searchconditiontype = "1";
String javafilename = "";
String href="";
String javafileAddress="";

if(!"".equals(browsertype)){
	Browser browser=(Browser)StaticObj.getServiceByFullname(browsertype, Browser.class);
	href = Util.null2String(browser.getHref());

	if("".equals(customid)){
		sql = "select b.id from datashowset a,mode_custombrowser b where showname='"+browsertype.replace("browser.","")+"' and a.customid=b.id";
		RecordSet.executeSql(sql);
		if(RecordSet.next()){
			customid=RecordSet.getString("id");
		}
	}
}

if("".equals(customid)){
	out.println(SystemEnv.getHtmlLabelName(81939,user.getLanguage()));//browser框id不能为空！
	return;
}
String norightlist = "";
rs.execute("select a.defaultsql,a.modeid,a.customname,a.customdesc,a.formid,a.searchconditiontype,a.javafilename,a.pagenumber,a.norightlist,a.javafileAddress from mode_custombrowser a  where   a.id="+customid);
if(rs.next()){
    formID=Util.null2String(rs.getString("formid"));
    customname=Util.null2String(rs.getString("customname"));
    titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+customname;
    defaultsql = Util.toScreenToEdit(rs.getString("defaultsql"),user.getLanguage()).trim();
    defaultsql = FormModeTransMethod.getDefaultSql(user,defaultsql);
    
    searchconditiontype = Util.null2String(rs.getString("searchconditiontype"));
	searchconditiontype = searchconditiontype.equals("") ? "1" : searchconditiontype;
	javafilename = Util.null2String(rs.getString("javafilename"));
	perpage = Util.getIntValue(Util.null2String(rs.getString("pagenumber")),10);
	norightlist = Util.null2String(rs.getString("norightlist"));
	javafileAddress = Util.null2String(rs.getString("javafileAddress"));
}
if(istree.equals("1")){//树组合查询一律当作无权限列表对待
	norightlist = "1";
	perpage = 10;
}

boolean bflag = false;
if(!href.isEmpty()&&href.indexOf("modeId=0")!=-1){
	bflag = true;
}

//============================================虚拟表基础数据====================================
String vdatasource = "";	//虚拟表单数据源
String vprimarykey = "";	//虚拟表单主键列名称
String vdatasourceDBtype = "";	//数据库类型
boolean isVirtualForm = VirtualFormHandler.isVirtualForm(formID);	//是否是虚拟表单
Map<String, Object> vFormInfo = new HashMap<String, Object>();
if(isVirtualForm){
	vFormInfo = VirtualFormHandler.getVFormInfo(formID);
	vdatasource = Util.null2String(vFormInfo.get("vdatasource"));	//虚拟表单数据源
	vprimarykey = Util.null2String(vFormInfo.get("vprimarykey"));	//虚拟表单主键列名称
	DataSourceXML dataSourceXML = new DataSourceXML();
	vdatasourceDBtype = dataSourceXML.getDataSourceDBType(vdatasource);
}else{
	vdatasourceDBtype = RecordSet.getDBType();
}

//============================================自定义查询条件====================================
String sqlwhere_con="";
boolean isoracle = vdatasourceDBtype.equals("oracle") ;
boolean isdb2 = vdatasourceDBtype.equals("db2") ;

String[] checkcons = request.getParameterValues("check_con");
ArrayList ids = new ArrayList();
ArrayList colnames = new ArrayList();
ArrayList opts = new ArrayList();
ArrayList values = new ArrayList();
ArrayList names = new ArrayList();
ArrayList opt1s = new ArrayList();
ArrayList value1s = new ArrayList();
Hashtable conht=new Hashtable();
//链接地址中sqlcondition
String sqlcondition = Util.null2String(request.getParameter("sqlcondition"));

List<String> checkconlist = new ArrayList<String>();
if(checkcons!=null){
	for(String checkcon:checkcons){
		checkconlist.add(checkcon);
	}
}
if(!sqlcondition.equals("")){
	String[] sqlconditions = sqlcondition.split(" and ");
	for(String condition:sqlconditions){
		int dindex = condition.indexOf("=");
		if(dindex==-1){
			continue;
		}
		String key = condition.substring(0,dindex);
		String value = condition.substring(dindex+1);
		checkconlist.add(key+"|"+value);
	}
}

if(!checkconlist.isEmpty()){
	for(int i=0;i<checkconlist.size();i++){
		String tmpid = ""+checkconlist.get(i);
		String tmpcolname = "",htmltype="",type="",tmpopt="",tmpvalue="",tmpname="",tmpopt1="",tmpvalue1="",multiselectValue="";
		if(tmpid.indexOf("|")==-1){
			tmpcolname = ""+Util.null2String(request.getParameter("con"+tmpid+"_colname"));
			htmltype = ""+Util.null2String(request.getParameter("con"+tmpid+"_htmltype"));
			type = ""+Util.null2String(request.getParameter("con"+tmpid+"_type"));
			tmpopt = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt"));
			tmpvalue = ""+Util.null2String(request.getParameter("con"+tmpid+"_value"));
			tmpname = ""+Util.null2String(request.getParameter("con"+tmpid+"_name"));
			tmpopt1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_opt1"));
			tmpvalue1 = ""+Util.null2String(request.getParameter("con"+tmpid+"_value1"));
			multiselectValue = ""+Util.null2String(request.getParameter("multiselectValue_con"+tmpid+"_value"));
		}else{
			tmpcolname = tmpid.split("\\|",-1)[0];
			htmltype = tmpid.split("\\|",-1)[2];
			type = tmpid.split("\\|",-1)[3];
			String _value = tmpid.split("\\|",-1)[4];
			tmpvalue = _value;
			tmpname = _value;
			tmpvalue1 = _value;
			multiselectValue = _value;
			tmpid = tmpid.split("\\|",-1)[1];
			if("1".equals(htmltype)&& type.equals("1")){
				tmpopt = "3";
			}else if(htmltype.equals("2")){
				tmpopt = "3";
			}else if(htmltype.equals("1")
				&&(type.equals("2")||type.equals("3")||type.equals("4")||type.equals("5"))){
				tmpopt="2";
    			tmpopt1="4";
    			if(_value.split("-",-1).length==2){
    				tmpvalue = _value.split("-",-1)[0];
    				tmpvalue1 = _value.split("-",-1)[1];
    			}else{
    				tmpvalue1 = "";
    			}
			}else if(htmltype.equals("3")){
				tmpopt = "1";
				if(type.equals("24")){
					tmpopt1="3";
				}else if(type.equals("2") || type.equals("19")){
					tmpopt="2";
    				tmpopt1="4";
				}
			}else if(htmltype.equals("4")){
			
			}else if(htmltype.equals("5")){
				tmpopt = "1";
			}
		}
		if("".equals(tmpvalue)&&"".equals(tmpvalue1))continue;
		conht.put("con_"+tmpid,"1");
		conht.put("con_"+tmpid+"_opt",tmpopt);
		conht.put("con_"+tmpid+"_opt1",tmpopt1);
		conht.put("con_"+tmpid+"_value",tmpvalue);
		conht.put("con_"+tmpid+"_value1",tmpvalue1);
		conht.put("con_"+tmpid+"_name",tmpname);
		conht.put("multiselectValue_con"+tmpid+"_value", multiselectValue);
		tmpvalue = tmpvalue.replace("'", "''");
		tmpvalue1 = tmpvalue1.replace("'", "''");
		if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){  //文本框
			if(tmpopt.equals("1"))	sqlwhere_con+=" and (t1."+tmpcolname+" ='"+tmpvalue +"' ";
			else if(tmpopt.equals("2"))	sqlwhere_con+=" and (t1."+tmpcolname+" <>'"+tmpvalue +"' ";
			else if(tmpopt.equals("3")){
			    ArrayList tempvalues=Util.TokenizerString(Util.StringReplace(tmpvalue,"　"," ")," ");
			    sqlwhere_con += " and (";
			    for(int k=0;k<tempvalues.size();k++){
			        if(k==0) sqlwhere_con += "t1."+tmpcolname;
			        else  sqlwhere_con += " or t1."+tmpcolname;
			        tmpvalue=Util.StringReplace(Util.StringReplace((String)tempvalues.get(k),"+","%"),"＋","%");
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
			    ArrayList tempvalues=Util.TokenizerString(Util.StringReplace(tmpvalue,"　"," ")," ");
			    for(int k=0;k<tempvalues.size();k++){
			        if(k==0) sqlwhere_con += "and (t1."+tmpcolname;
			        else  sqlwhere_con += " and t1."+tmpcolname;
			        tmpvalue=Util.StringReplace(Util.StringReplace((String)tempvalues.get(k),"+","%"),"＋","%");
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
		} else if(htmltype.equals("1")&& !type.equals("1")){  //数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->
			if(!tmpvalue.equals("")){
				if(type.equals("5")){//金额转换
					if(rs.getDBType().equals("oracle")){
						sqlwhere_con += "and (cast((CASE WHEN (t1."+tmpcolname+"||'') is null THEN '0' WHEN (t1."+tmpcolname+"||'') =' ' THEN '0' ELSE Replace((t1."+tmpcolname+"||''), ',', '') END) as number(30,6))";
					}else{//金额千分位是varchar类型
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
					if(type.equals("5")){//金额转换
						if(rs.getDBType().equals("oracle")){
							sqlwhere_con += "and cast((CASE WHEN (t1."+tmpcolname+"||'') is null THEN '0' WHEN (t1."+tmpcolname+"||'') =' ' THEN '0' ELSE Replace((t1."+tmpcolname+"||''), ',', '') END) as number(30,6))";
						}else{//金额千分位是varchar类型
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
		} else if(htmltype.equals("4")){   //check类型 = !=
			sqlwhere_con += "and (t1."+tmpcolname;
			if(!tmpvalue.equals("1")) sqlwhere_con+="<>'1' ";
			else sqlwhere_con +="='1' ";
		} else if(htmltype.equals("5")){  //选择框   = !=
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
		}else if(htmltype.equals("8")){  //公共选择项   = !=
			sqlwhere_con += "and (t1."+tmpcolname;
			if(tmpopt.equals("1"))	sqlwhere_con+=" ="+tmpvalue +" ";
			if(tmpopt.equals("2"))	sqlwhere_con+=" <>"+tmpvalue +" ";
		} else if(htmltype.equals("3") && (type.equals("1")||type.equals("9")||type.equals("4")||type.equals("7")||type.equals("8")||type.equals("16"))){//浏览框单人力资源  条件为多人力 (int  not  in),条件为多文挡,条件为多部门,条件为多客户,条件为多项目,条件为多请求
			sqlwhere_con += "and (t1."+tmpcolname;
			if(tmpopt.equals("1"))	sqlwhere_con+=" in ("+tmpvalue +") ";
			if(tmpopt.equals("2"))	sqlwhere_con+=" not in ("+tmpvalue +") ";
		}else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别 > >= = < !  and > >= = < !
			if(!tmpvalue.equals("")){
				sqlwhere_con += "and (t1."+tmpcolname;
				if(tmpopt.equals("1"))	sqlwhere_con+=" = "+tmpvalue +" ";
				if(tmpopt.equals("2"))	sqlwhere_con+=" <>"+tmpvalue +" ";
			}
			if(!tmpvalue1.equals("")){
				sqlwhere_con += " and t1."+tmpcolname;
				if(tmpopt1.equals("1"))	sqlwhere_con+=" ="+tmpvalue1 +" ";
				if(tmpopt1.equals("2"))	sqlwhere_con+=" <>"+tmpvalue1 +" ";
			}
		}//职位安全级别end
		else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //日期 > >= = < !  and > >= = < !
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
		} /* else if(htmltype.equals("3") && (type.equals("17")||type.equals("57")||type.equals("135")||type.equals("152")||type.equals("18")||type.equals("160"))){  //浏览框  多选筐条件为单选筐(多文挡) 多选筐条件为单选筐（多部门） 多选筐条件为单选筐（多项目 ）多选筐条件为单选筐（多项目 ）
			if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
			      sqlwhere_con += "and (','||t1."+tmpcolname+"||','";
			else
			      sqlwhere_con += "and (','+CONVERT(varchar,t1."+tmpcolname+")+',' ";
			if(tmpopt.equals("1"))	sqlwhere_con+=" like '%,"+tmpvalue +",%' ";
			if(tmpopt.equals("2"))	sqlwhere_con+=" not like '%,"+tmpvalue +",%' ";
		}else if(htmltype.equals("3") && (type.equals("141")||type.equals("56")||type.equals("27")||type.equals("118")||type.equals("65")||type.equals("64")||type.equals("137")||type.equals("142"))){//浏览框  
	 		if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
	       		sqlwhere_con += "and (','||t1."+tmpcolname+"||','";
			else
				sqlwhere_con += "and (','+CONVERT(varchar,t1."+tmpcolname+")+',' ";
			if(tmpopt.equals("1"))	sqlwhere_con+=" like '%,"+tmpvalue +",%' ";
			if(tmpopt.equals("2"))	sqlwhere_con+=" not like '%,"+tmpvalue +",%' ";
		} else if (htmltype.equals("3")){   //其他浏览框
			if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
				sqlwhere_con += "and (','||t1."+tmpcolname+"||','";
			else
				sqlwhere_con += "and (','+CONVERT(varchar,t1."+tmpcolname+")+',' ";
			if(tmpopt.equals("1"))	sqlwhere_con+=" like '%,"+tmpvalue +",%' ";
			if(tmpopt.equals("2"))	sqlwhere_con+=" not like '%,"+tmpvalue +",%' ";
		} else if (htmltype.equals("6")){   //附件上传同多文挡
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
		else if (htmltype.equals("3") || htmltype.equals("6")){   //其他浏览框
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
sqlwhere_con = sqlwhere_con.replace("{&}","");
String initselectfield = "";
List iframeList = new ArrayList();
String multiselectid="";
ArrayList<String> ldselectfieldid=new ArrayList<String>();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/formmode/js/modebrow_wev8.js"></script>
<LINK href="/js/jquery/plugins/multiselect/jquery.multiselect_wev8.css" type=text/css rel=STYLESHEET>
<!-- <link href="/js/jquery/plugins/multiselect/style_wev8.css" type=text/css rel=STYLESHEET> -->
<link href="/formmode/js/jquery/jquery-ui-1.10.3/themes/base/jquery-ui_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery-ui.min_wev8.js"></script>
<script language="javascript" src="/js/jquery/plugins/multiselect/jquery.multiselect.min_wev8.js"></script>
<script language="javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<style>
.ui-multiselect-menu{
	z-index:9999999;
}
.ui-multiselect-displayvalue{
	background-image:none;
}
.ui-widget-content label{
	background-color:rgb(255, 255, 255);
	font-weight:normal;
}

.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default{
	background-image:none;
	background-color: rgb(255,255,255);
}

.ui-state-hover, .ui-widget-content .ui-state-hover, .ui-widget-header .ui-state-hover, .ui-state-focus, .ui-widget-content .ui-state-focus, .ui-widget-header .ui-state-focus{
	background-image:none;
	background-color: rgb(255,255,255);
	font-weight:normal;
}

.ui-widget-header {
	background-image:none;
	font-weight:normal;
}
</style>
<script>
<%if(!istree.equals("1")){%>
try{
	parent.setTabObjName("<%=customname%>");
}catch(e){
	if(window.console)console.log(e);
}
<%}%>
<%if(istree.equals("1")){%>
	var dialog;
	var parentWin;
	try{
		parentWin = window.parent.parent.parent.getParentWindow(parent);
		dialog = window.parent.parent.parent.getDialog(parent);
		if(!dialog){
			parentWin = parent.parentWin;
			dialog = parent.dialog;
		}
	}catch(e){
		
	}
<%}else if(isview){%>
	var parentWin = window.parent.getParentWindow(window);
	var dialog = window.parent.getDialog(window);
<%}else{%>
	var parentWin = window.parent.parent.getParentWindow(parent);
	var dialog = window.parent.parent.getDialog(parent);
<%}%>
</script>
</head>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;//搜索
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancel(),_top} " ;//取消
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;//清除
RCMenuHeight += RCMenuHeightStep ;
%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="btnsearch1" class="e8_btn_top" onclick="javascript:submitData()" ><!-- 搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>
<div class="zDialog_div_content">
<form name="frmmain" method="post" action="/formmode/browser/CommonSingleBrowser.jsp?<%=tempquerystring%>">
<input name=customid type=hidden value="<%=customid%>">
<input name=issimple type=hidden value="<%=issimple%>">
<input name=browsertype type=hidden value="<%=browsertype%>">
<input type="hidden" name="sqlwhere" value="<%=xssUtil.put(sqlwhereparam) %>">
<input type=hidden name=formid id="formid" value="<%=formID %>">
<input type=hidden name=isVirtualForm id="isVirtualForm" value="<%=isVirtualForm %>">

<%
if(RecordSet.getDBType().equals("oracle")){
    sql = "select * from (select mode_CustombrowserDspField.queryorder ,mode_CustombrowserDspField.showorder ,workflow_billfield.id as id,workflow_billfield.fieldname as name,to_char(workflow_billfield.fieldlabel) as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.selectitem as selectitem,workflow_billfield.linkfield as linkfield,workflow_billfield.fieldhtmltype as httype,workflow_billfield.childfieldid as childfieldid,workflow_billfield.type as type,mode_CustombrowserDspField.conditionTransition as conditionTransition from workflow_billfield,mode_CustombrowserDspField,mode_custombrowser where mode_CustombrowserDspField.customid=mode_custombrowser.id and mode_custombrowser.id="+customid+" and mode_CustombrowserDspField.isquery='1' and workflow_billfield.billid='"+formID+"' and workflow_billfield.id=mode_CustombrowserDspField.fieldid ";
}else{
    sql = "select * from (select mode_CustombrowserDspField.queryorder ,mode_CustombrowserDspField.showorder ,workflow_billfield.id as id,workflow_billfield.fieldname as name,convert(varchar,workflow_billfield.fieldlabel) as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.selectitem as selectitem,workflow_billfield.linkfield as linkfield,workflow_billfield.fieldhtmltype as httype,workflow_billfield.childfieldid as childfieldid,workflow_billfield.type as type,mode_CustombrowserDspField.conditionTransition as conditionTransition from workflow_billfield,mode_CustombrowserDspField,mode_custombrowser where mode_CustombrowserDspField.customid=mode_custombrowser.id and mode_custombrowser.id="+customid+" and mode_CustombrowserDspField.isquery='1' and workflow_billfield.billid='"+formID+"' and workflow_billfield.id=mode_CustombrowserDspField.fieldid ";
}
    sql+=" union select queryorder,showorder,fieldid as id,'' as name,'' as label,'' as dbtype,0 as selectitem,0 as linkfield,'' as httype,0 as childfieldid,0 as type,0 as conditionTransition from mode_CustombrowserDspField where isquery='1' and fieldid in(-1,-2,-3,-4,-5,-6,-7,-8,-9) and customid="+customid;
    sql+=") a order by a.queryorder,a.showorder,a.id";
RecordSet.execute(sql);

String itemAreaDisplay = "";
boolean emptFlag = RecordSet.next();
if(!emptFlag){
	itemAreaDisplay = "{'itemAreaDisplay':'none'}";
}
%>
<wea:layout type="4col" >

	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'  attributes="<%=itemAreaDisplay %>"><!-- 查询条件 -->
<%//以下开始列出自定义查询条件
int i=0;
while (emptFlag)
{
i++;
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");
String htmltype = RecordSet.getString("httype");
String type = RecordSet.getString("type");
String id = RecordSet.getString("id");
String dbtype = Util.null2String(RecordSet.getString("dbtype"));
int selectitem =Util.getIntValue(Util.null2String(RecordSet.getString("selectitem")),0);
int linkfield = 0;
rs.execute("select id from workflow_billfield where linkfield="+id);
if(rs.next()){
	linkfield = Util.getIntValue(rs.getString("id"), 0);
}
int conditionTransition = Util.getIntValue(RecordSet.getString("conditionTransition"),0);
label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
String childfieldid = Util.null2String(RecordSet.getString("childfieldid"));

String namestr = "con"+id+"_value";
String browserType = type;
if ("0".equals(type)) browserType = "";
String completeUrl = "javascript:getajaxurl('" + browserType + "','"+dbtype+"','"+id+"','1')";

if(id.equals("-1")){
    id="_3";
    name="modedatacreatedate";
    label=SystemEnv.getHtmlLabelName(722,user.getLanguage());
    htmltype="3";
    type="2";
}else if(id.equals("-2")){
    id="-2";
    name="modedatacreater";
    label=SystemEnv.getHtmlLabelName(882,user.getLanguage());
    htmltype="3";
    type="1";
}
String display="display:'';";
if(issimple) display="display:none;";
String tmpvalue="";
String tmpvalue1="";
String tmpname="";
String multiselectvalue = "";
if(isresearch==1){
    tmpvalue=Util.null2String((String)conht.get("con_"+id+"_value"));
    tmpvalue1=Util.null2String((String)conht.get("con_"+id+"_value1"));
    tmpname=Util.null2String((String)conht.get("con_"+id+"_name"));
    multiselectvalue = Util.null2String(conht.get("multiselectValue_con"+id+"_value"));
}
%>
<wea:item>
<input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
<input type=hidden name="con<%=id%>_type" value="<%=type%>">
<input type=hidden name="con<%=id%>_colname" value="<%=name%>">
<input type='checkbox' name='check_con' title="<%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%>" value="<%=id%>" style="display:none" checked="checked"> <%=label%><!-- 是否作为查询条件 -->
</wea:item>
<wea:item>
<%
if(!tmpvalue.equals("")){
	FieldInfo fieldInfo = new FieldInfo();
	tmpname = fieldInfo.getFieldName(tmpvalue,Util.getIntValue(type),dbtype);
}
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){  //文本框
    int tmpopt=3;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),3);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<%if(!htmltype.equals("2")){//TD9319 屏蔽掉多行文本框的“等于”和“不等于”操作，text数据库类型不支持该判断%>
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>     <!--等于-->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>   <!--不等于-->
<%}%>
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>   <!--包含-->
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>   <!--不包含-->

</select>
<input type=text class=InputStyle style="width:50%" name="con<%=id%>_value" value="<%=tmpvalue%>">

<SPAN id=remind style='cursor:hand' title='<%=SystemEnv.getHtmlLabelName(82346,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82347,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82348,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82349,user.getLanguage())%>'>
<IMG src='/images/remind_wev8.png' align=absMiddle>
</SPAN>

<%}
else if(htmltype.equals("1")&& !type.equals("1")){  //数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->
    int tmpopt=2;
    int tmpopt1=4;
    if(isresearch==1) {
        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),2);
        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),4);
    }
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%><%}%><!-- 大于或等于 -->
<input type=text style="width:50%;" class=InputStyle size=10 name="con<%=id%>_value" onblur="checknumber('con<%=id%>_value');" value="<%=tmpvalue%>">
<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<%if(issimple){%>
<div>
<%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%><%}%><!-- 小于或等于 -->
<input type=text style="width:50%;" class=InputStyle size=10 name="con<%=id%>_value1"  onblur="checknumber('con<%=id%>_value1');" value="<%=tmpvalue1%>">
</div>
<%
}
else if(htmltype.equals("4")){   //check类型
%>

<input type=checkbox value=1 name="con<%=id%>_value" <%if(tmpvalue.equals("1")){%>checked<%}%>>

<%}
else if(htmltype.equals("5")){  //选择框
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
    
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<%
String selectchange = "";
if(!childfieldid.equals("")&&!childfieldid.equals("0")){
	selectchange = "changeChildField(this,'"+id+"','"+childfieldid+"');";
	initselectfield += "changeChildField(jQuery('#con"+id+"_value')[0],'"+id+"','"+childfieldid+"');";
	ldselectfieldid.add(id+"");
}
String multiselect="";
if(conditionTransition==1){
	multiselect="multiple=\"multiple\"";
	multiselectid+="con"+id+"_value,";
}
%>
<input type="hidden" name="multiselectValue_con<%=id%>_value" id="multiselectValue_con<%=id%>_value" value="<%=multiselectvalue %>" />
<select class=inputstyle <%=multiselect %>  name="con<%=id%>_value" id="con<%=id%>_value" <%if(!id.equals("_6") && !id.equals("_2") && !id.equals("_8")){%>onchange="<%=selectchange%>"<%}%>>
<%if(conditionTransition!=1){ %>
<option value="" ></option>
<%} %>
<%
char flag=2;
if(id.equals("_6")){
%>
    <option value="0" <%if (nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option><!-- 创建 -->
    <option value="1" <%if (nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option><!-- 批准 -->
    <option value="2" <%if (nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option><!-- 提交 -->
    <option value="3" <%if (nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option><!-- 归档 -->
<%
}else if(id.equals("_2")){
%>
    <option value="0" <%if (requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option><!-- 正常 -->
	<option value="1" <%if (requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option><!-- 重要 -->
	<option value="2" <%if (requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option><!-- 紧急 -->
<%
}else if(id.equals("_8")){
%>
    <option value="0" <%if (isdeleted==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option><!-- 有效 -->
    <option value="1" <%if (isdeleted==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option><!-- 无效 -->
    <option value="2" <%if (isdeleted==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option><!-- 全部 -->
<%
}else{
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
	String tempcancel = rs.getString("cancel");
	if("1".equals(tempcancel)){
		continue;
	}
%>
<option value="<%=tmpselectvalue%>" <%if (tmpvalue.equals(""+tmpselectvalue)) {%>selected<%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
<%}
}%>
</select>

<%}else if (htmltype.equals("8")){
	int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
    %>
    <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
    <option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
    <option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
    </select>
    <%
    String selectchange = "";
    if(linkfield!=0){//公共子字段联动
    	if(!iframeList.contains(id)){
    		iframeList.add(id);
    	}
    	selectchange = "changeChildSelectItemField(this,'"+id+"','"+linkfield+"');";
   	  	int selflinkfieldid = 1;
   		String selfSql = "select linkfield from workflow_billfield where id="+id;
   		selectRs.executeSql(selfSql);
   		if(selectRs.next()){
   			selflinkfieldid = selectRs.getInt("linkfield");
   			if(selflinkfieldid<1){
		    	initselectfield += "changeChildSelectItemField(0,'"+id+"','"+linkfield+"',1); \n ";
   			} 
   		}
    }
  
	
    %>
    <select initvalue="<%=tmpvalue %>" childsel="<%=linkfield %>" notBeauty=true class=inputstyle style="width:175px;"  name="con<%=id%>_value" id="con<%=id%>_value"  onchange="<%=selectchange%>" >
    <option value="" ></option>
   <%
	char flag=2;
	rs.executeSql("select id,name,defaultvalue from mode_selectitempagedetail where mainid = "+selectitem+" and statelev = 1  and (cancel=0 or cancel is null)  order by disorder asc,id asc");
	while(rs.next()){
		int tmpselectvalue = rs.getInt("id");
		String tmpselectname = rs.getString("name");
		String isdefault = rs.getString("defaultvalue");
		%>
		<option value="<%=tmpselectvalue%>" <%if (tmpvalue.equals(""+tmpselectvalue)) {%>selected<%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
		<%
	}%>
	</select>
	<%
} else if(htmltype.equals("3") && type.equals("1")){//浏览框单人力资源  (like not lik)
    int tmpopt=1;
    //String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=browserUrl%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">


<%} else if(htmltype.equals("3") && type.equals("9")){//浏览框单文挡  (like not lik)
    int tmpopt=1;
    //String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=browserUrl%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">


<%} else if(htmltype.equals("3") && type.equals("4")){//浏览框单部门   (like not lik)
    int tmpopt=1;
    //String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=browserUrl%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

	<%} else if(htmltype.equals("3") && type.equals("7")){//浏览框单客户   (like not lik)
        int tmpopt=1;
        //String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')";
        String browserUrl = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>

<%} else if(htmltype.equals("3") && type.equals("8")){//浏览框单项目   (like not lik)
    int tmpopt=1;
    //String browserOnClick = "onShowBrowser2('"+id+"','/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if(htmltype.equals("3") && type.equals("16")){//浏览框单请求  条件为多请求 (like not lik)
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/workflow/RequestBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=browserUrl%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%}else if(htmltype.equals("3") && type.equals("24")){//职位
    int tmpopt=1;
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>
<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
//=========================================================================================	
}//职位end

else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //日期
	int tmpopt=2;
    int tmpopt1=4;
    String classStr = "";
	if(type.equals("2")){ //日期
		display = "display:none;";
		String datetype_opt_span_display = "display:none;";
		classStr = "calendar";
		int datetype_opt = Util.getIntValue(Util.null2String(request.getParameter("datetype_"+id+"_opt")),6);
		if(datetype_opt == 6){
			datetype_opt_span_display = "display:;";
		}
		%>
		<select name="datetype_<%=id%>_opt" id="datetype_<%=id%>_opt" style="display: block;" onchange="changeDateType(this,'datetype_<%=id%>_opt_span','con<%=id%>_value','con<%=id%>_valuespan','con<%=id%>_value1','con<%=id%>_value1span')">
		<option value="1" <%if(datetype_opt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
		<option value="2" <%if(datetype_opt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
		<option value="3" <%if(datetype_opt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
		<option value="7" <%if(datetype_opt==7){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(27347,user.getLanguage())%></option><!-- 上个月 -->
		<option value="4" <%if(datetype_opt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
		<option value="5" <%if(datetype_opt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
		<option value="8" <%if(datetype_opt==8){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(31276,user.getLanguage())+SystemEnv.getHtmlLabelName(25201,user.getLanguage())%></option><!-- 上一年 -->
		<option value="6" <%if(datetype_opt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
		</select>
		<span name="datetype_<%=id%>_opt_span" id="datetype_<%=id%>_opt_span" style="<%=datetype_opt_span_display%>">
			<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
			<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
			<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
			<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
			<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
			<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
			<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
			</select>
			<%if(issimple){%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%><%}%><!-- 从 -->
			<button type=button  class="<%=classStr %>" onclick="onSearchWFQTDate(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1)" ></button>
			<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=tmpvalue%>">
			<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpvalue%></span>
			<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
			<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
			<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
			<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
			<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
			<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
			<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
			</select>
			<%if(issimple){%><%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%><%}%><!-- 到 -->
			<button type=button  class="<%=classStr %>" onclick="onSearchWFQTDate(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value)" ></button>
			<input type=hidden name="con<%=id%>_value1" id="con<%=id%>_value1" value="<%=tmpvalue1%>">
			<span name="con<%=id%>_value1span" id="con<%=id%>_value1span"><%=tmpvalue1%></span>
		</span>
		<%
	}else{ //时间
		if(isresearch==1) {
	        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),2);
	        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),4);
	    }
		classStr = "Clock";
		%>
		<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
		<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
		<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
		<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
		<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
		<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
		<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
		</select>
		<%if(issimple){%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%><%}%><!-- 从 -->
		<button type=button  class="<%=classStr %>" onclick ="onSearchWFQTTime(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1)" ></button>
		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=tmpvalue%>">
		<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpvalue%></span>
		<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
		<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
		<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
		<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
		<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
		<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
		<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
		</select>
		<%if(issimple){%><%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%><%}%><!-- 到 -->
		<button type=button  class="<%=classStr %>" onclick ="onSearchWFQTTime(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value)" ></button>
		<input type=hidden name="con<%=id%>_value1" id="con<%=id%>_value1" value="<%=tmpvalue1%>">
		<span name="con<%=id%>_value1span" id="con<%=id%>_value1span"><%=tmpvalue1%></span>
		<%
	}

} else if(htmltype.equals("3") && type.equals("17")){//人力资源 多选框
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
    if(!tmpvalue.equals("")){
    	FieldInfo fieldInfo = new FieldInfo();
    	tmpname = fieldInfo.getFieldName(tmpvalue,17);
    }
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if(htmltype.equals("3") && type.equals("37")){//浏览框  (多文挡)
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?isworkflow=1')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?isworkflow=1";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=browserUrl%>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if(htmltype.equals("3") && type.equals("57")){//浏览框  （多部门）
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByOrder.jsp','"+type+"')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByOrder.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=browserUrl%>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if(htmltype.equals("3") && type.equals("135")){//浏览框  （多项目 ）
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if(htmltype.equals("3") && type.equals("152")){//浏览框  多选筐条件为单选筐（多请求 ）
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=browserUrl%>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if(htmltype.equals("3") && type.equals("18")){//浏览框  多选筐
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%}
else if(htmltype.equals("3") && type.equals("160")){//浏览框  多选筐条件为单选筐
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')";
    //String browserOnClick = "onShowResourceRole('"+id+"', '/systeminfo/BrowserMain.jsp?url=/hrm/resource/RoleResourceBrowser.jsp?selectids=', '', '160', '0', '')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if(htmltype.equals("3") && type.equals("142")){//浏览框多收发文单位
String urls = "/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserMulti.jsp";
    int tmpopt=1;
    //String browserOnClick="onShowBrowser2('"+id+"','"+urls+"','"+type+"')";
    String browserUrl = urls;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%}
else if(htmltype.equals("3") && (type.equals("56")||type.equals("27")||type.equals("118")||type.equals("64")||type.equals("137"))){//浏览框
String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','"+urls+"')";
    String browserUrl = urls;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%}else if(htmltype.equals("3") && type.equals("65")){//浏览框
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    String browserUrl = urls;
   // String browserOnClick = "onShowResourceRole('"+id+"', '"+urls+"?selectedids=', '', '65', '0', '')";
    //String browserOnClick="onShowBrowser2('"+id+"','"+urls+"','65')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%}
else if("3".equals(htmltype) && "141".equals(type)){
	String url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceConditionBrowser.jsp";
	String browserOnClick = "onShowResourceConditionBrowserForCondition('"+namestr+"','"+url+"','','141',0)";
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
	%>
	
	<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
	<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
	<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
	</select>
	
	<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
	</brow:browser>
	<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
	<%
}
else if(htmltype.equals("3") && id.equals("_5")){//工作流浏览框
    tmpname="";
    ArrayList tempvalues=Util.TokenizerString(tmpvalue,",");
    for(int k=0;k<tempvalues.size();k++){
        if(tmpname.equals("")){
            tmpname=WorkflowComInfo.getWorkflowname((String)tempvalues.get(k));
        }else{
            tmpname+=","+WorkflowComInfo.getWorkflowname((String)tempvalues.get(k));
        }
    }
%>

<input type=hidden  name="con<%=id%>_opt" value="1">
<%if(customid.equals("")){
String browserOnClick="onShowWorkFlowSerach('workflowid','workflowspan')";
%>
<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<span id=workflowspan>
	<%=workflowname%>
</span>

<%}else{
	String browserOnClick="onShowCQWorkFlow('con"+id+"_value','con"+id+"_valuespan','"+type+"')";
%>
<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%}%>

<%} else if (htmltype.equals("3") && (type.equals("161") || type.equals("162"))){
	String urls=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype;     // 浏览按钮弹出页面的url
	String browserOnClick = "onShowBrowserCustom('"+id+"','"+urls+"','"+type+"')";
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
    
    Browser browser=(Browser)StaticObj.getServiceByFullname(dbtype, Browser.class);
    if(!tmpvalue.equals("")){
	    tmpname = "";
	    String[] tmpvalueArr = tmpvalue.split(",");
	    for(int m=0;m<tmpvalueArr.length;m++){
	    	if(!tmpvalueArr[m].equals("")){
		    	BrowserBean bb=browser.searchById(tmpvalueArr[m]);
				String tname=Util.null2String(bb.getName());
				tmpname += ","+tname;
	    	}
	    }
	    if(!tmpname.equals("")){
	    	tmpname = tmpname.substring(1);
	    }
    }
    String isSingleStr = "true";//单选
    if(type.equals("162")){
    	isSingleStr = "false";
    }
    
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>' 
	hasInput="true" isSingle='<%=isSingleStr %>' hasBrowser="true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if (htmltype.equals("3") && (type.equals("256") || type.equals("257"))){
	String urls=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype+"_"+type;     // 娴忚鎸夐挳寮瑰嚭椤甸潰鐨剈rl
    int tmpopt=1;
    String isSingle = "";
    String browserOnClick="onShowBrowserCustom('"+id+"','"+urls+"','"+type+"')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
    if(type.equals("256")){
    	isSingle = "true";
    }else{
    	isSingle = "false";
    }   
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>

<brow:browser viewType="0" name="<%=namestr%>" browserValue="<%=tmpvalue %>" 
	browserUrl="<%=urls %>" 
	hasInput="true" isSingle="<%=isSingle%>" hasBrowser = "true" isMustInput='1'
	completeUrl="<%=completeUrl%>" width="135px" 
	browserSpanValue="<%=tmpname%>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if (htmltype.equals("3")){
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','"+urls+"','"+type+"')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=urls%>'
	hasInput="true" isSingle='<%=type.equals("194")?"false":"true" %>' hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if (htmltype.equals("6")){   //附件上传同多文挡
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1','"+type+"')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"   >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%}%>
</wea:item>
<%
emptFlag = RecordSet.next();
}%>
	</wea:group>
</wea:layout>
<%for(int i=0;i<iframeList.size();i++){%>
<iframe id="selectChange_<%=iframeList.get(i) %>" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%} %>
<%for(int i=0;i<ldselectfieldid.size();i++){%>
<iframe id="selectChange_<%=ldselectfieldid.get(i) %>" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%} %>
</form>
<div>
<div>
  <input id="formmodeFlag" name="formmodeFlag" type="hidden" value="1">
</div>
<!-- 显示查询结果 start -->
<div id="splitPageContiner" style="overflow:auto;width:570px" >  
<%
//查询参数
String formmodeid="0";
RecordSet.execute("select a.modeid,a.customname,a.customdesc,a.formid from  mode_custombrowser a where  a.id="+customid);
if(RecordSet.next()){
    formID=Util.null2String(RecordSet.getString("formid"));
    formmodeid=Util.null2String(RecordSet.getString("modeid"));
}
if(istree.equals("1")){
	formmodeid = "0";
}
String tablename=Util.null2String(request.getParameter("tablename"));
rs.executeSql("select tablename from workflow_bill where id = " + formID);
if (rs.next()){
	tablename = rs.getString("tablename"); 
}

String orderby = "t1.id";
int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);
String tableString = "";
if(perpage <1) perpage=10;                                 
String backfields = " t1.id,t1.formmodeid,t1.modedatacreater,t1.modedatacreatertype,t1.modedatacreatedate,t1.modedatacreatetime ";
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

//加上自定以字段
String showfield="";
sql = "select isorder,workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type,mode_custombrowserdspfield.showorder,mode_custombrowserdspfield.colwidth,mode_custombrowserdspfield.istitle,mode_CustombrowserDspField.ispk" +
            " from workflow_billfield,mode_custombrowserdspfield,Mode_CustomBrowser where mode_custombrowserdspfield.customid=Mode_CustomBrowser.id and Mode_CustomBrowser.id="+customid+
            " and mode_custombrowserdspfield.isshow='1' and workflow_billfield.billid="+formID+" and workflow_billfield.viewtype=0 and workflow_billfield.id=mode_custombrowserdspfield.fieldid" +
            " union select isorder,mode_custombrowserdspfield.fieldid as id,'1' as name,2 as label,'3' as dbtype, '4' as httype,5 as type ,mode_custombrowserdspfield.showorder,mode_custombrowserdspfield.colwidth,mode_custombrowserdspfield.istitle,mode_CustombrowserDspField.ispk" +
            " from mode_custombrowserdspfield ,Mode_CustomBrowser where mode_custombrowserdspfield.customid=Mode_CustomBrowser.id and Mode_CustomBrowser.id="+customid+
            " and mode_custombrowserdspfield.isshow='1'  and mode_custombrowserdspfield.fieldid<0" +
            " order by istitle desc,showorder asc,id asc";
RecordSet.executeSql(sql);
String pkfield = "";
int real_col_count = 0;
while (RecordSet.next()){
	real_col_count ++;
	if (RecordSet.getInt("id")>0){
		String tempname=Util.null2String(RecordSet.getString("name"));
		String dbtype=Util.null2String(RecordSet.getString("dbtype"));
		String ispk = Util.null2String(RecordSet.getString("ispk"));
		if("1".equals(ispk)){
			pkfield = tempname;
		}
		String showfield_tmp=","+showfield.toLowerCase()+",";
		String currfield_tmp=",t1."+tempname.toLowerCase()+",";
		String backfield_tmp=","+backfields.trim().toLowerCase()+",";
		if(showfield_tmp.indexOf(currfield_tmp)>-1||backfield_tmp.indexOf(currfield_tmp)>-1)continue;
		
		if(dbtype.toLowerCase().equals("text")){
			if(vdatasourceDBtype.equals("oracle")){
				showfield=showfield+","+"to_char(t1."+tempname+") as "+tempname;
			}else{
				showfield=showfield+","+"convert(varchar(4000),t1."+tempname+") as "+tempname;
			}
		}else{
				showfield=showfield+","+"t1."+tempname;
			}
		}
	}
	RecordSet.beforFirst();
	backfields=backfields+showfield;
	//String fromSql  = " from "+tablename+" t1 ";
	List<User> lsUser = ModeRightInfo.getAllUserCountList(user);
	String fromSql;
	if(isVirtualForm){	//是虚拟表单
		fromSql  = " from "+ VirtualFormHandler.getRealFromName(tablename)+" t1 ";
		sqlwhere = " where 1=1";
	}else if(norightlist.equals("1")){
		  fromSql  = " from "+tablename+" t1 " ;
		  if(formmodeid.equals("")||formmodeid.equals("0")){//浏览框中没有设置模块
			  sqlwhere = " where 1=1 ";
		  }else{
			  sqlwhere = " where t1.formmodeid="+formmodeid+" ";
		  }
	}else{
		String rightsql = "";
		if(formmodeid.equals("")||formmodeid.equals("0")){//浏览框中没有设置模块
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
	    sqlwhere = " where t1.id = t2.sourceid";
	}
	if(!"".equals(sqlwhereparam)){
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
	             if(!javafileAddress.equals("")){
                     Map<String, String> sourceCodePackageNameMap = CommonConstant.SOURCECODE_PACKAGENAME_MAP;
                     String classFullName =javafileAddress;
                         
                     Map<String, Object> param = new HashMap<String, Object>();
                     param.put("user", user);
                     
                     Object result = CustomJavaCodeRun.run(classFullName, param);
                     if(!"error".equals(Util.null2String(result))){
                         sqlCondition = Util.null2String(result);
                     }
                 }else if(!javafilename.equals("")){
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
	//检查是否设置列宽
        double sumColWidth = 0;
        double avgColWidth = 5;
		if(real_col_count>0){
    	  avgColWidth = 100/(real_col_count*1.0);
	    }
		 BigDecimal bg = new BigDecimal(avgColWidth);
		 avgColWidth = bg.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
		 int zerocount = 0;
         String allstatfield = "";
         Map<String, Integer> countColumnsDbType = new HashMap<String, Integer>();
         RecordSet.beforFirst();
         while(RecordSet.next()){
         	sumColWidth += Util.getDoubleValue(RecordSet.getString("colwidth"),0);  
         	if(Util.getDoubleValue(RecordSet.getString("colwidth"),0)==0){
         		zerocount++;
         	}
         	if(Util.getIntValue(RecordSet.getString("isstat"),0)==1){
         		allstatfield+=RecordSet.getString("name")+",";
         		if(Util.getIntValue(RecordSet.getString("httype"))==1){
         			int dbtype = Util.getIntValue(RecordSet.getString("type"));
         			if(dbtype==5)
         				countColumnsDbType.put(RecordSet.getString("name"),1);
         			else
         				countColumnsDbType.put(RecordSet.getString("name"),0);
         		}else{
         			countColumnsDbType.put(RecordSet.getString("name"),0);
         		}
         	}
         }
	double tempSumWidth = sumColWidth;
    if(sumColWidth>0&&sumColWidth<100&&zerocount>0){
    	double tempWidth = (100-sumColWidth)/(zerocount*1.0);
	    BigDecimal bg1 = new BigDecimal(tempWidth);
	    tempWidth = bg1.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
	   if(tempWidth<(avgColWidth*0.5)){
		 avgColWidth = avgColWidth*0.5;
	   }else if(tempWidth<=avgColWidth){
		 avgColWidth = tempWidth;
	   }
    }
if(zerocount>0){
	  tempSumWidth = sumColWidth+avgColWidth*zerocount;
}
double sumWidthPre = 1;//总宽度超过100的比例
if(tempSumWidth>100){
	sumWidthPre = tempSumWidth/(100);
}
double percent = 0;//设置的宽度超过100时，计算每一列的百分比
if(tempSumWidth>100&&sumColWidth>0){
	percent =(100-avgColWidth*zerocount)/sumColWidth;
}
BigDecimal bg2 = new BigDecimal(percent);
percent = bg2.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
double widthPre =1.0;
if(tempSumWidth+7>100){
	widthPre = tempSumWidth/(tempSumWidth+7)*1.0;
}
BigDecimal bg3 = new BigDecimal(widthPre);
widthPre = bg3.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
      
		String sqlprimarykey = "t1.id";
		if(isVirtualForm){	//虚拟表单
			sqlprimarykey = "t1." + vprimarykey;
			BrowserInfoService browserInfoService=new BrowserInfoService();
			orderby = browserInfoService.getOrderSQL(customid);
			if("".equals(orderby)){
				orderby = "t1." + vprimarykey;
			}
		} else { //实际表单
			BrowserInfoService browserInfoService=new BrowserInfoService();
			if(!"".equals(pkfield))
				sqlprimarykey = "t1."+pkfield;
			orderby = browserInfoService.getOrderSQL(customid);
		}
		tableString =" <table instanceid=\"workflowRequestListTable\" pagesize=\""+perpage+"\"  tabletype=\"none\" >"+
                              "	   <sql backfields=\""+backfields+"\" sumColumns=\""+allstatfield+"\" ";
                              
        if(!countColumnsDbType.isEmpty()){
      		tableString+="\" countColumnsDbType=\""+countColumnsDbType;
      	}
        tableString+= " sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\""+sqlprimarykey+"\" sqlsortway=\"Desc\" poolname=\""+vdatasource+"\" />"+
                              "			<head>";
                 tableString+="				<col width=\"10%\" text=\""+ Util.toHtmlForSplitPage(SystemEnv.getHtmlLabelName(19049, user.getLanguage())) +"ID\" hide=\"true\" column=\"formmodeid\" />";
		RecordSet.beforFirst();
		while (RecordSet.next()) {
			double temocolwidth = Util.getDoubleValue(RecordSet.getString("colwidth"),0);
			if(temocolwidth==0){
				temocolwidth = (int)avgColWidth;
			}
			if(tempSumWidth>100){
				temocolwidth = (int)(temocolwidth*percent);
			}
	        temocolwidth=temocolwidth*widthPre;
			if(RecordSet.getString("id").equals("-1")){
				String orderkey = "orderkey=\"t1.modedatacreatedate,t1.modedatacreatetime\"";
				String isorder = RecordSet.getString("isorder");
				if(!"1".equals(isorder)){
					orderkey = "";
				}
				//创建日期
				tableString+="				<col width=\""+temocolwidth+"%\" text=\""+Util.toHtmlForSplitPage(SystemEnv.getHtmlLabelName(722,user.getLanguage()))+"\" column=\"modedatacreatedate\" "+orderkey+" otherpara=\"column:modedatacreatetime\" transmethod=\"weaver.formmode.search.FormModeTransMethod.getSearchResultCreateTime\" />";
			}else if(RecordSet.getString("id").equals("-2")){
				String orderkey = "orderkey=\"t1.modedatacreater\"";
				String isorder = RecordSet.getString("isorder");
				if(!"1".equals(isorder)){
					orderkey = "";
				}
				//创建人
				tableString+="				<col width=\""+temocolwidth+"%\" text=\""+Util.toHtmlForSplitPage(SystemEnv.getHtmlLabelName(882,user.getLanguage()))+"\" column=\"modedatacreater\" "+orderkey+"  otherpara=\"column:modedatacreatertype\" transmethod=\"weaver.formmode.search.FormModeTransMethod.getSearchResultName\" />";
			}else{
				String name = RecordSet.getString("name");
				String label = RecordSet.getString("label");
				String htmltype = RecordSet.getString("httype");
				String type = RecordSet.getString("type");
				String id = RecordSet.getString("id");
				String dbtype=RecordSet.getString("dbtype");
				String istitle = RecordSet.getString("istitle");
				String hreflink = RecordSet.getString("hreflink");
				String isorder = RecordSet.getString("isorder");
				//String viewtype = String.valueOf(Util.getIntValue(request.getParameter("viewtype"),0));
				//http://localhost:8080/formmode/view/addformmode.jsp?type=1&modeId=1&formId=-50
				//type=1&modeId=1&formId=-50
				//type<==>viewtype
				//0、查看
				//1、新建
				//2、编辑
				//3、监控
				if(isVirtualForm){
				    if(formmodeid.equals("0")){
				    	formmodeid = "virtual";
				    }
				}
				String orderkey = "";
				if("1".equals(isorder)){
					orderkey="orderkey=\"t1."+name+"\"";
				}
				String para3="column:id+"+id+"+"+htmltype+"+"+type+"+"+user.getLanguage()+"+"+isbill+"+"+dbtype+"+"+istitle+"+"+formmodeid+"+"+formID+"+"+viewtype+"+"+opentype+"+"+customid+"+fromsearchlist"+"+"+hreflink;
				label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
	 			tableString+="			    <col width=\""+temocolwidth+"%\" text=\""+Util.toHtmlForSplitPage(label)+"\"  column=\""+name+"\"  otherpara=\""+para3+"\" "+orderkey+"  transmethod=\"weaver.formmode.search.FormModeTransMethod.getBrowserOthers\"/>";
			}
		}
		tableString+="			</head>"+"</table>";
%>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
<!-- 显示查询结果  end -->
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout type="2col" needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=S  id=btnsearch onclick="submitData();"  value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"><!-- 搜索 -->
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear onclick="submitClear();"  value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"><!-- 清除 -->
			<input type="button" class=zd_btn_submit accessKey=T  id=btncancel onclick="onCancel();"  value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"><!-- 取消 -->
</wea:item>
</wea:group>
</wea:layout>
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language="javascript" src="/js/browser/WorkFlowBrowser_wev8.js"></script>
<script language="javaScript">
function changeDateType(obj,spanid,dateid,datespan,dateid1,datespan1){
   if(jQuery(obj).val()=='6'){
      jQuery("#"+spanid).css("display","inline");
   }else{
      jQuery("#"+spanid).css("display","none");
   }
   if(obj.value=="0"){
		jQuery("#"+dateid).val("");
		jQuery("#"+datespan).html("");
		jQuery("#"+dateid1).val("");
		jQuery("#"+datespan1).html("");
	}else if(obj.value=="1"){
		jQuery("#"+dateid).val(getTodayDate());
		jQuery("#"+datespan).html(getTodayDate());
		jQuery("#"+dateid1).val(getTodayDate());
		jQuery("#"+datespan1).html(getTodayDate());
	}else if(obj.value=="2"){
		jQuery("#"+dateid).val(getWeekStartDate());
		jQuery("#"+datespan).html(getWeekStartDate());
		jQuery("#"+dateid1).val(getWeekEndDate());
		jQuery("#"+datespan1).html(getWeekEndDate());
	}else if(obj.value=="3"){
		jQuery("#"+dateid).val(getMonthStartDate());
		jQuery("#"+datespan).html(getMonthStartDate());
		jQuery("#"+dateid1).val(getMonthEndDate());
		jQuery("#"+datespan1).html(getMonthEndDate());
	}else if(obj.value=="7"){//上个月
		jQuery("#"+dateid).val(getLastMonthStartDate());
		jQuery("#"+datespan).html(getLastMonthStartDate());
		jQuery("#"+dateid1).val(getLastMonthEndDate());
		jQuery("#"+datespan1).html(getLastMonthEndDate());
	}else if(obj.value=="4"){
		jQuery("#"+dateid).val(getQuarterStartDate());
		jQuery("#"+datespan).html(getQuarterStartDate());
		jQuery("#"+dateid1).val(getQuarterEndDate());
		jQuery("#"+datespan1).html(getQuarterEndDate());
	}else if(obj.value=="5"){
		jQuery("#"+dateid).val(getYearStartDate());
		jQuery("#"+datespan).html(getYearStartDate());
		jQuery("#"+dateid1).val(getYearEndDate());
		jQuery("#"+datespan1).html(getYearEndDate());
	}else if(obj.value=="8"){//上一年
		jQuery("#"+dateid).val(getLastYearStartDate());
		jQuery("#"+datespan).html(getLastYearStartDate());
		jQuery("#"+dateid1).val(getLastYearEndDate());
		jQuery("#"+datespan1).html(getLastYearEndDate());
	}else if(obj.value=="6"){
		jQuery("#"+dateid).val("");
		jQuery("#"+datespan).html("");
		jQuery("#"+dateid1).val("");
		jQuery("#"+datespan1).html("");
	}
}

function changeChildField(obj, fieldid, childfieldid){
	var multiselectflag="0";
	if("<%=multiselectid%>".indexOf(fieldid)>-1){
		multiselectflag="1";
	}
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value+"&isSearch=1&browserid=<%=customid%>&multiselectflag="+multiselectflag+"&multiselectvalue="+jQuery("#multiselectValue_con"+fieldid+"_value").val();
    $G("selectChange_"+fieldid).src = "/formmode/search/SelectChange.jsp?"+paraStr;
}

function changeChildSelectItemField(obj, fieldid, childfieldid,isinit){
	if(isinit&&isinit==1){//编辑时初始化
		obj = $G("con"+fieldid+"_value");
	}
	if(!obj){
		obj = $G("con"+fieldid+"_value");
	}
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value;
    if(isinit&&isinit==1){
    	paraStr = paraStr + "&isinit="+isinit;
    }
    var iframe = jQuery("#selectChange_"+fieldid);
    if(iframe.length==0){
    	iframe = jQuery("#selectChange");
    }
    iframe.get(0).src = "/formmode/search/SelectItemChangeByQuery.jsp?"+paraStr;
}

jQuery(document).ready(function(){
	<%=initselectfield%>;
	<%
	String[] multiselectidArray = multiselectid.split(",");
	for(int m=0;m<multiselectidArray.length;m++){
		if(Util.null2String(multiselectidArray[m]).trim().equals(""))
			continue;
	%>
		jQuery("#<%=multiselectidArray[m]%>").multiselect({
			multiple: true,
			noneSelectedText: '',
			checkAllText: "<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>",
	        uncheckAllText: "<%=SystemEnv.getHtmlLabelName(84355,user.getLanguage())%>",
	        selectedList:100,
	        minWidth:180,
	        close: function(){
				var tmpmsv = jQuery("#<%=multiselectidArray[m]%>").multiselect("getChecked").map(function(){return this.value;}).get();
	  			jQuery("#multiselectValue_<%=multiselectidArray[m]%>").val(tmpmsv.join(","));
	  			var selectObj = jQuery("#<%=multiselectidArray[m]%>");
				var onchangeStr = selectObj.attr('onchange');
				if(onchangeStr&&onchangeStr!=""){
					var selObj = selectObj.get(0);
					if (selObj.fireEvent){
						selObj.fireEvent('onchange');
					}else{
						selObj.onchange();
					}
				}
			}
	        
	  	});
	  	jQuery("#<%=multiselectidArray[m]%>").val(jQuery("#multiselectValue_<%=multiselectidArray[m]%>").val().split(","));
	  	jQuery("#<%=multiselectidArray[m]%>").multiselect("refresh");
	<%}%>
	
});

function nextSelectRefreshMultiSelect(selectid){
	var tmpmsv = jQuery("#"+selectid).multiselect("getChecked").map(function(){return this.value;}).get();
	jQuery("#multiselectValue_"+selectid).val(tmpmsv.join(","));
	jQuery("#"+selectid).val(jQuery("#multiselectValue_"+selectid).val().split(","));
	jQuery("#"+selectid).multiselect("refresh");
}

//多选下拉框赋值
function multselectSetValue(){
	var tmpmsv="";
    <%
	for(int m=0;m<multiselectidArray.length;m++){
		if(Util.null2String(multiselectidArray[m]).trim().equals(""))
			continue;
	%>
	  tmpmsv = jQuery("#<%=multiselectidArray[m]%>").multiselect("getChecked").map(function(){return this.value;}).get();
	  
	  jQuery("#multiselectValue_<%=multiselectidArray[m]%>").val(tmpmsv);
	<%}%>

}

function doReturnSpanHtml(obj){
	var t_x = obj.substring(0, 1);
	if(t_x == ','){
		t_x = obj.substring(1, obj.length);
	}else{
		t_x = obj;
	}
	return t_x;
}

function onShowFormWorkFlow(inputname, spanname) {
	var tmpids = $G(inputname).value;
	var url = uescape("?customid=<%=customid%>&value=<%=isbill%>_<%=formID%>_"
			+ tmpids);
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"
			+ url;

	disModalDialogRtnM(url, inputname, spanname);
}
function onShowCQWorkFlow(inputname, spanname) {
	var tmpids = $G(inputname).value;
	var url = uescape("?customid=<%=customid%>&value=<%=isbill%>_<%=formID%>_"
			+ tmpids);
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"
			+ url;

	disModalDialogRtnM(url, inputname, spanname);
}

function onShowWorkFlowSerach(inputname, spanname) {

	retValue = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp");
	temp = $G(inputname).value;
	if(retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "0" && wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
			$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
			$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
			
			if (temp != wuiUtil.getJsonValueByIndex(retValue, 0)) {
				$G("frmmain").action = "WFCustomSearchBySimple.jsp";
				$G("frmmain").submit();
			}
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
			$G("frmmain").action = "WFSearch.jsp";
			$G("frmmain").submit();

		}
	}
}

function onShowCQWorkFlow(inputname, spanname) {
	var tmpids = $G(inputname).value;
	var url = uescape("?customid=<%=customid%>&value=<%=isbill%>_<%=formID%>_"
			+ tmpids);
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"
			+ url;

	disModalDialogRtnM(url, inputname, spanname);
}


function submitData(){
	multselectSetValue();
	if (check_form(frmmain,''))
		frmmain.submit();
}

function submitClear()
{
	btnclear_onclick();
}
function onSearchWFQTDate(spanname,inputname,inputname1){
	WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();
			$dp.$(inputname).value = returnvalue;
	     },oncleared:function(){
		      spanname.innerHTML = '';
		      inputname.value = '';
	     }
	});
}
function onSearchWFQTTime(spanname,inputname,inputname1){
    var dads  = document.all.meizzDateLayer2.style;
    setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop;
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft;
	var ttyp  = spanname.type;
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop;
		tleft += spanname.offsetLeft;
	}
	var t = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
	dads.top = t+"px";
	dads.left = tleft+"px";
	$(document.all.meizzDateLayer2).css("z-index",99999);
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
    CustomQuery=1;
    outValue1 = inputname1;
}
function uescape(url){
    return escape(url);
}
</script>

<script type="text/javascript">
function onCancel(){
	if(dialog){
	    dialog.close();
	}else{  
	    window.parent.parent.close();
	}
}

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}


</script>

<script type="text/javascript">
function onShowResource() {
	var url = "";
	var tmpval = $G("creatertype").value;
	
	if (tmpval == "0") {
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	} else {
		url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	}
	disModalDialog(url, $G("resourcespan"), $G("createrid"), false);
}

function onShowBranch() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" + $G("branchid").value;
	
	disModalDialog(url, $G("branchspan"), $G("createrid"), false);
}

function onShowDocids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1";
	disModalDialog(url, $G("docidsspan"), $G("docids"), false);
}

function onShowCrmids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	disModalDialog(url, $G("crmidsspan"), $G("crmids"), false);
}

function onShowHrmids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	disModalDialog(url, $G("hrmidsspan"), $G("hrmids"), false);
}

function onShowPrjids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
	disModalDialog(url, $G("prjidsspan"), $G("prjids"), false);
}

function onShowBrowser(id,url) {
	var url = url + "?selectedids=" + $G("con" + id + "_value").value;
	disModalDialog(url, $G("con" + id + "_valuespan"), $G("con" + id + "_value"), false);
	$G("con" + id + "_name").value = $G("con" + id + "_valuespan").innerHTML;
}

function onShowBrowserCustom_old(id, url, type1) {
	url+="&iscustom=1";
	if (type1 == 256|| type1==257) {
		tmpids = $GetEle("con"+id+"_value").value;
		url = url + "&selectedids=" + tmpids;
	}
	var id1 = window.showModalDialog(url, window, 
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
			var names = wuiUtil.getJsonValueByIndex(id1, 1);
			var descs = wuiUtil.getJsonValueByIndex(id1, 2);
			if (type1 == 161) {
				$G("con" + id + "_valuespan").innerHTML = "<a title='" + ids + "'>" + names + "</a>&nbsp";
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
			if (type1 == 162) {
				var sHtml = "";

				var idArray = ids.split(",");
				var curnameArray = names.split("~~WEAVERSplitFlag~~");
				if(curnameArray.length < idArray.length){
					curnameArray = names.split(",");
				}
				var curdescArray = descs.split(",");

				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];

					sHtml = sHtml + "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
				}

				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				$G("con" + id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
			}
			if (type1 == 256||type1 == 257) {
				$G("con" + id + "_valuespan").innerHTML =  names ;
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
}

function onShowBrowserCustom(id, url, type1) {
	if (type1 == 256|| type1==257) {
		tmpids = $GetEle("con"+id+"_value").value;
		url = url + "&selectedids=" + tmpids;
		url+="&iscustom=1";
	}else{
		tmpids = $GetEle("con"+id+"_value").value;
		url = url + "|" + id + "&beanids=" + tmpids;
		url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
		url+="&iscustom=1";
	}
	var dialogurl = url;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogurl;
	dialog.callbackfun = function (paramobj, id1) {
		if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
			var names = wuiUtil.getJsonValueByIndex(id1, 1);
			var descs = wuiUtil.getJsonValueByIndex(id1, 2);
			if (type1 == 161) {
				var sHtml = "";
				var href = wuiUtil.getJsonValueByIndex(id1, 3);
				if(href == undefined || href=="" ){
					sHtml +=  wrapshowhtml("<a title='" + names + "' >" + names + "</a>&nbsp",curid,1);
				}else{
					var onclickstr="onclick=\"javascript:window.open('"+href+ids+"');\"";
					sHtml +=  wrapshowhtml("<a "+onclickstr+" title='" + names + "' >" + names + "</a>&nbsp",curid,1);
				}
				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
			if (type1 == 162) {
				var sHtml = "";
				var href = wuiUtil.getJsonValueByIndex(id1, 3);

				var idArray = ids.split(",");
				var curnameArray = names.split("~~WEAVERSplitFlag~~");
				if(curnameArray.length < idArray.length){
					curnameArray = names.split(",");
				}
				var curdescArray = descs.split(",");

				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];
					if(curdesc==''||curdesc=='undefined'||curdesc==null){
						curdesc = curname;
					}
					if(curdesc){
						curdesc = curname;
					}

					if(href == undefined || href=="" ){
						sHtml +=  wrapshowhtml("<a title='" + curdesc + "' >" + curname + "</a>&nbsp",curid,1);
					}else{
						var onclickstr="onclick=\"javascript:window.open('"+href+curid+"');\"";
						sHtml +=  wrapshowhtml("<a "+onclickstr+" title='" + curdesc + "' >" + curname + "</a>&nbsp",curid,1);
					}
				}

				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				$G("con" + id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
			}
			if (type1 == 256||type1 == 257) {
				$G("con" + id + "_valuespan").innerHTML =  names ;
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
		
	hoverShowNameSpan(".e8_showNameClass");
	   
	};
	
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
	dialog.Width = 550 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
		dialog.Width=648; 
	}
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();

}

function onShowBrowser1(id,url,type1) {
	if (type1 == 1) {
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
		$G("con" + id + "_valuespan").innerHTML = id1;
		$G("con" + id + "_value").value=id1
	} else if (type1 == 1) {
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
		$G("con"+id+"_value1span").innerHTML = id1;
		$G("con"+id+"_value1").value=id1;
	}
}



function onShowBrowser2(id, url, type1) {
	var tmpids = "";
	var id1 = null;
	if (type1 == 8) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?projectids=" + tmpids);
	} else if (type1 == 9) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?documentids=" + tmpids);
	} else if (type1 == 1) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 4) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?selectedids=" + tmpids
				+ "&resourceids=" + tmpids);
	} else if (type1 == 16) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 7) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 142) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids);
	}
	//id1 = window.showModalDialog(url)
	if (id1 != null) {
		resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
		resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			if(resourceids!=""&&resourceids.indexOf(",")==0){
				resourceids = resourceids.substr(1);
			}
			if(resourcename!=""&&resourcename.indexOf(",")==0){
				resourcename = resourcename.substr(1);
			}
			$G("con" + id + "_valuespan").innerHTML = resourcename;
			jQuery("input[name=con" + id + "_value]").val(resourceids);
			jQuery("input[name=con" + id + "_name]").val(resourcename);
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
}

function onShowMutiHrm(spanname, inputename) {
	tmpids = $G(inputename).value;
	id1 = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
					+ tmpids);
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";
			if(resourceids!=""&&resourceids.indexOf(",")==0){
				resourceids = resourceids.substr(1);
			}
			if(resourcename!=""&&resourcename.indexOf(",")==0){
				resourcename = resourcename.substr(1);
			}
			$G(inputename).value = resourceids;

			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");
			for ( var i = 0; i < resourceidArray.length(); i++) {
				var curid = resourceidArray[i];
				var curname = resourcenameArray[i];
				sHtml = sHtml + curname + "&nbsp";
			}

			$G(spanname).innerHTML = sHtml;
			if (spanname.indexOf("remindobjectidspan") != -1) {
				$G("isother").checked = true;
			} else {
				$G("flownextoperator")[0].checked = false;
				$G("flownextoperator")[1].checked = true;
			}
		} else {
			$G(spanname).innerHTML = "";
			$G(inputename).value = "";
			if (spanname.indexOf("remindobjectidspan") != -1) {
				$G("isother").checked = false;
			} else {
				$G("flownextoperator")[0].checked = true;
				$G("flownextoperator")[1].checked = false;
			}
		}
	}
}

function onShowWorkFlowSerach(inputname, spanname) {

	retValue = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp");
	temp = $G(inputname).value;
	if(retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "0" && wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
			$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
			$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
			
			if (temp != wuiUtil.getJsonValueByIndex(retValue, 0)) {
				$G("frmmain").action = "WFCustomSearchBySimple.jsp";
				$G("frmmain").submit();
			}
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
			$G("frmmain").action = "WFSearch.jsp";
			$G("frmmain").submit();

		}
	}
}

function disModalDialogRtnM(url, inputname, spanname) {
	var id = window.showModalDialog(url);
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0);
			var names = wuiUtil.getJsonValueByIndex(id, 1);
			
			if (ids.indexOf(",") == 0) {
				ids = ids.substr(1);
				names = names.substr(1);
			}
			$G(inputname).value = ids;
			var sHtml = "";
			
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");
			
			for ( var i = 0; i < ridArray.length; i++) {
				var curid = ridArray[i];
				var curname = rNameArray[i];
				if (i != ridArray.length - 1) sHtml += curname + "，"; 
				else sHtml += curname;
			}
			
			$G(spanname).innerHTML = sHtml;
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
}

function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;
   if(target.nodeName =="TD"){
    	var parentTr = jQuery(target).parent();
    	if(parentTr.hasClass("e8EmptyTR")){//没有数据可以显示--不能返回
    		return;
    	}
    }
    
	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var hrefStr = "<%=href%>";
		if(<%=bflag%>){
			var pNode = target.parentNode;
			if(pNode.nodeName!="TR"){
				pNode = pNode.parentNode;
			}
			//var rowformmodeid = jQuery(pNode).find("input[name=rowformmodeid]").val();
			var rowformmodeid = jQuery(pNode).find("td").eq(1).text();
			hrefStr = hrefStr.replace("modeId=0","modeId="+rowformmodeid);
		}else{
			if(jQuery.trim(hrefStr)!=''){
				var modeidIndex = hrefStr.indexOf("modeId=");
				var r = hrefStr.match(/modeId=-?[0-9]+/);
				var tempModeid = r[0];
				if(tempModeid!=undefined&&tempModeid!=""&&tempModeid!=null&&tempModeid!='null'){
					var pNode = target.parentNode;
					if(pNode.nodeName!="TR"){
						pNode = pNode.parentNode;
					}
					var rowformmodeid = jQuery(pNode).find("td").eq(1).text();
					if(rowformmodeid!=undefined && rowformmodeid.trim()!=""){
						hrefStr = hrefStr.replace(tempModeid,"modeId="+rowformmodeid);
    				}
				}
			}
		}
		<%if(istree.equals("1")){%>
			var objid = "<%=treenodeid%>_"+jQuery(jQuery(target).parents("tr")[0].cells[0]).find("input[type='checkbox']").val();
			objid = objid.replace(/_space_/g," ");
			var objname = jQuery(jQuery(target).parents("tr")[0].cells[2]).text();
			var text = objname;
			if(dialog){
				objname = "<a target='_blank' href='/formmode/search/CustomSearchOpenTree.jsp?pid="+objid+"' >"+objname+"</a>";
			}
			var returnjson = {
				id:objid,
				name:objname,
				desc:text
			};
		<%}else{%>
			var objid = jQuery(jQuery(target).parents("tr")[0].cells[0]).find("input[type='checkbox']").val();
			objid = objid.replace(/_space_/g," ");
			var returnjson = {
				id:objid,
				name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text(),
				desc:''<%=isVirtualForm?"":",href:hrefStr"%>,
				href:hrefStr
			};
		<%}%>
		
		if(dialog){
			 try{
			     dialog.callback(returnjson);
			 }catch(e){}
			 
			 try{
			     dialog.close(returnjson);
			 }catch(e){}
		    
		}else{  
			window.parent.parent.returnValue=returnjson;
			window.parent.parent.close();
		}
	}
}

function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
    	 try{
		     dialog.callback(returnjson);
		 }catch(e){}
		 
		 try{
		     dialog.close(returnjson);
		 }catch(e){}
	}else{  
		window.parent.parent.returnValue=returnjson;
		window.parent.parent.close();
	}
}
function resizeDialog2(){
	var bodywidth = jQuery(window).width();
	 var pagecontiner = jQuery("#splitPageContiner");
	var table1 = jQuery(".table:first");
	var tab  = table1[0];
	var ss  =<%=RecordSet.getCounts()%>;
	if(ss<=5){
	   table1.css("width",table1[0].clientWidth);
	}
	else if(ss>=6&&ss<10){
      table1.css("width",850);
	}else{
	   table1.css("width",1200);
	}
	if(bodywidth>600){
      table1.css("width",bodywidth);
	  pagecontiner.css("width",bodywidth-7);
	}
	
    //var col = $("table colgroup col");
  // alert(col.length);
//	var ListStyle = jQuery("#splitPageContiner");
//	var aa = ListStyle[0].children[0].childNodes[1].childNodes[1];
//	var ss = $("table:visible");
} 
window.onresize = function () {
	resizeDialog2();
	}


$(function(){
	<%
	if(!isview){
	%>
		jQuery("#_xTable").bind("click",BrowseTable_onclick);
	<%
	}
	%>
	resizeDialog();
	 resizeDialog2();
	document.body.onclick = function (e){//浏览框里面 让链接点击无效
	 	var e=e||event;
   		var target=e.srcElement||e.target;
	 	var tagName = target.tagName;
	 	if(tagName=="A" || tagName=="a"){
	 		return false;
	 	}
	} 
	
});

</script>

</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<!-- browser 相关 -->
<script type="text/javascript" src="/formmode/js/modebrow_wev8.js?v=1"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
</html>
<script>
/**
 * 角色人员
 */
function onShowResourceRole(id, url, linkurl, type1, ismand, roleid) {
	var tmpids = $GetEle("con" + id+"_value").value;
	url = url + tmpids;
	//id1 = window.showModalDialog(url);
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	//dialog.callbackfunParam = null;
	dialog.URL = url;
	dialog.callbackfun = function (paramobj, id1) {
		if (id1) {
			if (wuiUtil.getJsonValueByIndex(id1, 0) != ""
					&& wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
	
				var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
				var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
				var sHtml = "";
				if (resourceids.indexOf(",") == 0) {
					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
				}
				$GetEle("con" + id+"_value").value = resourceids;
				var idArray = resourceids.split(",");
				var nameArray = resourcename.split(",");
				for ( var _i = 0; _i < idArray.length; _i++) {
					var curid = idArray[_i];
					var curname = nameArray[_i];
					sHtml = sHtml + "<a href=" + linkurl + curid
							+ " target='_new'>" + curname + "</a>&nbsp";
				}
				$GetEle("con" + id + "_valuespan").innerHTML = sHtml;
	
			} else {
				if (ismand == 0) {
					$GetEle("con" + id + "_valuespan").innerHTML = "";
				} else {
					$GetEle("con" + id + "_valuespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
				}
				$GetEle("con" + id+"_value").value = "";
			}
		}
	
	};
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage()) %>";
	dialog.Width = 550 ;
	dialog.Height = 600;
	dialog.Drag = true;
	//dialog.maxiumnable = true;
	dialog.show();
}

</script>
<script>

	jQuery(document).ready(function(){
		//计算高度
		//获取到最外层的div高度
		window.setTimeout(function(){
			var outDiv = jQuery(".zDialog_div_content").height();//487
			//获取查询表单的高度
			var formDiv = jQuery("form[name='frmmain']")[0].offsetHeight;
			
			//判断是否是IEs
			var userAgent = navigator.userAgent;
			var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1; 
			var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
         	reIE.test(userAgent);
         	var fIEVersion = parseFloat(RegExp["$1"]);
         	if( isIE) {
         		formDiv = formDiv+1;
         	}
         	
			//alert("out:"+outDiv+"form"+formDiv);
			
			//设置splitPageContiner的高度
			jQuery("#splitPageContiner").css("height",outDiv-formDiv);
		},200);
		
	});

</script>