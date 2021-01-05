<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFFont"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCellStyle"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>

<%@page import="weaver.proj.util.PrjFieldComInfo"%>
<%@page import="weaver.proj.util.PrjTskFieldComInfo"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFFont"%>
<%@page import="org.apache.poi.hssf.util.HSSFColor"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCellStyle"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLDecoder.*"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.file.FileManage"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalExcelToDB" class="weaver.proj.util.PrjImpUtil" scope="page" />

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
User user=HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}

FileUpload fu = new FileUpload(request,false,false);
FileManage fm = new FileManage();
int isdata=Util.getIntValue(fu.getParameter("isdata"));
int isuse =Util.getIntValue(fu.getParameter("isuse"));
String isdialog=Util.null2String(fu.getParameter("isdialog"));
String generateTemplateFile= Util.null2String( fu.getParameter("generateTemplateFile"));

if("2".equals(generateTemplateFile)){
	JSONObject json=new JSONObject();
	json.put("result", "success");
	String filepath=request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")));
	String prjtypeid=Util.null2String(request.getParameter("prjtype"),"-1");
	String prjtypename = "";
	RecordSet.executeSql("select id,fullname from Prj_ProjectType where id='"+prjtypeid+"'");
	if(RecordSet.next()) {
		prjtypename=Util.null2String(RecordSet.getString("fullname"));
	}
	String filename="";
	String outfilename="";
	String redirect_url="";
	int startcell=0;
	if(isdata==1 && (isuse==0 || isuse == 1) ){
		filename=filepath +"/prjimp_xls.xls";
		outfilename=filepath +"/prjimp_xlsnew.xls";
		redirect_url="prjimptab.jsp?isFromTab=1&isGeneratedTemplateFile=1&isdialog="+isdialog;
		startcell=13;
	}else if(isdata==1 && isuse==2 ){
		filename=filepath +"/prjimp_xls1.xls";
		outfilename=filepath +"/prjimp_xlsnew1.xls";
		redirect_url="prjimptab.jsp?isFromTab=1&isGeneratedTemplateFile=1&isdialog="+isdialog;
		startcell=14;
	}
	
	//添加自定义字段到导入模板
	POIFSFileSystem fs = null;
	FileInputStream finput =null;
	FileOutputStream fout =null;
	try{
		File file = new File(filename);
		File outfile=new File(outfilename);
		if(outfile.exists()){
			outfile.deleteOnExit();
		}
		if(file.exists()){
			finput = new FileInputStream(filename);
			fs = new POIFSFileSystem(finput);
			fout = new FileOutputStream(outfile);
			HSSFWorkbook workbook = new HSSFWorkbook(fs);
			HSSFSheet sheet = workbook.getSheetAt(0);
			finput.close();
			HSSFRow row= sheet.getRow(0);
			
	
			
			//必填样式
			HSSFCellStyle ismandStyle = workbook.createCellStyle();
			HSSFFont ismandfont = workbook.createFont();
			ismandfont.setColor(HSSFFont.COLOR_RED);
			ismandfont.setFontName("宋体");
			ismandfont.setFontHeightInPoints((short)12);
			ismandStyle.setFont(ismandfont);
			ismandStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER );
			ismandStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			
			HSSFRow row1= null;
			HSSFCell cell1 =null;
			
			if(isdata==1){
				if(!"-1".equals(prjtypeid)){
					row1= sheet.getRow(1);
					cell1=row1.getCell((short)2);
					cell1.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell1.setCellValue(prjtypename);
					
					row1= sheet.getRow(2);
					cell1=row1.getCell((short)2);
					cell1.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell1.setCellValue(prjtypename);
					
					row1= sheet.getRow(3);
					cell1=row1.getCell((short)2);
					cell1.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell1.setCellValue(prjtypename);
				}
			}
			
			//cusfield
			TreeMap<String,JSONObject> openfieldMap = new PrjFieldComInfo().getOpenFieldMapByPrjtype(prjtypeid);
			TreeMap<String,JSONObject> opencusfieldMap = new PrjFieldComInfo().getOpencusFieldMapByPrjtype(prjtypeid);
			int i=startcell;
			if(openfieldMap!=null&&!openfieldMap.isEmpty()){
				Iterator it=openfieldMap.entrySet().iterator();
				while(it.hasNext()){
					Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
					String k= entry.getKey();
					JSONObject v= entry.getValue();
					int fieldhtmltype=v.getInt("fieldhtmltype");
					
					if(v.getInt("fieldhtmltype")==6||v.getInt("fieldhtmltype")==7){//附件上传和特殊字段没有导入
						continue;
					}
					HSSFCell cell=null;
					if(row.getCell((short)i)==null){
						cell= row.createCell((short)i);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(SystemEnv.getHtmlLabelName(v.getInt("fieldlabel"),user.getLanguage()));
						
					}else{
						cell=row.getCell((short)i);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(SystemEnv.getHtmlLabelName(v.getInt("fieldlabel"),user.getLanguage()));
					}
					if(v.getInt("ismand")==1){
						cell.setCellStyle(ismandStyle);
					}
					
					i++;
				}
			}
			if(opencusfieldMap!=null&&!opencusfieldMap.isEmpty()){
				Iterator it=opencusfieldMap.entrySet().iterator();
				while(it.hasNext()){
					Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
					String k= entry.getKey();
					JSONObject v= entry.getValue();
					int fieldhtmltype=v.getInt("fieldhtmltype");
					
					if(v.getInt("fieldhtmltype")==6||v.getInt("fieldhtmltype")==7){//附件上传和特殊字段没有导入
						continue;
					}
					HSSFCell cell=null;
					if(row.getCell((short)i)==null){
						cell= row.createCell((short)i);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(SystemEnv.getHtmlLabelName(v.getInt("fieldlabel"),user.getLanguage()));
						
					}else{
						cell=row.getCell((short)i);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellValue(SystemEnv.getHtmlLabelName(v.getInt("fieldlabel"),user.getLanguage()));
					}
					if(v.getInt("ismand")==1){
						cell.setCellStyle(ismandStyle);
					}
					
					i++;
				}
			}
			workbook.write(fout);
			fout.flush();
			fout.close();
		}
	}catch(Exception e){
		e.printStackTrace();
		RecordSet.writeLog(e.getMessage());
		json.put("result", "failure");
	}finally{
		try{
			if(fout!=null){
				fout.close();
			}
			if(finput!=null){
				finput.close();
			}
		}catch(Exception e2){
			e2.printStackTrace();
			json.put("result", "failure");
		}
	}
	out.print(json.toString());
}
%>
