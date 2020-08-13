/**
 * 
 */
package cn.scihi.zskgl.controller;


import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
 
import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import cn.scihi.zskgl.ucc.impl.ZskglUcc;

/**
 * @author wyc
 *
 */
@Controller
@SysLog(module = "知识库管理")
@RequestMapping(value = "/jsp/zskgl/zskgl")
public class ZskglController extends BizController {

	@Resource
	private ZskglUcc zskglUcc;

	public void init() {
		super.baseUcc = zskglUcc;
	}

	
}
