
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.general.FnaLanguage"%><%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%><%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%><%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%><%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%><%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%><%@page import="java.io.FileInputStream"%><%@page import="weaver.file.FileManage"%><%@page import="weaver.file.FileUpload"%><%@page import="java.lang.Exception"%><%@page import="weaver.systeminfo.SystemEnv"%><%@page import="weaver.fna.budget.FnaBudgetUtil"%><%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%><%@page import="weaver.fna.budget.BudgetHandler"%><%@page import="weaver.fna.maintenance.FnaBudgetControl"%><%@page import="weaver.hrm.company.CompanyComInfo"%><%@page import="weaver.hrm.company.SubCompanyComInfo"%><%@page import="weaver.hrm.company.DepartmentComInfo"%><%@page import="weaver.hrm.resource.ResourceComInfo"%><%@page import="weaver.conn.RecordSet"%><%@page import="org.apache.commons.lang.StringEscapeUtils"%><%@page import="java.text.DecimalFormat"%><%@ page import="weaver.fna.maintenance.FnaBudgetInfo" %><%@page import="java.text.SimpleDateFormat"%><%@page import="weaver.general.BaseBean"%><%@page import="weaver.general.TimeUtil"%><%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%@ page import="java.util.*,java.sql.Timestamp" %><%@ page import="weaver.general.GCONST" %><%@page import="weaver.hrm.HrmUserVarify"%><%@page import="weaver.hrm.User"%>
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
%><%
BaseBean bb = new BaseBean();
String result = "";

DecimalFormat df = new DecimalFormat("##############################################");

User user = HrmUserVarify.getUser (request , response) ;


boolean canEdit = HrmUserVarify.checkUserRight("FnaLedgerAdd:Add",user) || HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit",user);
if(!canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

RecordSet rs = new RecordSet();

ResourceComInfo resourceComInfo = new ResourceComInfo();
DepartmentComInfo departmentComInfo = new DepartmentComInfo();
SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
CompanyComInfo companyComInfo = new CompanyComInfo();

String timestrformart = "yyyyMMddHHmmss" ;
SimpleDateFormat SDF = new SimpleDateFormat(timestrformart) ;
Calendar calendar = Calendar.getInstance() ;

String dateTime = SDF.format(calendar.getTime());

int _index = 0;

FileUpload fu = new FileUpload(request,false);
String operation = Util.null2String(fu.getParameter("operation")).trim();
String _guid1 = Util.null2String(fu.getParameter("_guid1")).trim();
int keyWord = Util.getIntValue(fu.getParameter("keyWord"), -1);
int impType = Util.getIntValue(fu.getParameter("impType"), -1);

request.getSession().removeAttribute("index:"+_guid1);
request.getSession().removeAttribute("isDone:"+_guid1);

request.getSession().setAttribute("index:"+_guid1, SystemEnv.getHtmlLabelName(34119,user.getLanguage()));//开始预备数据
request.getSession().setAttribute("isDone:"+_guid1, "");

if("import".equals(operation) && (keyWord==0 || keyWord==1) && (impType==0 || impType==1)){
    List<String> errStrList = new ArrayList<String>();
   	String errStr = "";

	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
			Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
			Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	int currentMM = today.get(Calendar.MONTH) + 1;
   	
	RecordSet rs1 = new RecordSet();
	RecordSet rs2 = new RecordSet();
	RecordSet rs3 = new RecordSet();
	
	String Excelfilepath = "";
	int fileid = Util.getIntValue(fu.uploadFiles("filename"),0);
	String filename = fileid+"_"+FnaCommon.getPrimaryKeyGuid1()+".xls";
	boolean dropTmpTb = false;
	String tmpFCC_tbName = "tmpFCC_"+fileid;
	String drop_tmpFCC_tbName = tmpFCC_tbName;
	FileInputStream finput1 = null;
   	try{
   		String sql = "select filerealpath, isaesencrypt, aescode from imagefile where imagefileid = "+fileid;
   		rs.executeSql(sql);
   		String uploadfilepath="";
   		String isaesencrypt = "";
   		String aescode = "";
   		if(rs.next()){
   			uploadfilepath = rs.getString("filerealpath");
   			isaesencrypt = Util.null2String(rs.getString("isaesencrypt"));
   			aescode = Util.null2String(rs.getString("aescode"));
   		}
   		
   		if(!uploadfilepath.equals("")) {
   			Excelfilepath = request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")))+"\\"+filename ;
   			//FileManage.copy(uploadfilepath,Excelfilepath);
   			FileManage.copy(uploadfilepath, Excelfilepath, isaesencrypt, aescode);
   		}
   		
		if(fileid>0 && filename!=null && !"".equals(filename) && Excelfilepath!=null && !"".equals(Excelfilepath)){
			finput1 = new FileInputStream(Excelfilepath);
			POIFSFileSystem fs1 = new POIFSFileSystem(finput1);
			HSSFWorkbook workbook1 = new HSSFWorkbook(fs1);
			
			HSSFSheet sheet1 = workbook1.getSheetAt(1);
			int rowsNum = sheet1.getLastRowNum();

			
			request.getSession().setAttribute("index:"+_guid1, "0/"+(rowsNum-1)+" "+SystemEnv.getHtmlLabelName(34119,user.getLanguage()));//开始读取数据
			request.getSession().setAttribute("isDone:"+_guid1, "");

			
			List keyList = new ArrayList();
			List mcList = new ArrayList();
			List bmList = new ArrayList();
			List sjlbmcList = new ArrayList();
			List sjlbbmList = new ArrayList();
			List lxList = new ArrayList();
			List ztList = new ArrayList();
			List msList = new ArrayList();

			int impRowCntFcc = 0;
			for(int i=1;i<rowsNum+1;i++) {
				HSSFRow row = sheet1.getRow(i);
				HSSFCell cell = null;

				cell = row.getCell((short)0);//名称
				String mc_val = Util.null2String(getCellValue(cell)).trim();

				cell = row.getCell((short)1);//编码
				String bm_val = Util.null2String(getCellValue(cell)).trim();

				cell = row.getCell((short)2);//上级类别名称
				String sjlbmc_val = Util.null2String(getCellValue(cell)).trim();

				cell = row.getCell((short)3);//上级类别编码
				String sjlbbm_val = Util.null2String(getCellValue(cell)).trim();

				cell = row.getCell((short)4);//类型
				String lx = Util.null2String(getCellValue(cell)).trim();

				cell = row.getCell((short)5);//状态
				String zt = Util.null2String(getCellValue(cell)).trim();

				cell = row.getCell((short)6);//描述
				String ms_val = Util.null2String(getCellValue(cell)).trim();
				
				
				if("".equals(mc_val)){
					String _str1 = SystemEnv.getHtmlLabelNames("195,18622",user.getLanguage())+"\r";//***不能为空
					if(!errStrList.contains(_str1)){
						errStrList.add(_str1);
						errStr += _str1;
					}
					continue;
				}
				
				if(keyWord == 1 && "".equals(bm_val)){
					String _str1 = mc_val+":"+SystemEnv.getHtmlLabelNames("1321,18622",user.getLanguage())+"\r";
					if(!errStrList.contains(_str1)){
						errStrList.add(_str1);
						errStr += _str1;
					}
					continue;
				}
				
				if(!"".equals(lx) && !FnaLanguage.getLeiBie(user.getLanguage()).equals(lx) && !FnaLanguage.getChengBenZhongXin(user.getLanguage()).equals(lx)){
					String _str1 = mc_val+":"+SystemEnv.getHtmlLabelNames("33234,166",user.getLanguage())+
						":"+FnaLanguage.getLeiBie(user.getLanguage())+";"+FnaLanguage.getChengBenZhongXin(user.getLanguage())+"\r";
					if(!errStrList.contains(_str1)){
						errStrList.add(_str1);
						errStr += _str1;
					}
					continue;
				}
				
				if("".equals(zt)){
					String _str1 = mc_val+":"+SystemEnv.getHtmlLabelNames("602,18622",user.getLanguage())+"\r";
					if(!errStrList.contains(_str1)){
						errStrList.add(_str1);
						errStr += _str1;
					}
					continue;
				}
				
				if(!"".equals(zt) && !FnaLanguage.getWeiFengCun(user.getLanguage()).equals(zt) && !FnaLanguage.getYiFengCun(user.getLanguage()).equals(zt)){
					String _str1 = mc_val+":"+SystemEnv.getHtmlLabelNames("602,166",user.getLanguage())+
						":"+FnaLanguage.getWeiFengCun(user.getLanguage())+";"+FnaLanguage.getYiFengCun(user.getLanguage())+"\r";
					if(!errStrList.contains(_str1)){
						errStrList.add(_str1);
						errStr += _str1;
					}
					continue;
				}
				
				if(impType == 0){//添加
					if("".equals(lx)){
						String _str1 = mc_val+":"+SystemEnv.getHtmlLabelNames("33234,18622",user.getLanguage())+"\r";
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
				
				}else{//更新
					//更新时不允许填写（上级类别名称、上级类别编码）
					if(!"".equals(sjlbmc_val) || !"".equals(sjlbbm_val)){
						String _str1 = mc_val+":"+SystemEnv.getHtmlLabelNames("84649",user.getLanguage())+"\r";
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}

					//更新时不允许填写类别
					if(!"".equals(lx)){
						String _str1 = mc_val+":"+SystemEnv.getHtmlLabelNames("84668",user.getLanguage())+"\r";
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
				
				}


				//mc_val //名称
				//bm_val //编码
				//sjlbmc_val //上级类别名称
				//sjlbbm_val //上级类别编码
				if(impType == 1){//更新
					if(keyWord == 0){//名称
						rs1.executeSql("SELECT count(*) cnt from FnaCostCenter a where a.name = '"+StringEscapeUtils.escapeSql(mc_val)+"'");
						if(rs1.next()){
							if(rs1.getInt("cnt") <= 0){
								String _str1 = mc_val+":"+SystemEnv.getHtmlLabelNames("195",user.getLanguage())+
										SystemEnv.getHtmlLabelNames("23084",user.getLanguage())+"\r";//名称不存在
								if(!errStrList.contains(_str1)){
									errStrList.add(_str1);
									errStr += _str1;
								}
								continue;
							}else if(rs1.getInt("cnt") > 1){// > 1 为了排除自己
								String _str1 = mc_val+":"+SystemEnv.getHtmlLabelNames("26603",user.getLanguage())+"\r";//名称重复
								if(!errStrList.contains(_str1)){
									errStrList.add(_str1);
									errStr += _str1;
								}
								continue;
							}
						}
					}

					if(!"".equals(bm_val)){
						rs1.executeSql("SELECT count(*) cnt from FnaCostCenter a where a.code = '"+StringEscapeUtils.escapeSql(bm_val)+"'");
						if(rs1.next()){
							if(keyWord == 1 && rs1.getInt("cnt") <= 0){
								String _str1 = bm_val+":"+SystemEnv.getHtmlLabelNames("1321",user.getLanguage())+
										SystemEnv.getHtmlLabelNames("23084",user.getLanguage())+"\r";//编码不存在
								if(!errStrList.contains(_str1)){
									errStrList.add(_str1);
									errStr += _str1;
								}
								continue;
							}else if(rs1.getInt("cnt") > 1){// > 1 为了排除自己
								String _str1 = bm_val+":"+SystemEnv.getHtmlLabelNames("1321",user.getLanguage())+
										SystemEnv.getHtmlLabelNames("18082",user.getLanguage())+"\r";//编码重复
								if(!errStrList.contains(_str1)){
									errStrList.add(_str1);
									errStr += _str1;
								}
								continue;
							}
						}
					}
				
				}
				
				String lx_val = "0";
				if(FnaLanguage.getChengBenZhongXin(user.getLanguage()).equals(lx)){
					lx_val = "1";
				}
				
				String zt_val = "0";
				if(FnaLanguage.getYiFengCun(user.getLanguage()).equals(zt)){
					zt_val = "1";
				}
				
				if(keyWord == 0){
					keyList.add(mc_val);
				}else{
					keyList.add(bm_val);
				}
				mcList.add(mc_val);
				bmList.add(bm_val);
				sjlbmcList.add(sjlbmc_val);
				sjlbbmList.add(sjlbbm_val);
				lxList.add(lx_val);
				ztList.add(zt_val);
				msList.add(ms_val);

				impRowCntFcc++;
				request.getSession().setAttribute("index:"+_guid1, i+"/"+(rowsNum-1)+" "+SystemEnv.getHtmlLabelName(34119,user.getLanguage()));//开始读取数据
			}
			
			String splitFlagStr = "bfa181e2-a7e2-4eackkcck2-8fd5-451742ac0c46bfa181e2-a7e2-4eackkcck2-8fd5-451742ac0c46ck";

			//处理 关联对象（分部）
			List<String> gldxFbList = new ArrayList<String>();
			//处理 关联对象（部门）
			List<String> gldxBmList = new ArrayList<String>();
			//处理 关联对象（人员）
			List<String> gldxRyList = new ArrayList<String>();
			//处理 关联对象（客户）
			List<String> gldxKhList = new ArrayList<String>();
			//处理 关联对象（项目）
			List<String> gldxXmList = new ArrayList<String>();

			if("".equals(errStr)){
				//处理 关联对象（分部）
				sheet1 = workbook1.getSheetAt(2);
				rowsNum = sheet1.getLastRowNum();
				int impRowCnt = 0;
				for(int i=1;i<rowsNum+1;i++) {
					HSSFRow row = sheet1.getRow(i);
					HSSFCell cell = null;

					cell = row.getCell((short)0);//成本中心名称
					String cbzxMc_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)1);//成本中心编码
					String cbzxBm_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)2);//分部名称
					String fbMc_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)3);//分部编码
					String fbBm_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)4);//分部ID
					String fbId_val = Util.null2String(getCellValue(cell)).trim();

					
					if("".equals(cbzxMc_val) && "".equals(cbzxBm_val)){
						String _str1 = SystemEnv.getHtmlLabelNames("24664,141",user.getLanguage())+"："+
								SystemEnv.getHtmlLabelName(84656,user.getLanguage())+"\r";//成本中心名称、编码至少填写一项
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
					
					if("".equals(fbMc_val)){
						String _str1 = SystemEnv.getHtmlLabelNames("24664,141",user.getLanguage())+"："+
								cbzxMc_val+"("+cbzxBm_val+")"+":"+SystemEnv.getHtmlLabelNames("1878,81909",user.getLanguage())+"\r";//分部名称（必填）
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
					
					if("".equals(fbMc_val) && "".equals(fbMc_val) && "".equals(fbId_val)){
						String _str1 = SystemEnv.getHtmlLabelNames("24664,141",user.getLanguage())+"："+
								cbzxMc_val+"("+cbzxBm_val+")"+":"+SystemEnv.getHtmlLabelName(84651,user.getLanguage())+"\r";//分部名称、编码、ID至少填写一项
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
					
					int fbId = 0;
					String sql1 = "SELECT count(*) cnt, min(id) id from HrmSubCompany a where 1=1 ";
					if(!"".equals(fbMc_val)){
						sql1 += " and subcompanyname = '"+StringEscapeUtils.escapeSql(fbMc_val)+"' ";
					}
					if(!"".equals(fbBm_val)){
						sql1 += " and subcompanycode = '"+StringEscapeUtils.escapeSql(fbBm_val)+"' ";
					}
					if(!"".equals(fbId_val)){
						sql1 += " and id = "+Util.getIntValue(fbId_val)+" ";
					}
					rs1.executeSql(sql1);
					if(rs1.next()){
						if(rs1.getInt("cnt") <= 0){
							String _str1 = SystemEnv.getHtmlLabelNames("24664,141",user.getLanguage())+"："+
									fbMc_val+"("+fbBm_val+")"+":"+SystemEnv.getHtmlLabelName(23084,user.getLanguage())+"\r";//不存在
							if(!errStrList.contains(_str1)){
								errStrList.add(_str1);
								errStr += _str1;
							}
							continue;
						}else if(rs1.getInt("cnt") > 1){// > 1 为了排除自己
							String _str1 = SystemEnv.getHtmlLabelNames("24664,141",user.getLanguage())+"："+
									fbMc_val+"("+fbBm_val+")"+":"+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"\r";//重复
							if(!errStrList.contains(_str1)){
								errStrList.add(_str1);
								errStr += _str1;
							}
							continue;
						}
						fbId = rs1.getInt("id");
					}
					
					gldxFbList.add(cbzxMc_val+splitFlagStr+cbzxBm_val+splitFlagStr+fbId+splitFlagStr+"splitEndFlag");

					impRowCnt++;
					request.getSession().setAttribute("index:"+_guid1, i+"/"+(rowsNum-1)+" "+SystemEnv.getHtmlLabelNames("34119,24664,141",user.getLanguage()));//开始读取数据关联对象分部
				}
				

				//处理 关联对象（部门）
				sheet1 = workbook1.getSheetAt(3);
				rowsNum = sheet1.getLastRowNum();
				impRowCnt = 0;
				for(int i=1;i<rowsNum+1;i++) {
					HSSFRow row = sheet1.getRow(i);
					HSSFCell cell = null;

					cell = row.getCell((short)0);//成本中心名称
					String cbzxMc_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)1);//成本中心编码
					String cbzxBm_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)2);//部门名称
					String bmMc_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)3);//部门编码
					String bmBm_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)4);//部门ID
					String bmId_val = Util.null2String(getCellValue(cell)).trim();

					
					if("".equals(cbzxMc_val) && "".equals(cbzxBm_val)){
						String _str1 = SystemEnv.getHtmlLabelNames("24664,124",user.getLanguage())+"："+
								SystemEnv.getHtmlLabelName(84656,user.getLanguage())+"\r";//成本中心名称、编码至少填写一项
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
					
					if("".equals(bmMc_val)){
						String _str1 = SystemEnv.getHtmlLabelNames("24664,124",user.getLanguage())+"："+
								cbzxMc_val+"("+cbzxBm_val+")"+":"+SystemEnv.getHtmlLabelNames("15390,81909",user.getLanguage())+"\r";//部门名称（必填）
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
					
					if("".equals(bmMc_val) && "".equals(bmBm_val) && "".equals(bmId_val)){
						String _str1 = SystemEnv.getHtmlLabelNames("24664,124",user.getLanguage())+"："+
								cbzxMc_val+"("+cbzxBm_val+")"+":"+SystemEnv.getHtmlLabelName(84652,user.getLanguage())+"\r";//部门名称、编码、ID至少填写一项
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
					
					int bmId = 0;
					String sql1 = "SELECT count(*) cnt, min(id) id from HrmDepartment a where 1=1 ";
					if(!"".equals(bmMc_val)){
						sql1 += " and departmentname = '"+StringEscapeUtils.escapeSql(bmMc_val)+"' ";
					}
					if(!"".equals(bmBm_val)){
						sql1 += " and departmentcode = '"+StringEscapeUtils.escapeSql(bmBm_val)+"' ";
					}
					if(!"".equals(bmId_val)){
						sql1 += " and id = "+Util.getIntValue(bmId_val)+" ";
					}
					rs1.executeSql(sql1);
					if(rs1.next()){
						if(rs1.getInt("cnt") <= 0){
							String _str1 = SystemEnv.getHtmlLabelNames("24664,124",user.getLanguage())+"："+
									bmMc_val+"("+bmBm_val+")"+":"+SystemEnv.getHtmlLabelName(23084,user.getLanguage())+"\r";//不存在
							if(!errStrList.contains(_str1)){
								errStrList.add(_str1);
								errStr += _str1;
							}
							continue;
						}else if(rs1.getInt("cnt") > 1){// > 1 为了排除自己
							String _str1 = SystemEnv.getHtmlLabelNames("24664,124",user.getLanguage())+"："+
									bmMc_val+"("+bmBm_val+")"+":"+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"\r";//重复
							if(!errStrList.contains(_str1)){
								errStrList.add(_str1);
								errStr += _str1;
							}
							continue;
						}
						bmId = rs1.getInt("id");
					}
					
					gldxBmList.add(cbzxMc_val+splitFlagStr+cbzxBm_val+splitFlagStr+bmId+splitFlagStr+"splitEndFlag");

					impRowCnt++;
					request.getSession().setAttribute("index:"+_guid1, i+"/"+(rowsNum-1)+" "+SystemEnv.getHtmlLabelNames("34119,24664,124",user.getLanguage()));//开始读取数据关联对象部门
				}
				
				//处理 关联对象（人员）
				sheet1 = workbook1.getSheetAt(4);
				rowsNum = sheet1.getLastRowNum();
				impRowCnt = 0;
				for(int i=1;i<rowsNum+1;i++) {
					HSSFRow row = sheet1.getRow(i);
					HSSFCell cell = null;

					cell = row.getCell((short)0);//成本中心名称
					String cbzxMc_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)1);//成本中心编码
					String cbzxBm_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)2);//人员名称
					String ryMc_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)3);//人员编码
					String ryBm_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)4);//人员ID
					String ryId_val = Util.null2String(getCellValue(cell)).trim();

					
					if("".equals(cbzxMc_val) && "".equals(cbzxBm_val)){
						String _str1 = SystemEnv.getHtmlLabelNames("24664,1867",user.getLanguage())+"："+
								SystemEnv.getHtmlLabelName(84656,user.getLanguage())+"\r";//成本中心名称、编码至少填写一项
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
					
					if("".equals(ryMc_val)){
						String _str1 = SystemEnv.getHtmlLabelNames("24664,1867",user.getLanguage())+"："+
								cbzxMc_val+"("+cbzxBm_val+")"+":"+SystemEnv.getHtmlLabelNames("27622,81909",user.getLanguage())+"\r";//人员名称（必填）
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
					
					if("".equals(ryMc_val) && "".equals(ryBm_val) && "".equals(ryId_val)){
						String _str1 = SystemEnv.getHtmlLabelNames("24664,1867",user.getLanguage())+"："+
								cbzxMc_val+"("+cbzxBm_val+")"+":"+SystemEnv.getHtmlLabelName(84653,user.getLanguage())+"\r";//人员名称、编码、ID至少填写一项
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
					
					int ryId = 0;
					String sql1 = "SELECT count(*) cnt, min(id) id from HrmResource a where 1=1 ";
					if(!"".equals(ryMc_val)){
						sql1 += " and lastname = '"+StringEscapeUtils.escapeSql(ryMc_val)+"' ";
					}
					if(!"".equals(ryBm_val)){
						sql1 += " and workcode = '"+StringEscapeUtils.escapeSql(ryBm_val)+"' ";
					}
					if(!"".equals(ryId_val)){
						sql1 += " and id = "+Util.getIntValue(ryId_val)+" ";
					}
					rs1.executeSql(sql1);
					if(rs1.next()){
						if(rs1.getInt("cnt") <= 0){
							String _str1 = SystemEnv.getHtmlLabelNames("24664,1867",user.getLanguage())+"："+
									ryMc_val+"("+ryBm_val+")"+":"+SystemEnv.getHtmlLabelName(23084,user.getLanguage())+"\r";//不存在
							if(!errStrList.contains(_str1)){
								errStrList.add(_str1);
								errStr += _str1;
							}
							continue;
						}else if(rs1.getInt("cnt") > 1){// > 1 为了排除自己
							String _str1 = SystemEnv.getHtmlLabelNames("24664,1867",user.getLanguage())+"："+
									ryMc_val+"("+ryBm_val+")"+":"+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"\r";//重复
							if(!errStrList.contains(_str1)){
								errStrList.add(_str1);
								errStr += _str1;
							}
							continue;
						}
						ryId = rs1.getInt("id");
					}
					
					gldxRyList.add(cbzxMc_val+splitFlagStr+cbzxBm_val+splitFlagStr+ryId+splitFlagStr+"splitEndFlag");

					impRowCnt++;
					request.getSession().setAttribute("index:"+_guid1, i+"/"+(rowsNum-1)+" "+SystemEnv.getHtmlLabelNames("34119,24664,1867",user.getLanguage()));//开始读取数据关联对象人员
				}
				
				//处理 关联对象（客户）
				sheet1 = workbook1.getSheetAt(5);
				rowsNum = sheet1.getLastRowNum();
				impRowCnt = 0;
				for(int i=1;i<rowsNum+1;i++) {
					HSSFRow row = sheet1.getRow(i);
					HSSFCell cell = null;

					cell = row.getCell((short)0);//成本中心名称
					String cbzxMc_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)1);//成本中心编码
					String cbzxBm_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)2);//客户名称
					String khMc_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)3);//客户编码
					String khBm_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)4);//客户ID
					String khId_val = Util.null2String(getCellValue(cell)).trim();

					
					if("".equals(cbzxMc_val) && "".equals(cbzxBm_val)){
						String _str1 = SystemEnv.getHtmlLabelNames("24664,136",user.getLanguage())+"："+
								SystemEnv.getHtmlLabelName(84656,user.getLanguage())+"\r";//成本中心名称、编码至少填写一项
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
					
					if("".equals(khMc_val)){
						String _str1 = SystemEnv.getHtmlLabelNames("24664,136",user.getLanguage())+"："+
								cbzxMc_val+"("+cbzxBm_val+")"+":"+SystemEnv.getHtmlLabelNames("1268,81909",user.getLanguage())+"\r";//客户名称（必填）
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
					
					if("".equals(khMc_val) && "".equals(khBm_val) && "".equals(khId_val)){
						String _str1 = SystemEnv.getHtmlLabelNames("24664,136",user.getLanguage())+"："+
								cbzxMc_val+"("+cbzxBm_val+")"+":"+SystemEnv.getHtmlLabelName(84654,user.getLanguage())+"\r";//客户名称、编码、ID至少填写一项
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
					
					int khId = 0;
					String sql1 = "SELECT count(*) cnt, min(id) id from CRM_CUSTOMERINFO a where 1=1 ";
					if(!"".equals(khMc_val)){
						sql1 += " and NAME = '"+StringEscapeUtils.escapeSql(khMc_val)+"' ";
					}
					if(!"".equals(khBm_val)){
						sql1 += " and crmcode = '"+StringEscapeUtils.escapeSql(khBm_val)+"' ";
					}
					if(!"".equals(khId_val)){
						sql1 += " and id = "+Util.getIntValue(khId_val)+" ";
					}
					rs1.executeSql(sql1);
					if(rs1.next()){
						if(rs1.getInt("cnt") <= 0){
							String _str1 = SystemEnv.getHtmlLabelNames("24664,136",user.getLanguage())+"："+
									khMc_val+"("+khBm_val+")"+":"+SystemEnv.getHtmlLabelName(23084,user.getLanguage())+"\r";//不存在
							if(!errStrList.contains(_str1)){
								errStrList.add(_str1);
								errStr += _str1;
							}
							continue;
						}else if(rs1.getInt("cnt") > 1){// > 1 为了排除自己
							String _str1 = SystemEnv.getHtmlLabelNames("24664,136",user.getLanguage())+"："+
									khMc_val+"("+khBm_val+")"+":"+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"\r";//重复
							if(!errStrList.contains(_str1)){
								errStrList.add(_str1);
								errStr += _str1;
							}
							continue;
						}
						khId = rs1.getInt("id");
					}
					
					gldxKhList.add(cbzxMc_val+splitFlagStr+cbzxBm_val+splitFlagStr+khId+splitFlagStr+"splitEndFlag");

					impRowCnt++;
					request.getSession().setAttribute("index:"+_guid1, i+"/"+(rowsNum-1)+" "+SystemEnv.getHtmlLabelNames("34119,24664,136",user.getLanguage()));//开始读取数据关联对象客户
				}
				
				//处理 关联对象（项目）
				sheet1 = workbook1.getSheetAt(6);
				rowsNum = sheet1.getLastRowNum();
				impRowCnt = 0;
				for(int i=1;i<rowsNum+1;i++) {
					HSSFRow row = sheet1.getRow(i);
					HSSFCell cell = null;

					cell = row.getCell((short)0);//成本中心名称
					String cbzxMc_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)1);//成本中心编码
					String cbzxBm_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)2);//项目名称
					String xmMc_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)3);//项目编码
					String xmBm_val = Util.null2String(getCellValue(cell)).trim();

					cell = row.getCell((short)4);//项目Id
					String xmId_val = Util.null2String(getCellValue(cell)).trim();

					
					if("".equals(cbzxMc_val) && "".equals(cbzxBm_val)){
						String _str1 = SystemEnv.getHtmlLabelNames("24664,101",user.getLanguage())+"："+
								SystemEnv.getHtmlLabelName(84656,user.getLanguage())+"\r";//成本中心名称、编码至少填写一项
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
					
					if("".equals(xmMc_val)){
						String _str1 = SystemEnv.getHtmlLabelNames("24664,101",user.getLanguage())+"："+
								cbzxMc_val+"("+cbzxBm_val+")"+":"+SystemEnv.getHtmlLabelNames("1353,81909",user.getLanguage())+"\r";//项目名称（必填）
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
					
					if("".equals(xmMc_val) && "".equals(xmBm_val) && "".equals(xmId_val)){
						String _str1 = SystemEnv.getHtmlLabelNames("24664,101",user.getLanguage())+"："+
								cbzxMc_val+"("+cbzxBm_val+")"+":"+SystemEnv.getHtmlLabelName(84655,user.getLanguage())+"\r";//项目名称、编码、ID至少填写一项
						if(!errStrList.contains(_str1)){
							errStrList.add(_str1);
							errStr += _str1;
						}
						continue;
					}
					
					int xmId = 0;
					String sql1 = "SELECT count(*) cnt, min(id) id from Prj_ProjectInfo a where 1=1 ";
					if(!"".equals(xmMc_val)){
						sql1 += " and name = '"+StringEscapeUtils.escapeSql(xmMc_val)+"' ";
					}
					if(!"".equals(xmBm_val)){
						sql1 += " and procode = '"+StringEscapeUtils.escapeSql(xmBm_val)+"' ";
					}
					if(!"".equals(xmId_val)){
						sql1 += " and id = "+Util.getIntValue(xmId_val)+" ";
					}
					rs1.executeSql(sql1);
					if(rs1.next()){
						if(rs1.getInt("cnt") <= 0){
							String _str1 = SystemEnv.getHtmlLabelNames("24664,101",user.getLanguage())+"："+
									xmMc_val+"("+xmBm_val+")"+":"+SystemEnv.getHtmlLabelName(23084,user.getLanguage())+"\r";//不存在
							if(!errStrList.contains(_str1)){
								errStrList.add(_str1);
								errStr += _str1;
							}
							continue;
						}else if(rs1.getInt("cnt") > 1){// > 1 为了排除自己
							String _str1 = SystemEnv.getHtmlLabelNames("24664,101",user.getLanguage())+"："+
									xmMc_val+"("+xmBm_val+")"+":"+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"\r";//重复
							if(!errStrList.contains(_str1)){
								errStrList.add(_str1);
								errStr += _str1;
							}
							continue;
						}
						xmId = rs1.getInt("id");
					}
					
					gldxXmList.add(cbzxMc_val+splitFlagStr+cbzxBm_val+splitFlagStr+xmId+splitFlagStr+"splitEndFlag");

					impRowCnt++;
					request.getSession().setAttribute("index:"+_guid1, i+"/"+(rowsNum-1)+" "+SystemEnv.getHtmlLabelNames("34119,24664,101",user.getLanguage()));//开始读取数据关联对象项目
				}
				
			}

			
			if((impRowCntFcc==0 && "".equals(errStr)) 
					&& gldxFbList.size()==0 && gldxBmList.size()==0 && gldxRyList.size()==0 && gldxKhList.size()==0 && gldxXmList.size()==0){
				String _str1 = SystemEnv.getHtmlLabelNames("84660",user.getLanguage())+"\r";//导入数据不能为空
				if(!errStrList.contains(_str1)){
					errStrList.add(_str1);
					errStr += _str1;
				}
			}

			if("".equals(errStr)){
				String str1 = SystemEnv.getHtmlLabelName(34116,user.getLanguage());//开始预备数据
				for(int impIdx=0;impIdx<2;impIdx++){
					if(impIdx==1){
						if(!"".equals(errStr)){
							break;
						}
						tmpFCC_tbName = "FnaCostCenter";
						str1 = SystemEnv.getHtmlLabelName(34120,user.getLanguage());//开始导入数据
					}
					
					List dbIdList = new ArrayList();
					if("".equals(errStr)){
						int cnt1 = keyList.size();
						request.getSession().setAttribute("index:"+_guid1, 0+"/"+df.format(cnt1*2)+" "+str1);//开始预备数据
						if(impIdx==0){
							dropTmpTb = true;
							//创建临时表
							if("oracle".equalsIgnoreCase(rs1.getDBType())){
								rs1.executeSql("create table "+tmpFCC_tbName+" as Select * from FnaCostCenter");
							}else if("mysql".equalsIgnoreCase(rs1.getDBType())){
								rs1.executeSql("create table "+tmpFCC_tbName+" ( Select * from FnaCostCenter )");
							}else{
								rs1.executeSql("select * into "+tmpFCC_tbName+" from FnaCostCenter");
							}
						}
						for(int i=0;i<cnt1;i++) {
							String key_val = Util.null2String((String)keyList.get(i));
							String mc_val = Util.null2String((String)mcList.get(i));
							String bm_val = Util.null2String((String)bmList.get(i));
							String sjlbmc_val = Util.null2String((String)sjlbmcList.get(i));
							String sjlbbm_val = Util.null2String((String)sjlbbmList.get(i));
							String lx_val = Util.null2String((String)lxList.get(i));
							String zt_val = Util.null2String((String)ztList.get(i));
							String ms_val = Util.null2String((String)msList.get(i));
							
							if(impType == 0){//添加
								if(keyWord == 0){//名称
									rs1.executeSql("select count(*) cnt from "+tmpFCC_tbName+" where name='"+StringEscapeUtils.escapeSql(mc_val)+"'");
								}else{//编码
									rs1.executeSql("select count(*) cnt from "+tmpFCC_tbName+" where code='"+StringEscapeUtils.escapeSql(bm_val)+"'");
								}
								if(rs1.next() && rs1.getInt("cnt") > 0){
									String _str1 = mc_val+":"+SystemEnv.getHtmlLabelNames("18082",user.getLanguage())+"!\r";
									if(!errStrList.contains(_str1)){
										errStrList.add(_str1);
										errStr += _str1;
									}
									continue;
								}
								
							}else{//更新
								
							}
		
							String dbId = "";
							if(keyWord == 0){//名称
								rs1.executeSql("select id from "+tmpFCC_tbName+" where name='"+StringEscapeUtils.escapeSql(mc_val)+"'");
							}else{//编码
								rs1.executeSql("select id from "+tmpFCC_tbName+" where code='"+StringEscapeUtils.escapeSql(bm_val)+"'");
							}
							if(rs1.next()){
								dbId = rs1.getString("id");
							}
							
							if("".equals(dbId)){//执行插入sql
								if(impIdx==0 && "oracle".equalsIgnoreCase(rs1.getDBType())){
									rs1.execute("select max(id) maxId from "+tmpFCC_tbName);
									if(rs1.next()){
										dbId = (Util.getIntValue(rs1.getString("maxId"), 0)+1)+"";
									}
									rs1.executeSql("INSERT INTO "+tmpFCC_tbName+" \n" +
											"           (id, supfccid \n" +
											"           ,type \n" +
											"           ,name \n" +
											"           ,code \n" +
											"           ,archive \n" +
											"           ,description )\n" +
											"     VALUES\n" +
											"           ("+dbId+", null \n" +
											"           ,"+lx_val+" \n" +
											"           ,'"+StringEscapeUtils.escapeSql(mc_val)+"' \n" +
											"           ,'"+StringEscapeUtils.escapeSql(bm_val)+"' \n" +
											"           ,"+zt_val+" \n" +
											"           ,'"+StringEscapeUtils.escapeSql(ms_val)+"' )");
									
								}else{
									rs1.executeSql("INSERT INTO "+tmpFCC_tbName+" \n" +
											"           (supfccid \n" +
											"           ,type \n" +
											"           ,name \n" +
											"           ,code \n" +
											"           ,archive \n" +
											"           ,description )\n" +
											"     VALUES\n" +
											"           (null \n" +
											"           ,"+lx_val+" \n" +
											"           ,'"+StringEscapeUtils.escapeSql(mc_val)+"' \n" +
											"           ,'"+StringEscapeUtils.escapeSql(bm_val)+"' \n" +
											"           ,"+zt_val+" \n" +
											"           ,'"+StringEscapeUtils.escapeSql(ms_val)+"' )");
									
									if(keyWord == 0){//名称
										rs1.executeSql("select max(id) maxId from "+tmpFCC_tbName+" where name='"+StringEscapeUtils.escapeSql(mc_val)+"'");
									}else{//编码
										rs1.executeSql("select max(id) maxId from "+tmpFCC_tbName+" where code='"+StringEscapeUtils.escapeSql(bm_val)+"'");
									}
									if(rs1.next()){
										dbId = (Util.getIntValue(rs1.getString("maxId"), 0))+"";
									}
									
								}
								
							}else{//执行更新sql
								rs1.executeSql("update "+tmpFCC_tbName+" \n" +
										"       set name='"+StringEscapeUtils.escapeSql(mc_val)+"' \n" +
										"           ,code='"+StringEscapeUtils.escapeSql(bm_val)+"' \n" +
										"           ,archive="+zt_val+" \n" +
										"           ,description='"+StringEscapeUtils.escapeSql(ms_val)+"' \n" +
										"     where id = "+dbId+" ");
								
							}
							dbIdList.add(dbId);
							
			
							request.getSession().setAttribute("index:"+_guid1, (i+1)+"/"+df.format(cnt1*2)+" "+str1);//开始预备数据
						}
					}
		
		
					if("".equals(errStr)){
						int cnt1 = keyList.size();
						request.getSession().setAttribute("index:"+_guid1, (cnt1+0)+"/"+df.format(cnt1*2)+" "+str1);//开始预备数据
						for(int i=0;i<cnt1;i++) {
							String dbId_val = Util.null2String((String)dbIdList.get(i));
							String key_val = Util.null2String((String)keyList.get(i));
							String mc_val = Util.null2String((String)mcList.get(i));
							String bm_val = Util.null2String((String)bmList.get(i));
							String sjlbmc_val = Util.null2String((String)sjlbmcList.get(i));
							String sjlbbm_val = Util.null2String((String)sjlbbmList.get(i));
							String lx_val = Util.null2String((String)lxList.get(i));
							String zt_val = Util.null2String((String)ztList.get(i));
							String ms_val = Util.null2String((String)msList.get(i));
							

							if(impType == 0){//添加 
								if(keyWord == 0){//名称
									if(!"".equals(sjlbmc_val)){
										rs1.executeSql("SELECT count(*) cnt from "+tmpFCC_tbName+" a "+
											" where a.type = 0 and a.name = '"+StringEscapeUtils.escapeSql(sjlbmc_val)+"'");
										if(rs1.next()){
											if(rs1.getInt("cnt") <= 0){
												String _str1 = mc_val+":"+SystemEnv.getHtmlLabelNames("596,178",user.getLanguage())+
														SystemEnv.getHtmlLabelNames("195",user.getLanguage())+
														SystemEnv.getHtmlLabelNames("23084",user.getLanguage())+"\r";//上级类别名称不存在
												if(!errStrList.contains(_str1)){
													errStrList.add(_str1);
													errStr += _str1;
												}
												continue;
											}else if(rs1.getInt("cnt") > 1){
												String _str1 = mc_val+":"+SystemEnv.getHtmlLabelNames("596,178",user.getLanguage())+
														SystemEnv.getHtmlLabelNames("195",user.getLanguage())+
														SystemEnv.getHtmlLabelNames("18082",user.getLanguage())+"\r";//上级类别名称重复
												if(!errStrList.contains(_str1)){
													errStrList.add(_str1);
													errStr += _str1;
												}
												continue;
											}
										}
									}
								}

								if(!"".equals(sjlbbm_val)){
									rs1.executeSql("SELECT count(*) cnt from "+tmpFCC_tbName+" a "+
										" where a.type = 0 and a.code = '"+StringEscapeUtils.escapeSql(sjlbbm_val)+"'");
									if(rs1.next()){
										if(rs1.getInt("cnt") <= 0){
											String _str1 = mc_val+":"+SystemEnv.getHtmlLabelNames("596,178",user.getLanguage())+
													SystemEnv.getHtmlLabelNames("1321",user.getLanguage())+
													SystemEnv.getHtmlLabelNames("23084",user.getLanguage())+"\r";//上级类别编码不存在
											if(!errStrList.contains(_str1)){
												errStrList.add(_str1);
												errStr += _str1;
											}
											continue;
										}else if(rs1.getInt("cnt") > 1){
											String _str1 = mc_val+":"+SystemEnv.getHtmlLabelNames("596,178",user.getLanguage())+
													SystemEnv.getHtmlLabelNames("1321",user.getLanguage())+
													SystemEnv.getHtmlLabelNames("18082",user.getLanguage())+"\r";//上级类别编码重复
											if(!errStrList.contains(_str1)){
												errStrList.add(_str1);
												errStr += _str1;
											}
											continue;
										}
									}
								}
							
							}
							
							if(impIdx==0){
								if(keyWord == 0){//名称
									rs1.executeSql("select count(*) cnt from "+tmpFCC_tbName+" where name='"+StringEscapeUtils.escapeSql(mc_val)+"'");
									if(rs1.next() && rs1.getInt("cnt") > 1){
										String _str1 = mc_val+":"+SystemEnv.getHtmlLabelNames("18082",user.getLanguage())+" !!\r";
										if(!errStrList.contains(_str1)){
											errStrList.add(_str1);
											errStr += _str1;
										}
										continue;
									}
								}
							}

							if(!"".equals(bm_val)){
								rs1.executeSql("select count(*) cnt from "+tmpFCC_tbName+" where code='"+StringEscapeUtils.escapeSql(bm_val)+"'");
								if(rs1.next() && rs1.getInt("cnt") > 1){
									String _str1 = bm_val+":"+SystemEnv.getHtmlLabelNames("18082",user.getLanguage())+"!!\r";
									if(!errStrList.contains(_str1)){
										errStrList.add(_str1);
										errStr += _str1;
									}
									continue;
								}
							}
							

							if(impType == 0){//添加 （更新时不能调整上级）
								String supfccid = "0";
								if(keyWord == 0){//名称
									if(!"".equals(sjlbmc_val)){
										rs1.executeSql("select id from "+tmpFCC_tbName+" where name='"+StringEscapeUtils.escapeSql(sjlbmc_val)+"'");
										if(rs1.next()){
											supfccid = Util.null2String(rs1.getString("id"));
										}
									}
								}else{
									if(!"".equals(sjlbbm_val)){
										rs1.executeSql("select id from "+tmpFCC_tbName+" where code='"+StringEscapeUtils.escapeSql(sjlbbm_val)+"'");
										if(rs1.next()){
											supfccid = Util.null2String(rs1.getString("id"));
										}
									}
								}

								rs1.executeSql("update "+tmpFCC_tbName+" set supfccid = "+supfccid+" where id = "+dbId_val);
							}
							
		
							request.getSession().setAttribute("index:"+_guid1, (cnt1+i+1)+"/"+df.format(cnt1*2)+" "+str1);//开始预备数据
						}
					}
		
					if("".equals(errStr)){
						List<String> updatedCbzxId = new ArrayList<String>();//本次导入已经至少处理过一次的成本中心id

						List<List<String>> updateGldxObjList = new ArrayList<List<String>>();
						updateGldxObjList.add(gldxFbList);
						updateGldxObjList.add(gldxBmList);
						updateGldxObjList.add(gldxRyList);
						updateGldxObjList.add(gldxKhList);
						updateGldxObjList.add(gldxXmList);
						
						String[] gldxTypeArray = new String[]{"1", "2", "3", "4", "5"};
						String[] gldxTypeLanguageIdArray = new String[]{"141", "124", "1867", "136", "101"};
						
						int updateGldxObjListLen = updateGldxObjList.size();
						for(int ii=0;ii<updateGldxObjListLen;ii++){
							List<String> gldxObjList = updateGldxObjList.get(ii);
							String gldxType = gldxTypeArray[ii];
							
							//处理 关联对象（分部）
							String str2 = str1+"（"+SystemEnv.getHtmlLabelName(24664,user.getLanguage())+"："+
								SystemEnv.getHtmlLabelName(Util.getIntValue(gldxTypeLanguageIdArray[ii]),user.getLanguage())+"）";//开始预备数据关联对象
							int cnt1 = gldxObjList.size();
							for(int i=0;i<cnt1;i++) {
								String[] tmpStrArray = Util.null2String(gldxObjList.get(i)).trim().split(splitFlagStr);
								String cbzxMc = tmpStrArray[0];
								String cbzxBm = tmpStrArray[1];
								int objId = Util.getIntValue(tmpStrArray[2]);
								
								int cbzxId = 0;
								String sql1 = "SELECT count(*) cnt, min(id) id from "+tmpFCC_tbName+" a where 1=1 ";
								if(!"".equals(cbzxMc)){
									sql1 += " and name = '"+StringEscapeUtils.escapeSql(cbzxMc)+"' ";
								}
								if(!"".equals(cbzxBm)){
									sql1 += " and code = '"+StringEscapeUtils.escapeSql(cbzxBm)+"' ";
								}
								rs1.executeSql(sql1);
								if(rs1.next()){
									if(rs1.getInt("cnt") <= 0){
										String _str1 = cbzxMc+"("+cbzxBm+")"+":"+SystemEnv.getHtmlLabelName(23084,user.getLanguage())+"!\r";//不存在
										if(!errStrList.contains(_str1)){
											errStrList.add(_str1);
											errStr += _str1;
										}
										continue;
									}else if(rs1.getInt("cnt") > 1){// > 1 为了排除自己
										String _str1 = cbzxMc+"("+cbzxBm+")"+":"+SystemEnv.getHtmlLabelName(18082,user.getLanguage())+"!\r";//重复
										if(!errStrList.contains(_str1)){
											errStrList.add(_str1);
											errStr += _str1;
										}
										continue;
									}
									cbzxId = rs1.getInt("id");
								}
								
								if(impIdx==1){//正式导入
									if(impType == 0){//添加
									}else{//更新
										if(!updatedCbzxId.contains(cbzxId+"")){
											rs1.executeSql("delete from FnaCostCenterDtl where fccId = "+cbzxId);
										}
									}
									rs1.executeSql("select count(*) cnt from FnaCostCenterDtl where type="+gldxType+" and objId="+objId+" and fccId="+cbzxId);
									if(!(rs1.next() && rs1.getInt("cnt") > 0)){
										rs1.executeSql("insert into FnaCostCenterDtl (fccId, type, objId) values ("+cbzxId+", "+gldxType+", "+objId+")");
									}
									
									if(!updatedCbzxId.contains(cbzxId+"")){
										updatedCbzxId.add(cbzxId+"");
									}
								}
	
								request.getSession().setAttribute("index:"+_guid1, (cnt1+0)+"/"+df.format(cnt1)+" "+str2);
							}
						}
					}
						
				}
			}

		}else{
			String _str1 = SystemEnv.getHtmlLabelName(34117,user.getLanguage());//导入文件上传失败
			if(!errStrList.contains(_str1)){
				errStrList.add(_str1);
				errStr += _str1;
			}
		}
   	}catch(Exception ex1){
   		bb.writeLog(ex1);
		String _str1 = SystemEnv.getHtmlLabelName(34118,user.getLanguage())+":\r"+ex1.getMessage()+"\r";//解析导入文件出错
		if(!errStrList.contains(_str1)){
			errStrList.add(_str1);
			errStr += _str1;
		}
   	}finally{
   		try{
   			if(finput1!=null){
   				finput1.close();
   			}
   		}catch(Exception e){}
   		try{
   			BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();
   			budgetfeeTypeComInfo.removeBudgetfeeTypeCache();
   			
   			if(fileid>0 && filename!=null && !"".equals(filename) && Excelfilepath!=null && !"".equals(Excelfilepath)){
   				if(dropTmpTb){
   					rs1.executeSql("drop table "+drop_tmpFCC_tbName);
   				}
   				FileManage.DeleteFile(Excelfilepath);
   			}
   		}catch(Exception e){}
   	}
   	
   	if("".equals(errStr)){
   		result = "";//导入成功
   	}else{
   		result = errStr;
   	}
   	
   	
}else{
	result = SystemEnv.getHtmlLabelName(34115,user.getLanguage());//请正确提交数据
}
request.getSession().setAttribute("errorInfo:"+_guid1, result);
request.getSession().setAttribute("isDone:"+_guid1, "true");






































%><%=result %>