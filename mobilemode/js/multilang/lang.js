(function (golbal, factory) {
    golbal.MLanguage = factory(jQuery);
}(window, function ($) {
    var is = function (type) {
        return function (str) {
            return Object.prototype.toString.call(str) == "[object " + type + "]";
        };
    };
    var isObject = is("Object"),
        isString = is("String");
    var isElement = function (o) {
        return o instanceof HTMLElement;
    }, isImportability = function (o) { // 判断是否为可输入的元素
        return isElement(o) && (o.tagName === "INPUT" || o.tagName === "TEXTAREA");
    };
    var stopPropagation = function (e) {
        e.stopPropagation();
    };
    var isEnableMultiLang = typeof enableMultiLang != "undefined" && enableMultiLang == 1;

    var MULTI_ATTR = "data-multi";
    var def = {
        container: "body",
        el: "[" + MULTI_ATTR + "]"
    }, langs = [7, 8, 9]; // 7:简体中文 8:英文 9:繁体中文
    var symbol = "`~`";
    var _currlang = typeof _defaultLang != "undefined" && _defaultLang || 7;

    function MultiLanguage(el, config) {
        var ml = this;
        var container, $el;

        if (isObject(el)) {
            config = el;
            el = def.el;
        }

        config = config || {};
        config.el = el;
        config = $.extend(def, config, true);
        $el = filter(config.el, config.container);

        if (!$el || !$el.length) return;

        $el.attr(MULTI_ATTR, "true").each(function() {
            var $ele = $(this);
            var mval = $ele.val();
            var v = parseToMVals(mval);

            MLPicker.clone($ele);
            $ele.val(v[_currlang] || "");

            if (!mval || !v || mval == v || mval == v[_currlang] ) return;

            MLIcon.active($ele);
        }).on("input", function() {
            var $clone = MLPicker.getClone(this);
            var transfer = MLPicker.transfer;
            var val = $(this).val(),
                cval = $clone.val(),
                mval = parseToMVals(cval);

            if(cval == mval) {
                mval = {};
            }

            mval[_currlang] = val;

            if (_currlang == 7) {
                mval["9"] = transfer.ToTraditionalized(val);
            } else if (_currlang == 9) {
                mval["7"] = transfer.ToSimplized(val);
            }

            var str = Object.keys(mval).reduce(function(prev, k) {
                var v = mval[k];

                return prev + k + " " + v.trim() + symbol;
            }, symbol);

            str = "~" + str + "~";
            $clone.val(str);
        });

        // 未开启多语言开关 则只保留fmt功能
        if(!isEnableMultiLang) return;

        $el.on({
            mouseover: function () {
                new MLIcon(this).show();
            },
            mouseleave: function (e) {
                if (e.toElement && e.toElement.id == MLIcon.id) return;

                new MLIcon(this).hide();
            }
        })
    }

    // 过滤非input,textarea的元素和已初始化的元素
    function filter(el, container) {
        var $el = $(el);

        if (isString(el)) {
            $el = $(container).find(el);
        }

        if (!$el.length) return null;

        return $el.filter(function () {
            return isImportability(this) && $(this).attr(MULTI_ATTR) != "true";
        });
    }

    MultiLanguage.setLanguages = function (langs) {
        langs = langs;
    };
    MultiLanguage.setCurrLanguage = function(currlang) {
        _currlang = currlang;
    };
    MultiLanguage.getValue = function (name) {
        var $input = $(name);

        if (isString(name)) {
            $input = $("[name=" + name + "]");
        }

        return MLPicker.getClone($input).val();
    };
    MultiLanguage.parse = function(content) {
        return content.replace(/~`~`(.*?)`~`~/g, function(m) {
            var mval = parseToMVals(m);

            return mval[_currlang] || "";
        });
    };

    function MLIcon(el) {
        var $icon = MLIcon.$el,
            $body = $(document.body);
        var that = this;

        this.el = el;

        if (!MLIcon.$el) {
            $icon = $("<div class='multi-lang-icon' id='" + MLIcon.id + "'></div>");
            $body.append($icon);
            MLIcon.$el = $icon;
        }

        $icon.toggleClass("active", !!$(el).data("multi-config"))
            .off("click mouseleave").on({
                click: function (e) {
                    new MLPicker(el);
                    that.hide();
                    stopPropagation(e);
                },
                mouseleave: function (e) {
                    if (e.toElement == el) return;

                    MLIcon.$el.hide();
                }
            });
    }

    MLIcon.id = "multi-lang-icon";
    MLIcon.$el = null;
    MLIcon.active = function(el) {
        $(el).data("multi-config", true);
    };

    MLIcon.prototype = {
        show: function () {
            if (MLPicker.isvisible()) return;

            var $el = $(this.el),
                offset = $el.offset();
            var $icon = MLIcon.$el, top, left;

            top = offset.top + $el.outerHeight() / 2 - $icon.outerHeight() / 2;
            left = offset.left + $el.outerWidth() - $icon.outerWidth() - 5;

            $icon.css({ top: top, left: left }).show();
        },
        hide: function () {
            MLIcon.$el.hide();
        }
    };

    function MLPicker(el) {
        var $picker = MLPicker.$el,
            $body = $(document.body);
        var that = this;

        this.el = el;
        MLPicker.clone(el);

        if (!$picker) {
            $picker = $(MLPicker.tmpl);
            $body.append($picker);
            MLPicker.$el = $picker;
        }

        $body.off("click.mlpicker").on("click.mlpicker", this.hide.bind(this));
        $picker.off("click.stop").on("click.stop", stopPropagation);
        $picker.off("click.btn").on("click.btn", ".lang-btn", function () {
            var $btn = $(this);

            if (!$btn.hasClass("confirm")) return that.hide();

            that.transform().hide();
        });

        this.render();
        this.show();
    }

    MLPicker.$el = null;
    MLPicker.tmpl = '\
<div class="multi-lang-picker">\
    <div class="lang-content"></div>\
    <div class="lang-footer">\
        <span class="lang-btn confirm">'+SystemEnv.getHtmlNoteName(3451)+'</span>\
        <span class="lang-divide">|</span>\
        <span class="lang-btn cancel">'+SystemEnv.getHtmlNoteName(3516)+'</span>\
    </div>\
</div>\
';//确定 取消
    MLPicker.isvisible = function () {
        return MLPicker.$el && MLPicker.$el.is(":visible");
    };
    MLPicker.getClone = function (el) {
        if (!el) return;

        return $(el).next(".multi__clone");
    };
    MLPicker.clone = function (el) {
        var $el = $(el), $clone,
            name = $el.attr("name");

        if ($el.next(".multi__clone").length) return;
        
        name = name ? ("multilang_" + name) : "";

        $("<input type='hidden' />")
            .attr("name", name)
            .addClass("multi__clone")
            .insertAfter($el)
            .val($el.val());
    };

    MLPicker.prototype = {
        getClone: function (el) {
            return MLPicker.getClone(this.el);
        },
        getVals: function () {
            var $clone = this.getClone();
            var cval = $clone.val();

            return parseToMVals(cval);
        },
        render: function () {
            var $picker = MLPicker.$el;
            var vals = this.getVals();
            
            var tmpls = langs.reduce(function (prev, lang) {
                var val = vals[lang] || "";
                var tmpl = "<div class='lang-field'><img src='/mobilemode/js/multilang/img/multilang_" + lang + ".png' />\
                    <div><input type='text' langid='"+ lang + "' name='multilang_" + lang + "' id='multilang_" + lang + "' value='" + val + "'/></div></div>";
                return prev + tmpl;
            }, "");

            $picker.find(".lang-content").html(tmpls)
                .off("blur", "input").on("blur", "input", function (e) { // 简体与繁体自动切换
                    var $input = $(this),
                        langid = $input.attr("langid");
                    var transfer = MLPicker.transfer;

                    if(langid != 7 && langid != 9) return;

                    var isSimpleCh = langid == 7;
                    var method = isSimpleCh ? "ToTraditionalized" : "ToSimplized"
                    var v = transfer[method]($input.val());

                    $picker.find("[langid="+(isSimpleCh ? 9 : 7)+"]").val(v);
                    !isSimpleCh && $input.val(transfer.ToTraditionalized(v));
                });
        },
        show: function () {
            var $el = $(this.el),
                offset = $el.offset();
            var $picker = MLPicker.$el;
            var top, left;

            top = offset.top + $el.outerHeight();
            left = offset.left;
            $picker.css({ top: top, left: left, width: $el.outerWidth() }).show();
        },
        transform: function () {
            var $el = $(this.el),
                $picker = MLPicker.$el,
                $clone = this.getClone();
            var str = symbol;
            var isEmpty = true;
            var $curr;

            $picker.find("input").each(function (index) {
                var $input = $(this),
                    langid = $input.attr("langid"), v;

                langid == _currlang && ($curr = $input);
                v = $input.val().trim();
                isEmpty = v || isEmpty;
                str += langid + " " + $input.val().trim() + symbol;
            });
            $clone.val("~" + str + "~");
            $el.data("multi-config", isEmpty !== true);
            $curr && $el.val($curr.val());

            return this;
        },
        hide: function () {
            MLPicker.$el.hide();
        }
    };

    MLPicker.transfer = (function () {
        function JTPYStr() {
            return '锕锿皑嗳蔼霭爱嫒碍暧瑷庵谙鹌鞍埯铵暗暗翱翱鳌鳌袄媪岙奥骜钯坝坝罢鲅霸摆呗败稗颁坂板钣办绊帮绑榜膀谤镑龅褒宝饱鸨褓报鲍杯杯鹎贝狈备背钡悖惫辈鞴奔奔贲锛绷绷逼秕笔币毕闭哔荜毙铋筚滗痹跸辟弊边笾编鳊贬变缏辩辫标飑骠膘镖飙飙飚镳表鳔鳖鳖别别瘪宾宾傧滨缤槟镔濒摈殡膑髌鬓鬓冰饼禀并并并拨剥钵钵饽驳驳钹铂博鹁钸卜补布钚财采采采彩睬踩参参参骖残蚕惭惭惨黪灿仓伧沧苍舱操艹册侧厕厕恻测策策层插馇锸查察镲诧钗侪虿觇掺搀婵谗禅馋缠蝉镡产产谄铲铲阐蒇冁忏颤伥阊鲳长肠苌尝尝偿厂厂场场怅畅钞车砗扯彻尘陈谌谌碜碜闯衬称龀趁榇谶柽蛏铛撑枨诚乘铖惩塍澄骋吃鸱痴驰迟齿耻饬炽敕冲冲虫宠铳俦帱绸畴筹酬酬酬踌雠雠丑瞅出刍厨锄锄雏橱蹰础储处处绌触传船钏囱疮窗窗窗床创怆捶棰锤锤春纯唇莼莼淳鹑醇绰辍龊词辞辞鹚鹚糍赐从匆匆苁枞葱骢聪丛丛凑辏粗粗蹴撺镩蹿窜篡脆村鹾锉错哒达沓鞑呆绐带玳贷单担郸殚瘅箪胆掸诞啖啖弹惮当当当裆挡挡党谠凼砀荡荡档导岛捣捣祷焘盗锝德灯邓凳镫堤镝籴敌涤觌诋抵抵递谛缔蒂颠巅癫点电垫钿淀雕雕雕鲷吊钓调铞谍喋叠叠叠蝶鲽钉顶订碇碇锭丢铥东冬岽岽鸫动冻峒栋胨兜斗斗斗钭豆窦读渎渎椟椟牍犊黩独笃赌睹妒镀端断缎煅锻簖队对兑怼镦吨墩趸炖钝顿遁夺铎朵垛缍堕跺讹讹峨锇鹅鹅额婀厄厄轭垩恶恶饿谔阏萼腭锷鹗颚鳄鳄儿鸸鲕尔迩饵铒贰发发罚罚阀法珐帆翻翻凡矾钒烦繁泛泛饭范贩钫鲂仿仿仿访纺飞绯鲱诽废费痱镄纷氛坟奋偾愤粪鲼丰风沣枫疯砜峰锋冯缝讽凤佛夫肤麸麸凫绂绋辐幞呒抚俯俯辅讣妇负附驸复复赋缚鲋赙鳆钆嘎该赅丐丐钙盖概干干杆尴尴秆赶绀赣冈刚岗纲肛钢杠戆皋槔糕缟稿镐诰锆纥胳鸽搁歌阁镉个个铬给亘耕赓绠鲠鲠宫躬龚巩贡沟钩钩缑构构诟购够觏轱鸪毂鹘诂谷钴蛊鹄鼓顾雇锢鲴刮鸹剐诖挂拐拐怪关关观鳏馆馆管管贯惯掼鹳罐广犷归妫妫龟规规闺瑰鲑轨匦诡刽刿柜贵鳜衮绲辊滚鲧鲧呙埚锅蝈国国帼掴果椁过铪骇顸函韩汉悍焊焊颔绗颃蚝嗥号皓皓颢灏诃合合和阂核盍颌阖贺鹤恒横轰哄红闳荭鸿黉讧糇鲎呼呼呼轷胡胡壶鹕糊浒户冱护沪鹱花花华哗哗骅铧划画话桦怀坏欢欢獾还环锾缳缓奂唤换涣焕痪鲩黄鳇恍谎诙咴挥晖珲辉辉徽回回回回蛔蛔蛔蛔汇汇汇会讳哕浍绘荟诲桧烩贿秽缋毁毁毁昏荤阍浑馄诨锪钬货获获祸镬讥击叽饥饥机玑矶鸡鸡迹迹积绩绩缉赍赍跻齑羁级极楫辑几虮挤计记纪际剂哜济继觊蓟霁鲚鲫骥夹夹浃家镓郏荚铗蛱颊贾钾价驾戋奸坚歼间艰监笺笺缄缣鲣鹣鞯拣枧俭茧捡笕减检睑裥锏简谫戬碱碱见饯剑剑荐贱涧舰渐谏溅践鉴鉴鉴键槛姜将浆僵缰缰讲奖桨蒋绛酱娇浇骄胶鲛鹪侥挢绞饺矫脚铰搅剿缴叫峤轿较阶阶疖秸节讦劫劫劫杰诘洁结颉鲒届诫斤仅卺紧谨锦馑尽尽劲进荩晋烬赆赆缙觐泾经茎荆惊鲸阱刭颈净弪径径胫痉竞靓静镜迥炯纠鸠阄揪韭旧厩厩救鹫驹锔局局举举榉龃讵钜剧惧据飓锯窭屦鹃镌镌卷锩倦桊狷绢隽眷决诀珏绝觉谲橛镢镢军钧皲俊浚骏咔开锎凯剀垲恺铠慨锴忾龛坎侃阚瞰糠糠闶炕钪考铐轲疴钶颏颗壳咳克克课骒缂锞肯垦恳坑铿抠眍叩扣寇库绔喾裤夸块侩郐哙狯脍宽髋款诓诳邝圹纩况旷矿矿贶亏岿窥窥匮愦愧溃蒉馈馈篑聩坤昆昆锟鲲捆捆阃困扩阔阔腊蜡辣来崃徕涞莱铼赉睐赖赖濑癞籁兰岚拦栏婪阑蓝谰澜褴斓篮镧览揽缆榄懒懒烂滥琅锒螂阆捞劳唠崂痨铹铑涝耢乐鳓缧镭诔垒泪类累棱厘梨狸离骊犁鹂漓缡蓠璃璃鲡篱藜礼里里逦锂鲤鳢历历历厉丽励呖坜沥苈枥疠隶隶俪栎疬疬荔轹郦栗砺砾莅莅粝蛎跞雳俩奁奁奁奁连帘怜涟莲联裢廉鲢镰敛敛琏脸裣蔹练娈炼炼恋殓链潋凉梁粮两魉谅辆辽疗缭镣鹩钌猎邻邻临淋辚磷磷鳞麟凛廪懔檩吝赁蔺躏灵灵岭凌铃棂棂绫菱龄鲮领溜刘浏留琉琉馏骝瘤镏柳柳绺锍鹨龙咙泷茏栊珑胧砻笼聋陇垄垄拢娄偻喽蒌楼耧蝼髅嵝搂篓瘘瘘镂噜撸卢庐芦垆垆泸炉炉栌胪轳鸬舻颅鲈卤卤虏掳鲁橹橹橹镥陆录赂辂渌禄滤戮辘鹭氇驴闾榈吕侣稆铝屡缕褛虑绿孪峦挛栾鸾脔滦銮乱略锊抡仑仑伦囵沦纶轮论罗罗猡脶萝逻椤锣箩骡骡镙裸裸泺络荦骆妈嬷麻蟆马犸玛码蚂杩骂骂唛吗买荬劢迈麦卖脉脉颟蛮馒瞒鳗满螨谩缦镘猫牦牦锚铆冒贸帽帽么没梅梅镅鹛霉镁门扪钔闷焖懑们蒙蒙蒙锰梦弥弥祢猕谜芈眯觅觅秘幂谧绵绵黾缅腼面面面鹋缈妙庙咩灭蔑珉缗缗闵泯闽悯愍鳘鸣铭谬缪谟馍馍模殁蓦镆谋亩钼幕拿拿镎内纳钠乃乃奶难楠楠馕挠铙蛲垴恼脑闹闹讷馁嫩铌霓鲵你拟昵腻鲇鲶捻辇撵念娘酿鸟茑袅袅袅捏陧聂啮啮嗫镊镍颞蹑孽宁咛拧狞柠聍泞纽钮农农侬哝浓脓弄驽钕疟暖暖傩诺锘讴欧殴瓯鸥呕怄沤盘盘蹒庞刨刨狍炮炮疱胚赔锫佩辔喷鹏碰碰纰铍毗罴骈谝骗骗缥飘飘贫嫔频颦评凭凭苹瓶鲆钋泼颇钷迫仆扑铺铺镤朴谱镨凄凄栖桤戚戚齐脐颀骐骑棋棋蛴旗蕲鳍岂启启绮气讫弃荠碛憩千扦迁佥钎牵悭铅谦愆签签骞荨钤钱钳乾乾潜浅肷谴缱堑椠呛羌戗枪跄锖锵镪强强墙墙嫱蔷樯樯抢羟襁襁炝硗硗跷锹锹缲乔侨荞桥谯憔憔鞒诮峭窍翘窃惬箧锲亲钦琴勤锓寝吣揿揿氢轻倾鲭苘顷请庆穷茕琼丘秋秋鳅鳅虬球赇巯区曲曲岖诎驱驱躯趋鸲癯龋阒觑觑觑权诠辁铨蜷颧绻劝却悫悫确阕阙鹊榷裙裙群冉让荛饶桡扰娆绕热认纫妊轫韧韧饪绒绒绒荣嵘蝾融冗铷颥缛软软蕊蕊蕊锐睿闰润箬洒飒萨腮鳃赛毵伞伞糁馓颡丧骚缫鳋扫涩涩啬铯穑杀纱铩鲨筛晒删姗钐膻闪陕讪骟缮膳赡鳝鳝伤殇觞垧赏绱烧绍赊蛇舍厍设慑慑摄滠绅诜审审谂婶渖肾渗升升声胜渑绳圣剩尸师虱诗狮湿湿酾鲺时识实蚀埘莳鲥驶势视视视试饰是柿贳适轼铈谥谥释寿寿兽绶书纾枢倏倏疏摅输赎薯术树竖竖庶数漱帅闩双谁税顺说说烁铄硕丝咝鸶缌蛳厮锶似祀饲驷俟松怂耸讼诵颂搜馊飕锼擞薮苏苏苏稣诉肃谡溯溯酸虽绥随岁岁谇孙狲荪飧损笋挲蓑缩唢琐锁它铊塔獭鳎挞闼骀台台台抬鲐态钛贪摊滩瘫坛坛坛坛坛昙谈锬谭袒钽叹叹赕汤铴镗饧糖傥烫趟涛绦绦绦掏韬鼗鼗讨铽腾誊藤锑绨啼缇鹈题蹄体体屉剃剃阗条龆鲦眺粜铫贴铁铁铁厅厅听听烃铤同铜统筒恸偷偷头秃图涂涂钍兔团团抟颓颓颓腿蜕饨臀托拖脱驮驼鸵鼍椭拓箨洼娲蛙袜袜腽弯湾纨玩顽挽绾碗碗万亡网往辋望为为韦围帏沩沩违闱涠维潍伟伪伪纬苇炜玮诿韪鲔卫卫谓喂喂猬温纹闻蚊蚊阌吻稳问瓮瓮挝涡莴窝蜗卧龌乌污污邬呜诬钨无吴芜坞坞妩妩庑忤怃鹉务误骛雾鹜诶牺晰溪锡嘻膝习席袭觋玺铣戏戏系系饩细郄阋舄虾侠峡狭硖辖辖吓厦仙纤纤籼莶跹锨鲜闲闲弦贤咸娴娴衔衔痫鹇鹇鹇显险猃蚬藓县岘苋现线线宪馅羡献乡乡芗厢缃骧镶详享响饷飨鲞向向项枭哓骁绡萧销潇箫嚣嚣晓筱效效啸啸蝎协邪胁胁挟谐携携撷缬鞋写泄泻绁绁绁亵谢蟹欣锌衅兴陉幸凶汹胸修鸺馐绣绣锈锈须须顼虚嘘许诩叙叙恤恤勖绪续婿溆轩谖喧萱萱萱萱悬旋璇选癣绚铉楦靴学泶鳕谑勋勋埙埙熏寻巡驯询浔鲟训讯徇逊丫压鸦鸦桠鸭哑痖亚讶垭娅氩咽恹恹烟胭阉腌讠闫严岩岩岩盐阎颜颜檐兖俨厣演魇鼹厌彦砚艳艳验验谚焰雁滟滟酽谳餍燕燕燕赝赝鸯扬扬扬阳杨炀疡养痒样夭尧肴轺窑窑谣摇遥瑶鳐药药鹞耀爷铘野野业叶页邺夜晔烨烨谒靥医医咿铱仪诒迤饴贻移遗颐彝彝钇舣蚁蚁义亿忆艺议异呓呓译峄怿绎诣驿轶谊缢瘗镒翳镱因阴阴荫荫殷铟喑堙吟淫淫银龈饮隐瘾应莺莺婴嘤撄缨罂罂樱璎鹦鹰茔荥荧莹萤营萦滢蓥潆蝇赢颍颖瘿映哟佣拥痈雍墉镛鳙咏涌恿恿踊优忧犹邮莜莸铀游鱿铕佑诱纡余欤鱼娱谀渔嵛逾觎舆与伛屿俣语龉驭吁吁妪饫郁狱钰预欲谕阈御鹆愈愈蓣誉鹬鸢鸳渊员园圆缘鼋猿猿辕橼远愿约岳钥钥钥悦钺阅阅跃粤云匀纭芸郧氲陨殒运郓恽晕酝酝愠韫韵蕴匝杂杂灾灾灾载簪咱咱攒攒攒趱暂赞赞赞錾瓒赃赃赃驵脏脏葬糟凿枣灶皂唣噪则择泽责啧帻箦赜贼谮缯锃赠揸齄扎扎札札轧闸闸铡诈栅榨斋债沾毡毡谵斩盏崭辗占战栈绽骣张獐涨帐胀账钊诏赵棹照哲辄蛰谪谪辙锗这浙鹧贞针针侦浈珍桢砧祯诊轸缜阵鸩赈镇争征峥挣狰钲睁铮筝证证诤郑帧症卮织栀执侄侄职絷跖踯只只址纸轵志制帙帙帜质栉挚致贽轾掷鸷滞骘稚稚置觯踬终钟钟钟肿种冢众众诌周轴帚纣咒绉昼荮皱骤朱诛诸猪铢槠潴橥烛属煮嘱瞩伫伫苎注贮驻筑铸箸专砖砖砖颛转啭赚撰馔妆妆庄桩装壮状骓锥坠缀缒赘谆准桌斫斫斫浊诼镯镯兹兹赀资缁谘辎锱龇鲻姊渍眦综棕踪鬃鬃总总偬纵粽邹驺诹鲰镞诅组躜缵纂钻钻罪樽鳟';
        }
        function FTPYStr() {
            return '錒锿皚噯藹靄愛嬡礙曖璦庵諳鵪鞍埯銨暗暗翱翱鰲鰲襖媼嶴奧驁鈀壩壩罷鮁霸擺唄敗稗頒坂板鈑辦絆幫綁榜膀謗鎊齙褒寶飽鴇褓報鮑杯杯鵯貝狽備背鋇悖憊輩鞴奔奔賁錛繃繃逼秕筆幣畢閉嗶蓽斃鉍篳滗痺蹕闢弊邊籩編鯿貶變緶辯辮標颮驃膘鏢飆飆飚鑣表鰾鱉鱉別別癟賓賓儐濱繽檳鑌瀕擯殯臏髕鬢鬢冰餅禀並並並撥剝缽缽餑駁駁鈸鉑博鵓鈽卜補布钚財采采採彩睬踩參參參驂殘蠶慚慚慘黪燦倉傖滄蒼艙操艹冊側廁廁惻測策策層插馇鍤查察镲詫釵儕蠆覘摻攙嬋讒禪饞纏蟬鐔產產諂鏟鏟闡蕆囅懺顫倀閶鯧長腸萇嚐嚐償廠廠場場悵暢鈔車硨扯徹塵陳諶諶磣磣闖襯稱齔趁櫬讖檉蟶鐺撐棖誠乘鋮懲塍澄騁吃鴟痴馳遲齒恥飭熾敕沖沖蟲寵銃儔幬綢疇籌酬酬酬躊讎讎醜瞅出芻廚鋤鋤雛櫥躕礎儲處處絀觸傳船釧囪瘡窗窗窗床創愴捶棰錘錘春純唇蓴蓴淳鶉醇綽輟齪詞辭辭鶿鶿糍賜從匆匆蓯樅蔥驄聰叢叢湊輳粗粗蹴攛鑹躥竄篡脆村鹺銼錯噠達沓韃呆紿帶玳貸單擔鄲殫癉簞膽撣誕啖啖彈憚噹噹當襠擋擋黨讜氹碭蕩蕩檔導島搗搗禱燾盜锝德燈鄧凳鐙堤鏑糴敵滌覿詆抵抵遞諦締蒂顛巔癲點電墊鈿淀雕雕雕鯛吊釣調铞諜喋疊疊疊蝶鰈釘頂訂碇碇錠丟铥東冬岽岽鶇動凍峒棟腖兜鬥鬥鬥鈄豆竇讀瀆瀆櫝櫝牘犢黷獨篤賭睹妒鍍端斷緞煅鍛簖隊對兌懟鐓噸墩躉燉鈍頓遁奪鐸朵垛綞墮跺訛訛峨鋨鵝鵝額婀厄厄軛堊惡惡餓諤閼萼腭鍔鶚顎鱷鱷兒鴯鮞爾邇餌鉺貳發發罰罰閥法琺帆翻翻凡礬釩煩繁泛泛飯範販鈁魴仿仿仿訪紡飛緋鯡誹廢費痱鐨紛氛墳奮僨憤糞鱝豐風灃楓瘋砜峰鋒馮縫諷鳳佛夫膚麩麩鳧紱紼輻幞嘸撫俯俯輔訃婦負附駙复复賦縛鮒賻鰒钆嘎該賅丐丐鈣蓋概幹幹桿尷尷稈趕紺贛岡剛崗綱肛鋼槓戇皋槔糕縞稿鎬誥鋯紇胳鴿擱歌閣鎘個個鉻給亙耕賡綆鯁鯁宮躬龔鞏貢溝鉤鉤緱構構詬購夠覯軲鴣轂鶻詁谷鈷蠱鵠鼓顧僱錮鯝刮鴰剮詿掛拐拐怪關關觀鰥館館管管貫慣摜鸛罐廣獷歸媯媯龜規規閨瑰鮭軌匭詭劊劌櫃貴鱖袞緄輥滾鯀鯀呙堝鍋蟈國國幗摑果槨過鉿駭頇函韓漢悍焊焊頷絎頏蠔嗥號皓皓顥灝訶合合和閡核盍頜闔賀鶴恆橫轟哄紅閎葒鴻黌訌餱鱟呼呼呼轷胡胡壺鶘糊滸戶沍護滬鹱花花華嘩嘩驊鏵劃畫話樺懷壞歡歡獾還環鍰繯緩奐喚換渙煥瘓鯇黃鰉恍謊詼咴揮暉琿輝輝徽回回回回蛔蛔蛔蛔匯匯匯會諱噦澮繪薈誨檜燴賄穢繢毀毀毀昏葷閽渾餛諢锪钬貨獲獲禍鑊譏擊嘰飢飢機璣磯雞雞跡跡積績績緝齎齎躋齏羈級極楫輯幾蟣擠計記紀際劑嚌濟繼覬薊霽鱭鯽驥夾夾浹家鎵郟莢鋏蛺頰賈鉀價駕戔姦堅殲間艱監箋箋緘縑鰹鶼韉揀梘儉繭撿筧減檢瞼襉鐧簡譾戩鹼鹼見餞劍劍薦賤澗艦漸諫濺踐鑑鑑鑑鍵檻姜將漿僵韁韁講獎槳蔣絳醬嬌澆驕膠鮫鷦僥撟絞餃矯腳鉸攪剿繳叫嶠轎較階階癤秸節訐劫劫劫傑詰潔結頡鮚屆誡斤僅卺緊謹錦饉盡盡勁進藎晉燼贐贐縉覲涇經莖荊驚鯨阱剄頸淨弳徑徑脛痙競靚靜鏡迥炯糾鳩鬮揪韭舊厩厩救鷲駒鋦局局舉舉櫸齟詎鉅劇懼據颶鋸窶屨鵑鐫鐫卷錈倦桊狷絹雋眷決訣珏絕覺譎橛镢镢軍鈞皸俊浚駿咔開锎凱剴塏愷鎧慨鍇愾龕坎侃闞瞰糠糠閌炕鈧考銬軻疴鈳頦顆殼咳克克課騍緙錁肯墾懇坑鏗摳眍叩扣寇庫絝嚳褲誇塊儈鄶噲獪膾寬髖款誆誑鄺壙纊況曠礦礦貺虧巋窺窺匱憒愧潰蕢饋饋簣聵坤昆昆錕鯤捆捆閫困擴闊闊臘蠟辣來崍徠淶萊錸賚睞賴賴瀨癩籟蘭嵐攔欄婪闌藍讕瀾襤斕籃鑭覽攬纜欖懶懶爛濫瑯鋃螂閬撈勞嘮嶗癆铹銠澇耢樂鳓縲鐳誄壘淚類累棱厘梨狸離驪犁鸝漓褵蘺璃璃鱺籬藜禮里里邐鋰鯉鱧歷歷歷厲麗勵嚦壢瀝藶櫪癘隸隸儷櫟癧癧荔轢酈栗礪礫蒞蒞糲蠣躒靂倆奩奩奩奩連簾憐漣蓮聯褳廉鰱鐮斂斂璉臉襝蘞練孌煉煉戀殮鏈瀲涼梁糧兩魎諒輛遼療繚鐐鷯釕獵鄰鄰臨淋轔磷磷鱗麟凜廩懍檁吝賃藺躪靈靈嶺凌鈴櫺櫺綾菱齡鯪領溜劉瀏留琉琉餾騮瘤鎦柳柳綹锍鷚龍嚨瀧蘢櫳瓏朧礱籠聾隴壟壟攏婁僂嘍蔞樓耬螻髏嶁摟簍瘺瘺鏤嚕擼盧廬蘆壚壚瀘爐爐櫨臚轤鸕艫顱鱸鹵鹵虜擄魯櫓櫓櫓镥陸錄賂輅淥祿濾戮轆鷺氌驢閭櫚呂侶稆鋁屢縷褸慮綠孿巒攣欒鸞臠灤鑾亂略鋝掄崙崙倫圇淪綸輪論羅羅玀腡蘿邏欏鑼籮騾騾鏍裸裸濼絡犖駱媽嬤麻蟆馬獁瑪碼螞榪罵罵嘜嗎買蕒勱邁麥賣脈脈顢蠻饅瞞鰻滿蟎謾縵鏝貓犛犛錨鉚冒貿帽帽麼沒梅梅镅鶥黴鎂門捫鍆悶燜懣們濛濛蒙錳夢彌彌祢獼謎羋瞇覓覓秘冪謐綿綿黽緬靦面面面鶓緲妙廟咩滅蔑珉緡緡閔泯閩憫愍鳘鳴銘謬繆謨饃饃模歿驀鏌謀畝鉬幕拿拿镎內納鈉乃乃奶難楠楠馕撓鐃蟯垴惱腦鬧鬧訥餒嫩鈮霓鯢你擬暱膩鮎鯰捻輦攆念娘釀鳥蔦裊裊裊捏隉聶囓囓囁鑷鎳顳躡孽寧嚀擰獰檸聹濘紐鈕農農儂噥濃膿弄駑釹瘧暖暖儺諾锘謳歐毆甌鷗嘔慪漚盤盤蹣龐刨刨狍炮炮皰胚賠锫佩轡噴鵬碰碰紕鈹毗羆駢諞騙騙縹飄飄貧嬪頻顰評憑憑蘋瓶鮃釙潑頗钷迫僕撲鋪鋪镤樸譜镨淒淒棲榿戚戚齊臍頎騏騎棋棋蠐旗蘄鰭豈啟啟綺氣訖棄薺磧憩千扦遷僉釬牽慳鉛謙愆簽簽騫蕁鈐錢鉗乾乾潛淺肷譴繾塹槧嗆羌戧槍蹌錆鏘鏹強強牆牆嬙薔檣檣搶羥襁襁熗磽磽蹺鍬鍬繰喬僑蕎橋譙憔憔鞒誚峭竅翹竊愜篋鍥親欽琴勤鋟寢吣撳撳氫輕傾鯖檾頃請慶窮煢瓊丘秋秋鰍鰍虯球賕巰區曲曲嶇詘驅驅軀趨鴝癯齲闃覷覷覷權詮輇銓蜷顴綣勸卻愨愨確闋闕鵲榷裙裙群冉讓蕘饒橈擾嬈繞熱認紉妊軔韌韌飪絨絨絨榮嶸蠑融冗銣顬縟軟軟蕊蕊蕊銳睿閏潤箬灑颯薩腮鰓賽毿傘傘糝馓顙喪騷繅鳋掃澀澀嗇銫穡殺紗鎩鯊篩曬刪姍釤羶閃陝訕騸繕膳贍鱔鱔傷殤觴垧賞绱燒紹賒蛇舍厙設懾懾攝灄紳詵審審諗嬸渖腎滲升升聲勝澠繩聖剩屍師蝨詩獅濕濕釃鲺時識實蝕塒蒔鰣駛勢視視視試飾是柿貰適軾鈰諡諡釋壽壽獸綬書紓樞倏倏疏攄輸贖薯術樹豎豎庶數漱帥閂雙誰稅順說說爍鑠碩絲噝鷥緦螄廝鍶似祀飼駟俟松慫聳訟誦頌搜餿颼鎪擻藪蘇蘇蘇穌訴肅謖溯溯酸雖綏隨歲歲誶孫猻蓀飧損筍挲蓑縮嗩瑣鎖它鉈塔獺鰨撻闥駘台台台抬鮐態鈦貪攤灘癱壇壇壇壇壇曇談錟譚袒鉭嘆嘆賧湯铴鏜餳糖儻燙趟濤絛絛絛掏韜鞀鞀討铽騰謄藤銻綈啼緹鵜題蹄體體屜剃剃闐條齠鰷眺糶銚貼鐵鐵鐵廳廳聽聽烴鋌同銅統筒慟偷偷頭禿圖塗塗釷兔團團摶頹頹頹腿蛻飩臀托拖脫馱駝鴕鼉橢拓籜窪媧蛙襪襪膃彎灣紈玩頑挽綰碗碗萬亡網往輞望為為韋圍幃溈溈違闈潿維濰偉偽偽緯葦煒瑋諉韙鮪衛衛謂喂喂猬溫紋聞蚊蚊閿吻穩問甕甕撾渦萵窩蝸臥齷烏污污鄔嗚誣鎢無吳蕪塢塢嫵嫵廡忤憮鵡務誤騖霧鶩誒犧晰溪錫嘻膝習席襲覡璽銑戲戲系系餼細郄鬩舄蝦俠峽狹硤轄轄嚇廈仙纖纖秈薟躚鍁鮮閒閒弦賢咸嫻嫻銜銜癇鷴鷴鷴顯險獫蜆蘚縣峴莧現線線憲餡羨獻鄉鄉薌廂緗驤鑲詳享響餉饗鯗向向項梟嘵驍綃蕭銷瀟簫囂囂曉筱效效嘯嘯蠍協邪脅脅挾諧攜攜擷纈鞋寫泄瀉紲紲紲褻謝蟹欣鋅釁興陘幸兇洶胸修鵂饈繡繡銹銹須須頊虛噓許詡敘敘卹卹勗緒續婿溆軒諼喧萱萱萱萱懸旋璇選癬絢鉉楦靴學澩鱈謔勳勳塤塤熏尋巡馴詢潯鱘訓訊徇遜丫壓鴉鴉椏鴨啞瘂亞訝埡婭氬咽懨懨煙胭閹醃讠閆嚴岩岩岩鹽閻顏顏簷兗儼厴演魘鼴厭彥硯艷艷驗驗諺焰雁灩灩釅讞饜燕燕燕贗贗鴦揚揚揚陽楊煬瘍養癢樣夭堯餚軺窯窯謠搖遙瑤鰩藥藥鷂耀爺铘野野業葉頁鄴夜曄燁燁謁靨醫醫咿銥儀詒迤飴貽移遺頤彝彝釔艤蟻蟻義億憶藝議異囈囈譯嶧懌繹詣驛軼誼縊瘞鎰翳鐿因陰陰蔭蔭殷銦喑堙吟淫淫銀齦飲隱癮應鶯鶯嬰嚶攖纓罌罌櫻瓔鸚鷹塋滎熒瑩螢營縈瀅鎣瀠蠅贏潁穎癭映喲傭擁癰雍墉鏞鳙詠湧恿恿踴優憂猶郵莜蕕鈾遊魷銪佑誘紆餘歟魚娛諛漁嵛逾覦輿與傴嶼俁語齬馭吁吁嫗飫鬱獄鈺預欲諭閾禦鵒愈愈蕷譽鷸鳶鴛淵員園圓緣黿猿猿轅櫞遠願約岳鑰鑰鑰悅鉞閱閱躍粵雲勻紜芸鄖氳隕殞運鄆惲暈醞醞慍韞韻蘊匝雜雜災災災載簪咱咱攢攢攢趲暫讚讚贊鏨瓚贓贓贓駔髒髒葬糟鑿棗灶皂唣噪則擇澤責嘖幘簀賾賊譖繒鋥贈揸齄紮紮札札軋閘閘鍘詐柵榨齋債沾氈氈譫斬盞嶄輾佔戰棧綻骣張獐漲帳脹賬釗詔趙棹照哲輒蟄謫謫轍鍺這浙鷓貞針針偵湞珍楨砧禎診軫縝陣鴆賑鎮爭徵崢掙猙鉦睜錚箏證證諍鄭幀症卮織梔執侄侄職縶蹠躑隻隻址紙軹志制帙帙幟質櫛摯致贄輊擲鷙滯騭稚稚置觶躓終鐘鐘鐘腫種塚眾眾謅週軸帚紂咒縐晝荮皺驟朱誅諸豬銖櫧瀦櫫燭屬煮囑矚佇佇苧注貯駐築鑄箸專磚磚磚顓轉囀賺撰饌妝妝莊樁裝壯狀騅錐墜綴縋贅諄準桌斫斫斫濁諑鐲鐲茲茲貲資緇諮輜錙齜鯔姊漬眥綜棕踪鬃鬃總總傯縱粽鄒騶諏鯫鏃詛組躦纘纂鑽鑽罪樽鱒';
        }
        function Traditionalized(cc) {
            var str = '', ss = JTPYStr(), tt = FTPYStr();
            for (var i = 0; i < cc.length; i++) {
                if (cc.charCodeAt(i) > 10000 && ss.indexOf(cc.charAt(i)) != -1) str += tt.charAt(ss.indexOf(cc.charAt(i)));
                else str += cc.charAt(i);
            }
            return getStrFilterUpdate(str);
        }
        function Simplized(cc) {
            var str = '', ss = JTPYStr(), tt = FTPYStr();
            for (var i = 0; i < cc.length; i++) {
                if (cc.charCodeAt(i) > 10000 && tt.indexOf(cc.charAt(i)) != -1) str += ss.charAt(tt.indexOf(cc.charAt(i)));
                else str += cc.charAt(i);
            }
            return getStrFilterUpdate(str);
        }
        function getChangeField(value) {
            return parent.jQuery.trim(value);
        }
        function getStrFilterUpdate(str) {
            // update — 
            var regMdash = new RegExp("&mdash;", "gi");
            str = str.replace(regMdash, "—");
            // update ·
            var regMiddot = new RegExp("&middot;", "gi");
            str = str.replace(regMiddot, "·");
            // update “
            var regLdquo = new RegExp("&ldquo;", "gi");
            str = str.replace(regLdquo, "“");
            // update ”
            var regRdquo = new RegExp("&rdquo;", "gi");
            str = str.replace(regRdquo, "”");
            // update ‘
            var regAmpLsquo = new RegExp("&amp;lsquo;", "gi");
            str = str.replace(regAmpLsquo, "‘");
            // update ’
            var regAmpRsquo = new RegExp("&amp;rsquo;", "gi");
            str = str.replace(regAmpRsquo, "’");
            // update ‘
            var regLsquo = new RegExp("&lsquo;", "gi");
            str = str.replace(regLsquo, "‘");
            // update ’
            var regRsquo = new RegExp("&rsquo;", "gi");
            str = str.replace(regRsquo, "’");
            // update '  
            var reg39 = new RegExp("&#39;", "gi");
            str = str.replace(reg39, "'");
            // update <
            var regRdquo = new RegExp("&lt;", "gi");
            str = str.replace(regRdquo, "<");
            // update >
            var regGt = new RegExp("&gt;", "gi");
            str = str.replace(regGt, ">");
            // update ≤
            var regLe = new RegExp("&le;", "gi");
            str = str.replace(regLe, "≤");
            // update ≥
            var regGe = new RegExp("&ge;", "gi");
            str = str.replace(regGe, "≥");
            // update ×
            var regTimes = new RegExp("&times;", "gi");
            str = str.replace(regTimes, "×");
            // update ÷
            var regDivide = new RegExp("&divide;", "gi");
            str = str.replace(regDivide, "÷");
            // update –
            var regNdash = new RegExp("&ndash;", "gi");
            str = str.replace(regNdash, "–");
            // update …
            var regHellip = new RegExp("&hellip;", "gi");
            str = str.replace(regHellip, "…");
            // update ±
            var regHplusmn = new RegExp("&plusmn;", "gi");
            str = str.replace(regHplusmn, "±");
            // update ∞
            var regHinfin = new RegExp("&infin;", "gi");
            str = str.replace(regHinfin, "∞");
            // update δ
            var regHdelta = new RegExp("&delta;", "gi");
            str = str.replace(regHdelta, "δ");
            // update ∝
            var regHprop = new RegExp("&prop;", "gi");
            str = str.replace(regHprop, "∝");
            // update ∨
            var regHor = new RegExp("&or;", "gi");
            str = str.replace(regHor, "∨");
            // update ∧
            var regHand = new RegExp("&and;", "gi");
            str = str.replace(regHand, "∧");
            // update ‰
            var regHpermil = new RegExp("&permil;", "gi");
            str = str.replace(regHpermil, "‰");
            // update ·
            var regH8226 = new RegExp("&#8226;", "gi");
            str = str.replace(regH8226, "·");
            // update `
            var regHbull = new RegExp("&bull;", "gi");
            str = str.replace(regHbull, "`");
            // update 欧元符号
            //本字符串是欧元符号的unicode码, GBK编辑中不支持欧元符号(需更改为UTF-8), 故只能使用unicode码
            var regHeuro = new RegExp("&euro;", "gi");
            str = str.replace(regHeuro, "\u20AC");
            // update →
            var regHrarr = new RegExp("&rarr;", "gi");
            str = str.replace(regHrarr, "→");

            var reg160 = new RegExp("&amp;#160;", "gi");
            str = str.replace(reg160, " ");

            var regSup3 = new RegExp("m&sup3;", "gi");
            str = str.replace(regSup3, "m3");
            return str;
        }

        return {
            ToSimplized: Simplized,
            ToTraditionalized: Traditionalized
        };
    })();

    function parseToMVals(mval) {
        if (!mval) return {};

        var transfer = MLPicker.transfer;
        var value = mval.replace(/^~`~`|`~`~$/g, "").split(symbol), vals = {};

        if (value.length == 1 && value[0] === mval) return { "7" : mval };

        value.forEach(function (v) {
            var key = v.replace(/([\d]{1,2}) [\s\S]*/, "$1");
            v = v.replace(/[\d]{1,2} /, "");

            vals[key] = v;
        });
        return vals;
    }

    $.fn.MLanguage = function (config) {
        this.each(function () {
            new MultiLanguage(this, config);
        });
    };

    return MultiLanguage;
}));