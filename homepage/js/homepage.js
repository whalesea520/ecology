/**
 * Created by sunzhangyu on 2017/7/5.
 */

function openAppLink(obj,linkid){

    var linkType=jQuery(obj).attr("linkType");
    if(linkType=="doc")
        window.open("/docs/docs/DocDsp.jsp?id="+linkid);
    else if(linkType=="task")
        window.open("/proj/process/ViewTask.jsp?taskrecordid="+linkid);
    else if(linkType=="crm")
        window.open("/CRM/data/ViewCustomer.jsp?CustomerID="+linkid);
    else if(linkType=="workflow")
        window.open("/workflow/request/ViewRequest.jsp?requestid="+linkid);
    else if(linkType=="project")
        window.open("/proj/data/ViewProject.jsp?ProjID="+linkid);
    else if(linkType=="workplan")
        window.open("/workplan/data/WorkPlanDetail.jsp?workid="+linkid);
    return false;
}

function color_onchange(id,obj){
    try{
        if(obj.value !='000000'){
            $("#"+id).attr("checked",true);
        }
    }catch(e){}
}

function setScroll()
{
    if($(window.parent.document).find("._synergyBox").length > 0)
    {
        var ptop ;
        var bodyheight = jQuery(window.parent.document.body).height();
        var headHeight = 0;
        headHeight = jQuery(window.parent.document).find(".e8_boxhead").height();
        ptop = headHeight+1;
        $(window.parent.document).find("#synergy_framecontent").css("top",ptop);
        var phei = bodyheight - ptop;
        $(window.parent.document).find("#synergy_framecontent").css("height",phei);
    }else
    {
        var parentheight = window.parent.document.body.scrollHeight<$(window).height()?$(window).height():window.parent.document.body.scrollHeight;
        var contentheight = $("#Element_Container")[0].scrollHeight;

        if(parentheight > contentheight)
        {
            $(window.parent.document).find("#synergy_framecontent").css("height",parentheight);
            $(window.parent.document).find("#synergy_framecontent").css("top","0px");
            $("#Element_Container").css("overflow-y","hidden");
            $(window.parent.document.body).css("overflow-y","auto");
        }else
        {
            var isChrome=navigator.userAgent.indexOf("Chrome")==-1?false:true;
            var ptop ;
            if(isChrome)
                ptop = window.parent.document.body.scrollTop;
            else
                ptop = window.parent.document.documentElement.scrollTop + "px";
            var phei = window.parent.document.body.offsetHeight;
            $(window.parent.document).find("#synergy_framecontent").css("top",ptop);
            $(window.parent.document).find("#synergy_framecontent").css("height",phei);
            $("#Element_Container").css("overflow-y","auto");
            $(window.parent.document.body).css("overflow-y","hidden");
        }
    }
}

function doWorkflowEleSet(eid,ebaseid){
    try{
        //var formAction =$("#dialogIframe_"+eid).contents().find("#ifrmViewType_"+eid).contents().find("#frmFlwCenter").attr("action")
        var formAction ="/homepage/element/setting/WorkflowCenterOpration.jsp";
        var orders = getTabOrders(eid);
        $.post(formAction,{method:'submit',eid:eid,orders:orders},function(data){
            doUseSetting(eid,ebaseid);
        });

        //document.frames["ifrmViewType_"+eid].document.getElementById("btnSave").click();
    }catch(e){}
}

function showTabs(eid,tabid){
    $("#setting_"+eid).find(".settingtabcurrent").removeClass("settingtabcurrent");
    if(tabid=="tabContent"){
        jQuery("#weavertabs-content-"+eid).show();
        jQuery("#weavertabs-style-"+eid).hide();
        jQuery("#weavertabs-share-"+eid).hide();
        $("#setting_"+eid).find("#tabContent").addClass("settingtabcurrent");
    }else if(tabid=="tabStyle"){
        jQuery("#weavertabs-style-"+eid).show();
        jQuery("#weavertabs-share-"+eid).hide();
        jQuery("#weavertabs-content-"+eid).hide();
        $("#setting_"+eid).find("#tabStyle").addClass("settingtabcurrent");
    }else if(tabid=="tabShare"){
        jQuery("#weavertabs-share-"+eid).show();
        jQuery("#weavertabs-content-"+eid).hide();
        jQuery("#weavertabs-style-"+eid).hide();
        $("#setting_"+eid).find("#tabShare").addClass("settingtabcurrent");
    }

}

function onNoUseSetting(eid,ebaseid){
    if(ebaseid=="news"||parseInt(ebaseid)==7||parseInt(ebaseid)==1 || ebaseid=="reportForm" ||parseInt(ebaseid)==29){
        $.post('/page/element/compatible/NewsOperate.jsp',{method:'cancel',eid:eid},function(data){
            if($.trim(data)==""){
                //$("#item_"+eid).attr('needRefresh','true')
                //$("#item_"+eid).trigger("reload");
            }
        });
    }else if(parseInt(ebaseid)==8){
        var formAction ="/homepage/element/setting/WorkflowCenterOpration.jsp";
        $.ajax({
            url :formAction,
            data:{method:'cancel',eid:eid},
            cache : false,
            async : true,
            type : "post",
            dataType : 'json',
            success : function (result){

            }
        });
    }
    //外部数据元素有所不同需要刷新一次
    if(ebaseid=="OutData") {
        $("#item_"+eid).attr('needRefresh','true')
        $("#item_"+eid).trigger("reload");
    }
    $("#setting_"+eid).hide();
    $("#setting_"+eid).remove();
    fixedPosition(eid);
}

function openMaginze(obj,url,linkmode){
    url=url+obj.value;
    if(linkmode=="1") window.location=url;
    if(linkmode=="2") openFullWindowForXtable(url);
}


/**
 添加Tab页
 */
function addTab(eid,url,ebaseid){

    var tabCount = $("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).attr("tabCount");
    tabCount = parseInt(tabCount);
    tabCount++;

    var url = $("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).attr("url");
    url+="&tabId="+tabCount
    showTabDailog(eid,'add',tabCount,url,ebaseid)
}

function checkAllRows(eid,tableId){
    if(tableId == null){
        tableId= 'tabSetting_';
    }
    var ischeck = $('#checkAll_'+eid).attr("checked");
    $("#"+tableId+eid+" tr").find('[name=checkrow_'+eid+']').each(function(i){
        $(this).attr('checked',ischeck);
    })
}
/**
 编辑Tab页
 */
function editTab(eid,tabId,ebaseid){

    var url = $("#tabDiv_"+eid+"_"+$("#setting_"+eid).attr("randomValue")).attr("url");


    tabTitle = encodeURIComponent(encodeURIComponent(tabTitle));
    url+="&tabId="+tabId;//+"&tabTitle="+tabTitle
    if(ebaseid=="news" || parseInt(ebaseid)==7||parseInt(ebaseid)==1||parseInt(ebaseid)==29){
//		var tabWhere = $("#tab_"+eid+"_"+tabId).attr("tabWhere");
        //	url+="&value="+tabWhere;
    }else if(ebaseid=="reportForm"){
    }else{
        var showCopy = $("#tab_"+eid+"_"+tabId).attr("showCopy");
        var countFlag = $("#tab_"+eid+"_"+tabId).attr("countFlag");
        var tabTitle = $("#tab_"+eid+"_"+tabId).attr("tabTitle");
        url+="&showCopy="+showCopy+"&countFlag="+countFlag+"&tabTitle="+tabTitle;;
    }
    /*if(parseInt(ebaseid)==7 || parseInt(ebaseid)==29){
     var orderNum = $("#tab_"+eid+"_"+tabId).attr("orderNum");
     url+= "&orderNum="+orderNum;
     }*/
    showTabDailog(eid,"edit",tabId,url,ebaseid)
}

function registerDragEvent(tableId,eid) {
    var fixHelper = function(e, ui) {
        ui.children().each(function() {
            $(this).width($(this).width()); // 在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了

            $(this).height($(this).height());
        });
        return ui;
    };

    var copyTR = null;
    var startIdx = 0;

    var idStr = "#"+tableId+eid;

    jQuery(idStr + " tbody tr").bind("mousedown", function(e) {
        copyTR = jQuery(this).next("tr.Spacing");
    });

    jQuery(idStr + " tbody").sortable({ // 这里是talbe tbody，绑定 了sortable
        helper: fixHelper, // 调用fixHelper
        axis: "y",
        start: function(e, ui) {
            ui.helper.addClass("e8_hover_tr") // 拖动时的行，要用ui.helper
            if(ui.item.hasClass("notMove")) {
                e.stopPropagation && e.stopPropagation();
                e.cancelBubble = true;
            }
            if(copyTR) {
                copyTR.hide();
            }
            startIdx = ui.item.get(0).rowIndex;
            return ui;
        },
        stop: function(e, ui) {
            ui.item.removeClass("e8_hover_tr"); // 释放鼠标时，要用ui.item才是释放的行
            if(ui.item.get(0).rowIndex < 1) { // 不能拖动到表头上方

                if(copyTR) {
                    copyTR.show();
                }
                return false;
            }
            if(copyTR) {
                /* if(ui.item.get(0).rowIndex > startIdx) {
                 ui.item.before(copyTR.clone().show());
                 }else {
                 ui.item.after(copyTR.clone().show());
                 } */
                if(ui.item.prev("tr").attr("class") == "Spacing") {
                    ui.item.after(copyTR.clone().show());
                }else {
                    ui.item.before(copyTR.clone().show());
                }
                copyTR.remove();
                copyTR = null;
            }
            return ui;
        }
    });
}

function getTabOrders(eid,elementId){
    var str = "";
    if(elementId == null){
        elementId= 'tabSetting_';
    }
    $("#"+elementId+eid+" tr").find('span[orderNum]').each(function(i){
        $(this).attr('orderNum',i);
        str += $(this).attr('tabId') +"_"+i+";";
    })
    return str.substring(0,str.length-1);
}

function getTabPos(eid,orderNum,elementId,excludeId){
    var allLines = $("#"+elementId+">tbody").find('a[href*=javascript:deleTab]').parent().prev().find('span');
    var posOr = -1;

    for(var i=0; i < allLines.length; i++){
        if(excludeId && excludeId == $(allLines[i]).attr('id')){
            continue;
        }
        if(parseInt(orderNum) <= parseInt($(allLines[i]).attr('orderNum'))){
            posOr = $(allLines[i]).attr('id')
            break;
        }
    }
    return posOr;
}

function onSubMenuShow(obj){
    var divCurrent=obj.parentElement;
    var pSibling=divCurrent;

    var subMenu=document.getElementById("divSubMenu");
    subMenu.style.display='block';

    subMenu.style.position="absolute";
    //subMenu.style.width=pSibling.offsetWidth;
    subMenu.style.posLeft=pSibling.offsetLeft;
    subMenu.style.posTop=pSibling.offsetTop+pSibling.offsetHeight;
}

function onSubMenuHidden(obj){
    var subMenu=document.getElementById("divSubMenu");
    subMenu.style.display='none';
}

/*首页导航栏设置*/
var lastestSubDiv;
/*
 cObj:Current Object
 pObj:Pervious Sibling Object
 sObj:Sub Menu Object
 */
function onShowSubMenu(cObj,sObj){

    if (sObj.style.display=="none")    {
        /*初始化其显示的位置及大小*/
        //var pObj=cObj.previousSibling;
        var pObj=$(cObj).prev("div")[0];

        $(sObj).css({
            "position":"absolute",
            "left":$(pObj).offset().left,
            "top":$(pObj).offset().top+$(pObj).height()+10
        })

        if(lastestSubDiv!=null) lastestSubDiv.style.display="none";
        lastestSubDiv=sObj;
        sObj.style.display="";

        //alert(sObj.offsetWidth+":"+pObj.offsetWidth)

        var factDivWidth=pObj.offsetWidth+cObj.offsetWidth;
        if(factDivWidth<sObj.offsetWidth) factDivWidth=sObj.offsetWidth;

        sObj.style.width=factDivWidth;
        if (sObj.canHaveChildren) {
            var childDivs=sObj.children;
            for(var i=0;i<childDivs.length;i++) {
                var aChild=childDivs[i];
                if(aChild.offsetWidth<factDivWidth) aChild.style.width=factDivWidth;
            }
        }




    }
}
var x,y;
window.document.body.onmousemove = function(e){
    e=e||event;
    x = e.clientX;
    y = e.clientY;
    if(lastestSubDiv){
        var _l = lastestSubDiv.offsetLeft;
        var _t = lastestSubDiv.offsetTop;
        var _w = lastestSubDiv.offsetWidth;
        var _h = lastestSubDiv.offsetHeight;
        if(x>_l+_w || x<_l){
            lastestSubDiv.style.display = 'none';
            lastestSubDiv = null;
        }
    }
}

function stockGopage(type,url){
    if(type==0)
        openFullWindowForXtable(url);
    else
        this.location = url;
}

//处理元素样式编辑时没有设置图标图片会出现残图现象
$(".iconEsymbol").bind('error',function(){
    if($(this).attr("src")==''){
        $(this).hide();
    }
})


$(".toolbar").find("img").bind('error',function(){
    if($(this).attr("src")==''){
        $(this).hide();
    }
})


$(".downarrowclass").bind('error',function(){
    if($(this).attr("src")==''){
        $(this).hide();
    }
})


$(".rightarrowclass").bind('error',function(){
    if($(this).attr("src")==''){
        $(this).hide();
    }
})

function onCancel(){
    var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
    dialog.close();
}

function onNewRequest(obj,wfid,agent,beagenter,selfwf){
    if(!selfwf){
        $(obj).parent().find(".addwfDrop").find(".itemdrop:first").trigger("click");
        return;
    }
    jQuery.post('/workflow/request/AddWorkflowUseCount.jsp',{wfid:wfid});

    var redirectUrl = "/workflow/request/AddRequest.jsp?workflowid="+wfid+"&isagent="+agent+"&beagenter="+beagenter+"&f_weaver_belongto_userid=";
    var hiddenNames = "prjid,docid,crmid,hrmid,topage".split(",");
    for (var i = 0; i < hiddenNames.length; i++) {
        var hiddenName = hiddenNames[i];
        var hiddenVal = jQuery("input:hidden[name='"+hiddenName+"']").val();
        if (!!hiddenVal) {
            redirectUrl += "&" + hiddenName + "=" + hiddenVal;
        }
    }
    var width = screen.availWidth-10 ;
    var height = screen.availHeight-50 ;
    var szFeatures = "top=0," ;
    szFeatures +="left=0," ;
    szFeatures +="width="+width+"," ;
    szFeatures +="height="+height+"," ;
    szFeatures +="directories=no," ;
    szFeatures +="status=yes,toolbar=no,location=no," ;
    szFeatures +="menubar=no," ;
    szFeatures +="scrollbars=yes," ;
    szFeatures +="resizable=yes" ; //channelmode
    window.open(redirectUrl,"",szFeatures) ;

}

function onNewRequest2(wfid,agent,belongtouserid){
    jQuery.post('/workflow/request/AddWorkflowUseCount.jsp',{wfid:wfid});

    var redirectUrl = "/workflow/request/AddRequest.jsp?workflowid="+wfid+"&isagent="+agent+"&f_weaver_belongto_userid="+belongtouserid;
    var hiddenNames = "prjid,docid,crmid,hrmid,topage".split(",");
    for (var i = 0; i < hiddenNames.length; i++) {
        var hiddenName = hiddenNames[i];
        var hiddenVal = jQuery("input:hidden[name='"+hiddenName+"']").val();
        if (!!hiddenVal) {
            redirectUrl += "&" + hiddenName + "=" + hiddenVal;
        }
    }
    var width = screen.availWidth-10 ;
    var height = screen.availHeight-50 ;
    var szFeatures = "top=0," ;
    szFeatures +="left=0," ;
    szFeatures +="width="+width+"," ;
    szFeatures +="height="+height+"," ;
    szFeatures +="directories=no," ;
    szFeatures +="status=yes,toolbar=no,location=no," ;
    szFeatures +="menubar=no," ;
    szFeatures +="scrollbars=yes," ;
    szFeatures +="resizable=yes" ; //channelmode
    window.open(redirectUrl,"",szFeatures) ;

}

function agentWf(obj){
    $(".addwfDrop").hide();
    var etop =$(obj).offset().top;
    var eleft =$(obj).offset().left;
    var width = $(obj).parent().find(".addwfDrop").width();
    $(obj).parent().find(".addwfDrop").css("top",etop+10).css("left",eleft-width).show();
}