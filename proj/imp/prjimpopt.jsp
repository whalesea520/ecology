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
<%@ include file="/systeminfo/init_wev8.jsp" %>
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
FileUpload fu = new FileUpload(request,false,false);
FileManage fm = new FileManage();
int isdata=Util.getIntValue(fu.getParameter("isdata"));
int isuse =Util.getIntValue(fu.getParameter("isuse"));
String isdialog=Util.null2String(fu.getParameter("isdialog"));
String generateTemplateFile= Util.null2String( fu.getParameter("generateTemplateFile"));
String prjtypeid= Util.null2String(fu.getParameter("prjtype"));
String templetId= Util.null2String(fu.getParameter("templetId"));
if("1".equals(generateTemplateFile)){
	String filepath=request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")));
	String filename="";
	String outfilename="";
	String redirect_url="";
	int startcell=0;
	if(isdata==2){
		filename=filepath +"/prjtskimp_xls.xls";
		outfilename=filepath +"/prjtskimp_xlsnew.xls";
		redirect_url="prjtskimptab.jsp?isFromTab=1&isGeneratedTemplateFile=1&isdialog="+isdialog;
		startcell=10;
	}else if(isdata==1 && (isuse==0 || isuse == 1) ){
		filename=filepath +"/prjimp_xls.xls";
		outfilename=filepath +"/prjimp_xlsnew.xls";
		redirect_url="prjimptab.jsp?isFromTab=1&isGeneratedTemplateFile=1&isdialog="+isdialog+"&prjtypeid="+prjtypeid;
		startcell=13;
	}else if(isdata==1 && isuse==2 ){
		filename=filepath +"/prjimp_xls1.xls";
		outfilename=filepath +"/prjimp_xlsnew1.xls";
		redirect_url="prjimptab.jsp?isFromTab=1&isGeneratedTemplateFile=1&isdialog="+isdialog+"&prjtypeid="+prjtypeid;
		startcell=14;
	}else if(isdata==3){
		filename=filepath +"/prjtskTempletimp_xls.xls";
		outfilename=filepath +"/prjtskTempletimp_xlsnew.xls";
		redirect_url="prjtskTempletimp.jsp?isGeneratedTemplateFile=1&isdialog="+isdialog+"&templetId="+templetId;
		startcell=10;
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
			
			//cusfield
			TreeMap<String,JSONObject> openfieldMap=null;
			if(isdata==2){
				openfieldMap=new PrjTskFieldComInfo().getOpenFieldMap();
			}else if(isdata==3){
				openfieldMap=new PrjTskFieldComInfo().getOpenFieldMap();
			}else{
				openfieldMap=new PrjFieldComInfo().getOpenFieldMap();
			}
			if(!openfieldMap.isEmpty()){
			
				Iterator it=openfieldMap.entrySet().iterator();
				int i=startcell;
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
		//System.out.println("生成导入模板时异常!");
		RecordSet.writeLog(e.getMessage());
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
		}
	}
	
	
		
	response.sendRedirect(redirect_url);
	return;
}



String responsepage="prjimptab.jsp?isFromTab=1&isGeneratedTemplateFile=1&isdialog="+isdialog+"&prjtypeid="+prjtypeid;
if(isdata==2){
	responsepage="prjtskimptab.jsp?isFromTab=1&isGeneratedTemplateFile=1&isdialog="+isdialog;
}else if(isdata==3){
	responsepage = "prjtskTempletimp.jsp?isGeneratedTemplateFile=1&isdialog="+isdialog+"&templetId="+templetId;
}
 

String Excelfilepath="";
String auto = Util.null2String(fu.getParameter("auto"));
int fileid = 0 ;
try {
    fileid = Util.getIntValue(fu.uploadFiles("filename"),0);
    String filename = fu.getFileName();
    String sql = "select filerealpath from imagefile where imagefileid = "+fileid;
    RecordSet.executeSql(sql);
    String uploadfilepath="";
    if(RecordSet.next()) uploadfilepath =  RecordSet.getString("filerealpath");
 	if(!uploadfilepath.equals("")){
        Excelfilepath = GCONST.getRootPath()+"proj/ExcelToDB"+File.separatorChar+filename ;
        fm.copy(uploadfilepath,Excelfilepath);
	}

	String msg="";
	String msg1="";
	String msg2="";
	int msgsize=0;
	if(isdata==2){
		CapitalExcelToDB.setPrjid4task(Util.getIntValue(fu.getParameter("parentprj")));
	}else if(isdata==3){
		CapitalExcelToDB.setPrjid4task(Util.getIntValue(templetId));
	}
	CapitalExcelToDB.ExcelToDB(Excelfilepath, isdata, user, fu);
	
	String msgType= CapitalExcelToDB.getMsgType();//e1:模板不对或无法识别;e2:数据有误;ok:导入成功;e5:用户没有创建此类型项目的权限
	//System.out.println("msgType:"+msgType);
	
	msgsize=CapitalExcelToDB.getMsg1().size();
	
	
	if(msgsize==0){
	    msg="success";
	    response.sendRedirect(responsepage+"&msg="+msg+"&msgtype="+msgType);
	}else if("e2".equalsIgnoreCase(msgType) ||"e5".equalsIgnoreCase(msgType)||"e7".equalsIgnoreCase(msgType)){
	    for (int i = 0; i <msgsize; i++){
	    msg1=msg1+(String)CapitalExcelToDB.getMsg1().elementAt(i)+",";
	    msg2=msg2+(String)CapitalExcelToDB.getMsg2().elementAt(i)+",";
	    }
	    fm.DeleteFile(Excelfilepath);
		session.setAttribute("cptmsg1",msg1);
		session.setAttribute("cptmsg2",msg2);
	    response.sendRedirect(responsepage+"&msg="+msg+"&msgsize="+msgsize+"&msgtype="+msgType);
	}
}
catch(Exception e) {
	new BaseBean().writeLog(e.getMessage());
}
%>
