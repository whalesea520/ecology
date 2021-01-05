<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.axis.encoding.Base64" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="weaver.docs.networkdisk.tools.ImageFileUtil" %>
<%@ page import="java.util.Calendar" %>

<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	User user  = HrmUserVarify.getUser (request , response) ;
	
	byte[] decoded_localpath = Base64.decode(request.getParameter("downloadpath"));
	String localpath = new String(decoded_localpath, "utf8");
	
	String folderids = Util.null2String(request.getParameter("folderIds"));
    String fileids = Util.null2String(request.getParameter("fileids"));
    String clientguid = Util.null2String(request.getParameter("clientguid"));
    int isSystemDoc = Util.getIntValue(request.getParameter("isSystemDoc"),0);
	RecordSet rs = new RecordSet();
	List<Map<String,String>> result = new ArrayList<Map<String,String>>();
	Calendar today = Calendar.getInstance();
	String lastDate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
			+ Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
			+ Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	String lastTime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":"
			+ Util.add0(today.get(Calendar.MINUTE), 2) + ":" + Util.add0(today.get(Calendar.SECOND), 2);
	if(!folderids.isEmpty())
	{
		List<Map<String, String>> fileItems = ImageFileUtil.getAllFileByFolder(folderids,true);
	
		if(fileItems != null)
		{
			for(Map<String,String> itemMap : fileItems)
			{
				
			   if(itemMap != null)
				{
					// 创建 GUID 对象
					UUID uuid = UUID.randomUUID();
					// 得到对象产生的ID
					String downloadfileguid = uuid.toString();
					// 转换为大写
					downloadfileguid = downloadfileguid.toUpperCase();
			
					String sql = "insert into DownloadFileTemp(fileid,localpath,clientguid,userid,type,downloadfileguid) "
					+" values("+itemMap.get("fileid")+",'"+localpath+itemMap.get("filepath")+"','"+clientguid+"',"+user.getUID()+",0,'"+downloadfileguid+"')";
					
					rs.executeSql(sql);
					
					sql = "insert into NetworkfileLog (imagefileid,fileName,relativePath,fileSize,userid,\"uid\",lastDate,lastTime,opType,isDelete,downloadfileguid) "+
					"  select d.fileid,i.imagefilename,d.localpath,i.fileSize,d.userid,'"+clientguid+"' as \"uid\",'"+lastDate+"' as lastDate,'"+lastTime+"' as lastTime,2 as opType,-1 as isDelete ,'"+downloadfileguid+"' as downloadfileguid "+
					" from DownloadFileTemp d ,imagefile i where d.fileid = i.imagefileid and d.downloadfileguid = '"+downloadfileguid+"'";
					
					rs.executeSql(sql);
					
					
					sql = "select imagefilename,filesize from  imagefile where imagefileid = " + itemMap.get("fileid");
					
					rs.executeSql(sql);
					
					if(rs.next())
					{
						Map<String,String> item = new HashMap<String,String>();
						item.put("id",downloadfileguid);
						String imagefilename = rs.getString("imagefilename");
						item.put("filename",imagefilename);
						item.put("filesize",rs.getString("filesize"));
						item.put("filetype",imagefilename.substring(imagefilename.lastIndexOf(".")+1));
						item.put("localpath",localpath + itemMap.get("filepath"));
						item.put("type","0");
						item.put("uid",itemMap.get("fileid"));
						RecordSet rsLog = new RecordSet();
						String logsql = "select id from  NetworkfileLog where downloadfileguid = '" + downloadfileguid + "'";
						rsLog.executeSql(sql);
						 if(rsLog.next())
						{
							item.put("logid",rsLog.getString("id"));
						}
						result.add(item);
					}
					
				}
			}
		}
	}
	
	if(!fileids.isEmpty())
	{
	    String imagefileids = "";
	    if(isSystemDoc == 1){
	        rs.executeSql("select imagefileid from DocImageFile where docid in(" + fileids + ")");
	        while(rs.next()){
	            imagefileids += "," + rs.getString("imagefileid");
	        }
	        imagefileids = imagefileids.contains(",") ? imagefileids.substring(1) : imagefileids;
	    }else{
	        imagefileids = fileids;  
	    }
	    String[] fileidStrs = imagefileids.split(","); 
		for(String fileid : fileidStrs)
		{
		    if(!fileid.isEmpty())
		    {
				// 创建 GUID 对象
				UUID uuid = UUID.randomUUID();
				// 得到对象产生的ID
				String downloadfileguid = uuid.toString();
				// 转换为大写
				downloadfileguid = downloadfileguid.toUpperCase();
		
		        String sql = "insert into DownloadFileTemp(fileid,localpath,clientguid,userid,type,downloadfileguid,isSystemDoc) "
		        +" values("+fileid+",'"+localpath+"','"+clientguid+"',"+user.getUID()+",0,'"+downloadfileguid+"'," + isSystemDoc + ")";
		        rs.executeSql(sql);
				
				
				sql = "insert into NetworkfileLog (imagefileid,fileName,relativePath,fileSize,userid,\"uid\",lastDate,lastTime,opType,isDelete,downloadfileguid,isSystemDoc) "+
					"  select d.fileid,i.imagefilename,d.localpath,i.fileSize,d.userid,'"+clientguid+"' as \"uid\",'"+lastDate+"' as lastDate,'"+lastTime+"' as lastTime,2 as opType,-1 as isDelete ,'"+downloadfileguid+"' as downloadfileguid," + isSystemDoc + " as isSystemDoc "+
					" from DownloadFileTemp d ,imagefile i where d.fileid = i.imagefileid and d.downloadfileguid = '"+downloadfileguid+"'";
					
				 rs.executeSql(sql);
				
		        sql = "select imagefilename,filesize from  imagefile where imagefileid = " + fileid;
		        rs.executeSql(sql);
		        if(rs.next())
		        {
		            Map<String,String> item = new HashMap<String,String>();
			        item.put("id",downloadfileguid);
			        String imagefilename = rs.getString("imagefilename");
			        item.put("filename",imagefilename);
			        item.put("filesize",rs.getString("filesize"));
			        item.put("filetype",imagefilename.substring(imagefilename.lastIndexOf(".")+1));
			        item.put("localpath",localpath);
			        item.put("type","0");
					item.put("uid",fileid);
					
					RecordSet rsLog = new RecordSet();
					String logsql = "select id from  NetworkfileLog where downloadfileguid = '" + downloadfileguid + "'";
					
					rsLog.executeSql(logsql);
					 if(rsLog.next())
					{
						item.put("logid",rsLog.getString("id"));
					}
			        result.add(item);
		        }
		    }
		}
		
	}
	
	JSONArray jo = JSONArray.fromObject(result);
	out.println(jo.toString());
%>
