/**
 * Created by 三杰lee on 2015/1/4.
 * 根据任务状态 显示具体的时间戳
 */
+function (window, document, $) {
    //当前任务模板
    var tasknowTemp = "<div class='taskitem'> " +
        "<span class='middlehelper'></span> " +
        "    <span class='tasknow'> " +
        "   </span> " +
        "   <span class='tasklinenow taskmargin'> " +
        "   </span> " +
        "   <div class='taskinfo taskmargin' style='background-color: #FFB55E'> " +
        "   <div style='color: #fff'> " +
        "   <span class='middlehelper'></span> " +
        "   <span class='taskuser'>   " +
        "   </span>  " +
        "   </div>  " +
        "   <div style='color: #fff' >  " +
        "   <span class='middlehelper'></span>  " +
        "   <span class='taskdate'>  " +
        "   </span>  " +
        "   <span class='tasktime' style='color: #fff'>  " +
        "   </span>  " +
        "   </div>  " +
        "  </div>  " +
        "</div>";
    //中间任务模板
    var taskmiddleTemp = "<div class='taskitem'> " +
        "    <span class='middlehelper'></span> " +
        "  <span class='taskmiddle '> " +
        "  </span> " +
        "  <span class='taskline taskmargin'>" +
        " </span> " +
        " <div class='taskinfo taskmargin'> " +
        "   <div> " +
        " <span class='middlehelper'></span> " +
        " <span class='taskuser'> " +
        " </span> " +
        " <span class='tasksplitline'> " +
        "  - " +
        " </span> " +
        " <span class='taskstatus'> " +
        "  </span> " +
        " </div> " +
        "  <div>" +
        "   <span class='middlehelper'></span> " +
        " <span class='taskdate'> " +
        " </span> " +
        "  <span class='tasktime'> " +
        " </span> " +
        " </div> " +
        " </div> " +
        " </div>";
    //开始任务模板
    var taskbeginTemp = "<div class='taskitem'> " +
        "<span class='middlehelper'></span> " +
        "<span class='taskbegin '> " +
        "  </span> " +
        "   <span class='taskline taskmargin'> " +
        "   </span> " +
        "   <div class='taskinfo taskmargin'> " +
        "   <div> " +
        "    <span class='middlehelper'></span> " +
        "    <span class='taskuser'> " +
        "    </span> " +
        "  <span class='tasksplitline'> " +
        " - " +
        "  </span> " +
        "  <span class='taskstatus'>  " +
        " </span> " +
        "   </div> " +
        "  <div> " +
        "  <span class='middlehelper'></span> " +
        "  <span class='taskdate'> " +
        "  </span> " +
        "   <span class='tasktime'> " +
        "   </span> " +
        "  </div> " +
        "  </div> " +
        "  </div>";

    //给模板元素赋值
    function  setTempValue(el,taskinfo){

        el.find(".taskuser").html(taskinfo.taskuser);
        el.find(".taskdate").html(taskinfo.taskdate);
        el.find(".tasktime").html(taskinfo.tasktime);
        //如果是当前任务节点,则任务状态放在图标上
        if(el.find(".tasknow").length>0){
           el.find(".tasknow").html(taskinfo.taskstatus);
         }else{
            el.find(".taskstatus").html(taskinfo.taskstatus);
        }
    }

    $.fn.taskline = function (dataitems) {
        var taskframeset = $("<div class='taskitems'><div class='taskvline'></div></div>"),tasktemp;
        for(var i=dataitems.length-1; i>=0;i--){
             //当前任务
             if(i === (dataitems.length-1)){
                 tasktemp = tasknowTemp;
             //开始任务
             }else if(i === 0){
                 tasktemp = taskbeginTemp;
             //中间任务
             }else{
                 tasktemp = taskmiddleTemp;
             }
            tasktemp = $(tasktemp);
            setTempValue(tasktemp,dataitems[i]);
            //添加任务节点
            taskframeset.append(tasktemp);
        }
        //添加时间戳
        this.append(taskframeset);
        var that = this;
        $(document.body).click(function(e){
        	var current = e.target;
        	var $this = $(current);
        	if(that[0] !== current  &&  !!!that.has($this).length &&  !$this.hasClass("trace")){
        		that.hide();
        	}
        });
    }
}(this, document, jQuery);