Ext.namespace('e2cs.cal_locale');
e2cs.cal_locale={
	loadmaskText: '处理中....<br>请稍候...!',
	// Calendar locale
    dateSelectorText:    '选择..',
    dateSelectorTooltip: '选择日期..',
	// Why i have my own locale for days and months you will ask ? i didn't want to mess with ext locale and prefer the widget will have his own locale
    monthtitles:["一月",     "二月",     "三月",
                 "四月",     "五月",             "六月",
                 "七月",     "八月",         "九月",
                 "十月",     "十一月",     "十二月"],
    daytitles:  ["日",     "一",         "二",     "三","四",     "五",     "六"],
    todayLabel: '今天',
    todayToolTip: '设置今天日期...',

	// toolbar buttons tooltips
    tooltipMonthView:    '查看月视图...',
    tooltipWeekView:    '查看周视图...',
    tooltipDayView:        '查看日视图...',
    tooltipSchedView:   '查看计划视图...',		
	// tpl for zoom tasks general labels
    win_tasks_format:  '月-日-年',
    win_tasks_loading: '载入中...',
    win_tasks_empty:   '没有任务...',
	// Month view locale
    win_month_zoomlabel:'计划',
	headerTooltipsMonth: {
        prev: '上月..',
        next: '下月'
	},
	contextMenuLabelsMonth: {
        task: "添加新任务",
        chgwview: "切换到周视图...",
        chgdview: "切换到日视图...",
		gonextmonth: "查看下个月",     // 0.0.4
		goprevmonth: "查看上个月"     // 0.0.4
	},
    labelforTasksinMonth: '计划',
	// Dayview and daytask  locale
	//-----------------------------------------------------------------
	task_MoreDaysFromTask: '<br>(+)',
	task_LessDaysFromTask: '(-)<br>',
    task_qtip_starts:     '开始: ',
    task_qtip_ends:     '结束: ',
	headerTooltipsDay: {
            prev: '上一日',
            next: '下一日'
	},
	contextMenuLabelsDay: {
        taskAdd: "新任务",
        taskDelete: "删除任务",
        taskEdit: "编辑任务:",
        NextDay: "查看下一日",
        PreviousDay: "查看上一日",
        chgmview:"切换到月视图",
        chgwview:"切换到周视图",
        chgsview: "切换到计划视图..."

	},
	//-----------------------------------------------------------------
	//Week view  and weektask locale  // 0.0.4
	contextMenuLabelsWeek: {
		prev: "查看上一周.",
		next: "查看下一周.",
		chgdview: "切换到日视图",
		chgmview: "切换到月视图",
        chgsview: "切换到计划视图..."
	},
	//0.0.4
	headerTooltipsWeek: {
		prev: '上一周.',
		next: '下一周.'
	},
    labelforTasksinWeek: '更多周任务:',
    win_week_zoomlabel:'更多任务...',
    weekheaderlabel:'',
    weekheaderlabel_from:'周 从:',
    weekheaderlabel_to:' 至:',
    alldayTasksMaxLabel:'查看全部日任务..',
    Scheduler_selector:'选择期间',
	scheduler_noeventsonview:'<p>此期间没有任务</p>',
	scheduler_period_from_to:{
		starts:'从',
		ends:'到'
	},
	headerTooltipsScheduler: {
		prev: '上一期间',
		next: '下一期间'
	},
	scheduler_headerListStrings: {
		Day: "日",
		week: "周",
		period:"期间",
		start: "从",
		end: "到"
	},
	contextMenuLabelsSchedule: {
        taskAdd: "新任务",
        taskDelete: "删除任务",
        taskEdit: "编辑任务:",
        chgmview:"切换到月视图",
        chgwview:"切换到周视图",
        chgsview: "切换到计划视图...",
		NextPeriod: 	"查看下一期间",
		PreviousPeriod: "查看上一期间",
		chgwview: "切换到周视图...",
		chgmview: "切换到月视图...",
		chgdview: "切换到日视图..."
	}

}