onmessage = function(event){
	var data = event.data[0];
	var result = "";
	
	result = searchUserInfos(data.keyword, data.userInfos);
	postMessage([result]);
}

function searchUserInfos(keyword, userInfos) {
	var item, mobile, py, userName,status, result={}, dismissionStatus= ['4', '5', '6', '7'], count = 0;
	for(var id in userInfos){
		item = userInfos[id];
		status = item.status;
		if(!item || isNaN(parseInt(id)) || id == '1' || (typeof status != 'undefined' && dismissionStatus.indexOf(status) != -1)){
			continue;
		}
		userName = item.userName?item.userName.toLowerCase():"";
		py = item.py?item.py.toLowerCase():"";
		mobile = item.mobileShow?item.mobileShow:"";
		keyword = keyword.toLowerCase();
		if(userName.indexOf(keyword) != -1 || py.indexOf(keyword) != -1 || mobile.indexOf(keyword) != -1) {
			result[id] = item;
			if(++count > 32) {
				break;
			}
		}
	}
	return result;
}