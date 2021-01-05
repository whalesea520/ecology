
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ page import="weaver.file.*,java.math.BigDecimal,java.lang.*" %>
<%@ page import="weaver.workflow.report.ReportCompositorOrderBean" %><!--ReportCompositorOrderBean is added by xwj for td2099 on 20050608-->
<%@ page import="weaver.workflow.report.ReportCompositorListBean" %><!--ReportCompositorListBean is added by xwj for td2451 on 20051114-->
 <%@ page import="weaver.workflow.report.ReportUtilComparator" %>
 <%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<!--added by xwj for td2974 20051026-->
 <jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj for td2974 20051026-->
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj for td2974 20051026-->
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj for td2974 20051026-->
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />

<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page"/>

<jsp:useBean id="rscominfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rsvcominfo" class="weaver.hrm.companyvirtual.ResourceVirtualComInfo" scope="page"/>
<jsp:useBean id="deptcominfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="deptvcominfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" />


<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="LedgerComInfo" class="weaver.fna.maintenance.LedgerComInfo" scope="page"/>
<jsp:useBean id="ExpensefeeTypeComInfo" class="weaver.fna.maintenance.ExpensefeeTypeComInfo" scope="page"/>
<jsp:useBean id="MDCompanyNameInfo" class="weaver.workflow.report.ReportShare" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<jsp:useBean id="resourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
	
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
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
String guid1 = FnaCommon.getPrimaryKeyGuid1();
HashMap<String, String> colNameAliasNameHm = new HashMap<String, String>();
request.getSession().setAttribute(guid1+"_colNameAliasNameHm", colNameAliasNameHm);
//报表id
String reportid = Util.null2String(request.getParameter("reportid")) ;
String useddetailtable = "";
if(reportid.equals("")){
	reportid="0";
}

//模板id
int mouldId = Util.getIntValue(request.getParameter("mouldId"),0);

//是否根据模板id查询  1:根据模板查询  其他：不根据模板查询
String searchByMould = Util.null2String(request.getParameter("searchByMould")) ;

//modify by xhheng @20050126 for TD 1614
int sharelevel_0 = -1 ;    //标记原有共享范围"总部"
int sharelevel_1 = -1 ;    //标记原有共享范围"同部门"、"同分部"
int sharelevel_2 = -1 ;    //标记新共享范围"同部门下级部门"
int sharelevel_3 = -1;     //标记新共享范围"多部门"
int sharelevel_4 = -1;     //标记新共享范围"个人"
int sharelevel_5 = -1;     //标记新共享范围"多分部"
String mutidepartmentids="";//多部门



String mutisubcompanyids="";//多分部




String cUserid = String.valueOf(user.getUID());
String currentDept = "";
String currentSubcom = "";
String cVirDept = "";//其他维度部门
String cVirSubcom = "";//其他维度部门
String currentRoleid = ",";
String currentJobtitleid = "";//当前操作者岗位
Map<String,String> reportMap = new HashMap<String, String>();

currentJobtitleid = rscominfo.getJobTitle(cUserid);
currentDept = rscominfo.getDepartmentID(cUserid);
currentSubcom = rscominfo.getSubCompanyID(cUserid);
cVirDept = rsvcominfo.getDepartmentids(cUserid);
cVirSubcom = rsvcominfo.getSubcompanyids(cUserid);

String currentDeptAll = "";
String currentSubcomAll = "";
if(!"".equals(cVirDept)){
	currentDeptAll = currentDept + "," + cVirDept;
}
if(!"".equals(cVirSubcom)){
	currentSubcomAll = currentSubcom + "," + cVirSubcom;
}

RecordSet.executeSql("SELECT roleid FROM HrmRoleMembers WHERE resourceid = '"+cUserid + "'");
while(RecordSet.next()) {
	currentRoleid += RecordSet.getString("roleid")+",";
}
if(currentRoleid.length() == 1){
	currentRoleid = "";
}

int seclevel = Integer.parseInt(user.getSeclevel());
RecordSet.executeSql("SELECT shareType,userid,departmentid,subcompanyid,roleid,sharelevel,mutidepartmentid,seclevel,seclevel2 FROM WorkflowReportShare WHERE reportid="+reportid);

while(RecordSet.next()) {
	String shareType = Util.null2String(RecordSet.getString("shareType"));
	String userid = Util.null2String(RecordSet.getString("userid"));
	String departmentid = Util.null2String(RecordSet.getString("departmentid"));
	String subcompanyid = Util.null2String(RecordSet.getString("subcompanyid"));
	String roleid = Util.null2String(RecordSet.getString("roleid"));
	String sharelevel = Util.null2String(RecordSet.getString("sharelevel"));
	String mutidepartmentid = Util.null2String(RecordSet.getString("mutidepartmentid"));//共享查看范围
	int seclevel1 = Util.getIntValue(RecordSet.getString("seclevel"),0);
	int seclevel2 = Util.getIntValue(RecordSet.getString("seclevel2"),100);
    if((seclevel < seclevel1 || seclevel > seclevel2) && !shareType.equals("6") && !shareType.equals("1")) {
          continue;
    }
	if(shareType.equals("1") && !userid.equals("")){//人力资源
		if((userid.startsWith(",") && (userid.indexOf(","+cUserid+",") > -1)) || userid.equals(cUserid)){
			reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
		}
	}
	if(shareType.equals("2") && !subcompanyid.equals("")){//分部
		if((subcompanyid.startsWith(",") && subcompanyid.indexOf(","+currentSubcom+",") > -1) || subcompanyid.equals(currentSubcom)){
			reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
		}else{
			if(!"".equals(cVirSubcom)){
				if(cVirSubcom.indexOf(",") > -1){
					String virSubcoms[] = Util.TokenizerString2(cVirSubcom,",");
					for(int s=0;s<virSubcoms.length;s++){
						if((subcompanyid.startsWith(",") && subcompanyid.indexOf(","+virSubcoms[s]+",") > -1) || subcompanyid.equals(virSubcoms[s])){
							reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
						}
					}
				}else{
					if((subcompanyid.startsWith(",") && subcompanyid.indexOf(","+cVirSubcom+",") > -1) || subcompanyid.equals(cVirSubcom)){
						reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
					}
				}
			}
		}
	}
	if(shareType.equals("3") && !departmentid.equals("")){//部门
		if((departmentid.startsWith(",") && departmentid.indexOf(","+currentDept+",") > -1) || departmentid.equals(currentDept)){
			reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
		}else{
			if(!"".equals(cVirDept)){
				if(cVirDept.indexOf(",") > -1){
					String virDepts[] = Util.TokenizerString2(cVirDept,",");
					for(int s=0;s<virDepts.length;s++){
						if((departmentid.startsWith(",") && departmentid.indexOf(","+virDepts[s]+",") > -1) || departmentid.equals(virDepts[s])){
							reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
						}
					}
				}else{
					if((departmentid.startsWith(",") && departmentid.indexOf(","+cVirDept+",") > -1) || departmentid.equals(cVirDept)){
						reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
					}
				}
			}
		}
	}
	if(shareType.equals("4") && !roleid.equals("") && !roleid.equals("0") && !currentRoleid.equals("")){//角色
		if(currentRoleid.startsWith(",") && currentRoleid.indexOf(","+roleid+",") > -1){
				reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
		}
	}
	if(shareType.equals("5")){//所有人
		reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
	}
	if(shareType.equals("6") && !userid.equals("")){//岗位
		if((userid.startsWith(",") && (userid.indexOf(","+currentJobtitleid+",") > -1)) || userid.equals(currentJobtitleid)){
			if(seclevel1 == 0){
				if((departmentid.startsWith(",") && departmentid.indexOf(","+currentDept+",") > -1) || departmentid.equals(currentDept)){
					reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
    			}else{
	    			if(!"".equals(cVirDept)){
	    				if(cVirDept.indexOf(",") > -1){
	    					String virDepts[] = Util.TokenizerString2(cVirDept,",");
	    					for(int s=0;s<virDepts.length;s++){
	    						if((departmentid.startsWith(",") && departmentid.indexOf(","+virDepts[s]+",") > -1) || departmentid.equals(virDepts[s])){
	    							reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
	    						}
	    					}
	    				}else{
	    					if((departmentid.startsWith(",") && departmentid.indexOf(","+cVirDept+",") > -1) || departmentid.equals(cVirDept)){
	    						reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
    						}
	    				}
	    			}
    			}
			}else if(seclevel1 == 1){
				if((departmentid.startsWith(",") && departmentid.indexOf(","+currentSubcom+",") > -1) || departmentid.equals(currentSubcom)){
					reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
    			}else{
	    			if(!"".equals(cVirSubcom)){
	    				if(cVirSubcom.indexOf(",") > -1){
	    					String virSubcoms[] = Util.TokenizerString2(cVirSubcom,",");
	    					for(int s=0;s<virSubcoms.length;s++){
	    						if((departmentid.startsWith(",") && departmentid.indexOf(","+virSubcoms[s]+",") > -1) || departmentid.equals(virSubcoms[s])){
	    							reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
	    						}
	    					}
	    				}else{
	    					if((departmentid.startsWith(",") && departmentid.indexOf(","+cVirSubcom+",") > -1) || departmentid.equals(cVirSubcom)){
	    						reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
    						}
	    				}
	    			}
    			}
			}else{
				reportMap.put(sharelevel+"#"+mutidepartmentid,mutidepartmentid);
			}
		}
	}
}
String hasrightdeps = "" ;
String hassubcompany = "" ;
if(!reportMap.isEmpty()){
	for(String key : reportMap.keySet()){
		String shares[] = Util.TokenizerString2(key,"#");
		if(shares[0].equals("9")){
			sharelevel_3=Integer.parseInt(shares[0]);
			mutidepartmentids += reportMap.get(key) + ",";
		}else if(shares[0].equals("5")){
			sharelevel_5=Integer.parseInt(shares[0]);
			mutisubcompanyids += reportMap.get(key) + ",";
		}else{
			 if(shares[0].equals("3")){
		     	sharelevel_2 = Integer.parseInt(shares[0]);
			}else if(shares[0].equals("4")){
	            sharelevel_4=Integer.parseInt(shares[0]);
	        }else if(shares[0].equals("2")){
	        	sharelevel_0=Integer.parseInt(shares[0]);
	        }else{
	            sharelevel_1=Integer.parseInt(shares[0]);
	            if(sharelevel_1 == 0) {
	            	//if(hasrightdeps.equals("")) hasrightdeps = ""+ new Integer(user.getUserDepartment()).toString();
	            	//else hasrightdeps += ","+ new Integer(user.getUserDepartment()).toString() ;
	            	if(hasrightdeps.equals("")){
	            		hasrightdeps = ""+ currentDeptAll;
	            	}else{
	            		hasrightdeps += "," + currentDeptAll;
	            	}
	            }
	            if(sharelevel_1 == 1) {
	                //while(DepartmentComInfo.next()){
	                //    String cursubcompanyid = DepartmentComInfo.getSubcompanyid1();
	                //    if(!(""+user.getUserSubCompany1()).equals(cursubcompanyid)) continue;
	                //    String tempdepartment = ""+DepartmentComInfo.getDepartmentid() ;
	                //    if(hasrightdeps.equals("")) hasrightdeps = tempdepartment ;
	                //    else hasrightdeps += ","+ tempdepartment ;
	                //}
	                if(hassubcompany.equals("")){
	                	hassubcompany = currentSubcomAll;
	                }else{
	                	hassubcompany += ","+ currentSubcomAll;
	                }
	            }
	        }
		}
		
	}
}

if(!"".equals(mutidepartmentids)){
	if(mutidepartmentids.endsWith(",")){
		mutidepartmentids = mutidepartmentids.substring(0, mutidepartmentids.length() -1);
	}
}
if(!"".equals(mutisubcompanyids)){
	if(mutisubcompanyids.endsWith(",")){
		mutisubcompanyids = mutisubcompanyids.substring(0, mutisubcompanyids.length() -1);
	}
}

/*RecordSet.executeSql("select sharelevel,mutidepartmentid from WorkflowReportShareDetail where userid="+user.getUID()+" and usertype=1 and reportid="+reportid+" order by sharelevel");
while(RecordSet.next()) {
    int sharelevel_tmp = Util.getIntValue(RecordSet.getString("sharelevel"),0) ;
    if(sharelevel_tmp==9){
        sharelevel_3=sharelevel_tmp;
        mutidepartmentids=Util.null2String(RecordSet.getString("mutidepartmentid"));
       // if(mutidepartmentids.length()>1) mutidepartmentids=mutidepartmentids.substring(1,mutidepartmentids.length());
    }else{
        if(sharelevel_tmp==3){
            sharelevel_2=sharelevel_tmp;
        }
        else if(sharelevel_tmp==4){
            sharelevel_4=sharelevel_tmp;
        }
        else{
            sharelevel_1=sharelevel_tmp;
        }
    }
}
*/

//System.out.println(sharelevel_0+"|"+sharelevel_1+"|"+sharelevel_2+"|"+sharelevel_3+"|"+sharelevel_4+"|"+sharelevel_5);
if(sharelevel_0 == -1 && sharelevel_1 == -1 && sharelevel_2 == -1 && sharelevel_3==-1 && sharelevel_4 == -1 && sharelevel_5 == -1) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}


//add by xhheng @20050126 for TD 1614
if(sharelevel_2 == 3) {//标记新共享范围"同部门下级部门"
	//行政组织下所有下级部门

	String allChildDept = "";
	if(!"".equals(currentDept) && !"".equals(deptcominfo.getAllChildDepartId(currentDept,""))){
		allChildDept += ","+deptcominfo.getAllChildDepartId(currentDept,"");
	}
	if(hasrightdeps.equals("")){
		hasrightdeps = allChildDept;
	}else {
        hasrightdeps+=","+allChildDept;
    }
	//多维组织下所有下级部门

	String allChildVirDept = "";
	if(!"".equals(cVirDept)){
		if(cVirDept.indexOf(",") > -1){
			String virDepts[] = Util.TokenizerString2(cVirDept,",");
			for(int f=0;f<virDepts.length;f++){
				if(!"".equals(deptvcominfo.getAllChildDepartId(virDepts[f],""))){
					if("".equals(allChildVirDept)){
						allChildVirDept = deptvcominfo.getAllChildDepartId(virDepts[f],"");
					}else{
						allChildVirDept += ","+deptvcominfo.getAllChildDepartId(virDepts[f],"");
					}
				}
			}
		}else{
			if(!"".equals(deptvcominfo.getAllChildDepartId(cVirDept,""))){
				allChildVirDept += ","+deptvcominfo.getAllChildDepartId(cVirDept,"");
			}
		}
	}
	if(!"".equals(allChildVirDept)){
        hasrightdeps+=","+allChildVirDept;
    }
	while(hasrightdeps.indexOf(",,") > -1){
		hasrightdeps = hasrightdeps.replaceAll(",,",",");
	}
	if(hasrightdeps.indexOf(",") == 0){
		hasrightdeps = hasrightdeps.substring(1,hasrightdeps.length());
	}
	if(hasrightdeps.endsWith(",")){
		hasrightdeps = hasrightdeps.substring(0,hasrightdeps.length()-1);
	}
}
if(sharelevel_3==9){
    if(hasrightdeps.equals("")) hasrightdeps = mutidepartmentids;
    else hasrightdeps+=","+mutidepartmentids;
}

if(sharelevel_5==5){
    if(hassubcompany.equals("")) hassubcompany = mutisubcompanyids;
    else hassubcompany+=","+mutisubcompanyids;
}

if (hasrightdeps.equals("")) hasrightdeps="-100";
if (hassubcompany.equals("")) hassubcompany="-100";
if(hasrightdeps.startsWith(",")) hasrightdeps = hasrightdeps.substring(1);
if(hassubcompany.startsWith(",")) hassubcompany = hassubcompany.substring(1);
String userrightsql = "";
if (sharelevel_4 == 4)
{
	userrightsql = " or c.userid= " + user.getUID();
}
String otherSqlWhere = "";
if(RecordSet.getDBType().equals("oracle"))
{
	otherSqlWhere += " and nvl(r.currentstatus,-1) = -1 ";
}
else
{
	otherSqlWhere += " and isnull(r.currentstatus,-1) = -1 ";
}

//System.out.println(hasrightdeps);
//String[] checkcons = request.getParameterValues("check_con");//报表条件
String[] checkcons =null;//报表条件
String[] isShowArray = null;//报表列



List isShowList=new ArrayList();//显示的列的字段id

//String formid = Util.null2String(request.getParameter("formid")) ;
//String isbill = Util.null2String(request.getParameter("isbill")) ;
String formid="";
String isbill="";
String reportwfid = "";
rs2.executeSql("select reportname,formId,isBill,reportwfid from workflow_report where id = " + reportid);
String titlename1 = "";
if(rs2.next()){
    titlename1 = rs2.getString("reportname") ;
    formid = rs2.getString("formId") ;
    isbill = rs2.getString("isBill") ;
    reportwfid = rs2.getString("reportwfid") ;
}
boolean isNewBill = false;
if(isbill.equals("1")){
	rs2.executeSql("select id, tablename from workflow_bill where id="+formid);
	if(rs2.next()){
		int tempid = rs2.getInt("id");
		String temptablename = rs2.getString("tablename");
		if(temptablename.equals("formtable_main_"+tempid*(-1)) || temptablename.startsWith("uf_")) isNewBill=true;
	}
}

if("85".equals(formid)){

	isNewBill=true;

}


String sql = "" ;
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


if(searchByMould!=null&&searchByMould.equals("1")){//根据模板id查询时




    RecordSet.execute("select fieldId,isMain,isShow,isCheckCond,colName,htmlType,type,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond from WorkflowRptCondMouldDetail where mouldId="+mouldId) ;

    while(RecordSet.next()){
	    ids.add(Util.null2String(RecordSet.getString("fieldId")));
	    isMains.add(Util.null2String(RecordSet.getString("isMain")));
	    isShows.add(Util.null2String(RecordSet.getString("isShow")));
	    isCheckConds.add(Util.null2String(RecordSet.getString("isCheckCond")));
	    colnames.add(Util.null2String(RecordSet.getString("colName")));
	    htmlTypes.add(Util.null2String(RecordSet.getString("htmlType")));
	    typeTemps.add(Util.null2String(RecordSet.getString("type")));
	    opts.add(Util.null2String(RecordSet.getString("optionFirst")));
	    values.add(Util.null2String(RecordSet.getString("valueFirst")));
	    names.add(Util.null2String(RecordSet.getString("nameFirst")));
	    opt1s.add(Util.null2String(RecordSet.getString("optionSecond")));
	    value1s.add(Util.null2String(RecordSet.getString("valueSecond")));
    }

    List isCheckCondList=new ArrayList();

    String fieldId="";
	String isShow="";
	String isCheckCond="";

	for(int i=0;i<ids.size();i++){
		fieldId=(String)ids.get(i);
		isShow=(String)isShows.get(i);
		isCheckCond=(String)isCheckConds.get(i);

        if(isShow!=null&&isShow.equals("1")){
			isShowList.add(fieldId);
		}

        if(isCheckCond!=null&&isCheckCond.equals("1")){
			isCheckCondList.add(fieldId);
		}


	}

    int isCheckCondListCount = isCheckCondList.size();
    checkcons = new String[isCheckCondListCount];
    for (int i = 0; i < isCheckCondListCount; i++) {
        checkcons[i] = (String) isCheckCondList.get(i);
    }


}else{

	checkcons = request.getParameterValues("check_con");//报表条件
	isShowArray = request.getParameterValues("isShow");//报表列




    if(isShowArray!=null){
        for(int i=0;i<isShowArray.length;i++){
		    isShowList.add(isShowArray[i]);
	    }
	}

    String requestNameIsShow = request.getParameter("requestNameIsShow");//请求标题
    String requestLevelIsShow = request.getParameter("requestLevelIsShow");//紧急程度



    /**2014add**/
    String createmanIsShow = request.getParameter("createmanIsShow");//创建人



    String createdateIsShow = request.getParameter("createdateIsShow");//创建日期
    String workflowtoIsShow = request.getParameter("workflowtoIsShow");//工作流



    String currentnodeIsShow = request.getParameter("currentnodeIsShow");//当前节点
    String nooperatorIsShow = request.getParameter("nooperatorIsShow");//未操作者



    String requestStatusIsShow = request.getParameter("requeststatusIsShow");//流程状态



    String filingdateIsShow = request.getParameter("filingdateIsShow");//归档日期 receivedateIsShow
    //String signopinionsIsShow = request.getParameter("signopinionsIsShow");//签字意见

	if(requestNameIsShow!=null&&requestNameIsShow.equals("1")){
		isShowList.add("-1");
	}

	if(requestLevelIsShow!=null&&requestLevelIsShow.equals("1")){
		isShowList.add("-2");
	}

	//----add------
	if(createmanIsShow!=null&&createmanIsShow.equals("1")){
		isShowList.add("-10");
	}
	if(createdateIsShow!=null&&createdateIsShow.equals("1")){
		isShowList.add("-11");
	}
	if(workflowtoIsShow!=null&&workflowtoIsShow.equals("1")){
		isShowList.add("-12");
	}
	if(currentnodeIsShow!=null&&currentnodeIsShow.equals("1")){
		isShowList.add("-13");
	}
	if(nooperatorIsShow!=null&&nooperatorIsShow.equals("1")){
		isShowList.add("-14");
	}
	if(requestStatusIsShow!=null&&requestStatusIsShow.equals("1")){
		isShowList.add("-15");
	}
	if(filingdateIsShow!=null&&filingdateIsShow.equals("1")){
		isShowList.add("-16");
	}
	//if(signopinionsIsShow!=null&&signopinionsIsShow.equals("1")){
	//	isShowList.add("-17");
	//}
}



String sqlwhere = "";
String sqlrightwhere = "";
String temOwner = "";



if(checkcons!=null){

	for(int i=0;i<checkcons.length;i++){
		String tmpid = ""+checkcons[i];
		if(tmpid==null||tmpid.equals("")||tmpid.equals("-1")||tmpid.equals("-2")||tmpid.equals("-3")){
			continue;
		}

//		String ismain = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_ismain"));
//		String tmpcolname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_colname"));
//		String tmphtmltype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_htmltype"));
//		String tmptype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_type"));
//		String tmpopt = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt"));
//		String tmpvalue = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value"));
////		String tmpname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_name"));
//		String tmpopt1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt1"));
//		String tmpvalue1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value1"));
////		ids.add(tmpid);
////		colnames.add(tmpcolname);
////		opts.add(tmpopt);
////		values.add(tmpvalue);
////		names.add(tmpname);
////		opt1s.add(tmpopt1);
////		value1s.add(tmpvalue1);

		String ismain = "";
		String tmpcolname = "";
		String tmphtmltype = "";
		String tmptype = "";
		String tmpopt = "";
		String tmpvalue = "";
		String tmpopt1 = "";
		String tmpvalue1 = "";

        if(searchByMould!=null&&searchByMould.equals("1")){//根据模板id查询时



		    int tmpIdIndexId=ids.indexOf(tmpid);
			if(tmpIdIndexId==-1){
				continue;
			}
			ismain=(String)isMains.get(tmpIdIndexId);
			tmpcolname=(String)colnames.get(tmpIdIndexId);
			tmphtmltype=(String)htmlTypes.get(tmpIdIndexId);
			tmptype=(String)typeTemps.get(tmpIdIndexId);
			tmpopt=(String)opts.get(tmpIdIndexId);
			tmpvalue=(String)values.get(tmpIdIndexId);
			tmpopt1=(String)opt1s.get(tmpIdIndexId);
			tmpvalue1=(String)value1s.get(tmpIdIndexId);

		}else{
			ismain = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_ismain"));
			tmpcolname = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_colname"));
			tmphtmltype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_htmltype"));
			tmptype = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_type"));
			tmpopt = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt"));
			tmpvalue = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value"));
			tmpopt1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_opt1"));
			tmpvalue1 = ""+Util.null2String(request.getParameter("con"+checkcons[i]+"_value1"));
		}
		//生成where子句

        if(ismain.equals("1")){
            temOwner = "a";
        }else{
            temOwner = "d";
						if(isNewBill){//新表单



							RecordSet.executeSql("select detailtable from workflow_billfield where billid="+formid+" and id="+tmpid);
							if(RecordSet.next()){
								temOwner = RecordSet.getString("detailtable");
							}
						}
        }
		
		if(tmphtmltype.equals("1")&& tmptype.equals("1")){
		  //应47268TD中的建议，对文本框中值为空时仍作为查询条件
			//不等于的时候不把空值和null查出来
			if(tmpopt.equals("2"))	{
                if(!tmpvalue.equals("")){
					sqlwhere +="and "+temOwner+"."+tmpcolname+" <>'"+tmpvalue +"' ";
                }else{
                    sqlwhere += "and ("+temOwner+"."+tmpcolname + " is not null or "+temOwner+"."+tmpcolname + " <>'') ";
                }
			};
			//不等于空的时候把空值和null查出来
			if(tmpopt.equals("1")){
                if(!tmpvalue.equals("")){
                    sqlwhere += "and "+temOwner+"."+tmpcolname;
                    sqlwhere+=" ='"+tmpvalue +"' ";
                }else{
                    sqlwhere += "and ("+temOwner+"."+tmpcolname + " is null or "+temOwner+"."+tmpcolname + " ='') ";
                }
			}
			if(tmpopt.equals("3")){
                if(!tmpvalue.equals("")){
					sqlwhere += "and "+temOwner+"."+tmpcolname;
					sqlwhere+=" like '%"+tmpvalue +"%' ";
				}else{
					sqlwhere += "and ("+temOwner+"."+tmpcolname + " like '%"+tmpvalue +"%' or "+temOwner+"."+tmpcolname + " is null) ";
				}
			}
			if(tmpopt.equals("4")){
				sqlwhere += "and "+temOwner+"."+tmpcolname;
				sqlwhere+=" not like '%"+tmpvalue +"%' ";
				}
			/**
			sqlwhere += "and "+temOwner+"."+tmpcolname;
			if(tmpopt.equals("1"))	sqlwhere+=" ='"+tmpvalue +"' ";
			if(tmpopt.equals("2"))	sqlwhere+=" <>'"+tmpvalue +"' ";
			if(tmpopt.equals("3"))	sqlwhere+=" like '%"+tmpvalue +"%' ";
			if(tmpopt.equals("4"))	sqlwhere+=" not like '%"+tmpvalue +"%' ";
			*/
		}
		else if(tmphtmltype.equals("2")){
			if(!tmpvalue.equals("")){
				sqlwhere += "and "+temOwner+"."+tmpcolname;
				if(tmpopt.equals("1"))	sqlwhere+=" ='"+tmpvalue +"' ";
				if(tmpopt.equals("2"))	sqlwhere+=" <>'"+tmpvalue +"' ";
				if(tmpopt.equals("3"))	sqlwhere+=" like '%"+tmpvalue +"%' ";
				if(tmpopt.equals("4"))	sqlwhere+=" not like '%"+tmpvalue +"%' ";
			}
		}
		else if(tmphtmltype.equals("1")&& !tmptype.equals("1")){
			if(!tmpvalue.equals("")){
				if(tmptype.equals("5")){
					sqlwhere += "and REPLACE("+temOwner+"."+tmpcolname+", ',', '')";
					tmpvalue = "CAST( "+tmpvalue+" AS FLOAT)";
				} else {
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
				if(tmptype.equals("5")){
					sqlwhere += "and REPLACE("+temOwner+"."+tmpcolname+", ',', '')";
					tmpvalue1 = "CAST( "+tmpvalue1+" AS FLOAT)";
				} else {
					sqlwhere += "and "+temOwner+"."+tmpcolname;
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
		else if(tmphtmltype.equals("3") && !tmptype.equals("165") && !tmptype.equals("166")&& !tmptype.equals("167")&& !tmptype.equals("168")&& !tmptype.equals("169")&& !tmptype.equals("170")&& !tmptype.equals("194")&& !tmptype.equals("2") && !tmptype.equals("4") && !tmptype.equals("18") && !tmptype.equals("19")&& !tmptype.equals("17") && !tmptype.equals("37")  && !tmptype.equals("65")&& !tmptype.equals("57")&& !tmptype.equals("152")&& !tmptype.equals("162")&& !tmptype.equals("135")&& !tmptype.equals("137")&& !tmptype.equals("224")&& !tmptype.equals("225")&& !tmptype.equals("226")&& !tmptype.equals("227")&& !tmptype.equals("142") && !tmptype.equals("256") && !tmptype.equals("257")&& !tmptype.equals("24")&& !tmptype.equals("278")){
				if(!tmpvalue.equals("")){
					if (rs1.getDBType().equals("sqlserver") && isbill.equals("1") && !isNewBill && tmptype.equals("161")){
				     sqlwhere += "and CONVERT(varchar(4000),"+temOwner+"."+tmpcolname+")";
				  } else {
					   if(rs1.getDBType().equals("sqlserver")){
						if(tmptype.equals("160")){
							sqlwhere += "and ','+"+temOwner+"."+tmpcolname+"+','";
						}else{
							sqlwhere += "and "+temOwner+"."+tmpcolname;
						}
					  }else{
						if(tmptype.equals("160")){
							sqlwhere += "and ','||"+temOwner+"."+tmpcolname+"||','";
						}else{
							sqlwhere += "and "+temOwner+"."+tmpcolname;
						}
					  }
					}
					if(tmptype.equals("161")){
					  if(tmpopt.equals("1"))	sqlwhere+=" ='"+tmpvalue +"' ";
					  if(tmpopt.equals("2"))	sqlwhere+=" <>'"+tmpvalue +"' ";
			    } else{
					  if(tmptype.equals("160")){
							if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
							if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
						}else{
							if(tmpopt.equals("1"))	sqlwhere+=" ="+Util.getIntValue(tmpvalue) +" ";
							if(tmpopt.equals("2"))	sqlwhere+=" <>"+Util.getIntValue(tmpvalue) +" ";
						}
					}
				}
		}else if(tmphtmltype.equals("3") &&  (tmptype.equals("224")||tmptype.equals("225")||tmptype.equals("226")||tmptype.equals("227"))){
						if(!tmpvalue.equals("")){
							  sqlwhere += "and "+temOwner+"."+tmpcolname;
							  if(tmpopt.equals("1"))	sqlwhere+=" ='"+tmpvalue +"' ";
							  if(tmpopt.equals("2"))	sqlwhere+=" <>'"+tmpvalue +"' ";
						}

		}
		else if(tmphtmltype.equals("3") &&  tmptype.equals("137")){
			if(!tmpvalue.equals("")){
				sqlwhere += "and "+temOwner+"."+tmpcolname;
				if(tmpopt.equals("1"))	sqlwhere+=" ='"+Util.getIntValue(tmpvalue) +"' ";
				if(tmpopt.equals("2"))	sqlwhere+=" <>'"+Util.getIntValue(tmpvalue) +"' ";
			}
		}
		else if(tmphtmltype.equals("3") && (tmptype.equals("4") || tmptype.equals("165") || tmptype.equals("167") || tmptype.equals("169") || tmptype.equals("256") || tmptype.equals("24"))){
            if(!tmpvalue.equals("")){
            	
            	sqlwhere += "and "+temOwner+"."+tmpcolname;
				if(tmptype.equals("256") || tmptype.equals("24")){
					if(",".equals(tmpvalue.substring(0,1))){
				       tmpvalue = tmpvalue.substring(1);
				  	}
					String temporary = "";
					if(tmpvalue.indexOf(",") > -1){
						String [] arraypara = Util.TokenizerString2(tmpvalue, ",");
						for(int p=0; p<arraypara.length; p++) {
							if("".equals(temporary)){
								temporary += "'"+arraypara[p]+"'";
							}else{
								temporary += ","+"'"+arraypara[p]+"'";
							}
						}
						tmpvalue = temporary;
					}else{
						tmpvalue = "'"+tmpvalue+"'";
					}
					if(tmpopt.equals("1"))	sqlwhere+=" in("+tmpvalue +") ";
					if(tmpopt.equals("2"))	sqlwhere+=" not in("+tmpvalue +") ";
				}else{
	              	if(",".equals(tmpvalue.substring(0,1))){
				       tmpvalue = tmpvalue.substring(1);
				  	}
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

				
			}
			if(!tmpvalue1.equals("")){
				if(!tmpvalue1.equals(""))
					sqlwhere += " and "+temOwner+"."+tmpcolname;
				if(tmpopt1.equals("1"))	sqlwhere+=" >'"+tmpvalue1 +"' ";
				if(tmpopt1.equals("2"))	sqlwhere+=" >='"+tmpvalue1 +"' ";
				if(tmpopt1.equals("3"))	sqlwhere+=" <'"+tmpvalue1 +"' ";
				if(tmpopt1.equals("4"))	sqlwhere+=" <='"+tmpvalue1 +"' ";
				if(tmpopt1.equals("5"))	sqlwhere+=" ='"+tmpvalue1+"' ";
				if(tmpopt1.equals("6"))	sqlwhere+=" <>'"+tmpvalue1 +"' ";
			}
		}
		else if(tmphtmltype.equals("3") && (tmptype.equals("166") || tmptype.equals("168") || tmptype.equals("170") || tmptype.equals("194") || tmptype.equals("17") || tmptype.equals("18") || tmptype.equals("37") || tmptype.equals("65")|| tmptype.equals("57") || tmptype.equals("152") || tmptype.equals("162")|| tmptype.equals("135")|| tmptype.equals("142") || tmptype.equals("257") || tmptype.equals("278"))){       // 对多人力资源，多客户，多部门,多角色，多文档的处理
		    if(!tmpvalue.equals("")){
				if(tmpvalue.substring(0,1).equals(",")) tmpvalue = tmpvalue.substring(1);
				
				if(rs1.getDBType().equals("oracle") && tmphtmltype.equals("3") && tmptype.equals("17")){
					String searchstring = WfAdvanceSearchUtil.getHRMIds(temOwner+"."+tmpcolname,tmpvalue);
					sqlwhere += searchstring;
				}else{
			        if (rs1.getDBType().equals("oracle")){
						sqlwhere += "and (','||to_char("+temOwner+"."+tmpcolname+")||',' ";
			        }else{
				    	sqlwhere += "and (','+CONVERT(varchar(4000),"+temOwner+"."+tmpcolname+")+',' ";
			        }
				
					if(tmpopt.equals("1"))	sqlwhere+=" like '%,"+tmpvalue +",%' ";
					if(tmpopt.equals("2"))	sqlwhere+=" not like '%,"+tmpvalue +",%' ";
					sqlwhere +=") ";
				}
		    }
		}
		//将多请求与上面的多人力资源等合并到一起处理



		//else if(tmphtmltype.equals("3") && tmptype.equals("152")){
		//	if(!tmpvalue.equals("")){
		//		if(rs1.getDBType().equals("oracle")) sqlwhere += "and ','||"+temOwner+"."+tmpcolname+"||','";
		//		else sqlwhere += "and ','+convert(varchar(4000),"+temOwner+"."+tmpcolname+")+','";
		//		if(tmpopt.equals("1"))	sqlwhere+=" like '%"+tmpvalue +",%' ";
		//		if(tmpopt.equals("2"))	sqlwhere+=" not like '%"+tmpvalue +",%' ";
		//	}
		//}


	}

}

//if(sqlwhere.length() > 3 ) sqlwhere = sqlwhere.substring(3) ;
if(sqlwhere.length() > 4 ) sqlwhere = sqlwhere.substring(4) ;
String innersqlwhere = "";
/*-----  xwj for td2974 20051026   B E G I N  ---*/

//String requestname_check_con = request.getParameter("requestname_check_con");
//String requestlevel_check_con = request.getParameter("requestlevel_check_con");
//String requeststatus_check_con = request.getParameter("requeststatus_check_con");//added xwj for td2451 20051105
//String requestnamevalue = request.getParameter("requestnamevalue");
//String requestname = request.getParameter("requestname");
//String requestlevelvalue = request.getParameter("requestlevelvalue");
//String requeststatusvalue = request.getParameter("requeststatusvalue");//added xwj for td2451 20051105

String requestname_check_con = "";
String requestlevel_check_con = "";
String requestnamevalue = "";
String requestname = "";
String requestlevelvalue = "";
//------创建人



String createman_check_con = "";
String createmanselected = "";
String con10_value = "";
//创建时间
String createdate_check_con = "";
String createdate = "";
String createdateend = "";
//工作流



String workflowto_check_con = "";
String con12_value = "";
//当前节点
String currentnode_check_con = "";
String con13_value = "";
//未操作者 
String nooperator_check_con = "";
String nooperator_opt = "";
String con15_value = "";
//流程状态



String requeststatus_check_con = "";
String requeststatusvalue = "";
//归档日期
String filingdate_check_con = "";
String filingdate = "";
String filingdateend = "";


if(searchByMould!=null&&searchByMould.equals("1")){
	int tmpIdIndexId=ids.indexOf("-1");
	if(tmpIdIndexId!=-1){
		requestname_check_con=(String)isCheckConds.get(tmpIdIndexId);
		requestname=(String)opts.get(tmpIdIndexId);
		requestnamevalue=(String)values.get(tmpIdIndexId);
	}

	tmpIdIndexId=ids.indexOf("-2");
	if(tmpIdIndexId!=-1){
		requestlevel_check_con=(String)isCheckConds.get(tmpIdIndexId);
		requestlevelvalue=(String)values.get(tmpIdIndexId);
	}

	//-------------------------
	tmpIdIndexId=ids.indexOf("-10");
	if(tmpIdIndexId!=-1){
		createman_check_con=(String)isCheckConds.get(tmpIdIndexId);
		createmanselected=(String)opts.get(tmpIdIndexId);
		con10_value=(String)values.get(tmpIdIndexId);
	}
	tmpIdIndexId=ids.indexOf("-11");
	if(tmpIdIndexId!=-1){
		createdate_check_con=(String)isCheckConds.get(tmpIdIndexId);
		createdate=(String)values.get(tmpIdIndexId);
	}
	tmpIdIndexId=ids.indexOf("-12");
	if(tmpIdIndexId!=-1){
		workflowto_check_con=(String)isCheckConds.get(tmpIdIndexId);
		con12_value=(String)values.get(tmpIdIndexId);
	}
	tmpIdIndexId=ids.indexOf("-13");
	if(tmpIdIndexId!=-1){
		currentnode_check_con=(String)isCheckConds.get(tmpIdIndexId);
		con13_value=(String)values.get(tmpIdIndexId);
	}
	tmpIdIndexId=ids.indexOf("-14");
	if(tmpIdIndexId!=-1){
		nooperator_check_con=(String)isCheckConds.get(tmpIdIndexId);
		nooperator_opt=(String)opts.get(tmpIdIndexId);
		con15_value=(String)values.get(tmpIdIndexId);
	}
	tmpIdIndexId=ids.indexOf("-15");
	if(tmpIdIndexId!=-1){
		requeststatus_check_con=(String)isCheckConds.get(tmpIdIndexId);
		requeststatusvalue=(String)values.get(tmpIdIndexId);
	}
	tmpIdIndexId=ids.indexOf("-16");
	if(tmpIdIndexId!=-1){
		filingdate_check_con=(String)isCheckConds.get(tmpIdIndexId);
		filingdate=(String)values.get(tmpIdIndexId);
	}

}else{
    requestname_check_con = request.getParameter("requestname_check_con");
    requestlevel_check_con = request.getParameter("requestlevel_check_con");
    requestnamevalue = request.getParameter("requestnamevalue");
    requestname = request.getParameter("requestname");
    requestlevelvalue = request.getParameter("requestlevelvalue");
    //---------------------------
    createman_check_con = request.getParameter("createman_check_con");
    createmanselected = request.getParameter("createmanselected");
    con10_value = request.getParameter("con-10_value");
    
    createdate_check_con = request.getParameter("createdate_check_con");
    createdate = request.getParameter("createdate");
    createdateend = request.getParameter("createdateend");
    
    workflowto_check_con = request.getParameter("workflowto_check_con");
    con12_value = request.getParameter("con-12_value");
    
    currentnode_check_con = request.getParameter("currentnode_check_con");
    con13_value = request.getParameter("con-13_value");
    
    nooperator_check_con = request.getParameter("nooperator_check_con");
    nooperator_opt = request.getParameter("nooperator_opt");
    con15_value = request.getParameter("con-14_value");
    
    requeststatus_check_con = request.getParameter("requeststatus_check_con");
    requeststatusvalue = request.getParameter("requeststatusvalue");
    
    filingdate_check_con = request.getParameter("filingdate_check_con");
    filingdate = request.getParameter("filingdate");
    filingdateend = request.getParameter("filingdateend");
}



if("1".equals(requestname_check_con)){
  if(requestnamevalue!=null && !"".equals(requestnamevalue)){
	if("1".equals(requestname)){
		if(!"".equals(innersqlwhere)){
		  innersqlwhere += " and (r.requestname = '" + requestnamevalue + "') ";
		} else {
		  innersqlwhere += " (r.requestname = '" + requestnamevalue + "') ";
		}
	} else if("2".equals(requestname)){
		if(!"".equals(innersqlwhere)){
		  innersqlwhere += " and (r.requestname <> '" + requestnamevalue + "') ";
		} else{
		  innersqlwhere += "  (r.requestname <> '" + requestnamevalue + "') ";
		}
	} else if("3".equals(requestname)){
	     if(!"".equals(innersqlwhere)){
	   	  innersqlwhere += " and (r.requestname like '%" + requestnamevalue + "%') ";
	     } else {
	   	  innersqlwhere += "  (r.requestname like '%" + requestnamevalue + "%') ";
	     }  
	} else if("4".equals(requestname)){
		if(!"".equals(innersqlwhere)){
		 	innersqlwhere += " and (r.requestname not like '%" + requestnamevalue + "%') ";
		} else {
			innersqlwhere += " (r.requestname not like '%" + requestnamevalue + "%') ";
		}
	}
  }
}
if("1".equals(requestlevel_check_con)){
    if(!"".equals(innersqlwhere)){
    	innersqlwhere += " and (r.requestlevel = '" + requestlevelvalue + "') ";
    }
    else{
    	innersqlwhere += " (r.requestlevel = '" + requestlevelvalue + "') ";
    }
}
/*-----  xwj for td2974 20051026   E N D  ---*/

/*-----  xwj for td2451 20051114   b e g i n  ---*/

//----------------------------------
//-10
if("1".equals(createman_check_con)){
  if(con10_value!=null && !"".equals(con10_value)){
	if("1".equals(createmanselected)){
		if(!"".equals(innersqlwhere)){
		  innersqlwhere += " and (r.creater = '" + con10_value + "') ";
		} else {
		  innersqlwhere += " (r.creater = '" + con10_value + "') ";
		}
	} else if("2".equals(createmanselected)){
		if(!"".equals(innersqlwhere)){
		  innersqlwhere += " and (r.creater <> '" + con10_value + "') ";
		} else{
		  innersqlwhere += "  (r.creater <> '" + con10_value + "') ";
		}
	}
  }
}
//-11
if("1".equals(createdate_check_con)){
  if(createdate!=null && !"".equals(createdate)){
	if(!"".equals(innersqlwhere)){
	  innersqlwhere += " and (r.createdate >= '" + createdate + "') ";
	} else {
	  innersqlwhere += " (r.createdate >= '" + createdate + "') ";
	}
  }
  if(!"".equals(createdateend) && !"".equals(createdateend)){
	  if(!"".equals(innersqlwhere)){
		  innersqlwhere += " and (r.createdate <= '" + createdateend + "') ";
	  } else {
		  innersqlwhere += " (r.createdate <= '" + createdateend + "') ";
	  }
  }
  
}
//-12
if("1".equals(workflowto_check_con)){
  if(con12_value!=null && !"".equals(con12_value)){
	
	String allversionwfids = WorkflowVersion.getAllVersionStringByWFIDs(con12_value);
	
	if(!"".equals(innersqlwhere)){
	  innersqlwhere += " and (r.workflowid in (" + allversionwfids + ")) ";
	} else {
	  innersqlwhere += " (r.workflowid in (" + allversionwfids + ")) ";
	}
	
  }
}
//-13
if("1".equals(currentnode_check_con)){
  if(con13_value!=null && !"".equals(con13_value)){
	if(!"".equals(innersqlwhere)){
	  innersqlwhere += " and (r.currentnodeid = '" + con13_value + "') ";
	} else {
	  innersqlwhere += " (r.currentnodeid = '" + con13_value + "') ";
	}
  }
}
//-14

if("1".equals(nooperator_check_con)){
  if(con15_value!=null && !"".equals(con15_value)){
	if("3".equals(nooperator_opt)){
		if(!"".equals(innersqlwhere)){ 
		  innersqlwhere += " and (c.userid = '" + con15_value + "' AND (c.isremark in( '0','1','5','8','9','7' ) or (isremark='4' and viewtype=0)) ) ";
		} else {
		  innersqlwhere += " (c.userid = '" + con15_value + "' AND (c.isremark in( '0','1','5','8','9','7' ) or (isremark='4' and viewtype=0)) ) ";
		}
	} else if("4".equals(nooperator_opt)){
		if(!"".equals(innersqlwhere)){
		  innersqlwhere += " and ( r.requestid not in ( SELECT requestid FROM workflow_currentoperator "+
				  " where (isremark in ('0','1','5','7','8','9') or (isremark='4' and viewtype=0)) "+
				  " AND userid = '" + con15_value + "') ) ";
		} else{
			innersqlwhere += " ( r.requestid not in ( SELECT requestid FROM workflow_currentoperator "+
					  " where (isremark in ('0','1','5','7','8','9') or (isremark='4' and viewtype=0)) "+
					  " AND userid = '" + con15_value + "') )  ";
		}
	}
  }
}
//----------------------- -15
if("1".equals(requeststatus_check_con)){
    if("1".equals(requeststatusvalue)){
          if(!"".equals(innersqlwhere)){
        	  innersqlwhere += " and (r.currentnodetype = '3') ";
          }
          else{
        	  innersqlwhere += " (r.currentnodetype = '3') ";
          }
    }
    else{
           if(!"".equals(innersqlwhere)){
        	   innersqlwhere += " and (r.currentnodetype <> '3') ";
          }
         else{
        	 innersqlwhere += " (r.currentnodetype <> '3') ";
         }
    }
}
//----------------------- -16
if("1".equals(filingdate_check_con)){
  if(filingdate!=null && !"".equals(filingdate)){
	if(!"".equals(innersqlwhere)){
	  innersqlwhere += " and (r.lastoperatedate >= '" + filingdate + "')  ";
	} else {
	  innersqlwhere += " (r.lastoperatedate >= '" + filingdate + "')  ";
	}
  }
  if(filingdateend!=null && !"".equals(filingdateend) ){
	  if(!"".equals(innersqlwhere)){
		  innersqlwhere += " and (r.lastoperatedate <= '" + filingdateend + "')  ";
	  }else {
		  innersqlwhere += " (r.lastoperatedate <= '" + filingdateend + "') ";
	  }
  }
  if(!"".equals(innersqlwhere)){
  	innersqlwhere += " and r.currentnodetype = '3' ";
  }else{
  	innersqlwhere += " r.currentnodetype = '3' ";
  }
}
//----------------------------------
	    String archiveTime = "";
	    //System.out.println("archiveTime = " + archiveTime);
	    String archiveTimeFrom = "";
	    String archiveTimeTo = "";
	    if(searchByMould!=null&&searchByMould.equals("1")){
	    	int indexId=ids.indexOf("-4");
				if(indexId!=-1){
					archiveTime = (String)isCheckConds.get(indexId);
					archiveTimeFrom = (String)values.get(indexId);
					archiveTimeTo = (String)value1s.get(indexId);
				}
	  	}else{
	  		archiveTime = ""+Util.null2String(request.getParameter("archiveTime"));
	    	archiveTimeFrom = ""+Util.null2String(request.getParameter("fromdate"));
	    	archiveTimeTo = ""+Util.null2String(request.getParameter("todate"));
	  	}
	    if(archiveTime.equals("1")){
          if(!"".equals(innersqlwhere)){
        	  innersqlwhere += " and (r.currentnodetype = '3') ";
          }
          else{
        	  innersqlwhere += " (r.currentnodetype = '3') ";
          }
	    }
	    //System.out.println("archiveTimeFrom = " + archiveTimeFrom);
	    //System.out.println("archiveTimeTo = " + archiveTimeTo);
	    if(!archiveTimeFrom.equals("")){
	    	innersqlwhere += " and (r.lastoperatedate >= '" + archiveTimeFrom +"') ";
	    }
	    if(!archiveTimeTo.equals("")){
	    	innersqlwhere += " and (r.lastoperatedate <= '" + archiveTimeTo +"') ";
	    }
/*-----  xwj for td2451 20051114   E N D  ---*/

//System.out.println("sqlwhere = " + sqlwhere);
String tablename = "workflow_form" ;
String detailtablename = "" ;
String detailkeyfield = "" ;
int maincount = 0 ;
int detailcount = 0 ;
int ordercount = 0 ;
int statcount = 0 ;
String fieldname = "" ;
String orderbystr = "" ;
ReportCompositorOrderBean reportCompositorOrderBean = new ReportCompositorOrderBean(); //added by xwj for td2099 on 2005-06-08
ReportCompositorListBean rcListBean = new ReportCompositorListBean();//added by xwj for td2451 20051114
ReportCompositorListBean rcColListBean = new ReportCompositorListBean();//added by xwj for td2451 20051114

/*-----  xwj for td2974 20051026   B E G I N  ---*/
 //deleted xwj for td2451 20051114
if(isbill.equals("0")) {


   //只有显示请求说明时才执行下面的操作



  if(isShowList.indexOf("-1")!=-1){     
   
    //deleted xwj for td2451 20051114
    rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -1");
	
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("requestname");//xwj for td2451 20051114
	    rcListBean.setFieldId("-1");//xwj for td2451 20051114
        rcListBean.setHtmlType("-1");
	    rcListBean.setTypes("-1");
	    rcListBean.setIsDetail("0");

	    rcListBean.setColName(SystemEnv.getHtmlLabelName(1334,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("requestname");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
            reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
            reportCompositorOrderBean.setFieldName("requestname");
            reportCompositorOrderBean.setSqlFlag("c");
            compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
  }
   //只有显示紧急程度时才执行下面的操作
  if(isShowList.indexOf("-2")!=-1){   	
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -2");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("requestlevel");//xwj for td2451 20051114
	    rcListBean.setFieldId("-2");//xwj for td2451 20051114
        rcListBean.setHtmlType("-2");
	    rcListBean.setTypes("-2");
	    rcListBean.setIsDetail("0");
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(15534,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("requestlevel");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
            reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
            reportCompositorOrderBean.setFieldName("requestlevel");
            reportCompositorOrderBean.setSqlFlag("c");
            compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
  }
   
   //创建人



  if(isShowList.indexOf("-10")!=-1){   
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -10");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("creater");//xwj for td2451 20051114
	    rcListBean.setFieldId("-10");//xwj for td2451 20051114
        rcListBean.setHtmlType("-10");
	    rcListBean.setTypes("-10");
	    rcListBean.setIsDetail("0");
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(882,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("creater");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
            reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
            reportCompositorOrderBean.setFieldName("creater");
            reportCompositorOrderBean.setSqlFlag("c");
            compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
  }

  //创建日期
 if(isShowList.indexOf("-11")!=-1){   
 	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -11");
 	if(rs1.next()){
 	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
 	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
 	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
 	    rcListBean.setFieldName("createdate");//xwj for td2451 20051114
 	    rcListBean.setFieldId("-11");//xwj for td2451 20051114
       rcListBean.setHtmlType("-11");
 	    rcListBean.setTypes("-11");
 	    rcListBean.setIsDetail("0");
 	    rcListBean.setColName(SystemEnv.getHtmlLabelName(722,user.getLanguage()));//xwj for td2451 20051114
 	    compositorColList.add(rcListBean);//xwj for td2451 20051114
 	    fields.add("createdate");
 	    if("1".equals(rs1.getString("dborder"))){
 	        reportCompositorOrderBean = new ReportCompositorOrderBean();
 	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
           reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
           reportCompositorOrderBean.setFieldName("createdate");
           reportCompositorOrderBean.setSqlFlag("c");
           compositorOrderList.add(reportCompositorOrderBean);
 	    }
 	}
 }
 //工作流



 if(isShowList.indexOf("-12")!=-1){   
 	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -12");
 	if(rs1.next()){
 	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
 	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
 	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
 	    rcListBean.setFieldName("workflowid");//xwj for td2451 20051114
 	    rcListBean.setFieldId("-12");//xwj for td2451 20051114
      rcListBean.setHtmlType("-12");
 	    rcListBean.setTypes("-12");
 	    rcListBean.setIsDetail("0");
 	    rcListBean.setColName(SystemEnv.getHtmlLabelName(26361,user.getLanguage()));//xwj for td2451 20051114
 	    compositorColList.add(rcListBean);//xwj for td2451 20051114
 	    fields.add("workflowid");
 	    if("1".equals(rs1.getString("dborder"))){
 	        reportCompositorOrderBean = new ReportCompositorOrderBean();
 	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("workflowid");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
 	    }
 	}
 }
 //当前节点
 if(isShowList.indexOf("-13")!=-1){   
 	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -13");
 	if(rs1.next()){
 	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
 	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
 	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
 	    rcListBean.setFieldName("currentnodeid");//xwj for td2451 20051114
 	    rcListBean.setFieldId("-13");//xwj for td2451 20051114
      rcListBean.setHtmlType("-13");
 	    rcListBean.setTypes("-13");
 	    rcListBean.setIsDetail("0");
 	    rcListBean.setColName(SystemEnv.getHtmlLabelName(18564,user.getLanguage()));//xwj for td2451 20051114
 	    compositorColList.add(rcListBean);//xwj for td2451 20051114
 	    fields.add("currentnodeid");
 	    if("1".equals(rs1.getString("dborder"))){
 	        reportCompositorOrderBean = new ReportCompositorOrderBean();
 	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("currentnodeid");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
 	    }
 	}
 }
 
 //未操作者



 if(isShowList.indexOf("-14")!=-1){   
 	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -14");
 	if(rs1.next()){
 	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
 	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
 	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
 	    rcListBean.setFieldName("requestid");//xwj for td2451 20051114
 	    rcListBean.setFieldId("-14");//xwj for td2451 20051114
      rcListBean.setHtmlType("-14");
 	    rcListBean.setTypes("-14");
 	    rcListBean.setIsDetail("0");
 	    rcListBean.setColName(SystemEnv.getHtmlLabelName(16354,user.getLanguage()));//xwj for td2451 20051114
 	    compositorColList.add(rcListBean);//xwj for td2451 20051114
 	    fields.add("requestid");
 	    if("1".equals(rs1.getString("dborder"))){
 	        reportCompositorOrderBean = new ReportCompositorOrderBean();
 	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("requestid");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
 	    }
 	}
 }
//-15流程状态



 
 if(isShowList.indexOf("-15")!=-1){   
 	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -15");
 	if(rs1.next()){
 	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
 	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
 	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
 	    rcListBean.setFieldName("currentnodetype");//xwj for td2451 20051114
 	    rcListBean.setFieldId("-15");//xwj for td2451 20051114
      rcListBean.setHtmlType("-15");
 	    rcListBean.setTypes("-15");
 	    rcListBean.setIsDetail("0");
 	    rcListBean.setColName(SystemEnv.getHtmlLabelName(31485,user.getLanguage()));//xwj for td2451 20051114
 	    compositorColList.add(rcListBean);//xwj for td2451 20051114
 	    fields.add("currentnodetype");
 	    if("1".equals(rs1.getString("dborder"))){
 	      reportCompositorOrderBean = new ReportCompositorOrderBean();
 	      reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("currentnodetype");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
 	    }
 	}
 }
//-16归档日期
 
 if(isShowList.indexOf("-16")!=-1){   
 	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -16");
 	if(rs1.next()){
 	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
 	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
 	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
 	    rcListBean.setFieldName("lastoperatedate");//xwj for td2451 20051114
 	    rcListBean.setFieldId("-16");//xwj for td2451 20051114
      rcListBean.setHtmlType("-16");
 	    rcListBean.setTypes("-16");
 	    rcListBean.setIsDetail("0");
 	    rcListBean.setColName(SystemEnv.getHtmlLabelName(3000,user.getLanguage()));//xwj for td2451 20051114
 	    compositorColList.add(rcListBean);//xwj for td2451 20051114
 	    fields.add("lastoperatedate");
 	    if("1".equals(rs1.getString("dborder"))){
 	        reportCompositorOrderBean = new ReportCompositorOrderBean();
 	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("lastoperatedate");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
 	    }
 	}
 }

	/*-----  xwj for td2974 20051026   E N D ----*/
    
	//modify by xhheng @ 20041206 for TDID 1426 start
	
	// this sql id modified by xwj for td2099 on 2005-06-08 
   sql = " (select a.fieldname as col1, (select distinct c.fieldlable  from  workflow_fieldlable c  where  c.fieldid = b.fieldid and e.formid = c.formid and c.langurageid = "+user.getLanguage()+") as col2, a.fieldhtmltype as col3, a.type as col4, b.isstat as col5, b.dborder as col6, a.id as col7, b.dsporder as col8, f.isdetail as col9,  b.dbordertype as col10, b.compositororder as col11 from workflow_formdict a, Workflow_ReportDspField b ,  Workflow_Report e , workflow_formfield f " +
          " where a.id=f.fieldid   and e.formid=f.formid and b.fieldid = a.id  and e.id = b.reportid and b.reportid = " + reportid + 
          " and (f.isdetail!='1' or f.isdetail is null) union "+
          " select a.fieldname as col1,(select distinct c.fieldlable  from  workflow_fieldlable c  where  c.fieldid = b.fieldid and e.formid = c.formid and c.langurageid = "+user.getLanguage()+") as col2, a.fieldhtmltype as col3, a.type as col4, b.isstat as col5, b.dborder as col6, a.id as col7, b.dsporder as col8, f.isdetail as col9,  b.dbordertype as col10, b.compositororder as col11 from workflow_formdictdetail a, Workflow_ReportDspField b , Workflow_Report e , workflow_formfield f " +
          " where a.id=f.fieldid  and f.formid=e.formid  and b.fieldid = a.id  and e.id = b.reportid and b.reportid = " + reportid +"   and (f.isdetail='1' )) order by col8" ;
	
     //out.print(sql);
	//by ben 2006-03-27 for td3595
	//out.print(sql) ;
	//modify by xhheng @ 20041206 for TDID 1426 end
    RecordSet.execute(sql) ;
    //out.println("sql = " + sql);
    String owner = "";
    
    while(RecordSet.next()) {  

		if(isShowList.indexOf(Util.null2String(RecordSet.getString(7)))==-1){
			continue;
		}

        //modify by xhheng @ 20041210 for TDID 1426 end
        if(RecordSet.getString("col9").equals("1")){
            owner = "d";
            detailcount++;
           
        }else{
            owner = "a";
        }
        /*-----  xwj for td2974 20051026   B E G I N  ---*/
        
        rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
        rcListBean.setCompositorList(RecordSet.getDouble(8));//xwj for td2451 20051114
	      rcListBean.setSqlFlag(owner);//xwj for td2451 20051114
	      rcListBean.setFieldName(Util.null2String(RecordSet.getString(1)));//xwj for td2451 20051114
	      rcListBean.setFieldId(Util.null2String(RecordSet.getString(7)));//xwj for td2451 20051114
	      rcListBean.setColName(Util.toScreen(RecordSet.getString(2),user.getLanguage()));//xwj for td2451 20051114
	      rcListBean.setHtmlType(Util.null2String(RecordSet.getString(3)));
	      rcListBean.setTypes(Util.null2String(RecordSet.getString(4)));
	      rcListBean.setIsDetail(Util.null2String(RecordSet.getString(9)));

          rcListBean.setDbOrder(Util.null2String(RecordSet.getString(6)));
	      rcListBean.setIsstat(Util.null2String(RecordSet.getString(5)));
          compositorColList.add(rcListBean);//xwj for td2451 20051114
        fields.add(Util.null2String(RecordSet.getString(1))) ;
        /*-----  xwj for td2974 20051026   E N D  ---*/
        
        // deleted by xwj for td2974 20051026
        //add by wang jinyong end

        if(Util.null2String(RecordSet.getString(6)).equals("1")) {
            /* ---deleted and added by xwj for td2099 on 2005-06-08      B E G I N ---*/
            //orderbystr = " order by " + Util.null2String(RecordSet.getString(1)) ;  
            reportCompositorOrderBean = new ReportCompositorOrderBean();
            reportCompositorOrderBean.setCompositorOrder(RecordSet.getInt(11));
            reportCompositorOrderBean.setOrderType(Util.null2String(RecordSet.getString(10)));
            reportCompositorOrderBean.setFieldName(Util.null2String(RecordSet.getString(1)));
            reportCompositorOrderBean.setSqlFlag(owner);
            compositorOrderList.add(reportCompositorOrderBean);
             /* ---deleted and added by xwj for td2099 on 2005-06-08      E N D ---*/
           // deleted by xwj for td2974 20051026
        }
        //deleted by xwj for td2974 20051026
        //delete by xhheng @20050127 for TD 1621
    }
    
     /*-----  xwj for td2974 20051026   B E G I N  ---*/
      
      /*-----  xwj for td2451 on 2005-11-14  B E G I N  ---*/
    compositorColList2 = ReportComInfo.getCompositorList(compositorColList); //xwj for td2451 on 2005-11-14
    for(int a = 0; a < compositorColList2.size(); a++){
    rcColListBean = (ReportCompositorListBean)compositorColList2.get(a);
    RecordSet.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = " +rcColListBean.getFieldId());
   // if(RecordSet.next())
    String  tempfieldid = rcColListBean.getFieldId();
    htmltypes.add(rcColListBean.getHtmlType());
    types.add(rcColListBean.getTypes());
    isdetails.add(rcColListBean.getIsDetail());
     if (Util.null2String(rcColListBean.getDbOrder()).equals("1"))
        {ordercount ++ ;
       isdborders.add("1") ;
        }
        else
       isdborders.add("") ;
    if (Util.null2String(rcColListBean.getIsstat()).equals("1"))
        { statcount ++ ;
          isstats.add("1") ;
        }
        else
        isstats.add("") ;
  
    statvalues.add("") ;
    tempstatvalues.add("") ;
     fieldids.add(tempfieldid);
    }//xwj for td2451 on 2005-11-14 
	  fieldname =  ReportComInfo.getCompositorListByStrs(compositorColList)+",c.requestid"; //xwj for td2451 on 2005-11-14
    orderbystr = ReportComInfo.getCompositorOrderByStrs(compositorOrderList); //added by xwj for td2099 on2005-06-08
    /*-----  xwj for td2974 20051026   E N D  ---*/

}
else {
  //deleted xwj for td2451 20051114
    /*-----  xwj for td2974 20051026   B E G I N  ---*/
//deleted xwj for td2451 20051114
   //只有显示请求说明时才执行下面的操作



  if(isShowList.indexOf("-1")!=-1){   
    rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -1");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("requestname");//xwj for td2451 20051114
	    rcListBean.setFieldId("-1");//xwj for td2451 20051114
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(1334,user.getLanguage()));//xwj for td2451 20051114
    	compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("requestname");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
            reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
            reportCompositorOrderBean.setFieldName("requestname");
            reportCompositorOrderBean.setSqlFlag("c");
            compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
  }

   //只有显示紧急程度时才执行下面的操作
  if(isShowList.indexOf("-2")!=-1){    
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -2");
	if(rs1.next()){
        rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("requestlevel");//xwj for td2451 20051114
	    rcListBean.setFieldId("-2");//xwj for td2451 20051114
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(15534,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("requestlevel");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
            reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
            reportCompositorOrderBean.setFieldName("requestlevel");
            reportCompositorOrderBean.setSqlFlag("c");
            compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
  }
   
  /**2014**/
  //创建人



 if(isShowList.indexOf("-10")!=-1){ 
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -10");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("creater");//xwj for td2451 20051114
	    rcListBean.setFieldId("-10");//xwj for td2451 20051114
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(882,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("creater");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
           reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
           reportCompositorOrderBean.setFieldName("creater");
           reportCompositorOrderBean.setSqlFlag("c");
           compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
 }

 //创建日期
if(isShowList.indexOf("-11")!=-1){ 
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -11");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("createdate");//xwj for td2451 20051114
	    rcListBean.setFieldId("-11");//xwj for td2451 20051114
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(722,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("createdate");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("createdate");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
}
 
//工作流



if(isShowList.indexOf("-12")!=-1){ 
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -12");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("workflowid");//xwj for td2451 20051114
	    rcListBean.setFieldId("-12");//xwj for td2451 20051114
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(26361,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("workflowid");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
         reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
         reportCompositorOrderBean.setFieldName("workflowid");
         reportCompositorOrderBean.setSqlFlag("c");
         compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
}

//当前节点
if(isShowList.indexOf("-13")!=-1){ 
	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -13");
	if(rs1.next()){
	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
	    rcListBean.setFieldName("currentnodeid");//xwj for td2451 20051114
	    rcListBean.setFieldId("-13");//xwj for td2451 20051114
	    rcListBean.setColName(SystemEnv.getHtmlLabelName(18564,user.getLanguage()));//xwj for td2451 20051114
	    compositorColList.add(rcListBean);//xwj for td2451 20051114
	    fields.add("currentnodeid");
	    if("1".equals(rs1.getString("dborder"))){
	        reportCompositorOrderBean = new ReportCompositorOrderBean();
	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
         reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
         reportCompositorOrderBean.setFieldName("currentnodeid");
         reportCompositorOrderBean.setSqlFlag("c");
         compositorOrderList.add(reportCompositorOrderBean);
	    }
	}
}
if(isShowList.indexOf("-14")!=-1){   
 	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -14");
 	if(rs1.next()){
 	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
 	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
 	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
 	    rcListBean.setFieldName("requestid");//xwj for td2451 20051114
 	    rcListBean.setFieldId("-14");//xwj for td2451 20051114
      rcListBean.setHtmlType("-14");
 	    rcListBean.setTypes("-14");
 	    rcListBean.setIsDetail("0");
 	    rcListBean.setColName(SystemEnv.getHtmlLabelName(16354,user.getLanguage()));//xwj for td2451 20051114
 	    compositorColList.add(rcListBean);//xwj for td2451 20051114
 	    fields.add("requestid");
 	    if("1".equals(rs1.getString("dborder"))){
 	        reportCompositorOrderBean = new ReportCompositorOrderBean();
 	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("requestid");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
 	    }
 	}
 }
//-15
 if(isShowList.indexOf("-15")!=-1){   
 	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -15");
 	if(rs1.next()){
 	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
 	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
 	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
 	    rcListBean.setFieldName("currentnodetype");//xwj for td2451 20051114
 	    rcListBean.setFieldId("-15");//xwj for td2451 20051114
      rcListBean.setHtmlType("-15");
 	    rcListBean.setTypes("-15");
 	    rcListBean.setIsDetail("0");
 	    rcListBean.setColName(SystemEnv.getHtmlLabelName(31485,user.getLanguage()));//xwj for td2451 20051114
 	    compositorColList.add(rcListBean);//xwj for td2451 20051114
 	    fields.add("currentnodetype");
 	    if("1".equals(rs1.getString("dborder"))){
 	        reportCompositorOrderBean = new ReportCompositorOrderBean();
 	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("currentnodetype");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
 	    }
 	}
 }
//-16
 
 if(isShowList.indexOf("-16")!=-1){   
 	rs1.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = -16");
 	if(rs1.next()){
 	    rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
 	    rcListBean.setCompositorList(rs1.getDouble("dsporder"));//xwj for td2451 20051114
 	    rcListBean.setSqlFlag("c");//xwj for td2451 20051114
 	    rcListBean.setFieldName("lastoperatedate");//xwj for td2451 20051114
 	    rcListBean.setFieldId("-16");//xwj for td2451 20051114
      rcListBean.setHtmlType("-16");
 	    rcListBean.setTypes("-16");
 	    rcListBean.setIsDetail("0");
 	    rcListBean.setColName(SystemEnv.getHtmlLabelName(3000,user.getLanguage()));//xwj for td2451 20051114
 	    compositorColList.add(rcListBean);//xwj for td2451 20051114
 	    fields.add("lastoperatedate");
 	    if("1".equals(rs1.getString("dborder"))){
 	        reportCompositorOrderBean = new ReportCompositorOrderBean();
 	        reportCompositorOrderBean.setCompositorOrder(rs1.getInt("compositororder"));
          reportCompositorOrderBean.setOrderType(Util.null2String(rs1.getString("dbordertype")));
          reportCompositorOrderBean.setFieldName("lastoperatedate");
          reportCompositorOrderBean.setSqlFlag("c");
          compositorOrderList.add(reportCompositorOrderBean);
 	    }
 	}
 }

/**2014**/
   
	/*-----  xwj for td2974 20051026   E N D ----*/
    
    /*-----  xwj for td2974 20051026   B E G I N  ---*/
    sql = " select distinct a.fieldname , c.labelname, a.fieldhtmltype, a.type, b.isstat , a.viewtype , b.dborder , a.id , b.dbordertype , b.compositororder, b.dsporder, a.detailtable as detailtable from  workflow_billfield a, Workflow_ReportDspField b , HtmlLabelInfo c " +
          " where a.id = b.fieldid and a.fieldlabel = c.indexid and b.reportid = " + reportid +" and  c.languageid = " + user.getLanguage() + " order by b.dsporder " ;
    /*-----  xwj for td2974 20051026   end  ---*/
    //out.println(sql);
    RecordSet.execute(sql) ;
    int iDetailCol = 0;
    String strDBType = Util.null2String(RecordSet.getDBType());
    while(RecordSet.next()) {
		String colname = RecordSet.getString(1);
		
		if(isShowList.indexOf(Util.null2String(RecordSet.getString(8)))==-1){
			continue;
		}

        String viewtype = Util.null2String(RecordSet.getString(6)) ;
        if(viewtype.equals("1")) {
        	if(isNewBill) {
        		viewtype = Util.null2String(RecordSet.getString("detailtable")) ;
        		if (strDBType.equals("oracle")||strDBType.equals("db2")) {
        			//oracle有标识符长度不能大于30的限制
        			String _colname = colname;
					String aliasName = viewtype+"__C"+iDetailCol;
        			colname = _colname+" as "+aliasName;
        			colNameAliasNameHm.put((viewtype+"__"+_colname).toUpperCase(), aliasName);
					iDetailCol++;
        		} else {
        			String _colname = colname;
					String aliasName = viewtype+"__"+_colname;
        			colname = _colname+" as "+aliasName;
        			colNameAliasNameHm.put((viewtype+"__"+_colname).toUpperCase(), aliasName);
        		}
				if(useddetailtable.toUpperCase().indexOf("," + Util.null2String(viewtype).toUpperCase()) < 0 ) {
        			useddetailtable += "," + viewtype;
        		}
        	} else {
        		colname = colname+" as "+colname+"__0";
        		
            	viewtype ="d" ; // "b." --> "b"   xwj for td2131 on 2005-06-20
        	}
            detailcount ++ ;
        } else {
            viewtype ="a" ; // "a." --> "a"   xwj for td2131 on 2005-06-20
            maincount ++ ;
        }

        /*-----  xwj for td2974 20051026   B E G I N  ---*/
        rcListBean = new ReportCompositorListBean();//xwj for td2451 20051114
        rcListBean.setCompositorList(RecordSet.getDouble(11));//xwj for td2451 20051114
        rcListBean.setSqlFlag(viewtype);//xwj for td2451 20051114
        rcListBean.setFieldName(colname);//xwj for td2451 20051114
        rcListBean.setFieldId(Util.null2String(RecordSet.getString(8)));//xwj for td2451 20051114
        rcListBean.setColName(Util.toScreen(RecordSet.getString(2),user.getLanguage()));//xwj for td2451 20051114
	      compositorColList.add(rcListBean);//xwj for td2451 20051114
        fields.add(Util.null2String(RecordSet.getString(1))) ;
         /*-----  xwj for td2974 20051026   E N D  ---*/
        
         // deleted by xwj for td2974 20051026

        if(Util.null2String(RecordSet.getString(7)).equals("1")) {
            /* ---deleted and added by xwj for td2099 on 2005-06-08      B E G I N ---*/
            //orderbystr = " order by " + viewtype + Util.null2String(RecordSet.getString(1)) ;
            reportCompositorOrderBean = new ReportCompositorOrderBean();
            reportCompositorOrderBean.setCompositorOrder(RecordSet.getInt(10));
            reportCompositorOrderBean.setOrderType(Util.null2String(RecordSet.getString(9)));
            reportCompositorOrderBean.setFieldName(Util.null2String(RecordSet.getString(1)));
            reportCompositorOrderBean.setSqlFlag(viewtype);
            compositorOrderList.add(reportCompositorOrderBean);
             /* ---deleted and added by xwj for td2099 on 2005-06-08      E N D ---*/
             // deleted by xwj for td2974 20051026
        }
        // deleted by xwj for td2974 20051026
        //delete by xhheng @20050127 for TD 1621

    }
    /*-----  xwj for td2974 20051026  B E G I N  ---*/
    
     /*-----  xwj for td2451 on 2005-11-14  B E G I N  ---*/
    compositorColList2 = ReportComInfo.getCompositorList(compositorColList); //xwj for td2451 on 2005-11-14
    for(int a = 0; a < compositorColList2.size(); a++){
    rcColListBean = (ReportCompositorListBean)compositorColList2.get(a);
    RecordSet.executeSql("select * from Workflow_ReportDspField where reportid = " + reportid + " and fieldid = " +rcColListBean.getFieldId());
    if(RecordSet.next()){
      /*-----  xwj for td2451 on 2005-11-14  E N D  ---*/
    
    String  tempfieldid = RecordSet.getString("fieldid");
    if("-1".equals(tempfieldid) || "-2".equals(tempfieldid) || "-10".equals(tempfieldid) || "-11".equals(tempfieldid) || "-12".equals(tempfieldid) || "-13".equals(tempfieldid) || "-14".equals(tempfieldid) || "-15".equals(tempfieldid) || "-16".equals(tempfieldid) || "-17".equals(tempfieldid)){
    htmltypes.add(tempfieldid);
    types.add(tempfieldid);
    }
    else{
    rs3.executeSql("select formid from workflow_report b where   b.id = "+ reportid);
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
    }
    else{ 
      isstats.add("") ;
    }
    statvalues.add("") ;
    tempstatvalues.add("") ;
     if(Util.null2String(RecordSet.getString("dborder")).equals("1")) {
            ordercount ++ ;
            isdborders.add("1") ;
    }
    else{ 
      isdborders.add("") ;
    }
   }
    } //xwj for td2451 on 2005-11-14 
    fieldname =  ReportComInfo.getCompositorListByStrs(compositorColList)+",c.requestid"; //xwj for td2451 on 2005-11-14
    orderbystr = ReportComInfo.getCompositorOrderByStrs(compositorOrderList); //added by xwj for td2099 on2005-06-08
    /*-----  xwj for td2974 20051026   E N D  ---*/
    
    sql = " select tablename , detailtablename , detailkeyfield from workflow_bill where id = " + formid ;
    RecordSet.execute(sql) ;
    RecordSet.next() ;
    tablename = Util.null2String(RecordSet.getString(1)) ;
    detailtablename = Util.null2String(RecordSet.getString(2)) ;
    detailkeyfield = Util.null2String(RecordSet.getString(3)) ;
    if(isNewBill){//新表单



    	int indexflag = 1;
    	detailtablename = "";
    	RecordSet.executeSql("select tablename from workflow_billdetailtable where billid="+formid);
    	while(RecordSet.next()){
    		detailtablename += RecordSet.getString("tablename")+",";
    		if(useddetailtable.toUpperCase().indexOf("," + Util.null2String(RecordSet.getString("tablename")).toUpperCase()) > -1 ) {
				//fieldname += ","+RecordSet.getString("tablename")+".id as dt"+indexflag;
				fieldname += ","+RecordSet.getString("tablename")+".id as " + RecordSet.getString("tablename") + "_id_" ;
    			indexflag++;
    		}
    	}
    }
}

//System.out.println("^^^^^^^^^^^^^^^sqlwhere : "+sqlwhere);
String usersql = "";
if(!userrightsql.equals("")){
	usersql = "c.userid,";
}
String wfversions = WorkflowVersion.getAllVersionStringByWFIDs(reportwfid);
if(isbill.equals("0")) {
    //modify by xhheng @20050322 for Td 1625
    //modify by xhheng @20050127 for TD 1621
    if((sharelevel_1 <2 && sharelevel_1>-1 && sharelevel_0 != 2) || (sharelevel_0 != 2 && (sharelevel_2 ==3 || sharelevel_3==9 || sharelevel_4 == 4 || sharelevel_5 == 5))) {
    	if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
		{
		 	sql=" select "
				+ fieldname
				+ " from (select distinct c.requestname,"+
				" c.formid,c.requestlevel, c.requestid , c.creater,c.createdate,c.currentnodeid,c.workflowid,c.currentnodetype,c.lastoperatedate from "+
        		" Workflow_Report b INNER JOIN (select distinct r.deleted,b.formid,b.id,r.requestid ,r.createdate,r.currentnodeid,r.workflowid,r.creater,r.requestname,r.requestlevel,r.currentnodetype,";
		 	if(!usersql.equals("")){
				sql +=usersql;
			}
		 	sql +="(CASE WHEN r.currentnodetype = 3 THEN r.lastoperatedate WHEN r.currentnodetype != 3 THEN '' ELSE '' END) AS lastoperatedate from workflow_requestbase r,workflow_base b,workflow_currentoperator c where (r.deleted <> 1 or r.deleted is null or r.deleted='') and (b.isvalid='1' or b.isvalid='3' AND NOT exists(SELECT id FROM workflow_base w_b WHERE b.isvalid=3 AND b.activeVersionID = w_b.id AND w_b.isvalid<>'1') ) and r.workflowid=b.id and r.requestid = c.requestid "+otherSqlWhere;
			 	if (innersqlwhere.length() > 0){
	    			sql += " and " + innersqlwhere;
	    		}
			 	sql += ")  c INNER JOIN hrmresource e INNER JOIN HrmDepartmentAllView f " + 
        		" ON e.departmentid=f.id ON c.creater=e.id  ON b.formid = c.formid  INNER JOIN HrmSubCompanyAllView h ON e.subcompanyid1 = h.id and ( " ;
        		if(!"".equals(wfversions)){
        			String []wfversionarray = Util.TokenizerString2(wfversions,",");
        			for(int f=0;f<wfversionarray.length;f++){
        				sql += " c.id in ('"+wfversionarray[f]+"') or";
        			}
        			sql = sql.substring(0, sql.length()-2);
        			sql += " ) ";
        		}
        		//" and '" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'||to_char(c.id)||',%' ";
		}
		else
		{
      		sql=" select top 1000000 "+ fieldname+ " from (select distinct c.requestname,c.formid,c.requestlevel,c.requestid,c.creater,c.createdate,c.currentnodeid,c.workflowid,c.currentnodetype,c.lastoperatedate from " +
        		" Workflow_Report b INNER JOIN (select distinct r.deleted,b.formid,r.workflowid,b.id,r.requestid,r.createdate,r.creater,r.currentnodeid,r.requestname,r.requestlevel,r.currentnodetype,";
      		if(!usersql.equals("")){
				sql +=usersql;
			}
      		sql +="(CASE WHEN r.currentnodetype = 3 THEN r.lastoperatedate WHEN r.currentnodetype != 3 THEN '' ELSE '' END) AS lastoperatedate from workflow_requestbase r,workflow_base b,workflow_currentoperator c where (r.deleted <> 1 or r.deleted is null or r.deleted='') and (b.isvalid='1' or b.isvalid='3' AND NOT exists(SELECT id FROM workflow_base w_b WHERE b.isvalid=3 AND b.activeVersionID = w_b.id AND w_b.isvalid<>'1')) and r.workflowid=b.id and r.requestid = c.requestid "+otherSqlWhere;
        		if (innersqlwhere.length() > 0){
        			sql += " and " + innersqlwhere;
        		}
        		sql += ")  c INNER JOIN hrmresource e INNER JOIN HrmDepartmentAllView f " + 
        		" ON e.departmentid=f.id ON c.creater=e.id  ON b.formid = c.formid  INNER JOIN HrmSubCompanyAllView h ON e.subcompanyid1 = h.id and ( " ;
        		if(!"".equals(wfversions)){
        			String []wfversionarray = Util.TokenizerString2(wfversions,",");
        			for(int f=0;f<wfversionarray.length;f++){
        				sql += " c.id in ('"+wfversionarray[f]+"') or";
        			}
        			sql = sql.substring(0, sql.length()-2);
        			sql += " ) ";
        		}
        		//'" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'+convert(varchar,c.id)+',%' ";
		}
		sql += " and (b.id = " + reportid + ") AND (f.id in(" + hasrightdeps + ") " + userrightsql + " OR h.id IN("+hassubcompany+") ) ";

		sql += " and (b.id = " + reportid + ")";
		sql += ") c INNER JOIN workflow_form a ON c.requestid = a.requestid  ";
     if(detailcount != 0 ){  
         sql+=  " LEFT JOIN workflow_formdetail d  ON a.requestid = d.requestid " ;
         String tempGroupIds = ",";
         ArrayList fieldnamelist = Util.TokenizerString(fieldname,",");
         for(int tempindex=0;tempindex<fieldnamelist.size();tempindex++){
             String tempfieldname = (String)fieldnamelist.get(tempindex);
             if(tempfieldname.indexOf("d.")==0){
                 tempfieldname = tempfieldname.substring(2);
                 RecordSet.executeSql("select groupId from workflow_formfield where formid="+formid+" and fieldid=(select id from workflow_formdictdetail where fieldname='"+tempfieldname+"')");
                 if(RecordSet.next()){
                     String tempGroupId = RecordSet.getString("groupId");
                     if(tempGroupIds.indexOf(","+tempGroupId+",")<0)
                         tempGroupIds += tempGroupId+",";
                 }
             }
         }
         if(!tempGroupIds.equals(",")){//在多明细查询时，查询需要显示的明细。



             String tempSql = "(";
             ArrayList tempGroupIdslist = Util.TokenizerString(tempGroupIds,",");
             for(int tempindex=0;tempindex<tempGroupIdslist.size();tempindex++){
                 String tempGroupId = (String)tempGroupIdslist.get(tempindex);
                 if(tempSql.equals("(")) tempSql += "d.groupId="+tempGroupId;
                 else tempSql += " or d.groupId="+tempGroupId;
             }
             tempSql += ")";
             if(!tempSql.equals("()")){
                 sql += " and " + tempSql;
             }
         }
     }
    }else{
		if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
		{
			 sql = " select "+ fieldname+ " from (select distinct c.requestname,c.currentnodeid,c.createdate,c.workflowid,c.formid,c.requestlevel, c.requestid,c.creater,c.currentnodetype,c.lastoperatedate FROM Workflow_Report b " +
              "INNER JOIN (select distinct r.deleted,b.formid,r.workflowid,b.id,r.requestid ,r.creater,r.requestname,r.currentnodeid,r.createdate,r.requestlevel,r.currentnodetype,(CASE WHEN r.currentnodetype = 3 THEN r.lastoperatedate WHEN r.currentnodetype != 3 THEN '' ELSE '' END) AS lastoperatedate from workflow_requestbase r,workflow_base b,workflow_currentoperator c where (r.deleted <> 1 or r.deleted is null or r.deleted='') and (b.isvalid='1' or b.isvalid='3' AND NOT exists(SELECT id FROM workflow_base w_b WHERE b.isvalid=3 AND b.activeVersionID = w_b.id AND w_b.isvalid<>'1')) and r.workflowid=b.id and r.requestid = c.requestid "+otherSqlWhere;
      		if (innersqlwhere.length() > 0){
    			sql += " and " + innersqlwhere;
      		}
      		sql +=  " ) c ON  b.formid = c.formid and ( ";
      		if(!"".equals(wfversions)){
    			String []wfversionarray = Util.TokenizerString2(wfversions,",");
    			for(int f=0;f<wfversionarray.length;f++){
    				sql += " c.id in ('"+wfversionarray[f]+"') or";
    			}
    			sql = sql.substring(0, sql.length()-2);
    			sql += " ) ";
    		}
      		//'" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'||to_char(c.id)||',%' ";
		}
		else
		{
      		sql = " select top 1000000 "+ fieldname+ " from (select distinct c.requestname,c.currentnodeid,c.createdate,c.workflowid,c.formid,c.requestlevel, c.requestid,c.creater,c.currentnodetype,c.lastoperatedate FROM Workflow_Report b " +
              "INNER JOIN (select distinct r.deleted,b.formid,r.workflowid,b.id,r.requestid ,r.creater,r.requestname,r.currentnodeid,r.createdate,r.requestlevel,r.currentnodetype,(CASE WHEN r.currentnodetype = 3 THEN r.lastoperatedate WHEN r.currentnodetype != 3 THEN '' ELSE '' END) AS lastoperatedate from workflow_requestbase r,workflow_base b,workflow_currentoperator c where (r.deleted <> 1 or r.deleted is null or r.deleted='') and (b.isvalid='1' or b.isvalid='3' AND NOT exists(SELECT id FROM workflow_base w_b WHERE b.isvalid=3 AND b.activeVersionID = w_b.id AND w_b.isvalid<>'1')) and r.workflowid=b.id and r.requestid = c.requestid "+otherSqlWhere;
      		if (innersqlwhere.length() > 0){
    			sql += " and " + innersqlwhere;
      		}
      		sql += ") c ON  b.formid = c.formid and ( " ;
      		if(!"".equals(wfversions)){
    			String []wfversionarray = Util.TokenizerString2(wfversions,",");
    			for(int f=0;f<wfversionarray.length;f++){
    				sql += " c.id in ('"+wfversionarray[f]+"') or";
    			}
    			sql = sql.substring(0, sql.length()-2);
    			sql += " ) ";
    		}		
      		//'" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'+convert(varchar,c.id)+',%' ";
		}
		sql += " and (b.id = " + reportid + ")";

		sql += ") c INNER JOIN workflow_form a ON c.requestid = a.requestid  ";
     if(detailcount != 0 ) {  
         sql+=  " LEFT JOIN workflow_formdetail d  ON a.requestid = d.requestid " ;
         String tempGroupIds = ",";
         ArrayList fieldnamelist = Util.TokenizerString(fieldname,",");
         for(int tempindex=0;tempindex<fieldnamelist.size();tempindex++){
             String tempfieldname = (String)fieldnamelist.get(tempindex);
             if(tempfieldname.indexOf("d.")==0){
                 tempfieldname = tempfieldname.substring(2);
                 RecordSet.executeSql("select groupId from workflow_formfield where formid="+formid+" and fieldid=(select id from workflow_formdictdetail where fieldname='"+tempfieldname+"')");
                 if(RecordSet.next()){
                     String tempGroupId = RecordSet.getString("groupId");
                     if(tempGroupIds.indexOf(","+tempGroupId+",")<0)
                         tempGroupIds += tempGroupId+",";
                 }
             }
         }
         if(!tempGroupIds.equals(",")){//在多明细查询时，查询需要显示的明细。



             String tempSql = "(";
             ArrayList tempGroupIdslist = Util.TokenizerString(tempGroupIds,",");
             for(int tempindex=0;tempindex<tempGroupIdslist.size();tempindex++){
                 String tempGroupId = (String)tempGroupIdslist.get(tempindex);
                 if(tempSql.equals("(")) tempSql += "d.groupId="+tempGroupId;
                 else tempSql += " or d.groupId="+tempGroupId;
             }
             tempSql += ")";
             if(!tempSql.equals("()")){
                 sql += " and " + tempSql;
             }
         }
     }
    }
    if (sqlwhere.length() > 0)
		sql += " where " + sqlwhere;
    sql += orderbystr ;
}
else {
    //modify by xhheng @20050127 for TD 1621
    boolean haswhere = false ;
    //modify by mackjoe at 20070625 for TD6865
    if(detailcount != 0 && ("156".equals(formid) || "157".equals(formid) || "158".equals(formid) || "159".equals(formid))){
        fieldname+=",d.organizationtype";
		if("156".equals(formid)||"158".equals(formid)){
        	fieldname+=",d.budgetperiod,d.subject,d.organizationid ";
        }
    }
    
	if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2")) {
		sql = " select " + fieldname + ", c.workflowid c_workflowid_QC194991, c.formid c_formid_QC194991 from (select distinct c.requestname,c.creater,c.currentnodeid,c.createdate,c.workflowid,c.formid,c.requestlevel, c.requestid ,c.lastoperatedate,c.currentnodetype  from " ;
	} else {
		sql = " select top 1000000 " + fieldname + ", c.workflowid c_workflowid_QC194991, c.formid c_formid_QC194991 from (select distinct c.requestname,c.creater,c.currentnodeid,c.createdate,c.workflowid,c.formid,c.requestlevel, c.requestid ,c.lastoperatedate,c.currentnodetype  from " ;
	}
    sql += " Workflow_Report b INNER JOIN (select distinct r.deleted,b.formid,r.currentnodeid,r.createdate,r.workflowid,b.id,r.requestid ,r.creater,r.requestname,r.requestlevel,r.currentnodetype,";
    if(!usersql.equals("")){
		sql +=usersql;
	}
    sql += "(CASE WHEN r.currentnodetype = 3 THEN r.lastoperatedate WHEN r.currentnodetype != 3 THEN '' ELSE '' END) AS lastoperatedate from workflow_requestbase r,workflow_base b,workflow_currentoperator c where (r.deleted <> 1 or r.deleted is null or r.deleted='') and (b.isvalid='1' or b.isvalid='3' AND NOT exists(SELECT id FROM workflow_base w_b WHERE b.isvalid=3 AND b.activeVersionID = w_b.id AND w_b.isvalid<>'1')) and r.workflowid=b.id and r.requestid = c.requestid "+otherSqlWhere;
    if (innersqlwhere.length() > 0){
		sql += " and " + innersqlwhere;
    }
    sql +=  ") c " ;
    if((sharelevel_1 <2 && sharelevel_1>-1 && sharelevel_0 != 2) || (sharelevel_0 != 2 && (sharelevel_2 ==3 || sharelevel_3==9 || sharelevel_4==4 || sharelevel_5 == 5))) {
    	if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
    	{
    		sql += "  ON b.formid = c.formid and exists (select 1 from hrmresource e, (select nvl(resourceid, 1) resourceid, nvl(subcompanyid, 1) subcompanyid from HrmResourceVirtual union all select 0, 0 from dual) m, HrmDepartmentAllView f,HrmSubCompanyAllView h where ((c.creater = e.id and e.departmentid = f.id and e.subcompanyid1 = h.id) or (m.resourceid = e.id and c.creater = e.id and e.departmentid = f.id and m.subcompanyid = h.id)) and (f.id in("+hasrightdeps+") " + userrightsql + " OR h.id IN("+hassubcompany+"))) and ( " ;
    		if(!"".equals(wfversions)){
    			String []wfversionarray = Util.TokenizerString2(wfversions,",");
    			for(int f=0;f<wfversionarray.length;f++){
    				sql += " c.id in ('"+wfversionarray[f]+"') or";
    			}
    			sql = sql.substring(0, sql.length()-2);
    			sql += " ) and b.id="+reportid;
    		}		
    		//'" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'|| to_char(c.id) || ',%'  and b.id="+reportid;
		}else{
    		sql += "  ON b.formid = c.formid and exists (select 1 from hrmresource e,HrmDepartmentAllView f,HrmSubCompanyAllView h where c.creater=e.id and e.departmentid=f.id and e.subcompanyid1 = h.id and (f.id in("+hasrightdeps+") " + userrightsql + " OR h.id IN("+hassubcompany+") ) union all select 1 from HrmResourceVirtualView e,HrmDepartmentAllView f,HrmSubCompanyAllView h where c.creater=e.id and e.departmentid=f.id and e.subcompanyid1 = h.id and (f.id in("+hasrightdeps+") " + userrightsql + " OR h.id IN("+hassubcompany+") )) and ( " ;
    		if(!"".equals(wfversions)){
    			String []wfversionarray = Util.TokenizerString2(wfversions,",");
    			for(int f=0;f<wfversionarray.length;f++){
    				sql += " c.id in ('"+wfversionarray[f]+"') or";
    			}
    			sql = sql.substring(0, sql.length()-2);
    			sql += " ) and b.id="+reportid;
    		}
    		//'" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'+convert(varchar,c.id)+',%'  and b.id="+reportid;
    	}
    	//sql += " INNER JOIN hrmresource e INNER JOIN hrmdepartment f ON e.departmentid=f.id ON c.creater=e.id and f.id in("+hasrightdeps+") ON b.formid = c.formid and ','+b.reportwfid+',' like '%,'+convert(varchar,c.id)+',%' ";
    }else{
    	if (RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2"))
    	{
    		sql += " ON b.formid = c.formid and ( ";
    		if(!"".equals(wfversions)){
    			String []wfversionarray = Util.TokenizerString2(wfversions,",");
    			for(int f=0;f<wfversionarray.length;f++){
    				sql += " c.id in ('"+wfversionarray[f]+"') or";
    			}
    			sql = sql.substring(0, sql.length()-2);
    			sql += " ) and b.id="+reportid;
    		}
    		//'" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'||to_char(c.id)||',%'  and b.id="+reportid ;
    	}
    	else
    	{
    		sql += " ON b.formid = c.formid and ( ";
    		if(!"".equals(wfversions)){
    			String []wfversionarray = Util.TokenizerString2(wfversions,",");
    			for(int f=0;f<wfversionarray.length;f++){
    				sql += " c.id in ('"+wfversionarray[f]+"') or";
    			}
    			sql = sql.substring(0, sql.length()-2);
    			sql += " ) and b.id="+reportid;
    		}
    		//'" + "," + WorkflowVersion.getAllVersionStringByWFIDs(reportwfid) + "," + "' like '%,'+convert(varchar,c.id)+',%'  and b.id="+reportid;
    	}
    }

    sql += ") c INNER JOIN " + tablename + " a ";
    if(detailcount != 0 ) {
    	if(isNewBill){
    		//String fromSQL = "";
    		//String whereSQL = "";
    		List detailtablenameList = Util.TokenizerString(detailtablename, ",");
    		for(int tempInt=0;tempInt<detailtablenameList.size();tempInt++){
    			String tempdetailtablename = (String)detailtablenameList.get(tempInt);
    			if(useddetailtable.toUpperCase().indexOf("," + tempdetailtablename.toUpperCase()) > -1 ) {
    				sql += " LEFT JOIN "+tempdetailtablename + " ON a.id="+tempdetailtablename+"."+detailkeyfield;
    			}
    			//sql += " LEFT JOIN "+tempdetailtablename + " ON a.id="+tempdetailtablename+"."+detailkeyfield;
    			//fromSQL += tempdetailtablename+",";
    			//if(whereSQL.equals("")) whereSQL = " where a.id="+tempdetailtablename+"."+detailkeyfield;
    			//else whereSQL += " and a.id="+tempdetailtablename+"."+detailkeyfield;
    		}
    		//if(!fromSQL.equals("")){
    		//	fromSQL = fromSQL.substring(0,fromSQL.length()-1);
    		//	sql += ", "+fromSQL+whereSQL;
    		//}
    		haswhere = true ;
    	}else{
    		if(formid.equals("201")){
                sql += " LEFT JOIN " + detailtablename + " d ON a.requestid = d.detailrequestid" ;
            }else{
                sql += " LEFT JOIN " + detailtablename + " d ON a.id = d." +  detailkeyfield ;
            }
            haswhere = true ;
      }
      //sql += " ON c.requestid = a.requestid ";
    }
    sql += " ON c.requestid = a.requestid ";
    
    if (sqlwhere.length() > 0)
		sql += " where " + sqlwhere;
    sql += orderbystr ;
}
//    out.println("====================");
if(!orderbystr.equals("")) sql += ",c.requestid desc";
else sql += " order by c.requestid desc";
//System.out.println("--------2014sql = "+sql);
%>

<%
//----------------------------
//START
//----------------------------
int wfreportnumperpage = 20;
RecordSet.execute("select * from workflowReportCustom where userid=" + user.getUID());

if (RecordSet.next()) {
	wfreportnumperpage = Util.getIntValue(RecordSet.getString("wfreportnumperpage"), 20);
}

if (wfreportnumperpage <= 0) {
	wfreportnumperpage = 20;
}
%>


<%@page import="weaver.fna.general.FnaCommon"%><HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript"  src="/wui/common/jquery/jquery_wev8.js"></script>
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
    //alert("<%=sql%>\n\n\n"+datasql);
    //e8showAjaxTips("正在查询数据，请稍候...",true);
    e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(84041,user.getLanguage())%>",true,"xTable_message");
    ajax.send("guid1=<%=guid1%>&pmSql="+encodeURIComponent(datasql)+"&reportid=<%=reportid%>"+"&mouldId=<%=mouldId%>"+"&searchByMould=<%=searchByMould%>&isShowList=<%=isShowList.toString()%>&useddetailtable=<%=useddetailtable%>&pageSize=<%=wfreportnumperpage%>");
    //获取执行状态



    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里



        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            	//window.console.log("111111111111");
                document.all("showdatadiv").innerHTML=ajax.responseText;
                jQuery("#reportDateTbl tbody tr").hover(function () {
                	jQuery(this).addClass("Selected");
                }, function () {
                	jQuery(this).removeClass("Selected");
        		});
                //waitDiv.style.display = "none";
                e8showAjaxTips("",false);
            }catch(e){
                return false;
            }
        }
    }
    //document.write("http://192.168.0.38:8080/workflow/report/ReportResultData.jsp?pmSql="+escape(datasql)+"&reportid=<%=reportid%>"+"&mouldId=<%=mouldId%>"+"&searchByMould=<%=searchByMould%>");
}


function changepageSizeSel1(obj){
	var pageSize = obj;
	var currentPage = 1;
	var rowcount = $("input[name='rowcount']").val();
	var pageCount = $("input[name='pageCount']").val();

	var pTop= document.body.offsetHeight/4+document.body.scrollTop-100;
	//waitDiv.style.display = "block";
	//waitDiv.style.top = pTop;
	e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(84041,user.getLanguage())%>",true,"xTable_message");
	
    var ajax=ajaxinit();
    ajax.open("POST", "ReportResultData.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    var datasql = "<%=xssUtil.put(sql)%>";
    //alert("<%=sql%>\n\n\n"+datasql);
    ajax.send("guid1=<%=guid1%>&pmSql="+encodeURIComponent(datasql)+"&reportid=<%=reportid%>"+"&mouldId=<%=mouldId%>"+"&searchByMould=<%=searchByMould%>&isShowList=<%=isShowList.toString()%>&useddetailtable=<%=useddetailtable%>" + "&pageSize=" + pageSize + "&currentPage=" + currentPage + "&rowcount=" + rowcount + "&pageCount=" + pageCount);
    //获取执行状态



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
                //waitDiv.style.display = "none";
                e8showAjaxTips("",false);
            }catch(e){
                return false;
            }
        }
    }

}

var timeouthidden = null;
var ishow = false;

function clickShow(){
	if(timeouthidden){
		clearTimeout(timeouthidden);
	}
	timeouthidden = null;
	jQuery(".K13_select_list").css("display","block");
}

function hiddenOl(){
	if(timeouthidden){
		clearTimeout(timeouthidden);
	}
	timeouthidden = null;
	ishow = false;
	jQuery(".K13_select_list").css("display","none");
}
function hiddenO2(){
	if(timeouthidden){
		clearTimeout(timeouthidden);
	}
	timeouthidden = setTimeout(function(){
		if(!ishow){
			jQuery(".K13_select_list").css("display","none");
		}
		ishow = false;
	},500);
}
function showOl(){
	if(timeouthidden){
		clearTimeout(timeouthidden);
	}
	timeouthidden = null;
	jQuery(".K13_select_list").css("display","block");
	ishow = true;
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
	e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(84041,user.getLanguage())%>",true,"xTable_message");
	
    var ajax=ajaxinit();
    ajax.open("POST", "ReportResultData.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    var datasql = "<%=xssUtil.put(sql)%>";
    //alert("<%=sql%>\n\n\n"+datasql);
    ajax.send("guid1=<%=guid1%>&pmSql="+encodeURIComponent(datasql)+"&reportid=<%=reportid%>"+"&mouldId=<%=mouldId%>"+"&searchByMould=<%=searchByMould%>&isShowList=<%=isShowList.toString()%>&useddetailtable=<%=useddetailtable%>" + "&pageSize=" + pageSize + "&currentPage=" + currentPage + "&rowcount=" + rowcount + "&pageCount=" + pageCount);
    //获取执行状态



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
                //waitDiv.style.display = "none";
                e8showAjaxTips("",false);
            }catch(e){
                return false;
            }
        }
    }
}

function outputexcel() {
	var pTop= document.body.offsetHeight/4+document.body.scrollTop-100;
	//excelwaitDiv.style.display = "block";
	//excelwaitDiv.style.top = pTop;
	e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(84041,user.getLanguage())%>",true,"xTable_message");
	var datasql = "<%=xssUtil.put(sql)%>";
    var excelOutForm = document.getElementById("ExcelOut").contentWindow.document.createElement("form");
    //var excelOutForm = jQuery("#ExcelOut").contents().document.form(0);
    document.getElementById("ExcelOut").contentWindow.document.body.appendChild(excelOutForm);
    //excelOutForm.appendTo(document.body);
    excelOutForm.action = "/workflow/report/ReportResultData.jsp?guid1=<%=guid1%>&reportid=<%=reportid%>&mouldId=<%=mouldId%>&searchByMould=<%=searchByMould%>&isShowList=<%=isShowList.toString()%>&useddetailtable=<%=useddetailtable%>&outputExcel=1";
    excelOutForm.method = "POST";
    var excelOutParam = "<INPUT type=\"hidden\" name=\"pmSql\" value=\"" + datasql + "\">";
    excelOutForm.innerHTML = excelOutParam
    excelOutForm.submit();
}

function focus_goPage(id){
	var btnGo = jQuery("#jumpTobottom-goPage");
	jQuery("#jumpTobottom").attr('hideFocus',true);
	//btnGo.show();
	btnGo.get(0).style.display="block";
	btnGo.css('left','0px');
	jQuery("#jumpTobottom_go_page_wrap").css('border-color','#6694E3');
	btnGo.animate({left: '+=30'}, 50,function(){
		//$('#go_page_wrap').css('width','88px');
	});
}


function blur_goPage(id){
	setTimeout(function(){
		var btnGo = jQuery("#jumpTobottom-goPage");
		//$('#go_page_wrap').css('width','44px');
		btnGo.animate({
		    left: '-=44'
		  }, 100, function() {
			  jQuery("#jumpTobottom-goPage").css('left','0px');
			  jQuery("#jumpTobottom-goPage").hide();
			  jQuery("#jumpTobottom_go_page_wrap").css('border-color','#fff');
		  });
	},400);
}

function goback(){
	location.href = "ReportCondition.jsp?id=<%=reportid%>&mouldId=<%=Util.getIntValue(request.getParameter("mouldId"),0)%>&newMouldName=<%=Util.null2String(request.getParameter("newMouldName"))%>";
}

</script>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(15101,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY onload="showdata()">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<div id="showdatadiv">
</div>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">		 
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(364,user.getLanguage())%>"  class="e8_btn_top" onclick="javascript:goback()" >
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage())%>"  class="e8_btn_top" onclick="outputexcel()" >
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
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

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:goback(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:outputexcel(), ExcelOut} " ;
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
