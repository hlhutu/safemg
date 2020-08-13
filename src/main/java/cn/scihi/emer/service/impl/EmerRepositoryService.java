package cn.scihi.emer.service.impl;

import cn.scihi.emer.mapper.EmerRepositoryMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author uplus
 *
 */
@Service
public class EmerRepositoryService extends ServiceAdapter {

	@Autowired
	private EmerRepositoryMapper emerRepositoryMapper;

	public void init() throws Exception {
		super.setBaseMapper(emerRepositoryMapper);
	}
}
