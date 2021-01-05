/**
 * @author wcd
 * @date 2014-06-18
 */
function ajaxinit(){
	var xmlhttp;
	try{
		xmlhttp = new ActiveXObject('Msxm12.XMLHTTP');

	}catch(e){
		try{
			xmlhttp = new ActiveXObject('Microsoft.XMLHTTP');

		}catch(e){
			try{
				xmlhttp = new XMLHttpRequest();
			}catch(e){}
		}
	}
	return xmlhttp;
}

function ajaxSubmit(url){
	var result = "";
	var xmlhttp = ajaxinit();
	xmlhttp.open("get",url,false);
	xmlhttp.onreadystatechange = function(){
		if(xmlhttp.readyState == 4){
			if(xmlhttp.status == 200){
				result = xmlhttp.responseText;
			}
		}
	}
	xmlhttp.send(null);
	return result.trim();
}

function changeSelectValue(id,value){
	var option = $("select[id="+id+"]").find("option[value="+value+"]");
	$("select[id="+id+"]").selectbox("change", option.attr('value'), option.html());
}