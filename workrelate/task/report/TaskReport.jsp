<%@ page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<HTML>
    <HEAD>
        <title>任务执行分析</title>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <LINK href="/workrelate/plan/css/report.css" type=text/css rel=STYLESHEET>
        <LINK href="/workrelate/css/showLoading.css" type=text/css rel=STYLESHEET>
        <script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
        <script language="javascript" src="/js/selectDateTime_wev8.js"></script>
        <script type="text/javascript" src="/js/messagejs/simplehrm_wev8.js"></script>
        <script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
        <script language="javascript" src="/workrelate/js/highcharts.js"></script>
        <script language="javascript" src="/workrelate/js/jquery.showLoading.js"></script>
        <link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
				<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
				<%@ include file="/secondwev/common/head.jsp" %>
    </HEAD>
    <%
        Calendar cl = Calendar.getInstance();
        int currYear = cl.get(Calendar.YEAR);
        int currMonth = cl.get(Calendar.MONTH)+1;
        int currDay = cl.get(Calendar.DATE);
        //结束日期
        String endDateStr = currYear + "-" + 
                         (currMonth>=10?currMonth:("0"+currMonth)) + "-" + 
                         (currDay>=10?currDay:("0"+currDay));
        cl.add(Calendar.MONTH, -1);
        int preYear = cl.get(Calendar.YEAR);
        int preMonth = cl.get(Calendar.MONTH)+1;
        int preDay = cl.get(Calendar.DATE);
        //开始日期
        String beginDateStr = preYear + "-" + 
                         (preMonth>=10?preMonth:("0"+preMonth)) + "-" + 
                         (preDay>=10?preDay:("0"+preDay));
    %>
    <BODY>
        <div id="showImgContainer">
            <div id="showImgLeftContr" title="收起图表"></div>
            <div id="imgContainer"></div>
            <div id="showImgRightContr" title="查看图表"></div>
        </div>
        <div id="msg" class="msgcls">请先选择对比数据!</div> 
        <div class="dataconatiner">
        <div class="headerTb">
            <div class="tabbt" name="subOrg"><a>按组织</a></div>
            <div class="tabbt" id="tabworker" name="worker"><a>按人员</a></div>
        </div>
        <!-- 按分部查询条件 -->
        <div id="subSearchContent" style="width:99%;">
            <div style="width:100%;height:34px;border-bottom:1px #ECECEC solid;margin-bottom:10px;">
                <table class="searchtable" cellpadding="0" cellspacing="0" border="0" style="height:100%">
                    <colgroup>
                        <col width="8%"/>
                        <col width="12%"/>
                        <col width="8%"/>
                        <col width="12%"/>
                        <col width="8%"/>
                        <col/>
                        <col width="7%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td class="title">开始时间</td>
                            <td class="value">
                                <div class="timecls" onclick="getMyDate_begin('org_begindate')"><%=beginDateStr %></div>
                                <input type="hidden" id="org_begindate" value="<%=beginDateStr %>" />
                            </td>
                            <td class="title">结束时间</td>
                            <td class="value">
                                <div class="timecls" onclick="getMyDate_begin('org_enddate')"><%=endDateStr %></div>
                                <input type="hidden" id="org_enddate" value="<%=endDateStr %>" /></td>
                            <td class="title">统计对象</td>
                            <td class="value">
                            <input type="checkbox" name="org_persontype" checked="checked" value="1"/>责任人
                            <input type="checkbox" name="org_persontype" value="2"/>参与人
                            <input type="checkbox" name="org_persontype" value="3"/>创建人
                            </td>
                            <td>
                                <div>
                                    <div class="btn1 btn" style="padding: 0px !important" title="搜索" onclick="searchOrg()">搜索</div>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <!-- 按分部查询条件 end -->
        <!-- 按人员查询条件 -->
        <div id="workerSearchContent" style="width:99%;display:none">
           <div style="margin-bottom:10px;border-bottom:1px #ECECEC solid;">
                <table class="searchtable" cellpadding="0" cellspacing="0" border="0">
                    <colgroup>
                        <col width="7%"/>
                        <col width="24%"/>
                        <col width="7%"/>
                        <col width="24%"/>
                        <col width="7%"/>
                        <col width="24%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td class="title">人员</td>
                            <td class="value">
                            	<table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
					                                <select id="workerType">
					                                    <option value="0"></option>
					                                    <option value="3">所有下属</option>
					                                    <option value="2">直线下属</option>
					                                    <option value="1" selected="selected">选择人员</option>
					                                </select>
				                                </td>
                                        <td>
					                                <div id="hrmbrowserid" style="display:inline;width:auto;">
					                                <input class="wuiBrowser" type="hidden" id="hrmids" name="hrmids" value="" _required="no"
					                                                    _displayTemplate="<a href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</a>" 
					                                                    _displayText="" _param="resourceids" 
					                                                    _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
					                                </div>
				                                </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="title">分部</td>
                            <td class="value">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <select id="cpyincludesub">
                                                <option value="3">含子分部</option>
                                                <option value="1">仅本分部</option>
                                                <option value="2">仅子分部</option>
                                            </select>
                                        </td>
                                        <td>
                                            <input class="wuiBrowser" type="hidden" id="worker_subcompanyids" name="worker_subcompanyids" value=""
                                                _displayText="" 
                                                _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp" _param="selectedids" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="title">部门</td>
                            <td>
                                <table style="float:left;height:30px;" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <select id="deptincludesub">
                                                <option value="3">含子部门</option>
                                                <option value="1">仅本部门</option>
                                                <option value="2">仅子部门</option>
                                            </select>
                                        </td>
                                        <td>
                                            <input class="wuiBrowser" type="hidden" id="worker_departmentids" name="worker_departmentids" value=""
                                                _displayText=""
                                                _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp" _param="selectedids" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
           <div style="width:100%;height:34px;border-bottom:1px #ECECEC solid;margin-bottom:10px;">
                <table class="searchtable" cellpadding="0" cellspacing="0" border="0" style="height:100%">
                    <colgroup>
                        <col width="8%"/>
                        <col width="12%"/>
                        <col width="8%"/>
                        <col width="12%"/>
                        <col width="8%"/>
                        <col/>
                        <col width="7%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td class="title">开始时间</td>
                            <td class="value">
                                <div class="timecls" id="worker_begindateDiv" onclick="getMyDate_begin('worker_begindate')"><%=beginDateStr %></div>
                                <input type="hidden" id="worker_begindate" value="<%=beginDateStr %>" />
                            </td>
                            <td class="title">结束时间</td>
                            <td class="value">
                                <div class="timecls" id="worker_enddateDiv" onclick="getMyDate_begin('worker_enddate')"><%=endDateStr %></div>
                                <input type="hidden" id="worker_enddate" value="<%=endDateStr %>" /></td>
                            <td class="title">统计对象</td>
                            <td class="value">
                            <input type="checkbox" name="worker_persontype" value="1" checked="checked"/>责任人
                            <input type="checkbox" name="worker_persontype" value="2"/>参与人
                            <input type="checkbox" name="worker_persontype" value="3"/>创建人
                            </td>
                            <td>
                                <div>
                                    <div class="btn1 btn" style="padding: 0px !important" title="搜索" onclick="setPageNum(),searchWorker()">搜索</div>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <!-- 按人员查询条件  end-->
        <!-- 按组织查询展示框 -->
        <div id="subConpanyCont">
            <jsp:include page="SubCpyReport.jsp">
                <jsp:param value="<%=beginDateStr %>" name="beginDate"/>
                <jsp:param value="<%=endDateStr %>" name="endDate"/>
                <jsp:param value="1" name="personType"/>
            </jsp:include>
        </div>
        <!-- 按人员查询展示框 -->
        <div id="workerCont">
        </div>
        </div>
    </BODY>
    <script type="text/javascript">
        /**
         * 查询组织结构
         */
        function searchOrg(){
            var beginDate=$("#org_begindate").val();
            var endDate=$("#org_enddate").val();
            var personType = getPersonType("org_persontype");
            $("#subConpanyCont").html("");
            $("body").showLoading();
            $("#subConpanyCont").load("SubCpyReport.jsp",{
                "beginDate":beginDate,
                "endDate":endDate,
                "personType":personType
            },function(){
                $("body").hideLoading();
                afterSearchOrg();
            });
        }
        /**
         * 查询组织结构
         */
        function loadSubDept(subCpyId){
            var newTr = $("<tr></tr>");
            var beginDate=$("#org_begindate").val();
            var endDate=$("#org_enddate").val();
            var e = window.event;
            //获取元素
            var obj = e.target || e.srcElement;
            var curImg = $(obj);
            var curTd = curImg.parent("td");
            var curTr = curTd.parent("tr");
            var curCode = curTr.attr("curCode");
            var subCpyId = curTr.attr("subCpyId");
            var curtype = curTr.attr("curtype");
            var personType = getPersonType("org_persontype");
            curImg.attr("src","/workrelate/images/wrcontraction.png");
            //如果已经查询过下级部门则展示，否则查询
            var isOpened = curTr.attr("opened");
            if(isOpened == "no"){
                var level = curTd.attr("level");
                $("body").showLoading();
                newTr.load("SearchSubDept.jsp",{
                    "beginDate":beginDate,
                    "endDate":endDate,
                    "subCpyId":subCpyId,
                    "curCode":curCode,
                    "level":level,
                    "curtype":curtype,
                    "personType":personType
                },function(data){
                    curTr.after(newTr.html());
                    afterSearchOrg();
                    curImg.unbind("click");
                    curImg.bind("click",hideSubDept);
                    $("div .watchdetail").bind("mouseover",function(){
                        $(this).addClass("watchdetailHover");
                    }).bind("mouseout",function(){
                        $(this).removeClass("watchdetailHover");
                    });
                    $("body").hideLoading();
                });
                curImg.attr("onclick", "");
                curTr.attr("opened","yes");
            }else{
                curImg.attr("onclick", "");
                curImg.unbind("click");
                curTr.nextAll("tr[curCode^="+curTr.attr("curCode")+"_]").show();
                curImg.bind("click",hideSubDept);
                afterSearchOrg();
            }
        }
        /**
         * 查询组织结构
         */
        function hideSubDept(){
            var curImg = $(this);
            curImg.unbind("click");
            curImg.attr("src","/workrelate/images/wropen.png");
            var curTr = curImg.parent("td").parent("tr");
            curTr.nextAll("tr[curCode^="+curTr.attr("curCode")+"_]").hide();
            curImg.bind("click",loadSubDept);
            afterSearchOrg();
        }
        /**
         * 查询人员报表
         */
        function searchWorker(){
            var beginDate=$("#worker_begindate").val();
            var endDate=$("#worker_enddate").val();
            var subcompanyids=$("#worker_subcompanyids").val();
            var departmentids=$("#worker_departmentids").val();
            var cpyincludesub=$("#cpyincludesub").val();
            var deptincludesub=$("#deptincludesub").val();
            var workerType = $("#workerType").val();
            var hrmids=""+$("#hrmids").val();
            var pagenum=$("#pagenum").val();
            var personType = getPersonType("worker_persontype");
            $("#workerCont").html("");
            $("body").showLoading();
            $("#workerCont").load("WorkerReport.jsp",{
                "beginDate":beginDate,
                "endDate":endDate,
                "hrmids":hrmids,
                "subcompanyids":subcompanyids,
                "departmentids":departmentids,
                "cpyincludesub":cpyincludesub,
                "deptincludesub":deptincludesub,
                "workerType":$("#workerType").val(),
                "pagenum":pagenum,
                "personType":personType
            },function(){
                $("body").hideLoading();
            });
        }
        //给人员查询类型添加事件
        $("#workerType").change(function(){
            if($(this).val()=="2" || $(this).val()=="3"){
                searchWorker();
                $("#hrmbrowserid").hide();
            }else if($(this).val()=="1"){
                $("#hrmbrowserid").show();
            }
        });
        
        //设置查询类型样式
        $(".tabbt").click(function(){
            $(".tabbt").removeClass("tabbtFocs");
            $(this).addClass("tabbtFocs");
            //按组织查询
            if($(this).attr("name")=="subOrg"){
                $("#showImgRightContr").css({"visibility":"visible"});
                $("#workerSearchContent").hide();
                $("#subSearchContent").show();
                
                $("#workerCont").hide();
                $("#subConpanyCont").show();
            //按人员查询
            }else{
                $("#showImgRightContr").css({"visibility":"hidden"});
                $("#subSearchContent").hide();
                $("#workerSearchContent").show();
                if(!$(this).attr("isSearched")){
                    searchWorker();
                    $(this).attr("isSearched","1");
                }
                $("#workerCont").show();
                $("#subConpanyCont").hide();
            }
        });
        $("div[name=subOrg]").click();
        
        //添加搜索按钮事件
        $(document).ready(function(){
            jQuery("div.btn").live("mouseover",function(){
                jQuery(this).addClass("btn_hover");
            }).live("mouseout",function(){
                jQuery(this).removeClass("btn_hover");
            });
        });
        /**
         * 设置表格样式
         */
        function setTableColor(){
            $("#listTable tbody tr").bind("mouseover",function(){
                $(this).css({"background":"#FAFAFA"});
            }).bind("mouseout",function(){
                $("#listTable tbody tr").css({"background":"#FFFFFF"});
            });
        }
        /**
         * 查看详情
         */
        function watchDetail(event){
            var e = event||window.event;
            var obj = e.target || e.srcElement;
            var curTr = $(obj).parent("td").parent("tr");
            var curtype = curTr.attr("curtype");
            //判断是查询分部还是部门
            if(curtype == "subcpy"){
                $("#worker_subcompanyids").val(curTr.attr("subCpyId"));
                $("#worker_departmentids").val("");
                $("#worker_subcompanyidsSpan").html(curTr.find("td:first").find("label").html());
                $("#worker_departmentidsSpan").html("");
            }else{
                $("#worker_departmentids").val(curTr.attr("subCpyId"));
                $("#worker_subcompanyids").val("");
                $("#worker_departmentidsSpan").html(curTr.find("td:first").find("label").html());
                $("#worker_subcompanyidsSpan").html("");
            }
            $("input[name=worker_persontype][value=1]").attr("checked",$("input[name=org_persontype][value=1]").attr("checked"));
            $("input[name=worker_persontype][value=2]").attr("checked",$("input[name=org_persontype][value=2]").attr("checked"));
            $("input[name=worker_persontype][value=3]").attr("checked",$("input[name=org_persontype][value=3]").attr("checked"));
            
            $("#worker_begindate").val($("#org_begindate").val());
            $("#worker_enddate").val($("#org_enddate").val());
            $("#worker_begindateDiv").html($("#org_begindate").val());
            $("#worker_enddateDiv").html($("#org_enddate").val());
            $("#cpyincludesub").val(3);
            $("#deptincludesub").val(3);
            $("#tabworker").attr("isSearched","");
            $("#tabworker").click();

        }
        /**
         * 设置时间
         */
        function getMyDate_begin(inputid){
            WdatePicker({
                isShowClear:false,
                onpicked:function(dp){
                    var returnvalue = dp.cal.getDateStr();
                    $("#" + inputid).val(returnvalue);
                },
                oncleared:function(dp){
                    $("#" + inputid).val("");
                }
            });
        }
        
        /**
         * 得到人员查询类型
         */
        function getPersonType(checkboxname){
            var returnStr = "";
            $("input[name="+checkboxname+"]").each(function(){
                if($(this).attr("checked")){
                    returnStr += "," + $(this).val();
                }
            });
            if(returnStr.length > 0){
                return returnStr.substring(1);
            }else{
                return "";
            }
        }
        /**
         * 设置分页
         */
        function setPageNum(){
            $("#pagenum").val("1");
        }
        function imgOver(th){
            var src = $(th).attr("src");
            src = src.substring(0,src.lastIndexOf(".")) +"_click"+ src.substring(src.lastIndexOf("."));
            $(th).attr("src",src);
        }
        function imgOut(th){
            var src = $(th).attr("src");
            if(src.lastIndexOf("_")>0){
                src = src.substring(0,src.lastIndexOf("_")) + src.substring(src.lastIndexOf("."));
                $(th).attr("src",src);
            }
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function(){
            var rpwinWidth = $(window).width();
            var rpwinHeight = $(window).height();
            $("#showImgContainer").width(rpwinWidth+12);
            $("#showImgContainer").height(rpwinHeight);
            $("#showImgContainer").css({"left":(0-rpwinWidth)});
            $("#imgContainer").width(rpwinWidth-12);
            $("#showImgLeftContr").click(function(){
                $("#showImgContainer").animate({"left":"-"+rpwinWidth},500,function(){
                    $('#imgContainer').html('');
                });
            });
            $("#showImgRightContr").click(function(){
                showCompareReport();
            });
            afterSearchOrg();
        });
        /**
         * 展示图表
         */
        function showCompareReport(){
            var data = getDatas();
            if(data.length==0){
                return;
            }
            $("#showImgContainer").animate({"left":0},500,function(){
                showImg(data);
            });
        }
        /**
         * 得到数据
         */
        function getDatas(){
            var datas = new Array();
            var checkboxes = $(".listTable input:checkbox:checked").each(function(index){
                if(index>9){
                    return false;
                }
                var tr = $(this).parents("tr");
                var td = tr.find("td");
                var curData = new Array();
                for(var i=1;i<5;i++){
                    curData[i-1]=parseInt(td.eq(i).text());
                }
                datas[index] = {
                    name:tr.find("label").text(),
                    data:curData
                };
            });
            if(checkboxes.length==0){
                var _left = Math.round(($(window).width()-$("#msg").width())/2);
                $("#msg").css({"left":_left,"top":300}).show().animate({top:250},500,null,function(){
                    $(this).fadeOut(800);
                });
            }
            return datas;
        }
        /**
         * 展示图表
         */
        function showImg(data){
            $('#imgContainer').html('');
            datas = data; 
            var categories = ['任务数','已超期','进行中','已完成'];
            $('#imgContainer').highcharts({                               
                chart: {type:"column"},                
                title: {text: ''},                
                xAxis: {categories: categories},
                yAxis: {
                    title: {
                        text: '个'
                    },
                    labels: {
                        formatter: function() {
                            return this.value
                        }
                    }
                },
                tooltip: {
                    headerFormat: '<table width="140px"><tr><td cspans="2" style="text-align:center;"><span style="font-size:12px">{point.key}</span></td></tr>',
                    pointFormat: '<tr>'+
                                     '<td style="color:{series.color};padding:0,width:100px">{series.name}: </td>' +
                                     '<td style="padding:0;width:40px;"><b>{point.y}</b></td>'+
                                 '</tr>',
                    footerFormat: '</table>',
                    shared: true,
                    useHTML: true
                },               
                credits: {
                    enabled: false
                },
                series: datas               
            });          
        }
        function afterSearchOrg(){
            setTableColor();
            jQuery('body').jNice();
        }
    </script>
</HTML>