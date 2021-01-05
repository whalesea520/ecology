
/**
 * Ext.ux.UploadDialog namespace.
 */
Ext.namespace('Ext.ux.UploadDialog');

/**
 * File upload browse button.
 * 
 * @class Ext.ux.UploadDialog.BrowseButton
 */
Ext.ux.UploadDialog.BrowseButton = Ext.extend(Ext.Button, {
	input_name : 'file',

	input_file : null,

	original_handler : null,

	original_scope : null,

	/**
	 * @access private
	 */
	initComponent : function() {
		Ext.ux.UploadDialog.BrowseButton.superclass.initComponent.call(this);
		this.original_handler = this.handler || null;
		this.original_scope = this.scope || window;
		this.handler = null;
		this.scope = null;
	},

	/**
	 * @access private
	 */
	onRender : function(ct, position) {
		Ext.ux.UploadDialog.BrowseButton.superclass.onRender.call(this, ct,
				position);
		this.createInputFile();
	},

	/**
	 * @access private
	 */
	createInputFile : function() {
		var button_container = this.el.child('.x-btn-center');
		button_container.position('relative');
		this.input_file = Ext.DomHelper.append(button_container, {
			tag : 'input',
			type : 'file',
			size : 1,
			name : this.input_name || Ext.id(this.el),
			style : 'position: absolute; display: block; border: none; cursor: pointer'
		}, true);

		this.input_file.setOpacity(0.0);
		this.adjustInputFileBox();

		if (this.handleMouseEvents) {
			this.input_file.on('mouseover', this.onMouseOver, this);
			this.input_file.on('mousedown', this.onMouseDown, this);
		}

		if (this.tooltip) {
			if (typeof this.tooltip == 'object') {
				Ext.QuickTips.register(Ext.apply({
					target : this.input_file
				}, this.tooltip));
			} else {
				this.input_file.dom[this.tooltipType] = this.tooltip;
			}
		}

		this.input_file.on('change', this.onInputFileChange, this);
		this.input_file.on('click', function(e) {
			e.stopPropagation();
		});
	},

	/**
	 * @access private
	 */
	autoWidth : function() {
		Ext.ux.UploadDialog.BrowseButton.superclass.autoWidth.call(this);
		this.adjustInputFileBox();
	},

	/**
	 * @access private
	 */
	adjustInputFileBox : function() {
		var btn_cont, btn_box, inp_box, adj;

		if (this.el && this.input_file) {
			btn_cont = this.el.child('.x-btn-center');
			btn_box = btn_cont.getBox();
			this.input_file.setStyle('font-size', (btn_box.width * 0.5) + 'px');
			inp_box = this.input_file.getBox();
			adj = {
				x : 3,
				y : 3
			}
			if (Ext.isIE) {
				adj = {
					x : -3,
					y : 3
				}
			}
			this.input_file.setLeft(btn_box.width - inp_box.width + adj.x
					+ 'px');
			this.input_file.setTop(btn_box.height - inp_box.height + adj.y
					+ 'px');
		}
	},

	/**
	 * @access public
	 */
	detachInputFile : function(no_create) {
		var result = this.input_file;

		no_create = no_create || false;

		if (typeof this.tooltip == 'object') {
			Ext.QuickTips.unregister(this.input_file);
		} else {
			this.input_file.dom[this.tooltipType] = null;
		}
		this.input_file.removeAllListeners();
		this.input_file = null;

		if (!no_create) {
			this.createInputFile();
		}
		return result;
	},

	/**
	 * @access public
	 */
	getInputFile : function() {
		return this.input_file;
	},

	/**
	 * @access public
	 */
	disable : function() {
		Ext.ux.UploadDialog.BrowseButton.superclass.disable.call(this);
		this.input_file.dom.disabled = true;
	},

	/**
	 * @access public
	 */
	enable : function() {
		Ext.ux.UploadDialog.BrowseButton.superclass.enable.call(this);
		this.input_file.dom.disabled = false;
	},

	/**
	 * @access public
	 */
	destroy : function() {
		var input_file = this.detachInputFile(true);
		input_file.remove();
		input_file = null;
		Ext.ux.UploadDialog.BrowseButton.superclass.destroy.call(this);
	},

	/**
	 * @access private
	 */
	onInputFileChange : function() {
		// TODO
		loadLocalXMLFile(this.input_file.dom.value);
	}
});

/**
 * Toolbar file upload browse button.
 * 
 * @class Ext.ux.UploadDialog.TBBrowseButton
 */
Ext.ux.UploadDialog.TBBrowseButton = Ext.extend(
		Ext.ux.UploadDialog.BrowseButton, {
			hideParent : true,

			onDestroy : function() {
				Ext.ux.UploadDialog.TBBrowseButton.superclass.onDestroy
						.call(this);
				if (this.container) {
					this.container.remove();
				}
			}
		});
