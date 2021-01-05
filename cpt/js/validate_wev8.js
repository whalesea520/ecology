function checkshareifexists(tablename,poststr,_callback){
	
	var returnval = false;
	if(tablename==undefined||tablename==""||poststr==undefined||poststr==""){
		return false;
	}
	jQuery.ajax({
		url : "/cpt/capital/ShareIfExistsAjax.jsp",
		type : "post",
		async : true,
		processData : false,
		data : "tablename="+tablename+"&poststr="+poststr,
		dataType : "json",
		success: function do4Success(data){
			if(data&&data.msg&&data.msg!=""){
				window.top.Dialog.alert(data.msg);
				returnval=true;
			}else{
				try{
					if(_callback){
						_callback();
					}
				}catch(e){}
				
				returnval=false;
			}
		}
	});
	
	return returnval;
}



function checkdtifover(dtinfo,cptid_idx,cptnum_idx,_callback){
	
	var returnval = false;
	var tmp_cptid;
	var tmp_cptnum;
	if(cptnum_idx==-1){//the detail has no cptnum_idx,so is 1
		tmp_cptnum=1;
	}
	var poststr = "";
	if(dtinfo&&dtinfo.length>0){
		$.each(dtinfo,function(i,m){
			
			$.each(m,function(j,n){
				if(j==cptid_idx){
					for(var key in n){
						tmp_cptid=n[key];
					}
				}else if(j==cptnum_idx){
					for(var key in n){
						tmp_cptnum=n[key];
					}
				}
			});
			poststr += "|"+tmp_cptid+","+ tmp_cptnum;
		});
	}
	
	if(poststr!=""){
		poststr =poststr.substr(1);
	}else{
		return false;
	}
	jQuery.ajax({
		url : "/cpt/capital/CptIfOverAjax.jsp",
		type : "post",
		async : true,
		processData : false,
		data : "poststr="+poststr,
		dataType : "json",
		success: function do4Success(data){
			if(data&&data.msg&&data.msg!=""){
				window.top.Dialog.alert(data.msg);
				returnval=true;
				if(data.msg.contains("申请数量超出库存，请重新填写!")){
					returnval=false;
				}
			}else{
				try{
					if(_callback){
						_callback();
					}
				}catch(e){}
				returnval=false;
			}
		}
	});	
	
	return returnval;
}

function checkdtismust(dtinfo,dtmustidx){
	var ischeckdt=true;
	if(dtinfo&&dtinfo.length>0){
		$.each(dtinfo,function(i,m){
			$.each(m,function(j,n){
				if($.inArray(j,dtmustidx)!=-1){
					for(var key in n){
						if(n[key]==""){
							ischeckdt=false;
							return false;
						}
					}
				}
			});
		});
	}
	return ischeckdt;
}



function checkcapitalnum(poststr,_callback){
	//alert("checkcapitalnum");
	var returnval = false;
		
	if(poststr!=""){
		poststr =poststr.substr(1);
	}else{
		return false;
	}
	jQuery.ajax({
		url : "/cpt/capital/CptIfOverAjax.jsp",
		type : "post",
		async : true,
		processData : false,
		data : "poststr="+poststr,
		dataType : "json",
		success: function do4Success(data){
			if(data&&data.msg&&data.msg!=""){
				window.top.Dialog.alert(data.msg);
				returnval=true;
			}else{
				try{
					if(_callback){
						_callback();
					}
				}catch(e){}
				returnval=false;
			}
		}
	});	
	
	return returnval;
}

function checkformanager(poststr,formid,requestid,_callback){
	//alert("checkformanager==="+poststr);
	var returnval = false;
		
	if(poststr!=""){
		poststr =poststr.substr(1);
	}else{
		return false;
	}
	jQuery.ajax({
		url : "/cpt/capital/CptNumForManager.jsp",
		type : "post",
		async : true,
		processData : false,
		data : "poststr="+poststr+"&formid="+formid+"&requestid="+requestid,
		dataType : "json",
		success: function do4Success(data){
			if(data&&data.msg&&data.msg!=""){
				window.top.Dialog.alert(data.msg);
				returnval=true;
			}else{
				try{
					if(_callback){
						_callback();
					}
				}catch(e){}
				returnval=false;
			}
		}
	});	
	
	return returnval;
}




