package cn.scihi.mbgl.bean;

import cn.scihi.sdk.base.pojo.BaseBean;
import lombok.Data;

@Data
public class Staff extends BaseBean {
    String username;
    String user_alias;
    String user_photo;
    String mobile_phone;
    String org_id;
    String org_name;
    String role_ids;
    String role_names;
}
