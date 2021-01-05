 var ulWidth = 0;
 $(function(){
    lavlinit();
 });
 
function onLeft(){ 
    var Lilength =  $(".lavaLamp li:visible").length;
    var lastLi =  $(".lavaLamp li:visible").last().index();
    var secendLi = $(".lavaLamp li:visible").eq(1).index();

    if($(".lavaLamp li").eq(1).css("display")!="none") return; 
    $(".lavaLamp li:visible").each(function(index){
        if($(this).index()!=lastLi){
            if(index>=Lilength-4)
                $(this).hide("normal");
        }
    }); 

    $(".lavaLamp li:hidden").each(function(){
        var index = $(this).index();
        if(index>=secendLi-3 && index<=secendLi){
            $(this).show("normal");
        }
    });  
}

function onRight(){    
    var sumLi = 0;
    var lastLi =  $(".lavaLamp li:visible").last().index();
    $(".lavaLamp li:visible").each(function(){
        var vindex =  $(this).index();
        if(vindex!=lastLi) sumLi = vindex;
    });
    
    if($(".lavaLamp li").eq(lastLi-1).css("display")!="none") return; 
    $(".lavaLamp li:visible").each(function(index){
        if(index>0){
            if(index<=3)
            $(this).hide("normal");
        }
            
    }); 

    $(".lavaLamp li:hidden").each(function(){
        var index = $(this).index();
        if(index>sumLi && index<=(sumLi+3)){
            $(this).show("normal");
        }
    });    
}


function lavlinit(){
    $(".lavaLamp li").show();
    var sumLength = $(".lavaLamp li").length;
    if(sumLength==0) return;
    var liWidthSum =0;
        ulWidth = $(".lavaLamp").css("width");

    if(ulWidth.indexOf("px")){
        ulWidth = ulWidth.substr(0,ulWidth.indexOf("px"));
    }   
    ulWidth = parseInt(ulWidth)-45;
    $(".lavaLamp li").each(function(index){
        var width = $(this).css("width");
        width = width.substr(0,width.indexOf("px"));
        liWidthSum += parseInt(width);
        if(liWidthSum >ulWidth){
            if(index<sumLength-1)
             $(this).css("display","none");
        }
    });
    if(liWidthSum < ulWidth){
        $("#leftImg").css("display","none");
        $("#rightImg").css("display","none");
    }     
}
