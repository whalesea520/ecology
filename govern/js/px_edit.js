window.console = window.console || (function () {
    var c ={}; 
　　 c.log = c.warn = c.debug = c.info = c.error = c.time = c.dir = c.profile= c.clear = c.exception = c.trace = c.assert = function(){};
    return c;
})();
function GetQueryString(name){
     var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
     var r = window.location.search.substr(1).match(reg);
     if(r!=null)return  unescape(r[2]); return null;
}
var frameurl = "";
function refreshIframe(){

document.getElementById("cIframe").src = frameurl  ;
}

var name = "";
$(function(){ 
    var billid = GetQueryString("billid");
    var kx = jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.journal']")[0]).val();
    var defalutPeriods = jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.periods']")[0]).val();
    name = getKxSet(kx);
    var title0 = jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.titlepre']")[0]).val();
    var title1 = jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.titleaft']")[0]).val();
    frameurl  = "/govern/information/EditForView.jsp?edittype=2&billid="+billid+"&defalutPeriods="+defalutPeriods+"&kx="+kx+"&name="+encodeURI(title0)+"&title1="+encodeURI(title1);
    document.getElementById("cIframe").src=frameurl;

    //if(name){
        //jQuery(jQuery("#titleTd").find("span")[0]).html(name + "&nbsp;&nbsp;&nbsp;&nbsp;第"+defalutPeriods +"期");
    	//$(window.frames["cIframe"].document).find("#tltleSpan").text(name + "&nbsp;&nbsp;&nbsp;&nbsp;第"+defalutPeriods +"期");
    //}
    var gwid = jQuery("input[ecologyname='uf_xxcb_pbInfo.gwid']").val();
    if(!gwid){
    	var btnHtml = "";
	    btnHtml += "<input type=\"button\" value=\"保存\" id=\"edit_btn_save\" class=\"e8_btn_top_first editBtn\" title=\"保存\" onclick=\"javascript:editFromList();\">";
	    $("#btnTd").html(btnHtml)
    }
    
}); 

function changeEditUtl(eid){
    if(eid){
        jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.dbxxxz']")[0]).val(eid);
    }
}

function changePeriods(kuqus){
    var defalutPeriods = kuqus.periods;
    var titlepre = kuqus.titlepre;
    var titleaft = kuqus.titleaft;
    jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.titlepre']")[0]).val(titlepre);
    jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.titleaft']")[0]).val(titleaft);
    jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.periods']")[0]).val(defalutPeriods);
    $(window.frames["cIframe"].document).find("#tltleSpan").text(titlepre + "第"+defalutPeriods+"期"+titleaft);
    jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.title']")[0]).val(titlepre+"第"+defalutPeriods+"期"+titleaft);

}

function getKxSet(id){
    var ss = "";
    jQuery.ajax({    
    	type:'post',    
    	url:'/govern/information/ContentSelectOperation.jsp?action=getKxSet',
    	cache:false,    
    	dataType:'json',
    	data:{id:id},
    	async : false,
    	success:function(data){
            ss = data.name
        }
    });
    return ss;
}

function checkCustomize(){
    try{
    	var flag = true;
        var dataArray = document.getElementById("cIframe").contentWindow.dataArray;
        var data = [];
        var needPrompt = false;
        for(var i =0;i<dataArray.length;i++){
            var obj = {};
            obj.index=dataArray[i].index;
            obj.id=dataArray[i].id;
            var typeid = dataArray[i].typeid;
            if(!typeid)
            	needPrompt = true;
            obj.typeid = typeid
            data.push(obj);
        }
        if(needPrompt){
        	//flag = confirm("有来文未指定栏目，未指定栏目来文无法自动排版到期刊中。是否确认保存？");
        	flag = false;
        	top.Dialog.alert("有来文未指定栏目，无法自动排版到期刊中。请修改！");
        }
        var jsonStr = JSON.stringify({list:data});
        jQuery(jQuery("textarea[ecologyname='uf_xxcb_pbInfo.detailJson']")[0]).val(jsonStr);
    }catch(e){
        alert(e);
    }
    return flag;
}

function editFromList(){
    var editid = jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.dbxxxz']")[0]).val();
    var bt = jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.bs_bt']")[0]).val();
    var bsdw = jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.bs_dw']")[0]).val();
    var zw = jQuery(jQuery("textarea[ecologyname='uf_xxcb_pbInfo.bs_fj']")[0]).val();
    var bsrq = jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.bs_rq']")[0]).val();
    var qs= jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.bs_qs']")[0]).val();
    var mj= jQuery(jQuery("select[ecologyname='uf_xxcb_pbInfo.bs_mj']")[0]).val();
    var ly= jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.bs_ly']")[0]).val();
    console.log({editid:editid,bt:bt,bsdw:bsdw,zw:zw,bsrq:bsrq,qs:qs,mj:mj,ly:ly});
    jQuery.ajax({    
    	type:'post',    
    	url:'/govern/information/ContentSelectOperation.jsp?action=saveDbxx',
    	cache:false,    
    	dataType:'json',
    	data:{editid:editid,bt:bt,bsdw:bsdw,zw:zw,bsrq:bsrq,qs:qs,mj:mj,ly:ly},
    	async : false,
    	success:function(data){
            var flag = data.flag;
    		var sbdw = data.sbdw;
    		if(flag){
    			top.Dialog.alert("保存成功");
    			document.getElementById("cIframe").contentWindow.updateDbxx(editid,bsdw,sbdw,bt);
    		}else{
    			top.Dialog.alert("保存失败")
    		}
        }
    });
}