<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${ctx}/css/font-awesome/css/font-awesome.min.css?v=4.7.0" rel="stylesheet">
<link href="${ctx}/css/animate/animate.css?v=3.5.2" rel="stylesheet">

<link rel="stylesheet" href="http://cache.amap.com/lbs/static/main1119.css"/>

<!-- 这里要配置参数key,将其值设置为高德官网开发者获取的key -->
<script src="${ctx}/js/jquery.min.js?v=2.1.4"></script>
<script src="${ctx}/js/plugins/layer/layer.js?v=3.0.3"></script>

<script src="http://webapi.amap.com/maps?v=1.3&key=985a43b18ee1652571ca0fb6618e3382"></script>  
 
<link href="${ctx}/js/bootstrap/css/bootstrap.min.css?v=3.3.7" rel="stylesheet">
<script src="${ctx}/js/bootstrap/js/bootstrap.min.js?v=3.3.7"></script>

<link href="${ctx}/js/theme/style.css?v=4.1.0" rel="stylesheet">
<title>Amap</title>
<style type="text/css">
#pos{ 
    background-color: #fff;
    padding-left: 2px;
    padding-right: 2px;
    position:absolute;
    font-size: 12px;
    right: 10px;
    top: 10px;
    border-radius: 3px;
    line-height: 30px;
    border:1px solid #ccc;
    width: 45%;
}
#panel {
    position: absolute;
    background-color: white; 
    max-height: 400px ;
    overflow-y: auto;
    top: 160px;
    right: 10px;
    width: 20%;
}
</style>

<script type="text/javascript">
/**
 * mapResult{lat,lng,address}
 */
var mapResult = {};

var setJwd = function(j,w,address){
	$("#lngX").val(j);
    $("#latY").val(w);
    $("#keyword").val(address);
    mapResult.lat=w;
    mapResult.lng=j;
    mapResult.address=address;

}

$(window).ready(function() {
var map = new AMap.Map('container', {
    resizeEnable: true,
    zoom:13,
    center: [106.07125296789552,30.757634505284802]

});
//点标记的创建与添加
var marker  = new AMap.Marker({
    position: [106.07125296789552,30.757634505284802],
    map:map
}); 
//地图点击事件
var clickEventListener=AMap.event.addListener(map,'click',function(e){
	//查询经纬度的地址
 		map.plugin('AMap.Geocoder', function() {
   	 var geocoder = new AMap.Geocoder({
   	    // city 指定进行编码查询的城市，支持传入城市名、adcode 和 citycode
   	    city: '511304'
   	  })
   	 
   	 lnglat =  [e.lnglat.lng, e.lnglat.lat]
   	 geocoder.getAddress(lnglat, function(status, result) {
    	    if (status === 'complete' && result.info === 'OK') {
    	        // result为对应的地理位置详细信息
    	    	var addressContent = result.regeocode.formattedAddress
    	    }
    	    map.remove(marker); 
	            marker = new AMap.Marker({
	                position: [e.lnglat.lng, e.lnglat.lat]
	            });
	            
	            marker.setMap(map); 
	            marker.setTitle(addressContent);
	            var tempContent="<div class='infos'>"+addressContent+"</div>"+
	            "<div class='infos'>经度： "+e.lnglat.lng+"</div>"+
	            "<div class='infos'>纬度： "+e.lnglat.lat+"</div>"
	            
	            // label默认蓝框白底左上角显示，样式className为：amap-marker-label
	            marker.setLabel({
	                offset: new AMap.Pixel(20, 20),  //设置文本标注偏移量
	                content: tempContent, //设置文本标注内容
	                direction: 'top' //设置文本标注方位
	            });
	            setJwd(e.lnglat.lng,e.lnglat.lat,addressContent) ;
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
    $("#btn-query").on("click", function() {
	 placeSearch.search($("#keyword").val());
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

function search(lat,lng){
	var lnglat =[lng,lat];
	map.plugin('AMap.Geocoder', function() {
      	 var geocoder = new AMap.Geocoder({
      	    // city 指定进行编码查询的城市，支持传入城市名、adcode 和 citycode
      	    city: '511304'
      	  })
      	 geocoder.getAddress(lnglat, function(status, result) {
       	    if (status === 'complete' && result.info === 'OK') {
       	        // result为对应的地理位置详细信息
       	    	var addressContent = result.regeocode.formattedAddress
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
}

$("#mapRef").on("click", function() { //确定地址
		mapResult.lat=$("#latY").val();
		mapResult.lng=$("#lngX").val();
		mapResult.address=$("#keyword").val();
		return mapResult;
	});

 
});

</script>

</head>
<body >
 <div id="container" style="height:100%"></div>
 <div id="pos">
 	<div class="form-group" style="margin-bottom:2px !important" >
 		<label class="col-sm-2 control-label">关键字：</label>
        <input class="col-sm-8 input-sm " type="text" id="keyword" title="仅会查询南充嘉陵区内" />  
		<button class="col-sm-2" type="button" class="btn btn-sm btn-success" id='btn-query'   >
		 <i class="fa fa-search"></i> 搜索 </button>
	</div>	
	<div class="form-group"  style="margin-bottom:2px !important" >
        <label class="col-sm-2 control-label">经度:</label>	<input  class="col-sm-3 input-sm " type="text" id="lngX" name="lngX" /> 
        <label class="col-sm-2 control-label">纬度:</label>	<input  class="col-sm-3 input-sm  " type="text" id="latY" name="latY" /> 
        <button type="button" class="btn btn-sm btn-success btn-cancel col-sm-2" data-dismiss="modal" id="mapRef" >
             	<i class="fa fa-check"></i> 
             </button>
    </div>
 </div> 
 <div id="panel"></div> 
</body>
</html>