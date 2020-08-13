package cn.scihi.mbgl.ucc.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.service.IBaseService;
import cn.scihi.sdk.base.ucc.UccAdapter;

/**
 * @author uplus
 *
 */
@Service
public class PropUcc extends UccAdapter {

	@Autowired
	private IBaseService propService;

	public void init() throws Exception {
		super.setBaseService(propService);
	}
}
