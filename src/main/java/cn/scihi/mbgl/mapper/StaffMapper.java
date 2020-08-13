package cn.scihi.mbgl.mapper;

import cn.scihi.mbgl.bean.Staff;
import cn.scihi.sdk.base.mapper.IBaseMapper;

import java.util.List;
import java.util.Map;

/**
 * @author uplus
 *
 */
public interface StaffMapper extends IBaseMapper {
    List<Staff> queryMyDown(String myusername);

    List<Staff> queryUsersByOrgIdAndRoleId(Map<String, Object> map);

    long exist(String user_name);
}
