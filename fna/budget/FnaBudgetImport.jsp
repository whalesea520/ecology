<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.interfaces.thread.FnaExecuteUpdateSqlThread"%>
<%@page import="java.util.concurrent.CountDownLatch"%>
<%@page import="java.util.concurrent.Executors"%>
<%@page import="java.util.concurrent.ExecutorService"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.file.ExcelRow"%>
<%@page import="weaver.file.ExcelStyle"%>
<%@page import="weaver.file.ExcelSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.file.FileManage"%>
<%@ page import="weaver.file.AESCoder"%>
<%@page import="weaver.fna.maintenance.FnaBudgetControl"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="FnaBudgetInfoComInfo" class="weaver.fna.maintenance.FnaBudgetInfoComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="BudgetApproveWFHandler" class="weaver.fna.budget.BudgetApproveWFHandler" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%
	boolean canEdit = HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user);
	
	if(!canEdit){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();
	String guid1 = UUID.randomUUID().toString();
	DecimalFormat df = new DecimalFormat("################################################0.00");
    boolean canImport = true;//可修改


	FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
	boolean ifbottomtotop = 1==Util.getIntValue(fnaSystemSetComInfo.get_ifbottomtotop());//是否启用从下至上编辑财务费用设置
    String ifTrue = "true";
   	if(ifbottomtotop){
   		ifTrue = "false";
   	}

	int keyWord2 = Util.getIntValue(request.getParameter("keyWord2"), -1);//科目重复验证字段
    
    String operation = Util.null2String(request.getParameter("operation"));
    String fnabudgetinfoid = Util.null2String(request.getParameter("fnabudgetinfoid"));//ID
    String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
    String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
    String budgetperiods = Util.null2String(request.getParameter("budgetperiods"));//期间ID
    String openPanter = Util.null2String(request.getParameter("openPanter"));
    
    FileUpload fu = null;
    if(operation.equals("")){
        fu = new FileUpload(request,false);
   	    operation = Util.null2String(fu.getParameter("operation"));
		fnabudgetinfoid = Util.null2String(fu.getParameter("fnabudgetinfoid"));
		organizationid = Util.null2String(fu.getParameter("organizationid"));
		organizationtype = Util.null2String(fu.getParameter("organizationtype"));
		budgetperiods = Util.null2String(fu.getParameter("budgetperiods"));
		openPanter = Util.null2String(fu.getParameter("openPanter"));
		keyWord2 = Util.getIntValue(fu.getParameter("keyWord2"), -1);
    }
    if("".equals(openPanter)){
    	openPanter = "parent";
    }

	String revisionName = "";
    if(!"".equals(fnabudgetinfoid)){
        RecordSet.executeSql(" select budgetorganizationid, organizationtype, budgetperiods, revision, status from FnaBudgetInfo where id = "+fnabudgetinfoid);
		if(RecordSet.next()){
	        organizationid = Util.null2String(RecordSet.getString("budgetorganizationid"));
	        organizationtype = Util.null2String(RecordSet.getString("organizationtype"));
	        budgetperiods = Util.null2String(RecordSet.getString("budgetperiods"));
	        if(RecordSet.getInt("status")==0){
	        	revisionName = SystemEnv.getHtmlLabelName(220,user.getLanguage());//草稿
	        }else if(RecordSet.getInt("status")==1){
	        	revisionName = SystemEnv.getHtmlLabelName(18431,user.getLanguage())+"（V"+RecordSet.getInt("revision")+"）";//生效
	        }else if(RecordSet.getInt("status")==2){
	        	revisionName = SystemEnv.getHtmlLabelName(1477,user.getLanguage())+"（V"+RecordSet.getInt("revision")+"）";//历史
	        }else if(RecordSet.getInt("status")==3){
	        	revisionName = SystemEnv.getHtmlLabelName(2242,user.getLanguage())+"（V"+RecordSet.getInt("revision")+"）";//待审批
	        }
		}
    }else{
        response.sendRedirect("/notice/noright.jsp");
        return;
    }

	BudgetfeeTypeComInfo btc = new BudgetfeeTypeComInfo();
	int sqlCondOrgType4ftRul = Util.getIntValue(organizationtype);
	int sqlCondOrgId4ftRul = Util.getIntValue(organizationid);
	if(Util.getIntValue(organizationtype)==3){//个人预算
		sqlCondOrgType4ftRul = 2;
		sqlCondOrgId4ftRul = Util.getIntValue(ResourceComInfo.getDepartmentID(organizationid));
	}
    
    String para = "";
    char separator = Util.getSeparator();
    Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
            Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
            Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) + " " +
            Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
            Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
            Util.add0(today.get(Calendar.SECOND), 2);
    
    if(operation.equals("import")){
        String msg = "";
        int errorrow = 0;
        int errortab = 0;
        boolean impflag = true;
        
    	FileManage fm = new FileManage();

    	String Excelfilepath="";
     
    	int fileid = 0 ;
    	
    	List<List<String>> budgetperiodsList = new ArrayList<List<String>>();
	    
 	    List<String> msubject3names = new ArrayList<String>();
 	    List<List<String>> mbudgetvalues = new ArrayList<List<String>>();

 	    List<String> qsubject3names = new ArrayList<String>();
 	    List<List<String>> qbudgetvalues = new ArrayList<List<String>>();

 	    List<String> hsubject3names = new ArrayList<String>();
 	    List<List<String>> hbudgetvalues = new ArrayList<List<String>>();
 	    
 	    List<String> ysubject3names = new ArrayList<String>();
 	    List<List<String>> ybudgetvalues = new ArrayList<List<String>>();

 	    fileid = Util.getIntValue(fu.uploadFiles("filename"),0);

       	String filename = fileid+"_"+fu.getFileName();
       	FileInputStream finput1 = null;
       	try{
    		FnaSynchronized fnaSynchronized1 = new FnaSynchronized(FnaSynchronized.GET_LOCK_STR_FNABUDGETINFO_UPDATE(), user.getUID(), "正在导入预算数据！", user.getLanguage(), true);
    		try{
    			boolean budgetCanBeNegative = false;
		       	if(filename!=null&&!"".equals(filename)&&fileid>0){
		
		 	        String sql = "select isaesencrypt,aescode,filerealpath,iszip from imagefile where imagefileid = "+fileid;
		 	        RecordSet.executeSql(sql);
		 	        String uploadfilepath="";
		 	        String isaesencrypt="";
		 	        String aescode="";
		 	        if(RecordSet.next()) {
		 	        	uploadfilepath =  RecordSet.getString("filerealpath");
		 	        	isaesencrypt = RecordSet.getString("isaesencrypt");
		 	        	aescode = RecordSet.getString("aescode");
		 	        }
		 	
		 		    if(!uploadfilepath.equals("")) {
		 		        Excelfilepath = request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")))+"\\"+filename ;
		 		        //FileManage.copy(uploadfilepath,Excelfilepath);
						FileManage.copy(uploadfilepath,Excelfilepath, isaesencrypt, aescode);
		 	        }
				    
		 		    try {
		 				finput1 = new FileInputStream(Excelfilepath);

		 				
		 				//查询各个的期间的关闭状态,整合未关闭的期间
		 				int[] openPeriodsid = new int[]{0,0,0,0,0,0,0,0,0,0,0,0};
		 				RecordSet rSet = new RecordSet();
		 				String periodsql = " select * from FnaYearsPeriodsList where fnayearid = " + budgetperiods;
		 				periodsql += " order by Periodsid ";
		 				rSet.executeSql(periodsql);
		 				int m = 0;
		 				while(rSet.next()){
		 					int status = rSet.getInt("status");
		 					int periodsid = rSet.getInt("Periodsid");
		 					if(periodsid != 13){
		 						openPeriodsid[m] = status;
		 					}
		 					m++;
		 				}

		 				List<String> fnaBudgetfeeType_idList = new ArrayList<String>();
		 				List<String> fnaBudgetfeeType_repeat_codeList = new ArrayList<String>();//科目编码有重复的list
		 				HashMap<String, String> fnaBudgetfeeType_codeNameHm = new HashMap<String, String>(); 
	 					rSet.executeQuery("select a.id, a.codeName from FnaBudgetfeeType a where a.ISEDITFEETYPE = 1");
	 					while(rSet.next()){
	 						String _id = Util.null2String(rSet.getString("id")).trim();
	 						String _codeName = Util.null2String(rSet.getString("codeName")).trim();
	 						fnaBudgetfeeType_idList.add(_id);
	 						if(keyWord2==1){
	 							if(!"".equals(_codeName)){
		 							if(fnaBudgetfeeType_codeNameHm.containsKey(_codeName)){
		 								if(!fnaBudgetfeeType_repeat_codeList.contains(_codeName)){
		 									fnaBudgetfeeType_repeat_codeList.add(_codeName);
		 								}
		 							}else{
		 								fnaBudgetfeeType_codeNameHm.put(_codeName, _id);
		 							}
	 							}
	 						}
	 					}
			 				
			 			
	 					if("".equals(msg)){
			 				//InputStream is = new BufferedInputStream(finput1);
							//if("1".equals(isaesencrypt)){
								//is = AESCoder.decrypt(is,aescode);
							//}
			 				//POIFSFileSystem fs1 = new POIFSFileSystem(is);
			 				POIFSFileSystem fs1 = new POIFSFileSystem(finput1);
			 				HSSFWorkbook workbook1 = new HSSFWorkbook(fs1);
			 				
			 				for(int q1=1;q1<5;q1++){
			 				    if(!impflag){
			 				    	break;
			 				    }
			 				    
				 				HSSFSheet sheet1 = workbook1.getSheetAt(q1-1);
				 				
				 				HSSFRow row = null;
				 				HSSFCell cell = null;
				 				List<String>  titleNameList = new ArrayList<String>();//有效期间list
				 				List<String>  periodsList = new ArrayList<String>();//
				 				
				 				if(q1 == 1){
				 					for(int i = 0; i < openPeriodsid.length; i++){
					 					if(openPeriodsid[i] == 0){
					 						titleNameList.add((i+1)+"期");
					 						periodsList.add(String.valueOf(i+1));
					 					}
					 				}
				 					titleNameList.add("全年");
				 				}else if(q1==2){
				 					for(int i = 1; i < 5 ;i++){
				 						if(openPeriodsid[3*i-3]==0||openPeriodsid[3*i-2]==0||openPeriodsid[3*i-1]==0){
				 							titleNameList.add(i+"期");
				 							periodsList.add(String.valueOf(i));
				 						}
				 					}
				 					titleNameList.add("全年");
				 				}else if(q1==3){
				 					for(int i = 1; i < 3; i++){
				 						if(openPeriodsid[6*i-6]==0||openPeriodsid[6*i-5]==0||openPeriodsid[6*i-4]==0||openPeriodsid[6*i-3]==0||openPeriodsid[6*i-2]==0||openPeriodsid[6*i-1]==0){
				 							titleNameList.add(i+"期");
				 							periodsList.add(String.valueOf(i));
				 						}
				 					}
				 					titleNameList.add("全年");
				 				}else if(q1==4){
				 					boolean openYear = false;
				 					for(int i = 0; i < openPeriodsid.length; i ++){
				 						if(openPeriodsid[i] == 0){
				 							openYear = true;
				 						}
				 					}
				 					if(openYear){
				 						titleNameList.add("全年");
				 						periodsList.add("1");
				 					}
				 				}
				 				
				 				
				 				HSSFRow rowTitle = sheet1.getRow(0);
				 				for(int i = 0; i < titleNameList.size(); i++){
				 					HSSFCell cellTitle = rowTitle.getCell((short)(i+2));
				 					if(cellTitle!=null){
				 						String titleName = Util.null2String(getCellValue(cellTitle)).trim();
				 						if(!titleNameList.get(i).equals(titleName)){
				 							msg = "131210";//模版不匹配，请重新下载模版
				 				            errorrow = 0;
				 				            errortab = q1;
				 	 				        impflag = false;
				 							break;
				 						}
				 					}else{
				 						msg = "131210";//模版不匹配，请重新下载模版
			 				            errorrow = 0;
			 				            errortab = q1;
			 	 				        impflag = false;
			 							break;
				 					}
				 				}
				 				
				 				budgetperiodsList.add(periodsList);
								List<String> km_not_distinct_in_same_org_list = new ArrayList<String>();
				 				
				 				int rowsNum = sheet1.getLastRowNum();
				 				for (int i = 1; i < rowsNum + 1; i++) {
				 				    
									row = sheet1.getRow(i);
									
									List<String> tmpbudgetList = new ArrayList<String>();//有效期间对应的预算list
									
									//String[] tmpbudget = null;
									/* if(q1==1) tmpbudget = new String[]{"","","","","","","","","","","",""};
									if(q1==2) tmpbudget = new String[]{"","","",""};
									if(q1==3) tmpbudget = new String[]{"",""};
									if(q1==4) tmpbudget = new String[]{""};  */
									
			 					    cell = row.getCell((short)0);
			 					    String tmpsubject3 = getCellValue(cell);
			 					    cell = row.getCell((short)1);
			 					    String tmpsubject3Name = getCellValue(cell);
			 					  	budgetCanBeNegative = false;
									
									if(tmpsubject3!=null&&!"".equals(tmpsubject3)){
										/*
									    RecordSet.executeSql(" select id,budgetCanBeNegative from FnaBudgetfeeType where feeperiod = "+q1+" and isEditFeeType = 1 and id = "+Util.getIntValue(tmpsubject3));
									    if(RecordSet.next()){
									        tmpsubject3 = Util.null2String(RecordSet.getString(1));
									        budgetCanBeNegative = "1".equals(Util.null2String(RecordSet.getString("budgetCanBeNegative")));
									    } else {
									        msg = "19983";//导入时出错，某科目名称在数据库中不存在
				 				            errorrow = i;
				 				            errortab = q1;
				 	 				        impflag = false;
				 	 				        break;
									    }
									    */
									    
				 						if(keyWord2==1){
				 							if(fnaBudgetfeeType_codeNameHm.containsKey(tmpsubject3)){
				 								if(fnaBudgetfeeType_repeat_codeList.contains(tmpsubject3)){
						 							msg = "132323";//科目编码重复,请检查
						 				            errorrow = 0;
						 				            errortab = 1;
						 	 				        impflag = false;
						 							break;
				 								}
				 								tmpsubject3 = fnaBudgetfeeType_codeNameHm.get(tmpsubject3);
				 							}
				 						}
									    if(!fnaBudgetfeeType_idList.contains(tmpsubject3)){
									        msg = "132386";//导入时出错，科目不是可编制科目，无法导入！请检查！
				 				            errorrow = i;
				 				            errortab = q1;
				 	 				        impflag = false;
				 	 				        break;
									    }
									    
									    if(q1!=budgetfeeTypeComInfo.getSubjectFeeperiod(Util.getIntValue(tmpsubject3))){
									        msg = "19983";//导入时出错，某科目名称在数据库中不存在
				 				            errorrow = i;
				 				            errortab = q1;
				 	 				        impflag = false;
				 	 				        break;
									    }
									    
									    budgetCanBeNegative = "1".equals(Util.null2String(budgetfeeTypeComInfo.getBudgetCanBeNegative(tmpsubject3)).trim());
									    
							    		boolean _flag = btc.checkRuleSetRight(sqlCondOrgType4ftRul, sqlCondOrgId4ftRul, Util.getIntValue(tmpsubject3));
							    		if(!_flag){
									        msg = "19983";//导入时出错，某科目名称在数据库中不存在
				 				            errorrow = i;
				 				            errortab = q1;
				 	 				        impflag = false;
				 	 				        break;
							    		}
							    		
							    		if(km_not_distinct_in_same_org_list.contains(tmpsubject3)){
									        msg = "-987654321";//自定义错误信息
				 				            errorrow = i;
				 				            errortab = q1;
				 	 				        impflag = false;

				 	 						String _separator = fnaSystemSetComInfo.get_separator();
				 	 						if("".equals(_separator)){
				 	 							_separator = "/";
				 	 						}
											String _errorInfo = SystemEnv.getHtmlLabelNames("20208,18082",user.getLanguage())+"："+budgetfeeTypeComInfo.getSubjectFullName(tmpsubject3, _separator);//科目导入重复
											request.getSession().setAttribute(msg+"_errorInfo", _errorInfo);
											
				 	 				        break;
							    		}
							    		km_not_distinct_in_same_org_list.add(tmpsubject3);
							    		
									} else {
									    msg = "20213";//导入时出错，某科目名称为空!
			 				            errorrow = i;
			 				            errortab = q1;
			 	 				        impflag = false;
			 	 				        break;
									}
									
									boolean flag_tmpbudgetstr = true;
									for(int q2 = 0; q2 < periodsList.size(); q2++){
									    cell = row.getCell((new Short((2+q2)+"")).shortValue());
									    String tmpbudgetstr = Util.null2String(getCellValue(cell));
									    
									    if(flag_tmpbudgetstr && Util.getDoubleValue(tmpbudgetstr, -1.0) < 0.0 && !budgetCanBeNegative){//新预算额度不能小于0,且科目预算不可为负数
				 	 				      	flag_tmpbudgetstr = false;
				 	 				        break;
									    }
									    
									    //tmpbudget[q2] = tmpbudgetstr;
									    tmpbudgetList.add(tmpbudgetstr);
									}
									
									if(!flag_tmpbudgetstr){//新预算额度不能小于0
								        msg = "127307";
			 				            errorrow = i;
			 				            errortab = q1;
			 	 				        impflag = false;
			 	 				        break;
									}
			
				 				    if(tmpsubject3!=null&&!"".equals(tmpsubject3)){
				 				        int tmpcount = 0;
										for(int q2 = 0; q2 < tmpbudgetList.size(); q2++){
				 				        	if(!tmpbudgetList.get(q2).equals("")){
				 				        		tmpcount++;
				 				        	}
										}
				 				        if(tmpcount>0){
											if(q1==1){
					 					 	    msubject3names.add(tmpsubject3);
					 					 	    mbudgetvalues.add(tmpbudgetList);
											} else if(q1==2){
										 	    qsubject3names.add(tmpsubject3);
										 	    qbudgetvalues.add(tmpbudgetList);
											} else if(q1==3){
										 	    hsubject3names.add(tmpsubject3);
										 	    hbudgetvalues.add(tmpbudgetList);
											} else if(q1==4){
										 	    ysubject3names.add(tmpsubject3);
										 	    ybudgetvalues.add(tmpbudgetList);
											}
				 				        }
				 				    } else {
									    msg = "20213";//导入时出错，某科目名称为空!
			 				            errorrow = i;
			 				            errortab = q1;
			 	 				        impflag = false;
			 	 				        break;
				 				    }
				 				}
			 				}
			 		    }
		 		    } catch(Exception e){
		 	            impflag = false;
		 	            msg = "20040";//Excel文件导入失败，请检查Excel文件格式是否正确！
		 		    }
		         } else {
		             impflag = false;
		             msg = "20041";//文件不存在!
		         }
				
		 		if(impflag&&((msubject3names.size()>0)||(qsubject3names.size()>0)||(hsubject3names.size()>0)||(ysubject3names.size()>0))){
		            String status = "0";
		            String budgetstatus = "0";
		            String revision = "0";
		            //如果已有草稿，则查找删除
		            RecordSet.executeSql(" select id from FnaBudgetInfo where "
		                           + " budgetorganizationid = " + organizationid
		                           + " and organizationtype = " + organizationtype
		                           + " and budgetperiods = " + budgetperiods
		                           + " and status = 0 ");
		            while(RecordSet.next()) {
		                String existfnabudgetinfoid = RecordSet.getString(1);
		                RecordSet2.executeSql("delete from FnaBudgetInfoDetail where budgetinfoid = " + existfnabudgetinfoid);
		                RecordSet2.executeSql("delete from FnaBudgetInfo where id = " + existfnabudgetinfoid);
		            }
		            
		            para = budgetperiods + separator
		                    + organizationid + separator
		                    + organizationtype + separator
		                    + budgetstatus + separator
		                    + user.getUID() + separator
		                    + Util.fromScreen(currentdate, user.getLanguage()) + separator
		                    + revision + separator
		                    + status;
		            RecordSet.executeProc("FnaBudgetInfo_Insert", para);
		            
		            if (RecordSet.next()) {
		                
		                fnabudgetinfoid = RecordSet.getString(1);
		                
		                //
						String inusefnabudgetinfoid = "";
						String sql2 = "SELECT id FROM FnaBudgetInfo \n" +
								" WHERE status = 1 \n" +
								" AND budgetperiods = "+budgetperiods+" \n" +
								" AND organizationtype = "+organizationtype+" \n" +
								" AND budgetorganizationid = "+organizationid;
						RecordSet2.executeSql(sql2);
						if(RecordSet2.next()){
							inusefnabudgetinfoid = RecordSet2.getString("id");
						}
						
						if(Util.getIntValue(inusefnabudgetinfoid) > 0){
							sql2 = "insert into fnabudgetinfodetail\n" +
								"  (budgetinfoid, budgetperiods, budgettypeid, budgetresourceid, budgetcrmid, budgetprojectid, budgetaccount, budgetremark, budgetperiodslist) \n" + 
								" select "+fnabudgetinfoid+", budgetperiods, budgettypeid, budgetresourceid, budgetcrmid, budgetprojectid, budgetaccount, budgetremark, budgetperiodslist \n" + 
								" from fnabudgetinfodetail " +
								" where budgetinfoid = "+inusefnabudgetinfoid;
							RecordSet2.executeSql(sql2);
						}

			            HashMap<String, String> fnabudgetinfodetail_id_hm = new HashMap<String, String>();
						sql2 = "select id, budgettypeid, budgetperiodslist from fnabudgetinfodetail where budgetinfoid = ?";
						RecordSet2.executeQuery(sql2, fnabudgetinfoid);
						while(RecordSet2.next()){
							fnabudgetinfodetail_id_hm.put(Util.null2String(RecordSet2.getString("budgettypeid")).trim()+"_"+Util.null2String(RecordSet2.getString("budgetperiodslist")).trim(), 
									RecordSet2.getString("id"));
						}
			            
						List<String> delete_fnabudgetinfodetailId_List = new ArrayList<String>();
						StringBuffer insert_batchSql_budgetaccount = new StringBuffer();
						List<String> insert_batchSql_budgetaccount_list = new ArrayList<String>();
						int insert_batchSql_budgetaccount_cnt = 0;
		                
		                List<String> periods = budgetperiodsList.get(0);
			 		    
			            for (int j = 0; j < msubject3names.size(); j++) {
			                
			                //String[] budgetvalues = (String[]) mbudgetvalues.get(j);
			                List<String> budgetvalueList = mbudgetvalues.get(j);
			                
			                String budgettypeid = msubject3names.get(j).toString();
			               	budgetCanBeNegative = "1".equals(budgetfeeTypeComInfo.getBudgetCanBeNegative(budgettypeid));
			                for(int jj = 0;budgetvalueList!=null && budgetvalueList.size()>0 && jj < budgetvalueList.size();jj++){
			                	/*
				                para = fnabudgetinfoid + separator
				                        + budgetperiods + separator
				                        + periods.get(jj) + separator
				                        + budgettypeid + separator
				                        + "" + separator
				                        + "" + separator
				                        + "" + separator
				                        + budgetvalueList.get(jj) + separator
				                        + "";
				
				                if ((budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&Util.getDoubleValue(budgetvalueList.get(jj)) >= 0.00) 
				                		|| (budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&budgetCanBeNegative)){
				                    RecordSet2.executeProc("FnaBudgetInfoDetail_Insert", para);
				                }
				                */

				                if ((budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&Util.getDoubleValue(budgetvalueList.get(jj)) >= 0.00) 
				                		|| (budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&budgetCanBeNegative)){
									int budgetperiodslist = Util.getIntValue(periods.get(jj));
				                	String _deleteKey = budgettypeid+"_"+budgetperiodslist;
				                	int _deleteId = Util.getIntValue(fnabudgetinfodetail_id_hm.get(_deleteKey));
				                	if(_deleteId > 0){
				                		delete_fnabudgetinfodetailId_List.add(String.valueOf(_deleteId));
				                	}
									
				                	if(insert_batchSql_budgetaccount_cnt > 10000){
				                		insert_batchSql_budgetaccount_list.add(insert_batchSql_budgetaccount.toString());
				                		insert_batchSql_budgetaccount_cnt = 0;
				                		insert_batchSql_budgetaccount = new StringBuffer();
				                	}
				                	insert_batchSql_budgetaccount_cnt++;
				                	
									if(insert_batchSql_budgetaccount.length() > 0){
										insert_batchSql_budgetaccount.append("\n union all \n");
									}
									insert_batchSql_budgetaccount.append(" select "+fnabudgetinfoid+","+budgetperiods+","+budgetperiodslist+","+budgettypeid+",");
									insert_batchSql_budgetaccount.append("null,null,null,"+budgetvalueList.get(jj)+",null ");
									if("oracle".equals(RecordSet2.getDBType())){
										insert_batchSql_budgetaccount.append(" from dual ");
									}
				                }
			                }
			            }
			            
			            for (int j = 0; j < qsubject3names.size(); j++) {
			                
			                //String[] budgetvalues = (String[]) qbudgetvalues.get(j);
			                List<String> budgetvalueList = qbudgetvalues.get(j);
			                
			                String budgettypeid = qsubject3names.get(j).toString();
			                budgetCanBeNegative = "1".equals(budgetfeeTypeComInfo.getBudgetCanBeNegative(budgettypeid));
			                for(int jj = 0;budgetvalueList!=null && budgetvalueList.size()>0 && jj < budgetvalueList.size();jj++){
			                	/*
				                para = fnabudgetinfoid + separator
				                        + budgetperiods + separator
				                        + periods.get(jj) + separator
				                        + budgettypeid + separator
				                        + "" + separator
				                        + "" + separator
				                        + "" + separator
				                        + budgetvalueList.get(jj) + separator
				                        + "";
				
			                    if ((budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&Util.getDoubleValue(budgetvalueList.get(jj)) >= 0.00)
			                    		||(budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&budgetCanBeNegative)){		                    
				                    RecordSet2.executeProc("FnaBudgetInfoDetail_Insert", para);
			                    }
			                    */

			                    if ((budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&Util.getDoubleValue(budgetvalueList.get(jj)) >= 0.00)
			                    		||(budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&budgetCanBeNegative)){	
									int budgetperiodslist = Util.getIntValue(periods.get(jj));
				                	String _deleteKey = budgettypeid+"_"+budgetperiodslist;
				                	int _deleteId = Util.getIntValue(fnabudgetinfodetail_id_hm.get(_deleteKey));
				                	if(_deleteId > 0){
				                		delete_fnabudgetinfodetailId_List.add(String.valueOf(_deleteId));
				                	}
									
				                	if(insert_batchSql_budgetaccount_cnt > 10000){
				                		insert_batchSql_budgetaccount_list.add(insert_batchSql_budgetaccount.toString());
				                		insert_batchSql_budgetaccount_cnt = 0;
				                		insert_batchSql_budgetaccount = new StringBuffer();
				                	}
				                	insert_batchSql_budgetaccount_cnt++;
				                	
									if(insert_batchSql_budgetaccount.length() > 0){
										insert_batchSql_budgetaccount.append("\n union all \n");
									}
									insert_batchSql_budgetaccount.append(" select "+fnabudgetinfoid+","+budgetperiods+","+budgetperiodslist+","+budgettypeid+",");
									insert_batchSql_budgetaccount.append("null,null,null,"+budgetvalueList.get(jj)+",null ");
									if("oracle".equals(RecordSet2.getDBType())){
										insert_batchSql_budgetaccount.append(" from dual ");
									}
			                    }
			                }
			            }
			            
			            for (int j = 0; j < hsubject3names.size(); j++) {
			                
			                //String[] budgetvalues = (String[]) hbudgetvalues.get(j);
			                List<String> budgetvalueList = hbudgetvalues.get(j);
			                
			                String budgettypeid = hsubject3names.get(j).toString();
			                budgetCanBeNegative = "1".equals(budgetfeeTypeComInfo.getBudgetCanBeNegative(budgettypeid));
			                for(int jj = 0;budgetvalueList!=null && budgetvalueList.size()>0 && jj < budgetvalueList.size();jj++){
			                	/*
				                para = fnabudgetinfoid + separator
				                        + budgetperiods + separator
				                        + periods.get(jj) + separator
				                        + budgettypeid + separator
				                        + "" + separator
				                        + "" + separator
				                        + "" + separator
				                        + budgetvalueList.get(jj) + separator
				                        + "";
				
			                    if ((budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&Util.getDoubleValue(budgetvalueList.get(jj)) >= 0.00)
			                    		||(budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&budgetCanBeNegative)){	                    
				                    RecordSet2.executeProc("FnaBudgetInfoDetail_Insert", para);
			                    }
			                    */

			                    if ((budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&Util.getDoubleValue(budgetvalueList.get(jj)) >= 0.00)
			                    		||(budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&budgetCanBeNegative)){	     
									int budgetperiodslist = Util.getIntValue(periods.get(jj));
				                	String _deleteKey = budgettypeid+"_"+budgetperiodslist;
				                	int _deleteId = Util.getIntValue(fnabudgetinfodetail_id_hm.get(_deleteKey));
				                	if(_deleteId > 0){
				                		delete_fnabudgetinfodetailId_List.add(String.valueOf(_deleteId));
				                	}
									
				                	if(insert_batchSql_budgetaccount_cnt > 10000){
				                		insert_batchSql_budgetaccount_list.add(insert_batchSql_budgetaccount.toString());
				                		insert_batchSql_budgetaccount_cnt = 0;
				                		insert_batchSql_budgetaccount = new StringBuffer();
				                	}
				                	insert_batchSql_budgetaccount_cnt++;
				                	
									if(insert_batchSql_budgetaccount.length() > 0){
										insert_batchSql_budgetaccount.append("\n union all \n");
									}
									insert_batchSql_budgetaccount.append(" select "+fnabudgetinfoid+","+budgetperiods+","+budgetperiodslist+","+budgettypeid+",");
									insert_batchSql_budgetaccount.append("null,null,null,"+budgetvalueList.get(jj)+",null ");
									if("oracle".equals(RecordSet2.getDBType())){
										insert_batchSql_budgetaccount.append(" from dual ");
									}
			                    }
			                }
			            }
			
			            for (int j = 0; j < ysubject3names.size(); j++) {
			                
			                //String[] budgetvalues = (String[]) ybudgetvalues.get(j);
			                List<String> budgetvalueList = ybudgetvalues.get(j);
			                
			                String budgettypeid = ysubject3names.get(j).toString();
			                budgetCanBeNegative = "1".equals(budgetfeeTypeComInfo.getBudgetCanBeNegative(budgettypeid));
			                for(int jj = 0;budgetvalueList!=null && budgetvalueList.size()>0 && jj < budgetvalueList.size();jj++){
			                	/*
				                para = fnabudgetinfoid + separator
				                        + budgetperiods + separator
				                        + periods.get(jj) + separator
				                        + budgettypeid + separator
				                        + "" + separator
				                        + "" + separator
				                        + "" + separator
				                        + budgetvalueList.get(jj) + separator
				                        + "";
				
			                    if ((budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&Util.getDoubleValue(budgetvalueList.get(jj)) >= 0.00)
			                    		||(budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&budgetCanBeNegative)){		                    
				                    RecordSet2.executeProc("FnaBudgetInfoDetail_Insert", para);
			                    }
			                    */

			                    if ((budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&Util.getDoubleValue(budgetvalueList.get(jj)) >= 0.00)
			                    		||(budgetvalueList.get(jj)!=null&&!"".equals(budgetvalueList.get(jj))&&budgetCanBeNegative)){	
									int budgetperiodslist = Util.getIntValue(periods.get(jj));
				                	String _deleteKey = budgettypeid+"_"+budgetperiodslist;
				                	int _deleteId = Util.getIntValue(fnabudgetinfodetail_id_hm.get(_deleteKey));
				                	if(_deleteId > 0){
				                		delete_fnabudgetinfodetailId_List.add(String.valueOf(_deleteId));
				                	}
									
				                	if(insert_batchSql_budgetaccount_cnt > 10000){
				                		insert_batchSql_budgetaccount_list.add(insert_batchSql_budgetaccount.toString());
				                		insert_batchSql_budgetaccount_cnt = 0;
				                		insert_batchSql_budgetaccount = new StringBuffer();
				                	}
				                	insert_batchSql_budgetaccount_cnt++;
				                	
									if(insert_batchSql_budgetaccount.length() > 0){
										insert_batchSql_budgetaccount.append("\n union all \n");
									}
									insert_batchSql_budgetaccount.append(" select "+fnabudgetinfoid+","+budgetperiods+","+budgetperiodslist+","+budgettypeid+",");
									insert_batchSql_budgetaccount.append("null,null,null,"+budgetvalueList.get(jj)+",null ");
									if("oracle".equals(RecordSet2.getDBType())){
										insert_batchSql_budgetaccount.append(" from dual ");
									}
			                    }
			                }
			            }

						
						if(insert_batchSql_budgetaccount.length() > 0){
	                		insert_batchSql_budgetaccount_list.add(insert_batchSql_budgetaccount.toString());
						}
						
						if(delete_fnabudgetinfodetailId_List.size() > 0){
							String delete_sql = "delete from FnaBudgetInfoDetail where (1=2 ";
							List<String> delete_fnabudgetinfodetailId_List_sqlCond_List = FnaCommon.initData1(delete_fnabudgetinfodetailId_List);
							int delete_fnabudgetinfodetailId_List_sqlCond_List_len = delete_fnabudgetinfodetailId_List_sqlCond_List.size();
							for(int ii=0;ii<delete_fnabudgetinfodetailId_List_sqlCond_List_len;ii++){
								delete_sql += " or id in ("+delete_fnabudgetinfodetailId_List_sqlCond_List.get(ii)+") ";
							}
							delete_sql += " ) and budgetinfoid = ?";
							RecordSet2.executeUpdate(delete_sql, fnabudgetinfoid);
						}
						
						int insert_batchSql_budgetaccount_list_len = insert_batchSql_budgetaccount_list.size();
	                    if(insert_batchSql_budgetaccount_list_len > 0){
							ExecutorService executorService = null;
							try{
								executorService = Executors.newCachedThreadPool();//使用线程池进行线程管理
		            			CountDownLatch doneSignal = new CountDownLatch(insert_batchSql_budgetaccount_list_len);//使用计数栅栏
		            			for (int j = 0; j < insert_batchSql_budgetaccount_list_len; j++) {
			                    	String executeUpdateSqlThread = "INSERT INTO FnaBudgetInfoDetail " +
			                    			"(budgetinfoid, budgetperiods, budgetperiodslist, budgettypeid," +
			                    			" budgetresourceid, budgetcrmid, budgetprojectid, budgetaccount, budgetremark) \n"+
			                    			insert_batchSql_budgetaccount_list.get(j);
		            				executorService.submit(new FnaExecuteUpdateSqlThread(doneSignal, executeUpdateSqlThread));
								}
		            			doneSignal.await();//使用CountDownLatch的await方法，等待所有线程完成sheet操作
							}finally{
								if(executorService!=null){
									executorService.shutdown();
								}
							}
	                    }
						
		            }
		 		} else {
		 		    response.sendRedirect("FnaBudgetImport.jsp?msgid="+msg+(errorrow>0?"&row="+errorrow:"")+(errortab>0?"&tab="+errortab:"")+"&fnabudgetinfoid="+fnabudgetinfoid+"&openPanter="+openPanter+"&keyWord2="+keyWord2);
		 		    return;
		 		}
    		}finally{
    			fnaSynchronized1.releaseLock();
    		}
       	}finally{
       		try{
       			if(finput1!=null){
       				finput1.close();
       			}
       		}catch(Exception e){}
       		try{
       			if(fileid>0 && filename!=null && !"".equals(filename) && Excelfilepath!=null && !"".equals(Excelfilepath)){
       				FileManage.DeleteFile(Excelfilepath);
       			}
       		}catch(Exception e){}
       	}
       	
       	//response.sendRedirect("/fna/budget/FnaBudgetImport.jsp?msgid=-1&fnabudgetinfoid="+fnabudgetinfoid);
       	//response.sendRedirect("/fna/budget/FnaBudgetView.jsp?budgetinfoid="+fnabudgetinfoid);
       	out.println("<script language=javascript>"+"\r\n"+
       				"	var parentWin = parent.getParentWindow(window);"+"\r\n"+
       				"	parentWin."+openPanter+".location.href = \"/fna/budget/FnaBudgetView.jsp?budgetinfoid="+fnabudgetinfoid+"\";"+"\r\n"+
       				"	parentWin.closeDialog();"+"\r\n"+
       				"</script>");
       	return;
    }
%>
<%!
private String getCellValue(HSSFCell cell){
    String result = "";
    try {
	    if(cell.getCellType()==1){
	        result = cell.getStringCellValue();
	    } else if(cell.getCellType()==0){
	        java.text.DecimalFormat format = new java.text.DecimalFormat("########################.##");
	        result = format.format((new Double(cell.getNumericCellValue())).doubleValue());
	    } else if(cell.getCellType()==3){
	        result = "";
	    }
    } catch(Exception e){
        result = "";
    }
    return result;
}
%>
<%    
    String msgid = Util.null2String(request.getParameter("msgid"));
    int rowid = Util.getIntValue(Util.null2o(request.getParameter("row")));
    int tabid = Util.getIntValue(Util.null2o(request.getParameter("tab")));

    if ("".equals(fnabudgetinfoid)) {
        canImport = false;
    }
    
    String budgetyears = "";//期间年

    String sqlstr = "";

	//取数据
    if (fnabudgetinfoid != null && !"".equals(fnabudgetinfoid)) {
        sqlstr = " select budgetperiods,budgetorganizationid,organizationtype,revision,status,budgetstatus from FnaBudgetInfo where id = " + fnabudgetinfoid;
        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            budgetperiods = RecordSet.getString("budgetperiods");
            organizationid = RecordSet.getString("budgetorganizationid");
            organizationtype = RecordSet.getString("organizationtype");
        } else {
            canImport = false;
        }
    } else {//如果期间为空,则不允许修改
        canImport = false;
    }

	//检查权限
	int right = 0;
	if("0".equals(organizationtype) && FnaBudgetLeftRuleSet.isAllowCmpEdit(user.getUID())){
		right = 1;
	}else if("1".equals(organizationtype)){
		List<String> allowOrgIdEdit_list = new ArrayList<String>();
		boolean allowOrgIdEdit = FnaBudgetLeftRuleSet.getAllowSubCmpIdEdit(user.getUID(), allowOrgIdEdit_list);
		if(allowOrgIdEdit || allowOrgIdEdit_list.contains(organizationid)){
			right = 1;
		}
	}else if("2".equals(organizationtype)){
		List<String> allowOrgIdEdit_list = new ArrayList<String>();
		boolean allowOrgIdEdit = FnaBudgetLeftRuleSet.getAllowDepIdEdit(user.getUID(), allowOrgIdEdit_list);
		if(allowOrgIdEdit || allowOrgIdEdit_list.contains(organizationid)){
			right = 1;
		}
	}else if("3".equals(organizationtype)){
		List<String> __orgId_list = new ArrayList<String>();
		__orgId_list.add(organizationid);
		List<String> allowOrgIdEdit_list = new ArrayList<String>();
		boolean allowOrgIdEdit = FnaBudgetLeftRuleSet.getAllowHrmIdEdit(user.getUID(), null, null, __orgId_list, allowOrgIdEdit_list);
		if(allowOrgIdEdit || allowOrgIdEdit_list.contains(organizationid)){
			right = 1;
		}
	}else if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){
		List<String> allowOrgIdEdit_list = new ArrayList<String>();
		boolean allowOrgIdEdit = FnaBudgetLeftRuleSet.getAllowFccIdEdit(user.getUID(), allowOrgIdEdit_list);
		if(allowOrgIdEdit || allowOrgIdEdit_list.contains(organizationid)){
			right = 1;
		}
	}

    if (right < 1) canImport = false;//不可编辑

    if (!canImport) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }

	//取当前期间的年份
    if ("".equals(budgetyears)) {
        sqlstr = " select fnayear from FnaYearsPeriods where id = " + budgetperiods;
        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            budgetyears = RecordSet.getString("fnayear");
        }
    }
	
    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(386, user.getLanguage());
    String needfav = "1";
    String needhelp = "";
    
    
    if(operation.equals("")){
		response.sendRedirect("FnaBudgetImport.jsp?msgid="+msgid+"&operation=upload&fnabudgetinfoid="+fnabudgetinfoid+"&row="+rowid+"&tab="+tabid+"&openPanter="+openPanter+"&keyWord2="+keyWord2);
		return;
    }
%>

<%@page import="weaver.fna.general.FnaSynchronized"%><HTML><HEAD>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	
	<script language="javascript" src="/js/weaver_wev8.js"></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(25649,user.getLanguage())+",javascript:onNext(this),_TOP} ";//开始导入
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
    String fnatitle = SystemEnv.getHtmlLabelName(20209,user.getLanguage())+"：";
    if ("0".equals(organizationtype))
        fnatitle += (Util.toScreen(CompanyComInfo.getCompanyname(organizationid), user.getLanguage()));
    if ("1".equals(organizationtype))
        fnatitle += (Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid), user.getLanguage()));
    if ("2".equals(organizationtype))
        fnatitle += (Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid), user.getLanguage()));
    if ("3".equals(organizationtype))
        fnatitle += (Util.toScreen(ResourceComInfo.getResourcename(organizationid), user.getLanguage()));
    if ((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){
    	rs.executeSql("select name from FnaCostCenter where id = "+Util.getIntValue(organizationid));
    	if(rs.next()){
    		fnatitle += (Util.toScreen(Util.null2String(rs.getString("name")).trim(), user.getLanguage()));
    	}
    }
    fnatitle += " "+budgetyears;
    fnatitle += SystemEnv.getHtmlLabelName(15375, user.getLanguage());
%>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=fnatitle %>"/>
</jsp:include>

<span id="errormsg" style="color:red;display: block;"></span>

<FORM id="frmMain" name="frmMain" action="/fna/budget/FnaBudgetImport.jsp" enctype="multipart/form-data" method=post>
<input type="hidden" name="operation" value="import">
<INPUT name="fnabudgetinfoid" type="hidden" value="<%=fnabudgetinfoid%>">
<INPUT name="openPanter" type="hidden" value="<%=openPanter%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    		<input class="e8_btn_top" type="button" id="btnSave" onclick="onNext(this);" 
    			value="<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>"/><!-- 开始导入 -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<span style="font-weight: bold;display: block;width: 100%;text-align: center;"></span>
<span style="display: block;width: 100%;text-align: center;">
<%
if("-987654321".equals(msgid)){
	String _errorInfo = Util.null2String((String)request.getSession().getAttribute(msgid+"_errorInfo"));
	request.getSession().removeAttribute(msgid+"_errorInfo");
	msgid = "";
%>
	<br>
    <%=_errorInfo %>
<%
}else{
	if(!msgid.equals("")){ 
%>
		<br>
		<font color=red><%=SystemEnv.getHtmlLabelName(Util.getIntValue(msgid),user.getLanguage())%>(Sheet<%=tabid%><%=SystemEnv.getHtmlLabelName(18620,user.getLanguage())%><%=rowid%>)</font>
<%
	} 
}
%>
</span>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20209, user.getLanguage())+SystemEnv.getHtmlLabelName(87, user.getLanguage())%>' ><!-- 预算导入 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(16455, user.getLanguage())%></wea:item><!-- 组织机构 -->
		<wea:item>
	        <%
	            if ("0".equals(organizationtype))
	                out.print(FnaCommon.escapeHtml(CompanyComInfo.getCompanyname(organizationid))
	                        + "<b>(" + SystemEnv.getHtmlLabelName(140, user.getLanguage()) + ")</b>");
	            if ("1".equals(organizationtype))
	                out.print(FnaCommon.escapeHtml(SubCompanyComInfo.getSubCompanyname(organizationid))
	                        + "<b>(" + SystemEnv.getHtmlLabelName(24049, user.getLanguage()) + ")</b>");
	            if ("2".equals(organizationtype))
	                out.print(FnaCommon.escapeHtml(DepartmentComInfo.getDepartmentname(organizationid))
	                        + "<b>(" + SystemEnv.getHtmlLabelName(124, user.getLanguage()) + ")</b>");
	            if ("3".equals(organizationtype))
	                out.print(FnaCommon.escapeHtml(ResourceComInfo.getResourcename(organizationid))
	                        + "<b>(" + SystemEnv.getHtmlLabelName(1867, user.getLanguage()) + ")</b>");
	            if ((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){
	            	rs.executeSql("select name from FnaCostCenter where id = "+Util.getIntValue(organizationid));
	            	if(rs.next()){
	            		out.print(FnaCommon.escapeHtml(Util.null2String(rs.getString("name")).trim())
		                        + "<b>(" + SystemEnv.getHtmlLabelName(515, user.getLanguage()) + ")</b>");
	            	}
	                
	            }
	        %>
	        <input type="hidden" name="organizationid" value="<%=organizationid%>">
	        <input type="hidden" name="organizationtype" value="<%=organizationtype%>">
       	</wea:item>
       	
		<wea:item><%=SystemEnv.getHtmlLabelName(15365, user.getLanguage())%></wea:item><!-- 预算年度 -->
		<wea:item>
			<%=budgetyears%>
        	<input type="hidden" name="budgetperiods" value="<%=budgetperiods%>">
		</wea:item>
       	
		<wea:item><%=SystemEnv.getHtmlLabelNames("585,24638", user.getLanguage())%></wea:item><!-- 科目重复验证字段 -->
		<wea:item>
            <select class="inputstyle" id="keyWord2" name="keyWord2" style="width: 80px;">
              <option value="-1" <%=keyWord2==-1?"selected=\"selected\"":"" %>>ID</option>
              <option value="1" <%=keyWord2==1?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(1321,user.getLanguage())%></option><!-- 编码 -->
            </select>
			<%=SystemEnv.getHtmlLabelName(24646,user.getLanguage())%><!-- 重复验证字段用于判断记录在excel和数据库中是唯一的 -->
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(18577, user.getLanguage())%></wea:item><!-- Excel文件导入 -->
		<wea:item>
			<input id="showSrcFilename" type="text" readonly="readonly" _noMultiLang="true" /><input type="button" value="<%=SystemEnv.getHtmlLabelName(125333, user.getLanguage())%>" onclick="jQuery('#filename').click();"/><!-- 选择文件 -->
        	<input class="InputStyle" type="file" size="50" name="filename" id="filename" style="display: none;" onchange="jQuery('#showSrcFilename').val(this.value);"/>
		</wea:item>
       	
		<wea:item><%=SystemEnv.getHtmlLabelName(19971, user.getLanguage())%></wea:item><!-- 模板文件 -->
		<wea:item>
			<a href="#" onclick="onDown()"><font color="blue"><%=SystemEnv.getHtmlLabelName(28576,user.getLanguage())+"_"+revisionName%></font></a><!-- 下载模板 -->
			<%=SystemEnv.getHtmlLabelName(20211,user.getLanguage())%><!-- 请下载模板文件，填入数据后导入! -->
		</wea:item>
	</wea:group>
</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 关闭 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
</FORM>

<iframe id="dwnfrm" name="dwnfrm" src="" style="display:none"></iframe>
<script language=javascript>
//关闭
function doClose(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}

function onBtnSearchClick(){}

var oPopup = window.createPopup();

function showWait(content){
    var iX = document.body.offsetWidth/2-50;
	var iY = document.body.offsetHeight/2+document.body.scrollTop-50; 
	var oPopBody = oPopup.document.body;
    oPopBody.style.border = "1px solid #8888AA";
    oPopBody.style.backgroundColor = "white";
    oPopBody.style.position = "absolute";
    oPopBody.style.padding = "5px";
    oPopBody.style.zindex = 150;
    oPopBody.innerHTML = content;
    oPopup.show(iX, iY, 170, 25, document.body);
    var dialogScript = 'window.setTimeout(' + ' function () { window.close(); }, '+1+');';
    var result = window.showModalDialog('javascript:document.writeln(' + '"<script>' + dialogScript + '<' + '/script>")'); 
}

function hideWait(){
	oPopup.hide();
}

function onNext(obj) {
	var _filename = jQuery("#filename").val();
	if(_filename==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30213,user.getLanguage())%>");
		return;
	}
	
    document.frmMain.action = "/fna/budget/FnaBudgetImport.jsp";
    document.frmMain.operation.value = "import";
    document.frmMain.submit();
    obj.disabled=true;
}

function onDown(){
	var keyWord2 = jQuery("#keyWord2").val();
	document.getElementById("dwnfrm").src = "/fna/budget/FnaBudgetImportExp.jsp?fnabudgetinfoid=<%=fnabudgetinfoid %>&guid1=<%=guid1 %>&budgetperiods=<%=budgetperiods%>&keyWord2="+keyWord2;
}

function ResumeError() {
    return true;
}
window.onerror = ResumeError;

</script>

</BODY>
</HTML>
