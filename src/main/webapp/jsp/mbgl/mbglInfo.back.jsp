<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script src="${ctx}/js/plugins/jquery.jeditable.js"></script>
<script>
	var selectUrl = "${ctx}/jsp/mbgl/mbglInfo/select.do";
	var insertUrl = "${ctx}/jsp/mbgl/mbglInfo/insert.do";
	var insertFirstUrl = "${ctx}/jsp/mbgl/mbglInfo/taskdefs.do";
	var updateUrl = "${ctx}/jsp/mbgl/mbglInfo/update.do";
	var deleteUrl = "${ctx}/jsp/mbgl/mbglInfo/delete.do";
	
	var insertPropUrl = "${ctx}/jsp/mbgl/mbglInfoProp/insert.do";
	
	var callbackUrl = "${ctx}/jsp/mbgl/mbglInfo/callback.do";
	
	var back = { action : "click", target : ".a-back", result : "" };
	var closeItem = { action : "closeItem", target : document.location.toString() };
	var glid = "${param.glid}";
	var mbmc = "${param.mbmc}";
	var modelStatus = "${param.modelStatus}";

	var table;
	
	var node="${param.node}";
	var rwsl="${param.rwsl}";
	var visible = true;
	
	var dtParam = {
			"status":1,//1.正常数据，9.历史数据
		"glid":glid
	};
	if(node==-1){
		visible=false;
	}
	var visible2 = true;
	if(node!=0){
		visible2=false;
	}
	
	$(window).ready(function() {
		$("#mbmc").html("（${param.mbmc}）");
		if(modelStatus!=1){
			$("#a-save").hide();
		}
		$("#datas").wrapAll("<div style='overflow-x:auto'>");
		table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": false,
			"autoWidth": false,
			"paging": false,
			"scrollX": false,
			 //表头固定
            /* "scrollY": "500px",
            "scrollCollapse": "true", */
			"ajax": {
				"dataSrc": "datas",
				"url": selectUrl,
				"data": dtParam
			},
			"columns": [ {
				"title":'<a id="a-plus" title="新增"><i class="fa fa-plus"></i></a>',
				"data":"id",
				"visible":visible2,
				"render": function (data, type, row) {
					return '<a title="删除"><i class="fa fa-remove a-remove"></i></a>';
				}
			}, {
				"className":modelStatus==1?"edit":"noEdit",
				"title":"序号",
				"data":"xh"
			}, {
				"className":modelStatus==1?"edit":"noEdit",
				"title":"职责",
				"data":"zxxm"
			/* }, {
				"className":"执行",
				"title":"职责",
				"data":"zxxm" */
			}, {
				"title":"操作",
				"data":"id",
				"visible":visible,
				"render": function (data, type, row) {
					return "-";
				}
			}]
			,"drawCallback": function(s) {
					$(".pz").off("click").on("click",function(){
						var id=$(this).data("id");
						if(id){
							$("*", $("#editForm2")).attr("disabled", false);
							$("#editForm2").attr("action", insertPropUrl);
							$("#rwid").val(id);
							$("#myModal").modal("show");
						}else{
							layer.msg("请先保存后再进行配置！", {icon: 1});
						}
					});
					$(".save,.publish").off("click").on("click",function(){
						var r = table.api().row($(this).parents('tr')).data();
						var url = insertUrl;
						if($(this).hasClass('save')){
							url = updateUrl;
						}
						try {
							var obj = r;
							obj.url = url;
							if (confirm("您确定要"+$(this).html()+"吗？")) {
								ajax(obj, function(result) {
									if ("error" == result.resCode) {
										layer.msg(result.resMsg);
									} else {
										layer.msg("数据处理成功！", {
											shade : [ 0.1, "#fff" ] //独占
										}, function() {
											table.api().settings()[0].ajax.data = dtParam;
											table.api().ajax.reload();
										});
									}
								});
							}
						} catch (e) {
						}
					});
					$(".zx").off("click").on("click", function() {
						if (confirm("您确定完成了该操作吗？")) {
							var o = table.api().row($(this).parents('tr')).data();
							o.url = updateUrl;
							o.zxr = "${myUser.username}";
							o.zxsj = formatDate(new Date());
							ajax(o, function(result) {
								if ("error" == result.resCode) {
									layer.msg(result.resMsg);
								} else {
									table.api().ajax.reload();
									layer.msg("执行成功！");
								}
							});
						}
			       	});
				if("0" == "${param.node}") {
					$("#a-plus").off("click").on("click", function() {
						var length = table.api().data().length + 1;
						var v = {"xh":length, "zxxm":"职责-"+length}; 
						table.fnAddData(v); 
			       	});
					$(".a-remove").off("click").on("click", function() {
						console.log($(this).parents('tr'));
						return;
						var row = table.api().row($(this).parents('tr')).data();
						if(!row.id){
							table.api().row($(this).parents('tr')).remove().draw();
							return;
						}
						var ob = new Object();
						ob.url=updateUrl;
						ob.id=row.id;
						ob.status=0;//表示逻辑删除
						ajax(ob,function(result){
							if ("error" == result.resCode) {
								layer.msg(result.resMsg, {icon: 2});
							} else {
								layer.msg("数据处理成功！", {icon: 1});
								table.api().ajax.reload(null, false);
							}
						})
			       	});
					
					
					table.$('.edit').editable(callbackUrl, {
						type: 'textarea',
			          	onblur: 'submit',
			            tooltip: '可编辑',
					    indicator: '写入中...',
			            width: '100%',
			            height: '100%',
			            callback: function (value, settings) {
			            	var aPos = table.fnGetPosition(this);
			            	var r = table.api().row($(this).parents('tr')).data();
			            	r.change=1;
			            	var rindex = table.api().row($(this).parents('tr')).index();//获取下标
			            	table.api().row(rindex).data(r);//根据下表，填充数据。
			            	table.fnUpdate(value, aPos[0], aPos[1]);
			            	
			            },
			            onsubmit: function(settings, original) {
			            	var value = $(this).find('textarea').val();
			            	return $.trim(value) ? value : false;
			            }
			            /* ,submitdata: function (value, settings) {
			            	var c = ["c", "bh" , "qxlx", "qxlx", "qxlsx"];
			            	var aPos = table.fnGetPosition(this);
			            	var data = table.api().row(this).data();
			            	data.oldValue = value;
			            	data[c[aPos[1]]] = $(this).find('input').val();
			            	return data;
			            } */
			        });
				}
			}
		});
		
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				dtParam.keywords = $("#keywords").val();
				table.api().settings()[0].ajax.data = dtParam;
				table.api().ajax.reload();
			}
       	});
		
		$("#btn-insert").on("click", function() {
			$("*", $("#editForm2")).attr("disabled", false);
			$("#editForm").attr("action", insertUrl);
			$("#myModal").modal("show");
       	});
          
		
		$("#btn-ok").on("click", function() {
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				ajaxSubmit("#editForm", function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						table.api().ajax.reload(null, false);
						$("#myModal").modal("hide");
					}
				});
			}
		});
		
		$("#a-save").on("click", function() {
			try {
				var obj ={};
				$("*", $("#editForm")).attr("disabled", false);
				if (confirm("您确定要保存吗？")) {
					$("#editForm").attr("action", insertFirstUrl);
					obj.sfmb = "1";//是否模板（1.是，0.否）
					obj.mbgl_info_size = table.api().data().length;
					obj.mbgl_info_list = JSON.stringify(table.api().data());
					if(0 == obj.mbgl_info_size) {
						layer.msg("操作详情无数据！");
						return;
					}
					ajaxSubmit("#editForm", obj, function(result) {
						if ("error" == result.resCode) {
							layer.msg(result.resMsg);
						} else {
							layer.msg("数据处理成功！", {
								shade : [ 0.1, "#fff" ] //独占
							}, function() {
								table.api().settings()[0].ajax.data = dtParam;
								table.api().ajax.reload();
								//$(".a-reload").click();
							});
						}
					});
				}
			} catch (e) {
			}
		});
		$(".cycle").on("change",function(){
			if ($(this).val()=="1") {//$(this).attr("checked",true)两种方式
				$("#zqDiv").show();
			}else{
				$("#zqDiv").hide();
			}
		})
	});

</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<form id="editForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o a-clear"></i>任务管理<span id="mbmc"></span></h5>
	                    <div class="ibox-tools">
							<a id="a-save" style="color:#337ab7"><i class="fa fa-save"></i> 保存</a>
							<a class="a-reload"><i class="fa fa-repeat"></i> 刷新</a>
	                    </div>
	                </div>
		            <div class="ibox-content">
	                  <input type="text" id="glid" name="glid" value="${param.glid}" style="display: none;">
	                  <table id="datas" class="table display" style="width: 100%"></table>
		            </div>
		            
				</form>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:70%;">
	        <div class="modal-content ibox">
                <form id="editForm2" class="form-horizontal key-13" role="form" onsubmit="return false;">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i> 配置详情</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
	            
		            <div class="ibox-content">
		            	<input type="text" id="rwid" name="rwid" style="display:none"/>
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">附件</label>
					  	<div class="col-sm-4">
					  		<input type="radio"  name="file" value="1">必要
					  		<input type="radio"  name="file" value="0" checked="checked">非必要
					  	</div>
					  	<label class="col-sm-2 control-label">定位</label>
					  	<div class="col-sm-4">
					  		<input type="radio"  name="gps" value="1">必要
					  		<input type="radio"  name="gps" value="0" checked="checked">非必要
					  	</div>
				  	</div>
				  	<div class="form-group">
					  	<label class="col-sm-2 control-label">周期任务</label>
					  		<div class="col-sm-4">
					  		<input type="radio" class="cycle"  name="cycle" value="1">是
					  		<input type="radio" class="cycle"  name="cycle" value="0" checked="checked">否
					  	</div>
					  </div>
					  <div class="form-group" id="zqDiv" style="display: none;">
					  	<label class="col-sm-2 control-label">周期类型</label>
					  	<div class="col-sm-4">
					  		<s:dict dictType="zqlx" name="zqlx" clazz="input-sm form-control"></s:dict>
					  	</div>
					  </div>
		            </div>
		            
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-ok">
		                	<i class="fa fa-check"></i> 确定
		                </button>
		                <button type="button" class="btn btn-sm btn-default btn-cancel" data-dismiss="modal">
		                	<i class="fa fa-ban"></i> 取消
		                </button>
		            </div>
				</form>
	        </div>
	    </div>
	</div>
	
</body>
</html>