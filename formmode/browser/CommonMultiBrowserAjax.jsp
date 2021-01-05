<%@page import="weaver.formmode.browser.FormModeBrowserUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="weaver.servicefiles.DataSourceXML"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.SplitPageUtil"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.ComparatorUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.formmode.service.CommonConstant"%>
<%@ page import="weaver.formmode.customjavacode.CustomJavaCodeRun"%>
<%@ page import="weaver.formmode.service.BrowserInfoService"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.general.SplitPageParaBean"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@page import="weaver.formmode.tree.CustomTreeData"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsm" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FormModeTransMethod" class="weaver.formmode.search.FormModeTransMethod" scope="page"/>
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />

<%
request.setCharacterEncoding("UTF-8");
User user = HrmUserVarify.getUser(request,response);

String istree = Util.null2String(request.getParameter("istree"));//是否树的组合查询
String treeid = Util.null2String(request.getParameter("treeid"));
String treenodeid = Util.null2String(request.getParameter("treenodeid"));

String src = Util.null2String(request.getParameter("src"));
String browsertype = Util.null2String(request.getParameter("browsertype"));
String customid=Util.null2String(request.getParameter("customid"));
//链接地址中sqlwhere
String sqlwhereparam=Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("systemIds")).replace("weaver2017", "+");
int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
if(perpage <1) perpage=10;
String isCustomPageSize = Util.null2String(request.getParameter("isCustomPageSize"));

if("".equals(customid)){
	out.println(SystemEnv.getHtmlLabelName(81939,user.getLanguage()));//browser框id不能为空！
	return;
}

if(check_per.trim().startsWith(",")){
	check_per = check_per.substring(1);
}

//============================================browser框基础数据====================================
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
	if(perpage==10&&isCustomPageSize.equals("")){//首次加载或不改变页数
		perpage = Util.getIntValue(Util.null2String(rs.getString("pagenumber")),10);
	}
	norightlist = Util.null2String(rs.getString("norightlist"));
	
}

if(istree.equals("1")){//树组合查询一律当作无权限列表对待
	norightlist = "1";
	formmodeid = "0";
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

//============================================表单名称====================================
rs.executeSql("select tablename from workflow_bill where id = " + formID);
if (rs.next()){
	tablename = rs.getString("tablename"); 
}
if(isVirtualForm){
	tablename= VirtualFormHandler.getRealFromName(tablename);
}
//============================================自定义查询条件====================================
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
//============================================需要显示的字段====================================
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
if(isVirtualForm){	//是虚拟表单
	fromSql  = " from "+tablename+" t1 ";
	if(sqlwhere.equals("")){
		sqlwhere = " where 1=1";
	}
}else if(norightlist.equals("1")){
	  fromSql  = " from "+tablename+" t1 " ;
	  if(sqlwhere.equals("")){
			sqlwhere = " where 1=1 ";
	  }
	  if(!(formmodeid.equals("")||formmodeid.equals("0"))){//浏览框中设置了模块
		  sqlwhere += " and t1.formmodeid="+formmodeid+" ";
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
if(isVirtualForm){	//虚拟表单
	sqlprimarykey = "t1." + vprimarykey;
	pkfieldname = vprimarykey;
	pkfield = vprimarykey;
	BrowserInfoService browserInfoService=new BrowserInfoService();
	orderby = browserInfoService.getOrderSQL(customid);
	if(StringHelper.isEmpty(orderby)){
		orderby = "t1." + vprimarykey;
	}
} else { //实际表单
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

if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件
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

	if(dbtypeStr.equals("oracle")){//Oracle这里改变in的写法，否则Oracle 10g 版本的数据库会有bug 
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
	//屏蔽已选数据
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
%>