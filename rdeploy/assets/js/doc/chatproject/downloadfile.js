

function syncdownfiles(item,choosed){
	downloadSizeCount = parseInt(downloadSizeCount) + parseInt(item.filesize);
	syncdownfile(item,choosed);
};



function getFileTempSize(path){
	if(fs.existsSync(path)){
		var fileStat = getFilefileStat(path);
		return fileStat.size;
	}
	else{
		return 0;
	}
}


function syncdownfile(item,localpath){ 

	var file_url = userInfos.currentHost+'/weaver/weaver.file.NetworkDiskFileDownload';
	var urlinfo = urlparse(file_url);
	var DOWNLOAD_DIRPATH = localpath+'\\'+item.filename;
	var DOWNLOAD_DIRPATH_TEMP = DOWNLOAD_DIRPATH+"_"+item.id;
	var filestart = 0;
	
	if(fs.existsSync(DOWNLOAD_DIRPATH_TEMP)){
		var fileStat = fs.statSync(DOWNLOAD_DIRPATH_TEMP);
		filestart = fileStat.size;
	}
	var options = {
		method: 'GET',
		host: urlinfo.hostname,
		path: urlinfo.pathname,
		headers: {
			'start':  filestart,
			'imagefileid': item.uid,
		}
	};
	if(urlinfo.port) {
		options.port = urlinfo.port;
	}
	if(urlinfo.search) {
		options.path += urlinfo.search;
		}
	var req = http.request(options, function(res) {
		res.on('data', function(data) {
			fs.appendFileSync(DOWNLOAD_DIRPATH_TEMP,data);
			filestart += data.length;
			var filepr =  Math.round(filestart / (item.filesize) * 10000) / 100.00;
			if(filepr > 99)
			{
				filepr = 99;
			}
			if(filestart == item.filesize)
			{
				deleteDownloadTemp(item.id);
				fs.renameSync(DOWNLOAD_DIRPATH_TEMP, DOWNLOAD_DIRPATH);
				fillProgressBar(item.id,100);
			}
			fillProgressBar(item.id,filepr);
			
			downloadedSizeCount = parseInt(downloadedSizeCount) + parseInt(filestart);
			
			var fileprFull =  Math.round(filestart / (downloadSizeCount) * 10000) / 100.00;
			if(fileprFull > 99)
			{
				fileprFull = 99;
			}
			fillFullProcess(fileprFull,'download');
			
			
		}).on('end', function() {
			
		});
	});
	reqDownloadMap[item.uid] = req;
	req.end();
};


function deleteDownloadTemp(downloaduid)
{
	var file_url = userInfos.currentHost+'/docs/networkdisk/deleteDownloadFileTemp.jsp';
	var urlinfo = urlparse(file_url);
	
	var options = {
		method: 'GET',
		host: urlinfo.hostname,
		path: urlinfo.pathname,
		headers: {
			'downloaduid': downloaduid,
			'clientguid' : userInfos.guid,
			'isSystemDoc' : window.VIEW_MODEL == "disk" ? 0 : 1
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
					if(res.headers.deletestatus == '1')
					{
						
					}
					else
					{	
						
					}
				}
			});
	});
	req.end();
}


function pauseDownload(uploadfile_uid){
	reqDownloadMap[uploadfile_uid].destroy();
};



function resumeDownload(item,localpath){
	syncdownfile(item,localpath);
};

/**
*全部取消下载
*/
function cancelAllDownload(itemMap){
	if(itemMap)
	{
		for(var i = 0;i < itemMap.length;i++){
			deleteDownloadTemp(itemMap[i])
		}
	}
	fillFullProcess(100,'download');
};
/**
* 全部暂停上传
*/
function pauseAllDownload(){
	for(var key in reqDownloadMap) {
		reqDownloadMap[key].destroy();
	}
};

/**
* 全部重新上传
*/
function resumeAllDownload(itemMap){
	for(var key in itemMap)  {
		resumeDownload({
			id : itemMap.id,
			uid : itemMap.uploadfileguid,
			filename : itemMap.filename,
			filesize : itemMap.totalSize	
		},itemMap.diskPath);
	}
};