package cn.scihi.xjgl.ucc.impl;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.mbgl.service.impl.TaskInstanceService;
import cn.scihi.mbgl.ucc.impl.TaskUcc;
import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;

/**
 * @author uplus
 *
 */
@Service
public class XjglUcc extends UccAdapter {

	@Autowired
	private IBaseService xjglService;

	@Autowired
	private TaskUcc taskUcc;

	public void init() throws Exception {
		super.setBaseService(xjglService);
	}

	@Override
	public int update(Map<String, Object> map, HttpServletRequest request) throws Exception {
		super.update(map, request);
		if (map.containsKey("zxzt") && "2".equals(map.get("zxzt"))) {
			taskUcc.completeByOther(TaskInstanceService.XUNJIAN, map.get("id") + "");
		}
		return 1;
	}
}
