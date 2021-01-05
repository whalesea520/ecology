alter table hpBaseElement add isbase varchar(1)
/
update hpBaseElement set isbase = '1' where id in ('1', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '25', '29', '32', '34', '6', '7', '8', '9', 'addwf', 'audio', 'blogStatus', 'contacts', 'DataCenter', 'favourite', 'Flash', 'FormModeCustomSearch', 'imgSlide', 'jobsinfo', 'login', 'menu', 'MyCalendar', 'newNotice', 'news', 'notice', 'OutData', 'outterSys', 'picture', 'plan', 'reportForm', 'scratchpad', 'searchengine', 'share', 'Slide', 'Task', 'template', 'video', 'weather')
/
