<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.docs.networkdisk.server.SyncFileServer" %>
<%@ page import="weaver.docs.networkdisk.server.impl.SyncFileServerImpl" %>
<%@page import="weaver.docs.networkdisk.bean.DocAttachment"%>
<%@page import="weaver.docs.networkdisk.tools.FileMIMEUtil"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="org.apache.axis.encoding.Base64" %>
<%@page import="weaver.mobile.plugin.ecology.service.HrmResourceService"%>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	
	    HrmResourceService hrs = new HrmResourceService();
		// 用户登录ID
		String loginId = request.getHeader("loginId");
		// 获取到用户信息
	    User user = hrs.getUserById(hrs.getUserId(loginId));
	    // 封装文件上传对象
	    DocAttachment attInfo = new DocAttachment();
	 	// 文档创建人
	    attInfo.setCreaterId(user.getUID()+"");
	 	// 创建日期
	    attInfo.setCreateDate(request.getHeader("cdate"));
	    // 创建时间
	    attInfo.setCreateTime(request.getHeader("ctime"));
	    // 最后修改人
	    attInfo.setModifierId(user.getUID() + "");
	    // 最后修改日期
	    attInfo.setModifyDate(request.getHeader("mdate"));
	    // 最后修改时间
	    attInfo.setModifyTime(request.getHeader("ctime"));
	    // 所在目录
	    attInfo.setCategoryid(request.getHeader("categoryid"));
	    // 文件流
	    attInfo.setIs(request.getInputStream());
	    // 文件名
	    String fileName = request.getHeader("fileName");
	    byte[] decoded_fileName = Base64.decode(fileName);
	    fileName = new String(decoded_fileName, "utf8");
	    attInfo.setFileName(fileName);
	 	// 文件类型
	    attInfo.setFileType(FileMIMEUtil.getMIMEType(fileName.substring(fileName.lastIndexOf("."))));
	    // 文件大小
	    attInfo.setFileSize(Integer.parseInt(request.getHeader("fileSize")));
	    // 客户端GUID
	    attInfo.setComputerCode(request.getHeader("clientguid"));
	 	// 文件路径MD5值
	    attInfo.setFilePathMd5(request.getHeader("filePathMd5"));
		
	    // 需同步的根目录
	    byte[] decoded_rootpath = Base64.decode(request.getHeader("rootPath"));
	    String rootPath = new String(decoded_rootpath, "utf8");
	    
	    byte[] decoded_filePath = Base64.decode(request.getHeader("filePath"));
	    String filePath = new String(decoded_filePath, "utf8");
	    
	    attInfo.setDiskPath(rootPath);
	    // 文件相对盘符路径(不包含名称)
	    attInfo.setRelativePath(filePath.substring(rootPath.length()).replace(fileName,""));
		
	    // 文件上传接口
	    SyncFileServer syncFileServer = new SyncFileServerImpl();
		
		String uploadType = request.getHeader("type");
		if(uploadType.equals("1"))
		{
			// 上传
			attInfo = syncFileServer.uploadByButton(attInfo,user);
		}
		else
		{
			// 上传
			attInfo = syncFileServer.uploadByInput(attInfo,user);
		}
	    response.setHeader("returnstatus", attInfo.getReturnStatus());
%>