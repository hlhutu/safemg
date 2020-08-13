package cn.scihi.comm.bean;

import cn.scihi.sdk.base.pojo.BaseBean;
import lombok.Data;

@Data
public class SysUser extends BaseBean {
    String id;
    String user_name;//账号
    String user_alias;//昵称
    String user_photo;
}
