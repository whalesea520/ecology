<%@ page language='java' %>
<%@ page import='java.io.*,java.util.*,javax.servlet.*,javax.servlet.http.*,javax.servlet.http.HttpServletRequest'%>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="weaver.album.PhotoSequence,weaver.image.Thumbnail,weaver.general.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="p" class="weaver.album.PhotoComInfo" scope="page" />

<%
int userId = user.getUID();
int pId = 0;
String uploadImgIDs = "";
int uploadImgSizeSum = 0;

String picturePath = "";
rs.executeSql("SELECT picturePath FROM systemset");
if(rs.next()){
	picturePath = Util.null2String(rs.getString("picturePath"));
}

String physicalPath = request.getRealPath("UploadFolder");
String physicalPathThumbnail = physicalPath;//缩略图存放在/Album/UploadFolder/thumbnail下
if(!("".equals(picturePath))){//如果设置了路径，图片存放在指定目录下
	physicalPath = picturePath;
}

File saveDir = new File(physicalPath);
if(!(saveDir.exists())){
	saveDir.mkdir();
}

/*
//创建日志文件
File LogFile = new File (physicalPath + "/UploadLogFileLog.txt");
LogFile.createNewFile();
FileWriter LogFileWrite = new FileWriter(LogFile);
LogFileWrite.write("Upload Begin...");
*/

//开始接收上传数据
DiskFileUpload fu = new DiskFileUpload();

//1G
//设置运行客户端POST上来的数据最大大小
//这个值不能设太小，否则如果上传的文件过大会抛出上传异常的错误
fu.setSizeMax(1000000000);
//内存缓存最大大小0.5M
fu.setSizeThreshold(500000);
//临时文件保存路径
fu.setRepositoryPath(physicalPath);

//开始接收数据
List listFileItems = fu.parseRequest(request);
//将表单域的值放在map中，从而提高读取field的效率
Hashtable fieldItems = new Hashtable();

ArrayList imgArray = new ArrayList();

for(int i=0;i<listFileItems.size();i++){
	FileItem sourceFile = (FileItem)(listFileItems.get(i));
	if(!sourceFile.isFormField()){
		pId = PhotoSequence.getInstance().get();

		String fileName = new File(sourceFile.getName()).getName();

		if(fileName.lastIndexOf("\\")!=-1){
			fileName = fileName.substring(fileName.lastIndexOf("\\")+1, fileName.length());
		}
		
		if(Util.isExcuteFile(fileName)) continue;

		String newFileName = String.valueOf(pId);

		File file = new File(physicalPath + File.separator + newFileName);
		sourceFile.write(file);

		String filesize = Util.round(String.valueOf(file.length()/1000), 1);
		if(filesize.equals("0")) filesize="1";
		uploadImgSizeSum += Util.getIntValue(filesize);

		//缩略图
		String[] param = {physicalPath+File.separator+newFileName, physicalPathThumbnail+File.separator+"thumbnail"+File.separator+newFileName, "96", "200", "100"};
		Thumbnail.create(param);

		String[] paramImg = {""+pId, fileName, filesize, newFileName, TimeUtil.getCurrentTimeString()};
		imgArray.add(paramImg);
	}else{
		//表单域值，放到map中
		fieldItems.put(sourceFile.getFieldName(), sourceFile);
	}
}

if(uploadImgIDs.endsWith(",")){
	uploadImgIDs = uploadImgIDs.substring(0, uploadImgIDs.length()-1);
}


//=========================================================================================================
FileItem Field1FileItem = (FileItem)fieldItems.get("parentId");
String parentId = Field1FileItem.getString();
String ancestorId = p.getAncestorId(parentId);

String sql = "";
int size = imgArray.size();
for(int i=0;i<size;i++){
	String[] _imgArray = (String[])imgArray.get(i);
	sql = "INSERT INTO AlbumPhotos (id, parentId, isFolder, subFolderCount, photoName, photoSize, photoPath, photoDescription, thumbnailPath, userid, postdate,"+
			" subcompanyId,orderNum) VALUES ("+_imgArray[0]+", "+parentId+", '0', 0, '"+_imgArray[1]+"', "+_imgArray[2]+", '"+physicalPath+File.separator+_imgArray[3]+
					"', '', '"+File.separator+"album"+File.separator+"UploadFolder"+File.separator+"thumbnail"+File.separator+_imgArray[3]+"', "+userId+
					", '"+_imgArray[4]+"', "+ancestorId+",-1)";
	rs.executeSql(sql);

	p.addPhotoInfoCache(_imgArray[0]);
}

//sqlserver使用触发器
if(rs.getDBType().equals("oracle")){
	p.updateCountAndSize(ancestorId, parentId);
}

p.updatePhotoInfoCache(parentId);
%>