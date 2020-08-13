<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script>
	var selectUrl = "${ctx}/biz/xjmbgl/select.do";
	var insertUrl = "${ctx}/biz/xjmbgl/insert.do";
	var updateUrl = "${ctx}/biz/xjmbgl/update.do";
	var deleteUrl = "${ctx}/biz/xjmbgl/delete.do";

	var selectFxUrl = "${ctx}/jsp/aqfxdzzh/jdd/select.do";
	
	$(window).ready(function() {
		$("#jddName").html("${param.jddName}");
		$("#xjmb").val("${param.mainOrgId}");
		$("#fxid").val("${param.jddId}");
		$("#xjmc").val("${param.jddName}"+"安全生产巡检");
		var dtParam = {
			"keywords": $("#keywords").val()
			,"fxid":"${param.jddId}"
		};
		var table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": true,
			"autoWidth": false,
			"processing": true,
			"serverSide": true,
			"stateSave": false,
			"ajax": {
				"dataSrc": "datas",
				"url": selectUrl,
				"data": dtParam,
			},
			"order": [[4, "desc"]],
			"columnDefs": [{
				"targets": [0,5],
				"orderable" : false
			}],
			"columns": [ {
				"title":'<input type="checkbox" id="checkAll_" style="margin:0px;">',
				"data":"id",
				"render": function (data, type, row) {
					return '<input type="checkbox" class="ids_" name="ids_" value="'+data+'" style="margin:0px;"/>';
				}
			}, {
				"title":"巡检名称 <i class='fa fa-search'></i>",
				"data":"xjmc"
			}, {
				"title":"巡检对象 ",
				"data":"xjmb",
				"render": function (data, type, row) {
					return row.xjmb_desc;
				}
			}/*, {
				"title":"巡检类型 ",
				"data":"xjlx",
				"render": function (data, type, row) {
					return row.xjlx_desc;
				}
			}*/, {
				"title":"修改时间",
				"data":"modified",
				"render": function (data, type, row) {
					return '<span title="'+row.modifier_desc+'">'+data+'</span>';
				}
			}, {
				"title":"操作",
				"data":"id",
				"render": function (data, type, row) {
					var rs = '<a class="info" target="${basePath}/jsp/xjgl/xjmbglInfo.jsp"  value="'+data+'" xjmc="'+row.xjmc+'">巡检明细</a><sup>'+row.rwsl+'</sup>';
					return rs;//+= ' <a class="info" target="${basePath}/jsp/xjgl/xjglList.jsp" value="'+data+'" xjmc="'+row.xjmc+'">巡检任务</a><sup>'+row.qdsl+'</sup>';
				}
			}]
			,"drawCallback": function(s) {
				$("#checkAll_").off("click").on("click", function() {
					$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
				});
				
				$(".info").off("click").on("click", function() {
					var id = $(this).attr("value");
					var name = $(this).html();
					var xjmc = $(this).attr("xjmc");
					var target = $(this).attr("target");
					var o = {
							action:"menuItem",
							name:name
					}
						o.target = target+"?xj_id=" + id+"&mbid="+id+"&xjmc="+encodeURI(xjmc)+"&token=${param.token}";
					doMessage(o);
				});
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
			$("*", $("#editForm")).attr("disabled", false);
			$("#editForm").attr("action", insertUrl);
			$("#myModal").modal("show");
       	});
		
		$("body").on("click", "#btn-update" , function() {
			$("*", $("#editForm")).attr("disabled", false);
			
			var size = $(".ids_:checkbox:checked").length;
			if(size != 1) {
				layer.msg("请选择需要修改的一行数据！", {icon: 0});
				return;
			}
			
			$("#editForm").attr("action", updateUrl);
			$("#myModal").modal("show");

			var obj = new Object();
			obj.url = selectUrl;
			obj.id = $(".ids_:checkbox:checked").val();
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else if(result.datas && result.datas.length == 1) {
					$("#editForm").fill(result.datas[0]);
				} else {
					layer.msg("未找到相关数据，请刷新页面！", {icon: 7});
				}
			});
       	});
          
		$("#btn-delete").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size < 1) {
				layer.msg("请选择需要删除的数据！", {icon: 0});
				return;
			}
			
			layer.confirm("您确定要删除数据吗？", {icon: 3}, function() {
				var ids = [];
				$(".ids_:checkbox:checked").each(function(index, o) {
					ids.push($(this).val());
				});
				var obj = new Object();
				obj.url = deleteUrl;
				obj.id = ids.join(",");
				ajax(obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						table.api().ajax.reload(null, false);
					}
				});
			});
		});
		
		$("#btn-ok").on("click", function() {
			var b = $("#editForm").validationEngine("validate");
			var kssj = $("#kssj").val();
			var jssj = $("#jssj").val();
			if(jssj<kssj){
				layer.msg("结束时间不能小于开始时间！", {icon: 2});
				return false;
			}
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
		
		$("#xjmb").on("change",function(){
			$("#fxid").html('<option value="">请选择</option>');
			var ztjg = $(this).val();
			if(ztjg){
				getFx(ztjg,function(res){
					if(res.resCode=="success"){
						var datas = res.datas;
						$.each(datas,function(i,o){
							$("#fxid").append("<option value='"+o.id+"'>"+o.jddgl_mc+"</option>");
						})
					}
					$("#fxid").selectpicker("render");
					$("#fxid").selectpicker("refresh");
				})
			}
			$("#fxid").selectpicker("render");
			$("#fxid").selectpicker("refresh");
		})
		
	});
	
	function getFx(ztjg,callback){
		var obj = {
				"jddgl_ztjg":ztjg,
				"url":selectFxUrl
		}
		ajax(obj, callback);
	}
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>
							<i class="fa fa-file-o a-clear"></i> 巡检模板管理（<span id="jddName"></span>）
						</h5>
						<div class="ibox-tools">
							<a class="a-reload"> <i class="fa fa-repeat"></i> 刷新
							</a>
						</div>
					</div>

					<div class="ibox-content">
						<!-- search start -->
						<div class="form-horizontal clearfix">
							<div class="col-sm-6 pl0">
								<s:access url="${ctx}/jsp/biz/xjmbgl/insert.do">
									<button class="btn btn-sm btn-success" id="btn-insert">
										<i class="fa fa-plus"></i> 新增
									</button>
								</s:access>
								<s:access url="${ctx}/jsp/biz/xjmbgl/update.do">
									<button class="btn btn-sm btn-success" id="btn-update">
										<i class="fa fa-edit"></i> 修改
									</button>
								</s:access>
								<s:access url="${ctx}/jsp/biz/xjmbgl/delete.do">
									<button class="btn btn-sm btn-success" id="btn-delete">
										<i class="fa fa-trash-o"></i> 删除
									</button>
								</s:access>
							</div>

							<div class="col-sm-6 form-inline" style="padding-right: 0; text-align: right">
								<form id="queryForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
									<input type="text" placeholder="关键字" class="input-sm form-control validate[custom[tszf]]" id="keywords">
									<button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
										<i class="fa fa-search"></i> 查询
									</button>
								</form>
							</div>
						</div>
						<!-- search end -->

						<table id="datas" class="table display" style="width: 100%"></table>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- edit start-->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:70%;">
	        <div class="modal-content ibox">
                <form id="editForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i> 编辑数据</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
	            
		            <div class="ibox-content">
	                  <input type="text" id="id" name="id" style="display:none"/>
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">巡检名称</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="xjmc" id="xjmc" >
					    </div>
					  	<%--<label class="col-sm-2 control-label">巡检类型</label>
					    <div class="col-sm-4">
					      <s:dict dictType="xjlx" name="xjlx" clazz="input-sm form-control validate[required]"></s:dict>
					    </div>--%>
					  </div>
					  
					  <div class="form-group" style="display:none;">
					    <label class="col-sm-2 control-label">巡检目标</label>
					    <div class="col-sm-4">
							<input id="xjmb" name="xjmb" />
						</div>
					  	<label class="col-sm-2 control-label">风险点位</label>
					    <div class="col-sm-4">
					    	<input id="fxid" name="fxid" />
					    </div>
					  </div>

					  <div class="form-group">
					    <label class="col-sm-2 control-label">巡检描述</label>
					    <div class="col-sm-10">
					      <textarea class="form-control" name="xjms" id="xjms" ></textarea>
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
	<!-- edit end-->
</body>
</html>