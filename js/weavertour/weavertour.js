/**
 * Created by lsj on 2015/3/31.
 */
var WeaverTour = (function(win,doc,$){
   var TRIANGLE_EDGE = 10;
   var tbody = $(doc.body);


   var WeaverTour = win.WeaverTour = function(config){

       this.options = $.extend({steps:[],speed:700},{steps:config});
       this.currentstepNum = 0;
       this.currentStep = null;
   }

    //开始导航
    WeaverTour.prototype.startTour = function(){
    	if(tbody.length === 0){
    		tbody = $(doc.body);
    	}
    	var that = this;
    	setTimeout(function(){
    		if( that.options.steps.length > 0){
    			that.currentStep = that.options.steps[0];
    			that.generatorTipDialog();
    			that.setElOverLay();
            }
    	},2000);
        
    }

    //下一步
    WeaverTour.prototype.nextStep = function(){
         this.currentStep.dialog.fadeOut("slow");
         this.currentstepNum++;
         this.currentStep = this.options.steps[this.currentstepNum];
         if(this.currentStep.dialog){
             this.currentStep.dialog.fadeIn('slow');
         }else{
             this.generatorTipDialog();
         }
         tbody.animate({scrollTop:this.currentStep.el.offset().top},this.options.speed);
         this.setElOverLay();
    }
    //上一步
    WeaverTour.prototype.preStep = function(){
        this.currentStep.dialog.fadeOut("slow");
        this.currentstepNum--;
        this.currentStep = this.options.steps[this.currentstepNum];
        if(this.currentStep.dialog){
            this.currentStep.dialog.fadeIn('slow');
        }else{
            this.generatorTipDialog();
        }
        tbody.animate({scrollTop:this.currentStep.el.offset().top},this.options.speed);
        this.setElOverLay();
    }
    //停止导航
    WeaverTour.prototype.stopTour = function(){
           var steps = this.options.steps;
           //移除dialog
           for(var i=0; i<steps.length; i++){
                if(steps[i].dialog){
                    steps[i].dialog.remove();
                }
           }
           //移除遮罩
          $(".weavertour_overlay").remove();
          this.options.steps = null;
    }

    //生成提示对话框
    WeaverTour.prototype.generatorTipDialog = function(){
        var $el = $("#"+this.currentStep.itemid),
            showposition = this.currentStep.position || "bottom", dialog;
        this.currentStep.el = $el;
        //对话框
        dialog = $("<div class='weavertour_dialog'> "+
                            "<div class='weavertour_arrow_"+showposition+"'>"+
                            "</div> "+
                            "<div class='weavertour_content'> "+
                                "<div class='weavertour_title'> "+
                                       this.currentStep.title+
                                "</div> "+
                                "<div class='weavertour_info'> "+
                                       this.currentStep.describe+
                                "</div>" +
                                 "<div class='weavertour_toobar'>"+
                                 "</div>" +
                            "</div>"+
                      "</div>");
        this.currentStep.dialog = dialog;
        tbody.append(dialog);
        this.setDialogPageBtn();
        this.setDialogPosition($el,showposition,dialog);
        //绑定按钮事件
        this.bindEvents();
    }
    //设置高亮
    WeaverTour.prototype.setElOverLay = function(){
         var offset = this.currentStep.el.offset(), width = this.currentStep.el.width(), height = this.currentStep.el.height(), cssitem = {};
         if($(".weavertour_overlay").length > 0){
             cssitem["width"] = width+'px';
             cssitem["height"] = height+'px';
             cssitem["left"] = offset.left+'px';
             cssitem["top"] = offset.top+'px';
             $(".weavertour_overlay").animate(cssitem,this.options.speed);
         }else{
             var overlay = $("<div class='weavertour_overlay'></div>");
             overlay.css("width",width+'px').css("height",height+'px').css("left",offset.left+"px").css("top",offset.top+"px");
             tbody.append(overlay);
         }
    }
    //生成对话框
    WeaverTour.prototype.setDialogPosition = function($el,position,dialog){
        var $el_w = $el.width(), $el_h = $el.height(), d_w = dialog.width(), d_h = dialog.height(), cssitem={}, offset =  $el.offset();
        switch(position){
            case "top":(function(){
                if(d_w>=$el_w){
                    cssitem["left"] = (offset.left - (d_w/2 - $el_w/2))+'px';
                }else{
                    cssitem["left"] = (offset.left + ($el_w/2 - d_w/2))+'px';
                }
                cssitem["top"] =  (offset.top - d_h - TRIANGLE_EDGE)+'px';
            })();break;
            case "bottom":(function(){
                if(d_w>=$el_w){
                    cssitem["left"] = (offset.left - (d_w/2 - $el_w/2))+'px';
                }else{
                    cssitem["left"] = (offset.left + ($el_w/2 - d_w/2))+'px';
                }
                cssitem["top"] =  (offset.top + $el_h + TRIANGLE_EDGE)+'px';
            })();break;
            case "left":(function(){
                if(d_h>=$el_h){
                    cssitem["top"] = (offset.top - (d_h/2 - $el_h/2))+'px';
                }else{
                    cssitem["top"] = (offset.top + ($el_h/2 - d_h/2))+'px';
                }
                cssitem["left"] = (offset.left - TRIANGLE_EDGE - d_w )+'px';
            })();break;
            case "right":(function(){
                if(d_h>=$el_h){
                    cssitem["top"] = (offset.top - (d_h/2 - $el_h/2))+'px';
                }else{
                    cssitem["top"] = (offset.top + ($el_h/2 - d_h/2))+'px';
                }
                cssitem["left"] = (offset.left + TRIANGLE_EDGE + $el_w )+'px';
            })();break;
        }
        //设置tip样式
        dialog.css(cssitem);
        dialog.fadeIn('slow');
    }
    //生成分页按钮
    WeaverTour.prototype.setDialogPageBtn = function(){
        if(this.currentstepNum === (this.options.steps.length-1) && this.options.steps.length>1 ){
            this.currentStep.dialog.find(".weavertour_toobar").html("<span class='weavertour_btn weavertour_quit'>退出</span><span class='weavertour_btn weavertour_pre'>上一步</span>");
        } else if(this.currentstepNum >0  &&  (this.currentstepNum+1) < this.options.steps.length){
            this.currentStep.dialog.find(".weavertour_toobar").html("<span class='weavertour_btn weavertour_quit'>退出</span><span class='weavertour_btn weavertour_next'>下一步</span><span class='weavertour_btn weavertour_pre'>上一步</span>");
        }else  if(this.currentstepNum === 0 && this.options.steps.length>1){
            this.currentStep.dialog.find(".weavertour_toobar").html("<span class='weavertour_btn weavertour_quit'>退出</span><span class='weavertour_btn weavertour_next'>下一步</span>");
        }else {
            this.currentStep.dialog.find(".weavertour_toobar").html("<span class='weavertour_btn weavertour_quit'>退出</span>");
        }
    }
   //绑定事件
    WeaverTour.prototype.bindEvents = function(){
        var that = this;
        this.currentStep.dialog.delegate('.weavertour_btn','click',function(){
             var current = $(this);
             if(current.hasClass("weavertour_quit")){
                  //停止导航
                  that.stopTour();
             }else if(current.hasClass("weavertour_next")){
                  //下一步
                  that.nextStep();
             }else if(current.hasClass("weavertour_pre")){
                  //上一步
                  that.preStep();
             }

        });
    }
    return WeaverTour;
})(window,document,jQuery)