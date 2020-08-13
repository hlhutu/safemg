<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<style type="text/css">
 #pos{ 
    background-color: #fff;
    position:absolute;
    font-size: 12px;
    right: 10px;
    top: 10px;
    border:1px solid #ccc; 
}
</style>
<link rel="stylesheet" href="http://cache.amap.com/lbs/static/main1119.css"/>
<!-- 这里要配置参数key,将其值设置为高德官网开发者获取的key -->
<script src="http://webapi.amap.com/maps?v=1.3&key=985a43b18ee1652571ca0fb6618e3382"></script>  
<script>
	var selectUrl = "${ctx}/jsp/aqfxdzzh/jdd/select.do";  
	var deleteUrl = "${ctx}/jsp/aqfxdzzh/jdd/delete.do";
	var iconDatas=[{id:"fxy_jb_tbzd",uri:'../../images/1j.png',name:'一级'},{id:"fxy_jb_zd",uri:'../../images/2j.png',name:'二级'},
		{id:"fxy_jb_jd",uri:'../../images/3j.png',name:'三级'},{id:"fxy_jb_yb",uri:'../../images/4j.png',name:'四级'}];
	
	
	$(window).ready(function() { 
		var userName_="${myUser.user.user_name}";
		var dtParam = {
			"keywords": $("#keywords").val()
			,"jddgl_jgbm":"${myUser.user.org_id}"
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
			"order": [[1, "desc"]],
			"columnDefs": [{
				"targets": [0,1,7],
				"orderable" : false
			}],
			"columns": [ {
				"title":'<input type="checkbox" id="checkAll_" style="margin:0px;">',
				"data":"id",
				"render": function (data, type, row) {
					return '<input type="checkbox" class="ids_" name="ids_" value="'+data+'" style="margin:0px;"/>';
				}
			},{
				"data":"created"
				 ,"bVisible" : false 
			}, {
				"title":"名称 (监督点)  <i class='fa fa-search'></i>",
				"data":"jddgl_mc",
				"render": function (data, type, row) {
					if (typeof(data)!='undefined'&&data.length>=12) {
	           		 return  "<span type='button' title='"+data+"'>"+data.substr(0, 12 )+"....."+"</span>";
					}else{
						 return data;
					}
				}
			}, {
				"title":"地址  <i class='fa fa-search'></i>",
				"data":"jddgl_dz",
				"render": function (data, type, row)  {
					if (typeof(data)!='undefined'&&data.length>=15) {
		           		 return  "<span type='button' title='"+data+"'>"+data.substr(0, 15 )+"....."+"</span>";
						}else{
							 return data;
						}
				}
			}, {
				"title":"监管部门 <i class='fa fa-search'></i>",
				"data":"jddgl_jgbm",
				"render": function (data, type, row)  {
					return row.jddgl_jgbm_desc;
				}
			}, {
				"title":"风险等级 <i class='fa fa-search'></i>",
				"data":"jddgl_fxydj",
				"render": function (data, type, row)  {
					return row.jddgl_fxydj_desc;
				}
			}, {
				"title":"操作",
				"data":"id",
				"render": function (data, type, row) {
					return '<a class="info" value='+data+'>详情</a>'
					//+'<a class="zhdAdd" value='+data+' jddmc='+row.jddgl_mc+' jdddz='+row.jddgl_dz+' >  灾害情况</a>';
						+'  <a onclick="jumpToCheck(\''+data+'\',\''+row.jddgl_mc+'\',\''+row.jddgl_ztjg+'\')">巡检计划</a>';
				}
			}]
			,"drawCallback": function(s) {
				$("#checkAll_").off("click").on("click", function() {
					$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
				});
				$(".info").off("click").on("click", function() {
					var target = "${basePath}/jsp/aqfxdzzh/jddInfo.jsp?node=-1&orderId="+$(this).attr("value");
					var v = {action:"menuItem", name:"监督点信息查看", target: target};
					doMessage(v);
		       	});
				$(".zhdAdd").off("click").on("click", function() {
					var jddId = $(this).attr('value');
					var jddmc = $(this).attr('jddmc');
					var jdddz = $(this).attr('jdddz');
					var target = "${basePath}/jsp/aqfxdzzh/zhdList.jsp?node=0&jddId="+jddId+"&jddmc="+jddmc+"&jdddz="+jdddz;
					target = encodeURI(target);
					var v = {action:"menuItem", name:"灾害情况", target: target};
					doMessage(v);
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
			var target = "${basePath}/jsp/aqfxdzzh/jddInfo.jsp?node=0";
			var v = {action:"menuItem", name:"监督点信息录入", target: target};
			doMessage(v);
       	});

		$("#btn-modify").on("click", function() {
			var ids = [];
			$(".ids_:checkbox:checked").each(function(index, o) {
				ids.push($(this).val());
			});
			if(ids.length != 1) {
				layer.msg("请选择需要修改的一条数据！", {icon: 0});
				return;
			}
			
			var target = "${basePath}/jsp/aqfxdzzh/jddInfo.jsp?node=1&orderId="+ids[0];
			var v = {action:"menuItem", name:"监督点信息修改", target: target};
			doMessage(v);
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
		
	//----------------AMap	
	
		var map = new AMap.Map('container', {
		    resizeEnable: true,
		    zoom:13,
		    center: [106.07125296789552,30.757634505284802]

		});
	//获取  datatable.data 渲染到地图
        map.plugin(["AMap.ToolBar"], function() {
			map.addControl(new AMap.ToolBar());
		}); 
       
	
        $("#btn-map").on("click", function() {
        	$("#myModal").modal("show");
        	var salesDetailTable = new $.fn.dataTable.Api('#datas');
            var length = salesDetailTable.rows().data().length;
	        var list = [];
	        var marker = new Object();
	        for (var i = 0; i < length; i++) {
	        	
	        	 var iconL = new AMap.Icon({
	                 size: new AMap.Size(20, 24),
	                 image: getIconUrl(salesDetailTable.rows().data()[i].jddgl_fxydj),
	                 imageSize: new AMap.Size(20, 24) 
	        	});
	        	 
	        	marker  = new AMap.Marker({
	                position: [salesDetailTable.rows().data()[i].jddgl_jd,salesDetailTable.rows().data()[i].jddgl_wd]
	                ,icon :iconL 
	            }); 
	        	marker.setTitle(salesDetailTable.rows().data()[i].jddgl_dz);
	        	var tempContent="<div class='infos'>"+salesDetailTable.rows().data()[i].jddgl_mc+"</div>";
	 	            // label默认蓝框白底左上角显示，样式className为：amap-marker-label
	 	            marker.setLabel({
	 	            	offset:new AMap.Pixel(20, -20),
	 	            	topWhenClick:true,
	 	                content: tempContent, //设置文本标注内容
	 	                direction: 'top',//设置文本标注方位
	 	                extData :salesDetailTable.rows().data()[i].jddgl_dz
	 	            });
	 	        marker.setMap(map); 
	            list.push(marker);
	        } 
	    	
        })
         var htm = '';
	        $.each(iconDatas,function(i,o){
	        	htm += '&nbsp;<img  src='+o.uri+' width="20px" height="24px" /><span>&nbsp;'+o.name+'</span>';
        	 })
	      //  var htm = "&nbsp;&nbsp;<span class='' style='background:"+colors[o.sortNo]+"' >"+o.dictName+"</span>";
			$(".mapBack").append(htm);
        var getIconUrl=function(id){
        	var res = iconDatas[iconDatas.length-1].uri
        	$.each(iconDatas,function(i,o){
        		if (id==o.id) {
        			res =o.uri;
        		}
        	 })
        	return res; 
    	}
		
	});

	function jumpToCheck(id, name, mainOrgId){
		var target = "${basePath}/jsp/xjgl/xjmbglList.jsp?jddId="+id+"&jddName="+name+"&mainOrgId="+mainOrgId;
		target = encodeURI(target);
		doMessage({
			action:"menuItem"
			, name:"巡检计划"
			, target: target
		});
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
							<i class="fa fa-file-o a-clear"></i> 风险监督点列表
						</h5>
						<div class="ibox-tools">
							<a class="a-reload"> <i class="fa fa-repeat"></i> 刷新
							</a>
						</div>
					</div>

					<div class="ibox-content">
						<div class="form-horizontal clearfix">
							<div class="col-sm-6 pl0">
								<button class="btn btn-sm btn-success" id="btn-insert">
									<i class="fa fa-plus"></i> 新增
								</button>
							
								<button class="btn btn-sm btn-success" id="btn-modify">
									<i class="fa fa-edit"></i> 修改
								</button>
							
								<button class="btn btn-sm btn-success" id="btn-delete">
									<i class="fa fa-trash-o"></i> 删除
								</button>
							  	<button type="button" class="btn btn-sm btn-success " id="btn-map" >
				                	<i class="fa fa-map-marker"></i> 分布情况
				                </button> 
							</div>

							<div class="col-sm-6 form-inline" style="padding-right: 0; text-align: right">
								<form id="selectForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
									<input type="text" placeholder="关键字" class="input-sm form-control validate[custom[tszf]]" id="keywords" value="">
									<button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
										<i class="fa fa-search"></i> 查询
									</button>
								</form>
							</div>
						</div>

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
	                    <h5><i class="fa fa-pencil-square-o"></i> 分布情况</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
	                
	            	<div id="container" style="height:500px"></div>
	            	<!-- -- <div id="pos"> -->
	            			<div class="col-sm-1 " ></div>
	            			<div class="col-sm-4 	 mapBack" style="margin-top:-30px;"  ></div>
							<button class="col-sm-2 " type="button" class="btn btn-sm btn-success"  data-dismiss="modal"  style="margin-left:5px;position:absolute;right:10px;top:10px;width:100px"  >
							 <i class="fa fa-close "></i> 返回 </button>  
							
							
	            	
	            	<!-- </div> -->
	                  
				</form>
	        </div>
	    </div>
	</div>
	<!-- edit end-->
</body>
</html>