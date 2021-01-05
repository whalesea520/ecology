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
<jsp:useBean id="CapitalExcelToDB" class="weaver.cpt.ExcelToDB.CapitalExcelToDB" scope="page" />
<jsp:useBean id="CptFieldComInfo" class="weaver.cpt.util.CptFieldComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="CodeUtil" class="weaver.proj.util.CodeUtil" scope="page" />

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
User user=HrmUserVarify.getUser(request, response);
if(!HrmUserVarify.checkUserRight("Capital:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
if(user==null){
	return;
}
FileUpload fu = new FileUpload(request,false,false);
FileManage fm = new FileManage();
int isdata=Util.getIntValue(fu.getParameter("isdata"));
String autocode=Util.null2String(fu.getParameter("autocode"));
String cptdata1ids=Util.null2String(fu.getParameter("cptdata1ids"));//导入资产用,模板添加资产资料编号
String isdialog=Util.null2String(fu.getParameter("isdialog"));
String generateTemplateFile= Util.null2String(fu.getParameter("generateTemplateFile"));
String method=Util.null2String( request.getParameter("method"));
if("1".equals(generateTemplateFile)){
    //生成模板
	//String filepath=request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")));
	String filepath = GCONST.getRootPath()+"cpt"+File.separatorChar+"capital"+File.separatorChar;
	String filename="";
	String outfilename="";
	String redirect_url="";
	int startcell=0;
	if(isdata==2){
		filename=filepath +"CapitalExcelToDB1.xls";
		outfilename=filepath +"CapitalExcelToDB1new.xls";
		redirect_url="CapitalExcelToDB1.jsp?isFromTab=1&isGeneratedTemplateFile=1&isdialog="+isdialog;
		startcell=14+12+1;
	}else{
		filename=filepath +"CapitalExcelToDB.xls";
		outfilename=filepath +"CapitalExcelToDBnew.xls";
		redirect_url="CapitalExcelToDB.jsp?isFromTab=1&isGeneratedTemplateFile=1&isdialog="+isdialog;
		startcell=17+4;
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
			ismandfont.setFontName(SystemEnv.getHtmlLabelName(16190, user.getLanguage()));
			ismandfont.setFontHeightInPoints((short)12);
			ismandStyle.setFont(ismandfont);
			ismandStyle.setAlignment(HSSFCellStyle.ALIGN_JUSTIFY );
			ismandStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

            //普通样式
            HSSFCellStyle normalStyle = workbook.createCellStyle();
            HSSFFont normalfont = workbook.createFont();
            normalfont.setColor(HSSFFont.COLOR_NORMAL);
            normalfont.setFontName(SystemEnv.getHtmlLabelName(16190, user.getLanguage()));
            normalfont.setFontHeightInPoints((short)12);
            normalStyle.setFont(normalfont);
            normalStyle.setAlignment(HSSFCellStyle.ALIGN_JUSTIFY );
            normalStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);


            //sysfield
            HashMap<String,JSONObject> fieldInfo=CapitalExcelToDB.getFieldInfo();
            if(isdata==1){
                HSSFCell cell=null;

                //规格型号
                cell=row.getCell((short)3);
                if(fieldInfo.get("capitalspec").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //等级
                cell=row.getCell((short)4);
                if(fieldInfo.get("capitallevel").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //制造厂商
                cell=row.getCell((short)5);
                if(fieldInfo.get("manufacturer").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //参考价格
                cell=row.getCell((short)10);
                if(fieldInfo.get("startprice").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //供应商
                cell=row.getCell((short)11);
                if(fieldInfo.get("customerid").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //属性
                cell=row.getCell((short)12);
                if(fieldInfo.get("attribute").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //备注
                cell=row.getCell((short)13);
                if(fieldInfo.get("remark").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //折旧年限
                cell=row.getCell((short)15);
                if(fieldInfo.get("depreyear").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }

                //资产资料编号
                cell=row.getCell((short)17);
                if("2".equals( CodeUtil.getCptData1CodeUse())){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }

                //替代
                cell=row.getCell((short)18);
                if(fieldInfo.get("replacecapitalid").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //版本
                cell=row.getCell((short)19);
                if(fieldInfo.get("version").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //残值率
                cell=row.getCell((short)20);
                if(fieldInfo.get("deprerate").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }


            }else if(isdata==2){
                HSSFCell cell=null;

                //入库单价
                cell=row.getCell((short)2);
                if(fieldInfo.get("startprice").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }

                //存放地点
                cell=row.getCell((short)8);
                if(fieldInfo.get("location").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //资产状态
                cell=row.getCell((short)9);
                if(fieldInfo.get("stateid").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //入库日期
                cell=row.getCell((short)10);
                if(fieldInfo.get("stockindate").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //购置日期
                cell=row.getCell((short)11);
                if(fieldInfo.get("selectdate").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }

                //资产编号
                cell=row.getCell((short)12);
                if("2".equals( CodeUtil.getCptData2CodeUse ())){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }

                //供应商
                cell=row.getCell((short)13);
                if(fieldInfo.get("customerid").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //条形码
                cell=row.getCell((short)14);
                if(fieldInfo.get("barcode").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //财务编号
                cell=row.getCell((short)15);
                if(fieldInfo.get("fnamark").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //生效日
                cell=row.getCell((short)16);
                if(fieldInfo.get("startdate").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //生效至
                cell=row.getCell((short)17);
                if(fieldInfo.get("enddate").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //出厂日期
                cell=row.getCell((short)18);
                if(fieldInfo.get("manudate").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //替代
                cell=row.getCell((short)19);
                if(fieldInfo.get("replacecapitalid").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //版本
                cell=row.getCell((short)20);
                if(fieldInfo.get("version").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //账内或账外
                cell=row.getCell((short)21);
                if(fieldInfo.get("isinner").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //合同号
                cell=row.getCell((short)22);
                if(fieldInfo.get("contractno").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //发票号码
                cell=row.getCell((short)23);
                if(fieldInfo.get("invoice").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //领用日期
                cell=row.getCell((short)24);
                if(fieldInfo.get("deprestartdate").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //备注
                cell=row.getCell((short)25);
                if(fieldInfo.get("remark").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //规格型号
                cell=row.getCell((short)26);
                if(fieldInfo.get("capitalspec").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }

            }


			//cusfield
			TreeMap<String,JSONObject> openfieldMap= CptFieldComInfo.getOpenFieldMap();
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
}else if("regenTemplate".equals(method)){
    //添加资产资料编码在资产模板里
	JSONObject json=new JSONObject();
	json.put("result", "success");
	String cptids=Util.null2String( request.getParameter("cptids"));
	if(!"".equals(cptids)){
		//String filepath=request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")));
		String filepath = GCONST.getRootPath()+"cpt"+File.separatorChar+"capital"+File.separatorChar;
		String filename="";
		String outfilename="";
		filename=filepath +"CapitalExcelToDB1.xls";
		outfilename=filepath +"CapitalExcelToDB1new.xls";
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
				ismandfont.setFontName(SystemEnv.getHtmlLabelName(16190, user.getLanguage()));
				ismandfont.setFontHeightInPoints((short)12);
				ismandStyle.setFont(ismandfont);
				ismandStyle.setAlignment(HSSFCellStyle.ALIGN_JUSTIFY );
				ismandStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

				//普通样式
				HSSFCellStyle normalStyle = workbook.createCellStyle();
				HSSFFont normalfont = workbook.createFont();
				normalfont.setColor(HSSFFont.COLOR_NORMAL);
				normalfont.setFontName(SystemEnv.getHtmlLabelName(16190, user.getLanguage()));
				normalfont.setFontHeightInPoints((short)12);
				normalStyle.setFont(normalfont);
				normalStyle.setAlignment(HSSFCellStyle.ALIGN_JUSTIFY );
				normalStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);


				//sysfield
				HashMap<String,JSONObject> fieldInfo=CapitalExcelToDB.getFieldInfo();
				HSSFCell cell=null;

                //入库单价
                cell=row.getCell((short)2);
                if(fieldInfo.get("startprice").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }

                //存放地点
                cell=row.getCell((short)8);
                if(fieldInfo.get("location").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //资产状态
                cell=row.getCell((short)9);
                if(fieldInfo.get("stateid").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //入库日期
                cell=row.getCell((short)10);
                if(fieldInfo.get("stockindate").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //购置日期
                cell=row.getCell((short)11);
                if(fieldInfo.get("selectdate").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }

                //资产编号
                cell=row.getCell((short)12);
                if("2".equals( CodeUtil.getCptData2CodeUse ())){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }

                //供应商
                cell=row.getCell((short)13);
                if(fieldInfo.get("customerid").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //条形码
                cell=row.getCell((short)14);
                if(fieldInfo.get("barcode").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //财务编号
                cell=row.getCell((short)15);
                if(fieldInfo.get("fnamark").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //生效日
                cell=row.getCell((short)16);
                if(fieldInfo.get("startdate").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //生效至
                cell=row.getCell((short)17);
                if(fieldInfo.get("enddate").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //出厂日期
                cell=row.getCell((short)18);
                if(fieldInfo.get("manudate").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //替代
                cell=row.getCell((short)19);
                if(fieldInfo.get("replacecapitalid").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //版本
                cell=row.getCell((short)20);
                if(fieldInfo.get("version").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //账内或账外
                cell=row.getCell((short)21);
                if(fieldInfo.get("isinner").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //合同号
                cell=row.getCell((short)22);
                if(fieldInfo.get("contractno").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //发票号码
                cell=row.getCell((short)23);
                if(fieldInfo.get("invoice").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //领用日期
                cell=row.getCell((short)24);
                if(fieldInfo.get("deprestartdate").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //备注
                cell=row.getCell((short)25);
                if(fieldInfo.get("remark").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }
                //规格型号
                cell=row.getCell((short)26);
                if(fieldInfo.get("capitalspec").getBoolean("ismand")){
                    cell.setCellStyle(ismandStyle);
                }else{
                    cell.setCellStyle(normalStyle);
                }

				int startcell=14+12+1;
				//cusfield
				TreeMap<String,JSONObject> openfieldMap= CptFieldComInfo.getOpenFieldMap();
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
			
			
				//清掉残留行
				int rownum=sheet.getLastRowNum();
				for(int i=1;i<rownum+1;i++){
					sheet.removeRow(sheet.getRow(i));
				}
				
				String[]cptarr=Util.TokenizerString2( cptids,",");
				for(int i=0;i<cptarr.length;i++){
					row= sheet.createRow(i+1);
					cell=row.createCell((short)0);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell.setCellValue(CapitalComInfo.getMark(cptarr[i]) );
				}
				
				workbook.write(fout);
				fout.flush();
				fout.close();
			}else{
				json.put("result", "failure");
			}
		}catch(Exception e){
			e.printStackTrace();
			json.put("result", "failure");
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
				json.put("result", "failure");
			}
		}
		
		
	}
	
	
	
	out.print(json.toString());
}else{
    //导入资产或资产资料
	String responsepage="CapitalExcelToDB.jsp?isFromTab=1&isGeneratedTemplateFile=1&isdialog="+isdialog;
	if(isdata==2) responsepage="CapitalExcelToDB1.jsp?isFromTab=1&isGeneratedTemplateFile=1&isdialog="+isdialog;
	String Excelfilepath="";

	int fileid = 0 ;

	try {
	    fileid = Util.getIntValue(fu.uploadFiles("filename"),0);

	    String filename = fu.getFileName();


	    String sql = "select filerealpath from imagefile where imagefileid = "+fileid;
	    RecordSet.executeSql(sql);
	    String uploadfilepath="";
	    if(RecordSet.next()) uploadfilepath =  RecordSet.getString("filerealpath");


	 	if(!uploadfilepath.equals("")){

	        Excelfilepath = GCONST.getRootPath()+"cpt/ExcelToDB"+File.separatorChar+filename ;
	        fm.copy(uploadfilepath,Excelfilepath);
		}


	 
	 
	String msg="";
	String msg1="";
	String msg2="";
	String msg3="";
	int    msgsize=0;
    session.removeAttribute("cptexceltodb_totalCount");
    session.removeAttribute("cptexceltodb_successCount");
	CapitalExcelToDB.ExcelToDB(Excelfilepath,isdata,user.getUID(),user.getLanguage(),request.getRemoteAddr(),autocode);
	msgsize=CapitalExcelToDB.getMsg1().size();
    session.setAttribute("cptexceltodb_totalCount",""+ CapitalExcelToDB.getTotalCount());
    session.setAttribute("cptexceltodb_successCount", "" + CapitalExcelToDB.getSuccessCount());
	String msgType = CapitalExcelToDB.getMsgType();
	 
	
	if(msgsize==0){
	    msg="success";
	    response.sendRedirect(responsepage+"&msg="+msg+"&msgType="+msgType);
	}else{
	    for (int i = 0; i <msgsize; i++){
	    msg1=msg1+(String)CapitalExcelToDB.getMsg1().elementAt(i)+",";	    
	    msg2=msg2+(String)CapitalExcelToDB.getMsg2().elementAt(i)+",";	   
	    msg3=msg3+(String)CapitalExcelToDB.getMsg3().elementAt(i)+"-";   
	    }
	    fm.DeleteFile(Excelfilepath);
		session.setAttribute("cptmsg1",msg1);
		session.setAttribute("cptmsg2",msg2);
		session.setAttribute("cptmsg3",msg3);
		
	    response.sendRedirect(responsepage+"&msg="+msg+"&msgsize="+msgsize+"&msgType="+msgType);
	}
	}
	catch(Exception e) {
		new BaseBean().writeLog(e.getMessage());
		//System.out.println(e.getMessage());
	}
}
%>
