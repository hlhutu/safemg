<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
	<!-- 这里要配置参数key,将其值设置为高德官网开发者获取的key -->
	<script src="http://webapi.amap.com/maps?v=1.3&key=985a43b18ee1652571ca0fb6618e3382"></script>
<script>
	var selectUrl = "${ctx}/emerEvent/select.do";
	var insertUrl = "${ctx}/emerEvent/insert.do";
	var updateUrl = "${ctx}/emerEvent/update.do";
	var deleteUrl = "${ctx}/emerEvent/delete.do";

	var obj = new Object();
	obj.node = "${param.node}";
	obj.id = "${param.orderId}";
	obj.delflag = '1';
	var amapKey ='985a43b18ee1652571ca0fb6618e3382';
	var addressContent = '';
	var lnglat =  []

	$(window).ready(function() {
		var dtParam = {
			"keywords": $("#keywords").val()
		};
		$("#datas").wrapAll("<div style='overflow-x:auto'>");
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
			"order": [],
			"columns": [ {
				"orderable": false,
				"title":'<input type="checkbox" id="checkAll_" style="margin:0px;">',
				"data":"id",
				"render": function (data, type, row) {
					var s = '<input type="checkbox" ';
					if("1" == row.row_default) {
						s = s + 'disabled="disabled" '; 
					} else {
						s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
					}
					return s +'style="margin:0px;"/>';
				}
			},
			{
				"orderable": false,
				"title": "事件",
				"data": "title"
			},
			{
				"orderable": false,
				"title": "类型",
				"data": "category"
			},
			{
				"orderable": false,
				"title": "级别",
				"data": "event_level"
			},
			{
				"orderable": false,
				"title": "发生时间",
				"data": "event_time"
			},
			{
				"orderable": false,
				"title": "发生地点",
				"data": "address"
			},
			{
				"orderable": false,
				"title": "主管部门",
				"data": "org_name"
			},
			{
				"orderable": false,
				"title":"操作",
				"render": function (data, type, row) {
					return '<a class="info">详情</a>';
				}
			}]
			,"drawCallback": function(s) {
				$("#checkAll_").off("click").on("click", function() {
					$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
				});
				
				$(".info").off("click").on("click", function () {
					var r = table.api().row($(this).parents('tr')).data();
					$("input[type='checkbox']").prop("checked", false);
					$(".ids_[value='"+r.id+"']").prop("checked", true);
				});
			}
		});

		var map = new AMap.Map('container', {
			resizeEnable: true,
			zoom:13,
			center: [106.07125296789552,30.757634505284802]
		});
		//点标记的创建与添加
		var marker  = new AMap.Marker({
			position: [106.07125296789552,30.757634505284802],
			map: map
		});
		//地图点击事件
		var clickEventListener = AMap.event.addListener(map,'click',function(e){
			setJwd(e.lnglat.lng,e.lnglat.lat)
			//查询经纬度的地址
			map.plugin('AMap.Geocoder', function() {
				var geocoder = new AMap.Geocoder({
					// city 指定进行编码查询的城市，支持传入城市名、adcode 和 citycode
					city: '511304'
				});
				lnglat =  [e.lnglat.lng, e.lnglat.lat]
				geocoder.getAddress(lnglat, function(status, result) {
					if (status === 'complete' && result.info === 'OK') {
						// result为对应的地理位置详细信息
						addressContent = result.regeocode.formattedAddress
					}
					map.remove(marker);
					marker = new AMap.Marker({
						position: [e.lnglat.lng, e.lnglat.lat]
					});
					marker.setMap(map);
					marker.setTitle(addressContent);
					var tempContent="<div class='infos'>"+addressContent+"</div>";
					// label默认蓝框白底左上角显示，样式className为：amap-marker-label
					marker.setLabel({
						offset: new AMap.Pixel(20, 20),  //设置文本标注偏移量
						content: tempContent, //设置文本标注内容
						direction: 'top' //设置文本标注方位
					});
					setJwd(e.lnglat.lng, e.lnglat.lat, addressContent);
				})
			})
		});

		AMap.service(["AMap.PlaceSearch"], function() {
			//构造地点查询类
			var placeSearch = new AMap.PlaceSearch({
				pageSize: 5, // 单页显示结果条数
				pageIndex: 1, // 页码
				city: "511304", // 兴趣点城市  南充嘉陵区 511304
				citylimit: true,  //是否强制限制在设置的城市内搜索
				map: map, // 展现结果的地图实例
				panel: "panel", // 结果列表将在此容器中进行展示。
				autoFitView: true // 是否自动调整地图视野使绘制的 Marker点都处于视口的可见范围
			});
			//关键字查询
			$("#map-query").on("click", function() {
				placeSearch.search($("#map-keywords").val());
			})
			//查询结果列表点击事件
			placeSearch.on("listElementClick",function(e){
				map.remove(marker);
				setJwd(e.data.location.lng,e.data.location.lat,e.data.name)
			})
			//查询结果地图上marker点击事件
			placeSearch.on("markerClick",function(e){
				map.remove(marker);
				setJwd(e.data.location.lng,e.data.location.lat,e.data.name)
			})
		});

		map.plugin(["AMap.ToolBar"], function() {
			map.addControl(new AMap.ToolBar());
		});

		$("#btn-map").on("click", function() {
			$("#mapModel").modal("show");
			lnglat =[$("#lon").val(),$("#lat").val()];
			map.plugin('AMap.Geocoder', function() {
				var geocoder = new AMap.Geocoder({
					// city 指定进行编码查询的城市，支持传入城市名、adcode 和 citycode
					city: '511304'
				})
				geocoder.getAddress(lnglat, function(status, result) {
					if (status === 'complete' && result.info === 'OK') {
						// result为对应的地理位置详细信息
						addressContent = result.regeocode.formattedAddress
					}
					map.remove(marker);
					marker = new AMap.Marker({
						position: lnglat
					});
					marker.setTitle(addressContent);
					marker.setMap(map);
					var tempContent="<div class='infos'>"+addressContent+"</div>";
					// label默认蓝框白底左上角显示，样式className为：amap-marker-label
					marker.setLabel({
						offset:new AMap.Pixel(20, -20), //设置文本标注偏移量
						content: tempContent, //设置文本标注内容
						direction: 'top' //设置文本标注方位
					});
					setJwd(lnglat[0],lnglat[1],addressContent)
				})
			})

		});
		$("#mapRef").on("click", function() { //确定地址
			$("#address").val(addressContent);
			$("#lon").val($("#lngX").val());
			$("#lat").val($("#latY").val());
		});

		$("#btn-query").on("click", function() {
			var b = $("#selectForm").validationEngine("validate");
			if(b) {
				dtParam.keywords = $("#keywords").val();
				table.api().settings()[0].ajax.data = dtParam;
				table.api().ajax.reload();
			}
		});
		
		$("#editForm .btn-13").on("click", function() {
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
		
		$("#btn-insert").on("click", function() {
			$("*", $("#editForm")).attr("disabled", false);
			$("#attachmentList").html('');
			$("#editForm").attr("action", insertUrl);
			$("#myModal").modal("show");
		});
		$("body").on("click", "#btn-update, .info" , function() {
			$("*", $("#editForm")).attr("disabled", false);
			if("详情" ==  $(this).html()) {
				$("*", $("#editForm")).attr("disabled", true);
			}
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
			obj.delflag = "详情" ==  $(this).html()?"0":"1";
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else if(result.datas && result.datas.length == 1) {
					$("#editForm").fill(result.datas[0]);
					fillSelect("#editForm",result.datas[0]);
					$("#attachmentList").html(result.datas[0].attachList);
				} else {
					layer.msg("未找到相关数据！", {icon: 7});
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

		var setJwd = function(j,w,address){
			$("#lngX").val(j);
			$("#latY").val(w);
			addressContent=address;
			$("#map-keywords").val(addressContent);
		}
	});
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>
							<i class="fa fa-file-o a-clear"></i> 应急-事件
						</h5>
						<div class="ibox-tools">
							<a class="a-reload">
								<i class="fa fa-repeat"></i> 刷新
							</a>
						</div>
					</div>
					
					<div class="ibox-content">
						<!-- search start -->
						<div class="form-horizontal clearfix">
							<div class="col-sm-6 pl0">
								<s:access url="${basePath}/emerEvent/insert.do">
									<button class="btn btn-sm btn-success" id="btn-insert">
										<i class="fa fa-plus"></i> 新增
									</button>
								</s:access>
								<s:access url="${basePath}/emerEvent/update.do">
									<button class="btn btn-sm btn-success" id="btn-update">
										<i class="fa fa-edit"></i> 修改
									</button>
								</s:access>
								<s:access url="${basePath}/emerEvent/delete.do">
									<button class="btn btn-sm btn-success" id="btn-delete">
										<i class="fa fa-trash-o"></i> 删除
									</button>
								</s:access>
							</div>
							
							<div class="col-sm-6 form-inline" style="padding-right: 0; text-align: right">
								<form id="selectForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
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
						<input type="text" id="row_version" name="row_version" style="display:none"/>
						<div class="form-group">
							<label class="col-sm-2 control-label">标题</label>
							<div class="col-sm-4">
								<input type="text" class="input-sm form-control validate[required]" name="title" id="title" value="应急事件">
							</div>
							<label class="col-sm-2 control-label">发生时间</label>
							<div class="col-sm-4">
								<input type="text" class="input-sm form-control date_select validate[required]" name="event_time" id="event_time" readonly="readonly">
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">主管部门</label>
							<div class="col-sm-4">
								<s:select beanName="sdkUcc" mothodName="queryOrg" name="org_id" k="org_name" v='id'  clazz="selectpicker form-control validate[required]" />
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">类型</label>
							<div class="col-sm-4">
								<input type="text" class="input-sm form-control" name="category" id="category">
							</div>
							<label class="col-sm-2 control-label">级别</label>
							<div class="col-sm-4">
								<select class="input-sm form-control" name="event_level" id="event_level">
									<option>一般</option>
									<option>较大</option>
									<option>重大</option>
									<option>特别重大</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">事故地点</label>
							<div class="col-sm-9">
								<input type="text" class="input-sm form-control validate[required]" name="address" id="address">
								<input type="text" class="input-sm form-control" name="lon" id="lon" style="display: none;">
								<input type="text" class="input-sm form-control" name="lat" id="lat" style="display: none;">
							</div>
							<div class="col-sm-1">
								<button type="button" class="btn btn-sm btn-success" id="btn-map">
									<i class="fa fa-map-marker"></i> 定位
								</button>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">事件说明</label>
							<div class="col-sm-10">
								<textarea class="input-sm form-control" name="description" id="description" rows="2"></textarea>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">处置结果</label>
							<div class="col-sm-10">
								<textarea class="input-sm form-control" name="event_result" id="event_result" rows="2"></textarea>
							</div>
						</div>
						<div class="form-group desc">
							<label class="col-sm-2 control-label">附件</label>
							<div class="col-sm-10">
								<div class="col-sm-11" id="attachmentList">
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label"></label>
							<div class="col-sm-10">
								<input type="file" name="file" id="file" multiple />
							</div>
						</div>
					</div>
					
					<div class="modal-footer">
						<button type="button" class="btn btn-sm btn-success btn-13">
							<i class="fa fa-check"></i> 确定
						</button>
						<button type="button" class="btn btn-sm btn-default" data-dismiss="modal">
							<i class="fa fa-ban"></i> 取消
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<!-- edit end-->

	<!-- edit start-->
	<div class="modal fade" id="mapModel" tabindex="-1" role="dialog" >
		<div class="modal-dialog" style="width:70%;">
			<div class="modal-content ibox">
				<form id="mapModel_editForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
					<div class="ibox-title">
						<h5><i class="fa fa-pencil-square-o"></i> 获取经纬度</h5>
						<div class="ibox-tools">
							<a class="close-link" data-dismiss="modal">
								<i class="fa fa-times"></i>
							</a>
						</div>
					</div>
					<div id="container" style="height:500px"></div>
					<div id="pos">
						<div class="form-group" style="margin-bottom:2px !important" >
							<label class="col-sm-2 control-label">关键字：</label>
							<input class="col-sm-7 input-sm " type="text" id="map-keywords" title="仅会查询南充嘉陵区内" style="margin-top:2px" />
							<button class="col-sm-2" type="button" class="btn btn-sm btn-success" id='map-query' style="margin-left:5px"  >
								<i class="fa fa-search"></i> 搜索 </button>
							<i class="fa fa-close" data-dismiss="modal" style="margin-left:10px"></i>
						</div>
						<div class="form-group"  style="margin-bottom:2px !important" >
							<label class="col-sm-2 control-label">经度:</label>	<input  class="col-sm-3 input-sm " type="text" id="lngX" name="lngX" />
							<label class="col-sm-2 control-label">纬度:</label>	<input  class="col-sm-3 input-sm  " type="text" id="latY" name="latY" />
							<button type="button" class="btn btn-sm btn-success btn-cancel col-sm-1" data-dismiss="modal" id="mapRef" style="margin-left:5px">
								<i class="fa fa-check"></i>
							</button>
						</div>
					</div>
					<div id="panel"></div>
				</form>
			</div>
		</div>
	</div>
	<!-- edit end-->
</body>
</html>
