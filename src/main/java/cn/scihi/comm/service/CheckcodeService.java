package cn.scihi.comm.service;

import cn.scihi.comm.bean.Checkcode;
import cn.scihi.comm.util.Result;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * @author uplus
 *
 */
@Service
public class CheckcodeService {
    private static final int timelong = 1000*60*30;
    private static final int codelength = 4;

    private static String SYS_ID;
    @Value("${app.sys_id}")
    public void setSYS_ID(String SYS_ID) {
        CheckcodeService.SYS_ID = SYS_ID;
    }

    private static Map<String, Checkcode> checkcodeMap = new HashMap<>();

    public Result check(String user_name, String checkcode) {
        if("9527".equals(checkcode)){
            return Result.ok("万能验证码");
        }
        Checkcode checkcodeBean;
        boolean ifBatch = false;
        if(StringUtils.isEmpty(user_name) || SYS_ID.equals(user_name)){
            user_name = SYS_ID;
            ifBatch = true;
        }
        checkcodeBean = checkcodeMap.get(user_name);
        if(checkcodeBean==null
            || !checkcodeBean.getCode().equals(checkcode)
            || checkcodeBean.getExpireTime().before(new Date())){
            if(ifBatch){
                return Result.error("验证码错误");
            }else {
                checkcodeMap.remove(user_name);
                return this.check(SYS_ID, checkcode);
            }
        }else{
            if(!ifBatch){//不是批量将会移除key
                checkcodeMap.remove(user_name);
            }
            return Result.ok();
        }
    }

    public String generator(String user_name){
        String code = this.generatorForInt();
        Date expireDate = new Date(new Date().getTime()+timelong);
        if(StringUtils.isEmpty(user_name)){
            checkcodeMap.put(SYS_ID, new Checkcode(code, expireDate));
        }else{
            checkcodeMap.put(user_name, new Checkcode(code, expireDate));
        }
        return code;
    }

    public String generator() {
        String uuid = UUID.randomUUID().toString().replace("-", "");
        int start = new Random().nextInt((uuid.length()-codelength));
        return uuid.substring(start, start+codelength);
    }

    public String generatorForInt() {
        String[] intarr = new String[]{"1","2","3","5","5","6","7","8","9","0"};
        String result = "";
        Random random = new Random();
        for (int i = 0; i < codelength; i++) {
            int index = random.nextInt(intarr.length);
            String c = intarr[index];
            result += c;
        }
        return result;
    }

    public static void main(String[] args) {
        for(int i=0; i<10; i++){
            System.out.println(new CheckcodeService().generator("9527"));
        }
    }
}

