/*
 * Ext JS Library 2.0.2
 * Copyright(c) 2006-2008, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * http://extjs.com/license
 */

SamplePanel = Ext.extend(Ext.Panel, {
    autoHeight: true,
    frame:true,
    collapsible: true,
    cls:'demos',

    afterRender : function(){
        SamplePanel.superclass.afterRender.call(this);
        this.tpl.overwrite(this.body, this);
    },

    tpl : new Ext.XTemplate(
        '<dl>',
            '<tpl for="samples">',
            '<dt><a href="{url}" target="_blank"><img src="shared/screens/{icon}"/></a><br/>',
                '<span>{text}</span>',
            '</dt>',
            '</tpl>',
        '</dl><div style="clear:both"></div>'
    )
});

Ext.EventManager.on(window, 'load', function(){

    var catalog = [{
        title: 'Combination Samples',
        samples: [{
            text: 'Feed Viewer',
            url: 'feed-viewer/view.html',
            icon: 'feeds_wev8.gif'
        },{
            text: 'Simple Tasks (<a href="http://gears.google.com" target="_blank">Google Gears</a>)',
            url: 'tasks/tasks.html',
            icon: 'tasks_wev8.gif'
        },{
            text: 'Simple Tasks (<a href="http://labs.adobe.com/technologies/air/" target="_blank">Adobe AIR</a>)',
            url: 'http://extjs.com/blog/2007/06/29/building-a-desktop-application-with-ext-air-aptana-and-red-bull/',
            icon: 'air_wev8.gif'
        },{
            text: 'Image Organizer',
            url: 'organizer/organizer.html',
            icon: 'organizer_wev8.gif'
        },{
            text: 'Web Desktop',
            url: 'desktop/desktop.html',
            icon: 'desktop_wev8.gif'
        }]
    },{
        title: 'Grids',
        samples: [{
            text: 'Basic Array Grid',
            url: 'grid/array-grid.html',
            icon: 'grid-array_wev8.gif'
        },{
            text: 'Editable Grid',
            url: 'grid/edit-grid.html',
            icon: 'grid-edit_wev8.gif'
        },{
            text: 'XML Grid',
            url: 'grid/xml-grid.html',
            icon: 'grid-xml_wev8.gif'
        },{
            text: 'Paging',
            url: 'grid/paging.html',
            icon: 'grid-paging_wev8.gif'
        },{
            text: 'Grouping',
            url: 'grid/grouping.html',
            icon: 'grid-grouping_wev8.gif'
        },{
            text: 'Live Group Summary',
            url: 'grid/totals.html',
            icon: 'grid-summary_wev8.gif'
        },{
            text: 'Customizing: Grid Plugins',
            url: 'grid/grid3.html',
            icon: 'grid-plugins_wev8.gif'
        }]
    },{
        title: 'Tabs',
        samples: [{
            text: 'Basic Tabs',
            url: 'tabs/tabs.html',
            icon: 'tabs_wev8.gif'
        },{
            text: 'Advanced Tabs',
            url: 'tabs/tabs-adv.html',
            icon: 'tabs-adv_wev8.gif'
        }]
    },{
        title: 'Windows',
        samples: [{
            text: 'Hello World',
            url: 'window/hello.html',
            icon: 'window_wev8.gif'
        },{
            text: 'MessageBox',
            url: 'message-box/msg-box.html',
            icon: 'msg-box_wev8.gif'
        },{
            text: 'Layout Window',
            url: 'window/layout.html',
            icon: 'window-layout_wev8.gif'
        }]
    },{
        title: 'Trees',
        samples: [{
            text: 'Drag and Drop Reordering',
            url: 'tree/reorder.html',
            icon: 'tree-reorder_wev8.gif'
        },{
            text: 'Multiple trees',
            url: 'tree/two-trees.html',
            icon: 'tree-two_wev8.gif'
        },{
            text: 'Customizing: Column Tree',
            url: 'tree/column-tree.html',
            icon: 'tree-columns_wev8.gif'
        }]
    },{
        title: 'Layout Managers',
        samples: [{
            text: 'Border Layout',
            url: 'layout/complex.html',
            icon: 'border-layout_wev8.gif'
        },{
            text: 'Anchor Layout',
            url: 'form/anchoring.html',
            icon: 'anchor_wev8.gif'
        },{
            text: 'Customizing: Portals',
            url: 'portal/portal.html',
            icon: 'portal_wev8.gif'
        }]
    },{
        title: 'ComboBox',
        samples: [{
            text: 'Basic ComboBox',
            url: 'form/combos.html',
            icon: 'combo_wev8.gif'
        },{
            text: 'Customizing: ComboBox Templates',
            url: 'form/forum-search.html',
            icon: 'combo-custom_wev8.gif'
        }]
    },{
        title: 'Forms',
        samples: [{
            text: 'Dynamic Forms',
            url: 'form/dynamic.html',
            icon: 'form-dynamic_wev8.gif'
        },{
            text: 'Ajax with XML Forms',
            url: 'form/xml-form.html',
            icon: 'form-xml_wev8.gif'
        },{
            text: 'Customizing: Search Field',
            url: 'form/custom.html',
            icon: 'form-custom_wev8.gif'
        }]
    },{
        title: 'Toolbars and Menus',
        samples: [{
            text: 'Basic Toolbar',
            url: 'menu/menus.html',
            icon: 'toolbar_wev8.gif'
        },{
            text: 'Ext Actions',
            url: 'menu/actions.html',
            icon: 'toolbar-actions_wev8.gif'
        }]
    },{
        title: 'Miscellaneous',
        samples: [{
            text: 'DataView',
            url: 'view/data-view.html',
            icon: 'data-view_wev8.gif'
        },{
            text: 'DataView (advanced)',
            url: 'view/chooser.html',
            icon: 'chooser_wev8.gif'
        },{
            text: 'Progress Bar',
            url: 'simple-widgets/progress-bar.html',
            icon: 'progress_wev8.gif'
        },{
            text: 'Templates',
            url: 'core/templates.html',
            icon: 'templates_wev8.gif'
        },{
            text: 'Panels',
            url: 'panel/panels.html',
            icon: 'panel_wev8.gif'
        },{
            text: 'Resizable',
            url: 'resizable/basic.html',
            icon: 'resizable_wev8.gif'
        }]
    }];

    for(var i = 0, c; c = catalog[i]; i++){
        c.id = 'sample-' + i;
        new SamplePanel(c).render('all-demos');
    }

    var tpl = new Ext.XTemplate(
        '<dl><tpl for="."><dt><a href="#{id}">{title:stripTags}</a></dt></tpl></dl>'
    );
    tpl.overwrite('demo-menu', catalog);

    Ext.select('#sample-spacer').remove();
    Ext.get('loading').fadeOut({remove: true});
});