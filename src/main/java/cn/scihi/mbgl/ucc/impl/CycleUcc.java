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
public class CycleUcc extends UccAdapter {

	@Autowired
	private IBaseService cycleService;

	public void init() throws Exception {
		super.setBaseService(cycleService);
	}
}
