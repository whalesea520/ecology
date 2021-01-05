/**
 * User: 三杰lee
 * Date: 14-9-10
 * Time: 上午9:28
 */
//负责人矩阵设计对象
var matrixdesign = (function () {


    function placeholder(nodes,pcolor) {
      if(nodes.length && !("placeholder" in document.createElement("input"))){
          for(i=0;i<nodes.length;i++){
              var self = nodes[i],
                  placeholder = self.getAttribute('placeholder') || '';     
              self.onfocus = function(){
                  if(self.value == placeholder){
                     self.value = '';
                     self.style.color = "";
                  }               
              }
              self.onblur = function(){
                  if(self.value == ''){
                      self.value = placeholder;
                      self.style.color = pcolor;
                  }              
              }                                       
              self.value = placeholder;  
              self.style.color = pcolor;              
          }
      }
    } 
    
    //验证字段名, 字段名只能包含字母和数字，不能含中文!
    function  fieldNameCheck(fieldname){
		if(fieldname.length==0){
		    return false;
		}
		var notcharnum = false ;
		var notchar = false ;
		var notnum = false ;
		for(i=0 ; i<fieldname.length ; i++) {
			notchar = false ;
			notnum = false ;
			charnumber = parseInt(fieldname[i]) ; if(isNaN(charnumber)) notnum = true ;
			if((fieldname[i].toLowerCase()<'a' || fieldname[i].toLowerCase()>'z')&&fieldname[i]!='_') notchar = true ;
			if(notnum && notchar) notcharnum = true ;
		}
		if(fieldname[0].toLowerCase()<'a' || fieldname[0].toLowerCase()>'z') notcharnum = true ;
		if(notcharnum){
		  return false;
		}
		
		return true;
    }


	function  addPlaceHolder(view){
	   var nodes=[];
	   var labelname = view.find("input[name='labelname']").get(0);
	   var fieldname = view.find("input[name='fieldname']").get(0);
	   nodes.push(labelname);
	   nodes.push(fieldname);
       placeholder(nodes,"grey");
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
    var tmplettersall = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

    var lettersall = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
    
    for(var i=0;i<tmplettersall.length;i++){  
        for(var j=0;j<tmplettersall.length;j++){
        	lettersall.push(tmplettersall[i]+tmplettersall[j]);
        }
    }
    
    var cache = {};
    var matchitems = [];
    var selectitems = [];
    var matchcontainer = $(".matchitemcontainer");
    var selectcontainer = $(".selectitemcontainer");
    var matchaddcontainer=$(".matchaddcontainer");
    var selectaddcontainer=$(".selectaddcontainer");
    function Item() {
        this.selectMatchItem = function () {
            matchcontainer.find(".letterselected").removeClass("letterselected");
            this.view.find(".letter").addClass("letterselected");
        }
        this.selectSelectItem = function () {
            selectcontainer.find(".letterselected").removeClass("letterselected");
            this.view.find(".letter").addClass("letterselected");
        }
        this.addLetterSelectItem = function () {
            //如果存在选中节点
            if (this.view.find(".letterselected").length > 0) {
                var prev = this.view.prev();
                var next = this.view.next();
                //存在上个节点
                if (prev.length > 0) {
                    prev.find(".letter").addClass("letterselected");
                    //下个节点
                } else if (next.length > 0) {
                    next.find(".letter").addClass("letterselected");
                }
            }
        }
    }

    //匹配对象
    function MatchItem() {
        this.uuid = new UUID();
        this.temp = Item;
        //对象冒充继承item里面属性方法
        this.temp();
        this.model = {itemid:"",type: "0", namelabel: "", fieldlable: "", width: "130",htmltype:"",iscusttype:"0",filedorder:"",typeid:"",editable:"1"};
        this.view = $(".matchitemclone").clone();
        this.view.attr("itemid", this.uuid);
        //绑定事件(实现模型与视图数据交互)
        this.bindEvents();
    }

    MatchItem.prototype.bindEvents = function () {
        var that = this;
        var languageid=readCookie("languageidweaver");
        this.view.find(".letter").click(function () {
            that.selectMatchItem();
        });
        this.view.mouseover(function () {
            if(that.model.editable==='1' && matchitems.length>0)
                $(this).find(".itemdelete").show();
        });
        this.view.mouseleave(function () {
            if(that.model.editable==='1')
                $(this).find(".itemdelete").hide();
        });
        //注册失去焦点
        this.view.find("input").blur(function () {
            var current = $(this);
            var val = current.val();
            var field = current.parents(".field");
            if (val !== '') {
                if (!field.hasClass("matchlegalfield"))
                    field.addClass("matchlegalfield");
                if(current.attr("name")==='labelname'){
                    that.model.namelabel=val;
                }
                //同步数据.....
                matrixdesign.refreshPreviewItems();
            } else {
                field.removeClass("matchlegalfield");
            }
        });

        this.view.find(".itemdelete").click(function () {
            if (matchitems.length === 1) {
                return;
            }

            window.top.Dialog.confirm(SystemEnv.getHtmlNoteName(4053,languageid),function(){
                var flag = 0;
                for (var i = 0; i < matchitems.length; i++) {
                    if (matchitems[i] === that) {
                        flag = i;
                        break;
                    }
                }
                //移除对象
                matchitems.splice(i, 1);
                //删除缓存
                delete cache[that.uuid];
                //添加字母选中
                that.addLetterSelectItem();
                that.view.remove();
                that.model = null;
                //刷新预览区域
                matrixdesign.refreshPreviewItems();
				//关闭对话框
               // this.close().remove();
                resetContainerWidth();
                return false;

            });

        });
    }

    //选择对象
    function SelectItem() {
        this.uuid = new UUID();
        this.temp = Item;
        //对象冒充继承item里面属性方法
        this.temp();
        this.model = {itemid:"",type: "1", namelabel: "", fieldlable: "", width: "130",htmltype:"17",iscusttype:"0",filedorder:"",typeid:"",editable:"1"};
        this.view = $(".selectitemclone").clone();
        this.view.attr("itemid", this.uuid);
        this.bindEvents();
    }

    SelectItem.prototype.bindEvents = function () {
        var that = this;
        var languageid=readCookie("languageidweaver");
        this.view.find(".letter").click(function () {
            that.selectSelectItem();
        });
        this.view.mouseover(function () {
            if(that.model.editable==='1')
                $(this).find(".itemdelete").show();
        });
        this.view.mouseleave(function () {
            if(that.model.editable==='1')
                $(this).find(".itemdelete").hide();
        });
        //注册失去焦点
        this.view.find("input").blur(function () {
            var current = $(this);
            var val = current.val();
            var field = current.parents(".field");
            if (val !== '') {
                if (!field.hasClass("selectlegalfield"))
                    field.addClass("selectlegalfield");
                if(current.attr("name")==='labelname'){
                    that.model.namelabel=val;
                }
                //同步数据.....
                matrixdesign.refreshPreviewItems();
            } else {
                field.removeClass("selectlegalfield");
            }
        });
        this.view.find(".itemdelete").click(function () {
            if (selectitems.length === 1) {
                return;
            }
            window.top.Dialog.confirm(SystemEnv.getHtmlNoteName(4053,languageid),function(){
                var flag = 0;
                for (var i = 0; i < selectitems.length; i++) {
                    if (matchitems[i] === that) {
                        flag = i;
                        break;
                    }
                }
                //移除对象
                selectitems.splice(i, 1);
                //删除缓存
                delete cache[that.uuid];
                //添加字母选中
                that.addLetterSelectItem();
                that.view.remove();
                that.model = null;
				//this.close();
               // this.close().remove();
                resetContainerWidth();
                //刷新预览区域
                matrixdesign.refreshPreviewItems();
                return false;

            });

        });
    }

    function MatchAdd() {
        this.view = $(".matchitemaddclone").clone();
    }

    MatchAdd.prototype.bindEvent = function () {
        this.view.find(".addpng").on('click', function () {
            var matchitem = new MatchItem();
            matrixdesign.addMatchItem(matchitem);
            matchitem.selectMatchItem();
        });
        this.view.find(".addpng").hover(function(){
            $(this).find("img").attr("src","../images/m-add-hot_wev8.png");
        },function(){
            $(this).find("img").attr("src","../images/m-add_wev8.png");
        });

    }

    function SelectAdd() {
        this.view = $(".selectitemaddclone").clone();
    }

    SelectAdd.prototype.bindEvent = function () {
        this.view.find(".addpng").on('click', function () {
            var selectitem = new SelectItem();
            matrixdesign.addSelectItem(selectitem);
            selectitem.selectSelectItem();
        });
        this.view.find(".addpng").hover(function(){
            $(this).find("img").attr("src","../images/add-hot_wev8.png");
        },function(){
            $(this).find("img").attr("src","../images/add_wev8.png");
        });
    }

    //重置主容器宽度
    function resetContainerWidth() {
        var items = $(".matrixcontainerwrapper .matrixitem");
        var sum = 20;
        for (var i = 0; i < items.length; i++) {
            sum = sum + $(items[i]).width();
        }
        var cloneWidth = $(".selectaddcontainer").width();
        sum = sum + cloneWidth;
        $(".matrixcontainer").css("width", sum + "px");
    }

    function checkKey (obj){
		
		var keys=",PERCENT,PLAN,PRECISION,PRIMARY,PRINT,PROC,PROCEDURE,PUBLIC,RAISERROR,READ,READTEXT,RECONFIGURE,REFERENCES,REPLICATION,RESTORE,RESTRICT,RETURN,REVOKE,RIGHT,ROLLBACK,ROWCOUNT,ROWGUIDCOL,RULE,SAVE,SCHEMA,SELECT,SESSION_USER,SET,SETUSER,SHUTDOWN,SOME,STATISTICS,SYSTEM_USER,TABLE,TEXTSIZE,THEN,TO,TOP,TRAN,TRANSACTION,TRIGGER,TRUNCATE,TSEQUAL,UNION,UNIQUE,UPDATE,UPDATETEXT,USE,USER,VALUES,VARYING,VIEW,WAITFOR,WHEN,WHERE,WHILE,WITH,WRITETEXT,EXCEPT,EXEC,EXECUTE,EXISTS,EXIT,FETCH,FILE,FILLFACTOR,FOR,FOREIGN,FREETEXT,FREETEXTTABLE,FROM,FULL,FUNCTION,GOTO,GRANT,GROUP,HAVING,HOLDLOCK,IDENTITY,IDENTITY_INSERT,IDENTITYCOL,IF,IN,INDEX,INNER,INSERT,INTERSECT,INTO,IS,JOIN,KEY,KILL,LEFT,LIKE,LINENO,LOAD,NATIONAL,NOCHECK,NONCLUSTERED,NOT,NULL,NULLIF,OF,OFF,OFFSETS,ON,OPEN,OPENDATASOURCE,OPENQUERY,OPENROWSET,OPENXML,OPTION,OR,ORDER,OUTER,OVER,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUTHORIZATION,BACKUP,BEGIN,BETWEEN,BREAK,BROWSE,BULK,BY,CASCADE,CASE,CHECKPOINT,CLOSE,CLUSTERED,COALESCE,COLLATE,COLUMN,COMMIT,COMPUTE,CONSTRAINT,CONTAINS,CONTAINSTABLE,CONTINUE,CONVERT,CREATE,CROSS,CURRENT,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR,DATABASE,DBCC,DEALLOCATE,DECLARE,DEFAULT,DELETE,DENY,DESC,DISK,DISTINCT,DISTRIBUTED,DOUBLE,DROP,DUMMY,DUMP,ELSE,END,ERRLVL,ESCAPE,";
		//以下for oracle.update by cyril on 2008-12-08 td:9722
		keys+="ACCESS,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUDIT,BETWEEN,BY,CHAR,"; 
		keys+="CHECK,CLUSTER,COLUMN,COMMENT,COMPRESS,CONNECT,CREATE,CURRENT,";
		keys+="DATE,DECIMAL,DEFAULT,DELETE,DESC,DISTINCT,DROP,ELSE,EXCLUSIVE,";
		keys+="EXISTS,FILE,FLOAT,FOR,FROM,GRANT,GROUP,HAVING,IDENTIFIED,";
		keys+="IMMEDIATE,IN,INCREMENT,INDEX,INITIAL,INSERT,INTEGER,INTERSECT,";
		keys+="INTO,IS,LEVEL,LIKE,LOCK,LONG,MAXEXTENTS,MINUS,MLSLABEL,MODE,";
		keys+="MODIFY,NOAUDIT,NOCOMPRESS,NOT,NOWAIT,NULL,NUMBER,OF,OFFLINE,ON,";
		keys+="ONLINE,OPTION,OR,ORDER,PCTFREE,PRIOR,PRIVILEGES,PUBLIC,RAW,";
		keys+="RENAME,RESOURCE,REVOKE,ROW,ROWID,ROWNUM,ROWS,SELECT,SESSION,";
		keys+="SET,SHARE,SIZE,SMALLINT,START,SUCCESSFUL,SYNONYM,SYSDATE,TABLE,";
		keys+="THEN,TO,TRIGGER,UID,UNION,UNIQUE,UPDATE,USER,VALIDATE,VALUES,";
		keys+="VARCHAR,VARCHAR2,VIEW,WHENEVER,WHERE,WITH,";
		var fname=obj;
		if (fname!=""){
			fname=","+fname.toUpperCase()+",";
			if (keys.indexOf(fname)>0){
				return false;
			}
		}
		return true;
	}

    return {
        //获取要存储的对象，返回数据格式  0 显示名为空  1字段名为空 字段名只能为字母 2 字段名重名 3 自定义浏览框为空4 字段名为空
        getSaveParams:function(){
            //获取所有的条目
            var items=$(".matrixcontainer .matrixitem");
            var currentitem;
            var item;
            var itemid;
            var itemarray=[];
            var fieldnames=[];
            var htmltype;
            //自定义单选或多选id
            var typeid;
            //显示名
            var namelabel;
            //列名
            var fieldname;
            for(var i=0;i<items.length;i++){
                currentitem=$(items[i]);
                if(currentitem.hasClass("addicon"))
                    continue;
                itemid=currentitem.attr("itemid");
                item=cache[itemid];
                //设置宽度
                item.model.width=currentitem.width();
                //排序
                item.model.filedorder=i;
                //显示名
                namelabel= currentitem.find("input[name='labelname']").val();
                if(namelabel==='')return 0;
                item.model.namelabel=namelabel;
                fieldname= currentitem.find("input[name='fieldname']").val();
                if(fieldname==='') return 4;
                if(fieldNameCheck(fieldname))
                    item.model.fieldlable=fieldname;
                else
                    return 1;
                if(fieldnames.contains(fieldname))
                    return 2;
                else
                    fieldnames.push(fieldname);
                //匹配字段
                if(item.model.type==='0'){
                    htmltype=currentitem.find("select").val();
                    item.model.htmltype=htmltype;
                    //自定义单选
                    if(htmltype==='161'){
                        item.model.iscusttype='1';
                        typeid=currentitem.find("input[name='cusb']").val();
                        if(typeid==='')
                            return 3;
                        item.model.typeid=typeid;
                        //自定义多选
                    }else if(htmltype==='162'){
                        item.model.iscusttype='2';
                        typeid=currentitem.find("input[name='cusbmulti']").val();
                        if(typeid==='')
                            return 3;
                        item.model.typeid=typeid;
                    }else{
                        item.model.iscusttype='0';
                    }
                }
                itemarray.push(item.model);
            }
            return   itemarray;
          //保存条目
        },saveItems:function(){
            var that=this;
            var languageid=readCookie("languageidweaver");
            //条目集合
            var params=that.getSaveParams();
            if(params===0)
            {
                window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4012,languageid));
                return;
            }
            if(params===1)
            {
                window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4057,languageid));
                return;
            }
            if(params===2)
            {
                window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4014,languageid));
                return;
            }
            if(params===3)
            {
                window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4015,languageid));
                return;
            }
            if(params===4) {
            	window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4016,languageid));
                return;
            }
            var isCheckKey = false;
            //添加遮罩
            that.addLoadingItem();
            var param={};
            param.count=params.length;
            for(var i=0;i<params.length;i++){
                param["itemid_"+i]=params[i].itemid;
                if(!checkKey(params[i].fieldlable)){
                	isCheckKey = true;
                	break;
                }
                param["fieldlable_"+i]=params[i].fieldlable;
                param["filedorder_"+i]=params[i].filedorder;
                param["htmltype_"+i]=params[i].htmltype;
                param["iscusttype_"+i]=params[i].iscusttype;
                param["namelabel_"+i]=params[i].namelabel;
                param["type_"+i]=params[i].type;
                param["typeid_"+i]=params[i].typeid;
                param["width_"+i]=params[i].width;
            }
            if(isCheckKey){
            	window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4685,languageid));
                return;
            }
            //矩阵id
            param.matrixid=$("input[type='hidden'][name='matrixid']").val();
            $.ajax({
                data: param,
                type: "POST",
                url: "/matrixmanage/pages/saveitems.jsp",
                timeout: 20000,
                dataType: 'json',
                success: function(rs){
                    //移除遮罩
                    that.removeLoadingItem();
                    //存储成功
                    if(rs.success==='1'){
                        window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4010,languageid));
                        that.recoverDesigner(rs.fieldarray);
                        if(rs.firstcreatetable==='1'){
                             window.parent.location.reload();
                        }
                        //存储失败
                    }else{
                        window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4011,languageid));
                    }
                },fail:function(){
                    window.top.Dialog.alert(SystemEnv.getHtmlNoteName(4011,languageid));
                }
            });

        //添加加载进度条
      },addLoadingItem:function(){
          var container=$(window.top.document.body);
          var loadingdiv=$("<div class='loadingicon' style='position: absolute;width: 16px;height: 16px;z-index: 1001'><img src='/matrixmanage/images/loading_wev8.gif'></div>");
          loadingdiv.css("left",(container.width()/2-8)+'px');
          loadingdiv.css("top",(container.height()/2-8)+'px');
          container.append(loadingdiv);
          var mask=$("<div class='matrixmask' style='position: absolute;width: 100%;height: 100%;left: 0;top:0;z-index: 1000'></div>")
          container.append(mask);
        //移除图标
        },removeLoadingItem:function(){
            var container=$(window.top.document.body);
            container.find(".loadingicon").remove();
            container.find(".matrixmask").remove();
          //是否多选
        },
        //刷新显示名
        refreshNameLabel: function (item) {
            var uuid = item.uuid;
            var languageid=readCookie("languageidweaver");
            var namelabel = item.model.namelabel === '' ? ""+SystemEnv.getHtmlNoteName(3539,languageid) : item.model.namelabel;
            var width = item.model.width;
            $(".previewlist").find("li[labelid='" + uuid + "']").css("width", width + "px").html(namelabel);
        },
        //刷新预览区
        refreshPreviewItems:function(){
            var that=this;
            var container = $(".matrixsysarea .previewlist");
            container.html("");
            var item;
            var matchitems=$(".matrixitem");
            var itemid;
            var sum=20;
            for(var i=0;i<matchitems.length;i++){
                itemid=$(matchitems[i]).attr("itemid");
                if(itemid!=='' && itemid!==undefined){
                    item=cache[itemid];
                    that.addPreviewItem(container,item);
                    sum=sum+ item.view.width();
                }
            }
            container.css("width",sum+"px");
            //添加一个节点
        },addPreviewItem:function(container,item){
        	var languageid=readCookie("languageidweaver");
            var namelabel = item.model.namelabel === '' ? ''+SystemEnv.getHtmlNoteName(4058,languageid) : item.model.namelabel;
            var itemid = item.uuid;
            var width = item.view.width();
            var li = $("<li></li>");
            if(item.model.type==='0'){
                li.addClass("matchbg");
            }else if(item.model.type==='1'){
                li.addClass("selectbg");
            }
            li.html(namelabel);
            li.css("width", width + "px");
            li.attr("labelid", itemid);
            container.append(li);
        },
        //刷新字母列表
        refreshLettersItem: function () {
            var letters = $(".letter");
            var item;
            for (var i = 0; i < letters.length; i++) {
                item = $(letters[i])
                item.find("div").html(lettersall[i]);
            }
        },
        //添加匹配条目对象
        addMatchItem: function (item) {
            var that = this;
            //浏览框类型
            var htmltype=item.model.htmltype===''?'1':item.model.htmltype;
            var signalbroval="";
            var svalue="";
            var multibrwval="";
            var mvalue="";
			var custbrowserLabel="";
            //0 正常 1自定义单选 2自定义多选
            var iscusttype=item.model.iscusttype;
            if(htmltype==='161'){
                signalbroval=item.model.typeid;
                if(item.model.typeid!=='')
                    svalue=item.model.typeid.substr(item.model.typeid.indexOf(".")+1);
				custbrowserLabel=item.model.custbrowserLabel;
            }else if(htmltype==='162'){
                multibrwval=item.model.typeid;
                if(item.model.typeid!=='')
                    mvalue=item.model.typeid.substr(item.model.typeid.indexOf(".")+1);
				custbrowserLabel=item.model.custbrowserLabel;
            }
            //显示名
            var namelabel=item.model.namelabel;
            //字段名
            var fieldlabel=item.model.fieldlable;
            //浏览框是否可编辑
            var editable=item.model.editable;
            //条目宽度
            var width=item.model.width;

            var matchselect = matchcontainer.find(".letterselected");
            matchitems.push(item);
            cache[item.uuid] = item;
            if (matchselect.length > 0) {
                item.view.insertAfter(matchselect.parent());
            } else {
                matchcontainer.append(item.view);
            }
            item.view.removeClass("matchitemclone");
            //刷新字母表
            that.refreshLettersItem();
            resetContainerWidth();
            that.refreshPreviewItems();
            matchcontainer.find(".letter").disableSelection();

            //浏览框赋值
            item.view.find("select").val(htmltype);
            //美化select
            if(editable==='1')
                item.view.find("select").removeAttr("notBeauty").selectbox();
            else
                item.view.find("select").attr("disabled","disabled");
            //显示名
            item.view.find("input[name='labelname']").val(namelabel);
            //字段名
            item.view.find("input[name='fieldname']").val(fieldlabel);

            //如果不为空,则去除红色警告
            if(namelabel!==''){
                item.view.find("input[name='labelname']").parent().addClass("matchlegalfield");
            }
            if(fieldlabel!==''){
                item.view.find("input[name='fieldname']").parent().addClass("matchlegalfield");
            }
            //设置宽度
            item.view.css("width",width+'px');
            //生成隐藏自定义浏览框(单选)
            item.view.find(".custbrower").e8Browser({
                name:"cusb",
                viewType:"0",
                browserValue:signalbroval,
                isMustInput:"2",
                browserSpanValue:custbrowserLabel,
                hasInput:editable==='1',
				browBtnDisabled:editable==='1' ? "" : "none",
                linkUrl:"#",
                isSingle:true,
                completeUrl:"/data.jsp",
                browserUrl:"/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp",
                width:"150px",
                hasAdd:false
            });
            //自定义多选
            item.view.find(".custmultibrower").e8Browser({
                name:"cusbmulti",
                viewType:"0",
                browserValue:multibrwval,
                isMustInput:"2",
                browserSpanValue:custbrowserLabel,
                hasInput:editable==='1',
				browBtnDisabled:editable==='1' ? "" : "none",
                linkUrl:"#",
                isSingle:true,
                completeUrl:"/data.jsp",
                browserUrl:"/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp",
                width:"150px",
                hasAdd:false
            });
            //当为自定义单选和多选
            item.view.find("select").change(function(){
                var val=$(this).val();
                if(val==='161'){
                    item.view.find(".custbrower").parent().show();
                    item.view.find(".custmultibrower").parent().hide();
                }else if(val==='162'){
                    item.view.find(".custbrower").parent().hide();
                    item.view.find(".custmultibrower").parent().show();
                }else{
                    item.view.find(".custbrower").parent().hide();
                    item.view.find(".custmultibrower").parent().hide();
                }
            });
            //展示浏览框
            if(iscusttype==='1'){
                item.view.find(".custbrower").parent().show();
                item.view.find(".custmultibrower").parent().hide();
            }else if(iscusttype==='2'){
                item.view.find(".custbrower").parent().hide();
                item.view.find(".custmultibrower").parent().show();
            }
            //添加选择条目对象
        }, addSelectItem: function (item) {
            var that = this;
            //显示名
            var namelabel=item.model.namelabel;
            //字段名
            var fieldlabel=item.model.fieldlable;
            //条目宽度
            var width=item.model.width;

            //显示名
            item.view.find("input[name='labelname']").val(namelabel);
            //字段名
            item.view.find("input[name='fieldname']").val(fieldlabel);
            //如果不为空,则去除红色警告
            if(namelabel!==''){
                item.view.find("input[name='labelname']").parent().addClass("selectlegalfield");
            }
            if(fieldlabel!==''){
                item.view.find("input[name='fieldname']").parent().addClass("selectlegalfield");
            }
            //设置宽度
            item.view.css("width",width+'px');

            var selectitem = selectcontainer.find(".letterselected");
            selectitems.push(item);
            cache[item.uuid] = item;
            if (selectitem.length > 0)
                item.view.insertAfter(selectitem.parent());
            else
                selectcontainer.append(item.view);
            item.view.removeClass("selectitemclone");
            //刷新字母表
            that.refreshLettersItem();
            resetContainerWidth();
            that.refreshPreviewItems();
            selectcontainer.find(".letter").disableSelection();
            //添加匹配条目添加对象
        }, addMatchAddIcon: function () {
            var matchadd = new MatchAdd();
            matchaddcontainer.append(matchadd.view);
            matchadd.view.removeClass("matchitemaddclone");
            matchadd.bindEvent();
            //添加选择条目添加对象
        }, addSelectAddIcon: function () {
            var selectadd = new SelectAdd();
            selectaddcontainer.append(selectadd.view);
            selectadd.view.removeClass("selectitemaddclone");
            selectadd.bindEvent();
        },
        //初始化设计器
        initDesign: function () {
            var that = this;
            //匹配区域
            var matchitem = new MatchItem();
            matchitem.selectMatchItem();
            that.addMatchItem(matchitem);
            that.addMatchAddIcon();

            //选择区域
            var selectitem = new SelectItem();
         //   var first= selectitem;
            that.addSelectItem(selectitem);

            selectitem = new SelectItem();
            that.addSelectItem(selectitem);

            selectitem = new SelectItem();
            that.addSelectItem(selectitem);

            that.addSelectAddIcon();

			selectitem.selectSelectItem();

			//刷新字母表
            that.refreshLettersItem();
            resetContainerWidth();

            that.registerEvent();

            //恢复设计器
        },recoverDesigner:function(fieldarray){
            var that = this;
            //清空容器
            that.clearContainer();
            var matchitemfields=[];
            var selectitemfields=[];
            var matchitem;
            var selectitem;
            var first;
            var type;
            for(var i=0;i<fieldarray.length;i++){
                type=fieldarray[i].type;
                //匹配条目
                if(type==='0'){
                    matchitemfields.push(fieldarray[i]);
                    //选择条目
                }else if(type==='1'){
                    selectitemfields.push(fieldarray[i]);
                }
            }
            //生成匹配节点
            for(var i=0;i<matchitemfields.length;i++){
                matchitem = new MatchItem();
                matchitem.model=matchitemfields[i];
                that.addMatchItem(matchitem);
                if(i===0)
                    first=matchitem;
            }
            //生成匹配区域
            matchitem.selectMatchItem();
            that.addMatchAddIcon();

            //选择条目
            for(var i=0;i<selectitemfields.length;i++){
                selectitem=new SelectItem();
                selectitem.model=selectitemfields[i];
                that.addSelectItem(selectitem);
                if(i===0)
                    first=selectitem;
            }
            //生成选择区域
            that.addSelectAddIcon();
            if(selectitem)
               selectitem.selectSelectItem();

            //刷新字母表
            that.refreshLettersItem();
            resetContainerWidth();
            //  that.registerEvent();
            //清空容器
        },clearContainer:function(){
            //清空filed容器
            $(".matrixcontainer  .matchitemcontainer").html("");
            $(".matrixcontainer  .matchaddcontainer").html("");
            $(".matrixcontainer  .selectitemcontainer").html("");
            $(".matrixcontainer  .selectaddcontainer").html("");
            //清空预览区域
            $(".matrixsysarea").find(".previewlist").html("");
        },
        //注册事件（列置换,宽度可拖拉）
        registerEvent: function () {
            var that = this;
            var moveflag = false;
            var targetnow;
            //事件代理,设置宽度拖拽
            $(".matrixcontainer").delegate('.letter', 'mousemove', function (e) {
                var target = $(e.target);
                var offset = target.offset();
                var range = 10;
                if (target.parents(".matrixitem").hasClass("addicon") || target.hasClass("letterdraghandler"))
                    return;
                if (!moveflag) {
                    //拖拽列头
                    //  console.log((offset.left+target.width())+"=="+(e.pageX-range)+"===="+(e.pageX+range))
                    if ((offset.left + target.width()) > e.pageX - range && (offset.left + target.width()) < e.pageX + range) {
                        target.css("cursor", "e-resize");
                    } else {
                        target.css("cursor", "default");
                    }
                }
            });
            //设置可拖拉信号
            $(".matrixcontainer").delegate('.letter', 'mousedown', function (e) {
                var target = $(e.target);
                if (target.css("cursor") === 'e-resize') {
                    targetnow = target;
                    moveflag = true;
                }
            });
            $(document.body).mouseup(function (e) {

                if(moveflag){

                    //设置高度
                    var itemid = targetnow.parent().attr("itemid");
                    var item = cache[itemid];
                    item.model.width = targetnow.width();
                    that.refreshPreviewItems();

                    moveflag = false;
                    $(document.body).find(".letter").css("cursor", "default");
                    $(document.body).css("cursor", "default");
                }

            });
            $(document.body).on('mousemove', function (e) {
                if (moveflag && (targetnow !== undefined)) {
                    var widthnew = e.pageX - targetnow.offset().left;
                    if (widthnew < 130)
                        return;
                    $(document.body).find(".letter").css("cursor", "e-resize");
                    $(document.body).css("cursor", "e-resize");
                    targetnow.parent().css("width", widthnew + "px");
                    resetContainerWidth();
                    e.preventDefault();
                    e.stopPropagation();
                }
            });
            //列置换
            $(".matchitemcontainer").sortable({ handle: ".letterdraghandler", stop: function (event, ui) {
                that.refreshLettersItem();
                that.refreshPreviewItems();
            } });
            $(".selectitemcontainer").sortable({ handle: ".letterdraghandler", stop: function (event, ui) {
                that.refreshLettersItem();
                that.refreshPreviewItems();
            } });

        }
    }
})();
