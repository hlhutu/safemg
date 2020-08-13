package cn.scihi.comm.service;

import cn.scihi.comm.mapper.SysLogMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.scihi.sdk.base.mapper.IBaseMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;

/**
 * @author uplus
 *
 */
@Service
public class SysLogService extends ServiceAdapter {

	@Autowired
	private SysLogMapper sysLogMapper;

	public void init() throws Exception {
		super.setBaseMapper(sysLogMapper);
	}

	public Long clean() {
		return sysLogMapper.clean();
	}
}
