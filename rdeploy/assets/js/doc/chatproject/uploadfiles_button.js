
/**
* 上传
* categoryid:目录ID，filePath:文档路径，fileStat:文档信息，userInfos:用户信息，uid：文件唯一值
*/
function uploadFile (filePath,fileStat,fileMd5,uploadfileguid,comefrom) {
	if(fileStat.size == 0)
	{
		uploadError(uploadfileguid,"不能为空");
	}
	else if(fileStat.size > 2147483648){
		uploadError(uploadfileguid,"不能超过2G");
	}
	else
	{
		uploadSizeCount += fileStat.size;
		uploadFileTemp(filePath,fileStat.size,0,fileMd5,uploadfileguid,comefrom);
	}
};

/**
* 上传缓存文件，以1M为一个单位上传
*/
function uploadFileTemp(filePath,filesize,startsize,fileMd5,uploadfileguid,comefrom)
{
	// 计算分块单位
	var itemsize = 0;
	var endsize = parseInt(startsize) + (1024*1024);
	// 如果结束位置大于文件大小，结束位置取文件大小
	if(endsize >= filesize)
	{
		endsize = filesize -1;
	}
	// 上传到服务器
	upload_file(filePath,filesize,parseInt(startsize),endsize,fileMd5,uploadfileguid,comefrom);
}

function upload_file(filePath,filesize,startsize,endsize,fileMd5,uploadfileguid,comefrom)
{
		var urlinfo = urlparse(userInfos.currentHost+"/docs/networkdisk/uploadFiles_temp.jsp");
		var options = {
			method: 'POST',
			host: urlinfo.hostname,
			part: urlinfo.port,
			path: urlinfo.pathname,
			headers: {
				'loginid': userInfos.loginId,
				'uploadfileguid': uploadfileguid,
				'filepathmd5': fileMd5,
				'startsize' : startsize,
				'filesize' : filesize
			}
		};
		if(urlinfo.port) {
			options.port = urlinfo.port;
		}
		if(urlinfo.search) {
			options.path += urlinfo.search;
		}
		
		var req = http.request(options, function(res) {
			var chunks = [], length = 0;
			res.on('data', function(chunk) {
				length += chunk.length;
				chunks.push(chunk);
			});
			res.on('end', function() {
				if(res.statusCode == '200')
				{
					if(res.headers.returnstatus == '1')
					{
						uploadFileTemp(filePath,filesize,res.headers.startsize,fileMd5 ,uploadfileguid,comefrom);
					}else if(res.headers.returnstatus == '-1'){
						uploadError(uploadfileguid,"上传失败!");
					}
					else
					{	
						fillProgressBar(uploadfileguid,100);
					}
				}
			});
		});
	reqUploadMap[uploadfileguid] = req;
	var readstream  = fs.createReadStream(filePath,{start: startsize, end: endsize });
	
	readstream.on('data', function(chunk) {
		req.write(chunk);
	});
	// 读取结束
	readstream.on('end',function(){
		var filepr =  Math.round(endsize / (filesize) * 10000) / 100.00;
				if(filepr > 99)
				{
					filepr = 99;
				}
		fillProgressBar(uploadfileguid,filepr);
		uploadedSize(uploadfileguid,endsize);
		req.end();
		uploadedSizeCount += (endsize - startsize);
		var fileprFull =  Math.round(uploadedSizeCount / (uploadSizeCount) * 10000) / 100.00;
		if(fileprFull > 99)
		{
			fileprFull = 99;
		}
		fillFullProcess(fileprFull,'upload');
	});
}

/**
* 获取文件信息
*/
function getFilefileStat(pathname){
	var fileStat = fs.statSync(pathname);
	return fileStat;
};
/**
* 取消上传
*/
function cancelUpload(uploadfile_uid){
	if(reqUploadMap)
	{
		if(reqUploadMap[uploadfile_uid])
		{
			reqUploadMap[uploadfile_uid].destroy();
		}
	}
	deleteUpload(uploadfile_uid);
};

/**
* 暂停上传
*/
function pauseUpload(uploadfile_uid){
	reqUploadMap[uploadfile_uid].destroy();
};



/**
* 重新上传
*/
function resumeUpload(diskPath,totalSize,size,fileMd5,uploadfileguid){
	var _endsize = parseInt(size) + (1024*1024);
	if(_endsize >= totalSize)
	{
		_endsize = totalSize;
	}
	upload_file(diskPath,totalSize,parseInt(size),_endsize - 1,fileMd5,uploadfileguid);
};



/**
* 全部取消上传
*/
function cancelAllUpload(itemMap){
	
	for(var i = 0 ; i < itemMap.length ; i ++)
	{
		cancelUpload(itemMap[i]);
	}
	
	fillFullProcess(100,'upload');
};

function deleteUpload(uploadfile_uid)
{
	jQuery.ajax({
		url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
		data : {
			'uploadfile_uid' : uploadfile_uid,
			'type' : 'deleteUploadIng'
		},
		type : "post",
		dataType : "json",
		success : function(data){
			if(data && data.flag == "1"){
				
			}else{
				window.top.Dialog.alert("删除操作失败!");
			}
			}
		});
}

/**
* 全部暂停上传
*/
function pauseAllUpload(){
	for(var key in reqUploadMap) {
		reqUploadMap[key].destroy();
	}
};

/**
* 全部重新上传
*/
function resumeAllUpload(itemMap){
	for(var key in itemMap)  {
		resumeUpload(itemMap[key].diskPath,itemMap[key].totalSize,itemMap[key].size,itemMap[key].fileMd5,itemMap[key].uploadfileguid);
	}
};
