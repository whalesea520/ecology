
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@page import="java.net.URLEncoder"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="FormModeBrowserClause" class="weaver.formmode.browser.FormModeBrowserClause" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String userid = "";
boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;
String logintype = ""+user.getLogintype();
int usertype = 0;

if(userid.equals("")) {
	userid = ""+user.getUID();
	if(logintype.equals("2")) usertype= 1;
}

String tablename="";
String formID="0";
String customid=Util.null2String(request.getParameter("customid"));
String beanids=Util.null2String(request.getParameter("beanids"));
String browsertype=Util.null2String(request.getParameter("browsertype"));
String modeid = "0";
rs.executeSql("select a.modeid,a.customname,a.customdesc,b.modename,b.formid from mode_custombrowser a,modeinfo b where a.modeid = b.id and a.id="+customid);
if(rs.next()){
    formID=""+Util.getIntValue(rs.getString("formid"),0);
    modeid=""+Util.getIntValue(rs.getString("modeid"),0);
}
rs.executeSql("select tablename from workflow_bill where id = " + formID);
if (rs.next()){
	tablename = rs.getString("tablename"); 
}

String src=Util.null2String(request.getParameter("src"));
String method=Util.null2String(request.getParameter("method"));
String complete1=Util.null2String(request.getParameter("complete"));

String issimple=Util.null2String(request.getParameter("issimple"));

String createrid=Util.null2String(request.getParameter("createrid"));
String creatertype=Util.null2String(request.getParameter("creatertype"));

String fromdate=Util.null2String(request.getParameter("fromdate"));
String todate=Util.null2String(request.getParameter("todate"));
String userids="";
String pagenum=Util.null2String(request.getParameter("pagenum"));
String isVirtualForm=Util.null2String(request.getParameter("isVirtualForm"));

//下面开始自定义查询条件
String[] checkcons = request.getParameterValues("check_con");
String whereclause=" where t1.formmodeid = " + modeid + " ";
if(isVirtualForm.equals("true")){
	whereclause = "";
}
String sqlwhereparam=Util.null2String(request.getParameter("sqlwhere"));
sqlwhereparam=URLEncoder.encode(sqlwhereparam);
String sqlwhere="";
ArrayList ids = new ArrayList();
ArrayList colnames = new ArrayList();
ArrayList opts = new ArrayList();
ArrayList values = new ArrayList();
ArrayList names = new ArrayList();
ArrayList opt1s = new ArrayList();
ArrayList value1s = new ArrayList();
ids.clear();
colnames.clear();
opt1s.clear();
names.clear();
value1s.clear();
opts.clear();
values.clear();
Hashtable conht=new Hashtable();
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
	conht.put("con_"+tmpid,"1");
	conht.put("con_"+tmpid+"_opt",tmpopt);
	conht.put("con_"+tmpid+"_opt1",tmpopt1);
	conht.put("con_"+tmpid+"_value",tmpvalue);
	conht.put("con_"+tmpid+"_value1",tmpvalue1);
	conht.put("con_"+tmpid+"_name",tmpname);
    if(tmpid.equals("_1")){
        fromdate=tmpvalue;
        todate=tmpvalue1;
    }else if(tmpid.equals("_2")){
        createrid=tmpvalue;
    }else{
		if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){  //文本框
			if(!tmpvalue.equals(""))
			{
				if(tmpopt.equals("1"))	sqlwhere+=" and (t1."+tmpcolname+" ='"+tmpvalue +"' ";
				if(tmpopt.equals("2"))	sqlwhere+=" and (t1."+tmpcolname+" <>'"+tmpvalue +"' ";
				if(tmpopt.equals("3")){
				    ArrayList tempvalues=Util.TokenizerString(Util.StringReplace(tmpvalue,"　"," ")," ");
				    sqlwhere += " and (";
				    for(int k=0;k<tempvalues.size();k++){
				        if(k==0) sqlwhere += "t1."+tmpcolname;
				        else  sqlwhere += " or t1."+tmpcolname;
				        tmpvalue=Util.StringReplace(Util.StringReplace((String)tempvalues.get(k),"+","%"),"＋","%");
				        if(!isoracle&&!isdb2){
				            int indx=tmpvalue.indexOf("[");
				            if(indx<0) indx=tmpvalue.indexOf("]");
				            if(indx<0){
				                sqlwhere += " like '%"+tmpvalue+"%' ";
				            }else{
				                sqlwhere += " like '%"+Util.StringReplace(Util.StringReplace(Util.StringReplace(tmpvalue,"/","//"),"[","/["),"]","/]")+"%' ESCAPE '/' ";
				            }
				        }else{
				            sqlwhere += " like '%"+tmpvalue+"%' ";
				        }
				    }
				}
				if(tmpopt.equals("4")){
				    ArrayList tempvalues=Util.TokenizerString(Util.StringReplace(tmpvalue,"　"," ")," ");
				    for(int k=0;k<tempvalues.size();k++){
				        if(k==0) sqlwhere += "and (t1."+tmpcolname;
				        else  sqlwhere += " and t1."+tmpcolname;
				        tmpvalue=Util.StringReplace(Util.StringReplace((String)tempvalues.get(k),"+","%"),"＋","%");
				        if(!isoracle&&!isdb2){
				            int indx=tmpvalue.indexOf("[");
				            if(indx<0) indx=tmpvalue.indexOf("]");
				            if(indx<0){
				                sqlwhere += " not like '%"+tmpvalue+"%' ";
				            }else{
				                sqlwhere += " not like '%"+Util.StringReplace(Util.StringReplace(Util.StringReplace(tmpvalue,"/","//"),"[","/["),"]","/]")+"%' ESCAPE '/' ";
				            }
				        }else{
				            sqlwhere += " not like '%"+tmpvalue+"%' ";
				        }
				    }
				}
			}
			} else if(htmltype.equals("1")&& !type.equals("1")){  //数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->
				if(!tmpvalue.equals("")){
					if(type.equals("5")){//金额转换
						if(rs.getDBType().equals("oracle")){
							sqlwhere += "and (cast((CASE WHEN (t1."+tmpcolname+"||'') is null THEN '0' WHEN (t1."+tmpcolname+"||'') =' ' THEN '0' ELSE Replace((t1."+tmpcolname+"||''), ',', '') END) as number(30,6))";
						}else{//金额千分位是varchar类型
							sqlwhere += "and (cast((CASE isnumeric (t1."+tmpcolname+") WHEN 0 THEN '0' WHEN 1 THEN replace(t1."+tmpcolname+",',','') ELSE '0' END) as decimal(30,6))";
						}
					}else{
						sqlwhere += "and (t1."+tmpcolname;
					}
					if(tmpopt.equals("1"))	sqlwhere+=" >"+tmpvalue +" ";
					if(tmpopt.equals("2"))	sqlwhere+=" >="+tmpvalue +" ";
					if(tmpopt.equals("3"))	sqlwhere+=" <"+tmpvalue +" ";
					if(tmpopt.equals("4"))	sqlwhere+=" <="+tmpvalue +" ";
					if(tmpopt.equals("5"))	sqlwhere+=" ="+tmpvalue +" ";
					if(tmpopt.equals("6"))	sqlwhere+=" <>"+tmpvalue +" ";
				}
				if(!tmpvalue1.equals("")){
					if(type.equals("5")){//金额转换
						if(rs.getDBType().equals("oracle")){
							sqlwhere += "and cast((CASE WHEN (t1."+tmpcolname+"||'') is null THEN '0' WHEN (t1."+tmpcolname+"||'') =' ' THEN '0' ELSE Replace((t1."+tmpcolname+"||''), ',', '') END) as number(30,6))";
						}else{//金额千分位是varchar类型
							sqlwhere += "and cast((CASE isnumeric (t1."+tmpcolname+") WHEN 0 THEN '0' WHEN 1 THEN replace(t1."+tmpcolname+",',','') ELSE '0' END) as decimal(30,6))";
						}
					}else{
						sqlwhere += " and t1."+tmpcolname;
					}
					if(tmpopt1.equals("1"))	sqlwhere+=" >"+tmpvalue1 +" ";
					if(tmpopt1.equals("2"))	sqlwhere+=" >="+tmpvalue1 +" ";
					if(tmpopt1.equals("3"))	sqlwhere+=" <"+tmpvalue1 +" ";
					if(tmpopt1.equals("4"))	sqlwhere+=" <="+tmpvalue1 +" ";
				    if(tmpopt1.equals("5"))	sqlwhere+=" ="+tmpvalue1+" ";
					if(tmpopt1.equals("6"))	sqlwhere+=" <>"+tmpvalue1 +" ";
				}
			} else if(htmltype.equals("4")){   //check类型 = !=
				sqlwhere += "and (t1."+tmpcolname;
				if(!tmpvalue.equals("1")) sqlwhere+="<>'1' ";
				else sqlwhere +="='1' ";
			} else if(htmltype.equals("5")){  //选择框   = !=
				sqlwhere += "and (t1."+tmpcolname;
				if(tmpvalue.equals("")) 
				{
				if(tmpopt.equals("1"))	sqlwhere+=" is null ";
				if(tmpopt.equals("2"))	sqlwhere+=" is not  null ";
				}
				else
				{
				if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
				if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
				}
			} else if(htmltype.equals("3") && (type.equals("1")||type.equals("9")||type.equals("4")||type.equals("7")||type.equals("8")||type.equals("16"))){//浏览框单人力资源  条件为多人力 (int  not  in),条件为多文挡,条件为多部门,条件为多客户,条件为多项目,条件为多请求
				if(!tmpvalue.equals("")) {
					sqlwhere += "and (t1."+tmpcolname;
					if(tmpopt.equals("1"))	sqlwhere+=" in ("+tmpvalue +") ";
					if(tmpopt.equals("2"))	sqlwhere+=" not in ("+tmpvalue +") ";
				}
			}else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别 > >= = < !  and > >= = < !
				if(!tmpvalue.equals("")){
					sqlwhere += "and (t1."+tmpcolname;
					if(tmpopt.equals("1"))	sqlwhere+=" >"+tmpvalue +" ";
					if(tmpopt.equals("2"))	sqlwhere+=" >="+tmpvalue +" ";
					if(tmpopt.equals("3"))	sqlwhere+=" <"+tmpvalue +" ";
					if(tmpopt.equals("4"))	sqlwhere+=" <="+tmpvalue +" ";
					if(tmpopt.equals("5"))	sqlwhere+=" ="+tmpvalue +" ";
					if(tmpopt.equals("6"))	sqlwhere+=" <>"+tmpvalue +" ";
				}
				if(!tmpvalue1.equals("")){
					sqlwhere += " and t1."+tmpcolname;
					if(tmpopt1.equals("1"))	sqlwhere+=" >"+tmpvalue1 +" ";
					if(tmpopt1.equals("2"))	sqlwhere+=" >="+tmpvalue1 +" ";
					if(tmpopt1.equals("3"))	sqlwhere+=" <"+tmpvalue1 +" ";
					if(tmpopt1.equals("4"))	sqlwhere+=" <="+tmpvalue1 +" ";
				    if(tmpopt1.equals("5"))	sqlwhere+=" ="+tmpvalue1+" ";
					if(tmpopt1.equals("6"))	sqlwhere+=" <>"+tmpvalue1 +" ";
				}
			}//职位安全级别end
			else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //日期 > >= = < !  and > >= = < !
				if(!tmpvalue.equals("")){
					sqlwhere += "and (t1."+tmpcolname;
					if(tmpopt.equals("1"))	sqlwhere+=" >'"+tmpvalue +"' ";
					if(tmpopt.equals("2"))	sqlwhere+=" >='"+tmpvalue +"' ";
					if(tmpopt.equals("3"))	sqlwhere+=" <'"+tmpvalue +"' ";
					if(tmpopt.equals("4"))	sqlwhere+=" <='"+tmpvalue +"' ";
					if(tmpopt.equals("5"))	sqlwhere+=" ='"+tmpvalue +"' ";
					if(tmpopt.equals("6"))	sqlwhere+=" <>'"+tmpvalue +"' ";
				}
				if(!tmpvalue1.equals("")){
					sqlwhere += " and t1."+tmpcolname;
					if(tmpopt1.equals("1"))	sqlwhere+=" >'"+tmpvalue1 +"' ";
					if(tmpopt1.equals("2"))	sqlwhere+=" >='"+tmpvalue1 +"' ";
					if(tmpopt1.equals("3"))	sqlwhere+=" <'"+tmpvalue1 +"' ";
					if(tmpopt1.equals("4"))	sqlwhere+=" <='"+tmpvalue1 +"' ";
				    if(tmpopt1.equals("5"))	sqlwhere+=" ='"+tmpvalue1+"' ";
					if(tmpopt1.equals("6"))	sqlwhere+=" <>'"+tmpvalue1 +"' ";
				}
			} else if(htmltype.equals("3") && (type.equals("17")||type.equals("57")||type.equals("135")||type.equals("152")||type.equals("18")||type.equals("160"))){  //浏览框  多选筐条件为单选筐(多文挡) 多选筐条件为单选筐（多部门） 多选筐条件为单选筐（多项目 ）多选筐条件为单选筐（多项目 ）
				if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
				      sqlwhere += "and (','||t1."+tmpcolname+"||','";
				else
				      sqlwhere += "and (','+CONVERT(varchar,t1."+tmpcolname+")+',' ";
				if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
				if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
			}else if(htmltype.equals("3") && (type.equals("141")||type.equals("56")||type.equals("27")||type.equals("118")||type.equals("65")||type.equals("64")||type.equals("137")||type.equals("142"))){//浏览框  
		 		if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
		       		sqlwhere += "and (','||t1."+tmpcolname+"||','";
				else
					sqlwhere += "and (','+CONVERT(varchar,t1."+tmpcolname+")+',' ";
				if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
				if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
			} else if (htmltype.equals("3")){   //其他浏览框
				if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
					sqlwhere += "and (','||t1."+tmpcolname+"||','";
				else
					sqlwhere += "and (','+CONVERT(varchar,t1."+tmpcolname+")+',' ";
				if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
				if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
			} else if (htmltype.equals("6")){   //附件上传同多文挡
				if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
					sqlwhere += "and (','||t1."+tmpcolname+"||','";
				else
					sqlwhere += "and (','+CONVERT(varchar,t1."+tmpcolname+")+',' ";
				if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
				if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
			}
			if (htmltype.equals("1")|| htmltype.equals("2")||(htmltype.equals("3") && (type.equals("1")||type.equals("9")||type.equals("4")||type.equals("7")||type.equals("8")||type.equals("16")))||(htmltype.equals("3") && type.equals("24"))||(htmltype.equals("3") &&( type.equals("2") || type.equals("19")))) {
				if(!tmpvalue.equals("")){
					sqlwhere +=") ";
				}
			}else{
				sqlwhere +=") ";
			}
		}
	}
}
session.setAttribute("conhashtable_"+userid,conht);

whereclause+=sqlwhere;
FormModeBrowserClause.setTablename(tablename);
FormModeBrowserClause.setCustomid(customid);
FormModeBrowserClause.setFormmodeid(modeid);
FormModeBrowserClause.setWhereclause(whereclause);
FormModeBrowserClause.setFromdate(fromdate);
FormModeBrowserClause.setTodate(todate);
FormModeBrowserClause.setModedatacreatertype(creatertype);
FormModeBrowserClause.setModedatacreater(createrid);
FormModeBrowserClause.setBeanids(beanids);
//response.sendRedirect("/formmode/browser/CustomBrowserResult.jsp?query=1&pagenum=1&customid="+customid);

if(src.equals("multi")){
	response.sendRedirect("/formmode/browser/CommonMultiBrowser.jsp?browsertype="+browsertype+"&isresearch=1&query=1&pagenum="+pagenum+"&customid="+customid+"&sqlwhere="+xssUtil.put(sqlwhereparam));
} else {
	response.sendRedirect("/formmode/browser/CommonSingleBrowser.jsp?browsertype="+browsertype+"&isresearch=1&query=1&pagenum="+pagenum+"&customid="+customid+"&sqlwhere="+xssUtil.put(sqlwhereparam));
}
%>