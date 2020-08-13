<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<style type="text/css">
.w-e-text-container{
    height: 300px !important; 
</style>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script>
	var selectUrl = "${ctx}/jsp/xxkgl/select.do";
	var insertUrl = "${ctx}/jsp/xxkgl/insert.do";
	var updateUrl = "${ctx}/jsp/xxkgl/update.do";

	var fileDownloadUrl = "${ups}/sys/file/download.do";
	var fileDeleteUrl = "${ctx}/sdk/file/delete.do";

	var closeItem = { action : "closeItem", target : document.location.toString() }; //关闭

	var obj = new Object();
	obj.node = "${param.node}";
	if("${param.orderId}"!="undefined" && "${param.orderId}"!=undefined){
		obj.id = "${param.orderId}";
	}
	
	$(window).ready(function() {
		$("#thisform")[0].reset(); 
		display();

		if (obj.node == "0") { //新增
			$("#thisform").attr("action", insertUrl);
		} else { //修改/查看
			$("#thisform").attr("action", updateUrl);
			obj.url = selectUrl; 
			ajax(obj, function(result) { // 查询业务数据
				if ("error" == result.resCode) {
					layer.msg(result.resMsg);
				} else {
					$("#thisform").fill(result.datas[0]);
					fillSelect("#thisform",result.datas[0]);
					//表格填充
					$("#file_table").bootstrapTable("load",result.datas[0].fileObjs);
					display();
				}
			});
		}
		 
		$(".action button").on("click", function() {
			try {
				obj.result = $(this).attr("result");
				if ("取消" == obj.result) {
					return doMessage(closeItem);
				}

				$("*", $("#thisform")).attr("disabled", false);
				var b = $("#thisform").validationEngine("validate"); 
				if (b && confirm("您确定要" + obj.result + "吗？")) {
					ajaxSubmit("#thisform", obj, function(result) {
						if ("error" == result.resCode) {
							layer.msg(result.resMsg);
						} else {
							layer.msg("数据处理成功！", {
								time:500,
								shade : [ 0.1, "#fff" ]  
							}, function() {
								return doMessage(closeItem);
							});
						}
					});
				}
				display();
			} catch (e) {
			}
		});
		//初始化文件上传框
		var oFileInput = new FileInput();
	    oFileInput.Init("xxkgl_files");
		//初始化表格框
		var params = {
			columns: [
				{
					field: "id",
					title: "ID",
					visible: false
				},{
					field: "file_name",
					title: "文件名"
				},{
					field: "file_ext",
					title: "文件类型"
				},{
					field: "created",
					title: "上传时间"
				}, {
			        field: 'column_operate',
			        title: '操作',
			        width: 120,
			        formatter: function(value, row, index) {
				        var str = '<a href="javascript:void(0);" class="download" id="'+row.id+'">下载</a>';
				        if("-1"!=obj.node){
				        	str += '&emsp;&emsp;<a href="javascript:void(0);" class="delete">删除</a>';
				        }
			            return str;
			        },
			        events: {
			            'click .download': function(e, value, row, index) {
				            var imgUrl = fileDownloadUrl+"?id="+row.id;
				            var fileName = row.file_name+"."+row.file_ext;
				            
				            var odownLoad = document.getElementById(row.id);
				            odownLoad.href = imgUrl;
				            odownLoad.download = fileName;
			            },
			            'click .delete': function(e, value, row, index) {
			            	layer.confirm("您确定要删除该资料吗？", {icon: 3}, function() {
			    				var delObj = new Object();
			    				delObj.url = fileDeleteUrl;
			    				delObj.id = row.id;
			    				ajax(delObj, function(result) {
			    					if ("error" == result.resCode) {
			    						layer.msg(result.resMsg, {icon: 2});
			    					} else {
			    						layer.msg("资料删除成功！", {icon: 1});
			    						$("#file_table").bootstrapTable('remove', {field: 'id', values: [row.id]});
			    					}
			    				});
			    			});
			            }
			        }
			    }
			]
		}
		initBootStrapTable($("#file_table"),params);
	});

	var display = function() {
		var node = obj.node;
		if("0"==node){//新增
			$("#list_file_div").hide();
			
			$("*", $("#thisform")).attr("disabled", false);   
		}else if ("1" == node) { //修改
			$("*", $("#thisform")).attr("disabled", false);  
		}else if ("-1"==node) { //查看详情
			$("#upload_file_div").hide();
			
			$("*", $("#thisform")).attr("disabled", true);  
			$(".tj").hide();
			$("*",$(".action")).attr("disabled",false); 
		}
	}

	//初始化fileinput
	var FileInput = function () {
	    var oFile = new Object();

	    //初始化fileinput控件（第一次初始化）
	    oFile.Init = function(ctrlName) {
		    var control = $('#' + ctrlName);

		    //初始化上传控件的样式
		    control.fileinput({
		        language: 'zh', //设置语言
		        showUpload: false,//是否显示上传按钮
		        showUploadedThumbs: false,
		        initialPreviewShowDelete: true,
		        showCaption: false,//是否显示标题
		        browseClass: "btn btn-primary", //按钮样式     
		        dropZoneEnabled: true,//是否显示拖拽区域
		        enctype: 'multipart/form-data',
		        validateInitialCount: true,
		        previewFileIcon: "<i class='glyphicon glyphicon-king'></i>",
		        msgFilesTooMany: "选择上传的文件数量({n}) 超过允许的最大数值{m}！",
		        fileActionSettings: {
		        	showUpload: false,
		        	showDrag: false
		        },
		        layoutTemplates: {
		        	modal: '<div class="modal-dialog modal-lg" role="document">\n' +
		            '  <div class="modal-content">\n' +
		            '    <div class="modal-header">\n' +
		            '      <h3 class="modal-title">{heading} <small><span class="kv-zoom-title"></span></small></h3>\n' +
		            '      <div class="kv-zoom-actions pull-right">{toggleheader}{borderless}{close}</div>\n' +
		            '    </div>\n' +
		            '    <div class="modal-body">\n' +
		            '      <div class="floating-buttons"></div>\n' +
		            '      <div class="kv-zoom-body file-zoom-content"></div>\n' + '{prev} {next}\n' +
		            '    </div>\n' +
		            '  </div>\n' +
		            '</div>\n'
		        }
		    });
		}
	    return oFile;
	}

	//初始化bootstrap表格
	function initBootStrapTable(tableObj, params) {
		var autoHeight;
		try{
			autoHeight = document.body.offsetHeight-$(".basicnav")[0].offsetHeight-$(".basicserch")[0].offsetHeight-15;
		}catch(ex){}
		tableObj.bootstrapTable({
			id: tableObj.attr("id"),
			url: params.url ? params.url : "", //请求后台的URL（*）
			method: params.method ? params.method : "get", //请求方式（*）
			dataType: 'json', //数据类型
			undefinedText: '-', //空数据显示
			striped: params.striped ? params.striped : true, //是否显示行间隔色
			cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			pagination: true,
			// width: params.width ? params.width : "auto", //是否显示分页（*）
			height: params.height ? params.height : autoHeight, //表格固定高度
			sortable: params.sortable ? params.sortable : false, //是否启用排序
			sortName: params.sortName ? params.sortName : null, //排序字段
			sortOrder: params.sortOrder ? params.sortOrder : "asc", //排序方式
			sidePagination: params.sidePagination ? params.sidePagination : "client", //分页方式：client客户端分页，server服务端分页（*）
			pageNumber: 1, //初始化加载第一页，默认第一页
			pageSize: params.pageSize ? params.pageSize : 5, //每页的记录行数（*）
			pageList: params.pageList ? params.pageList : [5, 10, 20], //可供选择的每页的行数（*）
			showColumns: false, //是否显示所有的列选项
			showRefresh: params.showRefresh ? params.showRefresh : false, //是否显示刷新按钮
			minimumCountColumns: 2, //最少允许的列数
			clickToSelect: params.clickToSelect ? params.clickToSelect : false, //是否启用点击选中行
			uniqueId: params.uniqueId ? params.uniqueId : "id", //每一行的唯一标识，一般为主键列
			showToggle: false, //是否显示详细视图和列表视图的切换按钮
			cardView: false, //是否显示详细视图
			detailView: params.detailView ? params.detailView : false, //是否显示父子表
			search: params.search ? params.search : false, //是否显示自带的搜索框,服务端分页方式一般不用
			columns: params.columns ? params.columns : [] //表格列定义
		});
	}
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<form id="thisform" class="form-horizontal" role="form" onsubmit="return false;">
						<div class="ibox-title">
							<h5>
								<class="fa fa-file-o a-clear"></i> 详情
							</h5>
							<div class="ibox-tools">
								<a class="a-reload"> <i class="fa fa-repeat"></i> 刷新
								</a>
							</div>
						</div>
						<div class="ibox-content"> 
			            	  <div class="form-group">
			                  	<label class="col-sm-1 control-label">资料标题</label>
							    <div class="col-sm-5">
							      <input type="text" class="input-sm form-control validate[required]" name="xxkgl_title" id="xxkgl_title" >
							    </div>
			                  	<label class="col-sm-1 control-label">资料来源</label>
							    <div class="col-sm-5">
							      <input type="text" class="input-sm form-control validate[required]" name="xxkgl_sources" id="xxkgl_sources" >
							    </div>
							  </div>
			                  
							  <div class="form-group">
							    <label class="col-sm-1 control-label">内容简介</label>
							    <div class="col-sm-11">
							      <textarea class="form-control validate[required]" name="xxkgl_notes"></textarea>
							    </div>
							  </div>
							  
							  <div class="form-group" id="list_file_div">
							    <label class="col-sm-1 control-label">已有资料</label>
							    <div class="col-sm-11">
							      <table id="file_table" class="table" style="width: 100%"></table>
							    </div>
							  </div>
							  
							  <div class="form-group" id="upload_file_div">
							    <label class="col-sm-1 control-label">上传资料</label>
							    <div class="col-sm-11">
							      <input type="file" multiple class="file-loading" name="xxkgl_files" id="xxkgl_files" />
							    </div>
							  </div>
							  
							  <div class="form-group action">
								<div class="col-sm-12" style="text-align: center">
									<button type="button" class="btn btn-sm btn-success btn-group1 tj" result="提交">
										<i class="fa fa-check"></i> 提交
									</button>
									<button type="button" class="btn btn-sm btn-warning btn-group1 qx" result="取消">
										<i class="fa fa-remove"></i> 取消
									</button>
								</div>
							  </div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>