<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="java.io.OutputStream"%>
<%@page import="weaver.matrix.MatrixUtil"%>
<%@page import="weaver.workflow.workflow.GetShowCondition"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCellStyle"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFFont"%>
<%@page import="org.apache.poi.hssf.util.HSSFColor"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MatrixManager" class="weaver.matrix.MatrixManager" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
//request.setCharacterEncoding("UTF-8");
String matrixid = Util.null2String(request.getParameter("matrixid"));
String method = Util.null2String(request.getParameter("method"));

//System.out.println("olduserid="+matrixid+"====newuserid="+method);
  
        //处理模板导出
  	try{
	   //查询在当前矩阵id下的所有字段
	    List<String> backfiledlist = new ArrayList<String>();
	    List<String> displaynamelist = new ArrayList<String>();
	    List<String> fieldType = new ArrayList<String>();
		String sql ="select *  from MatrixFieldInfo where matrixid="+matrixid+"  order by fieldtype asc, priority";
		RecordSet.execute(sql);
	    //获取当前表的所有字段，不包括id
        while(RecordSet.next()){
        	backfiledlist.add(RecordSet.getString("fieldname"));	
        	displaynamelist.add(RecordSet.getString("displayname"));
        	fieldType.add(RecordSet.getString("browsertypeid"));
        }
	    HSSFWorkbook wb = new HSSFWorkbook(); 
	    int sheetNum = 0;
	    if(!"exportDataNoSQ".equals(method)){
	        HSSFSheet sheet0 = wb.createSheet(""+SystemEnv.getHtmlLabelName(84453,user.getLanguage())); //TODO 84453 矩阵导入说明
	        sheet0.setColumnWidth((short)1, (short)(1000 * 256));  
	        wb.setSheetName(0,""+SystemEnv.getHtmlLabelName(84453,user.getLanguage()));
	        HSSFCell cell_;
	        //第一行
	        HSSFRow row0 = sheet0.createRow((int) 0); 
	        HSSFCellStyle style0 = wb.createCellStyle();  
	        style0.setAlignment(HSSFCellStyle.ALIGN_CENTER); 
	        HSSFCellStyle style_ = wb.createCellStyle();  
	        style_.setAlignment(HSSFCellStyle.ALIGN_LEFT); 
	        cell_ = row0.createCell((short) 0); 
	        //cell_.setEncoding(HSSFCell.ENCODING_UTF_16);
	        cell_.setCellValue(""+SystemEnv.getHtmlLabelName(15486,user.getLanguage()));  //序号
	        cell_.setCellStyle(style0); 
	        
	        cell_ = row0.createCell((short) 1);  
	        //cell_.setEncoding(HSSFCell.ENCODING_UTF_16);
	        cell_.setCellValue(""+SystemEnv.getHtmlLabelName(25734,user.getLanguage()));    //说明 
	        cell_.setCellStyle(style_); 
	      	//第二行
	        row0 = sheet0.createRow((int) 1);
	        cell_ = row0.createCell((short) 0); 
	        //cell_.setEncoding(HSSFCell.ENCODING_UTF_16);
	        cell_.setCellValue(1);  //序号
	        cell_.setCellStyle(style0); 
	        
	        cell_ = row0.createCell((short) 1);  
	        //cell_.setEncoding(HSSFCell.ENCODING_UTF_16);
	        cell_.setCellValue(""+SystemEnv.getHtmlLabelName(84454,user.getLanguage()));    //说明 
	        cell_.setCellStyle(style_); 
	      	//第三行
	        row0 = sheet0.createRow((int) 2);
	        cell_ = row0.createCell((short) 0); 
	        //cell_.setEncoding(HSSFCell.ENCODING_UTF_16);
	        cell_.setCellValue(2);  //序号
	        cell_.setCellStyle(style0); 
	        
	        cell_ = row0.createCell((short) 1);  
	        //cell_.setEncoding(HSSFCell.ENCODING_UTF_16);
	        cell_.setCellValue(""+SystemEnv.getHtmlLabelName(84455,user.getLanguage()));    //说明 
	        cell_.setCellStyle(style_); 
	      	//第四行
	        row0 = sheet0.createRow((int) 3);
	        cell_ = row0.createCell((short) 0); 
	        //cell_.setEncoding(HSSFCell.ENCODING_UTF_16);
	        cell_.setCellValue(3);  //序号
	        cell_.setCellStyle(style0); 
	        
	        cell_ = row0.createCell((short) 1);  
	        //cell_.setEncoding(HSSFCell.ENCODING_UTF_16);
	        cell_.setCellValue(""+SystemEnv.getHtmlLabelName(84456,user.getLanguage()));    //说明 
	        cell_.setCellStyle(style_); 
	      	//第五行
	        row0 = sheet0.createRow((int) 4);
	        cell_ = row0.createCell((short) 0); 
	        //cell_.setEncoding(HSSFCell.ENCODING_UTF_16);
	        cell_.setCellValue(4);  //序号
	        cell_.setCellStyle(style0); 
	        
	        cell_ = row0.createCell((short) 1);  
	        //cell_.setEncoding(HSSFCell.ENCODING_UTF_16);
	        cell_.setCellValue(""+SystemEnv.getHtmlLabelName(84457,user.getLanguage()));    //说明 
	        cell_.setCellStyle(style_); 
	      	//第六行
	        row0 = sheet0.createRow((int) 5);
	        cell_ = row0.createCell((short) 0); 
	        //cell_.setEncoding(HSSFCell.ENCODING_UTF_16);
	        cell_.setCellValue(5);  //序号
	        cell_.setCellStyle(style0); 
	        
	        cell_ = row0.createCell((short) 1);  
	        //cell_.setEncoding(HSSFCell.ENCODING_UTF_16);
	        cell_.setCellValue(""+SystemEnv.getHtmlLabelName(84458,user.getLanguage()));    //说明 
	        cell_.setCellStyle(style_);
	      	//第七行
	        row0 = sheet0.createRow((int) 6);
	        cell_ = row0.createCell((short) 0); 
	        //cell_.setEncoding(HSSFCell.ENCODING_UTF_16);
	        cell_.setCellValue(6);  //序号
	        cell_.setCellStyle(style0); 
	        
	        cell_ = row0.createCell((short) 1);  
	        //cell_.setEncoding(HSSFCell.ENCODING_UTF_16);
	        cell_.setCellValue(""+SystemEnv.getHtmlLabelName(84580,user.getLanguage()));    //说明 
	        cell_.setCellStyle(style_);
	        
	        sheetNum++;
	    }
	        HSSFSheet sheet = wb.createSheet(""+SystemEnv.getHtmlLabelName(84452,user.getLanguage()));  //TODO 84452 矩阵导入模板
	        sheet.setDefaultColumnWidth( (short)15);
	        wb.setSheetName(sheetNum,""+SystemEnv.getHtmlLabelName(84452,user.getLanguage()));
	        HSSFRow row = sheet.createRow((int) 0);  
	        HSSFCellStyle style = wb.createCellStyle();  
	        style.setAlignment(HSSFCellStyle.ALIGN_CENTER); 
	        HSSFCellStyle style1 = wb.createCellStyle(); 
	        HSSFFont font = wb.createFont();
	        font.setColor(HSSFColor.GREY_50_PERCENT.index);
	        style1.setFont(font);
	        HSSFCell cell;
	        int cellNum = 0;
	        if("exportData".equals(method)){
		        cell = row.createCell((short) 0);  
		        //cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		        cell.setCellValue("UUID("+SystemEnv.getHtmlLabelName(129277, user.getLanguage())+")");  
		        cell.setCellStyle(style1); 
		        cellNum++;
	        }
	        HSSFCellStyle style2 = wb.createCellStyle(); 
	        HSSFFont font2 = wb.createFont();
	        font2.setColor(HSSFColor.ORANGE.index);
	        font2.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
	        style2.setFont(font2);
	        style2.setAlignment(HSSFCellStyle.ALIGN_CENTER); 
	        for (int i = cellNum; i < displaynamelist.size()+cellNum; i++)  
	        {  
	        	cell = row.createCell((short) (i));  
		        //cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		        cell.setCellValue(displaynamelist.get("exportData".equals(method)?i-1:i));  
		        cell.setCellStyle(style2);  
	        }
	        if("exportData".equals(method)||"exportDataNoSQ".equals(method)){
	        	Map<String, Map<String, String>>  fieldinfos=MatrixUtil.getFieldDetail(matrixid);
	        	//根据id值获取具体的名称
	        	GetShowCondition conditions=new GetShowCondition();
	        	String dbType = RecordSet1.getDBType();
	        	String dataorder = "dataorder";
	        	if("oracle".equalsIgnoreCase(dbType)){
	        		dataorder = "dataorder-1";
	        	}else if("sqlserver".equalsIgnoreCase(dbType)){
	        		dataorder = "cast(dataorder as float)";
	        	}
	        	sql ="select *  from "+MatrixUtil.MATRIXPREFIX+matrixid +"  order by "+dataorder;
	        	RecordSet1.execute(sql);
	        	int rowNum =1;
	        	while(RecordSet1.next())
	        	{  
		        	row = sheet.createRow((int) rowNum);
	        		if(!"exportDataNoSQ".equals(method)){
		        		cell = row.createCell((short) 0);  
	      			  	cell.setCellValue(RecordSet1.getString("UUID"));  
	    		        cell.setCellStyle(style1);
	        		}
	        		  //添加列值
	        		  for(int i=0;i<backfiledlist.size();i++){
	        			  String filedValue = RecordSet1.getString(backfiledlist.get(i));
	        			  String showName = "";
	        			  if(!"".equals(filedValue)){
	        				  if("exportDataNoSQ".equals(method)){
	        					  showName = MatrixUtil.getSpanValueByIds(fieldinfos.get(backfiledlist.get(i).toLowerCase()),conditions,filedValue);
	        					  if("162".equals(fieldType.get(i))||"17".equals(fieldType.get(i))){ //自定义多选
			        				  showName = showName.replace(",",";");
			        			  }
	        				  }else{
			        			  if("1".equals(fieldType.get(i))||"17".equals(fieldType.get(i))){//人员
			        				  showName =MatrixManager.getResource(filedValue);
			        			  }else if("164".equals(fieldType.get(i))){ // 分部类型
			        				  showName =MatrixManager.getSubcompany(filedValue);
			        			  }else if("4".equals(fieldType.get(i))){ // 部门类型
			        				  showName =MatrixManager.getDepartment(filedValue);
			        			  }else if("24".equals(fieldType.get(i))){ // 岗位类型
			        				  showName =MatrixManager.getJobTitleName(filedValue);
			        			  }else{
				        			  showName = MatrixUtil.getSpanValueByIds(fieldinfos.get(backfiledlist.get(i)),conditions,filedValue);
			        			  }
			        			  if("162".equals(fieldType.get(i))){ //自定义多选
			        				  showName = showName.replace(",",";");
			        			  }
	        				  }
	        			  }
	        			  cell = row.createCell((short) (i+sheetNum));  
	        			  //cell.setEncoding(HSSFCell.ENCODING_UTF_16);
	        			  cell.setCellValue(showName);  
	      		          cell.setCellStyle(style);
	        		  }
	        		  rowNum++;
	        	}
	        	
	        	
	        }
	        String name = "";
	        RecordSet1.executeSql("select issystem,name from MatrixInfo where id =" +matrixid);
	        if(RecordSet1.next()){
	        	name = RecordSet1.getString("name");
	        }
	        name += SystemEnv.getHtmlLabelName(84477,user.getLanguage());
	        name = new String(name.getBytes(),"ISO8859-1");
	        OutputStream os = response.getOutputStream();// 取得输出流   
	        response.reset();// 清空输出流   
	        response.setHeader("Content-disposition", "attachment; filename="+name+".xls");// 设定输出文件头   
	        response.setContentType("application/msexcel;charset=utf-8");// 定义输出类型 
	        response.setCharacterEncoding("utf-8");
	        wb.write(os);
	        os.close(); 
		return;
  	}catch(Exception e){
  		
  	}
%>