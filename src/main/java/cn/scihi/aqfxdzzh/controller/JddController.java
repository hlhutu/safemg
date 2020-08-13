/**
 * 
 */
package cn.scihi.aqfxdzzh.controller;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import cn.scihi.xjgl.service.impl.XjglService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.scihi.aqfxdzzh.ucc.impl.JddUcc;
import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.util.SysAnnotation.SysLog;

import java.util.List;
import java.util.Map;

/**
 * @author wyc
 *
 */
@Controller
@SysLog(module = "监督点管理")
@RequestMapping(value = "/jsp/aqfxdzzh/jdd")
public class JddController extends BizController {

	@Resource
	private JddUcc jddUcc;
	@Autowired
	private XjglService xjglService;

	public void init() {
		super.baseUcc = jddUcc;
	}

	public Object select(HttpServletRequest request, Map<String, Object> map) throws Exception {
		map = this.getParameterMap(request, true);
		if (StringUtils.isEmpty(request.getParameter("orderStr_"))) {
			String columnNo = request.getParameter("order[0][column]");
			String orderDir = request.getParameter("order[0][dir]");
			if (StringUtils.isNotEmpty(columnNo) && StringUtils.isNotEmpty(orderDir)) {
				String orderColumn = request.getParameter("columns[" + columnNo + "][data]");
				map.put("orderStr_", " order by " + orderColumn + " " + orderDir + " ");
			}
		}
		List<Map<String, Object>> list = this.baseUcc.select(map);
		if(!CollectionUtils.isEmpty(list)){
			for (Map<String, Object> listMap : list) {
				listMap.put("xjCount", xjglService.countByJdd((String) listMap.get("id")));
			}
		}
		map.put("datas", list);
		return this.toJSONString(map);
	}
	
}
