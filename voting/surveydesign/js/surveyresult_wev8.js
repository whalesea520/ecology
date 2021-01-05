/**
 * Created with JetBrains WebStorm.
 * User: Administrator
 * Date: 14-8-28
 * Time: 下午4:55
 * To change this template use File | Settings | File Templates.
 */
String.prototype.replaceAll  = function(s1,s2){
    return this.replace(new RegExp(s1,"gm"),s2);
}
var surveyresult=(function(){
    var questionnum=0;
    var questioncontainer=$(".questions");
    //其它输入添加可拖拽
    $( "#popup" ).draggable({ handle: ".head" });
    //问题明细添加可拖拽
    $( "#imgpopup" ).draggable({ handle: ".head" });
    var  optionvoters;
    return {
        setOpters:function(voters){
            optionvoters=voters;
        },
        //添加问题容器
        addQuestionsContainer:function(subid,subname){
            questionnum=0;
            questioncontainer=$(".questionsclone").clone();
            questioncontainer.removeClass("questionsclone");
            $("#surveyreport").append(questioncontainer);
            var subiditem=$("<input type='hidden' name='subid' value='"+subid+"'>");
            questioncontainer.append(subiditem);
            if(""!==subname){
				var subnameel=questioncontainer.find(".subcompanyname");
                subnameel.html(subname);
                subnameel.show();
            }

        } ,
        //生成问题(选择)
        generatorSelectSignal:function(question){

            var  options = [];
            var  tbody;
            var  tr;
            var  td;
            var  tips="";
            var  type;
            var  ismustinput;
            var  questioname;
            var  container;

            container=$(".questionsclone .selectsignalclone").clone();
            container.removeClass("selectsignalclone");

            container.append("<input type='hidden' name='questionid' value='"+question.quesionid+"'>");
            container.append("<input type='hidden' name='questiontype' value='"+question.questiontype+"'>");

            //问题名称
            questioname=question.name===''?'新建问题':question.name;
            container.find(".questiontitle").html(questionnum+"、<span>"+questioname+"</span>");
            //单选类型
            type = question.type;
            //是否必需
            ismustinput=question.ismustinput;
            //生成提示信息
            if(type==='0' || type==='2'){
                tips="单选";
            }else if(type==='1'){
                tips="多选";
            }
            //必须
            if(ismustinput==='1'){
                tips=tips+",必填";
            }
            //提示信息
            container.find(".rules").html('('+tips+')');

            //获取所有的选项
            for (var optionorder in  question.options) {
                options.push(question.options[optionorder]);
            }
            //获取表体
            tbody=container.find(".result").find("tbody");
            tbody.html("");
            //生成每行数据
            for(var i=0;i<options.length;i++){
                tr=$("<tr><td class='first comrow'>"+(options[i].oplabel===''?'选项':options[i].oplabel)+"</td><td>0<input type='hidden' name='votenums' value='0'><input type='hidden' name='n_"+options[i].quesionid+"' value='"+options[i].opid+"'></td><td><div  class='round-pink' ><span class='round-percent'></span><span class='round-text'></span></div><input type='hidden' name='votepercent' value='0'><input type='hidden' name='p_"+options[i].quesionid+"' value='"+options[i].opid+"'></td></tr>");
                progressBar(0, tr.find(".round-pink"))
                tbody.append(tr);
            }
            questioncontainer.append(container);

            //其它选项
            if(question.isother==='1'){
                var rsdetail=$("<div style='height: 30px;line-height: 30px;padding-left: 10px;'><a class='' style='cursor: pointer;color: #08C;' ><span class='i_detail_gray_result'></span>其他</a></div>");
                container.append(rsdetail);
                rsdetail.find("a").click(function(){

                    var subject=$(this).parents(".question").find(".subject span").html();
                    var subid= $(this).parents(".questions").find("input[name='subid']").val();
                    var votingid=$("input[name='votingid']").val();
                    var questionid=$(this).parents(".question").find("input[name='questionid'][type='hidden']").val();
                    var dg = new window.top.Dialog();
                    dg.currentWindow = window;
                    dg.Title = subject;
                    dg.URL = "/voting/surveydesign/pages/getOtherInput.jsp?votingid="+votingid+"&questionid="+questionid+"&subid="+subid;
                    dg.Width = 860;
                    dg.Height = 520;
                    dg.Drag = true;
                    dg.textAlign = "center";
                    dg.show();

                });
            }


        },
        //生成组合
        generatorMatrix:function(question){

            //单选类型
            var type ;
            //是否必需
            var ismustinput ;
            //提示信息
            var tips="";
            //列选项
            var cols = [];
            //行选项
            var rows = [];
            var option;
            var optiontemp;
            var questionname;
            //内容区域
            var content;
            //表头
            var thead;
            //表体
            var tbody;

            type = question.type;
            ismustinput=question.ismustinput
            questionname=question.name===''?'新建问题':question.name;


            //设置选项信息
            for (var optionorder in  question.options) {
                option = question.options[optionorder];
                optiontemp = option;
                if (option.roworcolumn === '0') {
                    rows.push(optiontemp);
                } else {
                    cols.push(optiontemp);
                }

            }
            //保存行列信息
            question.rows=rows;
            question.cols=cols;

            var container = $(".questionsclone .matrixclone").clone();
            container.removeClass("matrixclone");

            container.append("<input type='hidden' name='questiontype' value='"+question.questiontype+"'>");

            //设置问题标题
            container.find(".questiontitle").html(questionnum+"、<span>"+questionname+"</span>");

            //生成提示信息
            if(type==='0'){
                tips="单选";
            }else if(type==='1'){
                tips="多选"
            }
            //必须
            if(ismustinput==='1'){
                container.find(".require").show();
                tips=tips+",必填";
            }else{
                container.find(".require").hide();
            }

            //添加提示信息
            container.find(".rules").html("("+tips+")");
            //表
            thead = container.find(".result thead");
            thead.html("");
            tbody = container.find(".result tbody");
            tbody.html("");
            //单选框(radio)
            if ("0" === type || "1" === type) {
                var tr;
                var td;
                var th;
                //添加首节点
                thead.append($("<th class='first'></th>"));
                //添加列头
                for (var i = 0; i < cols.length; i++) {
                    th = $("<th class='comcol'>" + (cols[i].oplabel === '' ? '选项' : cols[i].oplabel) + "</th>");
                    thead.append(th);
                }
                //添加行头
                var rowtr;
                for (var i = 0; i < rows.length; i++) {
                    rowtr = $("<tr><td class='first comrow'>" + (rows[i].oplabel === '' ? '新建问题' : rows[i].oplabel) + "</td></tr>");
                    for (var j = 0; j < cols.length; j++) {
                        td = $("<td><input type='hidden' name='votenums' value='0'><input type='hidden' name='votepercent' value='0'>0<br/>0%<input type='hidden' value='"+cols[j].opid+"'  name='q_"+rows[i].quesionid+"_"+rows[i].opid+"' ></td>");
                        rowtr.append(td);
                    }
                    tbody.append(rowtr);
                }

            }

            questioncontainer.append(container);
        },
        //生成填空
        generatorBlankFill:function(question){
            var container=$(".questionsclone .blankfillingclone").clone();
            container.removeClass("blankfillingclone");
            var questionname=question.name;
            var ismustinput= question.ismustinput;
            var tips='填空';
            if(ismustinput==='1'){
                tips=tips+",必填";
            }
            container.append("<input type='hidden' value='"+question.quesionid+"'>");
            container.find(".questiontitle").html(questionnum+"、<span>"+questionname+"</span>");
            container.find(".rules").html('('+tips+')');
            var rsdetail=$("<a class=''><span class='i_detail_gray_result'></span>查看列表</a>");
            rsdetail.click(function(){
                var subject=$(this).parents(".question").find(".subject span").html();
                var subid= $(this).parents(".questions").find("input[name='subid']").val();
                var votingid=$("input[name='votingid']").val();
                var questionid=$(this).parents(".question").find("input[type='hidden']").val();
                var dg = new window.top.Dialog();
                dg.currentWindow = window;
                dg.Title = subject;
                dg.URL = "/voting/surveydesign/pages/getOtherInput.jsp?votingid="+votingid+"&questionid="+questionid+"&subid="+subid;
                dg.Width = 860;
                dg.Height = 520;
                dg.Drag = true;
                dg.textAlign = "center";
                dg.show();

            });
            container.find(".blankfilldetail").html(rsdetail);
            questioncontainer.append(container);

        },
        //生成问题视图
        generatorQuestion:function(question){
            var that = this;
            //获取问题类型,根据不同的问题生成对应的选项
            var questiontype = question.questiontype;
            //选择题
            if (questiontype === "0") {
                questionnum++;
                that.generatorSelectSignal(question);

            } else if (questiontype === '1') {
                //组合题
                questionnum++;
                that.generatorMatrix(question);

            }  else if (questiontype === '3') {
                //填空
                questionnum++;
                that.generatorBlankFill(question);
            }

        },
        //生成所有问题视图
        generatorAllQuestion:function(pageitems){
            var that=this;
            var pageinfo;
            var questioninfo;
            var page;
            var question;
            for (var pagenum in pageitems) {
                //页面
                page = pageitems[pagenum];
                pageinfo={};
                pageinfo.pagenum=pagenum;
                pageinfo.questions=[];
                if(pageitems[pagenum][1]){
                    var surveyname=pageitems[pagenum][1].surveyname;
                    $(".votetitle").html(surveyname===''?'新建调查表':surveyname);
                }
                for (var quesnum in page) {
                    question = page[quesnum];
                    pageinfo.questions.push(question);
                    that.generatorQuestion(question);
                }
            }

        },
        //生成选择题结果
        generatorSelectSignalRs:function(vote){
            var qid = vote.questionid;
            var opid = vote.optionid;
            var percent= (vote.percentdig*100).toFixed(2);
            var nums= vote.nums;
            var td = questioncontainer.find("input[name='n_"+qid+"'][value='"+opid+"']").parent();
            td.html("");
            td.append("<input type='hidden' name='n_"+qid+"' value='"+opid+"'><input type='hidden' name='votenums' value='"+nums+"'>"+nums);
            td = questioncontainer.find("input[name='p_"+qid+"'][value='"+opid+"']").parent();
            td.html("");
            //td.append("<div  class='round-pink' ><div></div></div>") ;
            td.append("<input type='hidden' name='votepercent' value='"+(vote.percentdig*100).toFixed(2)+"'><div  class='round-pink' ><span class='round-percent'></span><span class='round-text'></span></div>") ;
            progressBar(percent, td.find(".round-pink"));
            //生成组合选择题结果
        },generatorMatrixRs:function(vote){
            var qid = vote.questionid;
            var percent= (vote.percentdig*100).toFixed(2)+"%";
            var nums= vote.nums;
            var opids = vote.optionid.split("_");
            var hiddenname="q_"+qid+"_"+opids[0];
            var hiddenvalue=opids[1];
            var td=questioncontainer.find("input[name='"+hiddenname+"'][value='"+hiddenvalue+"']").parent();
            td.html("");
            td.append("<input type='hidden' name='"+hiddenname+"' value='"+hiddenvalue+"'><input type='hidden' name='votenums' value='"+nums+"'><input type='hidden' name='votepercent' value='"+(vote.percentdig*100).toFixed(2)+"'>"+nums+"<br/>"+percent);
            //td.append(nums);
            td.addClass("rsstyle");

            //生成填空题
        },generatorBlankFillRs:function(vote){



            //生成问题对应结果
        },generatorQuestionRs:function(vote){



            //判断调查人是否添加（考虑按分部统计）
        },needAdd:function(subcomid,items){
            var rs=[];
            if(subcomid==='-1'){
                for(var i=0;i<items.length;i++){
                    if(items[i].useranony!=='1'){
                        rs.push(items[i]);
                    }
                }
                return   rs;
            }
            var subids= subcomid.split(",");
            var flag;
            for(var i=0;i<items.length;i++){
                flag=false;
                for(var j=0;j<subids.length;j++){
                    if(items[i].subcomid===subids[j]){
                        flag=true;
                        break;
                    }
                }
                if(flag  &&  items[i].useranony!=='1'){
                    rs.push(items[i]);
                }
            }
            return rs;
            //生成所有问题对应的结果
        },generatorAllQuesitonRs:function(voters){
            //生成结果
            var questiontype;
            var that=this;
            for(var i=0;i<voters.length;i++){
                questiontype=voters[i].questiontype;
                //选择题
                if(questiontype==='0'){
                    that.generatorSelectSignalRs(voters[i]);
                    //组合选择
                }else if(questiontype==='1'){
                    that.generatorMatrixRs(voters[i]);
                }
            }
            //选择题详细信息
        },generatorSignalDetail:function(question){
            var that=this;
            var container=$(".asdetailcontainer");
            container.html("");
            //分部id
            var subcomid= question.parents(".questions").find("input[name='subid']").val();
            //获取所有选项
            var ops=question.find(".comrow");
            var table=$("<table class='detailquestion_title'><col width='30%'><col width='20%'><col width='50%'><tr><td >选项</td><td>票数</td><td>百分比</td></tr></table>");
            container.append(table);
            table=$("<table class='detailquestion'><col width='30%'><col width='20%'><col width='50%'></table>");
            container.append(table);
            var tr;
            var td;
            var current;
            var percent;
            var hideinputoption;
            var opid;
            var voters;
            for(var i=0;i<ops.length;i++){
                current=$(ops[i]);
                tr=$("<tr></tr>");
                table.append(tr);
                td=$("<td >"+current.html()+"</td>");
                tr.append(td);
                td=$("<td style='text-align: center'>"+current.parent().find("input[name='votenums']").val()+"</td>");
                tr.append(td);
                percent=current.parent().find("input[name='votepercent']").val();
                td=$("<td><div style='width: 350px;text-align: center'><div  class='round-pink' ><span class='round-percent'></span><span class='round-text'></span></div></td></div>");
                tr.append(td);
                progressBarStatic(percent, td.find(".round-pink"));
                hideinputoption=current.parent().find("input[name^=n_]");
                opid=hideinputoption.val();
                voters=optionvoters[opid];
                if(undefined!==voters){
                    var rs=that.needAdd(subcomid,voters);
                    var names=[];
                    for(var m=0;m<rs.length;m++){
                        names.push("<span class='voteuser'>"+rs[m].name+"</span>&nbsp;&nbsp;");
                    }
                    if(names.length>0){
                        var voterhtml=$("<tr><td colspan='3' style='background:#ECFDEA'><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;投票人&nbsp;:&nbsp;</span><span>"+names.join("")+"</span></td></tr>");
                        table.append(voterhtml);
                    }
                }
            }
            that.showDetailDialog('详细信息',$("<div></div>").append(container.clone()));
            //生成组合选择详细信息
        },generatorMatrixDetail:function(question){
            var that=this;
            var container=$(".asdetailcontainer");
            container.html("");
            var table;
            //所有子问题
            var ques=question.find(".comrow");
            //所有选项
            var ops= question.find(".comcol");
            //选项隐藏域
            var inputopitems;
            var childqu;
            var qnametr;
            var optr;
            var optd;
            var currentop;
            var currentinput;
            var percent;
            var hideinputoption;
            var opid;
            var voters;
            //分部id
            var subcomid= question.parents(".questions").find("input[name='subid']").val();
            table=$("<table class='detailquestion_title'><col width='10%'><col width='20%'><col width='20%'><col width='50%'><tr><td colspan=2>选项</td><td>票数</td><td>百分比</td></tr></table>");
            container.append(table);
            for(var i=0;i<ques.length;i++){
                table=$("<table class='detailquestion'><col width='10%'><col width='20%'><col width='20%'><col width='50%'></table>");
                container.append(table);
                childqu=$(ques[i]).parent().find("input[type='hidden'][name='votenums']");
                //添加问题选项
                qnametr=$("<tr><td colspan='4' style='font-weight: bold'>"+$(ques[i]).html()+"</td></tr>");
                table.append(qnametr);
                for(var j=0;j<ops.length;j++){
                    optr=$("<tr></tr>");
                    table.append(optr);
                    currentop=$(ops[j]);
                    currentinput=$(childqu[j]);
                    //选项名称
                    optd=$("<td colspan='2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+$(ops[j]).html()+"</td>");
                    optr.append(optd);
                    //票数
                    optd=$("<td style='text-align: center'>"+currentinput.parent().find("input[name='votenums']").val()+"</td>");
                    optr.append(optd);
                    //百分比
                    percent=currentinput.parent().find("input[name='votepercent']").val();
                    optd=$("<td><div style='width: 350px;text-align: center'><div  class='round-pink' ><span class='round-percent'></span><span class='round-text'></span></div></td></div>");
                    optr.append(optd);
                    progressBarStatic(percent, optd.find(".round-pink"));
                    //添加选项投票人信息
                    hideinputoption=currentinput.parent().find("input[name^=q_]");
                    //console.log(hideinputoption.attr("name"));
                    opid=hideinputoption.attr("name").split("_")[2]+"_"+hideinputoption.attr("value");
                    voters=optionvoters[opid];
                    if(undefined!==voters){
                        var rs=that.needAdd(subcomid,voters);
                        var names=[];
                        for(var m=0;m<rs.length;m++){
                            names.push("<span class='voteuser'>"+rs[m].name+"</span>&nbsp;&nbsp;");
                        }
                        if(names.length>0){
                            var voterhtml=$("<tr> <td colspan='4' style='background:#ECFDEA'><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;投票人&nbsp;:&nbsp;</span><span>"+names.join("")+"</span></td></tr>");
                            table.append(voterhtml);
                        }
                    }
                    // console.dir(optionvoters[opid]);
                }
            }
            that.showDetailDialog('详细信息',$("<div></div>").append(container.clone()));

            //显示明细对话框
        },showDetailDialog:function(subject,container){

            var dg = new window.top.Dialog();
            dg.currentWindow = window;
            dg.Title = subject;
            dg.URL = "/voting/surveydesign/pages/showOtherInput.jsp";
            dg.Width = 860;
            dg.Height = 420;
            dg.Drag = true;
            dg.textAlign = "center";
            dg.show();
            window.top.votecontainer=container;


            //注册问题明细点击事件
        },registerQestionDetail:function(){
            var that=this;
            $(".questiondetail").click(function(){
                //问题类型
                var current = $(this);
                var question=current.parents(".question");
                var questiontype=question.find("input[name='questiontype']").val();
                //   $("#imgpopup").bPopup({opacity: 0.2,positionStyle:'fixed',modalClose:false});
                //  $(window.top.document.body).append($("#imgpopup"));
                //   $(window.top.document.body).append($(".b-modal"));
                //选择题
                if(questiontype==='0'){
                    that.generatorSignalDetail(question);
                    //组合选择
                }else if(questiontype==='1'){

                    that.generatorMatrixDetail(question);

                }


            });

        }

    }
})();
/**
 * 处理进度条
 * @param percent
 * @param $element
 */
function progressBarStatic(percent, $element) {
	var progressBarWidth = percent * (350) / 100;
    //$element.find('span.round-percent').animate({ width: progressBarWidth }, 500);
    $element.find('span.round-percent').css("width",progressBarWidth+'px');
	$element.find('span.round-text').html(percent+"%&nbsp;");
}

/**
 * 处理进度条
 * @param percent
 * @param $element
 */
function progressBar(percent, $element) {
    var progressBarWidth = percent * ($element.width()) / 100;
    $element.find('span.round-percent').animate({ width: progressBarWidth }, 500);
    $element.find('span.round-text').html(percent+"%&nbsp;");
}
