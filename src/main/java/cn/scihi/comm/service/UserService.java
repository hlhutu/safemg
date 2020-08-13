package cn.scihi.comm.service;

import cn.scihi.mbgl.mapper.StaffMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author uplus
 *
 */
@Service
public class UserService {
    @Autowired
    private StaffMapper staffMapper;

    public boolean exists(String user_name) {
        return staffMapper.exist(user_name)>0;
    }
}
