var languageid=readCookie("languageidweaver");
var kkpager = {
    pagerid : 'div_pager',
    pno : 1,
    total : 1,
    totalRecords : 0,
    isShowTotalPage : false,
    isShowTotalRecords : false,
    isGoPage : false,
    hrefFormer : '',
    hrefLatter : '',
    getLink : function(n){
        if(n == 1){
            return this.hrefFormer + this.hrefLatter;
        }else{
            return this.hrefFormer + '_' + n + this.hrefLatter;
        }
    },
    focus_gopage : function (){
        var btnGo = jQuery('#btn_go');
        jQuery('#btn_go_input').attr('hideFocus',true);
        btnGo.show();
        btnGo.css('left','0px');
        jQuery('#go_page_wrap').css('border-color','#6694E3');
        btnGo.animate({left: '+=30'}, 50,function(){
            //jQuery('#go_page_wrap').css('width','88px');
        });
    },
    blur_gopage : function(){
        setTimeout(function(){
            var btnGo = jQuery('#btn_go');
            btnGo.animate({
                left: '-=44'
            }, 100, function() {
                jQuery('#btn_go').css('left','0px');
                jQuery('#btn_go').hide();
                jQuery('#go_page_wrap').css('border-color','#DFDFDF');
            });
        },400);
    },
    gopage : function(){
        var str_page = jQuery("#btn_go_input").val();
        if(isNaN(str_page)){
            jQuery("#btn_go_input").val(this.next);
            return;
        }
        var n = parseInt(str_page);
        if(n < 1 || n >this.total){
            jQuery("#btn_go_input").val(this.next);
            return;
        }
        flipOver(4,n);
    },
    init : function(config){
        this.pno = isNaN(config.pno) ? 1 : parseInt(config.pno);
        this.total = isNaN(config.total) ? 1 : parseInt(config.total);
        this.totalRecords = isNaN(config.totalRecords) ? 0 : parseInt(config.totalRecords);
        if(config.pagerid){this.pagerid = pagerid;}
        if(config.isShowTotalPage != undefined){this.isShowTotalPage=config.isShowTotalPage;}
        if(config.isShowTotalRecords != undefined){this.isShowTotalRecords=config.isShowTotalRecords;}
        if(config.isGoPage != undefined){this.isGoPage=config.isGoPage;}
        this.hrefFormer = config.hrefFormer || '';
        this.hrefLatter = config.hrefLatter || '';
        if(config.getLink && typeof(config.getLink) == 'function'){this.getLink = config.getLink;}
        if(this.pno < 1) this.pno = 1;
        this.total = (this.total <= 1) ? 1: this.total;
        if(this.pno > this.total) this.pno = this.total;
        this.prv = (this.pno<=2) ? 1 : (this.pno-1);
        this.next = (this.pno >= this.total-1) ? this.total : (this.pno + 1);
        this.hasPrv = (this.pno > 1);
        this.hasNext = (this.pno < this.total);
        this.inited = true;
    },
    generPageHtml : function(){
        if(!this.inited){
            return;
        }

        var str_prv='',str_next='';
        if(this.hasPrv){
            str_prv = '<span style="cursor:pointer;" onclick="flipOver(4,'+this.prv+')" title="'+SystemEnv.getHtmlNoteName(3445,languageid)+'">&lt;</span>';
        }else{
            str_prv = '<span class="disabled">&lt;</span>';
        }

        if(this.hasNext){
            str_next = '<span style="cursor:pointer;" onclick="flipOver(4,'+this.next+')" title="'+SystemEnv.getHtmlNoteName(3446,languageid)+'">&gt;</span>';
        }else{
            str_next = '<span class="disabled">&gt;</span>';
        }
        var str = '';
        var dot = '<span>...</span>';
        var total_info='';
        if(this.isShowTotalPage || this.isShowTotalRecords){
            total_info = '<span class="normalsize">'+SystemEnv.getHtmlNoteName(3586,languageid);
            if(this.isShowTotalPage){
                total_info += this.total+''+SystemEnv.getHtmlNoteName(3526,languageid);
                if(this.isShowTotalRecords){
                    total_info += '&nbsp;/&nbsp;';
                }
            }
            if(this.isShowTotalRecords){
                total_info += this.totalRecords+''+SystemEnv.getHtmlNoteName(4055,languageid);
            }

            total_info += '</span>';
        }

        var gopage_info = '';
        if(this.isGoPage){
            gopage_info = ' <span>'+SystemEnv.getHtmlNoteName(4046,languageid)+'</span><span id="go_page_wrap" style="display:inline-block;width:30px;height:20px;border:1px solid #DFDFDF;margin:-1px 1px;padding:0px;position:relative;left:0px;top:5px;">'+
                '<input type="button" id="btn_go" onclick="kkpager.gopage();" style="width:30px;height:22px;line-height:22px;padding:0px;font-family:arial,宋体,sans-serif;text-align:center;border:0px;background-color:#0063DC;color:#FFF;position:absolute;left:0px;top:-1px;display:none;" value="'+SystemEnv.getHtmlNoteName(3451,languageid)+'" />'+
                '<input type="text" id="btn_go_input" onfocus="kkpager.focus_gopage()" onkeypress="if(event.keyCode<48 || event.keyCode>57)return false;" onblur="kkpager.blur_gopage()" style="width:30px;height:18px;text-align:center;border:0px;position:absolute;left:0px;top:0px;outline:none;" value="'+(this.pno)+'" /></span>&nbsp;'+SystemEnv.getHtmlNoteName(3526,languageid);
        }

        if(this.total <= 8){
            for(var i=1;i<=this.total;i++){
                if(this.pno == i){
                    str += '<span class="curr">'+i+'</span>';
                }else{
                    str += '<span class="flipover" onclick="flipOver(4,'+i+')" title="'+SystemEnv.getHtmlNoteName(3525,languageid)+''+i+''+SystemEnv.getHtmlNoteName(3526,languageid)+'">'+i+'</span>';
                }
            }
        }else{
            if(this.pno <= 5){
                for(var i=1;i<=7;i++){
                    if(this.pno == i){
                        str += '<span class="curr">'+i+'</span>';
                    }else{
                        str += '<span class="flipover" onclick="flipOver(4,'+i+')" title="'+SystemEnv.getHtmlNoteName(3525,languageid)+''+i+''+SystemEnv.getHtmlNoteName(3526,languageid)+'">'+i+'</span>';
                    }
                }
                str += dot;
            }else{
                str += '<span class="flipover" onclick="flipOver(4,1)" title="'+SystemEnv.getHtmlNoteName(3525,languageid)+'1'+SystemEnv.getHtmlNoteName(3526,languageid)+'">1</span>';
                str += '<span class="flipover" onclick="flipOver(4,2)" title="'+SystemEnv.getHtmlNoteName(3525,languageid)+'2'+SystemEnv.getHtmlNoteName(3526,languageid)+'">2</span>';
                str += dot;

                var begin = this.pno - 2;
                var end = this.pno + 2;
                if(end > this.total){
                    end = this.total;
                    begin = end - 4;
                    if(this.pno - begin < 2){
                        begin = begin-1;
                    }
                }else if(end + 1 == this.total){
                    end = this.total;
                }
                for(var i=begin;i<=end;i++){
                    if(this.pno == i){
                        str += '<span class="curr">'+i+'</span>';
                    }else{
                        str += '<span class="flipover" onclick="flipOver(4,'+i+')" title="'+SystemEnv.getHtmlNoteName(3525,languageid)+''+i+''+SystemEnv.getHtmlNoteName(3526,languageid)+'">'+i+'</span>';
                    }
                }
                if(end != this.total){
                    str += dot;
                }
            }
        }

        str = "&nbsp;"+str_prv + str + str_next  + total_info + gopage_info;
        jQuery("#"+this.pagerid).html(str);
    }
};

function getParameter(name) {
    var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|jQuery)");
    var r = window.location.search.substr(1).match(reg);
    if (r!=null) return unescape(r[2]); return null;
}

//分页
function flipOver(sign,topage){
    //console.log("requestLogDataMaxRquestLogId:"+requestLogDataMaxRquestLogId);
    var prePage=jQuery("#prePage").val();
    var allPages=jQuery("#allPages").val();
    if (sign==-1){
        //初始加载
        prePage=1;
        initPaperChange(1);
    }else if(sign==0){
        //首页
        if(prePage<=1){
            return;
        }else{
            prePage=1;
        }
        initPaperChange(prePage);
    }else if(sign==1){
        //上一页
        if(prePage<=1){
            return;
        }else{
            prePage--;
        }
        initPaperChange(prePage);
    }else if(sign==2){
        //下一页
        if(prePage>=allPages||allPages<=1){
            return;
        }else{
            prePage++;
        }
        initPaperChange(prePage);
    }else if(sign==3){
        //尾页
        if(prePage>=allPages||allPages<=1){
            return;
        }else{
            prePage=allPages;
        }
        initPaperChange(prePage);
    }else if(sign==4){
        //跳转
        var page=topage;
        if(page==""||page.length==0){
            return;
        }else if(isNaN(page)){
            return;
        }else if(page<0||page>allPages){
            return ;
        }else {
            prePage=page;
        }
        initPaperChange(topage);
    }


}

var searchparams={};
searchparams.params={};
var KD_PAGESIZE=10;

function initPaperChange(topage)
{
    var totalPage = 0;
    var totalRecords = 0;
    var pageNo = 1;

    if(topage)
        pageNo=topage;
    if(!pageNo){
        pageNo = 1;
    }
    //当前页数
    searchparams.params.pageindex=pageNo;
    //每页条数
    searchparams.params.pagesize=KD_PAGESIZE;
    //矩阵id
    searchparams.params.matrixid=$(".pagewrapper").find("input[name='matrixid']").val();
    //获取矩阵表单数据
    searchparams.url="/matrixmanage/pages/getcolumndata.jsp";

    //分页数据展示
    //添加加载图标
    matrixtable.addLoadingItem();
    $.ajax({
        data: searchparams.params,
        type: "POST",
        url: searchparams.url,
        timeout: 20000,
        dataType: 'json',
        success: function(rs){
    	    if(rs === null){
    	    	 matrixtable.removeLoadingItem();
    	    	 window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4056,languageid));
    	    	 return;
    	    }
            //第一次需计算 总页数 总记录数
            totalRecords=~~rs[0].pagecount;
            if(totalRecords%KD_PAGESIZE===0)
                totalPage=totalRecords/KD_PAGESIZE;
            else
                totalPage=Math.floor(totalRecords/KD_PAGESIZE)+1;
            //移除图标
            matrixtable.removeLoadingItem();
            //如果第一次,则需返回对应的总条数,页数
            //生成分页控件
            kkpager.init({
                pno : pageNo,
                //总页码
                total : totalPage,
                //总数据条数
                totalRecords : totalRecords,
                isShowTotalPage:1,
                isShowTotalRecords:1,
                isGoPage:1,
                //链接前部
                hrefFormer : 'pager_test',
                //链接尾部
                hrefLatter : '.html',
                getLink : function(n){
                    return this.hrefFormer + this.hrefLatter + "?pno="+n;
                }

            });

            //  $("#searchcontent").hide();
            $(".kd_pagecontent").show();
            $("#div_pager").show();
            if(totalRecords===0)   {
            	var pagebody = $(".pagetbody").find(".pagetable");
            	pagebody.find("tbody").html("");
                kkpager.generPageHtml();
                return;
            }

            //根据结果生成条目
            matrixtable.generatorTableBody(rs);
            kkpager.generPageHtml();
			//隐藏搜索框
			$(".searchitems").hide();
        },fail:function(){
            alert(SystemEnv.getHtmlNoteName(3659,languageid));
        }
    });


}

