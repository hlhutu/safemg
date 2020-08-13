package cn.scihi.app;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;

/**
 * @author uplus
 *
 */
@Service
public class AppService extends ServiceAdapter {

	@Autowired
	private IBaseMapper appMapper;

	public void init() throws Exception {
		super.setBaseMapper(appMapper);
	}
}
