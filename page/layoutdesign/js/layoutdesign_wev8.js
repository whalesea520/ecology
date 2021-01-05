/**
 * User: 三杰lee
 * Date: 14-10-9
 * Time: 上午10:03
 * To change this template use File | Settings | File Templates.
 */
(function () {

    //扩展数组包含方法
    Array.prototype.contains = function(obj) {
        var i = this.length;
        while (i--) {
            if (this[i] === obj) {
                return true;
            }
        }
        return false;
    }

    this.layoutdesign = (function () {
        //获取选区标识
        var moveflag = false;
        //重置大小标识
        var resizeflag=false;
        var resizecontainer;

        var startcoord = '0,0';
        var endcoord = '0,0';
        var selectionsx;
        var selectionsy;
        var selectionex;
        var selectioney;
		
		var lang = readCookie("languageidweaver");
        //单元格合并信息
        var cellmergeinfo={};
        //所有分块
        var lettersall = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

        var layouttablewidth=$(".layouttable").width();
        //可拖拉范围
        var dragrange=5;

        return{
            initLayoutDesign: function () {
                //初始化默认合并
                // cellmergeinfo["0,0"]=['1,0','0,1','1,1'];
                // cellmergeinfo["2,0"]=['2,1'];
                // cellmergeinfo["3,0"]=['3,1'];
                // cellmergeinfo["0,2"]=['1,2','0,3','1,3'];
                // cellmergeinfo["2,2"]=['2,3'];
                // cellmergeinfo["3,2"]=['3,3'];

                this.bindMergeEvent();
            },
            //生成选区
            generatorSelection: function (left, top, width, height) {

                var currentcoord=selectionsx+","+selectionsy;
                var tdtemp=$("td[coord='"+currentcoord+"']");
                var imageicon=$(".imageicons");
                var menuleft=left+width/2;
                var menutop= top+height-imageicon.height();
                imageicon.css("top",(menutop-2)+"px");
                var rowspan=tdtemp.attr("rowspan")===undefined?1:tdtemp.attr("rowspan");
                var colspan=tdtemp.attr("colspan")===undefined?1:tdtemp.attr("colspan");
                var totalwidth;
                //可拆分
                if((rowspan>1 || colspan>1) && endcoord===startcoord && cellmergeinfo[currentcoord]!==undefined && cellmergeinfo[currentcoord].length>0){
                    imageicon.find(".mergeicon").hide();
                    imageicon.find(".splitall").show();
                    totalwidth=33;
                    if(colspan>1)  {
                        totalwidth+=33;
                        imageicon.find(".vsplit").show();
                    }
                    else
                      imageicon.find(".vsplit").hide();

                    if(rowspan>1){
                        totalwidth+=33;
                        imageicon.find(".hsplit").show();
                    }
                    else
                        imageicon.find(".hsplit").hide();
//                    menuleft=left+width/2-(imageicon.width()-33)/2;
                    imageicon.show();
                    //可合并
                }else if(startcoord!==endcoord){
                    totalwidth=33;
                    imageicon.find(".mergeicon").show();
                    imageicon.find(".splitall").hide();
                    imageicon.find(".hsplit").hide();
                    imageicon.find(".vsplit").hide();
//                    menuleft=left+width/2-(imageicon.width()-33*3)/2;
                    imageicon.show();
                }else{
                    imageicon.hide();
                }
                imageicon.css("left",(menuleft-totalwidth/2)+"px");

                var wline = $(".wline");
                wline.css("left", left + 'px');
                wline.css("top", top + 'px');
                wline.css("height", height + 'px');
                wline.show();
                var eline = $(".eline");
                eline.css("left", (left + width) + 'px');
                eline.css("top", top + 'px');
                eline.css("height", height + 'px');
                eline.show();
                var nline = $(".nline");
                nline.css("left", left + 'px');
                nline.css("top", top + 'px');
                nline.css("width", width + 'px');
                nline.show();
                var sline = $(".sline");
                sline.css("left", left + 'px');
                sline.css("top", (top + height) + 'px');
                sline.css("width", width + 'px');
                sline.show();


            },
            //计算选区
            caculateSelection: function () {
                var that = this;
                var startxy = startcoord.split(",");
                var endxy = endcoord.split(",");
                var startx = ~~startxy[0];
                var starty = ~~startxy[1];
                var endx = ~~endxy[0];
                var endy = ~~endxy[1];
                //获取左上角坐标
                var sx = startx <= endx ? startx : endx;
                var sy = starty <= endy ? starty : endy;
                //获取右下角坐标
                var ex = startx <= endx ? endx : startx;
                var ey = starty <= endy ? endy : starty;
                //选区最小坐标和最大坐标
                var minsx = sx, minsy = sy, maxex = ex, maxey = ey;
                var tdtemp;
                var colspan;
                var rowspan;
                for (var i = sx; i <= ex; i++)
                    for (var j = sy; j <= ey; j++) {
                        tdtemp = $("td[coord='" + i + "," + j + "']");
                        if (tdtemp.length > 0 && tdtemp.is(":visible")) {
                            //计算最大横坐标
                            colspan = tdtemp.attr("colspan");
                            if (colspan !== undefined && ~~colspan > 1) {
                                if (maxex < (i + ~~colspan - 1)) {
                                    maxex = i + ~~colspan - 1;
                                }
                            }
                            //计算最大纵坐标
                            rowspan = tdtemp.attr("rowspan");
                            if (rowspan !== undefined && ~~rowspan > 1) {
                                if (maxey < (j + ~~rowspan - 1)) {
                                    maxey = j + ~~rowspan - 1;
                                }
                            }
                        }
                    }
                var width = 0, height = 0, left, top;
                //计算宽度
                for (var i = minsx; i <= maxex; i++) {
                    tdtemp = $("td[coord='" + i + "," + minsy + "']");
                    if (tdtemp.length > 0 && tdtemp.is(":visible")) {
                        width += tdtemp.outerWidth();
                    }
                }
                //计算高度
                for (var j = minsy; j <= maxey; j++) {
                    tdtemp = $("td[coord='" + minsx + "," + j + "']");
                    if (tdtemp.length > 0 && tdtemp.is(":visible")) {
                        height += tdtemp.outerHeight();
                    }
                }

                tdtemp = $("td[coord='" + minsx + "," + minsy + "']");
                left = tdtemp.position().left;
                top = tdtemp.position().top;
                //绘制选区
                that.generatorSelection(left, top, width, height);

                selectionsx=minsx;
                selectionsy=minsy;
                selectionex=maxex;
                selectioney=maxey;

            },
            //合并单元格
            mergeSelection:function(){
                var that=this;
                var imageicon=$(".imageicons");
                var tdtemp;
                var mergecellitems=[];
                var colspan=~~selectionex-~~selectionsx+1;
                var rowspan=~~selectioney-~~selectionsy+1;
                for(var i=selectionsx;i<=selectionex;i++)
                    for(var j=selectionsy;j<=selectioney;j++){
                        if(i!==selectionsx  ||  j!==selectionsy){
                            tdtemp=$("td[coord='"+i+","+j+"']");
                            if(tdtemp.length>0){
                                // tdtemp.remove();
                                tdtemp.hide();
                                tdtemp.attr("rowspan","1");
                                tdtemp.attr("colspan","1");
                                //添加合并节点
                                mergecellitems.push(i+","+j);
                            }
                        }
                    }
                //缓存合并的节点
                cellmergeinfo[selectionsx+","+selectionsy]=mergecellitems;

                tdtemp= $("td[coord='"+selectionsx+","+selectionsy+"']");
                tdtemp.attr("colspan",colspan);
                tdtemp.attr("rowspan",rowspan);
                //图片默认宽度
                var totalwidth=33;
                imageicon.find(".mergeicon").hide();
                imageicon.find(".splitall").show();
                if(colspan>1){
                    totalwidth+=33;
                    imageicon.find(".vsplit").show();
                } else
                    imageicon.find(".vsplit").hide();
                if(rowspan>1)     {
                    totalwidth+=33;
                    imageicon.find(".hsplit").show();
                }
                else
                imageicon.find(".hsplit").hide();

              //  imageicon.css("left",(imageicon.position().left-52)+'px');
                imageicon.css("left",(tdtemp.position().left+tdtemp.width()/2-totalwidth/2)+'px');
            },
            //拆分所有
            splitAll:function(){
                var imageicon=$(".imageicons");
                var tdtemp;
                var restoreitems=cellmergeinfo[selectionsx+","+selectionsy];
                for(var i=0;i<restoreitems.length;i++){
                    tdtemp=$("td[coord='"+restoreitems[i]+"']");
                    tdtemp.show();
                }
                tdtemp=$("td[coord='"+selectionsx+","+selectionsy+"']");
                tdtemp.attr("colspan","1");
                tdtemp.attr("rowspan","1");

                tdtemp.trigger("click");

                imageicon.find(".mergeicon").show();
                imageicon.find(".splitall").hide();
                imageicon.find(".hsplit").hide();
                imageicon.find(".vsplit").hide();
                imageicon.css("left",(imageicon.position().left+52)+'px');
                //移除存储的数据
                delete  cellmergeinfo[selectionsx+","+selectionsy];
            },
            //水平拆分
            hsplit:function(){
                var tdtemp,tdfirst;
                var restoreitems=cellmergeinfo[selectionsx+","+selectionsy];
                tdtemp=$("td[coord='"+selectionsx+","+selectionsy+"']");
                tdfirst=tdtemp;
                tdtemp.attr("rowspan","1");
                var colspan= tdtemp.attr("colspan");
                var restorex;
                var restorey;
                for(var i=0;i<restoreitems.length;i++){
                    //获取恢复节点的水平坐标
                    restorex=restoreitems[i].split(",")[0];
                    restorey=restoreitems[i].split(",")[1];
                    if(restorex===selectionsx || restorex==selectionsx){
                        tdtemp=$("td[coord='"+restoreitems[i]+"']");
                        tdtemp.attr("colspan",colspan);
                        tdtemp.show();
                        //并添加合并节点
                        if(colspan!=undefined && colspan>1){
                            cellmergeinfo[restoreitems[i]]=[];
                            for(var j=0;j<=colspan-1;j++){
                                cellmergeinfo[restoreitems[i]].push((~~restorex+j)+","+restorey);
                            }
                        }
                    }
                }
                tdfirst.trigger("click");
            },
            //垂直拆分
            vsplit:function(){
                var tdtemp,tdfirst;
                var restoreitems=cellmergeinfo[selectionsx+","+selectionsy];
                tdtemp=$("td[coord='"+selectionsx+","+selectionsy+"']");
                tdfirst=tdtemp;
                tdtemp.attr("colspan","1");
                var rowspan= tdtemp.attr("rowspan");
                var restorey;
                var restorex;
                for(var i=0;i<restoreitems.length;i++){
                    //获取恢复节点的水平坐标
                    restorex=restoreitems[i].split(",")[0];
                    restorey=restoreitems[i].split(",")[1];
                    if(restorey===selectionsy || restorey==selectionsy ){
                        tdtemp=$("td[coord='"+restoreitems[i]+"']");
                        tdtemp.attr("rowspan",rowspan);
                        tdtemp.show();
                        //添加合并
                        if(rowspan!=undefined && rowspan>1){
                            cellmergeinfo[restoreitems[i]]=[];
                            for(var j=0;j<=rowspan-1;j++){
                                cellmergeinfo[restoreitems[i]].push(restorex+","+(~~restorey+j));
                            }
                        }
                    }
                }
                tdfirst.trigger("click");
            },
            //获取选区
            bindMergeEvent: function () {
                var that = this;

                $(".layoutcontainer").disableSelection();
               // $(document.body).disableSelection();
                $(".imageicons").disableSelection();

                $(window).resize(function (e) {
                    e.stopPropagation();
                    that.caculateSelection();
                });

                //合并单元格
                $(".mergeicon").click(function(e){
                    that.mergeSelection();
                    e.stopPropagation();
                }) ;
                //拆分所有
                $(".splitall").click(function(e){
                    that.splitAll();
                    e.stopPropagation();
                });

                //横向拆分
                $(".hsplit").click(function(e){
                    that.hsplit();
                    e.stopPropagation();
                });

                //垂直拆分
                $(".vsplit").click(function(e){
                    that.vsplit();
                    e.stopPropagation();
                });

                //点击事件
                $(".layouttable").delegate('td', 'click', function (e) {
                    var current = $(this);
                    var coords=current.attr("coord").split(",");
                    selectionsx=coords[0];
                    selectionsy=coords[1];
                    var position = current.position();
                    var left = position.left;
                    var top = position.top;
                    var width = current.outerWidth();
                    var height = current.outerHeight();
                    that.generatorSelection(left, top, width, height);
                    e.stopPropagation();
                });

                //计算是否呈现可拖拽
                function  caculateMoveFlag(e){
                    //当前的单元格
                    var currenttd=$(e.target);
                    //边缘单元格不能拖动
                    if(currenttd.attr("coord")===undefined)
                        return;
                    var coordx=currenttd.attr("coord").split(",")[0];
                    var offset=currenttd.offset();
                    var left=offset.left+currenttd.width();
                    var clientx=e.clientX;
                    if(clientx>=left-dragrange  &&  clientx<=left+dragrange && coordx!=='3'){
                        $(".layouttable").css("cursor","e-resize");
                    }else{
                        $(".layouttable").css("cursor","pointer");
                    }
                }

                //小数转百分数
                function cacultePci(data){
                    data=data+"";
                    var datastr=data.substr(2);
                    return datastr.substring(0,2)+"."+datastr.substr(2)+"%";
                }

                //计算表头宽度
                function caculateThWidth(e){
                    var colspan=resizecontainer.attr("colspan");
                    var coordx=resizecontainer.attr("coord").split(",")[0];
                    if(colspan!==undefined){
                        coordx=~~coordx+~~colspan-1;
                    }
                    var th=$("th[coord='"+coordx+",-1']");
                    var thnext=$("th[coord='"+(~~coordx+1)+",-1']");
                    var distance= e.clientX-(resizecontainer.offset().left+resizecontainer.width());
                    var thwidth=th.width();
                    var thnextwidth=thnext.width();
                    if(thwidth<5){
                        thwidth=10;
                        resizeflag=false;
                    }
                    if(thnextwidth<5){
                        thnextwidth=10;
                        resizeflag=false;
                    }
                    //计算百分比
                    th.css("width",cacultePci((thwidth+distance)/layouttablewidth));
                    thnext.css("width",cacultePci((thnextwidth-distance)/layouttablewidth));
                }

                $(".layouttable").on('mousedown', function (e) {
                    var currenttable=$(this);
                    var mousestyle=currenttable.css("cursor");
                    var current = $(e.target);
                    //鼠标样式
                    if(mousestyle==='e-resize'){
                        resizeflag=true;
                        resizecontainer=current;
                    }

                    //选区开始单元格
                    startcoord = current.attr("coord");
                    moveflag = true;
                    e.stopPropagation();
                });
                $(".layouttable").on('mousemove', function (e) {

                    if(resizeflag){
                        caculateThWidth(e);
                        return;
                    }else{
                        caculateMoveFlag(e);
                    }

                    if (moveflag) {
                        var target = $(e.target);
                        endcoord = target.attr("coord");
                        that.caculateSelection();
                    }
                    e.preventDefault();
                    e.stopPropagation();
                });
                $(".layouttable").on('mouseup', function (e) {
                    var target = $(e.target);
                    endcoord = target.attr("coord");
                    moveflag = false;
                    if(resizeflag!==true)
                        that.caculateSelection();
                    resizeflag=false;
                    e.stopPropagation();
                });
                //存储布局文件
            },saveLayout:function(){
                //主要存储表单和合并单元格的信息
                var params={},layouthtml="",tdtemp,tds,layout_dialog;
                params.layoutid=$("input[name='layoutid']").val();
                params.layoutname=$("input[name='layoutname']").val();
                params.layoutdesc=$("input[name='layoutdesc']").val();
                var allowareas=[];
                var allowarea="";
                var tableclone=$(".layouttable").clone();
                tds=tableclone.find("td");
                var count=0;
                for(var i=0;i<tds.length;i++){
                    tdtemp=$(tds[i]);
                    if(tdtemp.css("display")!=='none'){
                        allowarea=lettersall[count++];//单元格标识连续
                        allowareas.push(allowarea);
                        tdtemp.html("${elements_"+allowarea+"}");
                    }
                }
                params.layouttemplate=$("<div></div>").append(tableclone).html();
                params.layouttable=$("<div></div>").append($(".layouttable").clone()).html();
                params.cellmergeinfo=JSON.stringify(cellmergeinfo);

                if(params.layoutid!=='' && params.layoutid !== undefined){
                    var checkparam={};
                    checkparam.layoutid=params.layoutid;
                    checkparam.allowarea=allowareas.join(",");
                    $.ajax({
                        data: checkparam,
                        type: "POST",
                        url: "/page/layoutdesign/pages/savecheck.jsp",
                        timeout: 20000,
                        dataType: 'json',
                        success: function(rs){
                            //未涉及元素的丢失且该布局无相关的门户页面,则直接存储
                            if(rs.islostel==='0'  &&  rs.reapages==='0'){
                                postLayout();
                            }else{
                                var remindmsg=getShowInfo(rs);
                                layout_dialog = new window.top.Dialog();
                                layout_dialog.currentWindow = window;   //传入当前window
                                layout_dialog.Width = 300;
                                layout_dialog.Height = 100;
                                layout_dialog.Modal = true;
                                layout_dialog.Title = SystemEnv.getHtmlNoteName(3621,lang);
                                layout_dialog.InnerHtml=remindmsg;
                                layout_dialog.OKEvent=function(){
                                    //关闭窗口
                                    layout_dialog.close();
                                    //存储布局
                                    postLayout();

                                }
                                layout_dialog.show();
                                layout_dialog.okButton.value=SystemEnv.getHtmlNoteName(3622,lang);
                                bindevent(params.layoutid);
                            }
                        },fail:function(){
                            window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3623,lang));
                        }
                    });

                }else{
                    //存储布局
                    postLayout();
                }

                function bindevent(layoutid){
                    var item=$(window.top.document).find(".pagedetail");
                    if(item.length===0){
                        setTimeout(function(){bindevent(layoutid);},500);
                    }else{
                        item.on("click",function(){
                            var layout_dialog = new window.top.Dialog();
                            layout_dialog.currentWindow = window;   //传入当前window
                            layout_dialog.Width = 800;
                            layout_dialog.Height = 600;
                            layout_dialog.Modal = true;
                            layout_dialog.maxiumnable=true;
                            layout_dialog.Title = SystemEnv.getHtmlNoteName(3624,lang);
                            layout_dialog.URL = "/page/maint/layout/LayoutRelatedHomepage.jsp?method=show&layoutid="+layoutid;
                            layout_dialog.show();
                        });
                    }

                }

                //获取提示信息
                function  getShowInfo(rs){
                    var msg="";
                    var reapages=~~rs.reapages;
                    var islostel=rs.islostel;
                    if(rs.islostel==='1' &&  reapages>0){
                        msg="<div style='text-align:center;font-size:12px;padding-top: 40px;font-family: '微软雅黑';'>"+SystemEnv.getHtmlNoteName(3625,lang)+" <b><a class='pagedetail' style='color:red;font-size: 14px;' href='#'>"+reapages+"</a></b> "+SystemEnv.getHtmlNoteName(3628,lang)+"!</div>";
                    }else if(rs.islostel==='1'){
                        msg="<div style='text-align:center;font-size:12px;padding-top: 40px;font-family: '微软雅黑';'>"+SystemEnv.getHtmlNoteName(3626,lang)+"</div>";
                    }else {
                        msg="<div style='text-align:center;font-size:12px;padding-top: 40px;font-family: '微软雅黑';'>"+SystemEnv.getHtmlNoteName(3627,lang)+" <b><a class='pagedetail' style='color:red;font-size: 14px;' href='#'>"+reapages+"</a></b> "+SystemEnv.getHtmlNoteName(3628,lang)+"!</div>";
                    }
                    return msg;
                }

                function  postLayout(){
                    $.ajax({
                        data: params,
                        type: "POST",
                        url: "/page/layoutdesign/pages/saveitems.jsp",
                        timeout: 20000,
                        dataType: 'json',
                        success: function(rs){
                            if(rs.success==='0'){
                                window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3623,lang));
                            }else{
                                window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3629,lang));
                                if($("input[name='layoutid']").val() == ""){//刷新当前页
                                    window.location.href="layoutdesign.jsp?layoutid="+rs.success;
                                }
                                //刷新父界面
                                parent.getParentWindow(window).location.reload();

                            }
                        },fail:function(){
                            window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3623,lang));
                        }
                    });

                }

                //恢复布局
            },reciverLayout:function(layout){
                var layouttable=$(layout.tableinfo);
                cellmergeinfo=layout.cellmergeinfo;
                $(".layouttable").remove();
                $(".layouttablewrapper").append(layouttable);
                this.bindMergeEvent();
            }
        }

    })();

})();