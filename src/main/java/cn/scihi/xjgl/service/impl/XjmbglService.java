package cn.scihi.xjgl.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;

/**
 * @author uplus
 *
 */
@Service
public class XjmbglService extends ServiceAdapter {

	@Autowired
	private IBaseMapper xjmbglMapper;

	public void init() throws Exception {
		super.setBaseMapper(xjmbglMapper);
	}
}
