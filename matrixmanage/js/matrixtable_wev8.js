/**
 * Created with JetBrains WebStorm.
 * User: Administrator
 * Date: 14-9-15
 * Time: 上午11:05
 * To change this template use File | Settings | File Templates.
 */
var matrixtable=function(){
    
    //改变选中状态
	function changeCheckboxStatus(obj,checked){
		if(checked==true||checked==false){
			jQuery(obj).attr("checked",checked);
		}
		if(checked){
			jQuery(obj).next("span.jNiceCheckbox").addClass("jNiceChecked");
		}else{
			jQuery(obj).next("span.jNiceCheckbox").removeClass("jNiceChecked");
		}
	}
	
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

    this.fieldinfo="";

    //多选按钮id
    var buttonwithmore=['17','18','37','257','57','65','194','240','135','152','162','166','168','170'];

    return {

        //初始化矩阵表单
        initMatrixTable:function(fieldjson){
            var that=this;
            initPaperChange(1);
            //生成表头
            this.generatorTableHead(fieldjson);
            //设置列信息
            this.fieldinfo=fieldjson;


            $(document.body).click(function(e){
                var target=$(e.target);
                if(target.parents(".searchitems").length===0 &&  $(".searchitems").is(":visible")===true){
                    $(".searchitems").hide();
                }
            });

            //提交查询
            $(".qseachbtn").find(".btn_submit").click(function(){
                var input=$(".searchitems").find("input[type='hidden']");
                var fieldname=input.attr("name");
                var fieldvalue=input.val();
                searchparams.params["qfieldname"]= fieldname;
                searchparams.params["qfieldvalue"]= fieldvalue;
                initPaperChange(1);
                $(".searchitems").hide();
            }) ;

            $(".addrow").click(function(){
                that.insertARow();
            });
            //删除数据
            $(".deleteitems").click(function(){
                that.removeItems();
            }) ;
            $(".savecurrent").click(function(){
            	var languageid=readCookie("languageidweaver");
                //回传参数
                var param=that.getSaveParams();
                $.ajax({
                    data: param,
                    type: "POST",
                    url: "/matrixmanage/pages/savetablerecords.jsp",
                    timeout: 20000,
                    dataType: 'json',
                    success: function(rs){
                        //存储成功
                        if(rs.success==='1'){
                            searchparams.params={};
                            that.refreshCurrentPage();
                            //如果checkall选中  需关闭 
                            var checkall = $("input[name='checkall']");
                            if(checkall.is(":checked")){
                               changeCheckboxStatus(checkall[0],false);
                            }
                            window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4010,languageid));
                            //保存失败
                        }else if(rs.success === '2'){
                            window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4059,languageid));
                        }else{
                            window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4011,languageid));
                        }
                    },fail:function(){
                        window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4011,languageid));
                    }
                });

            });

            $(".pagetbody").scroll(function(){
                 var left=$(".pagetbody").scrollLeft();
                 $(".searchitems").hide();
                 $(".pagethead").scrollLeft(left);

            });


            //保存表单数据
        },saveTableData:function(){
            var that=this;
            //回传参数
            var param=that.getSaveParams();
            var languageid=readCookie("languageidweaver");
            that.addLoadingItem();
            $.ajax({
                data: param,
                type: "POST",
                url: "/matrixmanage/pages/savetablerecords.jsp",
                timeout: 20000,
                dataType: 'json',
                success: function(rs){
                    that.removeLoadingItem();
                    //保存成功
                    if(rs.success==='1'){
                        searchparams.params={};
                        that.refreshCurrentPage();
                        //如果checkall选中  需关闭 
                        var checkall = $("input[name='checkall']");
                        if(checkall.is(":checked")){
                           changeCheckboxStatus(checkall[0],false);
                        }
                         window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3657,languageid));
                        //保存失败
                    }else{
                        window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3658,languageid));
                    }
                },fail:function(){
                     window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3659,languageid));
                }
            });
            //刷新页面
        },refreshCurrentPage:function(){
            var currenpage=$("#div_pager").find(".curr").html();
            var topage;
            if($(".pagetable tbody").find("tr").length>0){
                topage= currenpage;
            }else if(currenpage>1){
                topage=currenpage-1;
            }
            initPaperChange(topage);

            //生成表头
        },generatorTableHead:function(fieldjson){
            var that=this;
            var languageid=readCookie("languageidweaver");
            //区域一表头(匹配区域)
            var thead=$(".pagetbody").find(".pagetable").find("thead");
            var headstr=[];
            var sumwidth=0;
            var checkStr = '';
            	if(issystem == '' && canedit == 'true' ){
            	   checkStr = "<th  style='border-right: 1px solid #f0f0f0; width: 35px;background: #ffffff;'><input type='checkbox' name='checkall' ></th>";
            	}
            headstr.push(checkStr+"<th class='dataorder' style='background: #ffffff;'>"+SystemEnv.getHtmlNoteName(4054,languageid)+"</th>");
            for(var i=0;i<fieldjson.length;i++){
                //匹配区域
                if(fieldjson[i].type==='0') {
                    headstr.push("<th title='"+SystemEnv.getHtmlNoteName(4060,languageid)+"' class='matchcol' fieldname='"+fieldjson[i].fieldlable+"' iscusttype='"+fieldjson[i].iscusttype+"' browserval='"+fieldjson[i].typeid+"'   browsertype='"+fieldjson[i].htmltype+"'  style='min-width: 100px;'><div style='position: relative'><span style='margin-right:20px;'>"+fieldjson[i].namelabel+"</span><img class='arrow' src='../images/yellowarrow_wev8.png'></div></th>");
                    sumwidth+=~~fieldjson[i].width;
                }else if(fieldjson[i].type==='1'){
                    headstr.push("<th title='"+SystemEnv.getHtmlNoteName(4060,languageid)+"' class='selectcol'fieldname='"+fieldjson[i].fieldlable+"' iscusttype='"+fieldjson[i].iscusttype+"' browserval='"+fieldjson[i].typeid+"'   browsertype='"+fieldjson[i].htmltype+"' style='min-width: 100px;'><div style='position: relative'><span style='margin-right:20px;'>"+fieldjson[i].namelabel+"</span><img class='arrow' src='../images/bluearrow_wev8.png'></div></th>");
                    sumwidth+=~~fieldjson[i].width;
                }

            }
            headstr.push("<th style='background: #ffffff;width: 18px;'></th>");
            thead.html(headstr.join(""));

            thead.find("input[name='checkall']").click(function(e){

                var current=$(this);
                var checkitems=$(".pagetbody").find(".pagetable").find("input[name='checkitem']");
                if(current.is(":checked")){
                    for(var i=0;i<checkitems.length;i++){
                        changeCheckboxStatus(checkitems[i],true);
                    }
                }else{
                    for(var i=0;i<checkitems.length;i++){
                        changeCheckboxStatus(checkitems[i],false);
                    }
                }
                e.stopPropagation();
            });
            //匹配区域点击查询
            thead.delegate('th','click',function(e){
                var currenttd=$(this);
                if(currenttd.hasClass("dataorder") || currenttd.find("input[name='checkall']").length===1 )
                    return;
                var pcontainer=$(".searchitems");
                var offset= currenttd.offset();
                var browcontainer=pcontainer.find(".searchbrowser");
                browcontainer.html("");
                pcontainer.css("width",currenttd.width()+"px");
                pcontainer.css("left",(offset.left+$(".pagewrapper").scrollLeft())+"px");
                pcontainer.css("top",(offset.top+30)+"px");
                pcontainer.show();
                //字段名
                var fieldlabel=currenttd.attr("fieldname");
                var htmltype=currenttd.attr("browsertype");
                var typeid= currenttd.attr("browserval");
                var fieldid= currenttd.attr("browserid");
                //获取浏览框url
                if(htmltype == "1"){
                	htmltype = "17";
                }else if(htmltype == "4"){
                	htmltype = "57";
                }else if(htmltype == "164"){
                	htmltype = "194";
                }else if(htmltype == "7"){
                	htmltype = "18";
                }else if(htmltype == "8"){
                	htmltype = "135";
                }else if(htmltype == "161"){
                	htmltype = "162";
                }else if(htmltype == '24'){  //缺少岗位多选
                	htmltype = "278";
                }
                if(isoutusermatrix=="1"&&htmltype=="17")htmltype="1";
                var url=browserjson[htmltype];
                that.generatorBrowser(browcontainer,fieldlabel,url,htmltype,fieldid,"","",typeid);
                e.stopPropagation();
            }) ;
            //设置table外围容器宽度
            //$(".pagethead").find(".pagetable").css("width",sumwidth+"px");
            //$(".pagetbody").find(".pagetable").css("width",sumwidth+"px");
            //生成表单数据
        },generatorTableBody:function(rs){
            var that=this;
            //匹配区域表体
            var tbody=$(".pagetbody").find(".pagetable").find("tbody");
            //设置宽度
            //$(".pagetbody").find(".pagetable").css("width",($(".pagethead").find(".pagetable").width()-18)+'px');
            tbody.html("");
            var trstr;
            var fiedlabel, ftype, spanval;
            //匹配
            var trstrs=[];
            var remindclass="";
            for(var i= 0,len=rs.length;i<len;i++){
            	var checkStr = '';
            	var serieTitle = "";
            	if(issystem == '' && canedit == 'true' ){
            	   checkStr = "<td style='min-width: 35px;'><input type='checkbox' name='checkitem'></td>";
            	}else{
            		serieTitle = " title = '' ";
            	}
                trstr=[];
                trstr.push("<tr>");
                trstr.push(checkStr+"<td id='isnotsystem' class='dataorder' style='width:50px;' "+serieTitle+"><span class='serienum' style='display:inline-block;overflow:hidden;min-width:50px;'>"+rs[i]["dataorder"]+"</span><span class='serieinput' style='display: none'><input value='"+rs[i]["dataorder"]+"' name='serienum' style='width:26px'></span><input type='hidden' name='uuid' value='"+rs[i].uuid+"'></td>");
                for(var j= 0,collen=this.fieldinfo.length;j<collen;j++){
                    remindclass="";
                    fiedlabel=this.fieldinfo[j].fieldlable;
                    ftype = this.fieldinfo[j].htmltype; 
                    
                    if(ftype === "1"){
                       spanval = "<a onclick=\"window.open('/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+rs[i][fiedlabel]+"')\"  style='display:inline-block;overflow:hidden;'>"+rs[i][fiedlabel+"_name"]+"</a>";	
                    }else if(ftype === "17"){
                       	var values = rs[i][fiedlabel+"_name"].split(",") ,
                       	    ids = rs[i][fiedlabel].split(","), 
                       	    htmlarray = [];
                       	for(var m=0;m<values.length;m++){
                       		htmlarray.push("<a onclick=\"window.open('/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+ids[m]+"')\"  style='display:inline-block;overflow:hidden;'>"+values[m]+"</a>");
                       	}
                       	spanval = htmlarray.join(",");
                    }else if(ftype === "164"){
                        spanval = "<a onclick=\"window.open('/hrm/HrmTab.jsp?_fromURL=HrmSubCompanyDsp&hasTree=false&id="+rs[i][fiedlabel]+"')\"  style='display:inline-block;overflow:hidden;'>"+rs[i][fiedlabel+"_name"]+"</a>";	
                    }else if(ftype === "4"){
                        spanval = "<a onclick=\"window.open('/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp&hasTree=&id="+rs[i][fiedlabel]+"')\"  style='display:inline-block;overflow:hidden;'>"+rs[i][fiedlabel+"_name"]+"</a>";	
                    }else{
                       spanval = rs[i][fiedlabel+"_name"];
                    }
                    
                    //如果字段的值为空,则需预警
                    if(rs[i][fiedlabel+"_name"]===''){
                        remindclass="notnullremind";
                    }
                    //匹配项
                    if(this.fieldinfo[j].type==='0'){
                    	var noshowtitle = " id='isnotsystem' ";
                    	if(canedit == 'true'){
	                        if(issystem != ''){
	                        	if(fiedlabel == 'id'){
		                        	noshowtitle = " title='"+rs[i]['title']+"' ";
	                        	}
	                        }
                        }else{
                      		if(issystem != ''){
	                        	if(fiedlabel == 'id'){
		                        	noshowtitle = " title='"+rs[i]['title']+"' ";
	                        	}
	                        }else{
	                        	noshowtitle = " title='' ";
	                        }
                        }
                        trstr.push("<td "+noshowtitle+" class='matchtd "+remindclass+"' fieldname='"+fiedlabel+"' iscusttype='"+this.fieldinfo[j].iscusttype+"' browserval='"+this.fieldinfo[j].typeid+"'  browserid='"+rs[i][fiedlabel]+"' style='width:"+this.fieldinfo[j].width+"px;padding:8px 8px'   browsertype='"+this.fieldinfo[j].htmltype+"' ><span class='browval'>"+spanval+"</span><span class='brow'></span></td>");
                        //选择项
                    }else if(this.fieldinfo[j].type==='1') {
                    	var noshowtitle = " id='isnotsystem' ";
                    	if(canedit == 'false'){
                        	noshowtitle = " title='' ";
                        }
                        trstr.push("<td "+noshowtitle+" class='selecttd "+remindclass+"' fieldname='"+fiedlabel+"' iscusttype='"+this.fieldinfo[j].iscusttype+"' browserval='"+this.fieldinfo[j].typeid+"' browserid='"+rs[i][fiedlabel]+"' style='width:"+this.fieldinfo[j].width+"px;padding:8px 8px'    browsertype='"+this.fieldinfo[j].htmltype+"' ><span class='browval'>"+spanval+"</span><span class='brow'></span></td>");
                    }
                }
                trstr.push("</tr>");
                //添加一行匹配数据
                trstrs.push(trstr.join(""));
            }
            tbody.html(trstrs.join(""));
            //选中最后一行
            tbody.find("tr").eq(rs.length-1).find(".dataorder").addClass("selectrow");

            //td双击可编辑
            function tddblclick(){
                var currenttd=$(this);
                //双击序列号
                if(currenttd.hasClass("dataorder")){
                  if(issystem == ''){
                    currenttd.find(".serienum").hide();
                    currenttd.find(".serieinput").show();
                  }
                }else{
                    currenttd.find(".browval").hide();
                    var browcontainer=currenttd.find(".brow");
                    //字段名
                    var fieldlabel=currenttd.attr("fieldname");
                    var htmltype=currenttd.attr("browsertype");
                    var fieldid=currenttd.attr("browserid");
                    var typeid=currenttd.attr("browserval");
                    var fieldspanname=currenttd.find(".browval").html();
                    var fieldwidth=currenttd.width();
                    //获取浏览框url
                    if(isoutusermatrix=="1"&&htmltype=="17")htmltype="1";
                    var url=browserjson[htmltype];
                    that.generatorBrowser(browcontainer,fieldlabel,url,htmltype,fieldid,fieldspanname,fieldwidth-8,typeid);
                    $("#autofocus").focus();
                }
            }
			if(canedit == 'true'){
	            //td双击(匹配区域)
	            tbody.delegate("#isnotsystem",'dblclick',tddblclick);
            }
            
            
			if(issystem == ''){
	            //行选中
	            tbody.delegate(".dataorder",'click',function(){
	                tbody.find(".selectrow").removeClass("selectrow");
	                $(this).addClass("selectrow");
	            });
            }
            
            jQuery('.pagewrapper').jNice();

            //生成浏览框
        },generatorBrowser:function(browcontainer,name,url,htmltype,fieldid,fieldspanname,fieldwidth,typeid){
        	if(fieldid == 0 || fieldid == "0"){
				if(htmltype==='161' ||  htmltype===161 || htmltype==='162'  ||  htmltype===162){
				}else{
					fieldid = "";		
				}
        		
        	}
            //是否为单选
            var issignal=this.isMore(htmltype);
            if(htmltype==='17'){
            	url = url+"?selectedids=#id#";
            }
            //自定义单选
            if(htmltype==='161' ||  htmltype===161){
                url="/systeminfo/BrowserMain.jsp?url=/interface/CommonBrowser.jsp?type="+typeid;
                htmltype += "&fielddbtype="+typeid;
                //自定义多选
            }else if(htmltype==='162'  ||  htmltype===162){
                url="/systeminfo/BrowserMain.jsp?url=/interface/MultiCommonBrowser.jsp?type="+typeid+"&selectedids=#id#";
                 htmltype += "&fielddbtype="+typeid;
            }
            browcontainer.e8Browser({
                name:name,
                viewType:"0",
                width:fieldwidth+'px',
                browserValue:fieldid,
                isMustInput:"1",
                browserSpanValue:fieldspanname,
                hasInput:true,
                linkUrl:"#",
                completeUrl:"/data.jsp?type="+htmltype,
                browserUrl:url,
                hasAdd:false,
                isSingle:issignal
            });

           browcontainer.removeData("_autocomplete");
        //获取选中行
        },getSelectIndex:function(){
            var tbody=$(".regionthree").find(".pagetable").find("tbody");
            var trs=tbody.find("tr");
            var tr;
            for(var i=0;i<trs.length;i++){
                  tr=$(trs[i]);
                  if(tr.find(".selectrow").length>0){
                      return i;
                  }
            }
            return 0;
            //新增一行
        },insertARow:function(){
            var that=this;
            var url;
            //匹配区域表体
            var tbody=$(".pagetbody").find(".pagetable").find("tbody");
            var tr=$("<tr></tr>");
            var trindex=that.getSelectIndex();
            var selectrow=tbody.find(".selectrow").parent();
            var dataordernum=0;
            if(selectrow.length===0){
                tbody.append(tr);
                dataordernum=(kkpager.pno-1)*(KD_PAGESIZE)+1;
            }else{
                tr.insertAfter(selectrow);
                dataordernum=selectrow.find(".selectrow .serienum").html();
            }
            var td=$("<td width='35px'><input type='checkbox' name='checkitem'></td>");
            tr.append(td);
            td=$("<td class='dataorder' width='50px'><span class='serienum' style='display: none'>"+dataordernum+"</span><span class='serieinput' ><input value='' name='serienum' style='width:26px'></span><input type='hidden' name='uuid'></td>");
            tr.append(td);
            if(selectrow.length===0){
                //行选中
                tbody.delegate(".dataorder",'click',function(){
                    tbody.find(".selectrow").removeClass("selectrow");
                    $(this).addClass("selectrow");
                });
            }
            td.trigger("click");
            var fiedlabel;
            var htmltype;
            for(var j= 0,collen=this.fieldinfo.length;j<collen;j++){
                fiedlabel=this.fieldinfo[j].fieldlable;
                htmltype=this.fieldinfo[j].htmltype;
                //匹配项
                if(this.fieldinfo[j].type==='0'){
                    td=$("<td class='matchtd' fieldname='"+fiedlabel+"' style='width:"+this.fieldinfo[j].width+"px' iscusttype='"+this.fieldinfo[j].iscusttype+"' browserval='"+this.fieldinfo[j].typeid+"'  browserid=''   browsertype='"+this.fieldinfo[j].htmltype+"' ><span class='browval'></span><span class='brow'></span></td>");
                    tr.append(td);
                    //选择项
                }else if(this.fieldinfo[j].type==='1') {
                    td=$("<td class='selecttd' fieldname='"+fiedlabel+"' style='width:"+this.fieldinfo[j].width+"px' iscusttype='"+this.fieldinfo[j].iscusttype+"' browserval='"+this.fieldinfo[j].typeid+"' browserid=''   browsertype='"+this.fieldinfo[j].htmltype+"' ><span class='browval'></span><span class='brow'></span></td>");
                    tr.append(td);
                }
                td.find(".browval").hide();
                if(isoutusermatrix=="1"&&htmltype=="17")htmltype="1";
                url=browserjson[htmltype];
                if(htmltype === '161' || htmltype === 161 || htmltype === '162' || htmltype === 162){
                	that.generatorBrowser(td.find(".brow"),fiedlabel,url,htmltype,"","",this.fieldinfo[j].width-8,this.fieldinfo[j].typeid);
                }else
                //生成浏览框
                that.generatorBrowser(td.find(".brow"),fiedlabel,url,htmltype,"","",this.fieldinfo[j].width-8,"");
            }
            //美化check框
            tr.jNice();
            //获取保存的参数
        },getSaveParams:function(){
            var tbody=$(".pagetbody").find(".pagetable").find("tbody");
            var matrixid=$(".pagewrapper").find("input[name='matrixid']").val();
            //匹配区域
            var trs=tbody.find("tr");
            var tds;
            var td;
            var param;
            var fieldname;
            var fieldval;
            param={};
            //设置矩阵id
            param["matrixid"]=matrixid;
            //设置数据条数
            param["recordnum"]=trs.length;

            //添加匹配区域值
            for(var i= 0,len=trs.length;i<len;i++){
                tds=$(trs[i]).find("td");
                for(var j= 0,tdlen=tds.length;j<tdlen;j++){
                    td=$(tds[j]);
                    //获取uuid和序列号
                    if(td.hasClass("dataorder")){
                        fieldname="dataorder";
                        fieldval=td.find(".serieinput").find("input[name='serienum']").val();
                        param[fieldname+"_"+i]=fieldval;
                        fieldname="uuid";
                        fieldval=td.find("input[type='hidden'][name='uuid']").val();
                        param[fieldname+"_"+i]=fieldval;
                        //获取动态列的字段名称字段值
                    }else{
                        fieldname=td.attr("fieldname");
                        if(td.find(".browval").is(":visible")){
                            fieldval=td.attr("browserid");
                        }else{
                            fieldval=td.find("input[name='"+fieldname+"']").val();
                        }
                        param[fieldname+"_"+i]=fieldval;
                    }
                }
            }
            return   param;
            //添加加载进度条
        },addLoadingItem:function(){
            var container=$(".pagewrapper");
            var loadingdiv=$("<div class='loadingicon' style='position: absolute;width: 16px;height: 16px;'><img src='../images/loading_wev8.gif'></div>");
            loadingdiv.css("left",(container.width()/2-8)+'px');
            loadingdiv.css("top",(container.height()/2-8)+'px');
            container.append(loadingdiv);
            //移除图标
        },removeLoadingItem:function(){
            var container=$(".pagewrapper");
            container.find(".loadingicon").remove();
            //是否多选
        },isMore:function(htmltype){
            //根据浏览框类型，确定是单选或多选
            if(buttonwithmore.contains(htmltype))
                return false;
            return true;
            //删除数据
        },removeItems:function(){
            var that=this;
        	var languageid=readCookie("languageidweaver");
            var deleteuuids=[];
            var trarray=[];
            var checkitems=$(".pagetbody").find("tbody").find("input:checked");
            var uuid;
            var tr;
            if(checkitems.length===0){
                window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3660,languageid));
                return;
            }
            for(var i= 0,len=checkitems.length;i<len;i++){
                tr=$(checkitems[i]).parents("tr");
                uuid=tr.find("input[name='uuid']").val();
                if(""!==uuid){
                    deleteuuids.push(uuid);
                }
                trarray.push(tr);
            }
            if(deleteuuids.length===0){
                for(var i= 0,length=trarray.length;i<len;i++){
                    $(trarray[i]).remove();
                }
                return;
            }else{
                //题型并删除
                Dialog.confirm(SystemEnv.getHtmlNoteName(3580,languageid),function(){
                    var param={};
                    var matrixid=$(".pagewrapper").find("input[name='matrixid']").val();
                    param["matrixid"]=matrixid;
                    param["deleteitems"]=deleteuuids.join(",");
                    $.ajax({
                        data: param,
                        type: "POST",
                        url: "/matrixmanage/pages/deletetabledatas.jsp",
                        timeout: 20000,
                        dataType: 'json',
                        success: function(rs){
                            //处理成功
                            if(rs.success==='1'){
                                that.refreshCurrentPage();
                                window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3661,languageid));
                                //移除数据
                                for(var i= 0,length=trarray.length;i<len;i++){
                                    $(trarray[i]).remove();
                                }
                                //保存失败
                            }else{
                                window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3662,languageid));
                            }
                        },fail:function(){
                            window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3663,languageid));
                        }
                    });
                });

            }
        }
    }

}();
