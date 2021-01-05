
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="mySmartUpload" scope="page"class="com.jspsmart.upload.SmartUpload" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="p" class="weaver.album.PhotoComInfo" scope="page" />

<%@ page import='java.io.File'%>
<%@ page import='java.util.ArrayList'%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import='weaver.hrm.User'%>
<%@ page import='weaver.hrm.HrmUserVarify'%>
<%@ page import='weaver.album.PhotoSequence'%>
<%@ page import='weaver.image.Thumbnail'%>


<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

int intParentId = Util.getIntValue(request.getParameter("parentId"));
if(intParentId==-1){
	intParentId=1;
}
String parentId = String.valueOf(intParentId);

int userId = user.getUID();
int pId = 0;
String uploadImgIDs = "";
int uploadImgSizeSum = 0;

String picturePath = "";
rs.executeSql("SELECT picturePath FROM systemset");
if(rs.next()){
	picturePath = Util.null2String(rs.getString("picturePath"));
}

String physicalPath =GCONST.getRootPath()+ "album" + File.separatorChar + "UploadFolder";
String physicalPathThumbnail = physicalPath;//缩略图存放在/Album/UploadFolder/thumbnail下
if(!("".equals(picturePath))){//如果设置了路径，图片存放在指定目录下
	physicalPath = picturePath;
}

File saveDir = new File(physicalPath);
if(!(saveDir.exists())){
	saveDir.mkdir();
}


			//计算文件上传个数
			int count = 0;
			mySmartUpload.initialize(pageContext);

			//依据form的内容上传  
			mySmartUpload.upload("UTF-8");

			ArrayList imgArray = new ArrayList();

			//将上传的文件一个一个取出来处理  
			for (int i = 0; i < mySmartUpload.getFiles().getCount(); i++) {
				//取出一个文件  
				com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(i);

				//如果文件存在，则做存档操作  
				if (!myFile.isMissing()) {
					String fileName = myFile.getFileName();
					pId = PhotoSequence.getInstance().get(); 
					if(fileName.lastIndexOf("\\")!=-1){
						fileName = fileName.substring(fileName.lastIndexOf("\\")+1, fileName.length());
					}

					if(Util.isExcuteFile(fileName)) continue;

					String newFileName = String.valueOf(pId);
					//文件存放位置  
					myFile.saveAs(physicalPath + File.separator + newFileName,mySmartUpload.SAVE_PHYSICAL);
					
					String filesize = Util.round(String.valueOf(myFile.getSize()/1000), 1);
					if(filesize.equals("0")) filesize="1";

					//缩略图
					String[] param = {physicalPath+File.separator+newFileName, physicalPathThumbnail+File.separator+"thumbnail"+File.separator+newFileName, "96", "200", "100"};
					Thumbnail.create(param);

					String[] paramImg = {""+pId, fileName, filesize, newFileName, TimeUtil.getCurrentTimeString()};
					imgArray.add(paramImg);

					count++;
				}
			}

			String ancestorId = p.getAncestorId(parentId);

			String sql = "";
			int size = imgArray.size();
			for(int i=0;i<size;i++){
				String[] _imgArray = (String[])imgArray.get(i);
				sql = "INSERT INTO AlbumPhotos (id, parentId, isFolder, subFolderCount, photoName, photoSize, photoPath, photoDescription, thumbnailPath, userid, postdate, "+
						"subcompanyId,orderNum) VALUES ("+_imgArray[0]+", "+parentId+", '0', 0, '"+_imgArray[1]+"', "+_imgArray[2]+", '"+physicalPath+File.separator+_imgArray[3]+
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

<html>
	<body>
	</body>
</html>
