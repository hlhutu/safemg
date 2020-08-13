package cn.scihi.mbgl.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.util.SysAnnotation.SysLog;

/**
 * @author uplus
 *
 */
@Controller
@SysLog(module = "动态属性扩展")
@RequestMapping("/biz/prop")
public class PropController extends BizController {

	@Autowired
	private IBaseUcc propUcc;

	public void init() {
		super.setBaseUcc(propUcc);
	}
}
