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

var mainFields  = {};
$(function(){ 
    var billid = GetQueryString("billid");
    var kx = jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.journal']")[0]).val();
    var name = getKxSet(jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.journal']")[0]).val());
    var defalutPeriods  = jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.periods']")[0]).val();
    var title0 = jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.titlepre']")[0]).val();
    var title1 = jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.titleaft']")[0]).val();
    document.getElementById("cIframe").src="/govern/information/EditForView.jsp?edittype=0&billid="+billid+"&kx="+kx+"&type=0&name="+encodeURI(title0)+"&title1="+encodeURI(title1)+"&defalutPeriods="+defalutPeriods;
    $("#cIframe").parent().css("height","100%");
    $("#cIframe").css("height","100%");
    jQuery.ajax({    
        type:'post',    
        url:'/govern/information/ContentSelectOperation.jsp?action=getPbFields',
        cache:false,    
        dataType:'json',
        async : false,
        success:function(data){
            mainFields = data;
        },
        error:function(e){
            console.log(e);        
        }
    });

    if(name){
        //jQuery(jQuery("#titleTd").find("span")[0]).html(name + "&nbsp;&nbsp;&nbsp;&nbsp;第"+defalutPeriods +"期");
    	$(window.frames["cIframe"].document).find("#tltleSpan").text(name + "&nbsp;&nbsp;&nbsp;&nbsp;第"+defalutPeriods +"期");
    }
}); 

function changeEditUtl(eid){
    console.log("mainFields ",mainFields);
    if(eid){
        jQuery.ajax({    
    	    type:'post',    
    	    url:'/govern/information/ContentSelectOperation.jsp?action=getDbxx',
    	    cache:false,    
    	    dataType:'json',
    	    data:{id:eid},
    	    async : false,
    	    success:function(data){
                $("#field"+mainFields.bs_bt+"span").html(data.bt);
                $("#field"+mainFields.bs_dw+"span").html(data.bsdw);
                $("#field"+mainFields.bs_rq+"span").html(data.bsrq);
                $("#disfield"+mainFields.bs_mj).val(data.mj);
                $("#field"+mainFields.bs_fj+"span").html(data.zw);

            }
        });
    }
}


function changePeriods(kuqus){
    var defalutPeriods = kuqus.periods
    jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.periods']")[0]).val(defalutPeriods);
    jQuery(jQuery("#titleTd").find("span")[0]).html(name + "&nbsp;&nbsp;&nbsp;&nbsp;第"+defalutPeriods+"期");
    jQuery(jQuery("input[ecologyname='uf_xxcb_pbInfo.title']")[0]).val(name+"第"+defalutPeriods+"期");
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
