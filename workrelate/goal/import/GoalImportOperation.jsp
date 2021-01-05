<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page import="org.apache.poi.hssf.usermodel.*"%>
<%@ page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%
response.setHeader("cache-control", "no-cache"); 
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%String userid = user.getUID()+"";
if(cmutil.getGoalMaint(userid)[0]<2){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
	FileUpload fu = new FileUpload(request,false);
	 
	int fileid = 0 ;
	
	try {
	    fileid = Util.getIntValue(fu.uploadFiles("filename"),0);
	
	    String sql = "select filerealpath from imagefile where imagefileid = "+fileid;
	    RecordSet.executeSql(sql);
	    String uploadfilepath="";
	    if(RecordSet.next()) uploadfilepath =  Util.null2String(RecordSet.getString("filerealpath"));
	
	    /**
	 	if(!uploadfilepath.equals("")){
	        Excelfilepath = GCONST.getRootPath()+"workrelate/goal/import/ExcelToDB"+File.separatorChar+filename ;
			//System.out.println("Excelfilepath＝"+Excelfilepath);
	        fm.copy(uploadfilepath,Excelfilepath);
	    }
	    */
		
		boolean result = this.ExcelToDB(uploadfilepath,user.getUID()+"",request);
	    staticobj.removeObject("GM_GOALSHOW");
		response.sendRedirect("GoalImport.jsp");
	}
	catch(Exception e) {
	
	}
%>
<%!

/**
 * 私有方法，获取Excel表格对应表格中的数据
 * 
 * @param cell
 *            Excel表格的行
 * @param row
 *            Excel表格的列
 * @return Excel表格对应表格中的数据
 */
private String getCellValue(HSSFCell cell, HSSFRow row) {
	//this.setCellValue("");
	if(cell==null) return "";
	String cellValue = "";
	switch (cell.getCellType()) {
	case HSSFCell.CELL_TYPE_NUMERIC:
		if (HSSFDateUtil.isCellDateFormatted(cell)) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			//cellValue = (DateFormat.getDateInstance().format((cell.getDateCellValue()))).toString();
			cellValue = (sdf.format((cell.getDateCellValue()))).toString();
		} else {
			//cellValue = String.valueOf(cell.getNumericCellValue());
			cellValue = String.valueOf((long)cell.getNumericCellValue());//
			//cellValue = String.format("%1$-9d", cell.getNumericCellValue());
		}

		break;
	case HSSFCell.CELL_TYPE_STRING:
		cellValue = cell.getStringCellValue();
		break;
	case HSSFCell.CELL_TYPE_FORMULA:
		cellValue = (DateFormat.getDateInstance().format((cell
				.getDateCellValue()))).toString();

		break;
	default:

		break;
	}
	return Util.null2String(cellValue.trim());
}

/**
 * 检查excel项是否为空
 * @param row
 * @return
 */
private boolean checkIsNull(HSSFRow row,StringBuffer errormsg){
	if(row == null){
		return false;
	}
	boolean b = true;
	//检查第1-6列
	int col = 6;
	for(int i=0;i<col;i++){
		if(i!=1){
			HSSFCell cell = row.getCell((short) i);
			if (cell == null || cell.getCellType() == 3) {
				errormsg.append("第"+String.valueOf(row.getRowNum() + 1)+"行必要信息不完整;<br>");
				b = false;
				return b;
			}
		}
	}
	return b;
}
/**
 * 检测字符串是否是指定日期格式
 * @param str 待检测的字符串
 * @param datePattern 指定日期格式
 * @return
 */
public boolean checkDate(String str,String datePattern) {
	if(datePattern == null || "".equals(datePattern)){
		return false;
	}
	SimpleDateFormat sdf = new SimpleDateFormat(datePattern);
	sdf.setLenient(false);
	try {
		if (str.equals(sdf.format(sdf.parse(str)))) {
			return true;
		} else {
			return false;
		}
	} catch (ParseException e) {
		return false;
	}
}
/**
 * 检测字符串是否是指定格式
 * @param str 待检测的字符串
 * @param rex 正则表达式
 * @return
 */
public static boolean check(String str, String rex) {
	if(rex == null || "".equals(rex)){
		return false;
	}
	Pattern pattern = Pattern.compile(rex);
	Matcher isNum = pattern.matcher(str); 
	if (!isNum.matches()) {
		return false;
	}
	return true;
}
/**
 * 将Excel表格中的数据导入数据库
 * 
 * @param FileName
 *            Excel表格的路径及文件名
 */
public boolean ExcelToDB(String FileName,String userid,HttpServletRequest request) {
	StringBuffer errormsg = new StringBuffer();
	String sql = "";
	int total = 0;//导入总数
	int success = 0;//成功个数
	int fail = 0;//失败个数
	try {
		FileInputStream finput = new FileInputStream(FileName);
		POIFSFileSystem fs = new POIFSFileSystem(finput);
		HSSFWorkbook workbook = new HSSFWorkbook(fs);
		HSSFSheet sheet = workbook.getSheetAt(0);

		finput.close();
		HSSFRow row = null;
		
		Map uidmap = new HashMap();
		RecordSet rs = new RecordSet();
		
		String uid = "";
		String puid = "";
		String parentid = "";
		String name = "";
		String cate = "";
		int period = 0;
		int periody = 0;
		int periodm = 0;
		int periods = 0;
		String enddate = "";
		String principalid = "";
		double target = 0;
		String tunit = "";
		double result = 0;
		String runit = "";
		double showorder = 0;
		
		int rowsNum = sheet.getLastRowNum();
		/**
		if(rowsNum-1 > maxNum){
			return false;
		}*/
		//System.out.println("rowNum:"+rowsNum);
		for (int i = 1; i < rowsNum + 1; i++) {
			total++;
			row = sheet.getRow(i);
			if(this.checkIsNull(row,errormsg)){//此行必填项都已填写
			
				String createdate = TimeUtil.getCurrentDateString();
				String createtime = TimeUtil.getOnlyCurrentTimeString();
				
				//标识
				HSSFCell cell0 = row.getCell((short) 0);
				uid = this.getCellValue(cell0, row);
				
				//上级标识
				HSSFCell cell1 = row.getCell((short) 1);
				puid = "";
				parentid = this.getCellValue(cell1, row);
				if(!"".equals(parentid)) puid = Util.null2String((String)uidmap.get(parentid));
				if(!"".equals(puid)) parentid = puid;
				parentid = Util.getIntValue(parentid,0)+"";
				
				//目标名称
				HSSFCell cell2 = row.getCell((short) 2);
				name = this.getCellValue(cell2, row);
				
				HSSFCell cell13 = row.getCell((short) 13);
				name += this.getCellValue(cell13, row);
				
				//目标类型
				HSSFCell cell3 = row.getCell((short) 3);
				cate = this.getCellValue(cell3, row);
				
				//目标周期
				HSSFCell cell4 = row.getCell((short) 4);
				period = Util.getIntValue(this.getCellValue(cell4, row),3);
				
				//责任人
				HSSFCell cell5 = row.getCell((short) 5);
				principalid = this.getCellValue(cell5, row);
				
				//目标值
				HSSFCell cell6 = row.getCell((short) 6);
				target = Util.getDoubleValue(this.getCellValue(cell6, row),0);
				
				//目标值单位
				HSSFCell cell7 = row.getCell((short) 7);
				tunit = this.getCellValue(cell7, row);
				
				//完成值
				HSSFCell cell8 = row.getCell((short) 8);
				result = Util.getDoubleValue(this.getCellValue(cell8, row),0);
				
				//完成值单位
				HSSFCell cell9 = row.getCell((short) 9);
				runit = this.getCellValue(cell9, row);
				
				HSSFCell cell10 = row.getCell((short) 10);
				HSSFCell cell11 = row.getCell((short) 11);
				HSSFCell cell12 = row.getCell((short) 12);
				periody = Util.getIntValue(this.getCellValue(cell10, row),Integer.parseInt(TimeUtil.getCurrentDateString().substring(0,4)));
				periodm = Util.getIntValue(this.getCellValue(cell11, row),Integer.parseInt(TimeUtil.getCurrentDateString().substring(5,7)));
				periods = Util.getIntValue(this.getCellValue(cell12, row),Integer.parseInt(TimeUtil.getCurrentSeason()));
				if(period==1){
					//enddate = TimeUtil.getYearMonthEndDay(year,month);
				}else if(period==2){
					if(periods==1) periodm = 3;
					if(periods==2) periodm = 6;
					if(periods==3) periodm = 9;
					if(periods==4) periodm = 12;
				}else if(period==3){
					periodm = 12;
				}else if(period==4){
					periody = periody+2;
					periodm = 12;
				}else if(period==5){
					periody = periody+4;
					periodm = 12;
				}
				enddate = TimeUtil.getYearMonthEndDay(periody,periodm);
				
				//排序
				HSSFCell cell14 = row.getCell((short) 14);
				showorder = Util.getDoubleValue(this.getCellValue(cell14, row),0);
				
				if(name.equals("") || principalid.equals("")) continue;
				//保存主信息
				sql = "insert into GM_GoalInfo (name,status,creater,createdate,createtime,begindate,enddate,cate,principalid,parentid,period,target,tunit,result,runit,showorder) "
					+"values('"+name+"',1,"+userid+",'"+createdate+"','"+createtime+"','','"+enddate+"','"+cate+"',"+principalid+",'"+parentid+"','"+period+"',"+target+",'"+tunit+"',"+result+",'"+runit+"',"+showorder+")";
				//System.out.println("sql:"+sql);
				boolean insert = rs.executeSql(sql);
				if(insert){
					rs.executeSql("select max(id) from GM_GoalInfo");
					if(rs.next()){
						success++;
						String goalid = Util.null2String(rs.getString(1));
						uidmap.put(uid,goalid);
						
						//添加新建反馈
						String content = "导入";
						sql = "insert into GM_GoalFeedback (goalid,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime)"
							+" values("+goalid+",'"+content+"',"+userid+",'','','','','','','"+createdate+"','"+createtime+"')";
						rs.executeSql(sql);
						//记录日志
						sql = "insert into GM_GoalLog (goalid,type,operator,operatedate,operatetime,operatefiled,operatevalue)"
							+" values("+goalid+",1,"+userid+",'"+createdate+"','"+createtime+"','','')";
						rs.executeSql(sql);
						//判断下级任务则需要默认加入查看日志并更新所有上级任务的参与人
						if(!parentid.equals("")){
							sql = "insert into GM_GoalLog (goalid,type,operator,operatedate,operatetime,operatefiled,operatevalue)"
								+" values("+parentid+",0,"+userid+",'"+createdate+"','"+createtime+"','','')";
							rs.executeSql(sql);
							this.updateSupPartner(goalid);
						}
					}
				}
				
			}
				
		}
		return true;
	} catch (Exception e) {
		errormsg.append("导入失败:格式不正确;请确认导入文件中不要含有筛选公式等特殊数据类型！<br>"+e);
		return true;
	} finally{
		String msg = "目标导入完成!<br>";
		msg += "总计："+total+"个; 成功："+success+"个; 失败："+(total-success)+"个;";
		request.getSession().setAttribute("GOAL_IMPORT_INFO",msg+"<br><br>"+errormsg.toString());
	}
}
private void updateSupPartner(String goalid){
	RecordSet rs = new RecordSet();
	List hrmids = new ArrayList();
	String parentid = "";
	String parentPrincipalid = "";
	rs.executeSql("select principalid,parentid from GM_GoalInfo where parentid<>0 and parentid is not null and (deleted=0 or deleted is null) and id="+goalid);
	if(rs.next()){
		parentid = Util.null2String(rs.getString("parentid"));
		if(!parentid.equals("")){
			hrmids.add(Util.null2String(rs.getString("principalid")));
			rs.executeSql("select principalid from GM_GoalInfo where (deleted=0 or deleted is null) and id="+parentid);
			if(rs.next()){
				parentPrincipalid = Util.null2String(rs.getString("principalid"));
				String partnerid = "";
				rs.executeSql("select partnerid from GM_GoalPartner where goalid="+goalid);
				while(rs.next()){
					partnerid = Util.null2String(rs.getString("partnerid"));
					if(!partnerid.equals("") && !partnerid.equals(parentPrincipalid) && hrmids.indexOf(partnerid)<0){
						hrmids.add(partnerid);
					}
				}
				for(int i=0;i<hrmids.size();i++){
					partnerid = (String)hrmids.get(i);
					if(!partnerid.equals("")){
						rs.executeSql("delete from GM_GoalPartner where goalid="+parentid+" and partnerid="+partnerid);
						rs.executeSql("insert into GM_GoalPartner (goalid,partnerid) values('"+parentid+"','"+partnerid+"')");
					}
				}
				this.updateSupPartner(parentid);
			}
		}
	}
}
%>