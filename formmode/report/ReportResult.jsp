
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.*,
                 java.math.BigDecimal" %>

<%@ page import="weaver.workflow.report.ReportCompositorOrderBean" %><!--ReportCompositorOrderBean is added by xwj for td2099 on 20050608-->
<%@ page import="weaver.workflow.report.ReportCompositorListBean" %><!--ReportCompositorListBean is added by xwj for td2451 on 20051114-->
 <%@ page import="weaver.workflow.report.ReportUtilComparator" %>
 <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<!--added by xwj for td2974 20051026-->
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj for td2974 20051026-->
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj for td2974 20051026-->
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj for td2974 20051026-->
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page"/>
<jsp:useBean id="FormModeTransMethod" class="weaver.formmode.search.FormModeTransMethod" scope="page"/>

<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="LedgerComInfo" class="weaver.fna.maintenance.LedgerComInfo" scope="page"/>
<jsp:useBean id="ExpensefeeTypeComInfo" class="weaver.fna.maintenance.ExpensefeeTypeComInfo" scope="page"/>
<jsp:useBean id="MDCompanyNameInfo" class="weaver.workflow.report.ReportShare" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<jsp:useBean id="resourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
	
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<%!
    private String formatData(String inData){
        if(inData==null||inData.equals("")){
            return "";
        }
        try{
            return new BigDecimal(  Util.null2String(inData).equals("")?"0":Util.null2String(inData) ).setScale(2,BigDecimal.ROUND_HALF_UP).toString();
        }catch(Exception e){
            return inData;
        }
    }

%>

<%
//报表id
String reportid = Util.null2String(request.getParameter("reportid")) ;
String useddetailtable = "";
if(reportid.equals("")){
	reportid="0";
}

String[] checkcons =null;//报表条件
String[] isShowArray = null;//报表列
List isShowList=new ArrayList();//显示的列的字段id

String formid = "0";
String reportname = "";
String modeid = "0";
int wfreportnumperpage = 10;
String defaultsql="";
String sql = "select a.defaultsql,a.reportname,a.formid,a.modeid,a.reportnumperpage from mode_Report a where a.id ="+reportid;
RecordSet.execute(sql) ;
while(RecordSet.next()){
	formid = Util.null2String(RecordSet.getString("formId"));
	reportname = Util.null2String(RecordSet.getString("reportname"));
	modeid = Util.null2String(RecordSet.getString("modeid"));
	wfreportnumperpage = Util.getIntValue(RecordSet.getString("reportnumperpage"),0);
	if(wfreportnumperpage<1){
		wfreportnumperpage = 10;
	}
    defaultsql = Util.toScreenToEdit(RecordSet.getString("defaultsql"),user.getLanguage()).trim();
    defaultsql = FormModeTransMethod.getDefaultSql(user,defaultsql);
}

List fieldids = new ArrayList() ;
List fields = new ArrayList() ;
List fieldnames = new ArrayList() ;
List htmltypes = new ArrayList() ;
List types = new ArrayList() ;
List isstats = new ArrayList() ;
List statvalues = new ArrayList() ;
List tempstatvalues = new ArrayList() ;
List isdetails = new ArrayList() ;//add by wang jinyong
String requestid = ""; //add by wang jinyong
boolean isnew = true; //add by wang jinyong
List isdborders = new ArrayList() ;

ArrayList compositorOrderList = new ArrayList() ;//addsed by xwj for td2099 on 2005-06-08
ArrayList compositorColList = new ArrayList() ;//addsed by xwj for td2451 on 2005-11-14
ArrayList compositorColList2 = new ArrayList() ;//addsed by xwj for td2451 on 2005-11-14

List ids = new ArrayList();
List isMains = new ArrayList();
List isShows = new ArrayList();
List isCheckConds = new ArrayList();
List colnames = new ArrayList();
List htmlTypes = new ArrayList();
List typeTemps = new ArrayList();
List opts = new ArrayList();
List values = new ArrayList();
List names = new ArrayList();
List opt1s = new ArrayList();
List value1s = new ArrayList();

checkcons = request.getParameterValues("check_con");//报表条件
isShowArray = request.getParameterValues("isShow");//报表列

if(isShowArray!=null){
    for(int i=0;i<isShowArray.length;i++){
	    isShowList.add(isShowArray[i]);
    }
}

String modedatacreatedateIsShow = request.getParameter("modedatacreatedateIsShow");
String modedatacreaterIsShow = request.getParameter("modedatacreaterIsShow");

if(modedatacreatedateIsShow!=null&&modedatacreatedateIsShow.equals("1")){
	isShowList.add("-1");
}

if(modedatacreaterIsShow!=null&&modedatacreaterIsShow.equals("1")){
	isShowList.add("-2");
}

String sqlwhere = "and a.formmodeid = " + modeid + " " ;
if(modeid.equals("")||modeid.equals("0")){//报表中没有设置模块
	String sqlStr1 = "select id,modename from modeinfo where formid="+formid+" and isdelete !=1 order by id";
	rs4.executeSql(sqlStr1);
	sqlwhere = "";
	String modeStr = "";
	while(rs4.next()){
		String mid = rs4.getString("id");
		if(modeStr.equals("")){
			modeStr += mid;
		}else{
			modeStr += ","+mid;
		}
	}
	if(!modeStr.isEmpty()){
		sqlwhere = "and a.formmodeid  in ("+modeStr+") ";
	}else{
		sqlwhere = "and 1=1 ";
	}
}
String temOwner = "";

	String modedatacreatedate_check_con = "";
	String modedatacreater_check_con = "";
	String modedatacreater = "";
	String fromdate = Util.null2String(request.getParameter("fromdate"));//创建日期开始日期
	String todate = Util.null2String(request.getParameter("todate"));//创建日期结束日期
	
	modedatacreatedate_check_con = Util.null2String(request.getParameter("modedatacreatedate_check_con"));
	modedatacreater_check_con = Util.null2String(request.getParameter("modedatacreater_check_con"));
	modedatacreater = Util.null2String(request.getParameter("modedatacreater"));
	
	if ("1".equals(modedatacreatedate_check_con)) {
		if (!"".equals(fromdate)) {
			sqlwhere += " and a.modedatacreatedate >= '"+fromdate+"' ";
		}
		if (!"".equals(todate)) {
			sqlwhere += " and a.modedatacreatedate <= '"+todate+"' ";
		}		
		
	}
	if ("1".equals(modedatacreater_check_con)) {
		if (!"".equals(modedatacreater)) {
			sqlwhere += " and a.modedatacreater = '"+modedatacreater+"' ";
		}
	}

if(checkcons!=null){
	for(int i=0;i<checkcons.length;i++){
		String tmpid = ""+checkcons[i];
		if(tmpid==null||tmpid.equals("")||tmpid.equals("-1")||tmpid.equals("-2")||tmpid.equals("-3")){
			continue;
		}

		String ismain = "";
		String tmpcolname = "";
		String tmphtmltype = "";
		String tmptype = "";
		String tmpopt = "";
		String tmpvalue = "";
		String tmpopt1 = "";
		String tmpvalue1 = "";

		ismain = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_ismain"));
		tmpcolname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_colname"));
		tmphtmltype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_htmltype"));
		tmptype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_type"));
		tmpopt = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt"));
		tmpvalue = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value"));
		tmpopt1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt1"));
		tmpvalue1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value1"));
		//生成where子句

        if(ismain.equals("1")){
            temOwner = "a";
        }else{
            temOwner = "d";
			RecordSet.executeSql("select detailtable from workflow_billfield where billid="+formid+" and id="+tmpid);
			if(RecordSet.next()){
				temOwner = RecordSet.getString("detailtable");
			}
        }

		if(tmphtmltype.equals("1")&& tmptype.equals("1")){
			if(!tmpvalue.equals("")){
				sqlwhere += "and "+temOwner+"."+tmpcolname;
				if(tmpopt.equals("1"))	sqlwhere+=" ='"+tmpvalue +"' ";
				if(tmpopt.equals("2"))	sqlwhere+=" <>'"+tmpvalue +"' ";
				if(tmpopt.equals("3"))	sqlwhere+=" like '%"+tmpvalue +"%' ";
				if(tmpopt.equals("4"))	sqlwhere+=" not like '%"+tmpvalue +"%' ";
			}
		}
		else if(tmphtmltype.equals("2")){
			if(!tmpvalue.equals("")){
				if(RecordSet.getDBType().equals("sqlserver")) {
					sqlwhere += "and convert(varchar,"+temOwner+"."+tmpcolname+")";
				}
				else {
					sqlwhere += "and "+temOwner+"."+tmpcolname;
				}
				if(tmpopt.equals("1"))	sqlwhere+=" ='"+tmpvalue +"' ";
				if(tmpopt.equals("2"))	sqlwhere+=" <>'"+tmpvalue +"' ";
				if(tmpopt.equals("3"))	sqlwhere+=" like '%"+tmpvalue +"%' ";
				if(tmpopt.equals("4"))	sqlwhere+=" not like '%"+tmpvalue +"%' ";
			}
		}
		else if(tmphtmltype.equals("1")&& !tmptype.equals("1")){
			if(!tmpvalue.equals("")){
				if(tmptype.equals("5")){//金额转换
					if(rs.getDBType().equals("oracle")){
						sqlwhere += "and cast((CASE WHEN ("+temOwner+"."+tmpcolname+"||'') is null THEN '0' WHEN ("+temOwner+"."+tmpcolname+"||'') =' ' THEN '0' ELSE Replace(("+temOwner+"."+tmpcolname+"||''), ',', '') END) as number(30,6))";
					}else{//金额千分位是varchar类型
						sqlwhere += "and cast((CASE isnumeric ("+temOwner+"."+tmpcolname+") WHEN 0 THEN '0' WHEN 1 THEN replace("+temOwner+"."+tmpcolname+",',','') ELSE '0' END) as decimal(30,6))";
					}
				}else{
					sqlwhere += "and "+temOwner+"."+tmpcolname;	
				}
				
				if(tmpopt.equals("1"))	sqlwhere+=" >"+tmpvalue +" ";
				if(tmpopt.equals("2"))	sqlwhere+=" >="+tmpvalue +" ";
				if(tmpopt.equals("3"))	sqlwhere+=" <"+tmpvalue +" ";
				if(tmpopt.equals("4"))	sqlwhere+=" <="+tmpvalue +" ";
				if(tmpopt.equals("5"))	sqlwhere+=" ="+tmpvalue +" ";
				if(tmpopt.equals("6"))	sqlwhere+=" <>"+tmpvalue +" ";
			}
			if(!tmpvalue1.equals("")){
				if(tmptype.equals("5")){//金额转换
					if(rs.getDBType().equals("oracle")){
						sqlwhere += "and cast((CASE WHEN ("+temOwner+"."+tmpcolname+"||'') is null THEN '0' WHEN ("+temOwner+"."+tmpcolname+"||'') =' ' THEN '0' ELSE Replace(("+temOwner+"."+tmpcolname+"||''), ',', '') END) as number(30,6))";
					}else{//金额千分位是varchar类型
						sqlwhere += "and cast((CASE isnumeric ("+temOwner+"."+tmpcolname+") WHEN 0 THEN '0' WHEN 1 THEN replace("+temOwner+"."+tmpcolname+",',','') ELSE '0' END) as decimal(30,6))";
					}
				}else{
					sqlwhere += " and "+temOwner+"."+tmpcolname;
				}
				if(tmpopt1.equals("1"))	sqlwhere+=" >"+tmpvalue1 +" ";
				if(tmpopt1.equals("2"))	sqlwhere+=" >="+tmpvalue1 +" ";
				if(tmpopt1.equals("3"))	sqlwhere+=" <"+tmpvalue1 +" ";
				if(tmpopt1.equals("4"))	sqlwhere+=" <="+tmpvalue1 +" ";
				if(tmpopt1.equals("5"))	sqlwhere+=" ="+tmpvalue1+" ";
				if(tmpopt1.equals("6"))	sqlwhere+=" <>"+tmpvalue1 +" ";
			}
		}
		else if(tmphtmltype.equals("4")){
			if("".equals(tmpvalue))continue;
			sqlwhere += "and "+temOwner+"."+tmpcolname;
			if(!tmpvalue.equals("1")) sqlwhere+="<>'1' ";
			else sqlwhere +="='1' ";
		}
		else if(tmphtmltype.equals("5")){
			if(!tmpvalue.equals("")){
				sqlwhere += "and "+temOwner+"."+tmpcolname;
				if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
				if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
			}else{
				if(tmpopt.equals("1")) sqlwhere += "and "+temOwner+"."+tmpcolname + " is null ";
				if(tmpopt.equals("2")) sqlwhere += "and "+temOwner+"."+tmpcolname + " is not null and "+temOwner+"."+tmpcolname + "!='-1' ";
			}
		}
		else if(tmphtmltype.equals("8")){
			if(!tmpvalue.equals("")){
				sqlwhere += "and "+temOwner+"."+tmpcolname;
				if(tmpopt.equals("1"))	sqlwhere+=" ="+tmpvalue +" ";
				if(tmpopt.equals("2"))	sqlwhere+=" <>"+tmpvalue +" ";
			}else{
				if(tmpopt.equals("1")) sqlwhere += "and "+temOwner+"."+tmpcolname + " is null ";
				if(tmpopt.equals("2")) sqlwhere += "and "+temOwner+"."+tmpcolname + " is not null and "+temOwner+"."+tmpcolname + "!='-1' ";
			}
		}
		else if(tmphtmltype.equals("3") && !tmptype.equals("165") && !tmptype.equals("166")&& !tmptype.equals("167")&& !tmptype.equals("168")&& !tmptype.equals("169")&& !tmptype.equals("170")&& !tmptype.equals("2") && !tmptype.equals("4") && !tmptype.equals("18") && !tmptype.equals("19")&& !tmptype.equals("17") && !tmptype.equals("37")  && !tmptype.equals("65")&& !tmptype.equals("57")&& !tmptype.equals("152")&& !tmptype.equals("161") && !tmptype.equals("162")&& !tmptype.equals("135")&& !tmptype.equals("137")&& !tmptype.equals("256")&& !tmptype.equals("257")){
				if(!tmpvalue.equals("")){
					sqlwhere += "and "+temOwner+"."+tmpcolname;
					if(tmpopt.equals("1"))	sqlwhere+=" ="+Util.getIntValue(tmpvalue) +" ";
					if(tmpopt.equals("2"))	sqlwhere+=" <>"+Util.getIntValue(tmpvalue) +" ";
				}
		}
		else if(tmphtmltype.equals("3") &&  tmptype.equals("137")){
			if(!tmpvalue.equals("")){
				sqlwhere += "and "+temOwner+"."+tmpcolname;
				if(tmpopt.equals("1"))	sqlwhere+=" ='"+Util.getIntValue(tmpvalue) +"' ";
				if(tmpopt.equals("2"))	sqlwhere+=" <>'"+Util.getIntValue(tmpvalue) +"' ";
			}
		}
		else if(tmphtmltype.equals("3") && (tmptype.equals("4") || tmptype.equals("165") || tmptype.equals("167") || tmptype.equals("169"))){
            if(!tmpvalue.equals("")){
            	if(",".equals(tmpvalue.substring(0,1))){//判断第一个字符是不是,  如果 是逗号截取掉。
            		sqlwhere += "and "+temOwner+"."+tmpcolname;
					if(tmpopt.equals("1"))	sqlwhere+=" in("+tmpvalue.substring(1) +") ";
					if(tmpopt.equals("2"))	sqlwhere+=" not in("+tmpvalue.substring(1) +") ";
            	}else{
            		sqlwhere += "and "+temOwner+"."+tmpcolname;
						if(tmpopt.equals("1"))	sqlwhere+=" in("+tmpvalue +") ";
						if(tmpopt.equals("2"))	sqlwhere+=" not in("+tmpvalue +") ";
            	}
            }
        }
		else if(tmphtmltype.equals("3") && (tmptype.equals("2")||tmptype.equals("19"))){ // 对日期处理
			if(!tmpvalue.equals("")){
				sqlwhere += "and "+temOwner+"."+tmpcolname;
				if(tmpopt.equals("1"))	sqlwhere+=" >'"+tmpvalue +"' ";
				if(tmpopt.equals("2"))	sqlwhere+=" >='"+tmpvalue +"' ";
				if(tmpopt.equals("3"))	sqlwhere+=" <'"+tmpvalue +"' ";
				if(tmpopt.equals("4"))	sqlwhere+=" <='"+tmpvalue +"' ";
				if(tmpopt.equals("5"))	sqlwhere+=" ='"+tmpvalue +"' ";
				if(tmpopt.equals("6"))	sqlwhere+=" <>'"+tmpvalue +"' ";

				if(!tmpvalue1.equals(""))
					sqlwhere += " and "+temOwner+"."+tmpcolname;
			}
			if(!tmpvalue1.equals("")){
				if(tmpopt1.equals("1"))	sqlwhere+=" >'"+tmpvalue1 +"' ";
				if(tmpopt1.equals("2"))	sqlwhere+=" >='"+tmpvalue1 +"' ";
				if(tmpopt1.equals("3"))	sqlwhere+=" <'"+tmpvalue1 +"' ";
				if(tmpopt1.equals("4"))	sqlwhere+=" <='"+tmpvalue1 +"' ";
				if(tmpopt1.equals("5"))	sqlwhere+=" ='"+tmpvalue1+"' ";
				if(tmpopt1.equals("6"))	sqlwhere+=" <>'"+tmpvalue1 +"' ";
			}
		}
		else if(tmphtmltype.equals("3") && (tmptype.equals("166") || tmptype.equals("168") || tmptype.equals("170") || tmptype.equals("17") || tmptype.equals("18") || tmptype.equals("37") || tmptype.equals("65")|| tmptype.equals("57") || tmptype.equals("152") || tmptype.equals("162")|| tmptype.equals("135")|| tmptype.equals("256")|| tmptype.equals("257") )){       // 对多人力资源，多客户，多部门,多角色，多文档的处理
		    if(!tmpvalue.equals("")){
		        if (rs1.getDBType().equals("oracle"))
							sqlwhere += "and (','||to_char("+temOwner+"."+tmpcolname+")||',' ";	
							else
			                sqlwhere += "and (','+CONVERT(varchar(4000),"+temOwner+"."+tmpcolname+")+',' ";
					
			
					        if(",".equals(tmpvalue.substring(0,1))){//判断第一个字符是不是,  如果 是逗号截取掉。
			                	if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue.substring(1) +",%' ";
								if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue.substring(1) +",%' ";
			                }else{
			                	if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
								if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
			                }
							sqlwhere +=") ";
		    }
		}
		else if(tmphtmltype.equals("3") && tmptype.equals("161")){ // 
		    if(!tmpvalue.equals("")){
		    	if(tmpopt.equals("1"))	sqlwhere+=" and "+temOwner+"."+tmpcolname+" = '"+tmpvalue+"' ";
				if(tmpopt.equals("2"))	sqlwhere+=" and "+temOwner+"."+tmpcolname+" != '"+tmpvalue+"' ";  
		    }
		}
		else if(tmphtmltype.equals("6") ){//附件
			if(!tmpvalue.equals("")){
		        if (rs1.getDBType().equals("oracle"))
							sqlwhere += "and (','||to_char("+temOwner+"."+tmpcolname+")||',' ";	
							else
			                sqlwhere += "and (','+CONVERT(varchar(4000),"+temOwner+"."+tmpcolname+")+',' ";
					
			
					        if(",".equals(tmpvalue.substring(0,1))){//判断第一个字符是不是,  如果 是逗号截取掉。
			                	if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue.substring(1) +",%' ";
								if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue.substring(1) +",%' ";
			                }else{
			                	if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
								if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
			                }
							sqlwhere +=") ";
		    }
		}
	}
}
	if(sqlwhere.length() > 3 ) sqlwhere = sqlwhere.substring(3) ;
	if(!defaultsql.equals("")){
		defaultsql = "(" + defaultsql + ")";
		sqlwhere += " and "+defaultsql+" ";	
	}

	String tablename = "workflow_form" ;
	String detailtablename = "" ;
	String detailkeyfield = "" ;
	int maincount = 0 ;
	int detailcount = 0 ;
	int ordercount = 0 ;
	int statcount = 0 ;
	String fieldname = "" ;
	String orderbystr = "" ;
	ReportCompositorOrderBean reportCompositorOrderBean = new ReportCompositorOrderBean();
	ReportCompositorListBean rcListBean = new ReportCompositorListBean();
	ReportCompositorListBean rcColListBean = new ReportCompositorListBean();
	double  avgColWidth = 100 ;
	
	//数据sql
// 	String sql4 = " select b.* from  mode_ReportDspField b left join  workflow_billfield a  on a.id=b.fieldid " +
//         " where  b.reportid = " + reportid +" order by a.detailtable";
	String sql4 = "select * from (select * from mode_ReportDspField where reportid = " + reportid +" and fieldid<0 order by fieldid desc)t1 UNION ALL select * from (";
	sql4 += " select b.* from  mode_ReportDspField b,workflow_billfield a  where a.id=b.fieldid and " +
	        "  b.reportid = " + reportid +" order by a.detailtable ";
	if(RecordSet.getDBType().equals("sqlserver")){
		sql4 = "select * from (select top 99.9 PERCENT * from mode_ReportDspField where reportid = " + reportid +" and fieldid<0 order by fieldid desc)t1 UNION ALL select * from (";
		sql4 += " select top 99.9 PERCENT b.* from  mode_ReportDspField b,workflow_billfield a  where a.id=b.fieldid and " +
		        "  b.reportid = " + reportid +" order by a.detailtable ";
	}
	if(RecordSet.getDBType().equals("oracle")){
		sql4 += " desc";
	}else{
		sql4 += " asc";
	}
	sql4 += ",b.dsporder,a.id asc)t2";      
	rs4.executeSql(sql4);
	if(isShowList.size()>0){
		avgColWidth = 100.0/isShowList.size();
	}
	double temocolwidth = avgColWidth;
	//String tableString = "";
	String allstatfield = "";
	String decimalFormat = "";
	int iDetailCol = 0;
    Map<String, Integer> countColumnsDbType = new HashMap<String, Integer>();
	while(rs4.next()){
		String tfieldid = rs4.getString("fieldid");
		if(tfieldid.equals("-1")){
			rs1.executeSql("select * from mode_ReportDspField where reportid = " + reportid + " and fieldid = -1");
			if(rs1.next()){
			    if(!"n".equals(rs1.getString("dbordertype"))){
			        reportCompositorOrderBean = new ReportCompositorOrderBean();
			        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
					reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
					reportCompositorOrderBean.setFieldName("modedatacreatedate");
					reportCompositorOrderBean.setSqlFlag("a");
					compositorOrderList.add(reportCompositorOrderBean);
			    }
				if(isShowList.indexOf("-1")!=-1){
				    rcListBean = new ReportCompositorListBean();
				    rcListBean.setCompositorList(rs1.getDouble("dsporder"));
				    rcListBean.setSqlFlag("a");
				    rcListBean.setFieldName("modedatacreatedate");
				    rcListBean.setFieldId("-1");
				    rcListBean.setColName(SystemEnv.getHtmlLabelName(722,user.getLanguage()));//创建日期
					compositorColList.add(rcListBean);
				    fields.add("modedatacreatedate");
				    ////创建日期
				    //tableString+="				<col width=\""+temocolwidth+"%\" text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"a_modedatacreatedate\"    otherpara=\"column:modedatacreatetime\" transmethod=\"weaver.formmode.search.FormModeTransMethod.getSearchResultCreateTime\" />";
				}
			}
		}else if(tfieldid.equals("-2")){
			rs1.executeSql("select * from mode_ReportDspField where reportid = " + reportid + " and fieldid = -2");
			if(rs1.next()){
			    if(!"n".equals(rs1.getString("dbordertype"))){
			        reportCompositorOrderBean = new ReportCompositorOrderBean();
			        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
					reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
					reportCompositorOrderBean.setFieldName("modedatacreater");
					reportCompositorOrderBean.setSqlFlag("a");
					compositorOrderList.add(reportCompositorOrderBean);
			    }
				if(isShowList.indexOf("-2")!=-1){
					rcListBean = new ReportCompositorListBean();
				    rcListBean.setCompositorList(rs1.getDouble("dsporder"));
				    rcListBean.setSqlFlag("a");
				    rcListBean.setFieldName("modedatacreater");
				    rcListBean.setFieldId("-2");
				    rcListBean.setColName(SystemEnv.getHtmlLabelName(882,user.getLanguage()));//创建人
				    compositorColList.add(rcListBean);
				    fields.add("modedatacreater");//创建人
				    //tableString+="				<col width=\""+temocolwidth+"%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"a_modedatacreater\"   otherpara=\"column:modedatacreatertype\" transmethod=\"weaver.formmode.search.FormModeTransMethod.getSearchResultName\" />";
				}
			}
		}else{
				sql = " select a.fieldname , c.labelname, a.fieldhtmltype, a.type, b.isstat , a.viewtype , b.dborder , a.id , b.dbordertype , b.compositororder, b.dsporder, a.detailtable as detailtable,a.fielddbtype "+
				" from  workflow_billfield a, mode_ReportDspField b , HtmlLabelInfo c " +
		        " where a.id = b.fieldid and b.fieldid="+tfieldid+" and a.fieldlabel = c.indexid and b.reportid = " + reportid +" and  c.languageid = " + user.getLanguage() + " order by b.dsporder " ;
			RecordSet.execute(sql) ;
			String strDBType = Util.null2String(RecordSet.getDBType());
			while(RecordSet.next()) {
				String colname = RecordSet.getString(1);
				String viewtype = Util.null2String(RecordSet.getString(6)) ;
				//if(viewtype.equals("1")) {
				//	viewtype = Util.null2String(RecordSet.getString("detailtable")) ;
				//}else{
				//	viewtype ="a" ;
				//}
				
				String name = colname;
				String otherName = "";
				if(viewtype.equals("1")) {
		     		viewtype = Util.null2String(RecordSet.getString("detailtable")) ;
		     		if (strDBType.equals("oracle")||strDBType.equals("db2")) {
		     			otherName = viewtype+"__C"+iDetailCol;
		     			colname = colname+" as "+viewtype+"__C"+iDetailCol;
						iDetailCol++;
		     		} else {
		     			otherName = viewtype+"__"+colname;
		     			colname = colname+" as "+viewtype+"__"+colname;
		     		}
					if(useddetailtable.toUpperCase().indexOf("," + Util.null2String(viewtype).toUpperCase()) < 0 ) {
		     			useddetailtable += "," + viewtype;
		     		}
					detailcount ++ ;
				} else {
				    viewtype ="a" ; 
				    maincount ++ ;
				}
				
				if(!Util.null2String(RecordSet.getString("dbordertype")).equals("n")) {
					reportCompositorOrderBean = new ReportCompositorOrderBean();
					reportCompositorOrderBean.setCompositorOrder(RecordSet.getInt(10));
					reportCompositorOrderBean.setOrderType(Util.null2String(RecordSet.getString(9)));
					reportCompositorOrderBean.setFieldName(Util.null2String(RecordSet.getString(1)));
					reportCompositorOrderBean.setSqlFlag(viewtype);
					compositorOrderList.add(reportCompositorOrderBean);
				}
				
				if(isShowList.indexOf(Util.null2String(RecordSet.getString(8)))==-1){
					continue;
				}
				
				rcListBean = new ReportCompositorListBean();
				rcListBean.setCompositorList(RecordSet.getDouble(11));
				rcListBean.setSqlFlag(viewtype);
				rcListBean.setFieldName(colname);
				rcListBean.setFieldId(Util.null2String(RecordSet.getString(8)));
				rcListBean.setColName(Util.toScreen(RecordSet.getString(2),user.getLanguage()));
				compositorColList.add(rcListBean);
				fields.add(Util.null2String(RecordSet.getString(1))) ;
				
				String id = RecordSet.getString("id");
				String htmltype = RecordSet.getString("fieldhtmltype");
				String label =  RecordSet.getString("labelname");
				String type =  RecordSet.getString("type");
				String isbill = "1";
				String dbtype = RecordSet.getString("fielddbtype");
				String istitle = "0";
				String opentype = "0";
				String showmethod = "0";
				String colName = "a_"+name;
				if(viewtype.equals("a")){
					colName = "a_"+name;
				}else{
					colName = otherName;
				}
				
				String para3="column:id+"+id+"+"+htmltype+"+"+type+"+"+user.getLanguage()+"+"+isbill+"+"+dbtype+"+"+istitle+"+"+modeid+"+"+formid+"+"+viewtype+"+"+opentype+"+"+reportid+"+fromsearchlist"+"+"+showmethod;
					//tableString+="			    <col width=\""+temocolwidth+"%\" text=\""+label+"\"  column=\""+colName+"\"  otherpara=\""+para3+"\"   transmethod=\"weaver.formmode.search.FormModeTransMethod.getOthers\"/>";
					
				if(Util.getIntValue(RecordSet.getString("isstat"),0)==1){
               		if(Util.getIntValue(RecordSet.getString("fieldhtmltype"),0)==1){
               			allstatfield+=colName+",";
            			if(type.equals("5")){
            				countColumnsDbType.put(colName,1);
            			}else{
            				countColumnsDbType.put(colName,0);
            			}
            			int digitsIndex = dbtype.indexOf(",");
        				int decimaldigits=2;
        	        	if(digitsIndex > -1){
        	        		decimaldigits = Util.getIntValue(dbtype.substring(digitsIndex+1, dbtype.length()-1), 2);
        	        		decimalFormat +="%."+decimaldigits+"f|";
        	        	}else{
        	        		decimalFormat +="%.0f|";
        	        	}
            		}
               	}
				
			}
				
		}
	}
	

	
	
	
	
	compositorColList2 = ReportComInfo.getCompositorList(compositorColList);
	for(int a = 0; a < compositorColList2.size(); a++){
		rcColListBean = (ReportCompositorListBean)compositorColList2.get(a);
		RecordSet.executeSql("select * from mode_ReportDspField where reportid = " + reportid + " and fieldid = " +rcColListBean.getFieldId());
		if(RecordSet.next()){
			String  tempfieldid = RecordSet.getString("fieldid");
			if("-1".equals(tempfieldid) || "-2".equals(tempfieldid)){
				htmltypes.add(tempfieldid);
				types.add(tempfieldid);
			} else {
				rs3.executeSql("select formid from mode_report b where   b.id = "+ reportid);
				if(rs3.next()){
					rs2.executeSql("select * from workflow_billfield where id = " + tempfieldid + " and billid=" + rs3.getString("formid"));
					if(rs2.next()){
						htmltypes.add(Util.null2String(rs2.getString("fieldhtmltype")));
						types.add(Util.null2String(rs2.getString("type")));
					}
				}
			}
			fieldids.add(tempfieldid);
			if(Util.null2String(RecordSet.getString("isstat")).equals("1")) {
				statcount ++ ;
				isstats.add("1") ;
			} else { 
				isstats.add("") ;
			}
			statvalues.add("") ;
			tempstatvalues.add("") ;
			if(!Util.null2String(RecordSet.getString("dbordertype")).equals("n")) {
				ordercount ++ ;
				isdborders.add("1") ;
			} else { 
				isdborders.add("") ;
			}
		}
	}
	fieldname =  ReportComInfo.getCompositorListByStrs(compositorColList)+",cast(a.id as varchar(100)) id ";
	
	orderbystr = ReportComInfo.getCompositorOrderByStrs(compositorOrderList);
  
	sql = " select tablename , detailtablename , detailkeyfield from workflow_bill where id = " + formid ;
	RecordSet.execute(sql) ;
	RecordSet.next() ;
	tablename = Util.null2String(RecordSet.getString(1)) ;
	detailtablename = Util.null2String(RecordSet.getString(2)) ;
	detailkeyfield = Util.null2String(RecordSet.getString(3)) ;
 	int indexflag = 1;
 	detailtablename = "";
 	RecordSet.executeSql("select tablename from workflow_billdetailtable where billid="+formid);
 	while(RecordSet.next()){
 		detailtablename += RecordSet.getString("tablename")+",";
 		if(useddetailtable.toUpperCase().indexOf("," + Util.null2String(RecordSet.getString("tablename")).toUpperCase()) > -1 ) {
			fieldname += ","+RecordSet.getString("tablename")+".id as " + RecordSet.getString("tablename") + "_id_" ;
 			indexflag++;
 		}
 	}
	
	String otherSqlWhere = "";
	
    if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2")) {
		sql = " select " + fieldname + " from " ;
	} else {
		sql = " select top 1000000 " + fieldname + " from " ;
	}
    sql += tablename + " a ";
	String sqlfrom = "from "+tablename +" a ";
    if(detailcount != 0 ) {
   		List detailtablenameList = Util.TokenizerString(detailtablename, ",");
   		for(int tempInt=0;tempInt<detailtablenameList.size();tempInt++){
   			String tempdetailtablename = (String)detailtablenameList.get(tempInt);
   			if(useddetailtable.toUpperCase().indexOf("," + tempdetailtablename.toUpperCase()) > -1 ) {
   				sqlfrom += " LEFT JOIN "+tempdetailtablename + " ON a.id="+tempdetailtablename+"."+detailkeyfield;
   				sql += " LEFT JOIN "+tempdetailtablename + " ON a.id="+tempdetailtablename+"."+detailkeyfield;
   			}
   		}
    }
    
    String backfields = fieldname;
    
	orderbystr = orderbystr.replace("order by","");
	//tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+wfreportnumperpage+"\" >"+
    //"	   <sql backfields=\""+backfields+"\" sumColumns=\""+allstatfield+"\" decimalFormat=\""+decimalFormat+"\" countColumnsDbType=\""+countColumnsDbType+"\"   sqlform=\""+Util.toHtmlForSplitPage(sqlfrom)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderbystr+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"asc\"  />"+
    //"			<head>"
   // + tableString 
   // +"			</head>"+   			
   // "</table>";
    
    if (sqlwhere.length() > 0){
		sql += " where " + sqlwhere;
    }
    if(orderbystr.length()>0){
	    sql +=" order by "+ orderbystr ;
    }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript"  src="/wui/common/jquery/jquery_wev8.js"></script>
<script type="text/javascript"  src="/js/weaverTable_wev8.js"></script>
</head>
<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showdata(){
    var ajax=ajaxinit();
    ajax.open("POST", "ReportResultData.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    var datasql = "<%=xssUtil.put(sql)%>";
    ajax.send("pmSql="+encodeURIComponent(datasql)+"&reportid=<%=reportid%>&isShowList=<%=isShowList.toString()%>&useddetailtable=<%=useddetailtable%>&pageSize=<%=wfreportnumperpage%>");
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.all("showdatadiv").innerHTML=ajax.responseText;
                jQuery("#reportDateTbl tbody tr").hover(function () {
                	jQuery(this).addClass("Selected");
                }, function () {
                	jQuery(this).removeClass("Selected");
        		});
                e8showAjaxTips("",false);
            }catch(e){
                return false;
            }
        }
    }
}

function jumpTo(jumpNum, jumpToEle){
	var pageSize = $("input[name='pageSize']").val();
	var currentPage = jumpNum;
	var rowcount = $("input[name='rowcount']").val();
	var pageCount = $("input[name='pageCount']").val();
	
	if (parseInt(currentPage) > parseInt(pageCount)) {
		$(jumpToEle).val($("input[name='currentPage']").val());
		return;
	}
	
	if (parseInt(currentPage) == parseInt($("input[name='currentPage']").val())) {
		return ;
	}
	
	var pTop= document.body.offsetHeight/4+document.body.scrollTop-100;
	//waitDiv.style.display = "block";
	//waitDiv.style.top = pTop;
	e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(25666,user.getLanguage())%>",true,"xTable_message");//服务器正在处理,请稍等...
	
    var ajax=ajaxinit();
    ajax.open("POST", "ReportResultData.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    var datasql = "<%=xssUtil.put(sql)%>";
    ajax.send("pmSql="+encodeURIComponent(datasql)+"&reportid=<%=reportid%>&isShowList=<%=isShowList.toString()%>&useddetailtable=<%=useddetailtable%>" + "&pageSize=" + pageSize + "&currentPage=" + currentPage + "&rowcount=" + rowcount + "&pageCount=" + pageCount);
    ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.all("showdatadiv").innerHTML=ajax.responseText;
                jQuery("#reportDateTbl tbody tr").hover(function () {
                	jQuery(this).addClass("Selected");
                }, function () {
                	jQuery(this).removeClass("Selected");
        		});
                e8showAjaxTips("",false);
            }catch(e){
                return false;
            }
        }
    }
}

function outputexcel() {
	var pTop= document.body.offsetHeight/4+document.body.scrollTop-100;
	e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(25666,user.getLanguage())%>",true,"xTable_message");//服务器正在处理,请稍等...
	var datasql = "<%=xssUtil.put(sql)%>";
    var excelOutForm = document.getElementById("ExcelOut").contentWindow.document.createElement("form");
    document.getElementById("ExcelOut").contentWindow.document.body.appendChild(excelOutForm);
    excelOutForm.action = "/formmode/report/ReportResultData.jsp?reportid=<%=reportid%>&isShowList=<%=isShowList.toString()%>&useddetailtable=<%=useddetailtable%>&outputExcel=1";
    excelOutForm.method = "POST";
    var excelOutParam = "<INPUT type=\"hidden\" name=\"pmSql\" value=\"" + datasql + "\">";
    excelOutForm.innerHTML = excelOutParam
    excelOutForm.submit();
}

</script>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(15101,user.getLanguage());//报表
String needfav ="1";
String needhelp ="";
%>
<BODY onload="showdata()">

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="window.history.back(-1);" value="<%=SystemEnv.getHtmlLabelName(15518,user.getLanguage())%>"><!-- 重新查询 -->
			<input type=button class="e8_btn_top" onclick="outputexcel();" value="Excel">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>
<div id="waitDiv" style="position:absolute;left:460px;top:340px;z-index:100;display:none;height:25px;width:140px;text-align: center;">
	<table name="scrollarea" width="140px" height="25px" style="display:inline;zIndex:-1;valign：middle;" >
		<tr>
			<td align="center" valign="center" >
				<fieldset style="width: 140px; height: 25px;background:#Fff;border-width:1px;padding-top: 5px;">
					<%=SystemEnv.getHtmlLabelName(25666,user.getLanguage())%></fieldset>
			</td>
		</tr>
	</table>
</div>

<div id="excelwaitDiv" style="position:absolute;left:460px;top:340px;z-index:100;display:none;height:25px;;width:140px;">
	<table name="scrollarea" width="140px;" height="25px;" style="display:inline;zIndex:-1" >
		<tr>
			<td align="center" valign="center" >
				<fieldset style="width: 140px; height: 25px;background:#Fff;border-width:1px;padding-top: 5px;">
					<span id="excelMsgSpan"><%=SystemEnv.getHtmlLabelName(25666,user.getLanguage())%></span></fieldset>
			</td>
		</tr>
	</table>
</div>

<div id="showdatadiv">
</div>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15518,user.getLanguage())+",javascript:window.history.back(-1),_self} " ;//重新查询
RCMenuHeight += RCMenuHeightStep;
%>

<%
RCMenu += "{"+"Excel,javascript:outputexcel(), ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
<style type="text/css">
Table.ListStyle TR.Selected td {
	color: #000;
	background:#f5fafb;
}

.PrevPage{
cursor:hand;
}
</style>
</HTML>
